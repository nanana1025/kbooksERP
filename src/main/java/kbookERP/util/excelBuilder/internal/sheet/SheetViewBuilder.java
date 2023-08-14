package kbookERP.util.excelBuilder.internal.sheet;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.text.StringEscapeUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import kbookERP.util.excelBuilder.util.XlsxParserHelper;
import kbookERP.util.map.UMap;
import kbookERP.util.sax.SAXHelper;


/**
 * sheet.xml 파일 템플릿을 이용해서 view 데이터 삽입
 *
 * @author 박주의
 */
public class SheetViewBuilder extends DefaultHandler {
	private static final Pattern VIEW_KEY_PATTERN = Pattern.compile("\\$\\{(.+)\\.(.+)\\}", Pattern.CASE_INSENSITIVE);

	private static final String LAST_CELL_ID_PATTERN = "<c r=\"";
	private static final String AS_CELL_TYPE_PATTERN = "t=\"s\"";
	private static final String TO_CELL_TYPE_PATTERN = "t=\"inlineStr\"";
	private static final String AS_VALUE_TAG_PATTERN = "<v>";
	private static final String TO_VALUE_TAG_PATTERN = "<is><t>";

	public StringBuffer xmlBuffer;
	private StringBuffer tagBuffer;
	private StringBuffer valBuffer;

	private UMap keyMap;
	private String keyPrefix;
	private UMap dataMap;
	private Writer fw;
	private File workFile;

	/**
	 * 디폴트 생성자를 이용해서 직접 파일을 지정하여 sheetList를 추출하는 법
	 *
	 * 사용예)
	 * 	SheetViewBuilder parser = new SheetViewBuilder();
	 * 	SAXHelper.parseXml("D:/test2/aaa/xl/worksheets/sheet1.xml", parser);
	 *	File xmlFile = parser.getResultFile();
	 */
	public SheetViewBuilder(UMap viewKey, String prefix, UMap data) throws IOException {
		xmlBuffer = new StringBuffer();
		tagBuffer = new StringBuffer();
		valBuffer = new StringBuffer();
		this.workFile = File.createTempFile("view", ".xml");
		this.fw = new OutputStreamWriter(new FileOutputStream(workFile), "UTF-8");
		this.keyMap = viewKey;
		this.keyPrefix= prefix;
		this.dataMap = data;
	}

	/**
	 *  엑셀파일에서 sheet.xml 파일을 추출 파싱해서 데이터맵을 생성
	 *
	 *  사용예)
	 * 	SheetViewBuilder parser = new SheetViewBuilder(sheetInfo.getTemlXmlFile());
		File xmlFile = parser.getResultFile();
	 *
	 * @param workFile
	 * @throws IOException
	 */
	public SheetViewBuilder(File tempXmlFile, UMap viewKey, String prefix, UMap data) throws IOException {
		this(viewKey, prefix, data);

		SAXHelper.parseXml(tempXmlFile, this);
	}

	/**
	 * 결과파일 출력
	 * @return
	 */
	public File getResultFile() {
		return workFile;
	}

	@Override
	public void startDocument() throws SAXException {
		xmlBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\r\n");
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {

		xmlBuffer.append("<").append(qName);
		for(int i=0 ; i < attributes.getLength() ; i++) {
			xmlBuffer.append(" ").append(attributes.getQName(i));
			xmlBuffer.append("=\"").append(attributes.getValue(i)).append("\"");
		}
		xmlBuffer.append(">");

		tagBuffer.setLength(0);
		tagBuffer.append(qName);
		valBuffer.setLength(0);
	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		String charData = valBuffer.toString();
		int charLen = charData.trim().length();
		boolean isInlineStr = false;
		if (qName.equalsIgnoreCase("v")) {
			int chkCellAttrTPos = xmlBuffer.indexOf(AS_CELL_TYPE_PATTERN, xmlBuffer.lastIndexOf(LAST_CELL_ID_PATTERN));
			if (charLen > 0 && chkCellAttrTPos > -1 && this.keyMap.containsKey(charData)) {

				// 2019년 (${view.MONTH})월 보고서 와 같이 사이에 낀 경우도 처리할 수 있도록 패턴매칭 replace 사용
				Matcher m = VIEW_KEY_PATTERN.matcher(this.keyMap.getStr(charData));
				if (m.find()) {
					valBuffer.setLength(0);
					if (keyPrefix.equals(m.group(1))) {
						m.appendReplacement(valBuffer, this.dataMap.getStr(m.group(2)));
					}
					m.appendTail(valBuffer);
					charData = valBuffer.toString();
					charData = StringEscapeUtils.unescapeXml(charData);
					charData = StringEscapeUtils.escapeXml10(charData);
				}

				// 결과값이 숫자인지 확인
				if (XlsxParserHelper.isNumber(charData)) {
					// 숫자인 경우에는 t="s" 가 없이 저장되도록 수정필요
					SAXHelper.replaceLast(xmlBuffer, AS_CELL_TYPE_PATTERN, "");
				}
				else {
					// 문자일 경우에는 t=inlineStr 로 변경처리 및 value 도 <is><v> 로 변경
					isInlineStr = true;

					// t="s" --> t="inlineStr" 로 변경
					SAXHelper.replaceLast(xmlBuffer, AS_CELL_TYPE_PATTERN, TO_CELL_TYPE_PATTERN);

					// <v> --> <is><v> 로 변경
					SAXHelper.replaceLast(xmlBuffer, AS_VALUE_TAG_PATTERN, TO_VALUE_TAG_PATTERN);
				}

			}
		}
		xmlBuffer.append(charData);
		valBuffer.setLength(0);

		if (charLen == 0 && qName.equals(tagBuffer.toString())) {
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

		try {
			fw.write(xmlBuffer.toString());
			xmlBuffer.setLength(0);
		} catch (IOException ignore) {
		}
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
		try {
			fw.close();
		} catch (IOException ignore) {
		}
	}
}
