package kbookERP.custom.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kbookERP.custom.search.SearchMapper;
import kbookERP.custom.util.Util;


@Service
public class CommonService {

	@Autowired
	private CommonMapper commonMapper;

	@Autowired
	private SearchMapper searchMapper;

	public synchronized String getVoucherNo() {
		return commonMapper.getVoucherNo();
	}

	public synchronized String getPaymentNo() {
		return commonMapper.getPaymentNo();
	}


	public Map<String, Object> checkGroupCd(Map<String, Object> params) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> sqlMap = new HashMap<String, Object>();
		try {
			sqlMap = searchMapper.getGroupInfo(params);
			if (sqlMap != null) {
				resultMap = sqlMap;
				resultMap.put("EXIST", true);
			} else
				resultMap.put("EXIST", false);
			resultMap.put("SUCCESS", true);
			return resultMap;
		} catch (Exception ex) {
			System.out.println("error: " + ex);
			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
			resultMap.put("SUCCESS", false);
			return resultMap;
		}
    }

	 public Map<String, Object> checkPurchCd(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			try {
				sqlMap = commonMapper.checkPurchCd(params);

				if (sqlMap != null) {
					resultMap = sqlMap;
					resultMap.put("EXIST", true);
				} else
					resultMap.put("EXIST", false);
				resultMap.put("SUCCESS", true);
				return resultMap;
			} catch (Exception ex) {
				System.out.println("error: " + ex);
				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);
				return resultMap;
			}
	    }




	public List<Map<String, Object>> getCode(String codeCls) {
		Map<String, Object> params = new HashMap<>();
		params.put("CODE_CLS", codeCls);
		List<Map<String, Object>> results = commonMapper.getCode(params);
		if(results == null)
			results = new ArrayList<>();

		return results;
	}

	public List<Map<String, Object>> getCode2(String codeCls) {
		Map<String, Object> params = new HashMap<>();
		params.put("CODE_CLS", codeCls);
		List<Map<String, Object>> results = commonMapper.getCode2(params);
		if(results == null)
			results = new ArrayList<>();

		return results;
	}

	public Map<String, Object> getCodeList(String codeCls) {

		Map<String, Object> params = new HashMap<>();
		Map<String, Object> resultMap = new HashMap<>();

		params.put("CODE_CLS", codeCls);
		List<Map<String, Object>> results = commonMapper.getCode(params);

		if(results == null || results.size() < 1) {
			results = new ArrayList<>();
				resultMap.put("SUCCESS", false);
				resultMap.put("MSG", "잘못된 코드입니다.");
				results.add(resultMap);
		}

		resultMap.put("SUCCESS", true);
		resultMap.put("DATA", results);

		return resultMap;
	}

	public String getCodeValue(String codeCls, Object codeName) {

		Map<String, Object> params = new HashMap<>();
		Map<String, Object> resultMap = new HashMap<>();

		params.put("CODE_CLS", codeCls);
		params.put("CODE_NM", codeName);
		Map<String, Object> results = commonMapper.getCodeValue(params);

		if(results == null || results.size() < 1) {
			return "-1";
		}

		return results.get("CODE_CD").toString();
	}

	public String getCodeName(String codeCls, Object codeCd) {

		Map<String, Object> params = new HashMap<>();
		Map<String, Object> resultMap = new HashMap<>();

		params.put("CODE_CLS", codeCls);
		params.put("CODE_CD", codeCd);
		Map<String, Object> results = commonMapper.getCodeName(params);

		if(results == null || results.size() < 1) {
			return "-1";
		}

		return results.get("CODE_NM").toString();
	}

	public Long queryLong(String query) {

		Map<String, Object> params = new HashMap<String, Object>();
		long result = -1;


		System.out.println("query = "+query);
		params.put("QUERY", query);
		result = commonMapper.queryLong(params);

		return result;
	}

	public Map<String, Object> executeQuery(HttpServletRequest req, Map<String, Object> params) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> newParams = new HashMap<String, Object>();

		String userId = req.getSession().getAttribute("userId").toString();
		String query = params.get("QUERY").toString();

		query = query.replace("{USER_ID}", userId);

		newParams.put("QUERY", query);

		commonMapper.exequteQuery(newParams);

		resultMap.put("SUCCESS", true);
		return resultMap;
	}

	public boolean execute(String query) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> newParams = new HashMap<String, Object>();
		try {
			newParams.put("QUERY", query);
			commonMapper.exequteQuery(newParams);

			return true;
		}
		catch(Exception ex){
			System.out.println("error:"+ex.getMessage());
			return false;
		}
	}

	public Map<String, Object> execute(Map<String, Object> params) {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		try {

			commonMapper.exequteQuery(params);
			resultMap.put("SUCCESS", true);
			return resultMap;
		}
		catch(Exception ex){
			System.out.println("error:"+ex.getMessage());
			resultMap.put("MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			return resultMap;
		}
	}

	public List<Map<String, Object>> queryList(String query) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
		Map<String, Object> newParams = new HashMap<String, Object>();

		try {

			newParams.put("QUERY", query);
			listMap = commonMapper.queryDT(newParams);

			return listMap;

		}
		catch(Exception ex){
			System.out.println("error:"+ex.getMessage());
			resultMap.put("MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			return listMap;
		}
	}

	public Map<String, Object> queryDT(Map<String, Object> params) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> sqlMap = new HashMap<String, Object>();
		List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();

		try {

			listMap = commonMapper.queryDT(params);

			if(listMap != null && listMap.size() > 0) {

				resultMap.put("DATA", listMap);
				resultMap.put("EXIST", true);
				resultMap.put("SUCCESS", true);

			}else {
				resultMap.put("MSG", "검색 결과가 없습니다.");
				resultMap.put("SUCCESS", true);
				resultMap.put("EXIST", false);
			}

//			sqlMap =  listMap.get(0);
//			System.out.println("sqlMap: " + sqlMap);
//			System.out.println("WAREHOUSE_MOVEMENT_STATE: " + listMap.get(0).get("WAREHOUSE_MOVEMENT_STATE"));

			return resultMap;
		}
		catch(Exception ex){
			System.out.println("error:"+ex.getMessage());
			resultMap.put("MSG", ex.getMessage());
			resultMap.put("SUCCESS", false);
			return resultMap;
		}
	}


	public synchronized String getSeq(String SEQ_NM) {
		Map<String, Object> map = new HashMap<>();
		map.put("SEQ_NM", SEQ_NM);
		return commonMapper.getSeq(map);
	}

	public Map<String, Object>  getCodeListTable(Map<String, Object> params) throws Exception {
		Map<String, Object> resultMap =new HashMap<String, Object>();
		Map<String, Object> newParams = new HashMap<String, Object>();
		List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();

		try{
			String tableName = params.get("CUSTOM_TABLE").toString();
			String customKey = params.get("CUSTOM_KEY").toString();
			String customValue = params.get("CUSTOM_VALUE").toString();
			String customCondition = params.get("CUSTOM_CONDITION").toString();
			String customOrder = params.get("CUSTOM_ORDER").toString();

			newParams.clear();
			newParams.put("TABLE_NAME", tableName);
			newParams.put("KEY", customKey);
			newParams.put("VALUE", customValue);
			newParams.put("CONDITION",customCondition);
			newParams.put("ORDER", customOrder);

			listMap = commonMapper.getCustomCode(newParams);

			resultMap.put("SUCCESS", true);
			resultMap.put("DATA", listMap);

			return resultMap;
		}
		catch(Exception ex)
		{
			resultMap.put("SUCCESS", false);
			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
			resultMap.put("ERROR", ex.getMessage());
			System.out.println("ERROR: "+ex.getMessage());
			return resultMap;
		}
	}

	public Map<String, Object>  getTable(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap =new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();
			List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();

			try{
				String tableName = params.get("CUSTOM_TABLE").toString();
				String customColumn = params.get("CUSTOM_COLUMN").toString();
				String customCondition = params.get("CUSTOM_CONDITION").toString();
				String customOrder = params.get("CUSTOM_ORDER").toString();


				newParams.clear();
				newParams.put("TABLE_NAME", tableName);
				newParams.put("COLUMNS", customColumn);
				newParams.put("CONDITION",customCondition);
				newParams.put("ORDER", customOrder);
				if(params.containsKey("CUSTOM_GROUP"))
					newParams.put("GROUP", params.get("CUSTOM_GROUP"));

				listMap = commonMapper.getTable(newParams);

				resultMap.put("SUCCESS", true);
				resultMap.put("DATA", listMap);

				return resultMap;
			}
			catch(Exception ex)
			{
				resultMap.put("SUCCESS", false);
				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("ERROR", ex.getMessage());
				System.out.println("ERROR: "+ex.getMessage());
				return resultMap;
			}
	}

	public Map<String, List<Map<String, Object>>> getCodeListCustom(Map<String, Object> params) throws Exception {
		Map<String, List<Map<String, Object>>> resultMap = new HashMap<String, List<Map<String, Object>>>();
		Map<String, Object> newParams = new HashMap<String, Object>();



		if(params.containsKey("CODE")) {
			String code = params.get("CODE").toString();
//			code = code.substring(1, code.length()-1);
			String[] arrayCode = code.split(",");

			for(String cd:arrayCode) {
				List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
				listSqlMap = getCode2(cd);
				resultMap.put(cd, listSqlMap);
			}
		}

//		System.out.println("params.containsKey(\"CUSTOM\") = "+params.containsKey("CUSTOM"));

		if(params.containsKey("CUSTOM")) {

			String tableName = params.get("CUSTOM").toString();
//			tableName = tableName.substring(1, tableName.length()-1);
			String[] arrayTableName = tableName.split(",");

			String customKey = params.get("CUSTOM_KEY").toString();
//			customKey = customKey.substring(1, customKey.length()-1);
			String[] arrayCustomKey = customKey.split(",");

			String customCondition = params.get("CUSTOM_CONDITION").toString();
//			customCondition = customCondition.substring(1, customCondition.length()-1);
			String[] arrayCustomCondition = customCondition.split(",");

			String customOrder = params.get("CUSTOM_ORDER").toString();
//			customOrder = customOrder.substring(1, customOrder.length()-1);
			String[] arrayCustomOrder= customOrder.split(",");


			for(int i = 0 ; i < arrayTableName.length; i++ ) {
				List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

				newParams.clear();
				newParams.put("TABLE_NAME", arrayTableName[i]);
				newParams.put("KEY", arrayCustomKey[i*2]);
				newParams.put("VALUE", arrayCustomKey[i*2+1]);
				newParams.put("CONDITION", arrayCustomCondition[i]);
				newParams.put("ORDER", arrayCustomOrder[i]);

				listSqlMap = commonMapper.getCustomCode(newParams);
				resultMap.put(arrayTableName[i], listSqlMap);
			}

		}

		return resultMap;
	}


	 public Map<String, Object> getVisibleCol(HttpServletRequest req, Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			List<Map<String, Object>> listTableColMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = commonMapper.getVisibleCol(params);

				if(listSqlMap.size() > 0) {

					listTableColMap = commonMapper.getTableCol(params);

					if(listSqlMap.size() == listTableColMap.size()) {

						resultMap.put("EXIST", true);
						resultMap.put("DATA", listSqlMap);
					}else {

						Map<Long, Map<String, Object>> listTableColIdMap = new HashMap<Long, Map<String, Object>>();
						Map<Long, Map<String, Object>> listVisibleColIdMap = new HashMap<Long, Map<String, Object>>();
						long id;
						int tableColCnt = 0;
						int visibleColCnt = 0;

						for(Map<String, Object> oData : listTableColMap) {
							id = Util.getLong(oData.get("TABLE_COL_ID"), 0);
							listTableColIdMap.put(id, oData);
							tableColCnt++;
						}

						for(Map<String, Object> oData : listSqlMap) {
							id = Util.getLong(oData.get("TABLE_COL_ID"), 0);
							listVisibleColIdMap.put(id, oData);
							visibleColCnt++;
						}

						Map<String, Object> vData;

						if(tableColCnt > visibleColCnt) {

							for( long key : listTableColIdMap.keySet() ){

								if(!listVisibleColIdMap.containsKey(key)) {

									vData = listTableColIdMap.get(key);
									vData.put("VISIBLE_YN", 1);
									vData.put("USER_ID", params.get("USER_ID"));
//									System.out.println("vData = "+vData);
									commonMapper.createVisibleColOne(vData);
								}
					        }
						}

						listSqlMap = commonMapper.getVisibleCol(params);
						resultMap.put("EXIST", true);
						resultMap.put("DATA", listSqlMap);
					}

				}else {

					listTableColMap = commonMapper.getTableCol(params);
//					List<Long> listTableColId = new ArrayList<Long>();
//
//					for(Map<String, Object> oData: listTableColMap) {
//
//						listTableColId.add(Util.getLong(oData.get("TABLE_COL_ID"), (long)0));
//					}

					if(listTableColMap.size() < 1)
						resultMap.put("EXIST", false);
					else {
						params.put("LIST_COL", listTableColMap);
						params.put("VISIBLE_YN", 1);
						commonMapper.createVisibleCol(params);

						listSqlMap = commonMapper.getVisibleCol(params);

						if(listSqlMap.size() > 0) {

							resultMap.put("EXIST", true);
							resultMap.put("DATA", listSqlMap);

						}else
							resultMap.put("EXIST", false);
					}
				}

				resultMap.put("SUCCESS", true);
				return resultMap;

			}catch(Exception ex) {
				resultMap.put("SUCCESS", false);
				resultMap.put("ERROR", ex.getMessage());
				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				System.out.println("ERROR: "+ex.getMessage());

				return resultMap;
			}
		}


	 public Map<String, Object> updateVisibleCol(HttpServletRequest req, Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Object> listData = new ArrayList<Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				if (params.containsKey("DATA")) {
					listData = (List<Object>) params.get("DATA");

					for (Object oData : listData) {
						Map<String, Object> data = new HashMap<String, Object>();
						data = (Map<String, Object>) oData;
						data.put("USER_ID", params.get("USER_ID"));

						commonMapper.updateVisibleCol(data);
					}
				}
				else {
					commonMapper.updateVisibleCol(params);
				}

				resultMap.put("SUCCESS", true);
				return resultMap;

			}catch(Exception ex) {
				resultMap.put("SUCCESS", false);
				resultMap.put("ERROR", ex.getMessage());
				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				System.out.println("ERROR: "+ex.getMessage());

				return resultMap;
			}
		}


	 public Map<String, Object> getCodeTable(Map<String, Object> params) throws Exception {
	    	Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();
			List<Object> listComponent = new ArrayList<Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			List<String> listCol = new ArrayList<String>();

			try {

				listSqlMap = commonMapper.getCodeTable(params);

				if(listSqlMap.size() < 1)
				{
					resultMap.put("EXIST", false);
				}
				else
				{
					resultMap.put("EXIST", true);
					resultMap.put("DATA", listSqlMap);
				}

				resultMap.put("SUCCESS", true);

				return resultMap;
		    }catch(Exception ex) {

		    	System.out.println("error: "+ex);
		    	resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
		    }
	    }

	 public Map<String, Object> getCodeListTable1(Map<String, Object> params) throws Exception {
	    	Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();
			List<Object> listComponent = new ArrayList<Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			List<String> listCol = new ArrayList<String>();

			try {

				listSqlMap = commonMapper.getCodeListTable1(params);

				if(listSqlMap.size() < 1)
				{
					resultMap.put("EXIST", false);
				}
				else
				{
					resultMap.put("EXIST", true);
					resultMap.put("DATA", listSqlMap);
				}

				resultMap.put("SUCCESS", true);

				return resultMap;
		    }catch(Exception ex) {

		    	System.out.println("error: "+ex);
		    	resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
		    }
	    }

	 public Map<String, Object> updateCode(Map<String, Object> params) throws Exception {

//	   	  Map<String, Object> newParams = new HashMap<String, Object>();
	         Map<String, Object> resultMap = new HashMap<String, Object>();
//	         List<Object> listPart= new ArrayList<Object>();
//	         Map<Object, Object> faultIdMap = new HashMap<Object, Object>();
//	         List<Map<String, Object>> listFaultPart= new ArrayList<Map<String, Object>>();

	         try {

	        	 commonMapper.updateCode(params);

	        	 commonMapper.updateSubCode(params);

		            resultMap.put("SUCCESS", true);
		            resultMap.put("MSG", "처리되었습니다.");
		            return resultMap;

	         } catch (Exception ex) {
	             resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
	             resultMap.put("ERROR", ex.getMessage());
	             resultMap.put("SUCCESS", false);
	             return resultMap;
	         }
	     }

		 public Map<String, Object> updateCodeList(Map<String, Object> params) throws Exception {

//		   	  Map<String, Object> newParams = new HashMap<String, Object>();
		         Map<String, Object> resultMap = new HashMap<String, Object>();

		         try {

//		        	 newParams.put("CODE_CLS", params.get("CODE_CLS"));
//		        	 newParams.put("CODE_CD", params.get("OLD_CODE_CD"));
//
//		        	 int cnt = commonMapper.checkCodeListInfo(newParams);
//
//		        	 if(cnt > 0) {
//		        		 resultMap.put("MSG", "이미 존재하는 코드번호입니다.");
//			             resultMap.put("SUCCESS", false);
//		        	 }
//		        	 else
		        	 {
			        	 commonMapper.updateCodeList(params);
			        	 resultMap.put("SUCCESS", true);
			        	 resultMap.put("MSG", "처리되었습니다.");
		        	 }

		        	 return resultMap;

		         } catch (Exception ex) {
		             resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
		             resultMap.put("ERROR", ex.getMessage());
		             resultMap.put("SUCCESS", false);
		             return resultMap;
		         }
		     }

		 public Map<String, Object> createCode(Map<String, Object> params) throws Exception {

//		   	  Map<String, Object> newParams = new HashMap<String, Object>();
		         Map<String, Object> resultMap = new HashMap<String, Object>();
//		         List<Object> listPart= new ArrayList<Object>();
//		         Map<Object, Object> faultIdMap = new HashMap<Object, Object>();
//		         List<Map<String, Object>> listFaultPart= new ArrayList<Map<String, Object>>();

		         try {

		        	 int root = Util.getInt(params.get("ROOT"), 0);

		        	 commonMapper.createCode(params);

			            resultMap.put("SUCCESS", true);
			            resultMap.put("MSG", "처리되었습니다.");
			            return resultMap;

		         } catch (Exception ex) {
		             resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
		             resultMap.put("ERROR", ex.getMessage());
		             resultMap.put("SUCCESS", false);
		             return resultMap;
		         }
		     }

		 public Map<String, Object> createCodeList(Map<String, Object> params) throws Exception {

//		   	  Map<String, Object> newParams = new HashMap<String, Object>();
		         Map<String, Object> resultMap = new HashMap<String, Object>();
//		         List<Object> listPart= new ArrayList<Object>();
//		         Map<Object, Object> faultIdMap = new HashMap<Object, Object>();
//		         List<Map<String, Object>> listFaultPart= new ArrayList<Map<String, Object>>();

		         try {

		        	 commonMapper.createCodeList(params);

			            resultMap.put("SUCCESS", true);
			            resultMap.put("MSG", "처리되었습니다.");
			            return resultMap;

		         } catch (Exception ex) {
		             resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
		             resultMap.put("ERROR", ex.getMessage());
		             resultMap.put("SUCCESS", false);
		             return resultMap;
		         }
		     }


		 public Map<String, Object> deleteCode(Map<String, Object> params) throws Exception {

//		   	  Map<String, Object> newParams = new HashMap<String, Object>();
		         Map<String, Object> resultMap = new HashMap<String, Object>();
//		         List<Object> listPart= new ArrayList<Object>();
//		         Map<Object, Object> faultIdMap = new HashMap<Object, Object>();
//		         List<Map<String, Object>> listFaultPart= new ArrayList<Map<String, Object>>();

		         try {

		        	 commonMapper.deleteCode(params);

			            resultMap.put("SUCCESS", true);
			            resultMap.put("MSG", "처리되었습니다.");
			            return resultMap;

		         } catch (Exception ex) {
		             resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
		             resultMap.put("ERROR", ex.getMessage());
		             resultMap.put("SUCCESS", false);
		             return resultMap;
		         }
		     }


		 public Map<String, Object> deleteCodeList(Map<String, Object> params) throws Exception {

//		   	  Map<String, Object> newParams = new HashMap<String, Object>();
		         Map<String, Object> resultMap = new HashMap<String, Object>();
//		         List<Object> listPart= new ArrayList<Object>();
//		         Map<Object, Object> faultIdMap = new HashMap<Object, Object>();
//		         List<Map<String, Object>> listFaultPart= new ArrayList<Map<String, Object>>();

		         try {

		        	 commonMapper.deleteCodeList(params);

			            resultMap.put("SUCCESS", true);
			            resultMap.put("MSG", "처리되었습니다.");
			            return resultMap;

		         } catch (Exception ex) {
		             resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
		             resultMap.put("ERROR", ex.getMessage());
		             resultMap.put("SUCCESS", false);
		             return resultMap;
		         }
		     }






























}
