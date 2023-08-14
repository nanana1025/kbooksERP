package com.dacare.custom.api;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.mysql.jdbc.StringUtils;

@Component
public class APILog {

	@Value("${file.log.dir}")
    private String _fileLogDir;

	@Value("${logDirLink}")
    private String _logDirLink;

	@Value("${logLink}")
    private String _logLink;

	DateTimeFormatter _formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
	DateTimeFormatter _formatterFull = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

	@SuppressWarnings("unused")
	public String CheckLogFilePath(String path){
		String fullPath = "";

		// 현재 날짜 구하기
		LocalDate now = LocalDate.now();
		// 포맷 적용
		String formatedNow = now.format(_formatter);

		if(_logDirLink.equals("1")) fullPath= _fileLogDir+"\\"+path+formatedNow+".log";
		else fullPath = _fileLogDir+"/"+path+formatedNow+".log";

//	    System.out.println("fullPath = "+fullPath);

		File file = new File(fullPath);

		if (!file.exists()) {//파일 없음
			try{
				if(file.createNewFile()){    //파일이 생성되는 시점
					return fullPath;
				}else {
					return null;
				}
			}
			catch(Exception e){
				e.getStackTrace();
				return null;
			}
		}else {//파일 있음
			return fullPath;
		}
	}

	@SuppressWarnings("unused")
	public void WrileLogWithTime(String path, StringBuilderPlus content, Boolean success){
		if(!StringUtils.isNullOrEmpty(path)) {
			// 현재 날짜 구하기
			LocalDateTime  now = LocalDateTime .now();
			// 포맷 적용
			String formatedNow = now.format(_formatterFull);

			File file = new File(path);

			try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
			    if(success) writer.append("[success] "+formatedNow);
			    else writer.append("[fail] "+formatedNow);
			    writer.append("\r\n\r\n");
//				writer.append(formatedNow);
			    writer.append(content.toString());
	//		    writer.append("\r\n");
			} catch (IOException e) {
			    e.printStackTrace();
			}
		}
	}

	@SuppressWarnings("unused")
	public void WrileLogWithoutTime(String path, StringBuilderPlus content, Boolean success){
		if(!StringUtils.isNullOrEmpty(path)) {
			File file = new File(path);

			try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
			  if(success) writer.append("[success]");
			    else writer.append("[fail]");
			  writer.append("\r\n\r\n");
				writer.append(content.toString());
	//		    writer.append("\n");
			} catch (IOException e) {
			    e.printStackTrace();
			}
		}
	}






}
