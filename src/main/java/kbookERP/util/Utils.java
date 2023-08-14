package kbookERP.util;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.activation.MimetypesFileTypeMap;
import javax.script.Invocable;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;

import kbookERP.core.xmlvo.chart.Chart;
import kbookERP.core.xmlvo.chart.ChartParser;
import kbookERP.core.xmlvo.data.DataParser;
import kbookERP.core.xmlvo.data.DataRoot;
import kbookERP.core.xmlvo.layout.Layout;
import kbookERP.core.xmlvo.layout.LayoutParser;
import kbookERP.core.xmlvo.list.ListParser;
import kbookERP.core.xmlvo.list.ListRoot;
import kbookERP.core.xmlvo.menu.Menu;
import kbookERP.core.xmlvo.menu.MenuParser;
import kbookERP.core.xmlvo.tree.Tree;
import kbookERP.core.xmlvo.tree.TreeParser;
import kbookERP.util.map.LowerKeyMap;
import kbookERP.util.map.ObjectUtils;
import kbookERP.util.sax.SAXHelper;

@Component
public class Utils {

	public static String YMD_SHORT = "yyMMdd";
	public static String YMD_SHORT_DASH = "yy-MM-dd";
	public static String YMD_LONG = "yyyyMMdd";
	public static String YMD_LONG_DASH = "yyyy-MM-dd";
	public static String YMD_FROMAT_01 = "yyyy-MM-dd HH:mm:ss";
	public static String YMD_FROMAT_02 = "yyyyMMddHHmm";
	public static String XML_EXTENTION = ".xml";
	public static String JAVA_EXTENTION = ".java";
	public static String JSON_EXTENTION = ".json";
	public static String EXCEL_EXTENTION = ".xslx";

	@Value(value="${system.xml.path}")
    static String xmlRootPath;

	@Value(value="${system.xml.path}")
	private void setValue(String xmlPath) {
		xmlRootPath = xmlPath;
	}

	private String getXmlRootPath() {
		return xmlRootPath;
	}

	/**
	 * 브라우저 종류 열거자
	 */
	enum BrowserTypes {
		MSIE, Chrome, Opera, Safari, Firefox
	}

    public static String nvl(Object src) {
        if(src == null) {
            return "";
        } else {
            return src.toString();
        }
    }

    public static String nvl(Object src, String val) {
        if(src == null) {
            if(val != null) {
                return val;
            } else {
                return "";
            }
        } else {
            return src.toString();
        }
    }

    public static String getToday() {
    	return getToday(YMD_SHORT);
    }

    public static String getToday(String format) {
    	Calendar cal = Calendar.getInstance();
		Date today = cal.getTime();
		SimpleDateFormat sdf = new SimpleDateFormat(format);

		return sdf.format(today);
    }

    public static String getStringDate(Date date) {
    	return getStringDate(date, YMD_SHORT);
    }

    public static String getStringDate(Date date, String format) {
    	if(org.springframework.util.ObjectUtils.isEmpty(date)) {
    		return "";
    	}
    	if(StringUtils.isEmpty(format)) {
    		format = YMD_SHORT;
    	}

    	String sDate = new SimpleDateFormat(format).format(date);

    	return sDate;
    }

    //목록 설정 xml 파싱
    public static ListRoot getListXmlToObject(String filePath) throws Exception {
//		  File file = new File(filePath);
		byte[] encoded = Files.readAllBytes(Paths.get(filePath));
    	String xmlStr = new String(encoded, "UTF-8");
	    ListParser parser = new ListParser();
		SAXHelper.parseStr(xmlStr, parser);
	    return parser.getList();
    }

    //CRUD 설정 xml 파싱
    public static DataRoot getDataXmlToObject(String filePath) throws Exception {
//    	  File file = new File(filePath);
    	byte[] encoded = Files.readAllBytes(Paths.get(filePath));
    	String xmlStr = new String(encoded, "UTF-8");
	    DataParser parser = new DataParser();
		SAXHelper.parseStr(xmlStr, parser);
	    return parser.getData();
    }

