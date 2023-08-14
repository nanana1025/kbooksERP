package kbookERP.util.excelBuilder.internal.sheet;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.text.StringEscapeUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import kbookERP.util.excelBuilder.data.EbDataSet;
import kbookERP.util.excelBuilder.internal.workbook.SheetInfo;
import kbookERP.util.excelBuilder.util.XlsxParserHelper;
import kbookERP.util.map.UMap;
import kbookERP.util.sax.SAXHelper;


/**
 * sheet.xml 파일 템플릿을 이용해서 list 데이터 삽입
 *
 * <pre>
 *  ■ 변경이력
 *
 *  버전    변경일자    작업자      수정내용
 *  ----    --------    --------    -------------------------------------------
 *  v2.0    20190510	박주의		최초작성 (SAX 기반으로 처리)
 *  v2.1    20190523	박주의		페이징 SQL을 사용할 수 있도록 EbDataSet 로 데이터 받게 수정
 *	v2.2	20190613	박주의		시트내에 머지된 열을 중복으로 조작할 때에 엉키는 버그 해결
 *
 * </pre>
 *
 * @author 박주의
 * @version v2.1
 *
 * */
public class SheetListBuilder extends DefaultHandler {
	private static final Pattern ROW_R_ATTR_PATTERN = Pattern.compile("<row r=\"([0-9]+)\"", Pattern.CASE_INSENSITIVE);
	private static final Pattern CELL_R_ATTR_PATTERN = Pattern.compile("<c r=\"([A-Z]+)([0-9]+)\"", Pattern.CASE_INSENSITIVE);
	private static final Pattern LIST_KEY_PATTERN = Pattern.compile("\\$\\[(\\w+)\\.(\\w+)\\]", Pattern.CASE_INSENSITIVE);
	private static final Pattern MERGECELLS_COUNT_PATTERN = Pattern.compile("count=\"([0-9]+)\"", Pattern.CASE_INSENSITIVE);
	private static final Pattern MERGECELL_REF_PATTERN = Pattern.compile("<mergeCell ref=\"([A-Z]+)([0-9]+):([A-Z]+)([0-9]+)\"/>", Pattern.CASE_INSENSITIVE);
	private static final Pattern CELL_KEY_PATTERN = Pattern.compile("([A-Z]+)([0-9]+)", Pattern.CASE_INSENSITIVE);

	private static final String FIRST_ROW_PATTERN = "<row r=\"";
	private static final String LAST_CELL_ID_PATTERN = "<c r=\"";
	private static final String AS_CELL_TYPE_PATTERN = "t=\"s\"";
	private static final String TO_CELL_TYPE_PATTERN = "t=\"inlineStr\"";
	private static final String AS_VALUE_TAG_PATTERN = "<v>";
	private static final String TO_VALUE_TAG_PATTERN = "<is><t>";

	// 파라미터 멤버
	private SheetInfo si;
	private UMap keyMap;
	private String keyPrefix;
	private EbDataSet eds;

	// 처리에 필요한 멤버들
	private Writer fw;
	private File workXmlFile;
	private int _endRowPos;
	private int _rowNo;
	private boolean _existRowValKey;
	private int _listAddRowSize;
	private int _listAddRowPos;

	// xml 및 tag, value 저장용 버퍼
	public StringBuffer xmlBuffer;
	private StringBuffer tagBuffer;
	private StringBuffer valBuffer;

	/**
	 *  엑셀파일에서 sheet.xml 파일을 추출 파싱해서 데이터맵을 생성
	 *
	 *  사용예)
	 * 	SheetListBuilder parser = new SheetListBuilder(sheetInfo.getTemlXmlFile());
		File xmlFile = parser.getResultFile();
	 *
	 * @param workXmlFile
	 * @throws IOException
	 */
	public SheetListBuilder(SheetInfo sheet, UMap listKey, String prefix, EbDataSet ds) throws IOException {
		// 파라미터 값 매핑
		this.si = sheet;
		this.keyMap = listKey;
		this.keyPrefix= prefix;
		this.eds = ds;

		// 시트파싱을 위한 기본값 셋팅
		xmlBuffer = new StringBuffer();
		tagBuffer = new StringBuffer();
		valBuffer = new StringBuffer();
		this.workXmlFile = File.createTempFile("list", ".xml");
		this.fw = new OutputStreamWriter(new FileOutputStream(workXmlFile), "UTF-8");
		this._endRowPos = 0;
		this._rowNo = 0;
		this._existRowValKey = false;
		this._listAddRowSize = 0;
		this._listAddRowPos = 0;

		// 파싱시작
		SAXHelper.parseXml(si.getTempXmlFile(), this);

		// drawRef 추출
		SheetRelsParser.findRelDrawRef(sheet);

		// 시트내에 관련 그림이 있을 경우 파싱 후 xml 의 행번호를 밀어준다.
		@SuppressWarnings("unused")
		DrawingBuilder drawParser = new DrawingBuilder(si, _listAddRowPos, _listAddRowSize);
	}

