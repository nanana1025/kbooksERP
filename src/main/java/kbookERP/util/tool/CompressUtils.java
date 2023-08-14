package kbookERP.util.tool;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Stack;

import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipArchiveInputStream;
import org.apache.commons.compress.archivers.zip.ZipArchiveOutputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * <pre>
 *  Class Name : CompressUtils.java
 *  Description : commons compress lib util class
 *                from http://javafreak.tistory.com/226
 *
 *  Modification Information
 *
 *    수정일     	수정자                   수정내용
 *   -------        --------    ---------------------------
 *  2014. 1. 2.	gochigoD01		최초작성
 *
 * </pre>
 *  @author  gochigoD01
 *  @created 2014. 1. 2.
 *  @version 1.0
 *  @see
 *
 */
public class CompressUtils {
	private static final Logger log = LoggerFactory.getLogger(CompressUtils.class);

	/**
	 * 원래는 UTF-8을 사용했으나 사용자가 데스크탑에서 압축프로그램(반디집만 테스트)으로 압축한 파일은 EUC-KR을 써야 파일명의 한글이 안깨진다.
	 */
	public static final String CHARSET = "EUC-KR";

	public static void unzip(File zippedFile) throws IOException {
		unzip(zippedFile, CHARSET);
	}

	public static void unzip(File zippedFile, String charsetName ) throws IOException {
		unzip(zippedFile, zippedFile.getParentFile(), charsetName);
	}

	public static void unzip(File zippedFile, File dstDir) throws IOException {
		unzipPro(new FileInputStream(zippedFile), dstDir, CHARSET);
	}

	public static void unzip(File zippedFile, File dstDir, String charsetName) throws IOException {
		unzipPro(new FileInputStream(zippedFile), dstDir, charsetName);
	}

	public static void unzip(InputStream is, File dstDir) throws IOException{
		unzipPro(is, dstDir, CHARSET);
	}

	public static void unzipPro( InputStream is, File dstDir, String charsetName) throws IOException {
		ZipArchiveInputStream zis ;
		ZipArchiveEntry entry ;
		String name ;
		File target ;
		int nWritten = 0;
		BufferedOutputStream bos ;
		byte [] buf = new byte[1024 * 8];

		zis = new ZipArchiveInputStream(is, charsetName, false);
		while ( (entry = zis.getNextZipEntry()) != null ){
			name = entry.getName();
			if (name != null && !("").equals(name)) {
				name = name.replaceAll("/", "");
				name = name.replaceAll("\\\\","");
				name = name.replaceAll("&", "");
				target = new File (dstDir, name);
				if ( entry.isDirectory() ){
					target.mkdirs(); /*  does it always work? */
					log.debug("dir  : " + name);
				} else {
					target.getParentFile().mkdirs();
					target.createNewFile();
					bos = new BufferedOutputStream(new FileOutputStream(target));
					while ((nWritten = zis.read(buf)) >= 0 ){
						bos.write(buf, 0, nWritten);
					}
					bos.close();
					log.debug("file : " + name);
				}
			}
		}
		zis.close();
	}

	/**
	 * compresses the given file(or dir) and creates new file under the same directory.
	 * @param src file or directory
	 * @throws IOException
	 */
	public static void zip(File src) throws IOException{
		zip(src, CHARSET, true);
	}

	/**
	 * compresses the given file(or dir) and creates new file under the same directory.
	 * @param src file or directory
	 * @param destDir
	 * @throws IOException
	 */
	public static void zip(File src, File destDir) throws IOException {
		zip(src, destDir, CHARSET, false);
	}

	/**
	 * zips the given file(or dir) and create
	 * @param src file or directory to compress
	 * @param includeSrc if true and src is directory, then src is not included in the compression. if false, src is included.
	 * @throws IOException
	 */
	public static void zip(File src, boolean includeSrc) throws IOException{
		zip(src, CHARSET, includeSrc);
	}

	/**
	 * compresses the given src file (or directory) with the given encoding
	 * @param src
	 * @param charSetName
	 * @param includeSrc
	 * @throws IOException
	 */
	public static void zip(File src, String charSetName, boolean includeSrc) throws IOException {
		zip( src, src.getParentFile(), charSetName, includeSrc);
	}

	/**
	 * compresses the given src file(or directory) and writes to the given output stream.
	 * @param src
	 * @param os
	 * @throws IOException
	 */
	public static void zip(File src, OutputStream os) throws IOException {
		zip(src, os, CHARSET, true);
	}

	/**
	 * compresses the given src file(or directory) and create the compressed file under the given destDir.
	 * @param src
	 * @param destDir
	 * @param charSetName
	 * @param includeSrc
	 * @throws IOException
	 */
	public static void zip(File src, File dst, String charSetName, boolean includeSrc) throws IOException {
		String fileName = src.getName();
		if ( !src.isDirectory() ) {
			int pos = fileName.lastIndexOf(".");
			if ( pos >  0){
				fileName = fileName.substring(0, pos);
			}
		}

		File zippedFile = null;
		if (dst.getName().lastIndexOf(".zip") > -1) {
			zippedFile = dst;
		} else {
			zippedFile = new File (dst, fileName += ".zip");
		}

		if ( !zippedFile.exists() ) {
			zippedFile.getParentFile().mkdirs();
			zippedFile.createNewFile();
		}
		zip(src, new FileOutputStream(zippedFile), charSetName, includeSrc);
	}

	public static void zip(File src, OutputStream os, String charsetName, boolean includeSrc) throws IOException {
		ZipArchiveOutputStream zos = new ZipArchiveOutputStream(os);
		zos.setEncoding(charsetName);
		FileInputStream fis ;

		int length ;
		ZipArchiveEntry ze ;
		byte [] buf = new byte[8 * 1024];
		String name ;

		Stack<File> stack = new Stack<File>();
		File root ;
		if ( src.isDirectory() ) {
			if( includeSrc ){
				stack.push(src);
				root = src.getParentFile();
			}
			else {
				File [] fs = src.listFiles();
				for (int i = 0; i < fs.length; i++) {
					stack.push(fs[i]);
				}
				root = src;
			}
		} else {
			stack.push(src);
			root = src.getParentFile();
		}

		while ( !stack.isEmpty() ){
			File f = stack.pop();
			name = toPath(root, f);
			if ( f.isDirectory()){
				log.debug("dir  : " + name);
				File [] fs = f.listFiles();
				for (int i = 0; i < fs.length; i++) {
					if ( fs[i].isDirectory() ) stack.push(fs[i]);
					else stack.add(0, fs[i]);
				}
			} else {
				log.debug("file : " + name);
				ze = new ZipArchiveEntry(name);
				zos.putArchiveEntry(ze);
				fis = new FileInputStream(f);
				while ( (length = fis.read(buf, 0, buf.length)) >= 0 ){
					zos.write(buf, 0, length);
				}
				fis.close();
				zos.closeArchiveEntry();
			}
		}
		zos.close();
	}

	private static String toPath(File root, File dir){
		String path = dir.getAbsolutePath();
		path = path.substring(root.getAbsolutePath().length()).replace(File.separatorChar, '/');
		if ( path.startsWith("/")) path = path.substring(1);
		if ( dir.isDirectory() && !path.endsWith("/")) path += "/" ;
		return path ;
	}
}