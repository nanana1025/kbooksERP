package kbookERP.custom.returns;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kbookERP.custom.register.RegisterMapper;
import kbookERP.custom.util.Util;

@Service
public class ReturnsService {

	@Autowired
	private ReturnsMapper returnsMapper;

	@Autowired
	private RegisterMapper registerMapper;




	 public Map<String, Object> getBookList4Return(Map<String, Object> params) throws Exception {
	    	/* 여기에 작성 */
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = returnsMapper.getBookList4Return(params);

				if (listSqlMap.size() > 0) {
					resultMap.put("EXIST", true);
					resultMap.put("DATA", listSqlMap);

					List<Map<String, Object>> listPurchaseProcessMap = new ArrayList<Map<String, Object>>();

					listPurchaseProcessMap = returnsMapper.getPurchaseProcessList(params);

					if (listPurchaseProcessMap.size() > 0) {
						resultMap.put("PURCH_EXIST", true);
						resultMap.put("PURCH_DATA", listPurchaseProcessMap);

					} else {
						resultMap.put("PURCH_EXIST", false);
					}
				} else {
					resultMap.put("EXIST", false);
				}

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> getPurchaseRate(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listReturnCntMap = new ArrayList<Map<String, Object>>();
			try {

				listSqlMap = returnsMapper.getPurchaseRate(params);

				if (listSqlMap.size() > 0) {
					resultMap.put("EXIST", true);
					resultMap.put("DATA", listSqlMap);

				} else {
					resultMap.put("EXIST", false);
				}

				int returnPlanCnt = returnsMapper.getReturnPlanCnt(params);

				resultMap.put("RETURN_PLAN_CNT", returnPlanCnt);

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> insertReturnBook(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Object> listData = new ArrayList<Object>();
//			List<Integer> listSuccessId = new ArrayList<Integer>();
			try {

				if (params.containsKey("DATA")) {
					listData = (List<Object>) params.get("DATA");

					int id;
					int ordCnt;
					int existCnt;
					Map<String, Object> oMap;
					for (Object oData : listData){
						oMap = (Map<String, Object>)oData;

						id = Util.getInt(oMap.get("ID"), -1);

						sqlMap = returnsMapper.getReturnBookExist(oMap);

						if(sqlMap == null)
							returnsMapper.createReturnBook(oMap);
						else
							returnsMapper.UpdateReturnBook(oMap);
					}

				}

				resultMap.put("SUCCESS", true);
				return resultMap;
			} catch (Exception ex) {
				resultMap.put("SUCCESS", false);
				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("ERROR", ex.getMessage());
				return resultMap;
			}
		}

	 public Map<String, Object> getPurchInfo4return(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			try {

				listSqlMap = returnsMapper.getPurchInfo4return(params);

				if (listSqlMap.size() > 0) {
					resultMap.put("EXIST", true);
					resultMap.put("DATA", listSqlMap);

				} else {
					resultMap.put("EXIST", false);
				}

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> getGroupInfo4return(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			try {

				listSqlMap = returnsMapper.getGroupInfo4return(params);

				if (listSqlMap.size() > 0) {
					resultMap.put("EXIST", true);
					resultMap.put("DATA", listSqlMap);

				} else {
					resultMap.put("EXIST", false);
				}

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> getStoreInfo4return(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			try {

				listSqlMap = returnsMapper.getStoreInfo4return(params);

				if (listSqlMap.size() > 0) {
					resultMap.put("EXIST", true);
					resultMap.put("DATA", listSqlMap);

				} else {
					resultMap.put("EXIST", false);
				}

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> getReturnBookList(Map<String, Object> params) throws Exception {
	    	/* 여기에 작성 */
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = returnsMapper.getReturnBookList(params);

				if (listSqlMap.size() > 0) {
					resultMap.put("EXIST", true);
					resultMap.put("DATA", listSqlMap);

//					List<Map<String, Object>> listPurchaseProcessMap = new ArrayList<Map<String, Object>>();

//					listPurchaseProcessMap = returnsMapper.getPurchaseProcessList(params);
//
//					if (listPurchaseProcessMap.size() > 0) {
//						resultMap.put("PURCH_EXIST", true);
//						resultMap.put("PURCH_DATA", listPurchaseProcessMap);
//
//					} else {
//						resultMap.put("PURCH_EXIST", false);
//					}
				} else {
					resultMap.put("EXIST", false);
				}

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> saveReturnBook(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Object> listData = new ArrayList<Object>();
//			List<Integer> listSuccessId = new ArrayList<Integer>();
			try {

				if (params.containsKey("DATA")) {
					listData = (List<Object>) params.get("DATA");

					int id;
//					int ordCnt;
//					int existCnt;
					int returnCnt;
					Map<String, Object> oMap;
					for (Object oData : listData){
						oMap = (Map<String, Object>)oData;

						returnCnt= Util.getInt(oMap.get("RETURN_CNT"), -1);

						if(returnCnt == 0) {
							returnsMapper.deleteReturnBook(oMap);
						}else {
							id = Util.getInt(oMap.get("ID"), -1);

//							sqlMap = returnsMapper.getReturnBookExist(oMap);
//
//							if(sqlMap == null)
//								returnsMapper.createReturnBook(oMap);
//							else
								returnsMapper.UpdateReturnBook4confirm(oMap);
						}
					}

				}

				resultMap.put("SUCCESS", true);
				return resultMap;
			} catch (Exception ex) {
				resultMap.put("SUCCESS", false);
				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("ERROR", ex.getMessage());
				return resultMap;
			}
		}

	 public Map<String, Object> confirmReturnBook(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Object> listData = new ArrayList<Object>();
//			List<Integer> listSuccessId = new ArrayList<Integer>();
			try {



				listSqlMap = returnsMapper.getReturnBookListAll(params);

				if (listSqlMap.size() > 0) {

					long hma06NookCd;
					int hor02MaxSeq;
					int returnChitNo;
					int retKbn;
					int gChitKbn;

					int row = 1;
					int result;
					int returnPlanCnt;

//					LocalDateTime now = LocalDateTime.now();
//					DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
//					String formatedNow = now.format(formatter);

					sqlMap = registerMapper.getToday(params);

					for(Map<String, Object> oData : listSqlMap) {

						retKbn = Util.getInt(oData.get("RET_KBN"), 0);

						if(retKbn == 1)
							gChitKbn = 28;
						else
							gChitKbn = 29;

						returnChitNo = returnsMapper.getRETURN_CHIT_NO(oData);
						returnsMapper.updateRETURN_CHIT_NO(oData);

						oData.put("CHIT_NO", returnChitNo);
						oData.put("CHIT_KBN", gChitKbn);
						oData.put("ROW_NO", row);
						oData.put("CHIT_DATE", sqlMap.get("TODAY"));
						oData.put("RET_FG", 1);

						result = returnsMapper.insertHRE04(oData);

						returnPlanCnt = returnsMapper.checkHRE03(oData);

						if(returnPlanCnt < 0)
							returnsMapper.insertReturnBookConfirm(oData);
						else
							returnsMapper.updateHRE03(oData);

						oData.put("RATE_KBN_O", oData.get("RATE_KBN"));

						returnsMapper.deleteReturnBook(oData);

						row++;
					}

					resultMap.put("SUCCESS", true);

				} else{
					resultMap.put("MSG", "확정할 데이터가 없습니다.");
					resultMap.put("REFRESH", false);
					resultMap.put("SUCCESS", false);
				}

				return resultMap;
			} catch (Exception ex) {
				resultMap.put("SUCCESS", false);
				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("ERROR", ex.getMessage());
				return resultMap;
			}
		}






































}