	/**
	 * 시트 정보 매핑
	 * @param sheet
	 */
	public void setSheetInfo(SheetInfo sheet) {
		this.si  = sheet;
	}

	/**
	 * 결과파일 출력
	 * @return
	 */
	public File getResultFile() {
		return workXmlFile;
	}

	@Override
	public void startDocument() throws SAXException {
		xmlBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\r\n");
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if ("row".equalsIgnoreCase(qName)) {
			_existRowValKey = false;
		}

		xmlBuffer.append("<").append(qName);
		for(int i=0 ; i < attributes.getLength() ; i++) {
			String attrNm = attributes.getQName(i);
			String attrVal = attributes.getValue(i);
			if ("row".equalsIgnoreCase(qName) && "r".equalsIgnoreCase(attrNm)) {
				_rowNo = NumberUtils.toInt(attrVal);
			}
			else if ("drawing".equalsIgnoreCase(qName) && "r:id".equalsIgnoreCase(attrNm)) {
				si.setRelDrawId(attrVal);
			}

			xmlBuffer.append(" ").append(attrNm);
			xmlBuffer.append("=\"").append(attrVal).append("\"");
		}
		xmlBuffer.append(">");

		tagBuffer.setLength(0);
		tagBuffer.append(qName);
		valBuffer.setLength(0);
	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		/////// [0] value 의 값을 추가하는 부분 시작 -------------------------
		String charData = valBuffer.toString();
		int charLen = charData.trim().length();
		boolean isInlineStr = false;
		if ("v".equalsIgnoreCase(qName)) {
			int chkCellAttrTPos = xmlBuffer.indexOf(AS_CELL_TYPE_PATTERN, xmlBuffer.lastIndexOf(LAST_CELL_ID_PATTERN));
			if (charLen > 0 && chkCellAttrTPos > -1 && this.keyMap.containsKey(charData)) {
				// $[key] 값으로 일단 변경
				String valKeyStr = this.keyMap.getStr(charData);
				if (valKeyStr.startsWith(String.format("$[%s.", keyPrefix))) {
					charData = valKeyStr;

					// 마지막 셀의 id 값을 찾기
					int cellBeginPos = xmlBuffer.lastIndexOf(LAST_CELL_ID_PATTERN);
					Matcher matCell = CELL_R_ATTR_PATTERN.matcher(xmlBuffer.toString());
					if (matCell.find(cellBeginPos)) {
						String cr = String.format("%s%s", matCell.group(1), matCell.group(2));
						UMap mcSpanMap = si.getMergeMap();
						mcSpanMap.remove(cr);
					}

					// t="s" --> t="inlineStr" 로 변경
					SAXHelper.replaceLast(xmlBuffer, AS_CELL_TYPE_PATTERN, TO_CELL_TYPE_PATTERN);

					// <v> --> <is><t> 로 변경
					SAXHelper.replaceLast(xmlBuffer, AS_VALUE_TAG_PATTERN, TO_VALUE_TAG_PATTERN);

					isInlineStr = true;		// inlineStr 변환처리 여부체크
					_existRowValKey = true;// $[key] 값으로 변경한 데이터가 있는지 체크
				}
			}
		}
		xmlBuffer.append(charData);
		valBuffer.setLength(0);
		/////// [0] value 의 값을 추가하는 부분 종료 -------------------------

		/////// [1] 닫는 태그 처리 부분 시작 ---------------------------------
		if (charLen == 0 && tagBuffer.toString().equals(qName)) {
			// 마지막 문자가 space 일 경우
			if (xmlBuffer.charAt(xmlBuffer.length()-1) == 32) {
				xmlBuffer.delete(xmlBuffer.length()-1, xmlBuffer.length());
			}
			xmlBuffer.insert(xmlBuffer.length()-1, "/");
		}
		else {
			if (isInlineStr) {
				xmlBuffer.append("</t></is>");
			}
			else {
				xmlBuffer.append("</").append(qName).append(">");
			}
		}
		/////// [1] 닫는 태그 처리 부분 종료 ---------------------------------

		if ("row".equalsIgnoreCase(qName)) {
			/////// [3-1] <row>열 처리 부분 시작 ---------------------------------
			_endRowPos = xmlBuffer.length();

			// <row> 자식에 $[key] 요소가 있었다면 행을 복사 (list 의 갯수만큼)
			int beginRowPos = xmlBuffer.indexOf(FIRST_ROW_PATTERN);
			String rowStr = xmlBuffer.substring(beginRowPos, _endRowPos);
			if (_existRowValKey) {

				xmlBuffer.delete(beginRowPos, _endRowPos);

				if (eds.getDataSetCount() > 0) {
					// 행추가
					for(int page = 1 ; page <= eds.getMaxPage() ; page++) {
						List<UMap> dataList = eds.getListByPage(page);
						for(int i = 0 ; i < dataList.size() ; i++) {
							UMap data = dataList.get(i);
							fillDataByListKey(rowStr, data);
							writeXmlBuffer(qName);
							_listAddRowSize++;
						}
					}

					_listAddRowSize--;	/*데이터행이 2개일 때 신규 추가행은 1개임*/
				}
				else {
					// 데이터가 비어있을 경우에는 블랭크로 채움
					fillDataByListKey(rowStr, null);
					writeXmlBuffer(qName);
				}

				_listAddRowPos = _rowNo;	// 행추가를 시작한 행번호를 저장

			}
			else {
				// 행넘버 리넘버링 처리 (태그내의 값 중에서 row 값을 증가)
				if (_listAddRowSize > 0) {
					StringBuffer reorderSb = new StringBuffer(rowStr);
					xmlBuffer.delete(beginRowPos, _endRowPos);
					reorderingRow(reorderSb, _listAddRowSize);
					xmlBuffer.append(reorderSb);
				}
			}
		}

		else if ("mergeCells".equalsIgnoreCase(qName)) {
			/////// [3-2] <mergeCells> 태그 처리 부분 시작 ---------------------------------

			Matcher matCount = MERGECELLS_COUNT_PATTERN.matcher(xmlBuffer.toString());
			xmlBuffer.setLength(0);
			if (matCount.find()) {
				xmlBuffer.append(matCount.replaceFirst(String.format("count=\"%s\"", NumberUtils.toInt(matCount.group(1))+_listAddRowSize)));
			}
			//2019-06-27 fix, 머지된 행의 카운트수의 자릿수가 변할 때 <mergeCell 태그가 들어갈 지점을 잘못 찾는 오류 수정
			int pos = matCount.end();
			pos = xmlBuffer.indexOf(">", pos)+1;

			Matcher matRef = MERGECELL_REF_PATTERN.matcher(xmlBuffer.substring(pos));
			xmlBuffer.setLength(pos);
			while (matRef.find()) {
				int mBeginVPos = NumberUtils.toInt(matRef.group(2));
				int mEndVPos = NumberUtils.toInt(matRef.group(4));
				if (_listAddRowPos < mBeginVPos) {
					mBeginVPos += _listAddRowSize;
					mEndVPos += _listAddRowSize;
					// 행밀기
					matRef.appendReplacement(xmlBuffer, String.format("<mergeCell ref=\"%s%s:%s%s\"/>", matRef.group(1), mBeginVPos, matRef.group(3), mEndVPos));
				}
				else if(_listAddRowPos == mBeginVPos) {
					// 여러줄 추가
					for(int i = 1 ; i <= _listAddRowSize ; i++) {
						xmlBuffer.append(String.format("<mergeCell ref=\"%s%s:%s%s\"/>", matRef.group(1), mBeginVPos+i, matRef.group(3), mEndVPos+i));
					}
				}
			}
			matRef.appendTail(xmlBuffer);
		}

		/////// [5] 태그를 종료할 때에 <row> 자식태그가 아닐 경우에만 버퍼를 비우고 파일로 스트림 출력
		writeXmlBuffer(qName);
	}

