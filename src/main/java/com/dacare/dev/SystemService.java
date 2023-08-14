package com.dacare.dev;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

@Service
public class SystemService {
    @Autowired
    SystemMapper systemMapper;
    
    @Value(value="${system.xml.path}")
    private String xmlRootPath;

    public int saveSystemInfo(Map<String,Object> params) throws Exception {
        return systemMapper.saveSystemInfo(params);
    }

    public int updateSystemInfo(Map<String,Object> params) throws Exception {
        return systemMapper.updateSystemInfo(params);
    }

    public String getSystemId() throws Exception {
        return systemMapper.getSystemId();
    }

    public Map<String,Object> getSystemInfoList(Map<String,Object> params) throws Exception {
        return systemMapper.getSystemInfoList(params);
    }

    public int getSystemInfoCnt() throws Exception {
        return systemMapper.getSystemInfoCnt();
    }

    public int updateMenuInfo(Map<String,Object> params) throws Exception {
        return systemMapper.updateMenuInfo(params);
    }

    public int deleteImgInfo(Map<String,Object> params) throws Exception {
        return systemMapper.deleteImgInfo(params);
    }

    public List<Map<String,Object>> getXmlList(Map<String,Object> params) throws Exception {
    	String filePath = "/xmlfiles";
        if("ADMIN".equals(params.get("xmlOwner"))) {
        	filePath = "/adminXml";
        }
        List<File> files = new ArrayList<File>();
        ClassPathResource resource = new ClassPathResource(xmlRootPath+filePath);
        String path = resource.getPath();
        File directory = new File(path);
        File[] fList = directory.listFiles();
        if(fList == null || fList.length==0) {
        	path = this.getClass().getResource(xmlRootPath+filePath).getPath();
        }
        directory = new File(path);
        fList = directory.listFiles();
        for(File f : fList) {
        	System.out.println(f.getAbsolutePath());
        }
        if(fList != null){
            for (File file : fList) {
                if (file.isFile()) {
                    files.add(file);
                } else if(file.isDirectory()) {
                	files.add(file);
                	listf(file.getAbsolutePath(),files);
                }
            }
        }
        List<Map<String,Object>> result = new ArrayList<Map<String,Object>>();
        
        if("ADMIN".equals(params.get("xmlOwner"))) {
        	Map<String,Object> topMap = new HashMap<String,Object>();
        	topMap.put("SCRN_TYPE", "ROOT");
        	topMap.put("XML_FOLDER", "/");
        	topMap.put("XML_FILE_NM", "adminXml");
        	topMap.put("XN", "ROOT");
    		topMap.put("LINK", null);
    		topMap.put("id", "/adminXml/");
    		topMap.put("parentId", null);
    		result.add(topMap);
        }  else {
        	Map<String,Object> topMap = new HashMap<String,Object>();
        	topMap.put("SCRN_TYPE", "ROOT");
        	topMap.put("XML_FOLDER", "/");
        	topMap.put("XML_FILE_NM", "xmlfiles");
        	topMap.put("XN", "ROOT");
    		topMap.put("LINK", null);
    		topMap.put("id", "/xmlfiles/");
    		topMap.put("parentId", null);
    		result.add(topMap);
        }
        
        int id = 0;
        for(File xmlFile : files) {
        	Map<String,Object> map = new HashMap<String,Object>();
        	String fileName = FilenameUtils.getName(xmlFile.getName());
        	String fileFolder = FilenameUtils.getPath(xmlFile.getPath());
        	String separator = "\\xmlfiles\\";
        	if("ADMIN".equals(params.get("xmlOwner"))) {
        		separator = "\\adminXml\\";
            }
        	fileFolder = fileFolder.substring(fileFolder.indexOf(separator));
        	fileFolder = fileFolder.replaceAll("\\\\", "/");
        	String xmlOwner = (String)params.get("xmlOwner");
        	String fileType = "";
        	if(xmlFile.isFile()) {
        		if(!fileName.contains(".")) {
        			fileType = "확장자가 없습니다. 삭제 후 재작성하세요.";
        		} else {
        			fileType = fileName.substring(fileName.lastIndexOf("_")+1, fileName.lastIndexOf(".")).toUpperCase();
        		}
        	} else if(xmlFile.isDirectory()) {
        		fileType = "FOLDER";
        	}
        	String link = "";
        	if(fileType.equals("LAYOUT")) {
        		link = "/layout.do?xn="+FilenameUtils.getBaseName(fileName);
        	} else if(fileType.equals("LIST")) {
        		link = "/list.do?xn="+FilenameUtils.getBaseName(fileName);
        	} else if(fileType.equals("DATA")) {
        		link = "/dataView.do?xn="+FilenameUtils.getBaseName(fileName);
        	}else if(fileType.equals("TREE")) {
        		link = "/tree.do?xn="+FilenameUtils.getBaseName(fileName);
        	}
        	map.put("SCRN_TYPE", fileType);
        	map.put("XML_FOLDER", fileFolder);
        	map.put("XML_FILE_NM", fileName);
        	map.put("XN", FilenameUtils.getBaseName(fileName));
        	if("LAYOUT".equals(fileType)) {
        		map.put("LINK", link);
        	} else {
        		map.put("LINK", null);
        	}
        	if("/xmlfiles/".equals(fileFolder) && xmlFile.isFile()) {
        		map.put("id", "-1");
        	} else if(xmlFile.isDirectory()){
        		map.put("id", fileFolder+fileName+"/");
        	} else {
        		map.put("id", id);
        		id++;
        	}
    		map.put("parentId", fileFolder);
        	result.add(map);
        }
        
        return result;
    }

    public int deleteXml(Map<String,Object> params) throws Exception {
        return systemMapper.deleteXml(params);
    }

    public void saveLog(Map<String,Object> params) throws Exception {
        systemMapper.saveLog(params);
    }
    
    public SystemService() {
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
                	files.add(file);
                    listf(file.getAbsolutePath(), files);
                }
            }
        }
    }
}
