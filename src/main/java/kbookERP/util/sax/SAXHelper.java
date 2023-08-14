package kbookERP.util.sax;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;


/**
 * SAXHelper (SAX 파싱을 위한 헬퍼 클래스)
 *
 * <pre>
 *  ■ 변경이력
 *
 *  버전    변경일자    작업자      수정내용
 *  ----    --------    --------    -------------------------------------------
 *  v2.0    20190510	  zxx		최초작성
 *
 * </pre>
 *
 * @author 박주의
 * @version v2.0
 *
 */
public class SAXHelper {

	/**
	 * xml파일명을 받아서 핸들러로 파싱
	 *
	 * @param xmlFileName ; 대상xml파일
	 * @param handler ; 파싱핸들러
	 */
	public static void parseXml(String xmlFileName, DefaultHandler handler) {
		parseXml(new File(xmlFileName), handler);
	}

	/**
	 * xml 파일을 받아서 핸들러로 파싱
	 *
	 * @param xmlFile ; 대상xml파일
	 * @param handler ; 파싱핸들러
	 */
	public static void parseXml(File xmlFile, DefaultHandler handler) {
		SAXParserFactory saxParserFactory = SAXParserFactory.newInstance();
		try {
			SAXParser saxParser = saxParserFactory.newSAXParser();
			saxParser.parse(xmlFile, handler);
		} catch (ParserConfigurationException | SAXException | IOException e) {
			if (!"ParsedComplete".equals(e.getMessage())) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * xml 문자열을 받아서 핸들러로 파싱
	 *
	 * @param xmlStr ; 대상xml String
	 * @param handler ; 파싱핸들러
	 */
	public static void parseStr(String xmlStr, DefaultHandler handler) {
		SAXParserFactory saxParserFactory = SAXParserFactory.newInstance();
		try {
			SAXParser saxParser = saxParserFactory.newSAXParser();
			InputStream is = new ByteArrayInputStream(replaceUserHtml(xmlStr).getBytes(StandardCharsets.UTF_8));
			saxParser.parse(is, handler);
		} catch (ParserConfigurationException | SAXException | IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 스트링버퍼로 받은 데이터 중에 asPattern 을 찾아서 toPattern 으로 변경
	 *
	 * @param sb ; 스트링버퍼
	 * @param asPattern ; 변경전
	 * @param toPattern ; 변경후
	 */
	public static void replaceLast(StringBuffer sb, String asPattern, String toPattern) {
		int beginPos = sb.lastIndexOf(asPattern);
		if (beginPos > 0) {
			int endPos = beginPos + asPattern.length();
			sb.delete(beginPos, endPos);
			sb.insert(beginPos, toPattern);
		}
	}

	/**
	 * xml 파일 string 내부의 html 태그를 <![CDATA[ ]]> 로 감싼 문자열로 변경
	 *
	 * @param xmlStr ; xml String
	 */
	public static String replaceUserHtml(String xmlStr) {
		StringBuffer sb = new StringBuffer(xmlStr);
		int pos = sb.indexOf("<userHtml>");
		if (pos > -1) {
			pos = sb.indexOf("<html", pos);
			while (pos > -1) {
				pos = sb.indexOf(">", pos) + 1;
				sb.insert(pos, "<![CDATA[");

				pos = sb.indexOf("</html>", pos);
				sb.insert(pos, "]]>");

				pos = sb.indexOf("<html", pos);
			}
		}
		return sb.toString();
	}
}
