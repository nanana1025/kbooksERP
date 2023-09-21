package kbookERP.custom.search;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SearchService {

	@Autowired
	private SearchMapper searchMapper;


	    public Map<String, Object> getSearchBookList(Map<String, Object> params) throws Exception {
	    	/* 여기에 작성 */
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				if(params.containsKey("PUBSHCD") || params.containsKey("PUBSH_NM")) {
					sqlMap = searchMapper.getPubshInfo(params);
					if(sqlMap == null) {
						resultMap.put("MSG", "출판사 정보가 없습니다.");
						resultMap.put("SUCCESS", false);
						return resultMap;
					}else
						params.put("PUBSHCD", sqlMap.get("PUBSHCD"));
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

				if(params.containsKey("STANDCD") || params.containsKey("STAND_NM")) {
					sqlMap = searchMapper.getStandInfo(params);
					if(sqlMap == null) {
						resultMap.put("MSG", "서가코드 정보가 없습니다.");
						resultMap.put("SUCCESS", false);
						return resultMap;
					}else
						params.put("STANDCD", sqlMap.get("STANDCD"));
				}

				listSqlMap = searchMapper.getSearchBookList(params);

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

	    public Map<String, Object> getSearchBookList4Purchase(Map<String, Object> params) throws Exception {
	    	/* 여기에 작성 */
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				if(params.containsKey("PUBSHCD") || params.containsKey("PUBSH_NM")) {
					sqlMap = searchMapper.getPubshInfo(params);
					if(sqlMap == null) {
						resultMap.put("MSG", "출판사 정보가 없습니다.");
						resultMap.put("SUCCESS", false);
						return resultMap;
					}else
						params.put("PUBSHCD", sqlMap.get("PUBSHCD"));
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

				if(params.containsKey("STANDCD") || params.containsKey("STAND_NM")) {
					sqlMap = searchMapper.getStandInfo(params);
					if(sqlMap == null) {
						resultMap.put("MSG", "서가코드 정보가 없습니다.");
						resultMap.put("SUCCESS", false);
						return resultMap;
					}else
						params.put("STANDCD", sqlMap.get("STANDCD"));
				}

				listSqlMap = searchMapper.getSearchBookList4Purchase(params);

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

	    public Map<String, Object> getBookList(Map<String, Object> params) throws Exception {
	    	/* 여기에 작성 */
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

//				if(params.containsKey("BOOKNM")) {
//					if(params.containsKey("PURCHCD"))
//						listSqlMap = searchMapper.getBookList(params);
//					else
//						listSqlMap = searchMapper.getBookListWithName(params);
//				}
//				else {
//					if(params.containsKey("PURCHCD"))
//						listSqlMap = searchMapper.getBookListWithPurchCd(params);
//					else
//						listSqlMap = searchMapper.getBookList(params);
//				}

				listSqlMap = searchMapper.getBookList(params);

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

	    public Map<String, Object> getBookListByBookCd(Map<String, Object> params) throws Exception {
	    	/* 여기에 작성 */
			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = searchMapper.getBookList(params);

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

	    public Map<String, Object> getNewBooksList(Map<String, Object> params) throws Exception {
	    	/* 여기에 작성 */
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				if(params.containsKey("SEARCH_TYPE")) {

					String searchType = params.get("SEARCH_TYPE").toString();

					if(searchType.equals("SINGLE")) {
						if(params.containsKey("PUBSHCD") || params.containsKey("PUBSH_NM")) {
							sqlMap = searchMapper.getPubshInfo(params);
							if(sqlMap == null) {
								resultMap.put("MSG", "출판사 정보가 없습니다.");
								resultMap.put("SUCCESS", false);
								return resultMap;
							}else
								params.put("PUBSHCD", sqlMap.get("PUBSHCD"));
						}

						if(params.containsKey("DEPTCD") || params.containsKey("DEPT_NM")) {
							sqlMap = searchMapper.getDeptInfo(params);
							if(sqlMap == null) {
								resultMap.put("MSG", "부코드 정보가 없습니다.");
								resultMap.put("SUCCESS", false);
								return resultMap;
							}else
								params.put("DEPTCD", sqlMap.get("DEPTCD"));
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

						if(params.containsKey("STANDCD") || params.containsKey("STAND_NM")) {
							sqlMap = searchMapper.getStandInfo(params);
							if(sqlMap == null) {
								resultMap.put("MSG", "서가코드 정보가 없습니다.");
								resultMap.put("SUCCESS", false);
								return resultMap;
							}else
								params.put("STANDCD", sqlMap.get("STANDCD"));
						}
					}

					listSqlMap = searchMapper.getNewBooksList(params);

					if (listSqlMap.size() > 0) {
						resultMap.put("EXIST", true);
						if(searchType.equals("SINGLE"))
							resultMap.put("ORGAN_NM", sqlMap.get("ORGAN_NM"));
						resultMap.put("DATA", listSqlMap);
					} else
						resultMap.put("EXIST", false);
				}
				else {

					listSqlMap = searchMapper.getNewBooksList(params);

					if (listSqlMap.size() > 0) {
						resultMap.put("EXIST", true);
//						if(searchType.equals("SINGLE"))
//							resultMap.put("ORGAN_NM", sqlMap.get("ORGAN_NM"));
						resultMap.put("DATA", listSqlMap);
					} else
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

	    public Map<String, Object> getBestSellerBooksList(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				if(params.containsKey("SEARCH_TYPE")) {

					String searchType = params.get("SEARCH_TYPE").toString();

					if(searchType.equals("SINGLE")) {
						if(params.containsKey("PUBSHCD") || params.containsKey("PUBSH_NM")) {
							sqlMap = searchMapper.getPubshInfo(params);
							if(sqlMap == null) {
								resultMap.put("MSG", "출판사 정보가 없습니다.");
								resultMap.put("SUCCESS", false);
								return resultMap;
							}else
								params.put("PUBSHCD", sqlMap.get("PUBSHCD"));
						}

						if(params.containsKey("DEPTCD") || params.containsKey("DEPT_NM")) {
							sqlMap = searchMapper.getDeptInfo(params);
							if(sqlMap == null) {
								resultMap.put("MSG", "부코드 정보가 없습니다.");
								resultMap.put("SUCCESS", false);
								return resultMap;
							}else
								params.put("DEPTCD", sqlMap.get("DEPTCD"));
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

						if(params.containsKey("STANDCD") || params.containsKey("STAND_NM")) {
							sqlMap = searchMapper.getStandInfo(params);
							if(sqlMap == null) {
								resultMap.put("MSG", "서가코드 정보가 없습니다.");
								resultMap.put("SUCCESS", false);
								return resultMap;
							}else
								params.put("STANDCD", sqlMap.get("STANDCD"));
						}
					}
				}

				listSqlMap = searchMapper.getBestSellerBooksList(params);

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

	    public Map<String, Object> getBookInfoDetail(Map<String, Object> params) throws Exception {

			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> bookInfo = new HashMap<String, Object>();

			try {

				bookInfo = searchMapper.getBookInfoDetail(params);

				if (bookInfo != null) {
					resultMap = bookInfo;
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

	    public Map<String, Object> getShopBookInfoDetail(Map<String, Object> params) throws Exception {

			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> bookInfo = new HashMap<String, Object>();

			try {

				bookInfo = searchMapper.getShopBookInfoDetail(params);

				if (bookInfo != null) {
					resultMap = bookInfo;
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

	    public Map<String, Object> getPurchaseList(Map<String, Object> params) throws Exception {

	    	Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = searchMapper.getPurchaseList(params);

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

	    public Map<String, Object> getPurchaseList4Order(Map<String, Object> params) throws Exception {

	    	Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = searchMapper.getPurchaseList4Order(params);

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

	    public Map<String, Object> getPurchaseDetail(Map<String, Object> params) throws Exception {

	    	Map<String, Object> resultMap = new HashMap<String, Object>();
	    	Map<String, Object> PurchaseMap = new HashMap<String, Object>();
//			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				PurchaseMap = searchMapper.getPurchaseDetail(params);

				if (PurchaseMap != null) {
					resultMap = PurchaseMap;
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


	    public Map<String, Object> getPublisherList(Map<String, Object> params) throws Exception {

	    	Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = searchMapper.getPublisherList(params);

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



	    public Map<String, Object> getBookPurchasInfo(Map<String, Object> params) throws Exception {

	    	Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = searchMapper.getBookPurchaseInfo(params);

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

	    public Map<String, Object> getSearchPublisherOutcome(Map<String, Object> params) throws Exception {

	    	Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listLDCountAMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listLDCountBMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listWarehouseMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = searchMapper.getPublisherOutcome(params);

				if (listSqlMap.size() > 0) {
					resultMap.put("EXIST", true);
					resultMap.put("DATA", listSqlMap);
				} else
					resultMap.put("EXIST", false);

				listLDCountAMap = searchMapper.getPublisherLDA(params);

				if (listLDCountAMap.size() > 0) {
					resultMap.put("LD_A_EXIST", true);
					resultMap.put("LD_A_DATA", listLDCountAMap);
				} else
					resultMap.put("LD_A_EXIST", false);

				listLDCountBMap = searchMapper.getPublisherLDB(params);

				if (listLDCountBMap.size() > 0) {
					resultMap.put("LD_B_EXIST", true);
					resultMap.put("LD_B_DATA", listLDCountBMap);
				} else
					resultMap.put("LD_B_EXIST", false);

				listWarehouseMap = searchMapper.getPublisherWarehouse(params);

				if (listWarehouseMap.size() > 0) {
					resultMap.put("WAREHOUSE_EXIST", true);
					resultMap.put("WAREHOUSE_DATA", listWarehouseMap);
				} else
					resultMap.put("WAREHOUSE_EXIST", false);


				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	    public Map<String, Object> getOrderBookPurchRate(Map<String, Object> params) throws Exception {

	    	Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = searchMapper.getOrderBookPurchRate(params);

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

	    public Map<String, Object> getOrderBookCntInfo(Map<String, Object> params) throws Exception {

	    	Map<String, Object> resultMap = new HashMap<String, Object>();
	    	Map<String, Object> PurchaseMap = new HashMap<String, Object>();
//			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				int inpCnt = searchMapper.getOrderBookInpCnt(params);
				int ordCnt = searchMapper.getOrderBookOrdCnt(params);
				int returnCnt = searchMapper.getOrderBookReturnCnt(params);
				int estiCnt = searchMapper.getOrderBookEstiCnt(params);

				resultMap.put("INP_CNT", inpCnt);
				resultMap.put("ORD_CNT", ordCnt);
				resultMap.put("RETURN_CNT", returnCnt);
				resultMap.put("ESTI_CNT", estiCnt);

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	    public Map<String, Object> checkHMA02(Map<String, Object> params) throws Exception {

	    	Map<String, Object> resultMap = new HashMap<String, Object>();
	    	Map<String, Object> sqlMap = new HashMap<String, Object>();
//			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				sqlMap = searchMapper.checkHMA02(params);

				if (sqlMap == null)
					resultMap.put("EXIST", false);
				else {
					resultMap = sqlMap;
					resultMap.put("EXIST", true);
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

	    public Map<String, Object> getBookSalePerformance(Map<String, Object> params) throws Exception {

	    	Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listPreformanceMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listLDCountAMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listLDCountBMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listWarehouseMap = new ArrayList<Map<String, Object>>();

			try {

				listPreformanceMap = searchMapper.getBookSalePerformance1(params);

				if (listPreformanceMap.size() > 0) {
					resultMap.put("EXIST", true);
					resultMap.put("DATA1", listPreformanceMap);


					listLDCountAMap = searchMapper.getPublisherLDA(params);

					if (listLDCountAMap.size() > 0) {
						resultMap.put("LD_A_EXIST", true);
						resultMap.put("LD_A_DATA", listLDCountAMap);
					} else
						resultMap.put("LD_A_EXIST", false);

					listLDCountBMap = searchMapper.getPublisherLDB(params);

					if (listLDCountBMap.size() > 0) {
						resultMap.put("LD_B_EXIST", true);
						resultMap.put("LD_B_DATA", listLDCountBMap);
					} else
						resultMap.put("LD_B_EXIST", false);

					listWarehouseMap = searchMapper.getPublisherWarehouse(params);

					if (listWarehouseMap.size() > 0) {
						resultMap.put("WAREHOUSE_EXIST", true);
						resultMap.put("WAREHOUSE_DATA", listWarehouseMap);
					} else
						resultMap.put("WAREHOUSE_EXIST", false);

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











































//	    public Map<String, Object> getSaleDataList(Map<String, Object> params) throws Exception {
//			Map<String, Object> resultMap = new HashMap<String, Object>();
////			Map<String, Object> newParams = new HashMap<String, Object>();
//			Map<String, Object> sqlMap = new HashMap<String, Object>();
//			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
//
//			try {
//
//				if(params.containsKey("SEARCH_TYPE")) {
//
//					String searchType = params.get("SEARCH_TYPE").toString();
//
//					if(searchType.equals("SINGLE")) {
////						if(params.containsKey("PUBSHCD") || params.containsKey("PUBSH_NM")) {
////							sqlMap = searchMapper.getPubshInfo(params);
////							if(sqlMap == null) {
////								resultMap.put("MSG", "출판사 정보가 없습니다.");
////								resultMap.put("SUCCESS", false);
////								return resultMap;
////							}else
////								params.put("PUBSHCD", sqlMap.get("PUBSHCD"));
////						}
//
//						if(params.containsKey("DEPTCD") || params.containsKey("DEPT_NM")) {
//							sqlMap = searchMapper.getDeptInfo(params);
//							if(sqlMap == null) {
//								resultMap.put("MSG", "부코드 정보가 없습니다.");
//								resultMap.put("SUCCESS", false);
//								return resultMap;
//							}else
//								params.put("DEPTCD", sqlMap.get("DEPTCD"));
//						}
//					}
//
//						if(params.containsKey("GROUPCD") || params.containsKey("GROUP_NM")) {
//							sqlMap = searchMapper.getGroupInfo(params);
//							if(sqlMap == null) {
//								resultMap.put("MSG", "조코드 정보가 없습니다.");
//								resultMap.put("SUCCESS", false);
//								return resultMap;
//							}else
//								params.put("GROUPCD", sqlMap.get("GROUPCD"));
//						}
//
////						if(params.containsKey("STANDCD") || params.containsKey("STAND_NM")) {
////							sqlMap = searchMapper.getStandInfo(params);
////							if(sqlMap == null) {
////								resultMap.put("MSG", "서가코드 정보가 없습니다.");
////								resultMap.put("SUCCESS", false);
////								return resultMap;
////							}else
////								params.put("STANDCD", sqlMap.get("STANDCD"));
////						}
//					}
//
//				listSqlMap = searchMapper.getSaleDataList(params);
//
//				if (listSqlMap.size() > 0) {
//					resultMap.put("EXIST", true);
//					resultMap.put("DATA", listSqlMap);
//				} else
//					resultMap.put("EXIST", false);
//
//
//				resultMap.put("SUCCESS", true);
//				return resultMap;
//
//			} catch (Exception ex) {
//				System.out.println("error: " + ex);
//
//				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
//				resultMap.put("SUCCESS", false);
//
//				return resultMap;
//			}
//	    }








































}
