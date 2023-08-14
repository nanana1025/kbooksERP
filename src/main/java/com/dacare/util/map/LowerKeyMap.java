package com.dacare.util.map;
import java.util.LinkedHashMap;


public class LowerKeyMap extends LinkedHashMap<String, Object> {

	private static final long serialVersionUID = -7197592549459458204L;

	public Object put(String key, Object value) {

		return super.put(key.toLowerCase(), value);
	}
}
