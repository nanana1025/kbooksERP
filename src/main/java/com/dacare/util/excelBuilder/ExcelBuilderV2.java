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
import com.dacare.util.excelBuilder.internal.sheet.MergeCellsParser;
import com.dacare.util.excelBuilder.internal.sheet.SheetListBuilder;
import com.dacare.util.excelBuilder.internal.sheet.SheetMergeListBuilder;
import com.dacare.util.excelBuilder.internal.sheet.SheetViewBuilder;
import com.dacare.util.excelBuilder.internal.workbook.SheetInfo;
import com.dacare.util.excelBuilder.internal.workbook.WorkBookParser;
import com.dacare.util.excelBuilder.util.XlsxZipHelper;
import com.dacare.util.map.UMap;

/**
 * ExcelBuilderV2 (엑셀템플릿 기반 엑셀 파일생성기)
 *
 * <pre>
 *  ■ 설명
 *   - Excel로 직접 템플릿을 만들고, 변수를 지정하면 동적으로 데이터를 채워준다.
 *   - 기존에 POI 를 사용하여 스타일 정보등을 읽어서 직접 sheet.xml 을 생성하던 방식에서
 *     SAX 를 이용하여 직접 XML 을 읽고 변경하는 방식으로 처리하는 로직을 개편했다.
 *   - 처리하는 로직 내에서 POI 종속을 없앴다.
 *
 *  ■ 기능
 *   - ViewData(UMap) 및 ListData(List<UMap>) 형태의 데이터에 대해서 출력이 가능 (v2.0)
 *   - 시트에 정의되어 있는 병합셀에 대해서 추가되는 데이터에 상관없이 유지됨 (v2.0)
 *   - ListData의 대상 셀이 행병합일 경우에도 표현가능 (v2.0, setMergeListData 메소드 제공)
 *
 *  ■ 공지사항
 *   - [중요]수정사항이 있을 경우 필히 변경이력 남길 것!!
 *   - [개선예정] 엑셀내에 포함된 함수에 대해서도 자동으로 인덱스가 수정되도록 처리 (sum함수 같은 것)
 *   - [개선예정] 싸인이미지와 같이 지정된 이미지로 수정하는 API 추가 (반자동형태로;;)
 *
 *  ■ 변경이력
 *
 *  버전    변경일자    작업자      수정내용
 *  ----    --------    --------    -------------------------------------------
 *  v2.0    20190510	박주의		최초작성 (SAX 기반으로 처리)
 *  v2.1    20190524	박주의		kproject 에 배포
 *  v2.2	20190613	박주의		시트내에 머지된 열을 중복으로 조작할 때에 엉키는 버그 해결
 * </pre>
 *
 * @author 박주의
 * @version v2.0
 *
 */
public class ExcelBuilderV2 {

	// 파일관련 파라미터
	private File openFile;
	private File workFile;
	private File saveFile;

	// 시트정보
	private ArrayList<SheetInfo> sheetList;

	private int currentSheetIdx;

	// 공유스트링 정보
	private UMap viewKeyMap;
	private UMap listKeyMap;

	/**
	 * 파일명으로 지정
	 *
	 * @param templateFileName
	 * @param outFileName
	 * @throws IOException
	 */
	public ExcelBuilderV2(String templateFileName, String outFileName) throws IOException {
		this(new File(templateFileName), new File(outFileName));
	}

	/**
	 * 템프파일을 읽어서 작업용 임시파일을 생성한다.
	 *
	 * @param templateFile ; 템플릿 파일명
	 * @param outFile	; 생성될 파일명
	 * @throws IOException
	 */
	public ExcelBuilderV2(File templateFile, File outFile) throws IOException  {
		this.openFile = templateFile;
		this.saveFile = outFile;

		// 작업파일 생성
		String saveFileAbsolutePath = this.saveFile.getAbsolutePath();
		String saveFullPath = FilenameUtils.getFullPath(saveFileAbsolutePath);
		String saveFileName = FilenameUtils.getName(saveFileAbsolutePath);
		this.workFile = new File(saveFullPath.concat("temp_").concat(saveFileName));
		FileUtils.copyFile(this.openFile, this.workFile);

		// 시트정보 추출
		WorkBookParser wbParser = new WorkBookParser(this.workFile);
		sheetList = wbParser.getSheetList();
		currentSheetIdx = -1;

		// 공유스트링 추출
		SharedStringsParser ssParser = new SharedStringsParser(this.workFile, true);
		viewKeyMap = ssParser.getViewMap();
		listKeyMap = ssParser.getListMap();
	}

