package com.dacare.custom.api;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.dacare.core.view.data.DataMapper;
import com.mysql.jdbc.StringUtils;

@Service
public class ApiService {

	@Autowired
	private ApiMapper apiMapper;

	@Autowired
	DataMapper dataMapper;

	@Autowired
	APILog _APILog;

	@Value("${logLink}")
    private String _logLink;


	public Map<String, Object> sale(Map<String, Object> params) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> newParams = new HashMap<String, Object>();
		Map<String, Object> newParams1 = new HashMap<String, Object>();
		List<Map<String, Object>> listProductType = new ArrayList<Map<String, Object>>();
		Map<String, Object> mapPoductType = new HashMap<String, Object>();
		List<Map<String, Object>> listPartType = new ArrayList<Map<String, Object>>();
		Map<String, Object> mapPartType = new HashMap<String, Object>();

		Map<String, Object> mapManageNo = new HashMap<String, Object>();
		Map<String, Object> sqlMap = new HashMap<String, Object>();


//		List<Map<String, Object>> listSqlMap2 = new ArrayList<Map<String, Object>>();

		StringBuilderPlus danawaFull = new StringBuilderPlus();
		StringBuilderPlus danawaParams = new StringBuilderPlus();
		StringBuilderPlus danawaSqlUpdate = new StringBuilderPlus();

		String danawaFullPath = "danawa"+_logLink+"sale"+_logLink+"full_";
		String danawaParamsPath = "danawa"+_logLink+"sale"+_logLink+"params_";
		String danawaSqlUpdatePath = "danawa"+_logLink+"sale"+_logLink+"sql_";

		String errorMsg = "";

		try {

			danawaFullPath = _APILog.CheckLogFilePath(danawaFullPath);
			danawaParamsPath = _APILog.CheckLogFilePath(danawaParamsPath);
			danawaSqlUpdatePath = _APILog.CheckLogFilePath(danawaSqlUpdatePath);

			// 로그
//			//System.out.println("params = " + params);
			danawaFull.appendLine("[params] "+params.toString());
			danawaParams.appendLine("[params] "+params.toString());

			boolean isSuccess = true;
			int errorCd = 0;

			String opCd = "";
			String returnType; //사용안할 예정
			String returnUrl;	//사용안할 예정
			String manageNo = "";
			String authNo = "";
			String saleComCd = "";
			String orderNo = "";;
			String isEncrytion = "Y";
			String registerSectionNo = "";

			// 제품 타입 가져오기
			newParams.clear();
			newParams.put("CODE_GROUP", "DANAWA_PRODUCT_TYPE");
			listProductType = apiMapper.getProductType(newParams);
			if(listProductType.size() >0) {
				for(Map<String, Object> data : listProductType) {
					String key = data.get("CODE_ID").toString();
					if(!mapPoductType.containsKey(key))
						mapPoductType.put(key, data.get("CODE_NAME"));
				}
			}

			newParams.clear();
			newParams.put("CODE_GROUP", "DANAWA_PART_TYPE");
			listPartType = apiMapper.getProductType(newParams);
			if(listPartType.size() >0) {
				for(Map<String, Object> data : listPartType) {
					String key = data.get("CODE_ID").toString();
					if(!mapPartType.containsKey(key))
						mapPartType.put(key, data.get("CODE_NAME"));
				}
			}

			// 데이터 공백 제거
			for( String key : params.keySet() ){
				String value = params.get(key).toString();
				params.put(key, value.trim());
	        }

			// 필수 정보 확인
			if(params.containsKey("op_code"))
				opCd = params.get("op_code").toString();
			else {
				isSuccess = false;
				errorCd = 900;
				errorMsg = "op_code 누락";
			}

			if(params.containsKey("rtn_type"))	//사용안할 예정
				returnType = params.get("rtn_type").toString();

			if(params.containsKey("sReturnUrl"))	//사용안할 예정
				returnUrl = params.get("sReturnUrl").toString();

			if(params.containsKey("sSerialNumber"))	//manageNo
				manageNo = params.get("sSerialNumber").toString();
			else {
				isSuccess = false;
				errorCd = 303;
				errorMsg = "sSerialNumber 누락";
			}

			if(params.containsKey("agencyCode")) //saleComCd
				saleComCd = params.get("agencyCode").toString();
			else {
				isSuccess = false;
				errorCd = 302;
				errorMsg = "agencyCode 누락";
			}

			if(params.containsKey("sOrderNumber"))		//orderNo,
				orderNo = params.get("sOrderNumber").toString();
			else {
				isSuccess = false;
				errorCd = 312;
				errorMsg = "sOrderNumber 누락";
			}

			if(errorCd > 0) {
				resultMap.put("sErrCd", errorCd);
				resultMap.put("ERROR_MSG", errorMsg);
				resultMap.put("SUCCESS", false);

				// 로그
//				//System.out.println("resultMap = " + resultMap);
				danawaFull.appendLine("[result] "+resultMap.toString());
				danawaParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
				_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);

				return resultMap;
			}


			// 데이터 누락 검사

			if(StringUtils.isNullOrEmpty(opCd))
				opCd = "220";

			if(opCd.equals("221")) {		//OPCODE 221일때 PC_CODE 받을것인지 아니면 모텔명으로만 할 것인지

				for( String key : CommonInfo.MAP_DATA_CHECK_1.keySet() ){
					String data = params.get(key).toString();
					if(StringUtils.isNullOrEmpty(data)) {
						resultMap.put("sErrCd", CommonInfo.MAP_DATA_CHECK_1.get(key));
						resultMap.put("ERROR_MSG", key+" 누락");
						resultMap.put("SUCCESS", false);

						// 로그
						//System.out.println("resultMap = " + resultMap);
						danawaFull.appendLine("[result] "+resultMap.toString());
						danawaParams.appendLine("[result] "+resultMap.toString());
						_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
						_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
						return resultMap;
					}
		        }

			}else if(opCd.equals("220")) {

				for( String key : CommonInfo.MAP_DATA_CHECK_FULL.keySet() ){
					if(!params.containsKey(key)) {
						resultMap.put("sErrCd", CommonInfo.MAP_DATA_CHECK_FULL.get(key));
						resultMap.put("ERROR_MSG", "key: "+key+" 누락");
						resultMap.put("SUCCESS", false);
						// 로그
						//System.out.println("resultMap = " + resultMap);
						danawaFull.appendLine("[result] "+resultMap.toString());
						danawaParams.appendLine("[result] "+resultMap.toString());
						_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
						_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
						return resultMap;
					}
		        }

				for( String key : CommonInfo.MAP_DATA_CHECK_FULL.keySet() ){
					String data = params.get(key).toString();
					if(StringUtils.isNullOrEmpty(data)) {
						resultMap.put("sErrCd", CommonInfo.MAP_DATA_CHECK_FULL.get(key));
						resultMap.put("ERROR_MSG", key+" value 누락");
						resultMap.put("SUCCESS", false);
						// 로그
						//System.out.println("resultMap = " + resultMap);
						danawaFull.appendLine("[result] "+resultMap.toString());
						danawaParams.appendLine("[result] "+resultMap.toString());
						_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
						_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
						return resultMap;
					}
		        }
			}else {
				resultMap.put("sErrCd", 901);
				resultMap.put("ERROR_MSG", "정의되지 않은 op_code ");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				danawaFull.appendLine("[result] "+resultMap.toString());
				danawaParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
				_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
				return resultMap;
			}

			if(params.containsKey("is_crypt"))
				isEncrytion = params.get("is_crypt").toString().toUpperCase();
			else {
				isEncrytion = "Y";
//				resultMap.put("ERR_CD", 904);
//				resultMap.put("ERROR_MSG", "is_crypt 누락");
//				resultMap.put("SUCCESS", false);
//				return resultMap;
				params.put("is_crypt", "Y");

			}


			// 데이터 암호화 체크 및 변환
			try {

				for( String key : CommonInfo.MAP_DESCRYPTION.keySet() ){

					String value = CommonInfo.MAP_DESCRYPTION.get(key).toString();
					if(params.containsKey(key)) {
						if(isEncrytion.equals("N"))	params.put(value, params.get(key).toString());
						else	{
							String data = decryption(params.get(key).toString());
							data = URLDecoder.decode(data, "EUC-KR");
							params.put(value, data);	// 복호화 알고리즘
						}
					}
		        }
			}
			catch(Exception ex) {

				resultMap.put("ERROR_MSG", "decryption error");
				resultMap.put("sErrCd", 100);
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				danawaFull.appendLine("[result] "+resultMap.toString());
				danawaParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
				_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
				return resultMap;
			}


