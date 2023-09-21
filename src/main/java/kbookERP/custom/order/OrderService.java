package kbookERP.custom.order;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kbookERP.custom.search.SearchMapper;
import kbookERP.custom.util.Util;

@Service
public class OrderService {

	@Autowired
	private OrderMapper orderMapper;

	@Autowired
	private SearchMapper searchMapper;

	    public Map<String, Object> getSaleDataList(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listRetMap = new ArrayList<Map<String, Object>>();

			try {

				if(params.containsKey("SEARCH_TYPE")) {

					String searchType = params.get("SEARCH_TYPE").toString();

					if(searchType.equals("SINGLE")) {
//						if(params.containsKey("PUBSHCD") || params.containsKey("PUBSH_NM")) {
//							sqlMap = searchMapper.getPubshInfo(params);
//							if(sqlMap == null) {
//								resultMap.put("MSG", "출판사 정보가 없습니다.");
//								resultMap.put("SUCCESS", false);
//								return resultMap;
//							}else
//								params.put("PUBSHCD", sqlMap.get("PUBSHCD"));
//						}

						if(params.containsKey("DEPTCD") || params.containsKey("DEPT_NM")) {
							sqlMap = searchMapper.getDeptInfo(params);
							if(sqlMap == null) {
								resultMap.put("MSG", "부코드 정보가 없습니다.");
								resultMap.put("SUCCESS", false);
								return resultMap;
							}else
								params.put("DEPTCD", sqlMap.get("DEPTCD"));
						}
					}

						if(params.containsKey("GROUPCD") || params.containsKey("GROUP_NM")) {
							sqlMap = searchMapper.getGroupInfo(params);
							if(sqlMap == null) {
								resultMap.put("MSG", "조코드 정보가 없습니다.");
								resultMap.put("SUCCESS", false);
								return resultMap;
							}else
								params.put("GROUPCD", sqlMap.get("GROUPCD"));
						}

//						if(params.containsKey("STANDCD") || params.containsKey("STAND_NM")) {
//							sqlMap = searchMapper.getStandInfo(params);
//							if(sqlMap == null) {
//								resultMap.put("MSG", "서가코드 정보가 없습니다.");
//								resultMap.put("SUCCESS", false);
//								return resultMap;
//							}else
//								params.put("STANDCD", sqlMap.get("STANDCD"));
//						}
					}

				int type = 1;

				if(params.containsKey("TYPE"))
					type = Util.getInt(params.get("TYPE"), 1);
				if(type == 1)
					listSqlMap = orderMapper.getSaleDataListRate(params);
				else
					listSqlMap = orderMapper.getSaleDataListGroup(params);

				if (listSqlMap.size() > 0) {
					resultMap.put("EXIST", true);


					int gCount;
					for(Map<String, Object> oData : listSqlMap) {

						sqlMap = orderMapper.getSaleDataEsti(oData);
						if(sqlMap != null) oData.put("ESTI_SUM", sqlMap.get("ESTI_SUM"));
						else oData.put("ESTI_SUM", 0);

						sqlMap = orderMapper.getSaleDataRet(oData);
						if(sqlMap != null) oData.put("RET_SUM", sqlMap.get("RET_SUM"));
						else oData.put("RET_SUM", 0);

						sqlMap = orderMapper.getSaleDataOrd(oData);
						if(sqlMap != null) {
							gCount = Util.getInt(sqlMap.get("ORD_SUM"), 0);
							oData.put("ORD_SUM", sqlMap.get("ORD_SUM"));
							oData.put("ORD_RATE", sqlMap.get("ORD_RATE"));
							oData.put("TRADE_ITEM", sqlMap.get("TRADE_ITEM"));
						}
						else {
							gCount = 0;
							oData.put("ORD_SUM", 0);
							oData.put("ORD_RATE", 0);
							oData.put("TRADE_ITEM", 0);

//							oData.put("RATE_KBN", 1);
//							listRetMap = searchMapper.getOrderBookPurchRate(oData);
						}

						sqlMap = orderMapper.getSaleDataInp(oData);
						if(sqlMap != null) oData.put("INP_SUM", sqlMap.get("INP_SUM"));
						else oData.put("INP_SUM", 0);

						if(gCount == 0) {
							listRetMap = orderMapper.getSaleDataInpRatio(oData);
							if(listRetMap.size() > 0) {
								oData.put("RATE", listRetMap.get(0).get("RATE"));
								oData.put("RATE_EXCEPT", true);
							}
							else
								oData.put("RATE", oData.get("ORD_RATE"));
						}
						else
							oData.put("RATE", oData.get("ORD_RATE"));
					}


					resultMap.put("DATA", listSqlMap);

//					List<Map<String, Object>> listAuthorSqlMap = new ArrayList<Map<String, Object>>();
//					List<Map<String, Object>> listEstiSqlMap = new ArrayList<Map<String, Object>>();
//					List<Map<String, Object>> listRetSqlMap = new ArrayList<Map<String, Object>>();
//					List<Map<String, Object>> listOrdSqlMap = new ArrayList<Map<String, Object>>();
//					List<Map<String, Object>> listInpSqlMap = new ArrayList<Map<String, Object>>();
//					List<Map<String, Object>> listInpRatioSqlMap = new ArrayList<Map<String, Object>>();
//
////					listAuthorSqlMap = orderMapper.getSaleDataAuthorList(params);
//					listEstiSqlMap = orderMapper.getSaleDataEstiList(params);
//					listRetSqlMap = orderMapper.getSaleDataRetList(params);
//					listOrdSqlMap = orderMapper.getSaleDataOrdList(params);
//					listInpSqlMap = orderMapper.getSaleDataInpList(params);
//					listInpRatioSqlMap = orderMapper.getSaleDataInpRatioList(params);
//
//
////					if (listAuthorSqlMap.size() > 0) {
////						resultMap.put("AUTHOR_EXIST", true);
////						resultMap.put("AUTHOR_DATA", listAuthorSqlMap);
////					}else resultMap.put("AUTHOR_EXIST", false);
//
//					if (listEstiSqlMap.size() > 0) {
//						resultMap.put("ESTI_EXIST", true);
//						resultMap.put("ESTI_DATA", listEstiSqlMap);
//					}else resultMap.put("ESTI_EXIST", false);
//
//					if (listRetSqlMap.size() > 0) {
//						resultMap.put("RET_EXIST", true);
//						resultMap.put("RET_DATA", listRetSqlMap);
//					}else resultMap.put("RET_EXIST", false);
//
//					if (listOrdSqlMap.size() > 0) {
//						resultMap.put("ORD_EXIST", true);
//						resultMap.put("ORD_DATA", listOrdSqlMap);
//					}else resultMap.put("ORD_EXIST", false);
//
//					if (listInpSqlMap.size() > 0) {
//						resultMap.put("INP_EXIST", true);
//						resultMap.put("INP_DATA", listInpSqlMap);
//					}else resultMap.put("INP_EXIST", false);
//
//					if (listInpRatioSqlMap.size() > 0) {
//						resultMap.put("INP_RATIO_EXIST", true);
//						resultMap.put("INP_RATIO_DATA", listInpRatioSqlMap);
//					}else resultMap.put("INP_RATIO_EXIST", false);

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


	    public Map<String, Object> getOrderDataList(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listStoreMap = new ArrayList<Map<String, Object>>();

			try {

//				System.out.println("params = "+params);
				listStoreMap = searchMapper.getStoreList(params);
//				System.out.println("params111 = "+params);

				if(listStoreMap.size() < 1) {
					resultMap.put("MSG", "해당점에 매장 정보가 없습니다.");
					resultMap.put("SUCCESS", false);
					return resultMap;
				}else{
					List<Long> listStoreCd = Util.getListLong(listStoreMap, "STORECD");
					params.put("LIST_STORECD", listStoreCd);

					List<Map<String, Object>> listStore = new ArrayList<Map<String, Object>>();

					for(long storecd : listStoreCd) {
						Map<String, Object> oData = new HashMap<String, Object>();
						oData.put("STORECD", storecd);
						oData.put("STORECD_COL", "STORE"+storecd);
						listStore.add(oData);
					}

					params.put("LIST_STORECD_EX", listStore);

				}


				if(params.containsKey("STORE_TYPE")) {

					String storeType = params.get("STORE_TYPE").toString();

					if(storeType.equals("SINGLE")) {
//						if(params.containsKey("PUBSHCD") || params.containsKey("PUBSH_NM")) {
//							sqlMap = searchMapper.getPubshInfo(params);
//							if(sqlMap == null) {
//								resultMap.put("MSG", "출판사 정보가 없습니다.");
//								resultMap.put("SUCCESS", false);
//								return resultMap;
//							}else
//								params.put("PUBSHCD", sqlMap.get("PUBSHCD"));
//						}

						if(params.containsKey("DEPTCD") || params.containsKey("DEPT_NM")) {
							sqlMap = searchMapper.getDeptInfo(params);
							if(sqlMap == null) {
								resultMap.put("MSG", "부코드 정보가 없습니다.");
								resultMap.put("SUCCESS", false);
								return resultMap;
							}else
								params.put("DEPTCD", sqlMap.get("DEPTCD"));
						}
					}

						if(params.containsKey("GROUPCD") || params.containsKey("GROUP_NM")) {
							sqlMap = searchMapper.getGroupInfo(params);
							if(sqlMap == null) {
								resultMap.put("MSG", "조코드 정보가 없습니다.");
								resultMap.put("SUCCESS", false);
								return resultMap;
							}else
								params.put("GROUPCD", sqlMap.get("GROUPCD"));
						}

//						if(params.containsKey("STANDCD") || params.containsKey("STAND_NM")) {
//							sqlMap = searchMapper.getStandInfo(params);
//							if(sqlMap == null) {
//								resultMap.put("MSG", "서가코드 정보가 없습니다.");
//								resultMap.put("SUCCESS", false);
//								return resultMap;
//							}else
//								params.put("STANDCD", sqlMap.get("STANDCD"));
//						}
					}

				listSqlMap = orderMapper.getOrderDataList(params);

				if (listSqlMap.size() > 0) {
					resultMap.put("EXIST", true);
					resultMap.put("DATA", listSqlMap);

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
//				sqlMap = orderMapper.checkPurchCd(params);
//
//				if (sqlMap != null) {
//					resultMap = sqlMap;
//					resultMap.put("EXIST", true);
//				} else
//					resultMap.put("EXIST", false);
				resultMap.put("SUCCESS", true);
				return resultMap;
			} catch (Exception ex) {
				System.out.println("error: " + ex);
				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);
				return resultMap;
			}
	    }

	    public Map<String, Object> insertOrderBook(Map<String, Object> params) throws Exception {
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

						sqlMap = orderMapper.getOrderBookExist(oMap);

						if(sqlMap == null)
							 orderMapper.createOrderBook(oMap);
						else
							orderMapper.UpdateOrderBook(oMap);
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

	    public Map<String, Object> insertOrderBookBySaleData(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
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

						listSqlMap = searchMapper.getVirtualShopCd(oMap);

						if(listSqlMap.size() < 1) {

							sqlMap = orderMapper.getOrderBookExist(oMap);

							if(sqlMap == null)
								 orderMapper.createOrderBook(oMap);
							else {
								oMap.put("REPLACE", true);
								orderMapper.UpdateOrderBook(oMap);
							}
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

	    public Map<String, Object> deleteOrderBookInfo(Map<String, Object> params) throws Exception {
 			Map<String, Object> resultMap = new HashMap<String, Object>();

 			try {

// 				int cnt = orderMapper.selectOrderBookInfo(params);

// 				System.out.println("CNT = "+cnt);
 				orderMapper.deleteOrderBookInfo(params);

 				resultMap.put("SUCCESS", true);
 				return resultMap;
 			} catch (Exception ex) {
 				System.out.println("error: " + ex);
 				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
 				resultMap.put("SUCCESS", false);
 				return resultMap;
 			}
 	    }

	    public Map<String, Object> updateOrderBookInfo(Map<String, Object> params) throws Exception {
 			Map<String, Object> resultMap = new HashMap<String, Object>();
 			List<Object> listData = new ArrayList<Object>();

 			try {

 				if (params.containsKey("DATA")) {
					listData = (List<Object>) params.get("DATA");

					int result;
					Map<String, Object> oMap;
					for (Object oData : listData){
						oMap = (Map<String, Object>)oData;

						result = orderMapper.updateOrderBookInfo(oMap);
						if(result == 0) {

							Map<String, Object> orderBookMap = orderMapper.getOrderBookOne(oMap);
							if(orderBookMap != null) {
								orderBookMap.put("SHOPCD", orderBookMap.get("INP_SHOPCD"));
								orderBookMap.put("STORECD", oMap.get("STORECD"));
								orderBookMap.put("ORD_CNT", oMap.get("ORD_COUNT"));
								orderMapper.createOrderBook(orderBookMap);
							}
							else {
//								orderBookMap.put("SHOPCD", orderBookMap.get("INP_SHOPCD"));
//								orderBookMap.put("ORD_CNT", oMap.get("ORD_COUNT"));
//								orderMapper.createOrderBook(oMap);
							}

//							oMap.put("SHOPCD", oMap.get("INP_SHOPCD"));
//							orderMapper.createOrderBook(oMap);
						}
					}
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

	    public Map<String, Object> confirmOrderBookList(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
//			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
//			List<Map<String, Object>> listStoreMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = orderMapper.selectOrderBookList(params);

//				System.out.println("listSqlMap.size() = "+listSqlMap.size());
				if (listSqlMap.size() > 0) {

					long hma06NookCd;
					int hor02MaxSeq;
					for(Map<String, Object> oData : listSqlMap) {

						hma06NookCd = Util.getLong(oData.get("HMA06_BOOKCD"), -1);
//						System.out.println("hma06NookCd = "+hma06NookCd);

						if(hma06NookCd == -1) {
							resultMap.put("MSG", "도서("+ oData.get("BOOKNM")+")에 대한 매입처("+oData.get("PURCHNM")+")가 없거나 매입률("+oData.get("ORD_RATE")+")이 없습니다. 데이터를 확인해주세요.");
							resultMap.put("SUCCESS", false);
							resultMap.put("REFRESH", true);
						}else {

							hor02MaxSeq = orderMapper.getHOR02MaxSeq(oData);
							oData.put("SEQ_NO", hor02MaxSeq+1);
							orderMapper.insertOrderBookConfirm(oData);
						}


					}
					resultMap.put("SUCCESS", true);

				} else{
					resultMap.put("MSG", "확정할 데이터가 없습니다.");
					resultMap.put("REFRESH", false);
					resultMap.put("SUCCESS", false);
				}


				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);
				resultMap.put("REFRESH", false);

				return resultMap;
			}
	    }

	    public Map<String, Object> clearOrderBook(Map<String, Object> params) throws Exception {
 			Map<String, Object> resultMap = new HashMap<String, Object>();
 			List<Object> listData = new ArrayList<Object>();

 			try {

 				if (params.containsKey("DATA")) {
					listData = (List<Object>) params.get("DATA");

					int result;
					Map<String, Object> oMap;
					for (Object oData : listData){
						oMap = (Map<String, Object>)oData;

						result = orderMapper.deleteOrderBookInfo(oMap);

					}
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


	    public Map<String, Object> getUnregisteredBookList(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listStoreMap = new ArrayList<Map<String, Object>>();

			try {

				listStoreMap = searchMapper.getStoreList(params);

				if(listStoreMap.size() < 1) {
					resultMap.put("MSG", "해당점에 매장 정보가 없습니다.");
					resultMap.put("SUCCESS", false);
					return resultMap;
				}

//				else{
//					List<Long> listStoreCd = Util.getListLong(listStoreMap, "STORECD");
//					params.put("LIST_STORECD", listStoreCd);
//
//					List<Map<String, Object>> listStore = new ArrayList<Map<String, Object>>();
//
//					for(long storecd : listStoreCd) {
//						Map<String, Object> oData = new HashMap<String, Object>();
//						oData.put("STORECD", storecd);
//						oData.put("STORECD_COL", "STORE"+storecd);
//						listStore.add(oData);
//					}
//
//					params.put("LIST_STORECD_EX", listStore);
//
//				}


				listSqlMap = orderMapper.getUnregisteredBookList(params);

				if (listSqlMap.size() > 0) {
					resultMap.put("EXIST", true);
					resultMap.put("DATA", listSqlMap);

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


	    public Map<String, Object> insertUnregisterdOrderBook(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Object> listData = new ArrayList<Object>();
			try {

				 orderMapper.deleteUnregisterdOrderBook(params);

				 int rowNo = orderMapper.getUnregisterdOrderBookMaxRowNo(params);

				 if (params.containsKey("DATA")) {
					listData = (List<Object>) params.get("DATA");


					Map<String, Object> oMap;
					for (Object oData : listData){
						oMap = (Map<String, Object>)oData;

						oMap.put("ROW_NO", ++rowNo);

						orderMapper.insertUnregisterdOrderBook(oMap);


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


	    public Map<String, Object> getOrderBookAllList(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listUSqlMap = new ArrayList<Map<String, Object>>();

			try {

				int registType = Util.getInt(params.get("REGIST_TYPE"), 0);

				if(registType == 0 || registType == 1){
					listSqlMap = orderMapper.getRegisterdOrderBookList(params);

					if (listSqlMap.size() > 0) {
						resultMap.put("REGISTERED_EXIST", true);
						resultMap.put("REGISTERED_DATA", listSqlMap);

					} else
						resultMap.put("REGISTERED_EXIST", false);
				}

				if(registType == 0 || registType == 2){
					listUSqlMap = orderMapper.getUnregisterdOrderBookList(params);

					if (listUSqlMap.size() > 0) {
						resultMap.put("UNREGISTERED_EXIST", true);
						resultMap.put("UNREGISTERED_DATA", listUSqlMap);

					} else
						resultMap.put("UNREGISTERED_EXIST", false);
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

	    public Map<String, Object> getOrderDataReport(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
//			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listRegisterdSqlMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listUnregisterdSqlMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listStoreMap = new ArrayList<Map<String, Object>>();

			try {

				listStoreMap = searchMapper.getStoreList(params);

				if(listStoreMap.size() < 1) {
					resultMap.put("MSG", "해당점에 매장 정보가 없습니다.");
					resultMap.put("SUCCESS", false);
					return resultMap;
				}else{
					List<Long> listStoreCd = Util.getListLong(listStoreMap, "STORECD");
					params.put("LIST_STORECD", listStoreCd);

					List<Map<String, Object>> listStore = new ArrayList<Map<String, Object>>();

					for(long storecd : listStoreCd) {
						Map<String, Object> oData = new HashMap<String, Object>();
						oData.put("STORECD", storecd);
						oData.put("STORECD_COL", "STORE"+storecd);
						listStore.add(oData);
					}

					params.put("LIST_STORECD_EX", listStore);

				}

				listRegisterdSqlMap = orderMapper.getRegisteredOrderDataList(params);

				if (listRegisterdSqlMap.size() > 0) {
					resultMap.put("REGISTERED_EXIST", true);
					resultMap.put("REGISTERED_DATA", listRegisterdSqlMap);

				} else
					resultMap.put("REGISTERED_EXIST", false);

				listUnregisterdSqlMap = orderMapper.getUnregisteredOrderDataList(params);

				if (listUnregisterdSqlMap.size() > 0) {
					resultMap.put("UNREGISTERED_EXIST", true);
					resultMap.put("UNREGISTERED_DATA", listUnregisterdSqlMap);

				} else
					resultMap.put("UNREGISTERED_EXIST", false);


				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }



























}
