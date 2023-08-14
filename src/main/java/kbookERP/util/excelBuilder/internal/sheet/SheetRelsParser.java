package kbookERP.util.excelBuilder.internal.sheet;
import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import kbookERP.util.excelBuilder.internal.workbook.SheetInfo;
import kbookERP.util.excelBuilder.util.XlsxZipHelper;
import kbookERP.util.sax.SAXHelper;


/**
 * sheet.xml.rels 파일 파싱 (페이지내에 포함된 이미지파일 이동을 위해 사용)
 *
 * @author 박주의
 */
public class SheetRelsParser extends DefaultHandler {

	private SheetInfo sheet;

	public SheetRelsParser(SheetInfo sheet) {
		this.sheet = sheet;
	}

	public SheetInfo getSheet() {
		return sheet;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if (qName.equalsIgnoreCase("Relationship")) {
			if (StringUtils.isNotEmpty(sheet.getRelDrawId()) && sheet.getRelDrawId().equals(attributes.getValue("Id"))) {
				String drawingXmlFilePath = attributes.getValue("Target");
				String drawingRef = drawingXmlFilePath.replace("..", "xl");
				sheet.setRelDrawRef(drawingRef);
			}
		}
	}

	/**
	 * sheet.xml.rels 에서 관련 drawing.xml 의 ref 정보를 추출한다.
	 *
	 * @param sheet
	 * @throws IOException
	 */
	public static void findRelDrawRef(SheetInfo sheet) throws IOException {
		// sheetRel.xml 파일 파싱
		if (StringUtils.isNotBlank(sheet.getRelDrawId())) {
			// sheet.xml.rels 파일 추출
			String sheetAbsolutePath = sheet.getSheetRef();
			String sheetFileName = FilenameUtils.getName(sheetAbsolutePath);
			File _sheetRelXmlFile = File.createTempFile(sheetFileName, ".rels");
			XlsxZipHelper.extractEntry(sheet.getWorkExcelFile(), _sheetRelXmlFile, String.format("xl/worksheets/_rels/%s.rels", sheetFileName));

			// sheet.xml.rels 파싱
			SheetRelsParser sheetRelParser = new SheetRelsParser(sheet);
			SAXHelper.parseXml(_sheetRelXmlFile, sheetRelParser);

			// sheet.xml.rels 임시파일 삭제
			FileUtils.deleteQuietly(_sheetRelXmlFile);
		}
	}
}