			if(params.containsKey("sBaseCenterId"))
				params.put("ba_center_id", params.get("sBaseCenterId").toString());

			{
				String data = params.get("sSandEndDay").toString();
				data = data.replace("-", "");
				data = data.substring(0, 8);
				params.put("sale_ymd", data);
			}

			{
				String data = params.get("sReceiverPost").toString();
				data = data.replace("-", "");
				params.put("post_no", data);
			}


			if(params.containsKey("os_com_name")) {
				String data = params.get("os_com_name").toString();
				if(StringUtils.isEmptyOrWhitespaceOnly(data))	params.put("os_yn", "N");
				else	params.put("os_yn", "Y");
			}
			else
				params.put("os_yn", "N");


			registerSectionNo = params.get("nRegisterSectionSeq").toString();

			if(mapPoductType.containsKey(registerSectionNo))
				params.put("product_type", mapPoductType.get(registerSectionNo));


			// 쿠폰번호 유효성 검사
			newParams.clear();

			if(opCd.equals("110") || opCd.equals("220") || opCd.equals("221")) {
				newParams.put("MANAGE_NO", manageNo);
				newParams.put("SALE_COM_CODE", saleComCd);
			}
			else if(opCd.equals("111") || opCd.equals("113"))
				newParams.put("MANAGE_NO", manageNo);
			else if(opCd.equals("112") )  //이런경우 없음
				newParams.put("AUTH_NO", authNo);
			else {
				resultMap.put("sErrCd", 901);
				resultMap.put("ERROR_MSG", "정의되지 않은 op_code");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				danawaFull.appendLine("[result] "+resultMap.toString());
				danawaParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
				_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
				return resultMap;
			}

//						mapManageNo = apiMapper.getManageNoInfo(newParams);

			// 로그
			danawaFull.appendLine("[execute sql] apiMapper.getManageNoCheck");
			mapManageNo = apiMapper.getManageNoCheck(newParams);


			if(mapManageNo == null) {
				resultMap.put("sErrCd", 203);
				resultMap.put("ERROR_MSG", "쿠폰 정보 없음");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				danawaFull.appendLine("[result] "+resultMap.toString());
				danawaParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
				_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
				return resultMap;
			}
			else{

				String useYn = mapManageNo.get("USE_FLAG").toString();
				if(!useYn.equals("Y")) {
					resultMap.put("sErrCd", 202);
					resultMap.put("ERROR_MSG", "삭제된 쿠폰번호");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					danawaFull.appendLine("[result] "+resultMap.toString());
					danawaParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
					_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
					return resultMap;
				}

				String couponSaleDt = mapManageNo.get("COUPON_SALE_DATE").toString();
				if(!couponSaleDt.equals("-1")) {
					resultMap.put("sErrCd", 201);
					resultMap.put("ERROR_MSG", "이미 등록된 번호");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					danawaFull.appendLine("[result] "+resultMap.toString());
					danawaParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
					_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
					return resultMap;
				}

				String couponSaleComCd = mapManageNo.get("SALE_COM_CD").toString();

				if(!couponSaleComCd.equals(saleComCd)) {
					resultMap.put("sErrCd", 209);
					resultMap.put("ERROR_MSG", "스티커 판매 업체 매칭 오류");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					danawaFull.appendLine("[result] "+resultMap.toString());
					danawaParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
					_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
					return resultMap;
				}


			}

			// 쿠폰 번호로 보증기간 확인
			{
				//초기 보증기간 설정
				String warrantyType = mapManageNo.get("WARRANTY_TYPE").toString();
				if(StringUtils.isNullOrEmpty(warrantyType))
					params.put("warranty_flag", "3");

				//보증기간 설정
				String saleNo = manageNo.substring(0,5);

				newParams.clear();
				newParams.put("TYPE", 1);
				newParams.put("SALE_NO", saleNo);
				newParams.put("COL_NO", registerSectionNo);

				// 로그
				danawaFull.appendLine("[execute sql] apiMapper.getWarrantyType");
				sqlMap = apiMapper.getWarrantyType(newParams);

				if(sqlMap == null) {
					resultMap.put("sErrCd", 204);
					resultMap.put("ERROR_MSG", "컬럼 번호와 관리번호 매핑 오류");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					danawaFull.appendLine("[result] "+resultMap.toString());
					danawaParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
					_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
					return resultMap;
				}

				params.put("warranty_flag", sqlMap.get("WARRANTY_CD").toString());
			}

			// 기존 판매 확인
			authNo = mapManageNo.get("AUTH_NO").toString();

			if(opCd.equals("220")) {

				// 판매 제품 정보 파싱
				if(params.containsKey("goods_detail")) {
					String goodsDetail = params.get("goods_detail").toString();
					if(!StringUtils.isNullOrEmpty(goodsDetail)) {

						String[] arrData = goodsDetail.split("<br>");
						String pName;
						String pValue;
						int startIndex;
						int endIndex;
						int length;

						for(String data : arrData ){

							data = data.trim();

							startIndex = data.indexOf('[');
							endIndex = data.indexOf(']');
							length = data.length();

							if(startIndex >= 0 && endIndex < length) {
								pName = data.substring(startIndex+1, endIndex);
								pValue = data.substring(endIndex+1, length);

								if(mapPartType.containsKey(pName)) {

									String value = mapPartType.get(pName).toString();

									if(params.containsKey(value)) {
										String nData = params.get(value).toString();

										if(StringUtils.isNullOrEmpty(nData))	params.put(value, pValue);
										else	params.put(value, nData + " / " + pValue);
									}
									else
										params.put(value, pValue);
								}
							}
						}
					}
					else {

						// goodsDetail empty일때 처리
					}
				}
				else {
					// goodsDetail 없을때 처리
				}
			}

