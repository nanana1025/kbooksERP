package com.dacare.util.excelBuilder.internal.workbook;
import org.apache.commons.lang3.StringUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;


/**
 * workbook.xml.rels 파일 파싱 (시트파일의 위치정보를 찾기 위해 사용)
 *
 * @author 박주의
 */
public class WorkBookRelsParser extends DefaultHandler {

	private SheetInfo sheet;

	public WorkBookRelsParser(SheetInfo sheet) {
		this.sheet = sheet;
	}

	public SheetInfo getSheet() {
		return sheet;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if (qName.equalsIgnoreCase("Relationship")) {
			if (StringUtils.isNotEmpty(sheet.getRelId()) && sheet.getRelId().equals(attributes.getValue("Id"))) {
				sheet.setSheetRef("xl/"+attributes.getValue("Target"));
			}
		}
	}
}
