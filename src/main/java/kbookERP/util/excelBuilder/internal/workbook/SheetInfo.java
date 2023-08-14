package kbookERP.util.excelBuilder.internal.workbook;
import java.io.File;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.math.NumberUtils;

import kbookERP.util.map.UMap;

/**
 * 시트정보를 처리하기 위한 VO 객체
 *
 * @author 박주의
 */
public class SheetInfo {
	private static final Pattern CELL_STR_PATTERN = Pattern.compile("([A-Z]+)([0-9]+)", Pattern.CASE_INSENSITIVE);

	private int sheetIdx;
	private String sheetName;
	private String sheetRef;
	private String relId;

	private File tempXmlFile;
	private String relDrawId;
	private String relDrawRef;
	private File relDrawFile;

	private UMap mergeMap;
	private File workExcelFile;

	private String sheetBeginCellStr;
	private String sheetEndCellStr;

	private String rangeBeginCellStr;
	private String rangeEndCellStr;
	private int bufferSize;
	private int maxPage;

	public int getSheetIdx() {
		return sheetIdx;
	}

	public void setSheetIdx(int sheetIdx) {
		this.sheetIdx = sheetIdx;
	}

	public String getSheetName() {
		return sheetName;
	}

	public void setSheetName(String sheetName) {
		this.sheetName = sheetName;
	}

	public File getTempXmlFile() {
		return tempXmlFile;
	}

	public void setTempXmlFile(File temlXmlFile) {
		this.tempXmlFile = temlXmlFile;
	}

	public File getRelDrawFile() {
		return relDrawFile;
	}

	public void setRelDrawFile(File relDrawFile) {
		this.relDrawFile = relDrawFile;
	}

	public String getSheetRef() {
		return sheetRef;
	}

	public void setSheetRef(String sheetRef) {
		this.sheetRef = sheetRef;
	}

	public String getRelDrawRef() {
		return relDrawRef;
	}

	public void setRelDrawRef(String drawingRef) {
		this.relDrawRef = drawingRef;

	}

	public String getRelId() {
		if (this.relId == null) {return "";}
		return this.relId;
	}

	public void setRelId(String rId) {
		this.relId = rId;
	}

	public UMap getMergeMap() {
		return mergeMap;
	}

	public void setMergeMap(UMap mergeCells) {
		this.mergeMap = mergeCells;
	}

	public String getRelDrawId() {
		return relDrawId;
	}

	public void setRelDrawId(String relDrawId) {
		this.relDrawId = relDrawId;
	}

	public File getWorkExcelFile() {
		return workExcelFile;
	}

	public void setWorkExcelFile(File workExcelFile) {
		this.workExcelFile = workExcelFile;
	}

	public String getSheetBeginCellStr() {
		return sheetBeginCellStr;
	}

	public void setSheetBeginCellStr(String beginCellStr) {
		this.sheetBeginCellStr = beginCellStr;
	}

	public String getSheetEndCellStr() {
		return sheetEndCellStr;
	}

	public void setSheetEndCellStr(String endCellStr) {
		this.sheetEndCellStr = endCellStr;
	}

	public String getRangeBeginCellStr() {
		return this.rangeBeginCellStr;
	}
	public void setRangeBeginCellStr(String rangeBeginCellStr) {
		this.rangeBeginCellStr = rangeBeginCellStr;
		this.maxPage = -1;
	}

	public String getRangeEndCellStr() {
		return this.rangeEndCellStr;
	}

	public void setRangeEndCellStr(String rangeEndCellStr) {
		this.rangeEndCellStr = rangeEndCellStr;
		this.maxPage = -1;
	}

	public int getBufferSize() {
		return this.bufferSize;
	}

	public void setBufferSize(int size) {
		this.bufferSize = size;
		this.maxPage = -1;
	}

	/**
	 * 시트정보에서 읽어들일 데이터의 최대 페이지수를 입력된 버퍼사이즈에 맞추어 계산
	 *
	 * @return 최대 페이지수
	 */
	public int getMaxPage() {
		if (this.maxPage == -1) {
			Matcher matBeginCell = CELL_STR_PATTERN.matcher(rangeBeginCellStr);
			if (matBeginCell.find()) {
				int rowBegin = NumberUtils.toInt(matBeginCell.group(2));
				Matcher matEndCell = CELL_STR_PATTERN.matcher(rangeEndCellStr);
				if (matEndCell.find()) {
					int rowEnd = NumberUtils.toInt(matEndCell.group(2));
					int lastPage = ((rowEnd - rowBegin) / this.bufferSize) + 1;
					if (lastPage > 0) {
						this.maxPage = lastPage;
					}
				}
			}
		}

		if (this.maxPage < 0) {
			throw new RuntimeException(String.format("<Error> SheetInfo.getMaxPage() - MagePage를 계산할 수가 없습니다. (%s:%s)", rangeBeginCellStr, rangeEndCellStr));
		}

		return this.maxPage;
	}

	@Override
	public String toString() {
		return String.format(
				"SheetInfo [sheetIdx=%s, sheetName=%s, sheetRef=%s, relId=%s, tempXmlFile=%s, relDrawId=%s, relDrawRef=%s, relDrawFile=%s, mergeMap=%s, workExcelFile=%s, sheetBeginCellStr=%s, sheetEndCellStr=%s, rangeBeginCellStr=%s, rangeEndCellStr=%s, bufferSize=%s, maxPage=%s]",
				sheetIdx, sheetName, sheetRef, relId, tempXmlFile, relDrawId, relDrawRef, relDrawFile, mergeMap,
				workExcelFile, sheetBeginCellStr, sheetEndCellStr, rangeBeginCellStr, rangeEndCellStr, bufferSize,
				maxPage);
	}


}
