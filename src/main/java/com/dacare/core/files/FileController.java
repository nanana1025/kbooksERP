package com.dacare.core.files;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.dacare.core.xmlvo.data.DataRoot;
import com.dacare.util.Utils;
import com.dacare.util.constant.Cubrid;
import com.dacare.util.constant.MariaDB;
import com.dacare.util.constant.Oracle;
import com.dacare.util.map.LowerKeyMap;
import com.dacare.util.vo.User;

@RestController
public class FileController {
    private static final Logger logger = LoggerFactory.getLogger(FileController.class);

    @Autowired
    private FileStorageService fileStorageService;

    @Autowired
    FileMapper fileMapper;

    @Autowired
    private Environment env;


//
//    @Value("${spring.datasource.dbtype}")
//	String dbType;
//
//
//    @RequestMapping("/fileTest.do")
//    public ModelAndView fileTest(@RequestParam Map<String,Object> params) throws Exception {
//        ModelAndView mav = new ModelAndView();
//        mav.setViewName("core/fileTest");
//
//        return mav;
//    }
//
//    @PostMapping("/uploadFile")
//    public UploadFileResponse uploadFile(@RequestParam("file") MultipartFile file) {
//        Map<String, Object> result = fileStorageService.storeFile(file, null);
//
//        String fileName =  FilenameUtils.getName((String)result.get("fileName"));
//
//        String fileDownloadUri = ServletUriComponentsBuilder.fromCurrentContextPath()
//                .path("/downloadFile/")
//                .path(fileName)
//                .toUriString();
//
//        return new UploadFileResponse(fileName, fileDownloadUri, file.getContentType(), file.getSize());
//    }
//
//    @PostMapping("/uploadMultipleFiles")
//    public List<UploadFileResponse> uploadMultipleFiles(@RequestParam("files") MultipartFile[] files) {
//        return Arrays.asList(files)
//                .stream()
//                .map(file -> uploadFile(file))
//                .collect(Collectors.toList());
//    }
//
//    @GetMapping("/downloadFile/{fileName:.+}")
//    public ResponseEntity<Resource> downloadFile(@PathVariable String fileName, HttpServletRequest request) {
//        // Load file as Resource
//    	System.out.println("FileController.downloadFile");
//        Resource resource = fileStorageService.loadFileAsResource(fileName);
//
//        // Try to determine file's content type
//        String contentType = null;
//        try {
//            contentType = request.getServletContext().getMimeType(resource.getFile().getAbsolutePath());
//        } catch (IOException ex) {
//            logger.info("Could not determine file type.");
//        }
//
//        // Fallback to the default content type if type could not be determined
//        if(contentType == null) {
//            contentType = "application/octet-stream;charset=UTF-8";
//        }
//
//        try {
//            fileName = getDisposition(fileName, getBrowser(request));
//        } catch (Exception e) {
//            throw new RuntimeException("fileName encoding error !!");
//        }
//
//        return ResponseEntity.ok()
//                .contentType(MediaType.parseMediaType(contentType))
//                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
//                .body(resource);
//    }
//
//    @GetMapping("/downloadInventoryCheckFile/{fileName:.+}")
//    public ResponseEntity<Resource> downloadInventoryCheckFile(@PathVariable String fileName, HttpServletRequest request) {
//        // Load file as Resource
//    	System.out.println("FileController.downloadInventoryCheckFile");
//
//    	Map<String, Object> sqlMaps = new HashMap<String, Object>();
//
//    	sqlMaps = fileMapper.getInventoryCheckLatestFile();
//    	String extension = FilenameUtils.getExtension(fileName);
//    	String fileNm = FilenameUtils.getBaseName(fileName);
//    	fileName = fileNm+"_"+sqlMaps.get("VERSION").toString()+"."+extension;
//
//
//        Resource resource = fileStorageService.loadFileAsResource(fileName);
//
//        // Try to determine file's content type
//        String contentType = null;
//        try {
//            contentType = request.getServletContext().getMimeType(resource.getFile().getAbsolutePath());
//        } catch (IOException ex) {
//            logger.info("Could not determine file type.");
//        }
//
//        // Fallback to the default content type if type could not be determined
//        if(contentType == null) {
//            contentType = "application/octet-stream;charset=UTF-8";
//        }
//
//        try {
//            fileName = getDisposition(fileName, getBrowser(request));
//        } catch (Exception e) {
//            throw new RuntimeException("fileName encoding error !!");
//        }
//
//        return ResponseEntity.ok()
//                .contentType(MediaType.parseMediaType(contentType))
//                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
//                .body(resource);
//    }
//
//    private String getBrowser(HttpServletRequest request) {
//        String header = request.getHeader("User-Agent");
//        if (header.indexOf("MSIE") > -1) {
//            return "MSIE";
//        } else if (header.indexOf("Chrome") > -1) {
//            return "Chrome";
//        } else if (header.indexOf("Opera") > -1) {
//            return "Opera";
//        } else if (header.indexOf("Trident/7.0") > -1){
//            //IE 11 이상 //IE 버전 별 체크 >> Trident/6.0(IE 10) , Trident/5.0(IE 9) , Trident/4.0(IE 8)
//            return "MSIE";
//        }
//
//        return "Firefox";
//    }
//
//    private String getDisposition(String filename, String browser) throws Exception {
//        String encodedFilename = null;
//        if (browser.equals("MSIE")) {
//            encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
//        } else if (browser.equals("Firefox")) {
//            encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
//        } else if (browser.equals("Opera")) {
//            encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
//        } else if (browser.equals("Chrome")) {
//            StringBuffer sb = new StringBuffer();
//            for (int i = 0; i < filename.length(); i++) {
//                char c = filename.charAt(i);
//                if (c > '~') {
//                    sb.append(URLEncoder.encode("" + c, "UTF-8"));
//                } else {
//                    sb.append(c);
//                }
//            }
//            encodedFilename = sb.toString();
//        } else {
//            throw new RuntimeException("Not supported browser");
//        }
//
//        return encodedFilename;
//    }
//
//    private String getFilePath(String fileName) {
//    	String filePath = "";
//    	List<File> files = new ArrayList<File>();
//    	String root = getClass().getResource("/xmlfiles").toString();
//    	listf(root.substring(root.indexOf(":")+1),files);
//    	for(File file : files){
//    		if(fileName.equals(file.getName())){
//    			filePath = file.getAbsolutePath();
//    		}
//    	}
//		return filePath;
//	}
//
//    private void listf(String directoryName, List<File> files) {
//        File directory = new File(directoryName);
//
//        // Get all files from a directory.
//        File[] fList = directory.listFiles();
//        if(fList != null){
//            for (File file : fList) {
//                if (file.isFile()) {
//                    files.add(file);
//                } else if (file.isDirectory()) {
//                    listf(file.getAbsolutePath(), files);
//                }
//            }
//        }
//    }
//
//
//    @GetMapping("/download.json")
//    public UploadFileResponse downloadFileJson(@RequestParam Map<String,Object> params) throws Exception {
//
//        String fileName = (String) params.get("fileName");
//        String fileDownloadUri = ServletUriComponentsBuilder.fromCurrentContextPath()
//                .path("/downloadFile/")
//                .path(fileName)
//                .toUriString();
//        return new UploadFileResponse(fileName, fileDownloadUri, "MultipartFile", 0);
//    }
//
//    @GetMapping("/downloadDirect.json")
//    public ResponseEntity<Resource> downloadDirectFileJson(@RequestParam Map<String,Object> params, HttpServletRequest request) throws Exception {
////        String fileName = Utils.decodeJavascriptString((String) params.get("fileName"));
//        String fileId = Utils.decodeJavascriptString((String) params.get("fileId"));
//        String[] fileIdArr = fileId.split("_");
//        Map<String,Object> sParam = new HashMap<String,Object>();
//        sParam.put("FILE_ID", fileIdArr[0]);
//        sParam.put("FILE_SEQ", fileIdArr[1]);
//
//        LowerKeyMap fileInfo = fileMapper.getFileInfoById(sParam);
//        String fileName = fileId + "." + (String)fileInfo.get("file_type");
//        String orgFileName = (String)fileInfo.get("file_nm");
//        orgFileName = new String(orgFileName.getBytes("UTF-8"), "ISO-8859-1");
//
//        // Load file as Resource
//        Resource resource = fileStorageService.loadFileAsResource(fileName);
//
//        // Try to determine file's content type
//        String contentType = null;
//        try {
//            contentType = request.getServletContext().getMimeType(resource.getFile().getAbsolutePath());
//        } catch (IOException ex) {
//            logger.info("Could not determine file type.");
//        }
//
//        // Fallback to the default content type if type could not be determined
//        if(contentType == null) {
//            contentType = "application/octet-stream;charset=UTF-8";
//        }
//
//
//        try {
//        	fileId = getDisposition(fileId, getBrowser(request));
//        } catch (Exception e) {
//            throw new RuntimeException("fileName encoding error !!");
//        }
//
//        return ResponseEntity.ok()
//                .contentType(MediaType.parseMediaType(contentType))
//                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + orgFileName + "\"")
//                .body(resource);
//    }
//
////    @PostMapping("/remove.json")
////    public void removeFileJson(@RequestParam Map<String,Object> params) throws Exception {
////
////    	if(params.get("sid") == null || "".equals(params.get("sid").toString())) {
////            throw new Exception("============ [SID is null] ============");
////        }
////        String[] objectIds = null;
////        List<ListColumn> selectColumns;
////        List<CrudColumn> viewColumns;
////        ListItem listItem = null;
////        CrudItem crudItem = null;
////        String objectId = (String)params.get("OBJ_ID");
////        String fileCol = (String)params.get("FILE_COL");
////        String tableId = (String)params.get("TABLE_ID");
////
////        String fileNm = params.get("sid").toString().trim() + "_LIST.xml";
////        String filePath = getFilePath(fileNm);
////        if(Utils.fileCheck(filePath)) {
//////            throw new Exception("등록된 LIST XML 파일이 없습니다.");
////	        ListObject listObject = Utils.getListXmlToObject(filePath);
////
////	        for(ListItem item : listObject.listItem) {
////	            if(params.get("sid").equals(item.getSid())) {
////	                listItem = item;
////	                objectIds = listItem.getObjectid().split(",");
////	            }
////	        }
////        } else {
////        	fileNm = params.get("sid").toString().trim() + "_CRUD.xml";
////        	filePath = getFilePath(fileNm);
////        	if(Utils.fileCheck(filePath)){
////        		CrudObject crudObject = Utils.getCrudXmlToObject(filePath);
////
////        		for(CrudItem item : crudObject.cruditem){
////        			crudItem = item;
////        			objectIds = crudItem.getObjectid().split(",");
////        		}
////        	}
////        }
////
////        String[] objKeyVals = objectId.split(",");
////        //파일수정&삭제
////    	Map<String,Object> dParam = new HashMap<>();
////    	dParam.put("TABLE_ID", tableId);
////    	dParam.put("FILE_COL", fileCol);
////    	dParam.put("FILE_ID", params.get("FILE_ID"));
////        String where = "WHERE ";
////        for(int i=0;i<objectIds.length;i++){
////        	dParam.put(objectIds[i], objKeyVals[i]);
////        	where += objectIds[i] + " = " + "'" + objKeyVals[i] + "'";
////        	if(i != objectIds.length -1){
////        		where += " AND ";
////        	}
////        }
////        dParam.put("WHERE", where);
////
////        List<LowerKeyMap> fileName = fileMapper.getFileNameBySql(dParam);
////        int fileCnt = fileMapper.selectFileCnt(dParam);
////        if(fileCnt == 0)
////        	fileMapper.deleteRawData(dParam);
////
////    	fileMapper.deleteFileData(dParam);
////    	for(int i=0; i<fileName.size(); i++){
////    		LowerKeyMap file = fileName.get(i);
////    		fileStorageService.deleteFile((String)file.get("FILE_NM"));
////    	}
////    	return;
////    }
////
//
//    @PostMapping("/uploadInsert.json")
//    @ResponseBody
//    public Map<String,Object> uploadInsertFile(@RequestParam(value="files[]", required=false) List<MultipartFile> files, HttpServletRequest req, @RequestParam Map<String,Object> params) throws Exception {
//
//    	if(params.get("xn") == null || "".equals(params.get("xn").toString())) {
//            throw new Exception("============ [xn is null] ============");
//        }
//
////        String[] objectIds = null;
//        String tableId = "";
//        Map<String,Object> rtnMap = new HashMap<String,Object>();
//        String fileColArr =(String)params.get("FILE_COL");
//        String[] fileCol = fileColArr.split(",");
//
//        String fileNm = params.get("xn").toString() + ".xml";
//        String filePath = Utils.getFilePath(fileNm);
//        if("ADM".equals(req.getSession().getAttribute("SESSION_USER_TYPE"))) {
//	    	  filePath = Utils.getAdmXmlPath(fileNm);
//	    }
//    	if(Utils.fileCheck(filePath)){
//    		DataRoot dataObject = Utils.getDataXmlToObject(filePath);
//
////			objectIds = dataObject.getObject().split(",");
//			tableId = dataObject.getTable();
//    	}
//
//        String userId = "0";
//        HttpSession session = req.getSession();
//        User userInfo = (User) session.getAttribute("userInfo");
//        if(userInfo != null) {
//        	userId = userInfo.getUser_id();
//        }
//
////        int fileIdSeq = fileMapper.fileDataSeq();
//        int fileIdSeq = 0;
//        String prevFileCol = null;
//        for(int z=0; z<files.size(); z++){
//        	// 파일컬럼 달라지는 경우 시퀀스 증가
//        	if(prevFileCol != null && !prevFileCol.equals(fileCol[z])) {
//        		fileIdSeq = 0;
//        	}
//        	if(params.get(fileCol[z]) != null && !"".equals(params.get(fileCol[z]))){
//        		fileIdSeq = Integer.parseInt((String)params.get(fileCol[z]));
//        	} else if(fileIdSeq == 0){
//        		if ("CUBRID".equalsIgnoreCase(dbType)) {
//    				fileIdSeq = fileMapper.fileDataSeq();
//    			} else if ("ORACLE".equalsIgnoreCase(dbType)) {
//    				fileIdSeq = fileMapper.fileDataOracleSeq();
//    			} else if ("MARIADB".equalsIgnoreCase(dbType)) {
//    				fileIdSeq = fileMapper.fileDataOracleSeq();
//    			}
//        	}
//    		int fileSeq = fileMapper.fileSeq(fileIdSeq);
//
//        	MultipartFile file = files.get(z);
//
//	        //파일저장
//        	String svrFileName = fileIdSeq + "_" + fileSeq;
//        	Map<String, Object> result = fileStorageService.storeFile(file, svrFileName);
////            String fileName =  FilenameUtils.getName((String)result.get("fileName"));
//            String orgFileName =  FilenameUtils.getName((String)result.get("orgFileName"));
//	        String path = FilenameUtils.getFullPath((String)result.get("path"));
//	        String fileType = (String)result.get("fileType");
//
//	        //DB저장
//	        Map<String,Object> sParam = new HashMap<>();
////	        sParam.put("TABLE_ID", tableId);
//	        sParam.put("TABLE_NM", tableId);
//	        sParam.put("FILE_SEQ", fileSeq);
////	        String where = "WHERE ";
////	        for(int i=0;i<objectIds.length;i++){
////	        	sParam.put(objectIds[i], params.get(objectIds[i]));
////	        	where += objectIds[i] + " = " + "'" + params.get(objectIds[i]) + "'";
////	        	if(i != objectIds.length -1){
////	        		where += " AND ";
////	        	}
////	        }
//	        sParam.put("FILE_NM", orgFileName);
//	        sParam.put("FILE_TYPE", fileType);
//	        sParam.put("FILE_PATH", path);
//	        sParam.put("CREATE_ID", userId);
//
//	    	sParam.put("FILE_ID", fileIdSeq);
//	    	String datetime = "";
//			if ("CUBRID".equalsIgnoreCase(dbType)) {
//				datetime = Cubrid.DATETIME;
//			} else if ("ORACLE".equalsIgnoreCase(dbType)) {
//				datetime = Oracle.DATE;
//			} else if ("MARIADB".equalsIgnoreCase(dbType)) {
//				datetime = MariaDB.DATETIME;
//			}
//			sParam.put("SYSDATETIME", datetime);
//
//	    	fileMapper.saveFileData(sParam);
//
//	    	rtnMap.put(fileCol[z], fileIdSeq);
//
//	    	//이전값 저장
//	    	prevFileCol = fileCol[z];
//        }
//
//        return rtnMap;
//    }
//
//    public void removeFileById(@RequestParam Map<String,Object> params) throws Exception {
//
//    	if(params.get("FILE_ID") == null || "".equals(params.get("FILE_ID").toString())) {
//            throw new Exception("============ [FILE_ID is null] ============");
//        }
//
//    	Map<String,Object> dParam = new HashMap<>();
//    	dParam.put("FILE_ID", params.get("FILE_ID"));
//
//        List<LowerKeyMap> fileName = fileMapper.getFileNameBySql(dParam);
//    	fileMapper.deleteFileData(dParam);
//    	for(int i=0; i<fileName.size(); i++){
//    		LowerKeyMap file = fileName.get(i);
//    		fileStorageService.deleteFile((String)file.get("FILE_NM"));
//    	}
//    	return;
//    }
//
//    @GetMapping("/removeFileInView.json")
//    public void removeFileInViewJson(@RequestParam Map<String,Object> params, HttpServletRequest req) throws Exception {
//    	if(params.get("xn") == null || "".equals(params.get("xn").toString())) {
//            throw new Exception("============ [xn is null] ============");
//        }
//
//        String[] objectIds = ((String)params.get("OBJ_ID")).split(",");
//        String fileCol = (String)params.get("FILE_COL");
//        String[] objKeyVals = ((String)params.get("OBJ_KEY_VAL")).split(",");
//        String tableId = "";
//
//        String fileNm = params.get("xn").toString().trim() + ".xml";
//	    fileNm = fileNm.replaceAll("(?i)LIST", "DATA");
//        String filePath = Utils.getFilePath(fileNm);
//        if("ADM".equals(req.getSession().getAttribute("SESSION_USER_TYPE"))) {
//	    	  filePath = Utils.getAdmXmlPath(fileNm);
//	    }
//    	if(Utils.fileCheck(filePath)){
//    		DataRoot dataObject = Utils.getDataXmlToObject(filePath);
//
//			tableId = dataObject.getTable();
//    	}
//
//        //파일수정&삭제
//    	Map<String,Object> dParam = new HashMap<>();
//    	dParam.put("TABLE_ID", tableId);
//    	dParam.put("FILE_COL", fileCol);
//        String where = "WHERE ";
//        for(int i = 0; i < objectIds.length; i++) {
//        	dParam.put(objectIds[i], objKeyVals[i]);
//        	where += objectIds[i] + " = " + "'" + objKeyVals[i] + "'";
//
//        	if(i != objectIds.length -1)
//        		where += " AND ";
//        }
//
//        dParam.put("WHERE", where);
//
//        //파일ID 조회
//    	String fileId = fileMapper.getFileIdBySql(dParam);
//    	dParam.put("FILE_ID", fileId);
//    	dParam.put("FILE_SEQ", params.get("FILE_SEQ"));
//
//        List<LowerKeyMap> fileName = fileMapper.getFileNameBySql(dParam);
//        int fileCnt = fileMapper.selectFileCnt(dParam);
//        if(fileCnt == 0)
//        	fileMapper.deleteRawData(dParam);
//
//    	fileMapper.deleteFileData(dParam);
//    	for(int i=0; i<fileName.size(); i++){
//    		LowerKeyMap file = fileName.get(i);
//    		fileStorageService.deleteFile((String)file.get("FILE_NM"));
//    	}
//    	return;
//    }
}
