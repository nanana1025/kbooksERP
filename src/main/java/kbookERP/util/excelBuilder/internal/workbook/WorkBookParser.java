package kbookERP.util.excelBuilder.internal.workbook;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import org.apache.commons.io.FileUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import kbookERP.util.excelBuilder.util.XlsxZipHelper;
import kbookERP.util.sax.SAXHelper;


/**
 * workbook.xml 파일 파싱 (시트정보를 추출하기 위해 사용)
 *
 * @author 박주의
 */
public class WorkBookParser extends DefaultHandler {

	private ArrayList<SheetInfo> sheetList;
	private File wbRelXmlFile;

	/**
	 * 디폴트 생성자를 이용해서 직접 파일을 지정하여 sheetList를 추출하는 법
	 *
	 * 사용예)
	 * 	WorkBookHandler parser = new WorkBookHandler();
	 * 	handler.setWbRelXmlFile(new File("D:/test2/aaa/xl/_rels/workbook.xml.rels"));
	 * 	SAXHelper.parseXml("D:/test2/aaa/xl/workbook.xml", parser);
	 *	List<SheetInfo> sheetList = handler.getSheetList();
	 */
	public WorkBookParser() {
		sheetList = new ArrayList<SheetInfo>();
	}

	/**
	 *  엑셀파일에서 workbook.xml 및 workbook.xml.rels 파일을 추출 파싱해서 sheetList 를 생성
	 *
	 *  사용예)
	 * 	WorkBookHandler parser = new WorkBookHandler(this.workFile);
		List<SheetInfo> sheetList = parser.getSheetList();
	 *
	 * @param workFile
	 * @throws IOException
	 */
	public WorkBookParser(File workFile) throws IOException {
		this();

		File wbXmlFile = File.createTempFile("workbook", ".xml");
		XlsxZipHelper.extractEntry(workFile, wbXmlFile, "xl/workbook.xml");

		wbRelXmlFile = File.createTempFile("workbook.xml", ".rels");
		XlsxZipHelper.extractEntry(workFile, wbRelXmlFile, "xl/_rels/workbook.xml.rels");

		SAXHelper.parseXml(wbXmlFile, this);

		FileUtils.deleteQuietly(wbXmlFile);
		FileUtils.deleteQuietly(wbRelXmlFile);
	}

	public void setWbRelXmlFile(File relXmlFile) {
		this.wbRelXmlFile = relXmlFile;
	}

	public ArrayList<SheetInfo> getSheetList() {
		return sheetList;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if (qName.equalsIgnoreCase("sheet")) {
			SheetInfo sheet = new SheetInfo();
			sheet.setSheetName(attributes.getValue("name"));
			sheet.setRelId(attributes.getValue("r:id"));

			if (wbRelXmlFile != null) {
				WorkBookRelsParser parser = new WorkBookRelsParser(sheet);
				SAXHelper.parseXml(wbRelXmlFile, parser);
			}
			sheet.setSheetIdx(sheetList.size());
			sheetList.add(sheet);
		}
	}
}
