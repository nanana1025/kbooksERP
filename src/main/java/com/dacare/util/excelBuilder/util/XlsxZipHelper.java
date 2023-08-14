package com.dacare.util.excelBuilder.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;

import com.dacare.util.excelBuilder.internal.workbook.SheetInfo;

/**
 * XlsxZipHelper (xlsx의 압축파일 처리를 위한 헬퍼 클래스)
 *
 * <pre>
 *  ■ 변경이력
 *
 *  버전    변경일자    작업자      수정내용
 *  ----    --------    --------    -------------------------------------------
 *  v2.0    20190510	박주의		최초작성 (SAX 기반으로 처리)
 *
 * </pre>
 *
 * @author 박주의
 * @version v2.0
 *
 */
public class XlsxZipHelper {

	/**
	 * 압축파일에서 필요한 파일을 추출
	 *
	 * @param zipfile ; 압축파일
	 * @param extractFile ; 압축파일에서 추출할 파일
	 * @param entry ; 압축파일에서 추출할 파일경로
	 * @throws IOException
	 */
	public static void extractEntry(File zipfile, File extractFile, String entry) throws IOException  {
		FileOutputStream fos = null;
		ZipFile zip = new ZipFile(zipfile);
		try {
			fos = new FileOutputStream(extractFile);
			Enumeration<? extends ZipEntry> en = zip.entries();
			while (en.hasMoreElements()) {
				ZipEntry ze = en.nextElement();
				if (ze.getName().equals(entry)) {
					InputStream is = zip.getInputStream(ze);
					XlsxZipHelper.copyStream(is, fos);
					is.close();
					break;
				}
			}
		} finally {
			if (zip != null) {
				zip.close();
			}
			if (fos != null) {
				fos.close();
			}
		}
	}

	/**
	 * 시트정보를 이용해서 workFile 의 정보중 수정된 xml 파일들을 갱신하고 savaFile 로 저장
	 *
	 * @param workFile ; 원본파일
	 * @param saveFile ; 출력파일
	 * @param sheetList ; 수정작업을 할 entry경로 및 파일정보를 담은 시트 리스트정보
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	public static void updateEntry (File workFile, File saveFile, List<SheetInfo> sheetList) throws FileNotFoundException, IOException {

		// 변경된 내용에 대한 엔트리셋 생성
		HashSet<String> entrySet = new HashSet<String>();
		for (int i = 0; i < sheetList.size(); i++) {
			SheetInfo si = sheetList.get(i);
			File tmpFile = si.getTempXmlFile();
			if (tmpFile != null) {
				String sheetEntry = si.getSheetRef();
				if (StringUtils.isNotBlank(sheetEntry)) {
					entrySet.add(sheetEntry);
				}
				String drawEntry = si.getRelDrawRef();
				if (StringUtils.isNotBlank(drawEntry)) {
					entrySet.add(drawEntry);
				}
			}
		}

		FileOutputStream out = null;
		ZipFile zip = null;
		ZipOutputStream zos = null;
		try {

			/*
			if(!saveFile.setWritable(true, true)){
				System.out.println("Could not set Writable permissions");
			}
			if(!saveFile.setReadable(true, true)){
				System.out.println("Could not set Readable permissions");
			}
			if(!saveFile.setExecutable(true, true)){
				System.out.println("Could not set Executable permissions");
			}
			*/
			zip = new ZipFile(workFile);
			out = new FileOutputStream(saveFile);
			zos = new ZipOutputStream(out);

			// 기존내용 중에서 변경된 시트내용을 제외하고 압축파일에 추가
			Enumeration<? extends ZipEntry> en = zip.entries();
			while (en.hasMoreElements()) {
				ZipEntry ze = en.nextElement();

				if (!entrySet.contains(ze.getName())) {
					zos.putNextEntry(new ZipEntry(ze.getName()));
					InputStream is = zip.getInputStream(ze);
					XlsxZipHelper.copyStream(is, zos);
					is.close();
				}
			}

			// 변경된 시트 내용을 압축파일에 추가
			for (int i = 0; i < sheetList.size(); i++) {
				SheetInfo si = sheetList.get(i);

				String tmpEntry = si.getSheetRef();
				File tmpFile = si.getTempXmlFile();
				putEntry(zos, tmpFile, tmpEntry);

				String drawEntry = si.getRelDrawRef();
				File drawFile = si.getRelDrawFile();
				putEntry(zos, drawFile, drawEntry);
			}
		} finally {
			if (zos != null) {
				zos.close();
			}
			if (zip != null) {
				zip.close();
			}
			if (out != null) {
				out.close();
			}

			// 최종 중간 작업파일 삭제
			FileUtils.deleteQuietly(workFile);
		}
	}

	/**
	 * 지정된 엔트리로 변경처리
	 *
	 * @param zos
	 * @param si
	 * @param entry
	 * @return
	 * @throws IOException
	 * @throws FileNotFoundException
	 */
	private static File putEntry(ZipOutputStream zos, File file, String entry) throws IOException, FileNotFoundException {
		if (file != null) {
			zos.putNextEntry(new ZipEntry(entry));
			InputStream is = new FileInputStream(file);
			copyStream(is, zos);
			is.close();
			FileUtils.deleteQuietly(file);
		}
		return file;
	}

	/**
	 * 스트림 복사 메소드
	 *
	 * @param in 입력스트림
	 * @param out 출력스트림
	 * @throws IOException I/O예외
	 */
	public static void copyStream(InputStream in, OutputStream out) throws IOException {
		byte[] chunk = new byte[1024];
		int count;
		while ((count = in.read(chunk)) >= 0) {
			out.write(chunk, 0, count);
		}
	}

	/**
	 * 작업을 위해서 임시로 생성했던 시트파일을 삭제
	 *
	 * @param sheetList ; temp 파일정보를 담은 시트 리스트정보
	 * @throws FileNotFoundException
	 * @throws IOException
	 */
	public static void clearTempEntry (List<SheetInfo> sheetList) throws FileNotFoundException, IOException {
		// 작업을 위한 템프파일을 삭제
		for (int i = 0; i < sheetList.size(); i++) {
			SheetInfo si = sheetList.get(i);

			File tmpFile = si.getTempXmlFile();
			if (tmpFile != null) {
				FileUtils.deleteQuietly(tmpFile);
			}

			File drawFile = si.getRelDrawFile();
			if (drawFile != null) {
				FileUtils.deleteQuietly(drawFile);
			}
		}
	}
}