    //메뉴 설정 xml 파싱
    public static Menu getMenuXmlToObject(String filePath) throws Exception {
        File file = new File(filePath);
        MenuParser parser = new MenuParser();
		SAXHelper.parseXml(file, parser);
        return parser.getMenu();
    }

  //트리 설정 xml 파싱
    public static Tree getTreeXmlToObject(String filePath) throws Exception {
//    	File file = new File(filePath);
    	byte[] encoded = Files.readAllBytes(Paths.get(filePath));
    	String xmlStr = new String(encoded, "UTF-8");
        TreeParser parser = new TreeParser();
		SAXHelper.parseStr(xmlStr, parser);
        return parser.getTree();
    }

    //차트 설정 xml 파싱
    public static Chart getChartXmlToObject(String filePath) throws Exception {
//    	File file = new File(filePath);
    	byte[] encoded = Files.readAllBytes(Paths.get(filePath));
    	String xmlStr = new String(encoded, "UTF-8");
    	ChartParser parser = new ChartParser();
    	SAXHelper.parseStr(xmlStr, parser);
    	return parser.getChart();
    }

    //레이아웃 설정 xml 파싱
    public static Layout getLayoutXmlToObject(String filePath) throws Exception {
    	File file = new File(filePath);
        LayoutParser parser = new LayoutParser();
		SAXHelper.parseXml(file, parser);
        return parser.getLayout();
    }

    //목록 내 키값 소문자 변경(DHX 키값 대문자 사용 불가)
    public static List keyChangeLower(List<Map<String,Object>> list) {

        List<Map> newList = new LinkedList<>();
        for (int i = 0; i < list.size(); i++) {
            HashMap<String, Object> tm = new HashMap<String, Object>(list.get(i));
            Iterator<String> iteratorKey = tm.keySet().iterator(); // 키값 오름차순
            Map  newMap = new HashMap();
            // //키값 내림차순 정렬
            while (iteratorKey.hasNext()) {
                String key = iteratorKey.next();
                newMap .put(key.toLowerCase(), tm.get(key));
            }
            newList.add(newMap);
        }
        return newList;
    }

    public static boolean fileCheck(String path) {
        File file = new File(path);
        return (file.exists() && file.isFile());
    }

    public static String currentDate() {
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    	Calendar c1 = Calendar.getInstance();
    	String currentDate = sdf.format(c1.getTime());
    	return currentDate;
    }

    //xml을 String으로 파싱
    public static String getXmlToString(String filePath) throws Exception {
        File file = new File(filePath);
        String output = FileUtils.readFileToString(file, "UTF-8");
//        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
//        TransformerFactory tf = TransformerFactory.newInstance();
//        DocumentBuilder builder = factory.newDocumentBuilder();
//        org.w3c.dom.Document doc = builder.parse(file);
//        Transformer transformer = tf.newTransformer();
//        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
//        StringWriter writer = new StringWriter();
//        transformer.transform(new DOMSource(doc), new StreamResult(writer));
//        String output = writer.getBuffer().toString();

        return output;
    }

    public static String unescapeStr(String str) {
    	str = str.replaceAll("%23", "#");
    	str = str.replaceAll("%25" ,"%");
    	str = str.replaceAll("%26" ,"&");
    	str = str.replaceAll("%3F" ,"?");
    	str = str.replaceAll("%3D" ,"=");
    	return str;
    }



