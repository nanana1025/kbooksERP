package com.dacare.util.excelBuilder;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipException;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;

import com.dacare.util.excelBuilder.data.DefaultEdsArrayList;
import com.dacare.util.excelBuilder.data.EbDataSet;
import com.dacare.util.excelBuilder.internal.sharedStrings.SharedStringsParser;
import com.dacare.util.excelBuilder.internal.sheet.DimensionParser;
import com.dacare.util.excelBuilder.internal.sheet.SheetListBuilder;
import com.dacare.util.excelBuilder.internal.sheet.SheetMergeListBuilder;
import com.dacare.util.excelBuilder.internal.sheet.SheetParser;
import com.dacare.util.excelBuilder.internal.sheet.SheetViewBuilder;
import com.dacare.util.excelBuilder.internal.styles.StyleInfo;
import com.dacare.util.excelBuilder.internal.styles.StylesParser;
import com.dacare.util.excelBuilder.internal.workbook.SheetInfo;
import com.dacare.util.excelBuilder.internal.workbook.WorkBookParser;
import com.dacare.util.excelBuilder.util.XlsxParserHelper;
import com.dacare.util.excelBuilder.util.XlsxZipHelper;
import com.dacare.util.map.UMap;

/**
 * ExcelReader (xlsx 형태의 엑셀파일의 데이터를 읽기)
 *
 * <pre>
 *  ■ 설명
 *   - 기존에 POI 를 사용하여 데이터를 읽는 방식에서 직접 sheet.xml 파일을 추출하고
 *     SAX 를 이용하여 직접 XML 을 읽어서 데이터를 가져오는 방식으로 처리하는 로직을 개편했다.
 *   - 처리하는 로직 내에서 POI 종속을 없앰.
 *   - 대용량 엑셀파일을 읽을 때에도 페이징방식으로 분할해서 읽을 수 있도록 처리함.
 *
 *  ■ 기능
 *   - 데이터를 읽을 범위를 지정하면 해당 되는 범위 내의 데이터만 읽어들임. (지정되지 않으면 전체 읽기)
 *   - List<UMap> 형태로 데이터를 반환한다. 열데이터는 UMap 형태로 하고 행데이터는 List형태로 구성
 *   - 제목열을 지정하면 해당 되는 제목열을 KEY값으로 하는 UMap 생성. (지정하지 않으면 시트의 칼럼문자로 생성)
 *
 *  ■ 공지사항
 *   - [중요]수정사항이 있을 경우 필히 변경이력 남길 것!!
 *
 *  ■ 변경이력
 *
 *  버전    변경일자    작업자      수정내용
 *  ----    --------    --------    -------------------------------------------
 *  v2.0    20190603	박주의		최초작성 (SAX 기반으로 처리)
 *
 * </pre>
 *
 * @author 박주의
 * @version v2.0
 *
 */
public class ExcelReader {
	// 파일관련 파라미터
	private File openFile;

	// 시트정보
	private List<SheetInfo> sheetList;
	private int currentSheetIdx;

	// 공유스트링 정보
	private List<String> siList;

	// 스타일정보
	private List<StyleInfo> xfList;

	/**
	 * 파일명으로 지정
	 *
	 * @param templateFileName
	 * @param outFileName
	 * @throws IOException
	 */
	public ExcelReader(String readFileName) throws IOException {
		this(new File(readFileName));
	}

	/**
	 * 템프파일을 읽어서 작업용 임시파일을 생성한다.
	 *
	 * @param templateFile ; 템플릿 파일명
	 * @param outFile	; 생성될 파일명
	 * @throws IOException
	 */
	public ExcelReader(File readFile) throws IOException  {
		this.openFile = readFile;

		// 시트정보 추출
		WorkBookParser wbParser = new WorkBookParser(this.openFile);
		sheetList = wbParser.getSheetList();
		currentSheetIdx = -1;

		// 공유스트링 추출
		SharedStringsParser ssParser = new SharedStringsParser(this.openFile, false);
		siList = ssParser.getSiList();

		// 스타일정보 추출
		StylesParser syParser = new StylesParser(this.openFile);
		xfList = syParser.getStyleList();
	}

	/**
	 * 시트정보 리스트를 출력
	 *
	 * @return ArrayList<SheetInfo>
	 */
	public List<SheetInfo> getSheetList() {
		return sheetList;
	}

	/**
	 * 시트정보의 갯수를 출력
	 *
	 * @return int
	 */
	public int getSheetCount() {
		return sheetList.size();
	}

	/**
	 * 시트 인덱스를 받으면 시트정보를 출력
	 *
	 * @param idx ; 시트 순번으로 0부터 시작
	 * @return SheetInfo
	 */
	public SheetInfo getSheetInfo(int idx) {
		return sheetList.get(idx);
	}

	/**
	 * 시트객체로 작업 시작 시트를 지정
	 *
	 * @param sheetIdx ; 시트 객체의 순번으로 0부터 시작
	 * @throws IOException
	 */
	public void openSheetAll(int sheetIdx) throws IOException {
		openSheetAll(sheetList.get(sheetIdx));
	}

	/**
	 * 시트객체로 작업 시작 시트를 지정
	 *
	 * @param si ; 시트객체 (ExcelReader 객체 생성 후 생성됨)
	 * @throws IOException
	 */
	public void openSheetAll(SheetInfo si) throws IOException {
		// 시트파일 생성
		String sheetAbsolutePath = si.getSheetRef();
		String sheetFileBaseName = FilenameUtils.getBaseName(sheetAbsolutePath);
		si.setTempXmlFile(File.createTempFile(sheetFileBaseName, ".xml"));
		System.out.println(si.getTempXmlFile());
		XlsxZipHelper.extractEntry(this.openFile, si.getTempXmlFile(), si.getSheetRef());

		// 현재 작업할 시트의 인덱스를 지정
		currentSheetIdx = si.getSheetIdx();

		// 현재 작업중인 엑셀파일 셋팅
		si.setWorkExcelFile(this.openFile);

		// 시트의 dimension 정보를 검색
		new DimensionParser(si);

		// default 셋팅
		si.setBufferSize(10);
		si.setRangeBeginCellStr(si.getSheetBeginCellStr());
		si.setRangeEndCellStr(si.getSheetEndCellStr());
	}

