package com.dacare.custom.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.math.NumberUtils;

public class Util {

	public static void pramsNullCheck(Map<String, Object> params) {
		for( String key : params.keySet() ){
			if(params.get(key) == null)
				params.put(key, "");
        }
	}

	public static double getDouble(Object data, double defaultValue) {
		if(data == null)
			return defaultValue;
		return NumberUtils.toDouble(data.toString(), defaultValue);
	}

	public static long getLong(Object data, long defaultValue) {
		if(data == null)
			return defaultValue;
		return NumberUtils.toLong(data.toString(), defaultValue);
	}

    public static int getInt(Object data, int defaultValue) {
    	if(data == null)
			return defaultValue;
		return NumberUtils.toInt(data.toString(), defaultValue);
	}

    public static short getShort(Object data, short defaultValue) {
    	if(data == null)
			return defaultValue;
  		return NumberUtils.toShort(data.toString(), defaultValue);
  	}

    public static String toString(int value) {
  		return Integer.toString(value);
  	}


    public static List<String> getListString(Object data){
    	List<String> listData = new ArrayList<String>();
	    String datas = data.toString();
	    String[] arrData = datas.split(",");
		for(String value : arrData) {
			listData.add(value);
		}
		return listData;
    }

    public static List<Long> getListLong(Object data){
    	List<Long> listData = new ArrayList<Long>();
	    String datas = data.toString();
	    String[] arrData = datas.split(",");
		for(String value : arrData) {
			listData.add(getLong(value, -1));
		}
		return listData;
    }


    public static List<Long> getListLong(List<Map<String, Object>> datas, String col){
    	List<Long> listData = new ArrayList<Long>();

		for(Map<String, Object> data : datas) {
			listData.add(getLong(data.get(col), -1));
		}

		return listData;
    }

    public static List<String> getListString(List<Map<String, Object>> datas, String col){
    	List<String> listData = new ArrayList<String>();

		for(Map<String, Object> data : datas) {
			listData.add(data.get(col).toString());
		}

		return listData;
    }


    public static List<Object> getListObject(List<Map<String, Object>> listMap, String col){
    	List<Object> listData = new ArrayList<Object>();

		for(Map<String, Object> data : listMap) {
			listData.add(data.get(col));
		}
		return listData;
    }



}
