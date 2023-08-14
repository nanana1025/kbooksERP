package kbookERP.core.files;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

//@Service
public class FileStorageService {
//    private Path fileStorageLocation = null;

//    @Value("${file.upload-dir}")
//    private String uploadPath;

//    @Autowired
//    public FileStorageService(FileStorageProperties fileStorageProperties) {
//        this.fileStorageLocation = Paths.get(fileStorageProperties.getUploadDir()).toAbsolutePath().normalize();
//
//        try {
//            Files.createDirectories(this.fileStorageLocation);
//        } catch(Exception ex) {
//            throw new FileStorageException("Could not create the directory where the uploaded files will be stored.", ex);
//        }
//    }

//    public Map<String,Object> storeFile(MultipartFile file, String svrFileName) {
//        String fileName = FilenameUtils.getName(file.getOriginalFilename());
//        String orgFileName = FilenameUtils.getName(file.getOriginalFilename());
////        String baseName = FilenameUtils.getBaseName(file.getOriginalFilename());
//        String extension = FilenameUtils.getExtension(file.getOriginalFilename());
//        Map<String,Object> result = new HashMap<String,Object>();
//        try  {
//            if(fileName.contains("..")) {
//                throw new FileStorageException("Sorry! Filename contains invalid path sequence " + fileName);
//            }
//
//            Path targetLocation = this.fileStorageLocation.resolve(fileName);
////            while(Files.exists(targetLocation, LinkOption.NOFOLLOW_LINKS)) {
////                baseName = baseName +"_"+ Calendar.getInstance().getTimeInMillis();
////                fileName = baseName + "." + extension;
//                fileName = svrFileName + "." + extension;
//                targetLocation = this.fileStorageLocation.resolve(fileName);
//                result.put("fileName", fileName);
//                result.put("orgFileName", orgFileName);
//                result.put("fileType", extension);
//                result.put("path", targetLocation.toString());
////            }
//            InputStream fi = file.getInputStream();
//            Files.copy(fi, targetLocation, StandardCopyOption.REPLACE_EXISTING);
//            fi.close();
//
//            return result;
//        } catch(IOException ex) {
//            throw new FileStorageException("Could not store file " + fileName + ". Please try again!", ex);
//        }
//    }

//    public void deleteFile(String fileName) throws IOException {
//    	String path = uploadPath + "/" + fileName;
//    	File file = new File(path);
//    	Path filePath = file.toPath();
//    	if(file.exists()){
////    		boolean result = file.delete();
//    		Files.delete(filePath);
////    		System.out.println(result);
//    	}
//    }

//    public Resource loadFileAsResource(String fileName) {
//        try {
////        	System.out.println("fileName = "+fileName);
//            Path filePath = Paths.get(fileName);
////            System.out.println("filePath = "+filePath);
//            Resource resource = new UrlResource(filePath.toUri());
//            if(resource.exists()) {
//                return resource;
//            } else {
//                throw new KFileNotFoundException("File not found " + fileName);
//            }
//        } catch(MalformedURLException ex) {
//            throw new KFileNotFoundException("File not found " + fileName);
//        }
//    }

}
