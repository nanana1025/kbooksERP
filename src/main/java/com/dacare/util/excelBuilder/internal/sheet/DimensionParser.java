package com.dacare.util.excelBuilder.internal.sheet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import com.dacare.util.excelBuilder.internal.workbook.SheetInfo;
import com.dacare.util.sax.SAXHelper;


/**
 * sheet.xml 파일 파싱 후 dimension 정보 추출 (시트정보를 읽을 때 활용)
 *
 * @author 박주의
 */
public class DimensionParser extends DefaultHandler {

	private static final Pattern CELL_REF_PATTERN = Pattern.compile("([A-Z]+)([0-9]+):([A-Z]+)([0-9]+)", Pattern.CASE_INSENSITIVE);

	private SheetInfo sheet;

	/**
	 * 디폴트 생성자를 이용해서 직접 파일을 지정하여 sheetList를 추출하는 법
	 *
	 */
	public DimensionParser(SheetInfo si) {
		this.sheet = si;

		SAXHelper.parseXml(si.getTempXmlFile(), this);
	}

	/**
	 * 시트정보를 반환
	 *
	 * @return
	 */
	public SheetInfo getSheetInfo() {
		return sheet;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if ("dimension".equalsIgnoreCase(qName)) {
			String attrVal = attributes.getValue("ref");
			Matcher m = CELL_REF_PATTERN.matcher(attrVal);
			if (m.find()) {
				String begin = String.format("%s%s", m.group(1), m.group(2));
				sheet.setSheetBeginCellStr(begin);

				String end = String.format("%s%s", m.group(3), m.group(4));
				sheet.setSheetEndCellStr(end);
			}

			// 파싱종료
			throw new SAXException("ParsedComplete");
		}
	}


}