    /**
     * 쿼리결과 List를 계층구조를 가진 구조로 변환한다.
     * Javascript Tree 컴포넌트의 데이터 구조에 맞추가 위해 사용한다.
     * input => [{"ornzid":9001,"upprornzid":0},{"ornzid":7,"upprornzid":9001}]
     * output => [{"ornzid":9001,"upprornzid":0, children: [{"ornzid":7,"upprornzid":9001}]]
     * @param srcList
     * @param keyName
     * @param upprKeyName
     * @return
     */
    public static List<Map<String,Object>> toHierarchyJson(List<LowerKeyMap> srcList, String keyName, String upprKeyName, String textcol, String treeTitle) {
        List<Map<String, Object>> dstList = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> data : srcList) {
            String upprKey = ObjectUtils.toString(data.get(upprKeyName));
            LowerKeyMap upprData = getMapByValueFromList(srcList, keyName, upprKey);
            if (upprData == null) {
                dstList.add(data);
            } else {
                List<Map<String, Object>> childrenList = ObjectUtils.toList(upprData.get("items"));
                childrenList.add(data);
                upprData.put("items", childrenList);

                // activate node인 경우 상위 노드들을 모두 펼쳐준다.
                if (ObjectUtils.toBool(data.get("activate"))) {
                    while(upprData != null) {
                        upprData.put("expanded", true);

                        upprKey = ObjectUtils.toString(upprData.get(upprKeyName));
                        upprData = getMapByValueFromList(srcList, keyName, upprKey);
                    }
                }
            }
        }
        return dstList;
    }

    /**
     * List에서 Map의 값을 검색해서 해당 값을 가진 Map을 반환한다.
     * 해당 값을 가진 Map이 여러개인 경우 무조건 첫번째 검색된 Map을 반환한다.
     * @param list
     * @param key
     * @param value
     * @return
     */
    public static LowerKeyMap getMapByValueFromList(List<LowerKeyMap> list, String key, String value) {
        for (LowerKeyMap map : list) {
            String data = ObjectUtils.toString(map.get(key));
            if (data.equals(value)) return map;
        }
        return null;
    }
    /**
     * List에는 값을 array 배열에 담당 반환환다.
     * @param list
     * @param keys
     * @return List<String[]>
     */
    public static List<String[]> getStringArrayByValueFromList(List<Map<String, Object>> list, String... keys)
    {
        List<String[]> resultArray = new ArrayList<String[]>();
        if (null!=list && 0<list.size())
        {
            for (int i=0; i<list.size(); i++)
            {
                Map mTemp = (Map<String,Object>)list.get(i);
                String arrayData[] = new String[keys.length];
                for (int j=0; j<keys.length; j++)
                {
                    arrayData[j] = ObjectUtils.toString(mTemp.get(keys[j]));
                }
                resultArray.add(arrayData);
            }
        }
        return resultArray;
    }
    /**
     * Map 의 컬럼을 array 배열에 담아 반환한다. (조주연)
     * @param map
     * @param keys
     * @return List<String[]>
     */
    public static List<String[]> getStringArrayByValueFromMap(Map<String, Object> map, String... keys)
    {
        List<String[]> resultArray = new ArrayList<String[]>();
        for (int i=0; i<keys.length; i++)
        {
            String arrayData[] = new String[2];
            arrayData[0] = ObjectUtils.toString(i+1);
            arrayData[1] = ObjectUtils.toString(map.get(keys[i]));
            resultArray.add(arrayData);
        }
        return resultArray;
    }

    /**
     * list에 있는 여러 값들 중에서 필요한 넘들만 { name1:value, name2:value } 형태로 뽑아낸다.
     * <pre>
     * 예) list [{ fnm:'사과', cnt:4, cost:4000, grage:'상' },{ fnm:'배', cnt:2, cost:8000, grage:'중' }, ...]
     *     toNameValue(list, 'fnm', 'cnt') => "{ '사과': 4, '배':2, ... }"
     * </pre>
     *
     * @param list
     * @param nameKey
     * @param valueKey
     * @return
     * @throws Exception
     */
    public static String toNVJson(List<Map<String, Object>> list, String nameKey, String valueKey) throws Exception {
        // 결과물의 순서를 위하여 LinkedHashMap 사용
        Map<String, Object> rs = new LinkedHashMap<>();

        for (Map<String, Object> map : list) {
            rs.put(ObjectUtils.toString(map.get(nameKey)), map.get(valueKey));
        }

        ObjectMapper om = new ObjectMapper();
        return om.writeValueAsString(rs);
    }

    public static String replaceCol(String str) {
    	str = str.replaceAll("\"strSort\"", "strSort");
    	str = str.replaceAll("\"numSort\"", "numSort");
    	str = str.replaceAll("\"calSort\"", "calSort");
    	str = str.replaceAll("\"naSort\"", "naSort");
    	return str;
    }

    public static String getMenuFilePath(String fileName, String menuPath) {
    	String filePath = "";
    	List<File> files = new ArrayList<File>();

    	ClassPathResource resource = new ClassPathResource(menuPath+"/xmlfiles");
        String root = resource.getPath();

        File f = new File(root);
        if(f.exists()) {
        	root = f.getAbsolutePath();
        } else {

        	root = Utils.class.getResource(menuPath+"/xmlfiles").toString();
        	root = root.replaceFirst("file:", "");

        }
    	listf(root,files);
    	for(File file : files){
    		if(fileName.equalsIgnoreCase(file.getName())){
    			filePath = file.getAbsolutePath();
    		}
    	}
		return filePath;
	}

    public static String getMenuAdmFilePath(String fileName, String menuPath) {
    	String filePath = "";
    	List<File> files = new ArrayList<File>();

    	ClassPathResource resource = new ClassPathResource(menuPath+"/adminXml");
    	String root = resource.getPath();
    	File f = new File(root);
    	if(f.exists()) {
    		root = f.getAbsolutePath();
    	} else {
    		root = Utils.class.getResource(menuPath+"/adminXml").toString();
    		root = root.replaceFirst("file:", "");
	}
    	listf(root,files);
    	for(File file : files){
    		if(fileName.equalsIgnoreCase(file.getName())){
    			filePath = file.getAbsolutePath();
    		}
    	}
    	return filePath;
    }

    public static String getFilePath(String fileName) {
    	String filePath = "";
    	List<File> files = new ArrayList<File>();
    	ClassPathResource resource = new ClassPathResource(xmlRootPath+"/xmlfiles");
        String root = resource.getPath();
        File f = new File(root);
        if(f.exists()) {
        	root = f.getAbsolutePath();
        } else {
        	root = Utils.class.getResource(xmlRootPath+"/xmlfiles").toString();
        	root = root.replaceFirst("file:", "");
        }
    	listf(root,files);
    	for(File file : files){
    		if(fileName.equalsIgnoreCase(file.getName())){
    			filePath = file.getAbsolutePath();
    		}
    	}
		return filePath;
	}

    public static String getAdmXmlPath(String fileName) throws Exception {
		String filePath = "";
    	List<File> files = new ArrayList<File>();
    	ClassPathResource resource = new ClassPathResource(xmlRootPath+"/adminXml");
        String root = resource.getPath();
        File f = new File(root);
        if(f.exists()) {
        	root = f.getAbsolutePath();
        } else {
        	root = Utils.class.getResource(xmlRootPath+"/adminXml").toString();
        	root = root.replaceFirst("file:", "");
        }
    	listf(root,files);
    	for(File file : files){
    		if(fileName.equalsIgnoreCase(file.getName())){
    			filePath = file.getAbsolutePath();
    		}
    	}
		return filePath;
    }

    public static String getResourceFilePath(String fileName) {
    	String filePath = "";
    	List<File> files = new ArrayList<File>();
    	ClassPathResource resource = new ClassPathResource(xmlRootPath+"/xmlfiles");
        String path = resource.getPath();
        File f = new File(path);

        if(f.exists()) {
        	path = f.getAbsolutePath();
        } else {
        	path = Utils.class.getResource(xmlRootPath+"/xmlfiles").toString();
        	path = path.replaceFirst("file:", "");
        }
    	listf(path,files);
    	for(File file : files){
    		if(fileName.equalsIgnoreCase(file.getName())){
    			filePath = file.getAbsolutePath();
    		}
    	}
    	return filePath;
    }

    public static String getAdmResourceFilePath(String fileName) {
    	String filePath = "";
    	List<File> files = new ArrayList<File>();
    	ClassPathResource resource = new ClassPathResource(xmlRootPath+"/adminXml");
        String path = resource.getPath();
        File f = new File(path);
        if(f.exists()) {
        	path = f.getAbsolutePath();
        } else {
        	path = Utils.class.getResource(xmlRootPath+"/adminXml").toString();
        	path = path.replaceFirst("file:", "");
        }
    	listf(path,files);
    	for(File file : files){
    		if(fileName.equalsIgnoreCase(file.getName())){
    			filePath = file.getAbsolutePath();
    		}
    	}
    	return filePath;
    }


    private static void listf(String directoryName, List<File> files) {
        File directory = new File(directoryName);

        // Get all files from a directory.
        File[] fList = directory.listFiles();
        if(fList != null){
            for (File file : fList) {
                if (file.isFile()) {
                    files.add(file);
                } else if (file.isDirectory()) {
                    listf(file.getAbsolutePath(), files);
                }
            }
        }
    }

    public static String decodeJavascriptString(final String encodedString) {
        ScriptEngine engine = new ScriptEngineManager().getEngineByName("nashorn");
        Invocable invocable = (Invocable) engine;
        String decodedString = encodedString;
        try {
            decodedString = (String) invocable.invokeFunction("unescape", encodedString);

        } catch (ScriptException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }

        return decodedString;
    }

    public static String makeIdentityNumber(String prefix) {
    	return makeIdentityNumber(prefix, getToday());
    }

    public static String makeIdentityNumber(String prefix, String date) {
    	if(StringUtils.isEmpty(prefix)) {
    		return "";
    	}

    	if(StringUtils.isEmpty(date)) {
    		date = getToday();
    	}

    	 return makeIdentityNumber(prefix, date, 0);
    }

    public static String makeIdentityNumber(String prefix, int order) {
    	if(StringUtils.isEmpty(prefix)) {
    		return "";
    	}

    	if(order < 0) {
    		return "";
    	}

    	return makeIdentityNumber(prefix, getToday(), order);
    }

    public static String makeIdentityNumber(String prefix, String date, int lastOrder) {
    	if(StringUtils.isEmpty(date)) {
    		date = getToday();
    	}

    	StringBuilder sb = new StringBuilder();
    	String order = String.format("%02d", lastOrder + 1);
    	sb.append(prefix).append(date).append("-").append(order);

    	return sb.toString();
    }

    @Deprecated
    /* @see Utils.getStringDate */
    public static String dateString(String type) {
		if (type == null)
			return null;

		String str = null;
		try {
			// type 예) yyyy-MM-dd HH:mm:ss
			SimpleDateFormat formatterDate = new SimpleDateFormat(type);
			str = formatterDate.format(new java.util.Date());
		} catch (IllegalArgumentException e) {
		}
		return str;
	}

    /**
     * 시작시간과 과 종료시간 사이의 날짜차이를 구한다.
     * @param startDate 시작시간
     * @param endDate 종료시간
     * @param dateFormat 날짜포멧
     * @return
     */
	public static int getDayDiffByFormat(String startDate, String endDate, String dateFormat) {
		int diff = 0;
		try {
			Date d1 = new SimpleDateFormat(dateFormat).parse(startDate);
			Calendar c1 = Calendar.getInstance();
			c1.setTime(d1);

			Date d2 = new SimpleDateFormat(dateFormat).parse(endDate);
			Calendar c2 = Calendar.getInstance();
			c2.setTime(d2);

			long diffMillis = c2.getTimeInMillis() - c1.getTimeInMillis();
			diff = (int)(diffMillis);

		} catch (ParseException e) {
			System.out.println("getDayDiffByFormat ParseException 오류");
		}
		return diff;
	}

	public static List<Map<String, Object>> convertJsonStringToListMap(String jsonStr) throws Exception {
		if(StringUtils.isEmpty(jsonStr)) {
			throw new Exception("string is empty");
		}

		ObjectMapper mapper = new ObjectMapper();
		return mapper.readValue(jsonStr, new TypeReference<List<Map<String, Object>>>() {});
	}

	/**
 	 * <pre>
 	 * 파일 다운로드
 	 * HttpServletResponse에 파일을 카피해서 브라우저에서 다운로드 되도록 한다.
 	 * </pre>
 	 *
 	 * @param fileFullPath 다운로드할 파일 전체 경로 예) D:\GochigoD01\Documents\KLOG\배포\201401221504\kbiz.war
 	 * @param filename 다운로드할때 브라우저에서 사용되는 파일명
 	 * @param request
 	 * @param response
 	 * @throws IOException
 	 * @throws Exception
 	 */
 	public static void downloadFile(String fileFullPath, String filename, HttpServletRequest request, HttpServletResponse response) throws Exception, IOException {
		File srcFile = new File(fileFullPath);
		if (srcFile.exists()) {
			String type = new MimetypesFileTypeMap().getContentType(srcFile);
			response.setContentType(type+"; charset=UTF-8");
			response.setContentLength((int)srcFile.length());

			response.setHeader("Content-Disposition", "attachment; filename=\"" + getDownFileName(request, filename) + "\"");

			try {
				FileUtils.copyFile(srcFile, response.getOutputStream());
				response.getOutputStream().flush();
			} catch (IOException e) {
				System.out.println(e);
			} finally {
//				if(srcFile.length() > 0) {
//					//FileUtils.forceDelete(srcFile);
//				}
				response.getOutputStream().close();
			}
		} else {
			throw new Exception(fileFullPath);
		}
 	}

 	/**
	 * 웹 브라우저에서 파일 다운로드시 파일명을 반환한다.
	 * 각 IE와 그 외 브라우저는 파일명 인코딩을 다르게 처리해야 하며 띄어쓰기는 '_'로 치환한다.
	 * @param request
	 * @param srcFileName
	 * @return
	 */
	public static String getDownFileName(HttpServletRequest request, String srcFileName) {

		BrowserTypes type = getBrowser(request);
		if (srcFileName == null || srcFileName.equals("")) {
			srcFileName = "UnKnownFileName";
		}

		String dstFileName = "";

		try {
			if (type == BrowserTypes.MSIE) {
				dstFileName = URLEncoder.encode(srcFileName.replaceAll(" ", "_"), "UTF-8");
			} else {
				dstFileName = new String(srcFileName.getBytes("UTF-8"), "ISO-8859-1").replaceAll(" ", "_");
			}
		} catch (UnsupportedEncodingException e) {
			dstFileName = srcFileName;
		}
		return dstFileName;
	}

	/**
	 * 브라우저 종류를 반환한다.
	 * @param request
	 * @return
	 */
	public static BrowserTypes getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		if (header.indexOf("MSIE") > -1 || header.indexOf("Trident") > -1) {
			return BrowserTypes.MSIE;
		} else if (header.indexOf("Chrome") > -1) {
			return BrowserTypes.Chrome;
		} else if (header.indexOf("Opera") > -1) {
			return BrowserTypes.Opera;
		} else if (header.indexOf("Safari") > -1) {
			return BrowserTypes.Safari;
		}
		return BrowserTypes.Firefox;
	}

	/**
     * 빈을 직접 얻습니다.
     *
     * @param beanName
     * @return
     */
    public static Object getBean(String beanName) {
        WebApplicationContext context = ContextLoader.getCurrentWebApplicationContext();
        return context.getBean(beanName);
    }

    public static void setLanguage(HttpSession session, String language) {
    	if(!StringUtils.isEmpty(language)) {
    		session.setAttribute("language", language);
    	}
    }

    public static String getLanguage(HttpSession session) {
    	String language = (String)session.getAttribute("language");
    	return language;
    }

    public static String getFileName(String fileName, String extension) {
    	if(StringUtils.isEmpty(extension)) {
    		return fileName;
    	}

    	return fileName + extension;
    }

    /**
     * 빈을 직접 얻습니다.
     *
     * @param beanName
     * @return
     */
    public static List<LowerKeyMap> getChildrenItemedList(List<LowerKeyMap> list) {
        for(LowerKeyMap map : list) {
        	if(map.get("items") != null) {
        		int cnt = Integer.parseInt(((String)map.get("items").toString()));
        		List<LowerKeyMap> tempList = new ArrayList<LowerKeyMap>();
        		for(int i=0;i<cnt;i++) {
        			LowerKeyMap tempMap = new LowerKeyMap();
        			tempList.add(tempMap);
        		}
        		map.put("items", tempList);
        	}
        }
        return list;
    }
}
