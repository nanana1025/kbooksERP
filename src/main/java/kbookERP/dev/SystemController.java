package kbookERP.dev;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.devtools.restart.Restarter;
import org.springframework.core.env.Environment;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXParseException;

import com.fasterxml.jackson.databind.ObjectMapper;

import kbookERP.core.view.menu.MenuController;
import kbookERP.core.xmlvo.menu.Menu;
import kbookERP.core.xmlvo.menu.MenuItem;
import kbookERP.util.Utils;
import kbookERP.util.constant.Cubrid;
import kbookERP.util.constant.MariaDB;
import kbookERP.util.constant.Oracle;

@Controller
public class SystemController {

    Logger log = LoggerFactory.getLogger(this.getClass());

    //raw password : gochigodev
    private final static String DEV_PW_ENC = "$2a$10$ekqscqle8BX.hedt6UbC1.SPk37Oe4XwtuNzxYrQowwBwLD7B0zze";

    public static Map<String, Object> SYSTEM_INFO;
//    public static Map<String,Object> MENU_INFO;

    @PostConstruct
    public Map<String,Object> setSystemInfo() throws Exception {
//        SYSTEM_INFO = systemService.getSystemInfoList(null);
        return SYSTEM_INFO;
    }

    @Autowired
    SystemService systemService;

    @Autowired
    MenuController menuController;

    @Value(value="${system.id}")
	private String menuSystemId;

	@Value(value="${system.xml.path}")
	private String menuPath;

    @Autowired
    private Environment env;

    @Value("${spring.datasource.dbtype}")
	String dbType;

    @Value(value="${system.admin.id}")
    private String systemAdminId;