	/**
	 * 시트객체로 작업 시작 시트를 지정 및 제목행을 지정
	 *
	 * @param si ; 시트객체 (ExcelReader 객체 생성 후 생성됨)
	 * @param titleRowIndex ; 제목정보로 읽어들일 행index 를 입력
	 * @throws IOException
	 */
	public void openSheetAll(SheetInfo si, boolean useTitle) throws IOException {
		openSheetAll(si);

		// TODO : 제목행 설정 추가 필요 (박주의)
	}

	/**
	 * 시트객체로 작업 시작 시트를 지정 및 시트를 읽을 범위를 지정
	 *
	 * @param si
	 * @param beginCellStr
	 * @param endCellStr
	 * @throws IOException
	 */
	public void openSheetRange(SheetInfo si, String beginCellStr, String endCellStr) throws IOException {
		openSheetRange(si, beginCellStr, endCellStr, true);
	}

	/**
	 * 시트객체로 작업 시작 시트를 지정 및 시트를 읽을 범위 와 제목행을 지정
	 *
	 * @param si
	 * @param beginCellStr
	 * @param endCellStr
	 * @param useTitle ; 첫행을 제목열로 사용할지 여부 결정, false 일 경우에는 ColString 을 열명으로 사용
	 * @throws IOException
	 */
	public void openSheetRange(SheetInfo si, String beginCellStr, String endCellStr, boolean useTitle) throws IOException {
		openSheetAll(si);

		//TODO 2019-06-13 최대값과 영역값간에 범위 확인

		//영역값 설정
		si.setRangeBeginCellStr(beginCellStr);
		si.setRangeEndCellStr(endCellStr);
	}

	/**
	 * 현재 열린 시트 정보를 한번에 읽어들이는 메소드
	 *
	 * @return
	 * @throws IOException
	 */
	public List<UMap> read() throws IOException {
		SheetInfo si = sheetList.get(currentSheetIdx);
		File sheetWorkFile = si.getWorkExcelFile();
		SheetParser sParser = new SheetParser(sheetWorkFile, si, siList, xfList);
		return sParser.getRowList();
	}

	/**
	 * 현재 열린 시트 정보를 한번에 읽어들이는 메소드
	 *
	 * @return
	 * @throws IOException
	 */
	public List<UMap> read(int pageNo) throws IOException {
		SheetInfo si = sheetList.get(currentSheetIdx);
		File sheetWorkFile = si.getWorkExcelFile();
		SheetParser sParser = new SheetParser(sheetWorkFile, si, siList, xfList, pageNo);
		return sParser.getRowList();
	}

	/**
	 * 시트를 읽기 위한 temp파일을 정리하고, 기타 설정값들을 초기화
	 *
	 * @throws ZipException
	 * @throws IOException I/O 예외
	 */
	public void close() throws FileNotFoundException, IOException {
		XlsxZipHelper.clearTempEntry(sheetList);
	}

	/**
	 * 엑셀빌드 테스트 (엑셀빌더 사용예제)
	 *
	 *  <pre>
	 *   ■ 사용법
	 *    - 첨부된 testSample.xlsx 파일을 d:/test/testSample.xlsx 경로로 복사후 main 메소드 실행
	 *
	 *  </pre>
	 *
	 * @param args
	 * @throws IOException
	 */
	public static void main(String[] args) throws IOException {

        // excel 생성 테스트 시작
		long sTime = System.currentTimeMillis();

		ExcelReader excel = new ExcelReader("d:/test/testResult2.xlsx");
		SheetInfo si = excel.getSheetInfo(0);
		//excel.openSheetAll(si);
		excel.openSheetRange(si, "C3", "Q21");
		si.setBufferSize(5);

		System.out.println("###작업시작###");
		int rowNo = 1;
		for(int pi = 1 ; pi <= si.getMaxPage() ; pi++) {
			List<UMap> rowList = excel.read(pi);
			for(int i = 0 ; i < rowList.size() ; i++) {
				System.out.print(String.format("%d>", rowNo));
				System.out.println(rowList.get(i));
				rowNo++;
			}
		}
		System.out.println("###작업종료###");

		// 읽기 종료
		excel.close();

		System.out.println("workTime : "+ (System.currentTimeMillis()-sTime));

		/*
		for(SheetInfo si : excel.sheetList) {

			//System.out.println(siList);

			// openSheet 타입1
			//excel.openSheetAll(si);

			// openSheet 타입2 (제목행)
			//excel.openSheetAll(si, 2);

			// openSheet 타입3 (범위)
			//excel.openSheetRange(si, "시작위치", "종료위치");

			// openSheet 타입4 (범위, 제목행)
			excel.openSheetRange(si, "시작", "종료");

			// readData 타입1 (openSheet 를 먼저 해야함, 안하면 오류)
			//List<UMap> failList = excel.read();

			// readData 타입2 (openSheet 를 먼저 해야함, 안하면 오류)
			excel.setBufferSize(5);
			List<UMap> failList2 = excel.read(3);

			// work코드 failList 가지고 어쩌구 저쩌구~~~~

			break;
		}
		*/
	}

}
