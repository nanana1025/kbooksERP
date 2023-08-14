package com.dacare.util.excelBuilder.util;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.Month;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;
import java.util.Calendar;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.math.NumberUtils;

/**
 * XlsxHelper (SAX 파싱을 위한 헬퍼 클래스)
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
public class XlsxParserHelper {

	private static final Pattern IS_T_TAG_PATTERN = Pattern.compile("(t=\"inlineStr\"><is><t>)(.*)(</t></is>)", Pattern.CASE_INSENSITIVE);
	private static final Pattern IS_C_BLANK_TAG_PATTERN = Pattern.compile("( t=\"inlineStr\"><is><t></t></is></c)", Pattern.CASE_INSENSITIVE);
	private static final Pattern IS_NEWLINE_C_TAG_PATTERN = Pattern.compile("(\n<c)", Pattern.CASE_INSENSITIVE);
	private static final Pattern CELL_IDX_PATTERN = Pattern.compile("([A-Z]+)([0-9]+)", Pattern.CASE_INSENSITIVE);

	/**
	 * 엑셀의 칼럼문자를 순번으로 변환 (A를 1, AA를 27로 변환)
	 *
	 * @param ref ; 엑셀의 칼럼문자
	 * @return int
	 */
	public static int convertColStringToIndex(String ref) {
		int retval = 0;
		char[] refs = ref.toUpperCase().toCharArray();
		for (int k = 0; k < refs.length; k++) {
			char thechar = refs[k];
			retval = (retval * 26) + (thechar - 'A' + 1);
		}
		return retval - 1;
	}

	/**
	 * 엑셀의 칼럼순번을 칼럼문자로 변환 (1을 A, 27을 AA로 변환)
	 *
	 * @param col ; 엑셀의 칼럼순번 (1부터 시작)
	 * @return String
	 */
	public static String convertColIndexToString(int col) {
		StringBuilder colRef = new StringBuilder(2);
		int colNum = col + 1;
		while (colNum > 0) {
			int thisPart = colNum % 26;
			if (thisPart == 0) {
				thisPart = 26;
			}
			colNum = (colNum - thisPart) / 26;

			// The letter A is at 65
			char colChar = (char) (thisPart + 64);
			colRef.insert(0, colChar);
		}
		return colRef.toString();
	}

	/**
	 * String 형태의 value 가 숫자값인지 여부 체크
	 * - 엑셀의 셀에 들어갈 데이터가 숫자값인지 여부 판단
	 *
	 * @param val ; 숫자인지 체크할 대상
	 * @return boolean
	 */
	public static boolean isNumber(String val) {
		boolean isResult = true;
		try {
			Double.parseDouble(val);
			char c = val.charAt(val.length()-1);
			if (c == 'f' || c == 'F' || c == 'd' || c == 'D') {
				isResult = false;
			}
			else {
				isResult = true;
			}
		} catch (NumberFormatException nfe) {
			isResult = false;
		}
		return isResult;
	}

	/**
	 * 숫자형 칼럼에 대해서는 숫자칼럼으로 변경처리
	 *  - t="inlineStr" 가 없이 <is><t> 도 <v> 형태가 되도록 저장
	 *
	 * @param str
	 * @return
	 */
	public static void replaceNumberTypeCell(StringBuffer sb) {
		Matcher matNumberCell = IS_T_TAG_PATTERN.matcher(sb.toString().replace("<c", "\n<c"));
		sb.setLength(0);
		while (matNumberCell.find()) {
			String val = matNumberCell.group(2);
			if (XlsxParserHelper.isNumber(val)) {
				matNumberCell.appendReplacement(sb, String.format("><v>%s</v>", matNumberCell.group(2)));
			}
			else {
				matNumberCell.appendReplacement(sb, matNumberCell.group());
			}
		}
		matNumberCell.appendTail(sb);

		Matcher matEmptyCell = IS_C_BLANK_TAG_PATTERN.matcher(sb.toString());
		sb.setLength(0);
		while (matEmptyCell.find()) {
			matEmptyCell.appendReplacement(sb, "/");
		}
		matEmptyCell.appendTail(sb);

		Matcher matNewline = IS_NEWLINE_C_TAG_PATTERN.matcher(sb.toString());
		sb.setLength(0);
		while (matNewline.find()) {
			matNewline.appendReplacement(sb, "<c");
		}
		matNewline.appendTail(sb);
	}

	/**
	 * 날짜포맷의 셀값(숫자값)을 yyyyMMddHHmmss 형태의 정해진 문자포맷으로 변경하는 함수
	 *
	 * @param val ; 날짜로 변환할 숫자값
	 * @param datePattern 날짜패턴
	 * @return
	 */
	public static String convertDateTypeCellNumberToString(String val) {
		return convertDateTypeCellNumberToString(val, "yyyyMMddHHmmss");
	}

	/**
	 * 날짜포맷의 셀값(숫자값)을 yyyyMMddHHmmss 형태의 정해진 문자포맷으로 변경하는 함수
	 *
	 * @param val ; 날짜로 변환할 숫자값
	 * @param datePattern 날짜패턴 (yyyyMMddHHmmss)
	 * @return
	 */
	public static String convertDateTypeCellNumberToString(String val, String datePattern) {
		String result = null;
		try {
			BigDecimal epochFromExcel = new BigDecimal(val);
			int days = epochFromExcel.intValue();

			Calendar cal = Calendar.getInstance();
			cal.clear();					// 1970년 기준 (epoch)
			cal.set(Calendar.YEAR, 1900);	// 엑셀은 1900년 기준

			// nval 은 1900-01-01 을 1로 봤을때 이후 얼마나 지났는가를 표시하는 것임
			// 엑셀의 경우 1900년도를 윤년이 아닌데 윤년으로 취급해서 1900-02-29 가 더 포함되는 버그때문에 -2 를 빼줘야함
			cal.add(Calendar.DATE, days-2);

			// 소수부분 짤라내서 나노밀리세컨드로 계산하기
			BigDecimal fraction = epochFromExcel.subtract(new BigDecimal(days));
			long nanos = fraction.multiply(new BigDecimal( TimeUnit.DAYS.toNanos(1))).longValue();

			// Calendar 객체는 milisecond 까지만 지원하기 때문에 나노세컨드 부분은 반올림처리
			cal.setTimeInMillis(cal.getTimeInMillis()+Math.round(nanos/1000000.0));

			// 출력형식으로 변환
			SimpleDateFormat sdf = new SimpleDateFormat(datePattern);
			result = sdf.format(cal.getTime());
		} catch (RuntimeException e) {
			result = val;
		}
		return result;
	}

	/**
	 * 셀인덱스 (B5) 에서 행번호를 추출 (ex: 5)
	 *
	 * @param cellStr
	 * @return
	 */
	public static int getCellRowIndex(String cellStr) {
		int result = -1;
		Matcher matCell = CELL_IDX_PATTERN.matcher(cellStr);
		if (matCell.find()) {
			result = NumberUtils.toInt(matCell.group(2));
		}
		return result;
	}

	/**
	 * 셀인덱스 (B5) 에서 열문자를 추출 (ex: B)
	 *
	 * @param cellStr
	 * @return
	 */
	public static String getCellColString(String cellStr) {
		String result = null;
		Matcher matCell = CELL_IDX_PATTERN.matcher(cellStr);
		if (matCell.find()) {
			result = matCell.group(1);
		}
		return result;
	}

}
