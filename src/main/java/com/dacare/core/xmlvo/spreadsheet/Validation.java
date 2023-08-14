package com.dacare.core.xmlvo.spreadsheet;

public class Validation {
	
	private String type;
	private String comparerType;
	private String dataType;
	private String from;
	private String to;
	private String showButton;
	private String allowNulls;
	private String messageTemplate;
	private String titleTemplate;
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getComparerType() {
		return comparerType;
	}
	public void setComparerType(String comparerType) {
		this.comparerType = comparerType;
	}
	public String getDataType() {
		return dataType;
	}
	public void setDataType(String dataType) {
		this.dataType = dataType;
	}
	public String getFrom() {
		return from;
	}
	public void setFrom(String from) {
		this.from = from;
	}
	public String getTo() {
		return to;
	}
	public void setTo(String to) {
		this.to = to;
	}
	public String getShowButton() {
		return showButton;
	}
	public void setShowButton(String showButton) {
		this.showButton = showButton;
	}
	public String getAllowNulls() {
		return allowNulls;
	}
	public void setAllowNulls(String allowNulls) {
		this.allowNulls = allowNulls;
	}
	public String getMessageTemplate() {
		return messageTemplate;
	}
	public void setMessageTemplate(String messageTemplate) {
		this.messageTemplate = messageTemplate;
	}
	public String getTitleTemplate() {
		return titleTemplate;
	}
	public void setTitleTemplate(String titleTemplate) {
		this.titleTemplate = titleTemplate;
	}
}
