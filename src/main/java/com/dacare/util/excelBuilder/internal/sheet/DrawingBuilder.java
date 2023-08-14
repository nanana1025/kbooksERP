package com.dacare.util.excelBuilder.internal.sheet;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.text.StringEscapeUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import com.dacare.util.excelBuilder.internal.workbook.SheetInfo;
import com.dacare.util.excelBuilder.util.XlsxZipHelper;
import com.dacare.util.sax.SAXHelper;


/**
 * DrawingBuilder (엑셀에 포함된 이미지 정보를 담고있는 drawing.xml 을 변경하는 클래스)
 *
 * <pre>
 *  ■ 설명
 *   - 태그내에 있는 <xdr:row>9</xdr:row> 값을 찾아서 데이터가 추가되는 행 이후의 행일 경우 행밀기를 함
 *   - row 값이 1부터가 아니라 0부터 시작됨
 *
 *  ■ 변경이력
 *
 *  버전    변경일자    작업자      수정내용
 *  ----    --------    --------    -------------------------------------------
 *  v2.0    20190513	박주의		최초작성
 *
 * </pre>
 *
 * @author 박주의
 * @version v2.0
 *
 */
public class DrawingBuilder extends DefaultHandler {
	// 파라미터 멤버
	private int _addRowPos;
	private int _addRowSize;

	// xml 처리를 위한 멤버
	public StringBuffer xmlBuffer;
	private StringBuffer tagBuffer;
	public StringBuffer valBuffer;

	private Writer fw;

	public DrawingBuilder(SheetInfo sheet, int addRowPos, int addRowSize) throws IOException {
		// 파라미터값을 셋팅
		_addRowPos = addRowPos;
		_addRowSize = addRowSize;

		// xml 처리를 위한 멤버 값 셋팅
		xmlBuffer = new StringBuffer();
		tagBuffer = new StringBuffer();
		valBuffer = new StringBuffer();

		// 그림파일이 포함된 경우만 처리
		if (StringUtils.isNotBlank(sheet.getRelDrawRef())) {
			File sheetRelDrawingXmlFile = sheet.getRelDrawFile();

			// 그림파일이 아직 미추출 상태면 추출
			if (sheetRelDrawingXmlFile == null) {
				String drawingFileName = FilenameUtils.getBaseName(sheet.getRelDrawRef());
				File drawingFile = File.createTempFile(drawingFileName, ".xml");
				XlsxZipHelper.extractEntry(sheet.getWorkExcelFile(), drawingFile, sheet.getRelDrawRef());
				sheet.setRelDrawFile(drawingFile);
			}

			// 작업을 위한 그림xml 생성
			File resultFile = File.createTempFile("draw", ".xml");
			this.fw = new OutputStreamWriter(new FileOutputStream(resultFile), "UTF-8");

			// xml 파싱시작
			SAXHelper.parseXml(sheet.getRelDrawFile(), this);

			// 결과 drawing.xml 을 시트정보의 RelDrawFile 로 덮어쓰기후 삭제
			FileUtils.copyFile(resultFile, sheet.getRelDrawFile());
			FileUtils.deleteQuietly(resultFile);
		}
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
		if (qName.equalsIgnoreCase("xdr:row")) {
			// 행밀기 처리
			int rowNo = NumberUtils.toInt(charData);
			if ((rowNo+1) > _addRowPos) {
				rowNo += _addRowSize;
			}
			charData = String.valueOf(rowNo);
		}
		xmlBuffer.append(charData);
		valBuffer.setLength(0);

		if (charLen == 0 && qName.equals(tagBuffer.toString())) {
			xmlBuffer.insert(xmlBuffer.length()-1, "/");
		}
		else {
			xmlBuffer.append("</").append(qName).append(">");
		}

		writeXmlBuffer();
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

	/**
	 * 버퍼의 내용을 출력하고 비움
	 */
	private void writeXmlBuffer() {
		try {
			fw.write(xmlBuffer.toString());
		} catch (IOException ignore) {}
		xmlBuffer.setLength(0);
	}

}