	/**
	 * 리스트키를 데이터로 채우기
	 *
	 * @param rowStr
	 * @param data
	 */
	private void fillDataByListKey(String rowStr, UMap data) {
		StringBuffer newRowSb = new StringBuffer(rowStr);

		// 행넘버 리넘버링 처리 (태그내의 값 중에서 row 값을 증가)
		reorderingRow(newRowSb, _listAddRowSize);

		// value 값을 db 의 값으로 변경
		Matcher matListKey = LIST_KEY_PATTERN.matcher(newRowSb.toString());
		newRowSb.setLength(0);
		while (matListKey.find()) {
			String excelKeyPrefix = matListKey.group(1);
			if (keyPrefix.equals(excelKeyPrefix)) {
				String dataKey = matListKey.group(2);
				String val = "";
				if (data != null) {
					val = data.getStr(dataKey);
					val = StringEscapeUtils.unescapeXml(val);
					val = StringEscapeUtils.escapeXml10(val);
				}
				matListKey.appendReplacement(newRowSb, val);
			}
		}
		matListKey.appendTail(newRowSb);

		// value값이 숫자일 경우에는 셀의 스타일이 숫자형태로 저장되도록 처리
		XlsxParserHelper.replaceNumberTypeCell(newRowSb);

		// 행을 버퍼에 추가
		xmlBuffer.append(newRowSb);
	}