	/**
	 * 시트정보 리스트를 출력
	 *
	 * @return ArrayList<SheetInfo>
	 */
	public ArrayList<SheetInfo> getSheetList() {
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
	 * 시트순번으로 작업 시작 시트를 지정 및 시트의 병합셀 정보를 추출
	 *
	 * @param sheetIdx ; 시트 객체의 순번으로 0부터 시작
	 * @throws IOException
	 */
	public void beginSheet(int sheetIdx) throws IOException {
		beginSheet(sheetList.get(sheetIdx));
	}

	/**
	 * 시트객체로 작업 시작 시트를 지정 및 시트의 병합셀 정보를 추출
	 *
	 * @param si ; 시트객체 (ExcelBuilderV2 객체 생성 후 생성됨)
	 * @throws IOException
	 */
	public void beginSheet(SheetInfo si) throws IOException {
		// 시트파일 생성
		String sheetAbsolutePath = si.getSheetRef();
		String sheetFileBaseName = FilenameUtils.getBaseName(sheetAbsolutePath);
		si.setTempXmlFile(File.createTempFile(sheetFileBaseName, ".xml"));
		XlsxZipHelper.extractEntry(this.workFile, si.getTempXmlFile(), si.getSheetRef());

		// 현재 작업할 시트의 인덱스를 지정
		currentSheetIdx = si.getSheetIdx();

		// 현재 작업할 시트의 병합셀 정보를 추출
		MergeCellsParser mcParser = new MergeCellsParser(si.getTempXmlFile(), listKeyMap);
		si.setMergeMap(mcParser.getMergeCellsSpanMap());

		// 현재 작업중인 엑셀파일 셋팅
		si.setWorkExcelFile(this.workFile);
	}

	/**
	 * view 형태의 데이터를 매핑 ${view.data1}
	 *
	 * @param viewData ; UMap 형태의 viewData
	 * @param prefix ; 시트내에서 데이터의 구분을 위한 접두사
	 * @throws IOException
	 */
	public void setViewData(UMap viewData, String prefix) throws IOException {
		File sheetXmlFile = sheetList.get(currentSheetIdx).getTempXmlFile();
		SheetViewBuilder sParser = new SheetViewBuilder(sheetXmlFile, viewKeyMap, prefix, viewData);
		File sheetXmlResultFile = sParser.getResultFile();
		FileUtils.copyFile(sheetXmlResultFile, sheetXmlFile);
		FileUtils.deleteQuietly(sheetXmlResultFile);
		//FileUtils.copyFile(sheetXmlFile, File.createTempFile("view", ".xml", new File("d:/test")));
	}

	/**
	 * list 형태의 데이터를 매핑 $[list.data2]
	 *
	 * @param listData ; List<UMap> 형티의 listData
	 * @param prefix ; 시트내에서 데이터의 구분을 위한 접두사
	 * @throws IOException
	 */
	public void setListData(List<UMap> listData, String prefix) throws IOException {
		SheetInfo si = sheetList.get(currentSheetIdx);
		SheetListBuilder sParser = new SheetListBuilder(si, listKeyMap, prefix, new DefaultEdsArrayList(listData));
		File sheetXmlResultFile = sParser.getResultFile();

		File sheetXmlFile = si.getTempXmlFile();
		FileUtils.copyFile(sheetXmlResultFile, sheetXmlFile);
		FileUtils.deleteQuietly(sheetXmlResultFile);
		//FileUtils.copyFile(sheetXmlFile, File.createTempFile("list", ".xml", new File("d:/test")));
	}

	/**
	 * list 형태의 데이터를 매핑 $[list.data2]
	 *
	 * @param listData ; List<UMap> 형티의 listData
	 * @param prefix ; 시트내에서 데이터의 구분을 위한 접두사
	 * @throws IOException
	 */
	public void setListData(EbDataSet ds, String prefix) throws IOException {
		SheetInfo si = sheetList.get(currentSheetIdx);
		SheetListBuilder sParser = new SheetListBuilder(si, listKeyMap, prefix, ds);
		File sheetXmlResultFile = sParser.getResultFile();

		File sheetXmlFile = si.getTempXmlFile();
		FileUtils.copyFile(sheetXmlResultFile, sheetXmlFile);
		FileUtils.deleteQuietly(sheetXmlResultFile);
		//FileUtils.copyFile(sheetXmlFile, File.createTempFile("list", ".xml", new File("d:/test")));
	}

	/**
	 * 행병합 list 형태의 데이터를 매핑 $[mgList.data3]
	 *
	 * @param listData ; List<UMap> 형티의 listData
	 * @param prefix ; 시트내에서 데이터의 구분을 위한 접두사
	 * @throws IOException
	 */
	public void setMergeListData(List<UMap> listData, String prefix) throws IOException {
		SheetInfo si = sheetList.get(currentSheetIdx);
		SheetMergeListBuilder sParser = new SheetMergeListBuilder(si, listKeyMap, prefix, new DefaultEdsArrayList(listData));
		File sheetXmlResultFile = sParser.getResultFile();

		File sheetXmlFile = si.getTempXmlFile();
		FileUtils.copyFile(sheetXmlResultFile, sheetXmlFile);
		FileUtils.deleteQuietly(sheetXmlResultFile);
		//FileUtils.copyFile(sheetXmlFile, File.createTempFile("merge", ".xml", new File("d:/test")));
	}

	/**
	 * 행병합 list 형태의 데이터를 매핑 $[mgList.data3]
	 *
	 * @param listData ; List<UMap> 형티의 listData
	 * @param prefix ; 시트내에서 데이터의 구분을 위한 접두사
	 * @throws IOException
	 */
	public void setMergeListData(EbDataSet ds, String prefix) throws IOException {
		SheetInfo si = sheetList.get(currentSheetIdx);
		SheetMergeListBuilder sParser = new SheetMergeListBuilder(si, listKeyMap, prefix, ds);
		File sheetXmlResultFile = sParser.getResultFile();

		File sheetXmlFile = si.getTempXmlFile();
		FileUtils.copyFile(sheetXmlResultFile, sheetXmlFile);
		FileUtils.deleteQuietly(sheetXmlResultFile);
		//FileUtils.copyFile(sheetXmlFile, File.createTempFile("merge", ".xml", new File("d:/test")));
	}

	/**
	 * 결과파일을 저장하고 작업을 종료
	 *
	 * @throws ZipException
	 * @throws IOException I/O 예외
	 */
	public void finish() throws FileNotFoundException, IOException {
		XlsxZipHelper.updateEntry(this.workFile, this.saveFile, this.sheetList);
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

		// 테스트용 view 데이터 준비
//		Gson gson = new Gson();
//		String viewJson = "{TEST_NAME:'2', TEST_DT:'2019-04-26', MONTH:'2&3'}";
//      Type modelType1 = new TypeToken<UMap>() {}.getType();
//      UMap viewMap = gson.fromJson(viewJson, modelType1);
        UMap viewMap = new UMap();
        viewMap.put("TEST_NAME", "2");
        viewMap.put("TEST_DT", "2019-04-26");
        viewMap.put("MONTH", "2&3");

		// 테스트용 list1 데이터 준비
        ArrayList<UMap> failList = new ArrayList<UMap>();
        for(int i = 0 ; i < 10 ; i++ ) {
        	UMap m = new UMap();
        	m.put("SEQ", i);
        	m.put("ERN", "A20190426"+(i%10));
        	m.put("FAIL_MNO", String.format("FI2019%05d", i));
        	m.put("FAIL_ITEM", "테스트장비"+(i%5));
        	m.put("FAIL_NIIN", 987654321+(i%5));
        	failList.add(m);
        }

		// 테스트용 list2 데이터 준비
        ArrayList<UMap> mntList = new ArrayList<UMap>();
        for(int i = 0 ; i < 5; i++ ) {
        	UMap m = new UMap();
        	m.put("SEQ", i);
        	m.put("ERN", "A&20190426"+(i%10));
        	m.put("MNT_MNO", String.format("MT2019%05d", i));
        	mntList.add(m);
        }

        ArrayList<UMap> bList = new ArrayList<UMap>();
        for(int i = 0 ; i < 10; i++ ) {
        	UMap m = new UMap();
        	m.put("BLANK", "");
        	bList.add(m);
        }

     // 여러건 데이터
	  DefaultEdsArrayList ds = new DefaultEdsArrayList(mntList) {
			@Override
			public int getDataSetCount() {
				return mntList.size() * 2;
			}

			@Override
			public int getMaxPage() {
				return 2;
			}

			@Override
			public List<UMap> getListByPage(int page) {
				return mntList;
			}
		};

        // excel 생성 테스트 시작
		long sTime = System.currentTimeMillis();
		String outFilePath = "d:/test/testResult2.xlsx";
		System.out.println("workStart : " + outFilePath);
		ExcelBuilderV2 excel = new ExcelBuilderV2("d:/test/testSample2.xlsx", outFilePath);
		for(SheetInfo si : excel.sheetList) {
			// 시트 시작
			excel.beginSheet(si);

			//System.out.println(si.getTempXmlFile());

			// 단건 데이터
			excel.setViewData(viewMap, "view");

			if (si.getSheetName().equals("고장이력")) {
				// 여러건 데이터
				excel.setListData(failList, "fList");

				// 여러건 데이터
				excel.setMergeListData(ds, "mList");

				// 공백처리용
				excel.setListData(bList, "bList");
				excel.setListData(bList, "cList");
			}
			else {
				excel.setListData(ds, "mList");
			}
		}

		// 결과파일 생성
		excel.finish();

		System.out.println("workTime : "+ (System.currentTimeMillis()-sTime));
	}

}
