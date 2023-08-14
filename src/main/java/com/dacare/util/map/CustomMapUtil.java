package com.dacare.util.map;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;

public class CustomMapUtil {

	private static final Logger logger = LoggerFactory.getLogger(CustomMapUtil.class);

	public static final String GREATER_THAN = "gt";
	public static final String GREATER_THAN_OR_EQUALS = "gtoreq";
	public static final String LESS_THAN = "lt";
	public static final String LESS_THAN_OR_EQUALS = "ltoreq";
	public static final String EQUALS = "eq";
	public static final String NOT_EQUALS = "noteq";
	public static final String BETWEEN = "between";
	public static final String IN = "in";
	public static final String NOT_IN = "notin";
	public static final String LIKE = "like";
	public static final String NOT_LIKE = "notlike";

	public static List<Map<String, Object>> setLowerKey(List<Map<String, Object>> list) {
		if (list.size() == 0) {
			return null;
		}

		List<Map<String, Object>> newList = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> map : list) {
			Map<String, Object> newMap = new HashMap<String, Object>();
			for (String key : map.keySet()) {
				newMap.put(key.toLowerCase(), map.get(key));
			}
			newList.add(newMap);
		}

		return newList;
	}

	public static Map<String, Object> setLowerKey(Map<String, Object> map) {
		if (MapUtils.isEmpty(map)) {
			return null;
		}

		Map<String, Object> newMap = new HashMap<String, Object>();
		for (String key : map.keySet()) {
			newMap.put(key.toLowerCase(), map.get(key));
		}

		return newMap;
	}

	public static List<Map<String, Object>> setUpperKey(List<Map<String, Object>> list) {
		if (list.size() == 0) {
			return null;
		}

		List<Map<String, Object>> newList = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> map : list) {
			Map<String, Object> newMap = new HashMap<String, Object>();
			for (String key : map.keySet()) {
				newMap.put(key.toUpperCase(), map.get(key));
			}
			newList.add(newMap);
		}

		return newList;
	}

	public static Map<String, Object> setUpperKey(Map<String, Object> map) {
		if (MapUtils.isEmpty(map)) {
			return null;
		}

		Map<String, Object> newMap = new HashMap<String, Object>();
		for (String key : map.keySet()) {
			newMap.put(key.toUpperCase(), map.get(key));
		}

		return newMap;
	}

	public static Map<String, Object> converseDynamicParamMap(Map<String, Object> map) {
		Map<String, Object> newMap = new HashMap<String, Object>();
		Set<Map.Entry<String, Object>> entries = map.entrySet();
		Iterator<Map.Entry<String, Object>> i = entries.iterator();

		while (i.hasNext()) {
			Map.Entry<String, Object> entry = i.next();
			if(entry.getKey().contains("dynamic")) {
				newMap.put(entry.getKey(), entry.getValue());
			}
		}

		return newMap;
	}

	public static String converseDynamicParamMapToString(Map<String, Object> map) throws Exception {

		logger.debug("#######converseDynamicParamMapToString method start##########");

		StringBuilder sb = new StringBuilder();
		Set<Map.Entry<String, Object>> entries = map.entrySet();
		Iterator<Map.Entry<String, Object>> i = entries.iterator();

		while (i.hasNext()) {
			Map.Entry<String, Object> entry = i.next();
			if(entry.getKey().startsWith("dynamic")) {
				int separator = StringUtils.countOccurrencesOf(entry.getKey(), "_");
				if(separator == 2) {
					String[] keyArr = entry.getKey().split("_");
					sb.append("and " + keyArr[2] + " " + converseSign(keyArr[1]) + " '" + entry.getValue() + "'");
				}
			}
		}

		logger.debug("#######converseDynamicParamMapToString method end##########");

		return sb.toString();
	}


	public static String converseSign(String target) throws Exception {
		if(StringUtils.isEmpty(target)) {
			throw new Exception("부호가 존재하지 않음");
		}

		String sign = "";
		switch (target) {
		case CustomMapUtil.GREATER_THAN:
			sign = ">";
			break;
		case CustomMapUtil.GREATER_THAN_OR_EQUALS:
			sign = ">=";
			break;
		case CustomMapUtil.LESS_THAN:
			sign = "<";
			break;
		case CustomMapUtil.LESS_THAN_OR_EQUALS:
			sign = "<=";
			break;
		case CustomMapUtil.EQUALS:
			sign = "=";
			break;
		case CustomMapUtil.NOT_EQUALS:
			sign = "!=";
			break;
		case CustomMapUtil.BETWEEN:
			sign = "between";
			break;
		case CustomMapUtil.IN:
			sign = "in";
			break;
		case CustomMapUtil.NOT_IN:
			sign = "in";
			break;
		case CustomMapUtil.LIKE:
			sign = "like";
			break;
		case CustomMapUtil.NOT_LIKE:
			sign = "not like";
			break;
		default:
			break;
		}

		return sign;
	}



}
