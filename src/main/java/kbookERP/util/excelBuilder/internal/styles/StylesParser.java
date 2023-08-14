package kbookERP.util.excelBuilder.internal.styles;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.io.FileUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import kbookERP.util.excelBuilder.util.XlsxZipHelper;
import kbookERP.util.map.UMap;
import kbookERP.util.sax.SAXHelper;


/**
 * styles.xml 파일 파싱 (스타일정보를 추출하기 위해 사용)
 *
 * @author 박주의
 */
public class StylesParser extends DefaultHandler {

	// 기본 날짜포맷id
	private static Set<String> builtInDateTimenumFmtIdSet;

	// 처리에 필요한 멤버
	private boolean onTagCellXfs;
	private UMap numFmtMap;

	// 결과값 멤버
	private ArrayList<StyleInfo> xfList;

	/**
	 *  엑셀파일에서 styles.xml 파일을 추출 파싱해서 styleList를 생성
	 *
	 *  사용예)
	 * 	SharedStringsParser parser = new SharedStringsParser(this.workFile);
		UMap data = parser.getData();
	 *
	 * @param workFile
	 * @param useMap ; viewMap 및 listMap 에 데이터를 추출할지 여부
	 * @throws IOException
	 */
	public StylesParser(File workFile) throws IOException {
		if (builtInDateTimenumFmtIdSet == null) {
			builtInDateTimenumFmtIdSet = new HashSet<String>(Arrays.asList(new String[]{"14","15","16","17","18","19","20","21","22","27","28","29","30","31","32","33","34","35","36","45","46","47","50","51","52","53","54","55","56","57","58"}));
		}

		onTagCellXfs = false;
		xfList = new ArrayList<StyleInfo>();
		numFmtMap = new UMap();

		File styleXmlFile = File.createTempFile("styles", ".xml");
		XlsxZipHelper.extractEntry(workFile, styleXmlFile, "xl/styles.xml");

		SAXHelper.parseXml(styleXmlFile, this);

		FileUtils.deleteQuietly(styleXmlFile);
	}

	/**
	 * 스타일리스트를 반환
	 *
	 * @return
	 */
	public ArrayList<StyleInfo> getStyleList() {
		return xfList;
	}

	/**
	 * formatId 나 formatCode 를 확인해서 날짜타입인지 여부를 확인
	 *
	 * @param formatId
	 * @return
	 */
	public boolean checkDateType(String formatId) {
		boolean result = builtInDateTimenumFmtIdSet.contains(formatId);
		if (!result && numFmtMap.containsKey(formatId)) {
			String formatCode = numFmtMap.getStr(formatId).toLowerCase();
			if (formatCode.indexOf("yy") > -1 || formatCode.indexOf("mm") > -1 || formatCode.indexOf("dd") > -1 || formatCode.indexOf("hh") > -1 || formatCode.indexOf("ss") > -1) {
				result = true;
			}
		}
		return result;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {

		if ("cellXfs".equalsIgnoreCase(qName)) {
			onTagCellXfs = true;
		}
		else if (onTagCellXfs && "xf".equalsIgnoreCase(qName)) {
			StyleInfo style = new StyleInfo();
			style.setStyleIdx(xfList.size());
			String numFmtId = attributes.getValue("numFmtId");
			style.setNumFmtId(numFmtId);
			style.setDateType(this.checkDateType(numFmtId));
			style.setFontId(attributes.getValue("fontId"));
			style.setFillId(attributes.getValue("fillId"));
			style.setBorderId(attributes.getValue("borderId"));
			style.setXfId(attributes.getValue("xfId"));
			style.setApplyFont(attributes.getValue("applyFont"));
			style.setApplyAlignment(attributes.getValue("applyAlignment"));
			style.setApplyFill(attributes.getValue("applyFill"));
			style.setFormatCode(numFmtMap.getStr(numFmtId));
			xfList.add(style);
		}
		else if ("numFmt".equalsIgnoreCase(qName)) {
			numFmtMap.put(attributes.getValue("numFmtId"), attributes.getValue("formatCode"));
		}
	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		if ("cellXfs".equalsIgnoreCase(qName)) {
			throw new SAXException("ParsedComplete");
		}
	}
}