			if(opCd.equals("220") || opCd.equals("221")) {

				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date now = new Date();
				String today = format.format(now);

				newParams.clear();
				newParams.put("MANAGE_NO", manageNo);
				newParams.put("AUTH_NO", authNo);

				newParams.put("SALE_DATE",  params.get("sale_ymd"));
				newParams.put("REG_DATE",  today);
				newParams.put("WARRANTY_START",  params.get("sale_ymd"));
				newParams.put("WARRANTY_END",  AddDate(params.get("sale_ymd").toString(), params.get("warranty_flag").toString()));
				newParams.put("WARRANTY_TYPE",  params.get("warranty_flag"));

//					newParams.put("PRODUCT_CODE",  params.get("product_type"));
				newParams.put("PRODUCT_TYPE",  params.get("product_type"));
				newParams.put("PUBLISHER_CODE",  240);
				newParams.put("SELLER_CODE",  saleComCd);
				if(params.containsKey("model_name"))	newParams.put("MODEL_NAME",  params.get("model_name"));
				else	newParams.put("MODEL_NAME",  "");
				newParams.put("REG_PATH",  1);

				if(opCd.equals("220")) {

					if(params.containsKey("CPU"))	newParams.put("CPU",  params.get("CPU"));
					else	newParams.put("CPU",  "");

					if(params.containsKey("MBD"))	newParams.put("MBD",  params.get("MBD"));
					else	newParams.put("MBD",  "");

					if(params.containsKey("RAM"))	newParams.put("RAM",  params.get("RAM"));
					else	newParams.put("RAM",  "");

					if(params.containsKey("VGA"))	newParams.put("VGA",  params.get("VGA"));
					else	newParams.put("VGA",  "");

					if(params.containsKey("HDD"))	newParams.put("HDD",  params.get("HDD"));
					else	newParams.put("HDD",  "");

					if(params.containsKey("SSD"))	newParams.put("SSD",  params.get("SSD"));
					else	newParams.put("SSD",  "");

					if(params.containsKey("ODD"))	newParams.put("ODD",  params.get("ODD"));
					else	newParams.put("ODD",  "");

					if(params.containsKey("CASE"))	newParams.put("CASE",  params.get("CASE"));
					else	newParams.put("CASE",  "");

					if(params.containsKey("POWER"))	newParams.put("POWER",  params.get("POWER"));
					else	newParams.put("POWER",  "");

					if(params.containsKey("MONITOR"))	newParams.put("MONITOR",  params.get("MONITOR"));
					else	newParams.put("MONITOR",  "");

					if(params.containsKey("KEYBOARD"))	newParams.put("KEYBOARD",  params.get("KEYBOARD"));
					else	newParams.put("KEYBOARD",  "");

					if(params.containsKey("SOUND"))	newParams.put("SOUND",  params.get("SOUND"));
					else	newParams.put("SOUND",  "");

					if(params.containsKey("SOUND"))	newParams.put("SPEAKER",  params.get("SOUND"));
					else	newParams.put("SPEAKER",  "");

					if(params.containsKey("COOLER"))	newParams.put("COOLER",  params.get("COOLER"));
					else	newParams.put("COOLER",  "");

					if(params.containsKey("MOUSE"))	newParams.put("MOUSE",  params.get("MOUSE"));
					else	newParams.put("MOUSE",  "");

					if(params.containsKey("SW"))	newParams.put("SW",  params.get("SW"));
					else	newParams.put("SW",  "");

					if(params.containsKey("PRINTER"))	newParams.put("PRINTER",  params.get("PRINTER"));
					else	newParams.put("PRINTER",  "");

					if(params.containsKey("LAN"))	newParams.put("LAN",  params.get("LAN"));
					else	newParams.put("LAN",  "");

					if(params.containsKey("basic_info"))	newParams.put("BASIC_SPEC",  params.get("basic_info"));
					else	newParams.put("BASIC_SPEC",  "");

					if(params.containsKey("add_info"))	newParams.put("ADD_SPEC",  params.get("add_info"));
					else	newParams.put("ADD_SPEC",  "");

					if(params.containsKey("goods_detail"))	newParams.put("GOODS_DETAIL",  params.get("goods_detail"));
					else	newParams.put("GOODS_DETAIL",  "");

					if(params.containsKey("ETC"))	newParams.put("ETC",  params.get("ETC"));
					else	newParams.put("ETC",  "");

					if(params.containsKey("os_yn"))	newParams.put("WINDOWS_SETUP",  params.get("os_yn"));
					else	newParams.put("WINDOWS_SETUP",  "");

					if(params.containsKey("OS"))	newParams.put("OS",  params.get("OS"));
					else	newParams.put("OS",  "");
				}
				else if(opCd.equals("221")) {

					newParams1.clear();
					newParams1.put("PC_CODE",  params.get("nPcCode"));
					newParams1.put("MODEL_NAME",  params.get("model_name"));
					newParams1.put("SALE_COM_CODE",  params.get("saleComCd"));
					newParams1.put("PC_TYPE",  "5");

					// 로그
					danawaFull.appendLine("[execute sql] apiMapper.getSalePcInfo");
					sqlMap = apiMapper.getSalePcInfo(newParams);

					if(sqlMap == null) {

						resultMap.put("sErrCd", 205);
						resultMap.put("ERROR_MSG", "등록 PC 정보 없음");
						resultMap.put("SUCCESS", false);
						// 로그
						//System.out.println("resultMap = " + resultMap);
						danawaFull.appendLine("[result] "+resultMap.toString());
						danawaParams.appendLine("[result] "+resultMap.toString());
						_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
						_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
						return resultMap;

					}else {

						for(String col : CommonInfo.LIST_SALE_PC_COL) {

							if(sqlMap.get(col) != null)	newParams.put(col,  sqlMap.get(col));
							else newParams.put(col,  "");
						}
					}
				}

				// 로그
				danawaSqlUpdate.appendLine("[newParamsSale] "+newParams.toString());
				danawaFull.appendLine("[newParamsSale] "+newParams.toString());
				danawaFull.appendLine("[execute sql] apiMapper.updateSaleInfo");
				int result = apiMapper.updateSaleInfo(newParams);

				if(result < 1) {

					resultMap.put("ERR_CD", 206);
					resultMap.put("ERROR_MSG", "판매 등록 오류");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					danawaFull.appendLine("[result] "+resultMap.toString());
					danawaParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
					_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
					return resultMap;
				}
				else {
					newParams.clear();
					newParams.put("MANAGE_NO", manageNo);
					newParams.put("AUTH_NO", authNo);
					newParams.put("NAME",  params.get("customer_name"));
					newParams.put("TEL",  params.get("tel_no"));
					newParams.put("PHONE",  params.get("hand_phone"));
					newParams.put("POST_NO",  params.get("post_no"));
					newParams.put("ADDRESS1",  params.get("address"));
					newParams.put("ADDRESS2",  params.get("address2"));
					newParams.put("MEMO",  params.get("remark"));
					newParams.put("SALE_FLAG",  1);

					// 로그
					danawaSqlUpdate.appendLine("[newParamsCustomer] "+newParams.toString());
					danawaFull.appendLine("[newParamsCustomer] "+newParams.toString());
					danawaFull.appendLine("[execute sql] apiMapper.selectCustomerInfo");
					sqlMap = apiMapper.selectCustomerInfo(newParams);

					if(sqlMap == null) {
						// 로그
						danawaFull.appendLine("[execute sql] apiMapper.insertCustomerInfo");
						apiMapper.insertCustomerInfo(newParams);
					}
					else	{
						// 로그
						danawaFull.appendLine("[execute sql] apiMapper.updateCustomerInfo");
						apiMapper.updateCustomerInfo(newParams);
					}

					// 로그
					danawaFull.appendLine("[execute sql] apiMapper.updateCouponInfo");
					apiMapper.updateCouponInfo(newParams);
				}

			}