    @Value("${spring.db1.datasource.jdbcUrl}")
    private String db1_url;
    @Value("${spring.db1.datasource.username}")
    private String db1_username;
    @Value("${spring.db1.datasource.password}")
    private String db1_password;

//    @Value("${spring.db2.datasource.jdbcUrl}")
//    private String db2_url;
//    @Value("${spring.db2.datasource.username}")
//    private String db2_username;
//    @Value("${spring.db2.datasource.password}")
//    private String db2_password;

//    @Value("${spring.db3.datasource.jdbcUrl}")
//    private String db3_url;
//    @Value("${spring.db3.datasource.username}")
//    private String db3_username;
//    @Value("${spring.db3.datasource.password}")
//    private String db3_password;


//
//
//
//    @Value(value="${system.xml.path}")
//    private String xmlRootPath;
//    /**
//     * 개발자 로그인처리
//     * @param request
//     * @param pwd
//     * @return
//     */
//    @RequestMapping(value="/devLogin.json")
//    @ResponseBody
//    public Map<String,Object> devLogin(HttpServletRequest request, @RequestParam String pwd) {
//        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
//        boolean isLoginPass = passwordEncoder.matches(pwd, DEV_PW_ENC);
//        Map<String,Object> rtnMap = new HashMap<>();
//        rtnMap.put("isLoginPass", isLoginPass);
//
//        if(isLoginPass) {
//            HttpSession session = request.getSession();
//            session.setAttribute("SESSION_USER_TYPE", "DEV");
//        }
//
//        return rtnMap;
//    }
//
//    /**
//     * 시스템 선택 화면
//     * @param request
//     * @param params
//     * @return
//     */
//    @RequestMapping(value="/systemSel.do")
//    public String systemSel(HttpServletRequest request, @RequestParam Map<String,Object> params, Model model) throws Exception {
//
//
////        Map<String,Object> sysInfo = systemService.getSystemInfoList(params);
////        model.addAttribute("isEmptySystemInfo", (sysInfo==null));
////        model.addAttribute("db_url", db1_url);
////        model.addAttribute("db_username", db1_username);
////        model.addAttribute("db_password", db1_password);
//
////        model.addAttribute("db2_url", db2_url);
////        model.addAttribute("db2_username", db2_username);
////        model.addAttribute("db2_password", db2_password);
////
////        model.addAttribute("db3_url", db3_url);
////        model.addAttribute("db3_username", db3_username);
////        model.addAttribute("db3_password", db3_password);
//
//        model.addAttribute("sysInfo", SYSTEM_INFO);
//        return "core/system/systemSel";
//    }
//
//
//
//    /**
//     * XML 선택화면
//     * @param request
//     * @param params
//     * @return
//     */
//    @RequestMapping(value="/system/xmlSel.do")
//    public String xmlSel(HttpServletRequest request, @RequestParam Map<String,Object> params) {
//        return "core/system/xmlSel";
//    }
//
//    /**
//     * 사용자 메뉴 XML 정의 화면
//     * @param request
//     * @param params
//     * @return
//     */
//    @RequestMapping(value="/system/menuXmlSet.do")
//    public String menuXmlSet(HttpServletRequest request, @RequestParam Map<String,Object> params, Model model) throws Exception{
//        Map<String,Object> sysInfo = systemService.getSystemInfoList(params);
//        if(sysInfo != null) {
//            String menuSid = Utils.nvl(sysInfo.get("MENU_SID"));
//            model.addAttribute("systemId"   , sysInfo.get("SYSTEM_ID"));
//            model.addAttribute("systemName" , sysInfo.get("SYSTEM_NM"));
//            model.addAttribute("menuSid"    , menuSid);
//            model.addAttribute("sysInfo", SYSTEM_INFO);
//
//            if(menuSid != "") {
//                String filePath =  Utils.getFilePath(menuSid + "_MENU.xml");
//                if(!Utils.fileCheck(filePath)) {
//                    throw new Exception("XML 파일이 없습니다.");
//                }
//
//                String xmlString = Utils.getXmlToString(filePath);
//                model.addAttribute("xmlName", menuSid);
//                model.addAttribute("xmlStr", xmlString);
//            }
//        }
//
//        return "core/system/menuXmlSet";
//    }
//
//    /**
//     * 관리자 메뉴 XML 정의 화면
//     * @param request
//     * @param params
//     * @return
//     */
//    @RequestMapping(value="/system/admMenuXmlSet.do")
//    public String admMenuXmlSet(HttpServletRequest request, @RequestParam Map<String,Object> params, Model model) throws Exception{
//        Map<String,Object> sysInfo = systemService.getSystemInfoList(params);
//        if(sysInfo != null) {
//            model.addAttribute("systemId"   , systemAdminId);
//            model.addAttribute("systemName" , sysInfo.get("SYSTEM_NM"));
//            model.addAttribute("menuSid"    , systemAdminId);
//            model.addAttribute("sysInfo", SYSTEM_INFO);
//
//            String filePath =  Utils.getAdmXmlPath(systemAdminId + "_MENU.xml");
//            if(!Utils.fileCheck(filePath)) {
//                throw new Exception("XML 파일이 없습니다.");
//            }
//
//            String xmlString = Utils.getXmlToString(filePath);
//            model.addAttribute("xmlName", systemAdminId);
//            model.addAttribute("xmlStr", xmlString);
//        }
//
//        return "core/system/admMenuXmlSet";
//    }
//
//    /**
//     * 사용자 화면 XML 정의 화면
//     * @param request
//     * @param params
//     * @return
//     */
//    @RequestMapping(value="/system/scrnXmlSet.do")
//    public String scrnXmlSet(HttpServletRequest request, @RequestParam Map<String,Object> params, Model model) {
//    	HttpSession session = request.getSession();
//        session.setAttribute("SESSION_USER_TYPE", "DEV");
//        model.addAttribute("sysInfo", SYSTEM_INFO);
//        return "core/system/scrnXmlSet";
//    }
//
//    /**
//     * 관리자 화면 XML 정의 화면
//     * @param request
//     * @param params
//     * @return
//     */
//    @RequestMapping(value="/system/admScrnXmlSet.do")
//    public String admScrnXmlSet(HttpServletRequest request, @RequestParam Map<String,Object> params, Model model) {
//    	HttpSession session = request.getSession();
//        session.setAttribute("SESSION_USER_TYPE", "ADM");
//        model.addAttribute("sysInfo", SYSTEM_INFO);
//        return "core/system/admScrnXmlSet";
//    }
//
//    /**
//     * 시스템정보 입력 화면
//     * @param request
//     * @param params
//     * @param model
//     * @return
//     * @throws Exception
//     */
//    @RequestMapping(value="/system/systemInfo.do")
//    public String systemInfo(HttpServletRequest request, @RequestParam Map<String, Object> params, Model model) throws Exception {
//
//        Map<String,Object> rtnMap = systemService.getSystemInfoList(params);
//        if(rtnMap != null) {
//            model.addAttribute("systemInfo", rtnMap);
//            model.addAttribute("editMode", "U");
//            ObjectMapper om = new ObjectMapper();
//            model.addAttribute("fileInfo", om.writeValueAsString(getFileInfoJson(rtnMap)));
//            model.addAttribute("sysInfo", SYSTEM_INFO);
//        } else {
//            model.addAttribute("editMode", "C");
//        }
//        return "core/system/systemInfo";
//    }
//
//    /**
//     * 시스템 정보 저장
//     * @param request
//     * @param params
//     * @param files
//     * @return
//     * @throws Exception
//     */
//    @PostMapping(value="/system/saveSystemInfo.json")
//    @ResponseBody
//    public Map<String,Object> saveSystemInfo(HttpServletRequest request, @RequestParam Map<String,Object> params, @RequestPart("logoImg") MultipartFile files) throws Exception {
//
//        params = saveFile(params, files);
//
//        Map<String,Object> rtnMap = new HashMap<String,Object>();
////        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
////        String admPw = Utils.nvl(params.get("adminPw"));
////        params.remove("adminPw");
////        params.put("adminPw", passwordEncoder.encode(admPw));
//        String systemId = systemService.getSystemId();
//        params.put("systemId", systemId);
//        params.put("rgsId", "sysadmin");
//
//        String datetime = "";
//		if ("CUBRID".equalsIgnoreCase(dbType)) {
//			datetime = Cubrid.DATETIME;
//		} else if ("ORACLE".equalsIgnoreCase(dbType)) {
//			datetime = Oracle.DATE;
//		} else if ("MARIADB".equalsIgnoreCase(dbType)) {
//			datetime = MariaDB.DATETIME;
//		}
//		params.put("SYSDATETIME", datetime);
//
//        if(params.containsKey("errMsg")) {
//            rtnMap.put("success", false);
//            rtnMap.put("errMsg", params.get("errMsg"));
//            return rtnMap;
//        }
//
//        if(systemService.saveSystemInfo(params) > 0) {
//            rtnMap.put("success", true);
//
//           // setSystemInfo();
//        } else {
//            rtnMap.put("success", false);
//            rtnMap.put("errMsg", "data save fail");
//        }
//        return rtnMap;
//    }
//
//    /**
//     * 시스템 정보 업데이트
//     * @param request
//     * @param params
//     * @param files
//     * @return
//     * @throws Exception
//     */
//    @PostMapping(value="/system/updateSystemInfo.json")
//    @ResponseBody
//    public Map<String,Object> updateSystemInfo(HttpServletRequest request, @RequestParam Map params, @RequestPart("logoImg") MultipartFile files) throws Exception {
//
//        if(!ObjectUtils.isEmpty(files.getOriginalFilename())) {
//            /*파일 업로드 시작*/
//        	String orgFileNm	= FilenameUtils.getName(files.getOriginalFilename());
//        	String sysImgPath = getSysImgPath();
//        	String fileUrl		= FilenameUtils.concat(sysImgPath, orgFileNm);	// 파일명을 포함한 실제 경로
//
//            Path dirPath =  Paths.get(sysImgPath).toAbsolutePath().normalize();
//
////            String imgFileNm = files.getOriginalFilename();
//
//            Files.createDirectories(dirPath);
//            File dstFile = new File(fileUrl);
//
////            Path targetLocation = dirPath.resolve(imgFileNm);
//            //파일 신규 추가
//
//            FileUtils.copyInputStreamToFile(files.getInputStream(), dstFile);
////            Files.copy(files.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
//
//            if(!ObjectUtils.isEmpty(params.get("orgFileName"))) {
//                //기 등록 파일 삭제
//                Path delTargetLocation = dirPath.resolve(params.get("orgFileName").toString());
//                Files.deleteIfExists(delTargetLocation);
//            }
//
////            String imgPath = targetLocation.toAbsolutePath().toString();
//            params.put("files", "exists");
//            params.put("imgPath", fileUrl);
//            params.put("imgName", orgFileNm);
//            /*파일 업로드 종료*/
//        }
//
//        Map rtnMap = new HashMap();
//
//        rtnMap.put("success", systemService.updateSystemInfo(params) > 0);
//        //setSystemInfo();
//
//        return rtnMap;
//    }
//
//    /**
//     * 파일 저장 처리
//     * @param params
//     * @param files
//     * @return
//     */
//    public Map<String,Object> saveFile(Map params, MultipartFile files) {
//        String imgPath  = "";
//        try {
//            /*파일 업로드 시작*/
//
//            String sysImgPath = getSysImgPath();
//
//            Path dirPath =  Paths.get(sysImgPath).toAbsolutePath().normalize();
//
//            String imgFileNm = files.getOriginalFilename();
//
//            Files.createDirectories(dirPath);
//
//            Path targetLocation = dirPath.resolve(imgFileNm);
//            Files.copy(files.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
//
//            imgPath = targetLocation.toAbsolutePath().toString();
//            params.put("imgPath", imgPath);
//            params.put("imgName", imgFileNm);
//
//            return params;
//        } catch(IOException i) {
//            params.put("errMsg", "file save error!");
//            return params;
//        }
//    }
//
//    /**
//     * 파일 삭제처리
//     * @param params
//     * @return
//     */
//    @RequestMapping(value="/system/delFile.do")
//    @ResponseBody
//    public Map<String,Object> deleteFile(@RequestParam Map params) {
//        String imgPath  = "";
//        try {
//            String sysImgPath = getSysImgPath();
//            Path dirPath =  Paths.get(sysImgPath).toAbsolutePath().normalize();
//            String imgFileNm = params.get("orgFileName").toString();
//
//            Path targetLocation = dirPath.resolve(imgFileNm);
//            Files.deleteIfExists(targetLocation);
//            systemService.deleteImgInfo(params);
//            params.put("success", true);
//        } catch(IOException i) {
//            params.put("success", false);
//            params.put("errMsg", "file delete error!");
//        } catch(Exception e) {
//            params.put("success", false);
//            params.put("errMsg", "img info update eror!");
//        }
//        return params;
//    }
//
//    /**
//     * 이미지 저장 경로
//     * @return
//     * @throws IOException
//     */
//    public String getSysImgPath() throws IOException {
//        Resource res = new ClassPathResource("application.properties");
//        File file = res.getFile();
//        String resPath = file.getParent();
//
//        return resPath + File.separator + "static" + File.separator + "sys_img";
//    }
//
//    /**
//     * 파일 정보 조회 json
//     * @param params
//     * @return
//     * @throws Exception
//     */
//    public Map<String,Object> getFileInfoJson(Map<String,Object> params) throws Exception {
//        Map<String,Object> fileInfo = new HashMap<>();
//        String imgPath = Utils.nvl(params.get("LOGO_IMG_PATH"));
//        String name = Utils.nvl(params.get("LOGO_IMG_NM"));
//
//        File file = new File(imgPath);
//
//        if(file.exists()) {
//            fileInfo.put("size", file.length());
//            fileInfo.put("extension", name.substring(name.lastIndexOf("."), name.length()));
//            fileInfo.put("name", name);
//        }
//
//        return fileInfo;
//    }
//
//    /**
//     * 파일 다운로드
//     * @param params
//     * @param request
//     * @return
//     * @throws Exception
//     */
//    @GetMapping("/download.do")
//    public ResponseEntity<Resource> downloadDirectFileJson(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
//
//
//        String fileName = (String) params.get("fileName");
//
//        String path = getSysImgPath();
//        File file = new File(path + File.separator + fileName);
//
//        Path filePath = file.toPath();
//        Resource resource = new UrlResource(filePath.toUri());
//
//        // Try to determine file's content type
//        String contentType = request.getServletContext().getMimeType(file.getAbsolutePath());
//
//        // Fallback to the default content type if type could not be determined
//        if(contentType == null) {
//            contentType = "application/octet-stream;charset=UTF-8";
//        }
//
//        return ResponseEntity.ok()
//                .contentType(MediaType.parseMediaType(contentType))
//                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
//                .body(resource);
//    }
//
//    @PostMapping("/system/saveMenuXml.json")
//    @ResponseBody
//    public Map<String,Object> saveMenuXml(HttpServletRequest request, @RequestParam Map<String,Object> params) throws Exception {
//        /* xml 파일 생성 시작 */
//        String xmlStr = params.get("xmlStr").toString();
//        String systemId = params.get("systemId").toString();
//        String xmlType = params.get("xmlType").toString();
//        String owner = params.get("owner").toString();
//
//        String fileName = systemId+"_"+xmlType+".xml";
//        params.put("fileName", fileName);
//
//        String path = Utils.getResourceFilePath(fileName);
//        if("ADMIN".equals(owner)) {
//        	path = Utils.getAdmResourceFilePath(fileName);
//        }
//        File folder = new File(path);
//        if(!folder.exists()) {
//            boolean _flg = folder.mkdir();
//            if(!_flg) {
//                throw new IOException("Directory create Failed !! ");
//            }
//        }
//
//        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
//        DocumentBuilder builder;
//        builder = factory.newDocumentBuilder();
//        Document document = builder.parse(new InputSource(new StringReader(xmlStr)));
//        TransformerFactory tranFactory = TransformerFactory.newInstance();
//        Transformer aTransformer = tranFactory.newTransformer();
//        Source src = new DOMSource( document );
//        Result dest = new StreamResult( new File( path ) );
//        aTransformer.transform( src, dest );
//
//        Map<String,Object> uptMap = new HashMap<>();
//
//        uptMap.put("systemId", params.get("systemId"));
//        uptMap.put("menuSid" , systemId);
//
//        uptMap.put("success" ,  systemService.updateMenuInfo(uptMap) > 0);
//        if("ADMIN".equals(owner)) {
//        	uptMap.put("success" ,  1);
//        }
//
//        menuController.setMenuObject(request);
//    	Restarter.getInstance().restart();
//
//        return uptMap;
//    }
//
//    @RequestMapping(value = "/system/menuPreview.do")
//    public String menuPreview(HttpServletRequest request, @RequestParam Map<String,Object> params, Model model) throws Exception {
//
//        Map<String,Object> sysInfo = systemService.getSystemInfoList(params);
//
//        model.addAttribute("sysInfo" , sysInfo);
//
//        String filePath = Utils.getFilePath(params.get("sid")+"_MENU.xml");
//        if("ADMIN".equals(params.get("OWNER"))) {
//        	filePath = Utils.getAdmXmlPath(params.get("sid")+"_MENU.xml");
//        }
//
//        if(!Utils.fileCheck(filePath)) {
//            throw new Exception("등록된 MENU XML 파일이 없습니다.");
//        }
//
//        String xmlString = Utils.getXmlToString(filePath);
//        model.addAttribute("xmlStr", xmlString);
//
//        Menu menu = Utils.getMenuXmlToObject(filePath);
//
//        List<MenuItem> itemList = menu.getItems();
//
//        List<HashMap<String,Object>> sResult = new ArrayList<>();
//
//        StringBuilder sb = new StringBuilder();
//
//        if(menu != null){
//            sb.append("<table class=\"tbl_type01\">");
//            sb.append("<col width=\"20%\">");
//            sb.append("<col width=\"30%\">");
//            sb.append("<col width=\"50%\">");
//            sb.append("<thead><tr><th>text</th><th>url</th><th>sub</th></tr></thead>");
//            sb.append("<tbody>");
//            for(MenuItem item : itemList){
//            	if(item.getPid() != 0) continue;
//
//                sb.append("<tr>");
//                sb.append("<td>"+Utils.nvl(item.getText())+"</td>");
//                sb.append("<td><a href=\""+Utils.nvl(item.getUrl())+"\">"+Utils.nvl(item.getUrl())+"</a></td>");
//
//                sb.append("<td>");
//                if(item.getItems() != null && item.getItems().size() > 0) {
//                	previewSubMenuMake(sb, item);
//                }
//                sb.append("</td>");
//                sb.append("</tr>");
//            }
//            sb.append("</tbody>");
//            sb.append("</table>");
//        }
//
//        model.addAttribute("menuTbl", sb.toString());
//
//        model.addAttribute("menutype", menu.getType());
//        model.addAttribute("sid", params.get("sid"));
//
//        return "core/system/menuPreview";
//    }
//
//    private void previewSubMenuMake(StringBuilder sb, MenuItem menu) {
//    	 sb.append("<table class=\"tbl_type01\">");
//         sb.append("<col width=\"30%\">");
//         sb.append("<col width=\"70%\">");
//         sb.append("<thead><tr><th>text</th><th>url</th></tr></thead>");
//         sb.append("<tbody>");
//         List<HashMap<String, Object>> subItems = new ArrayList<>();
//
//         for (MenuItem subItem : menu.getItems()) {
//             sb.append("<tr>");
//             sb.append("<th>"+Utils.nvl(subItem.getText())+"</th>");
//             sb.append("<td><a href=\""+Utils.nvl(subItem.getUrl())+"\">"+Utils.nvl(subItem.getUrl())+"</a></td>");
//             sb.append("</tr>");
//         }
//         sb.append("</tbody>");
//         sb.append("</table>");
//    }
//
//    @RequestMapping("/system/xmlList.do")
//    public String xmlList() throws Exception {
//        return "core/xmlList";
//    }
//
//    @GetMapping("/system/xmlSave.do")
//    public ModelAndView mngmList(@RequestParam Map<String,Object> params) throws Exception {
//        ModelAndView mav = new ModelAndView();
//
//        mav.addObject("xmlOwner", params.get("owner"));
//        mav.addObject("xmlFolder", params.get("xmlFolder"));
//        mav.addObject("sysInfo", SYSTEM_INFO);
//        mav.setViewName("core/xmlSave");
//
//        return mav;
//    }
//
//    @RequestMapping(value="/system/xmlList.json", produces="application/json")
//    @ResponseBody
//    public List<Map<String,Object>> getMngmList(HttpServletRequest request, @RequestParam Map<String,Object> params) throws Exception {
//        ModelAndView mav = new ModelAndView();
//
//        //DB 사용시
//        List<Map<String,Object>> list  = systemService.getXmlList(params);
//
//        //txt파일 사용 시
////        List<LinkedHashMap<String,Object>> list = DataFileMng.xmlInfoRead();
//        mav.setView(new MappingJackson2JsonView());
////        mav.addObject("rows", getRsltList(list));
//        return list;
//    }
//
//    @GetMapping("/system/deleteXml.json")
//    public ModelAndView deleteXml(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mv = new ModelAndView();
//        String xn = request.getParameter("xn");
//        String xmlOwner = request.getParameter("xmlOwner");
//
//        Map<String,Object> delParam = new HashMap<>();
//        delParam.put("xn", xn);
//
//        String filePath = Utils.getResourceFilePath(xn);
//        if("ADMIN".equals(xmlOwner)) {
//        	filePath = Utils.getAdmResourceFilePath(xn);
//        }
//
//        File delFile = new File(filePath);
//        if(delFile.isFile()) delFile.delete();
//
//        mv.setView(new MappingJackson2JsonView());
//
//        mv.addObject("success", "success");
//
//        return mv;
//    }
//
//    @PostMapping("/system/saveXml.json")
//    public ModelAndView saveXml(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mv = new ModelAndView();
//
//        String xmlStr = request.getParameter("xmlStr");
//        String xmlFolder = request.getParameter("xmlFolder");
//        String xmlName = request.getParameter("xn");
//        String xmlType = request.getParameter("xmlType");
//        String xmlOwner = request.getParameter("xmlOwner");
//        String sid = xmlName.substring(0, xmlName.indexOf("_")-1);
//
////        Map<String,Object> saveParam = new HashMap<>();
////        saveParam.put("xmlName", xmlName);
////        saveParam.put("xmlType", xmlType);
////        saveParam.put("fileName", xmlName);
////        saveParam.put("xmlOwner", xmlOwner);
////        saveParam.put("sid", sid);
//
////        if(systemService.getXmlList(saveParam).size() > 0) {
////            throw new Exception("이미 존재하는 SID.");
////        }
//
////        String path = env.getProperty("xmlfile.dir");
//        ClassPathResource resource = new ClassPathResource(xmlRootPath+xmlFolder);
////        if("ADMIN".equals(xmlOwner)) {
////        	resource = new ClassPathResource("src/main/resources/adminXml");
////        }
//        String path = resource.getPath();
//
//
//        File folder = new File(path);
//        if(!folder.exists()) {
//        	path = this.getClass().getResource(xmlRootPath+xmlFolder).toString();
//        	path = path.replaceFirst("file:", "");
//        }
//        folder = new File(path);
//        if(!folder.exists()) {
//            boolean _flg = folder.mkdir();
//            if(!_flg) {
//                throw new IOException("Directory create Failed !! ");
//            }
//        }
//
//        File isFile = new File(path+xmlName);
//        if(isFile.exists()) {
//        	throw new IOException("이미 존재하는 파일명입니다.");
//        }
//
//        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
//        DocumentBuilder builder;
//
//        builder = factory.newDocumentBuilder();
//        try {
//        	Document document = builder.parse(new InputSource(new StringReader(xmlStr)));
//        } catch(SAXParseException e) {
//        	mv.addObject("message", e.getMessage());
//        }
//
////        TransformerFactory tranFactory = TransformerFactory.newInstance();
////        Transformer aTransformer = tranFactory.newTransformer();
////        Source src = new DOMSource( document );
////
////        Result dest = new StreamResult( new File( path + File.separator + xmlName) );
////        aTransformer.transform( src, dest );
//        File newFile = new File(path+xmlName);
//        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(newFile, true), StandardCharsets.UTF_8));
//        bw.write(xmlStr);
//        bw.flush();
//        bw.close();
//
//        mv.setView(new MappingJackson2JsonView());
//        mv.addObject("rtnSid", xmlName);
//        return mv;
////        } else {
////            throw new Exception("Data Save Error!!");
////        }
//    }
//
//    public List<LinkedHashMap<String,Object>> getRsltList(List<LinkedHashMap<String,Object>> sResult) {
//        List<LinkedHashMap<String,Object>> _resultList = new ArrayList<>();
//        for(LinkedHashMap<String,Object> _map : sResult) {
//            LinkedHashMap<String,Object> _result = new LinkedHashMap<>();
//            _result.put("id", _map.get("RN"));
//            _map.remove("RN");
//            String arrData[] = new String[_map.keySet().size()];
//            int i = 0;
//            for(String key : _map.keySet()) {
//                if(arrData[i]==null) {
//                    arrData[i] = Utils.nvl(_map.get(key));
//                }
//                i++;
//            }
//            _result.put("data", arrData);
//            _resultList.add(_result);
//        }
//
//        return _resultList;
//    }
//
//    @GetMapping("/system/xmlEdit.do")
//    public ModelAndView xmlEdit(@RequestParam Map<String,Object> params) throws Exception {
//        ModelAndView mav = new ModelAndView();
//
//        mav.setViewName("core/xmlEdit");
//
////        String filePath = env.getProperty("xmlfile.dir")+ File.separator+ params.get("sid")+"_"+params.get("scrnTp") + ".xml";
//        String filePath = Utils.getResourceFilePath((String)params.get("xn"));
//        if("ADMIN".equals(params.get("owner"))) {
//        	filePath = Utils.getAdmResourceFilePath((String)params.get("xn"));
//        }
//
//        System.out.println("@@@@@ filePath : "+filePath);
//        if(!Utils.fileCheck(filePath)) {
//            throw new Exception("XML 파일이 없습니다.");
//        }
//
//        String xmlString = Utils.getXmlToString(filePath);
////        mav.addObject("xmlId", params.get("XML_ID"));
//        mav.addObject("xn", params.get("xn"));
//        mav.addObject("xmlTp", params.get("xmlTp"));
//        mav.addObject("xmlString", xmlString);
//        mav.addObject("xmlOwner", params.get("owner"));
//        mav.addObject("sysInfo", SYSTEM_INFO);
//        return mav;
//    }
//
//    @PostMapping("/system/editXml.json")
//    public ModelAndView editXml(HttpServletRequest request, HttpServletResponse response) throws Exception {
//        ModelAndView mv = new ModelAndView();
//
//        String xmlString = request.getParameter("xmlString");
//        String owner = request.getParameter("xmlOwner");
//        String xn = request.getParameter("xn");
//
//        String filePath = Utils.getResourceFilePath(xn);
//        if("ADMIN".equals(owner)) {
//        	filePath = Utils.getAdmResourceFilePath(xn);
//        }
//        if(!Utils.fileCheck(filePath)) {
//            throw new Exception("XML 파일이 없습니다.");
//        }
//
//        File file = new File(filePath);
//        file.delete();
//
//        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
//        DocumentBuilder builder;
//
//        builder = factory.newDocumentBuilder();
//        try {
//        	Document document = builder.parse(new InputSource(new StringReader(xmlString)));
//        } catch(SAXParseException e) {
//        	mv.addObject("message", e.getMessage());
//        }
//
////        TransformerFactory tranFactory = TransformerFactory.newInstance();
////        Transformer aTransformer = tranFactory.newTransformer();
////        Source src = new DOMSource( document );
//
////        Result dest = new StreamResult( new File(filePath) );
////        aTransformer.transform( src, dest );
//        File newFile = new File(filePath);
//        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(newFile, true), StandardCharsets.UTF_8));
//        bw.write(xmlString);
//        bw.flush();
//        bw.close();
//
//        mv.setView(new MappingJackson2JsonView());
//        mv.addObject("rtnSid", xn);
//        return mv;
//    }
//
//    @GetMapping("/system/xmlFolderAdd.do")
//    public ModelAndView xmlFolderAdd(@RequestParam Map<String,Object> params) throws Exception {
//        ModelAndView mav = new ModelAndView();
//
//        mav.addObject("folderNm", params.get("folderNm"));
//        mav.setViewName("core/system/xmlFolderAdd");
//
//        return mav;
//    }
//
//    @PostMapping("/system/addXmlFolder.json")
//    public ModelAndView addXmlFolder(@RequestParam Map<String,Object> params) throws Exception {
//    	ModelAndView mv = new ModelAndView();
//    	ClassPathResource resource = new ClassPathResource(xmlRootPath);
//
//        String path = resource.getPath();
//        File chkPath = new File(path);
//        if(!chkPath.exists()) {
//        	path = this.getClass().getResource(xmlRootPath).toString();
//        	path = path.replaceFirst("file:", "");
//        }
//        path = path + params.get("newFolderNm");
//
//        File folder = new File(path);
//        boolean _flg = false;
//        if(!folder.exists()) {
//        	folder.setWritable(true);
//            _flg = folder.mkdir();
//        }
//
//        mv.setView(new MappingJackson2JsonView());
//        if(_flg) {
//            mv.addObject("success", "success");
//        }
//    	return mv;
//    }
//
//    public String getFilePath(String fileName) {
//        //String filePath = env.getProperty("xmlfile.dir")+ File.separator+ params.get("sid").toString().trim() + "_LIST.xml";
//        String filePath = "";
//        List<File> files = new ArrayList<File>();
////    	listf(env.getProperty("xmlfile.dir"),files);
//        String root = getClass().getResource("/xmlfiles").toString();
//        listf(root.substring(root.indexOf(":") + 1), files);
//        for (File file : files) {
//            if (fileName.equals(file.getName())) {
//                filePath = file.getAbsolutePath();
//            }
//        }
//        return filePath;
//    }
//
//    private static void listf(String directoryName, List<File> files) {
//        File directory = new File(directoryName);
//
//        // Get all files from a directory.
//        File[] fList = directory.listFiles();
//        if (fList != null) {
//            for (File file : fList) {
//                if (file.isFile()) {
//                    files.add(file);
//                } else if (file.isDirectory()) {
//                    listf(file.getAbsolutePath(), files);
//                }
//            }
//        }
//    }
}
