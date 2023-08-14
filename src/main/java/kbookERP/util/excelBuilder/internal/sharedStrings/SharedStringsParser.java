package kbookERP.util.excelBuilder.internal.sharedStrings;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import kbookERP.util.excelBuilder.util.XlsxZipHelper;
import kbookERP.util.map.UMap;
import kbookERP.util.sax.SAXHelper;


/**
 * sharedStrings.xml 파일 파싱 (viewMap 과 listMap의 key 값만 추출, ExcelBuilder용)
 *
 * @author 박주의
 */
public class SharedStringsParser extends DefaultHandler {

	private ArrayList<String> siList;
	private UMap viewMap;
	private UMap listMap;

	private StringBuffer sBuffer;

	private boolean isUseMap;
	private int siNo;
	private boolean onTagSi;
	private boolean onTagT;

	/**
	 * 디폴트 생성자를 이용해서 직접 파일을 지정하여 sheetList를 추출하는 법
	 *
	 * 사용예)
	 * 	SharedStringsParser parser = new SharedStringsParser();
	 * 	SAXHelper.parseXml("D:/test2/aaa/xl/sharedStrings.xml", parser);
	 *	UMap data = parser.getData();
	 */
	public SharedStringsParser() {
		sBuffer = new StringBuffer();
		siList = new ArrayList<String>();
		viewMap = new UMap();
		listMap = new UMap();
		siNo = 0;
		onTagSi = false;
		onTagT = false;
		isUseMap = true;
	}

	/**
	 *  엑셀파일에서 sharedStrings.xml 파일을 추출 파싱해서 데이터맵을 생성
	 *
	 *  사용예)
	 * 	SharedStringsParser parser = new SharedStringsParser(this.workFile);
		UMap data = parser.getData();
	 *
	 * @param workFile
	 * @param useMap ; viewMap 및 listMap 에 데이터를 추출할지 여부
	 * @throws IOException
	 */
	public SharedStringsParser(File workFile, boolean useMap) throws IOException {
		this();
		this.isUseMap = useMap;

		File ssXmlFile = File.createTempFile("sharedStrings", ".xml");
		XlsxZipHelper.extractEntry(workFile, ssXmlFile, "xl/sharedStrings.xml");

		SAXHelper.parseXml(ssXmlFile, this);

		FileUtils.deleteQuietly(ssXmlFile);
	}


	/**
	 * ${key} 형태의 값을 반환
	 *
	 * @return
	 */
	public UMap getViewMap() {
		return viewMap;
	}

	/**
	 * $[key] 형태의 값을 반환
	 *
	 * @return
	 */
	public UMap getListMap() {
		return listMap;
	}

	/**
	 * 디버깅용 리스트 값을 반환
	 *
	 * @return
	 */
	public List<String> getSiList() {
		return siList;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if (qName.equalsIgnoreCase("si")) {
			onTagSi = true;
			sBuffer.setLength(0);
		}
		else if (onTagSi && qName.equalsIgnoreCase("t")) {
			onTagT = true;

		}
	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		if (qName.equalsIgnoreCase("si")) {
			String val = sBuffer.toString().trim();
			if (isUseMap) {
				if (isUseMap && val.indexOf("${") >= 0) {
					viewMap.put(String.format("%d", siNo), val);
				}
				else if (isUseMap && val.startsWith("$[")) {
					listMap.put(String.format("%d", siNo), val);
				}
			}else {
				siList.add(val);
			}
			onTagSi = false;
			siNo++;
		}
		else if (onTagSi && qName.equalsIgnoreCase("t")) {
			onTagT = false;
		}
	}

	@Override
	public void characters(char[] ch, int start, int length) throws SAXException {
		if (onTagSi && onTagT) {
	      String characterData = (new String(ch, start, length));
	      sBuffer.append(characterData);
		}
	}
}