			resultMap.put("sOrderKeyCode", orderNo);
			resultMap.put("sAgencyCode", saleComCd);
			resultMap.put("sSerialNumber", manageNo);
			resultMap.put("SUCCESS", true);
			// 로그
			//System.out.println("resultMap = " + resultMap);
			danawaFull.appendLine("[result] "+resultMap.toString());
			danawaParams.appendLine("[result] "+resultMap.toString());
			_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
			_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
			_APILog.WrileLogWithTime(danawaSqlUpdatePath, danawaSqlUpdate, true);
			return resultMap;


		} catch (Exception ex) {
			resultMap.put("sErrCd", 100);
			resultMap.put("ERROR_MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			// 로그
			//System.out.println("resultMap = " + resultMap);
			danawaFull.appendLine("[result] "+resultMap.toString());
			danawaParams.appendLine("[result] "+resultMap.toString());
			_APILog.WrileLogWithTime(danawaFullPath, danawaFull, false);
			_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, false);
			_APILog.WrileLogWithTime(danawaSqlUpdatePath, danawaSqlUpdate, false);
			return resultMap;
		}
	}

	public Map<String, Object> saleExternal(Map<String, Object> params) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> newParams = new HashMap<String, Object>();
		Map<String, Object> mapManageNo = new HashMap<String, Object>();
		Map<String, Object> sqlMap = new HashMap<String, Object>();

		StringBuilderPlus dangolFull = new StringBuilderPlus();
		StringBuilderPlus dangolParams = new StringBuilderPlus();
		StringBuilderPlus dangolSqlUpdate = new StringBuilderPlus();

		String dangolFullPath = "dangol"+_logLink+"sale"+_logLink+"full_";
		String dangolParamsPath = "dangol"+_logLink+"sale"+_logLink+"params_";
		String dangolSqlUpdatePath = "dangol"+_logLink+"sale"+_logLink+"sql_";

		String errorMsg = "";

		try {

			dangolFullPath = _APILog.CheckLogFilePath(dangolFullPath);
			dangolParamsPath = _APILog.CheckLogFilePath(dangolParamsPath);
			dangolSqlUpdatePath = _APILog.CheckLogFilePath(dangolSqlUpdatePath);

			// 로그
			//System.out.println("params = " + params);
			dangolFull.appendLine("[params] "+params.toString());
			dangolParams.appendLine("[params] "+params.toString());

			boolean isSuccess = true;
			int errorCd = 0;

			String manageNo = "";
			String authNo = "";
			String saleComCd = "";
			String colNo = "";
			String isEncrytion = "Y";


			// 데이터 공백 제거
			for( String key : params.keySet() ){
				String value = params.get(key).toString();
				params.put(key, value.trim());
	        }



			if(params.containsKey("MANAGE_NO"))
				manageNo = params.get("MANAGE_NO").toString();
			else {
				isSuccess = false;
				errorCd = 303;
				errorMsg = "쿠폰번호 누락";
			}

			if(params.containsKey("SALE_COM_CD"))
				saleComCd = params.get("SALE_COM_CD").toString();
			else {
				isSuccess = false;
				errorCd = 302;
				errorMsg = "판매 업체 코드 누락";
			}

//			if(params.containsKey("COL_NO"))
//				colNo = params.get("COL_NO").toString();
//			else {
//				isSuccess = false;
//				errorCd = 902;
//				errorMsg = "컬럼번호 누락";
//			}

			if(errorCd < 0) {
				resultMap.put("ERR_CD", errorCd);
				resultMap.put("ERROR_MSG", errorMsg);
				resultMap.put("SUCCESS", false);
				return resultMap;
			}


			for( String key : CommonInfo.MAP_DATA_CHECK_FULL_EXTERAL.keySet() ){
				if(!params.containsKey(key)) {
					resultMap.put("sErrCd", CommonInfo.MAP_DATA_CHECK_FULL_EXTERAL.get(key));
					resultMap.put("ERROR_MSG", "key: "+key+" 누락");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					dangolFull.appendLine("[result] "+resultMap.toString());
					dangolParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
					_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
					return resultMap;
				}
	        }

//			for( String key : CommonInfo.MAP_DATA_CHECK_FULL_EXTERAL.keySet() ){
//				String data = params.get(key).toString();
//				if(StringUtils.isNullOrEmpty(data)) {
//					resultMap.put("sErrCd", CommonInfo.MAP_DATA_CHECK_FULL_EXTERAL.get(key));
//					resultMap.put("ERROR_MSG", key+" value 누락");
//					resultMap.put("SUCCESS", false);
//					//System.out.println("resultMap = " + resultMap);
//					return resultMap;
//				}
//	        }

			if(params.containsKey("IS_CRYPT"))
				isEncrytion = params.get("IS_CRYPT").toString().toUpperCase();
			else
				isEncrytion = "Y";


			// 데이터 암호화 체크 및 변환
			if(isEncrytion.equals("Y")) {

				try {

					for( String key : CommonInfo.MAP_DESCRYPTION.keySet() ){

						String value = CommonInfo.MAP_DESCRYPTION.get(key).toString();
						if(params.containsKey(key)) {
							if(isEncrytion.equals("N"))	params.put(value, params.get(key).toString());
							else	{
								String data = decryption(params.get(key).toString());
								data = URLDecoder.decode(data, "EUC-KR");
								params.put(value, data);	// 복호화 알고리즘
							}
						}
			        }
				}
				catch(Exception ex) {

					resultMap.put("ERROR_MSG", "decryption error");
					resultMap.put("sErrCd", 100);
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					dangolFull.appendLine("[result] "+resultMap.toString());
					dangolParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
					_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
					return resultMap;
				}
	        }

			// 쿠폰번호 유효성 검사
			newParams.clear();
			newParams.put("MANAGE_NO", manageNo);
			newParams.put("SALE_COM_CODE", saleComCd);

			mapManageNo = apiMapper.getManageNoCheck(newParams);

			if(mapManageNo == null) {
				resultMap.put("ERR_CD", 203);
				resultMap.put("ERROR_MSG", "쿠폰 정보 없음");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				dangolFull.appendLine("[result] "+resultMap.toString());
				dangolParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
				_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
				return resultMap;
			}
			else{

				String useYn = mapManageNo.get("USE_FLAG").toString();
				if(!useYn.equals("Y")) {
					resultMap.put("ERR_CD", 202);
					resultMap.put("ERROR_MSG", "삭제된 쿠폰번호");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					dangolFull.appendLine("[result] "+resultMap.toString());
					dangolParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
					_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
					return resultMap;
				}

				String couponSaleDt = mapManageNo.get("COUPON_SALE_DATE").toString();
				if(!couponSaleDt.equals("-1")) {
					resultMap.put("ERR_CD", 201);
					resultMap.put("ERROR_MSG", "이미 등록된 번호");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					dangolFull.appendLine("[result] "+resultMap.toString());
					dangolParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
					_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
					return resultMap;
				}


			}

			// 쿠폰 번호로 보증기간 확인
//			String saleNo = manageNo.substring(0,5);
//
//			newParams.clear();
//			newParams.put("TYPE", 2);
//			newParams.put("SALE_NO", saleNo);
//			newParams.put("COL_NO", colNo);
//
//			sqlMap = apiMapper.getWarrantyType(newParams);
//
//			if(sqlMap == null) {
//				resultMap.put("ERR_CD", 318);
//				resultMap.put("ERROR_MSG", "컬럼 번호와 관리번호 매핑 오류");
//				resultMap.put("SUCCESS", false);
//				//System.out.println("resultMap = " + resultMap);
//				return resultMap;
//			}



//			params.put("WARRANTY_TYPE", mapManageNo.get("WARRANTY_TYPE").toString());

			// 판매 등록
			authNo = mapManageNo.get("AUTH_NO").toString();

			newParams.clear();
			newParams.put("MANAGE_NO", manageNo);
			newParams.put("AUTH_NO", authNo);

			newParams.put("REG_DATE",  params.get("REG_DATE"));
			newParams.put("SALE_DATE",  params.get("SALE_DATE"));
			if(params.containsKey("WARRANTY_START"))
				newParams.put("WARRANTY_START",  params.get("WARRANTY_START"));
			else
				newParams.put("WARRANTY_START",  params.get("SALE_DATE"));

			if(params.containsKey("WARRANTY_END"))
				newParams.put("WARRANTY_END",  params.get("WARRANTY_END"));
			else
				newParams.put("WARRANTY_END",  AddDate4External(newParams.get("WARRANTY_START").toString(), mapManageNo.get("WARRANTY_TYPE").toString()));

			if(params.containsKey("GOODS_DETAIL"))
				newParams.put("GOODS_DETAIL",  params.get("GOODS_DETAIL"));
			else
				newParams.put("GOODS_DETAIL",  "");

			if(params.containsKey("WINDOWS_SETUP")) newParams.put("WINDOWS_SETUP",  params.get("WINDOWS_SETUP"));


//			newParams.put("WARRANTY_TYPE",  params.get("WARRANTY_TYPE"));

//			newParams.put("PRODUCT_CODE",  params.get("PRODUCT_CODE"));
//			newParams.put("PRODUCT_TYPE",  params.get("PRODUCT_TYPE"));
			newParams.put("PUBLISHER_CODE",  params.get("PUBLISHER_CODE"));
			newParams.put("SELLER_CODE",  saleComCd);

			newParams.put("REG_PATH",  4);
			newParams.put("SALE_FLAG",  1);

			for( String key : CommonInfo.LIST_COL) {
				if(params.containsKey(key))	newParams.put(key,  params.get(key));
				else	newParams.put(key,  "");
			}

			// 로그
			dangolSqlUpdate.appendLine("[newParamsSale] "+newParams.toString());
			dangolFull.appendLine("[newParamsSale] "+newParams.toString());
			dangolFull.appendLine("[execute sql] apiMapper.updateSaleInfo");

			int result = apiMapper.updateSaleInfo(newParams);

			if(result < 1) {

				resultMap.put("ERR_CD", 206);
				resultMap.put("ERROR_MSG", "판매 등록 오류");
				resultMap.put("SUCCESS", false);

				// 로그
				//System.out.println("resultMap = " + resultMap);
				dangolFull.appendLine("[result] "+resultMap.toString());
				dangolParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
				_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
				return resultMap;
			}
			else {

				dangolFull.appendLine("[execute sql] apiMapper.selectCustomerInfo");
				sqlMap = apiMapper.selectCustomerInfo(newParams);

				if(sqlMap == null)	{
					dangolFull.appendLine("[execute sql] apiMapper.insertCustomerInfo");
					apiMapper.insertCustomerInfo(newParams);
				}
				else	{
					dangolFull.appendLine("[execute sql] apiMapper.updateCustomerInfo");
					apiMapper.updateCustomerInfo(newParams);
				}

				dangolFull.appendLine("[execute sql] apiMapper.updateCouponInfo");
				apiMapper.updateCouponInfo(newParams);
			}




			resultMap.put("SUCCESS", true);
			// 로그
			//System.out.println("resultMap = " + resultMap);
			dangolFull.appendLine("[result] "+resultMap.toString());
			dangolParams.appendLine("[result] "+resultMap.toString());
			_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
			_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
			_APILog.WrileLogWithTime(dangolSqlUpdatePath,dangolSqlUpdate, true);
			return resultMap;


		} catch (Exception ex) {
			resultMap.put("sErrCd", 100);
			resultMap.put("ERROR_MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			// 로그
			//System.out.println("resultMap = " + resultMap);
			dangolFull.appendLine("[result] "+resultMap.toString());
			dangolParams.appendLine("[result] "+resultMap.toString());
			_APILog.WrileLogWithTime(dangolFullPath, dangolFull, false);
			_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, false);
			_APILog.WrileLogWithTime(dangolSqlUpdatePath, dangolSqlUpdate, false);
			return resultMap;
		}
	}


	public Map<String, Object> deleteSaleExternal(Map<String, Object> params) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> newParams = new HashMap<String, Object>();
		Map<String, Object> mapManageNo = new HashMap<String, Object>();

		StringBuilderPlus dangolFull = new StringBuilderPlus();
		StringBuilderPlus dangolParams = new StringBuilderPlus();
		StringBuilderPlus dangolSqlUpdate = new StringBuilderPlus();

		String dangolFullPath = "dangol"+_logLink+"initialize"+_logLink+"full_";
		String dangolParamsPath = "dangol"+_logLink+"initialize"+_logLink+"params_";
		String dangolSqlUpdatePath = "dangol"+_logLink+"initialize"+_logLink+"sql_";

		String errorMsg = "";

		try {

			dangolFullPath = _APILog.CheckLogFilePath(dangolFullPath);
			dangolParamsPath = _APILog.CheckLogFilePath(dangolParamsPath);
			dangolSqlUpdatePath = _APILog.CheckLogFilePath(dangolSqlUpdatePath);

			// 로그
			//System.out.println("params = " + params);
			dangolFull.appendLine("[params] "+params.toString());
			dangolParams.appendLine("[params] "+params.toString());

			boolean isSuccess = true;
			int errorCd = 0;

			String manageNo = "";
			String authNo = "";


			// 데이터 공백 제거
			for( String key : params.keySet() ){
				String value = params.get(key).toString();
				params.put(key, value.trim());
	        }

			if(!params.containsKey("MANAGE_NO") && params.containsKey("AUTH_NO")) {
				resultMap.put("ERR_CD", 101);
				resultMap.put("ERROR_MSG", "파라미터 KEY 없음");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				dangolFull.appendLine("[result] "+resultMap.toString());
				dangolParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
				_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
				return resultMap;
			}

			if(params.containsKey("MANAGE_NO"))
				manageNo = params.get("MANAGE_NO").toString();

			if(params.containsKey("AUTH_NO"))
				authNo = params.get("AUTH_NO").toString();

			if(StringUtils.isNullOrEmpty(manageNo) && StringUtils.isNullOrEmpty(manageNo)) {
				resultMap.put("ERR_CD", 102);
				resultMap.put("ERROR_MSG", "파라미터 VALUE 없음");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				dangolFull.appendLine("[result] "+resultMap.toString());
				dangolParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
				_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
				return resultMap;
			}

			// 쿠폰번호 유효성 검사
			newParams.clear();
			if(!StringUtils.isNullOrEmpty(manageNo) )
				newParams.put("MANAGE_NO", manageNo);
			if(!StringUtils.isNullOrEmpty(authNo))
				newParams.put("AUTH_NO", authNo);

			mapManageNo = apiMapper.getManageNoCheck(newParams);


			if(mapManageNo == null) {

				resultMap.put("ERR_CD", 203);
				resultMap.put("ERROR_MSG", "등록되지 않은 쿠폰 정보");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				dangolFull.appendLine("[result] "+resultMap.toString());
				dangolParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
				_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
				return resultMap;

			}
			else{

				String useYn = mapManageNo.get("USE_FLAG").toString();
				if(!useYn.equals("Y")) {
					resultMap.put("ERR_CD", 202);
					resultMap.put("ERROR_MSG", "이미 삭제된 쿠폰번호");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					dangolFull.appendLine("[result] "+resultMap.toString());
					dangolParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
					_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
					return resultMap;
				}

				String couponSaleDt = mapManageNo.get("COUPON_SALE_DATE").toString();
				if(couponSaleDt.equals("-1")) {

					resultMap.put("ERR_CD", 208);
					resultMap.put("ERROR_MSG", "고객 판매되지 않은 스티커번호");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					dangolFull.appendLine("[result] "+resultMap.toString());
					dangolParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
					_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
					return resultMap;

				}
			}

			manageNo = mapManageNo.get("MANAGE_NO").toString();
			authNo = mapManageNo.get("AUTH_NO").toString();

			newParams.clear();
			newParams.put("MANAGE_NO", manageNo);
			newParams.put("AUTH_NO", authNo);
			newParams.put("SALE_FLAG",  2);
			// 로그
			dangolSqlUpdate.appendLine("[newParamsInitialze] "+newParams.toString());
			dangolFull.appendLine("[newParamsInitialze] "+newParams.toString());
			dangolFull.appendLine("[execute sql] apiMapper.deleteSaleInfo");
			int result = apiMapper.deleteSaleInfo(newParams);

			if(result < 1) {

				resultMap.put("ERR_CD", 207);
				resultMap.put("ERROR_MSG", "쿠폰 삭제 오류");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				dangolFull.appendLine("[result] "+resultMap.toString());
				dangolParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
				_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
				return resultMap;
			}
			else{
				dangolFull.appendLine("[execute sql] apiMapper.deleteCustomerInfo");
				apiMapper.deleteCustomerInfo(newParams);

				dangolFull.appendLine("[execute sql] apiMapper.updateCouponInfo");
				apiMapper.updateCouponInfo(newParams);
			}

			resultMap.put("SUCCESS", true);
			// 로그
			//System.out.println("resultMap = " + resultMap);
			dangolFull.appendLine("[result] "+resultMap.toString());
			dangolParams.appendLine("[result] "+resultMap.toString());
			_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
			_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
			_APILog.WrileLogWithTime(dangolSqlUpdatePath,dangolSqlUpdate, true);
			return resultMap;


		} catch (Exception ex) {
			resultMap.put("sErrCd", 100);
			resultMap.put("ERROR_MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			// 로그
			//System.out.println("resultMap = " + resultMap);
			dangolFull.appendLine("[result] "+resultMap.toString());
			dangolParams.appendLine("[result] "+resultMap.toString());
			_APILog.WrileLogWithTime(dangolFullPath, dangolFull, false);
			_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, false);
			_APILog.WrileLogWithTime(dangolSqlUpdatePath, dangolSqlUpdate, false);
			return resultMap;
		}
	}

	public Map<String, Object> deleteSaleExternal4Danawa(Map<String, Object> params) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> newParams = new HashMap<String, Object>();
		Map<String, Object> mapManageNo = new HashMap<String, Object>();
		Map<String, Object> sqlMap = new HashMap<String, Object>();


		StringBuilderPlus danawaFull = new StringBuilderPlus();
		StringBuilderPlus danawaParams = new StringBuilderPlus();
		StringBuilderPlus danawaSqlUpdate = new StringBuilderPlus();

		String danawaFullPath = "danawa"+_logLink+"initialize"+_logLink+"full_";
		String danawaParamsPath = "danawa"+_logLink+"initialize"+_logLink+"params_";
		String danawaSqlUpdatePath = "danawa"+_logLink+"initialize"+_logLink+"sql_";

		String errorMsg = "";

		try {

			danawaFullPath = _APILog.CheckLogFilePath(danawaFullPath);
			danawaParamsPath = _APILog.CheckLogFilePath(danawaParamsPath);
			danawaSqlUpdatePath = _APILog.CheckLogFilePath(danawaSqlUpdatePath);

			// 로그
			//System.out.println("params = " + params);
			danawaFull.appendLine("[params] "+params.toString());
			danawaParams.appendLine("[params] "+params.toString());

			boolean isSuccess = true;
			int errorCd = 0;

			String manageNo = "";
			String authNo = "";

			// 데이터 공백 제거
			for( String key : params.keySet() ){
				String value = params.get(key).toString();
				params.put(key, value.trim());
	        }

			if(!params.containsKey("sSerialNumber")) {
				resultMap.put("sErrCd", 101);
				resultMap.put("ERROR_MSG", "파라미터 sSerialNumber 없음");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				danawaFull.appendLine("[result] "+resultMap.toString());
				danawaParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
				_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
				return resultMap;
			}

			if(params.containsKey("sSerialNumber"))
				manageNo = params.get("sSerialNumber").toString();



			if(StringUtils.isNullOrEmpty(manageNo)) {
				resultMap.put("sErrCd", 102);
				resultMap.put("ERROR_MSG", "파라미터 VALUE 없음");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				danawaFull.appendLine("[result] "+resultMap.toString());
				danawaParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
				_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
				return resultMap;
			}

			// 쿠폰번호 유효성 검사
			newParams.clear();
			if(!StringUtils.isNullOrEmpty(manageNo) )
				newParams.put("MANAGE_NO", manageNo);
			if(!StringUtils.isNullOrEmpty(authNo))
				newParams.put("AUTH_NO", authNo);

			mapManageNo = apiMapper.getManageNoCheck(newParams);


			if(mapManageNo == null) {

				resultMap.put("ERR_CD", 203);
				resultMap.put("ERROR_MSG", "등록되지 않은 쿠폰 정보");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				danawaFull.appendLine("[result] "+resultMap.toString());
				danawaParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
				_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
				return resultMap;

			}
			else{

				String useYn = mapManageNo.get("USE_FLAG").toString();
				if(!useYn.equals("Y")) {
					resultMap.put("sErrCd", 202);
					resultMap.put("ERROR_MSG", "이미 삭제된 쿠폰번호");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					danawaFull.appendLine("[result] "+resultMap.toString());
					danawaParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
					_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
					return resultMap;
				}

				String couponSaleDt = mapManageNo.get("COUPON_SALE_DATE").toString();
				if(couponSaleDt.equals("-1")) {

					resultMap.put("sErrCd", 208);
					resultMap.put("ERROR_MSG", "고객 판매되지 않은 스티커번호");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					danawaFull.appendLine("[result] "+resultMap.toString());
					danawaParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
					_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
					return resultMap;

				}
			}

			manageNo = mapManageNo.get("MANAGE_NO").toString();
			authNo = mapManageNo.get("AUTH_NO").toString();

			newParams.clear();
			newParams.put("MANAGE_NO", manageNo);
			newParams.put("AUTH_NO", authNo);

			// 로그
			danawaSqlUpdate.appendLine("[newParamsinitialze] "+newParams.toString());
			danawaFull.appendLine("[newParamsinitialze] "+newParams.toString());
			danawaFull.appendLine("[execute sql] apiMapper.deleteSaleInfo");
			int result = apiMapper.deleteSaleInfo(newParams);

			if(result < 1) {

				resultMap.put("sErrCd", 207);
				resultMap.put("ERROR_MSG", "쿠폰 삭제 오류");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				danawaFull.appendLine("[result] "+resultMap.toString());
				danawaParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
				_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
				return resultMap;
			}
			else{
				newParams.put("SALE_FLAG",  2);

				// 로그
				danawaSqlUpdate.appendLine("[newParamsCustomer] "+newParams.toString());
				danawaFull.appendLine("[newParamsCustomer] "+newParams.toString());
				danawaFull.appendLine("[execute sql] apiMapper.deleteCustomerInfo");
				apiMapper.deleteCustomerInfo(newParams);
				danawaFull.appendLine("[execute sql] apiMapper.updateCouponInfo");
				apiMapper.updateCouponInfo(newParams);
			}

			resultMap.put("SUCCESS", true);
			// 로그
			//System.out.println("resultMap = " + resultMap);
			danawaFull.appendLine("[result] "+resultMap.toString());
			danawaParams.appendLine("[result] "+resultMap.toString());
			_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
			_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
			_APILog.WrileLogWithTime(danawaSqlUpdatePath, danawaSqlUpdate, true);
			return resultMap;


		} catch (Exception ex) {
			resultMap.put("sErrCd", 100);
			resultMap.put("ERROR_MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			// 로그
			//System.out.println("resultMap = " + resultMap);
			danawaFull.appendLine("[result] "+resultMap.toString());
			danawaParams.appendLine("[result] "+resultMap.toString());
			_APILog.WrileLogWithTime(danawaFullPath, danawaFull, false);
			_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, false);
			_APILog.WrileLogWithTime(danawaSqlUpdatePath, danawaSqlUpdate, false);
			return resultMap;
		}
	}


	public Map<String, Object> getSaleInfo(Map<String, Object> params) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> newParams = new HashMap<String, Object>();
		Map<String, Object> mapManageNo = new HashMap<String, Object>();
		Map<String, Object> sqlMap = new HashMap<String, Object>();

		StringBuilderPlus externalFull = new StringBuilderPlus();
		StringBuilderPlus externalParams = new StringBuilderPlus();


		String externalFullPath = "external"+_logLink+"check"+_logLink+"full_";
		String externalParamsPath = "external"+_logLink+"check"+_logLink+"params_";
