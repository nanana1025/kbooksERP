package kbookERP.util.excelBuilder.internal.sheet;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.text.StringEscapeUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import kbookERP.util.excelBuilder.internal.styles.StyleInfo;
import kbookERP.util.excelBuilder.internal.workbook.SheetInfo;
import kbookERP.util.excelBuilder.util.XlsxParserHelper;
import kbookERP.util.excelBuilder.util.XlsxZipHelper;
import kbookERP.util.map.UMap;
import kbookERP.util.sax.SAXHelper;


/**
 * sheet.xml 파일 파싱 후 row 데이터를 읽음
 *
 * @author 박주의
 */
public class SheetParser extends DefaultHandler {

	private static final Pattern CELL_REF_PATTERN = Pattern.compile("([A-Z]+)([0-9]+):([A-Z]+)([0-9]+)", Pattern.CASE_INSENSITIVE);
	private static final Pattern CELL_IDX_PATTERN = Pattern.compile("([A-Z]+)([0-9]+)", Pattern.CASE_INSENSITIVE);

	// 파라미터 멤버
	private SheetInfo sheet;
	private List<StyleInfo> xfList;
	private List<String> siList;

	// 처리에 필요한 멤버들
	private int pageNo;
	private List<UMap> rowList;
	private UMap rowMap;
	private int rowStart;
	private int rowEnd;
	private int rowIdx;
	private String colStart;
	private String colEnd;

	// xml 및 tag, value 저장용 버퍼
	private boolean onTagRow;
	private boolean onTagC;
	private boolean isDateType;
	private boolean isNumber;
	private String onCellStr;
	private StringBuffer valBuffer;

	/**
	 *  엑셀파일에서 sheet.xml 파일을 추출 파싱해서 데이터맵을 생성
	 *
	 *  사용예)
	 * 	SheetParser parser = new SheetParser(tempXmlFile, si);
		UMap data = parser.getData();
	 *
	 * @param workFile
	 * @param si
	 * @param pageNo2
	 * @param siList
	 * @throws IOException
	 */
	public SheetParser(File workFile, SheetInfo si, List<String> siList, List<StyleInfo> xfList) throws IOException {
		this(workFile, si, siList, xfList, -1);
	}

	/**
	 *  엑셀파일에서 sheet.xml 파일을 추출 파싱해서 데이터맵을 생성
	 *
	 *  사용예)
	 * 	SheetParser parser = new SheetParser(tempXmlFile, si);
		UMap data = parser.getData();
	 *
	 * @param workFile
	 * @param si
	 * @throws IOException
	 */
	public SheetParser(File workFile, SheetInfo si, List<String> siList, List<StyleInfo> xfList, int pageNo) throws IOException {
		rowList = new ArrayList<UMap>();
		rowMap = null;
		onCellStr = null;
		valBuffer = new StringBuffer();

		this.sheet = si;
		this.siList = siList;
		this.xfList = xfList;
		this.pageNo = pageNo;

		this.rowStart = XlsxParserHelper.getCellRowIndex(si.getRangeBeginCellStr());
		this.rowEnd = XlsxParserHelper.getCellRowIndex(si.getRangeEndCellStr());
		this.colStart = XlsxParserHelper.getCellColString(si.getRangeBeginCellStr());
		this.colEnd = XlsxParserHelper.getCellColString(si.getRangeEndCellStr());

		String sheetAbsolutePath = si.getSheetRef();
		String sheetFileBaseName = FilenameUtils.getBaseName(sheetAbsolutePath);

		// 작업을 위한 시트파일이 추출된게 없을 경우에는 신규로 추출
		if (si.getTempXmlFile() == null) {
			si.setTempXmlFile(File.createTempFile(sheetFileBaseName, ".xml"));
			XlsxZipHelper.extractEntry(workFile, si.getTempXmlFile(), si.getSheetRef());
		}
		SAXHelper.parseXml(si.getTempXmlFile(), this);
	}

	/**
	 * 추출한 결과값을 반환한다.
	 *
	 * @return
	 */
	public List<UMap> getRowList() {
		return rowList;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if ("row".equalsIgnoreCase(qName)) {
			rowIdx = NumberUtils.toInt(attributes.getValue("r"));
			if (rowIdx >= rowStart + ((pageNo-1) * sheet.getBufferSize())) {
				if (rowIdx <= rowEnd && rowIdx < rowStart + ((pageNo) * sheet.getBufferSize())) {
					onTagRow = true;
				}
				else {
					throw new SAXException("ParsedComplete");
				}
			}
			else {
				onTagRow = false;
			}
			rowMap = new UMap();
			onTagC = false;
		}
		else if (onTagRow && "c".equalsIgnoreCase(qName)) {
			//System.out.print("c="+attributes.getValue("r")+" ");
			isDateType = false;
			isNumber = false;

			onCellStr = attributes.getValue("r");
			String colStr = XlsxParserHelper.getCellColString(onCellStr);
			boolean flag = colStr.compareTo(colStart) >= 0;
			if (flag) {
				flag = colStr.compareTo(colEnd) <= 0;
				if (flag) {
					onTagC = true;
				}

				// 날짜타입여부
				int styleNo = NumberUtils.toInt(attributes.getValue("s"));
				isDateType = xfList.get(styleNo).isDateType();

				// 숫자타입여부
				String tAttr = attributes.getValue("t");
				if (tAttr == null) {
					isNumber = true;
				}
			}
			valBuffer.setLength(0);
		}

	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		if (onTagRow && "row".equalsIgnoreCase(qName)) {
			if (onTagRow) {
				rowList.add(rowMap);
				//System.out.println("#"+this.rowIdx);
			}
		}

		if (onTagRow && onTagC && "v".equalsIgnoreCase(qName)) {
			String val = null;
			if (isNumber) {
				if (isDateType) {
					val = XlsxParserHelper.convertDateTypeCellNumberToString(valBuffer.toString());
				}
				else {
					val = valBuffer.toString();
				}
			}
			else {
				if (isDateType) {
					val = XlsxParserHelper.convertDateTypeCellNumberToString(valBuffer.toString());
				}
				else {
					int siNo = NumberUtils.toInt(valBuffer.toString());
					val = siList.get(siNo);
				}
			}
			rowMap.put(onCellStr, val);
		}
	}

	@Override
	public void characters(char[] ch, int start, int length) throws SAXException {
		String charData = (new String(ch, start, length));
		charData = StringEscapeUtils.unescapeXml(charData);
		charData = StringEscapeUtils.escapeXml10(charData);
		valBuffer.append(charData);
	}
}
