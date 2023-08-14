package com.dacare.core.xmlvo.data;

import java.util.HashMap;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class DataHtml {

	private String position;
	private String value;

	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	
	@Override
	public String toString() {
		ObjectMapper mapper = new ObjectMapper();
		HashMap<String,Object> htmlMap = new HashMap<String,Object>();
		htmlMap.put("position", this.position);
		htmlMap.put("html", this.value.replaceAll("\"", "\\\\\""));
		
		try {
			return mapper.writeValueAsString(htmlMap);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		return "parsing error";
	}
}