//		external
		try {

			externalFullPath = _APILog.CheckLogFilePath(externalFullPath);
			externalParamsPath = _APILog.CheckLogFilePath(externalParamsPath);

			// 로그
			//System.out.println("params = " + params);
			externalFull.appendLine("[params] "+params.toString());
			externalParams.appendLine("[params] "+params.toString());

			String hp;
			String tel;
			String manageNo = "";
			String authNo = "";


			if(params.containsKey("manage_no"))
				manageNo = params.get("manage_no").toString();

			if(params.containsKey("auth_no"))
				authNo = params.get("auth_no").toString();


			if(!StringUtils.isNullOrEmpty(manageNo) || !StringUtils.isNullOrEmpty(authNo))
			{
				if(!StringUtils.isNullOrEmpty(manageNo))
						newParams.put("MANAGE_NO", manageNo);
				if(!StringUtils.isNullOrEmpty(authNo))
					newParams.put("AUTH_NO", authNo);

				mapManageNo = apiMapper.getManageNoCheck(newParams);

				if(mapManageNo == null) {
					resultMap.put("ERR_CD", 203);
					resultMap.put("ERROR_MSG", "쿠폰 정보 없음");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					externalFull.appendLine("[result] "+resultMap.toString());
					externalParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(externalFullPath, externalFull, true);
					_APILog.WrileLogWithTime(externalParamsPath,externalParams, true);
					return resultMap;
				}
				else{

					String useYn = mapManageNo.get("USE_FLAG").toString();
					if(!useYn.equals("Y")) {
						resultMap.put("ERR_CD", 202);
						resultMap.put("ERROR_MSG", "삭제된 쿠폰번호");
						resultMap.put("SUCCESS", false);
						// 로그
						//System.out.println("resultMap = " + resultMap);
						externalFull.appendLine("[result] "+resultMap.toString());
						externalParams.appendLine("[result] "+resultMap.toString());
						_APILog.WrileLogWithTime(externalFullPath, externalFull, true);
						_APILog.WrileLogWithTime(externalParamsPath,externalParams, true);
						return resultMap;
					}

					String couponSaleDt = mapManageNo.get("COUPON_SALE_DATE").toString();
					if(couponSaleDt.equals("-1")) {
						resultMap.put("ERR_CD", 208);
						resultMap.put("ERROR_MSG", "고객 판매되지 않은 쿠폰번호");
						resultMap.put("SUCCESS", false);
						// 로그
						//System.out.println("resultMap = " + resultMap);
						externalFull.appendLine("[result] "+resultMap.toString());
						externalParams.appendLine("[result] "+resultMap.toString());
						_APILog.WrileLogWithTime(externalFullPath, externalFull, true);
						_APILog.WrileLogWithTime(externalParamsPath,externalParams, true);
						return resultMap;
					}

					sqlMap = apiMapper.getSaleInfoForAsworld(mapManageNo);


					String value;
					String encData;

					for( String key : sqlMap.keySet() ){
						if(sqlMap.get(key) != null) {

							value = sqlMap.get(key).toString();

							if(!StringUtils.isNullOrEmpty(value)) {

								encData = URLEncoder.encode(value,"EUC-KR");
								encData = encryption(encData);

								sqlMap.put(key, encData.trim());
							}
						}
			        }

					resultMap = sqlMap;
					resultMap.put("SUCCESS", true);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					externalFull.appendLine("[result] "+resultMap.toString());
					externalParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(externalFullPath, externalFull, true);
					_APILog.WrileLogWithTime(externalParamsPath,externalParams, true);
					return resultMap;

				}
			}
			else {
				resultMap.put("ERR_CD", 102);
				resultMap.put("ERROR_MSG", "파라미터 VALUE 없음");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				externalFull.appendLine("[result] "+resultMap.toString());
				externalParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(externalFullPath, externalFull, true);
				_APILog.WrileLogWithTime(externalParamsPath,externalParams, true);
				return resultMap;
			}

		} catch (Exception ex) {
			resultMap.put("sErrCd", 100);
			resultMap.put("ERROR_MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			// 로그
			//System.out.println("resultMap = " + resultMap);
			externalFull.appendLine("[result] "+resultMap.toString());
			externalParams.appendLine("[result] "+resultMap.toString());
			_APILog.WrileLogWithTime(externalFullPath, externalFull, false);
			_APILog.WrileLogWithTime(externalParamsPath,externalParams, false);
			return resultMap;
		}
	}


	public Map<String, Object> getSaleInfoNonEncrytion(Map<String, Object> params) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> newParams = new HashMap<String, Object>();
		Map<String, Object> mapManageNo = new HashMap<String, Object>();
		Map<String, Object> sqlMap = new HashMap<String, Object>();

		StringBuilderPlus dangolFull = new StringBuilderPlus();
		StringBuilderPlus dangolParams = new StringBuilderPlus();


		String dangolFullPath = "dangol"+_logLink+"check"+_logLink+"full_";
		String dangolParamsPath = "dangol"+_logLink+"check"+_logLink+"params_";

		try {

			dangolFullPath = _APILog.CheckLogFilePath(dangolFullPath);
			dangolParamsPath = _APILog.CheckLogFilePath(dangolParamsPath);

			// 로그
			//System.out.println("params = " + params);
			dangolFull.appendLine("[params] "+params.toString());
			dangolParams.appendLine("[params] "+params.toString());

			String hp;
			String tel;
			String manageNo = "";
			String authNo = "";


			if(params.containsKey("MANAGE_NO"))
				manageNo = params.get("MANAGE_NO").toString();

			if(params.containsKey("AUTH_NO"))
				authNo = params.get("AUTH_NO").toString();


			if(!StringUtils.isNullOrEmpty(manageNo) || !StringUtils.isNullOrEmpty(authNo))
			{
				if(!StringUtils.isNullOrEmpty(manageNo))
						newParams.put("MANAGE_NO", manageNo);
				if(!StringUtils.isNullOrEmpty(authNo))
					newParams.put("AUTH_NO", authNo);

				mapManageNo = apiMapper.getManageNoCheck(newParams);

				if(mapManageNo == null) {
					resultMap.put("ERR_CD", 203);
					resultMap.put("ERROR_MSG", "쿠폰 정보 없음");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					dangolFull.appendLine("[result] "+resultMap.toString());
					dangolParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
					_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
					return resultMap;
				}
				else{

					String useYn = mapManageNo.get("USE_FLAG").toString();
					if(!useYn.equals("Y")) {
						resultMap.put("ERR_CD", 202);
						resultMap.put("ERROR_MSG", "삭제된 쿠폰번호");
						resultMap.put("SUCCESS", false);
						// 로그
						//System.out.println("resultMap = " + resultMap);
						dangolFull.appendLine("[result] "+resultMap.toString());
						dangolParams.appendLine("[result] "+resultMap.toString());
						_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
						_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
						return resultMap;
					}

					String couponSaleDt = mapManageNo.get("COUPON_SALE_DATE").toString();
					if(couponSaleDt.equals("-1")) {
						resultMap.put("ERR_CD", 208);
						resultMap.put("ERROR_MSG", "고객 판매되지 않은 쿠폰번호");
						resultMap.put("SUCCESS", false);
						// 로그
						//System.out.println("resultMap = " + resultMap);
						dangolFull.appendLine("[result] "+resultMap.toString());
						dangolParams.appendLine("[result] "+resultMap.toString());
						_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
						_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
						return resultMap;
					}

					sqlMap = apiMapper.getSaleInfo4Danawa(mapManageNo);


//					String value;
//					String encData;
//
//					for( String key : sqlMap.keySet() ){
//						if(sqlMap.get(key) != null) {
//
//							value = sqlMap.get(key).toString();
//
//							if(!StringUtils.isNullOrEmpty(value)) {
//
//								encData = URLEncoder.encode(value,"EUC-KR");
//								encData = encryption(encData);
//
//								sqlMap.put(key, encData.trim());
//							}
//						}
//			        }

					resultMap = sqlMap;
					resultMap.put("SUCCESS", true);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					dangolFull.appendLine("[result] "+resultMap.toString());
					dangolParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
					_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
					return resultMap;

				}
			}
			else {
				resultMap.put("ERR_CD", 102);
				resultMap.put("ERROR_MSG", "파라미터 VALUE 없음");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				dangolFull.appendLine("[result] "+resultMap.toString());
				dangolParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(dangolFullPath, dangolFull, true);
				_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, true);
				return resultMap;
			}

		} catch (Exception ex) {
			resultMap.put("sErrCd", 100);
			resultMap.put("ERROR_MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			// 로그
			//System.out.println("resultMap = " + resultMap);
			dangolFull.appendLine("[result] "+resultMap.toString());
			dangolParams.appendLine("[result] "+resultMap.toString());
			_APILog.WrileLogWithTime(dangolFullPath, dangolFull, false);
			_APILog.WrileLogWithTime(dangolParamsPath, dangolParams, false);
			return resultMap;
		}
	}

	public Map<String, Object> getSaleInfoNonEncrytion4Danawa(Map<String, Object> params) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> newParams = new HashMap<String, Object>();
		Map<String, Object> mapManageNo = new HashMap<String, Object>();
		Map<String, Object> sqlMap = new HashMap<String, Object>();


		StringBuilderPlus danawaFull = new StringBuilderPlus();
		StringBuilderPlus danawaParams = new StringBuilderPlus();

		String danawaFullPath = "danawa"+_logLink+"check"+_logLink+"full_";
		String danawaParamsPath = "danawa"+_logLink+"check"+_logLink+"params_";

		String errorMsg = "";

		try {

			danawaFullPath = _APILog.CheckLogFilePath(danawaFullPath);
			danawaParamsPath = _APILog.CheckLogFilePath(danawaParamsPath);

			// 로그
			//System.out.println("params = " + params);
			danawaFull.appendLine("[params] "+params.toString());
			danawaParams.appendLine("[params] "+params.toString());

			String hp;
			String tel;
			String manageNo = "";
			String authNo = "";

			if(!params.containsKey("sSerialNumber")) {
				resultMap.put("sErrCd", 101);
				resultMap.put("ERROR_MSG", "파라미터 sSerialNumber 없음");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				danawaFull.appendLine("[result] "+resultMap.toString());
				danawaParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
				_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
				return resultMap;
			}


			if(params.containsKey("sSerialNumber"))
				manageNo = params.get("sSerialNumber").toString();

//			if(params.containsKey("AUTH_NO"))
//				authNo = params.get("AUTH_NO").toString();


			if(!StringUtils.isNullOrEmpty(manageNo))
			{
				if(!StringUtils.isNullOrEmpty(manageNo))
						newParams.put("MANAGE_NO", manageNo);
				if(!StringUtils.isNullOrEmpty(authNo))
					newParams.put("AUTH_NO", authNo);

				// 로그
				danawaFull.appendLine("[execute sql] apiMapper.getManageNoCheck");
				mapManageNo = apiMapper.getManageNoCheck(newParams);

				if(mapManageNo == null) {
					resultMap.put("sErrCd", 203);
					resultMap.put("ERROR_MSG", "쿠폰 정보 없음");
					resultMap.put("SUCCESS", false);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					danawaFull.appendLine("[result] "+resultMap.toString());
					danawaParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
					_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
					return resultMap;
				}
				else{

					String useYn = mapManageNo.get("USE_FLAG").toString();
					if(!useYn.equals("Y")) {
						resultMap.put("sErrCd", 202);
						resultMap.put("ERROR_MSG", "삭제된 쿠폰번호");
						resultMap.put("SUCCESS", false);
						// 로그
						//System.out.println("resultMap = " + resultMap);
						danawaFull.appendLine("[result] "+resultMap.toString());
						danawaParams.appendLine("[result] "+resultMap.toString());
						_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
						_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
						return resultMap;
					}

					String couponSaleDt = mapManageNo.get("COUPON_SALE_DATE").toString();
					if(couponSaleDt.equals("-1")) {
						resultMap.put("sErrCd", 208);
						resultMap.put("ERROR_MSG", "고객 판매되지 않은 쿠폰번호");
						resultMap.put("SUCCESS", false);
						// 로그
						//System.out.println("resultMap = " + resultMap);
						danawaFull.appendLine("[result] "+resultMap.toString());
						danawaParams.appendLine("[result] "+resultMap.toString());
						_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
						_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
						return resultMap;
					}

					// 로그
					danawaFull.appendLine("[execute sql] apiMapper.mapManageNo");
					sqlMap = apiMapper.getSaleInfo4Danawa(mapManageNo);


//					String value;
//					String encData;
//
//					for( String key : sqlMap.keySet() ){
//						if(sqlMap.get(key) != null) {
//
//							value = sqlMap.get(key).toString();
//
//							if(!StringUtils.isNullOrEmpty(value)) {
//
//								encData = URLEncoder.encode(value,"EUC-KR");
//								encData = encryption(encData);
//
//								sqlMap.put(key, encData.trim());
//							}
//						}
//			        }

					resultMap = sqlMap;
					resultMap.put("SUCCESS", true);
					// 로그
					//System.out.println("resultMap = " + resultMap);
					danawaFull.appendLine("[result] "+resultMap.toString());
					danawaParams.appendLine("[result] "+resultMap.toString());
					_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
					_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
					return resultMap;

				}
			}
			else {
				resultMap.put("sErrCd", 102);
				resultMap.put("ERROR_MSG", "파라미터 VALUE 없음");
				resultMap.put("SUCCESS", false);
				// 로그
				//System.out.println("resultMap = " + resultMap);
				danawaFull.appendLine("[result] "+resultMap.toString());
				danawaParams.appendLine("[result] "+resultMap.toString());
				_APILog.WrileLogWithTime(danawaFullPath, danawaFull, true);
				_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, true);
				return resultMap;
			}

		} catch (Exception ex) {
			resultMap.put("sErrCd", 100);
			resultMap.put("ERROR_MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			// 로그
			//System.out.println("resultMap = " + resultMap);
			danawaFull.appendLine("[result] "+resultMap.toString());
			danawaParams.appendLine("[result] "+resultMap.toString());
			_APILog.WrileLogWithTime(danawaFullPath, danawaFull, false);
			_APILog.WrileLogWithTime(danawaParamsPath, danawaParams, false);
			return resultMap;
		}
	}


	public String encryption(String InputData) {

		StringBuffer output = new StringBuffer();
		char ch;

		int inputLength = InputData.length();
		int keyLength = CommonInfo.KEY.length();
		int encCharLength = CommonInfo.ENC_CHAR.length();

		int i,j,index;

		for(i = j = 0; j < inputLength; i++, j++) {

			if(i >= keyLength)	i = 0;

			ch = InputData.charAt(j);

			index = CommonInfo.ENC_CHAR.indexOf(ch);

			if(index >= 0) {
				index = (index + CommonInfo.ENC_CHAR.indexOf(CommonInfo.KEY.charAt(i))) % encCharLength;
				output.append(CommonInfo.ENC_CHAR.charAt(index));
			}
			else	output.append(ch);
		}

		return output.toString();
	}


	public String decryption(String InputData) {

		StringBuffer output = new StringBuffer();
		char ch;

		int inputLength = InputData.length();
		int keyLength = CommonInfo.KEY.length();
		int encCharLength = CommonInfo.ENC_CHAR.length();

		int i,j,index;

		for(i = j = 0; j < inputLength; i++, j++) {

			if(i >= keyLength)	i = 0;

			ch = InputData.charAt(j);

			index = CommonInfo.ENC_CHAR.indexOf(ch);

			if(index >= 0) {
				index = (index - CommonInfo.ENC_CHAR.indexOf(CommonInfo.KEY.charAt(i)) + encCharLength) % encCharLength;
				output.append(CommonInfo.ENC_CHAR.charAt(index));
			}
			else	output.append(ch);
		}

		return output.toString();
	}












	public String AddDate(String date, String term) {

		String newDate = "";;
		try{

			int warranty = Integer.parseInt(term);

	        SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
	        Date to = transFormat.parse(date);
	        Calendar cal = Calendar.getInstance();
	        cal.setTime(to);

	        cal.add(Calendar.MONDAY, warranty);

	        newDate = transFormat.format(cal.getTime());

	        return newDate;

		}
		catch(Exception e){
			return date;
		}
	}

	public String AddDate4External(String date, String term) {

		String newDate = "";;
		try{

			int warranty = Integer.parseInt(term);

	        SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd");
	        Date to = transFormat.parse(date);
	        Calendar cal = Calendar.getInstance();
	        cal.setTime(to);

	        cal.add(Calendar.MONDAY, warranty);

	        newDate = transFormat.format(cal.getTime());

	        return newDate;

		}
		catch(Exception e){
			return date;
		}
	}






	public static String LocalString(String val) {
		if (val == null)
			return null;
		else {
			byte[] b;

			try {
				b = val.getBytes("8859_1");
				CharsetDecoder decoder = Charset.forName("UTF-8").newDecoder();
				try {
					CharBuffer r = decoder.decode(ByteBuffer.wrap(b));
					return r.toString();
				} catch (CharacterCodingException e) {
					return new String(b, "EUC-KR");
				}
			} catch (UnsupportedEncodingException e1) {
				e1.printStackTrace();
			}
		}
		return null;
	}


	public Map<String, Object> test(Map<String, Object> params) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try {

			// 데이터 공백 제거
			for( String key : params.keySet() ){
				String value = params.get(key).toString();
				params.put(key, value.trim());
	        }

			String name = params.get("sReceiverName").toString();

			//System.out.println("encode10= "+name);
			String data3 = URLEncoder.encode(name,"EUC-KR");
			//System.out.println("encode000000 = "+data3);
			String data4 = encryption(data3);
			//System.out.println("encode111111 = "+data4);


//			String name = params.get("sReceiverName").toString();
			//System.out.println("name = "+name);
			String data = decryption(name);
			//System.out.println("decode1 = "+data);
			data = URLDecoder.decode(data, "EUC-KR");
			//System.out.println("decode2 = "+data);

			String data2 = URLEncoder.encode(data,"EUC-KR");
			//System.out.println("encode1 = "+data2);
			 data2 = encryption(data2);
			//System.out.println("encode2 = "+data2);

			resultMap.put("SUCCESS", true);
			return resultMap;


		} catch (Exception ex) {
			resultMap.put("sErrCd", 100);
			resultMap.put("ERROR_MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			return resultMap;
		}
	}

	public Map<String, Object> encryption(Map<String, Object> params) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try {

			//System.out.println("params = " + params);

			String data;

			for( String key : params.keySet() ){
				String value = params.get(key).toString();
				params.put(key, value.trim());
	        }

			if(params.containsKey("data")) //saleComCd
				data = params.get("data").toString();
			else {
				resultMap.put("ERROR_MSG", "파라미터 없음(data)");
				resultMap.put("SUCCESS", false);
				//System.out.println("resultMap = " + resultMap);
				return resultMap;
			}

			if(StringUtils.isEmptyOrWhitespaceOnly(data)) {
				resultMap.put("ERROR_MSG", "blank data");
				resultMap.put("SUCCESS", false);
				//System.out.println("resultMap = " + resultMap);
				return resultMap;
			}


			// 데이터 공백 제거


			String encodingData = URLEncoder.encode(data,"EUC-KR");
			//System.out.println("encodingData = "+encodingData);

//			encodingData = "%BC%AD%BF%EF%C6%AF%BA%B0%BD�=2DG2G9Ud2%Q9�kFB;4FBWiUQP9jymkF94FJ4iZSdT;lpZc5;46B4iaSgE4vrWwJ46C";
			String encryptionData = encryption(encodingData);
			//System.out.println("encryptionData = "+encryptionData);

			resultMap.put("URL_ENCODING", encodingData);
			resultMap.put("ENCRYPTION", encryptionData);
			resultMap.put("SUCCESS", true);
			return resultMap;


		} catch (Exception ex) {
			resultMap.put("sErrCd", 100);
			resultMap.put("ERROR_MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			return resultMap;
		}
	}

	public Map<String, Object> decryption(Map<String, Object> params) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try {

			//System.out.println("params = " + params);

			String data;

			for( String key : params.keySet() ){
				String value = params.get(key).toString();
				params.put(key, value.trim());
	        }

			if(params.containsKey("data")) //saleComCd
				data = params.get("data").toString();
			else {
				resultMap.put("ERROR_MSG", "파라미터 없음(data)");
				resultMap.put("SUCCESS", false);
				//System.out.println("resultMap = " + resultMap);
				return resultMap;
			}

			if(StringUtils.isEmptyOrWhitespaceOnly(data)) {
				resultMap.put("ERROR_MSG", "blank data");
				resultMap.put("SUCCESS", false);
				//System.out.println("resultMap = " + resultMap);
				return resultMap;
			}


			// 데이터 공백 제거

			try {
				String decryptionData = decryption(data);
				//System.out.println("decryptionData = "+decryptionData);
				String decodingData =URLDecoder.decode(decryptionData, "EUC-KR");
				//System.out.println("decodingData = "+decodingData);
			}
			catch(Exception ex) {

				//System.out.println("decryption error");
				resultMap.put("ERROR", "decryption error");
				resultMap.put("SUCCESS", false);
				return resultMap;
			}


//			resultMap.put("DECRYPTION", decodingData);
			resultMap.put("SUCCESS", true);
			return resultMap;


		} catch (Exception ex) {
			resultMap.put("sErrCd", 100);
			resultMap.put("ERROR_MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			return resultMap;
		}
	}











































}
