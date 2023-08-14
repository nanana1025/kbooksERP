package com.dacare.custom.api;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



public  class CommonInfo {

	public static Map<Integer, String> MAP_ERROR_CD100 = new HashMap<Integer,String>() {{
			put(100, "ex.getMessage()");
			put(101, "스티커 번호 관련 KEY 없음");
			put(102, "스티커 번호 관련 VALUE 없음");
		}
	};

	public static Map<Integer, String> MAP_ERROR_CD200 = new HashMap<Integer,String>() {{
			put(201, "이미 등록된 번호");
			put(202, "삭제된 쿠폰번호");
			put(203, "쿠폰 정보 없음");
			put(204, "컬럼 번호와 관리번호 매핑 오류");
			put(205, "등록 PC 정보 없음");
			put(206, "판매 등록 오류");
			put(207, "스티커 초기화 오류");
			put(208, "고객 판매되지 않은 스티커번호");
			put(209, "스티커 판매 업체 매칭 오류");
		}
	};
	public static Map<Integer, String> MAP_ERROR_CD900 = new HashMap<Integer,String>() {{
		put(900, "op_code 누락");
		put(901, "정의되지 않은 op_code");
		put(902, "컬럼번호 누락");

	}
};

	public static Map<String, Integer> MAP_DATA_CHECK_FULL = new HashMap<String, Integer>() {{
			put("sGoodsList", 301);
			put("agencyCode", 302);
			put("sSerialNumber", 303);
			put("sSandEndDay", 304);
			put("sReceiverName", 305);
			put("sReceiverMobile", 306);
			put("sReceiverPhone", 307);
			put("sReceiverPost", 308);
			put("sReceiverBasicAddr", 309);
			put("sReceiverDetailAddr", 310);
			put("sOrderModel", 311);
			put("sOrderNumber", 312);
			put("nRegisterSectionSeq", 313);
//			put("sReturnUrl", 3XX);
		}
	};

	public static Map<String, Integer> MAP_DATA_CHECK_FULL_EXTERAL = new HashMap<String, Integer>() {{
		put("SALE_COM_CD", 302);
		put("MANAGE_NO", 303);
		put("SALE_DATE", 304);
		put("NAME", 305);
		put("PHONE", 306);
		put("TEL", 307);
		put("POST_NO", 308);
		put("ADDRESS1", 309);
		put("ADDRESS2", 310);
		put("MODEL_NAME", 311);
//		put("sReturnUrl", 3XX);
	}
};

	public static Map<String, Integer> MAP_DATA_CHECK_1 = new HashMap<String, Integer>() {{
		put("agencyCode", 302);
		put("sSerialNumber", 303);
		put("sSandEndDay", 304);
		put("sReceiverName", 305);
		put("sReceiverMobile", 306);
		put("sReceiverPhone", 307);
		put("sReceiverPost", 308);
		put("sReceiverBasicAddr", 309);
		put("sReceiverDetailAddr", 310);
		put("sOrderModel", 311);
		put("sOrderNumber", 312);
		put("nRegisterSectionSeq", 313);
		put("nPcCode", 314);
//		put("sReturnUrl", 3XX);
	}
};

	public static Map<String, String> MAP_DESCRYPTION = new HashMap<String, String>() {{
			put("sGoodsList", "goods_detail");
			put("sOrderModel", "model_name");
			put("sReceiverName", "customer_name");
			put("sReceiverMobile", "hand_phone");
			put("sReceiverPhone", "tel_no");
			put("sReceiverBasicAddr", "address");
			put("sReceiverDetailAddr", "address2");
//			put("sBaseCenterCompanyName", "ba_center_name");
		}
	};

	public static Map<String, Integer> MAP_DATA_CHECK2 = new HashMap<String, Integer>() {{
			put("MANAGE_NO", 301);
			put("SALE_COM_CD", 302);
			put("SALE_DATE", 303);
			put("WARRANTY_START", 304);
			put("WARRANTY_END", 305);
			put("PRODUCT_TYPE", 306);
			put("PUBLISHER_CODE", 307);
		}
	};


	public static List<String> LIST_COL = new ArrayList<String>(Arrays.asList("NAME","TEL", "PHONE", "POST_NO", "ADDRESS1", "ADDRESS2", "MODEL_NAME", "CPU", "MBD", "RAM", "VGA", "HDD", "SSD", "ODD", "CASE", "POWER", "MONITOR", "KEYBOARD", "SOUND", "SPEAKER", "COOLER", "MOUSE", "SW", "PRINTER", "LAN", "BASIC_SPEC", "ADD_SPEC", "GOODS_DETAIL", "ETC", "WINDOWS_SETUP", "OS"));


	public static List<String> LIST_SALE_PC_COL = new ArrayList<String>(Arrays.asList("CPU", "MBD", "RAM", "VGA", "HDD", "SSD", "ODD", "CASE", "POWER", "COOLER", "KEYBOARD", "MOUSE", "MONITOR", "SOUND", "SPEAKER", "PRINTER", "WINDOWS_SETUP", "SW",  "BASIC_SPEC", "ADD_SPEC", "GOODS_DETAIL", "ETC", "OS"));

	public static String KEY = "67890dacare12345";
	public static String ENC_CHAR = "1234567890ABCDEFGHIJKLMNOPQRTSUVWXYZabcdefghijklmnopqrstuvwxyz.,/?!$@^*()_+-=:;~{}#%";


	//ASWORLD
	public static List<String> LIST_ASWORLD_COMPANY_COL = new ArrayList<String>(Arrays.asList("SELLER_CODE", "NAME", "TEL1", "TEL2", "POST_NO", "ADDRESS_BASIC", "ADDRESS_DETAIL", "REF_NAME1", "REF_TEL1", "REF_NAME2", "REF_TEL2", "REF_NAME3", "REF_TEL3", "REG_NUMBER", "CEO_NAME"));



}

