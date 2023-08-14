package kbookERP.custom.util;


import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import org.apache.commons.lang3.math.NumberUtils;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import kbookERP.util.map.UMap;

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

    public static boolean toBoolean(Object data) {
    	if(data == null)
			return false;
  		return Boolean.parseBoolean(data.toString());
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

    public static List<Integer> getListInt(Object data){
    	List<Integer> listData = new ArrayList<Integer>();
	    String datas = data.toString();
	    String[] arrData = datas.split(",");
		for(String value : arrData) {
			listData.add(getInt(value, -1));
		}
		return listData;
    }

    public static List<Long> getListLongU(List<UMap> datas, String col){
    	List<Long> listData = new ArrayList<Long>();

		for(Map<String, Object> data : datas) {
			listData.add(getLong(data.get(col), -1));
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
    public static List<String> getListStringU(List<UMap> datas, String col){
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

	// 택배 배송 상태 조회
	public static String getInvoiceState(String deliveryCompany, String invoiceNo) {
		String invoiceState = "확인불가";
		String invoiceUrl = "https://apis.tracker.delivery/carriers/";

		if(deliveryCompany.equals("5")) {
			//로젠
			invoiceUrl += "kr.logen";
		} else if(deliveryCompany.equals("1")) {
			//CJ
			invoiceUrl += "kr.cjlogistics";
		} else {
			return invoiceState;
		}

		invoiceUrl += "/tracks/" + invoiceNo;

		try {

			HttpClient httpClient = HttpClientBuilder.create().build();
			HttpResponse response = httpClient.execute(new HttpGet(invoiceUrl));
			HttpEntity entity = response.getEntity();
			String content = EntityUtils.toString(entity);

			JSONParser parser = new JSONParser();
			JSONObject result = (JSONObject) parser.parse(content);

			if(result.containsKey("state")) {

				JSONObject state = (JSONObject) result.get("state");

				if(state.containsKey("text")) {
					invoiceState = (String) state.get("text");
				}
			}

		} catch (ParseException e) {
			e.printStackTrace();
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return invoiceState;
	}
}
