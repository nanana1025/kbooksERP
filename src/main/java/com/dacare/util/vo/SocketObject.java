package com.dacare.util.vo;

public class SocketObject {

	private String message;
	private String success;
	
	public SocketObject(String str){
		this.success = str;
	}
	
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getSuccess() {
		return success;
	}
	public void setSuccess(String success) {
		this.success = success;
	}
}
