package com.dacare.util.excelBuilder.internal.sheet;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.text.StringEscapeUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import com.dacare.util.excelBuilder.util.XlsxParserHelper;
import com.dacare.util.map.UMap;
import com.dacare.util.sax.SAXHelper;


/**
 * sheet.xml 파일 파싱 후 mergeCells 정보 추출 (페이지내의 병합셀에 대한 처리를 위해 사용)
 *
 * @author 박주의
 */
public class MergeCellsParser extends DefaultHandler {

	private static final Pattern CELL_REF_PATTERN = Pattern.compile("([A-Z]+)([0-9]+):([A-Z]+)([0-9]+)", Pattern.CASE_INSENSITIVE);

	private UMap keyMap;
	private UMap mcSpanMap;

	private StringBuffer tagAttrBuffer;
	private StringBuffer valBuffer;

	/**
	 * 디폴트 생성자를 이용해서 직접 파일을 지정하여 sheetList를 추출하는 법
	 *
	 * 사용예)
	 * 	SharedStringsParser parser = new SharedStringsParser();
	 * 	SAXHelper.parseXml("D:/test2/aaa/xl/sharedStrings.xml", parser);
	 *	UMap data = parser.getData();
	 */
	public MergeCellsParser(UMap listKey) {
		mcSpanMap = new UMap();
		this.keyMap = listKey;
		this.tagAttrBuffer = new StringBuffer();
		this.valBuffer = new StringBuffer();
	}

	/**
	 *  엑셀파일에서 sharedStrings.xml 파일을 추출 파싱해서 데이터맵을 생성
	 *
	 *  사용예)
	 * 	SharedStringsParser parser = new SharedStringsParser(this.workFile);
		UMap data = parser.getData();
	 *
	 * @param workFile
	 * @throws IOException
	 */
	public MergeCellsParser(File tempXmlFile, UMap listKey) throws IOException {
		this(listKey);

		SAXHelper.parseXml(tempXmlFile, this);
	}

	/**
	 * <mergeCell ref="N4:O5"/> 일 경우 "KEY"="colSpan:rowSpan" 의 key=value 형태로 맵 생성
	 * EX) "N4"="N4:N5" 일 경우에는 "N4"="1:1" 와 같이 저장
	 *
	 * @return
	 */
	public UMap getMergeCellsSpanMap() {
		return mcSpanMap;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if ("mergeCell".equalsIgnoreCase(qName)) {
			String attrVal = attributes.getValue("ref");
			Matcher m = CELL_REF_PATTERN.matcher(attrVal);
			if (m.find()) {
				String key = String.format("%s%s", m.group(1), m.group(2));
				if (mcSpanMap.containsKey(key)) {
					int colSpan = XlsxParserHelper.convertColStringToIndex(m.group(3)) - XlsxParserHelper.convertColStringToIndex(m.group(1)) + 1;
					int rowSpan = NumberUtils.toInt(m.group(4)) - NumberUtils.toInt(m.group(2)) + 1;
					String val =  String.format("%s:%s", colSpan, rowSpan);
					mcSpanMap.put(key, val);
				}
			}
		}
		if ("c".equalsIgnoreCase(qName)) {
			tagAttrBuffer.setLength(0);
			valBuffer.setLength(0);

			String attrVal = attributes.getValue("r");
			tagAttrBuffer.append(attrVal);
		}

	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		if ("v".equalsIgnoreCase(qName)) {
			String charData = valBuffer.toString();
			int charLen = charData.trim().length();

			if (charLen > 0 && this.keyMap.containsKey(charData)) {
				// $[key] 형태의 값인지 확인
				String valKeyStr = this.keyMap.getStr(charData);
				if (valKeyStr.startsWith("$[")) {
					String cr = tagAttrBuffer.toString();
					mcSpanMap.put(cr, null);
				}
			}
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
		List<String> keys = mcSpanMap.toKeyList();
		for(int i = keys.size()-1 ; i >= 0 ; i--) {
			String key = keys.get(i);
			String val = mcSpanMap.getStr(key);
			if (StringUtils.isBlank(val)) {
				mcSpanMap.remove(key);
			}
		}
	}
}