	@Override
	public void characters(char[] ch, int start, int length) throws SAXException {
		String charData = (new String(ch, start, length));
		charData = StringEscapeUtils.unescapeXml(charData);
		charData = StringEscapeUtils.escapeXml10(charData);
		valBuffer.append(charData);
	}

	@Override
	public void endDocument() throws SAXException {
		UMap mcSpanMap = si.getMergeMap();
		UMap mcNewSpanMap = new UMap();
		List<String> keyList = mcSpanMap.toKeyList();
		for(int i = 0 ; i < keyList.size() ; i++) {
			String oldKey = keyList.get(i);
			Matcher matCellKey = CELL_KEY_PATTERN.matcher(oldKey);
			if (matCellKey.find()) {

				//2019-06-13 fix, 시트내에 머지된 열을 중복으로 조작할 때에 엉키는 버그 해결
				int rowNo = NumberUtils.toInt(matCellKey.group(2));
				if ((rowNo+1) > _listAddRowPos) {
					rowNo += _listAddRowSize;
				}

				String newKey = String.format("%s%s", matCellKey.group(1), rowNo);
				mcNewSpanMap.put(newKey, mcSpanMap.getStr(oldKey));
			}
		}
		mcSpanMap.clear();
		si.setMergeMap(mcNewSpanMap);

		try {
			fw.close();
		} catch (IOException ignore) {
		}
	}

	/**
	 * 버퍼의 내용을 출력하고 비움
	 */
	private void writeXmlBuffer(String qName) {
		if (!"c".equalsIgnoreCase(qName) && !"v".equalsIgnoreCase(qName) && !"is".equalsIgnoreCase(qName) && !"t".equalsIgnoreCase(qName) && !"f".equalsIgnoreCase(qName) && !"mergeCell".equalsIgnoreCase(qName)) {
			try {
				fw.write(xmlBuffer.toString());
			} catch (IOException ignore) {}
			xmlBuffer.setLength(0);
		}
	}

	/**
	 * addIdx 만큼 row 인덱스를 재정렬
	 *
	 * @param newRowSb
	 * @param addIdx
	 */
	private void reorderingRow(StringBuffer newRowSb, int addIdx) {
		// <row> 의 r="" attr 변경
		Matcher matRow = ROW_R_ATTR_PATTERN.matcher(newRowSb.toString());
		newRowSb.setLength(0);
		if (matRow.find()) {
			newRowSb.append(matRow.replaceFirst(String.format("<row r=\"%d\"", NumberUtils.toInt(matRow.group(1))+addIdx)));
		}

		// <c> 의 r="" attr 변경
		Matcher matCell = CELL_R_ATTR_PATTERN.matcher(newRowSb.toString());
		newRowSb.setLength(0);
		while (matCell.find()) {
			matCell.appendReplacement(newRowSb, String.format("<c r=\"%s%s\"", matCell.group(1), NumberUtils.toInt(matCell.group(2))+addIdx));
		}
		matCell.appendTail(newRowSb);
	}
}
