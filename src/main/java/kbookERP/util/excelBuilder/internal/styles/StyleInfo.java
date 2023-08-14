package kbookERP.util.excelBuilder.internal.styles;
import org.apache.commons.lang3.BooleanUtils;

/**
 * 스타일정보를 처리하기 위한 VO 객체
 *
 * @author 박주의
 */
public class StyleInfo {

	private int styleIdx;
	private String numFmtId;
	private String fontId;
	private String fillId;
	private String borderId;
	private String xfId;
	private boolean applyFont;
	private boolean applyAlignment;
	private boolean applyFill;
	private boolean dateType;
	private String formatCode;

	public int getStyleIdx() {
		return styleIdx;
	}
	public void setStyleIdx(int styleIdx) {
		this.styleIdx = styleIdx;
	}
	public String getNumFmtId() {
		return numFmtId;
	}
	public void setNumFmtId(String numFmtId) {
		this.numFmtId = numFmtId;
	}
	public String getFontId() {
		return fontId;
	}
	public void setFontId(String fontId) {
		this.fontId = fontId;
	}
	public String getFillId() {
		return fillId;
	}
	public void setFillId(String fillId) {
		this.fillId = fillId;
	}
	public String getBorderId() {
		return borderId;
	}
	public void setBorderId(String borderId) {
		this.borderId = borderId;
	}
	public String getXfId() {
		return xfId;
	}
	public void setXfId(String xfId) {
		this.xfId = xfId;
	}
	public boolean isApplyFont() {
		return applyFont;
	}
	public void setApplyFont(String applyFont) {
		if (applyFont != null) {
			this.applyFont = BooleanUtils.toBoolean(applyFont, "1", "0");
		}
	}
	public boolean isApplyAlignment() {
		return applyAlignment;
	}
	public void setApplyAlignment(String applyAlignment) {
		if (applyAlignment != null) {
			this.applyAlignment = BooleanUtils.toBoolean(applyAlignment, "1", "0");
		}
	}
	public boolean isApplyFill() {
		return applyFill;
	}
	public void setApplyFill(String applyFill) {
		if (applyFill != null) {
			this.applyFill = BooleanUtils.toBoolean(applyFill, "1", "0");
		}
	}
	public boolean isDateType() {
		return dateType;
	}
	public void setDateType(boolean dateType) {
		this.dateType = dateType;
	}
	public String getFormatCode() {
		return formatCode;
	}
	public void setFormatCode(String formatCode) {
		this.formatCode = formatCode;
	}

	@Override
	public String toString() {
		return String.format(
				"StyleInfo [styleIdx=%s, numFmtId=%s, isDateType()=%s, fontId=%s, fillId=%s, borderId=%s, xfId=%s, applyFont=%s, applyAlignment=%s, applyFill=%s, formatCode=%s]\n",
				styleIdx, numFmtId, isDateType(), fontId, fillId, borderId, xfId, applyFont, applyAlignment, applyFill, formatCode);
	}

}
