package kbookERP.custom.register;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kbookERP.custom.common.CommonInfo;
import kbookERP.custom.util.Util;

@Service
public class RegisterService {

	@Autowired
	private RegisterMapper registerMapper;


	public Map<String, Object> getNewBookCd(Map<String, Object> params) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
//		Map<String, Object> newParams = new HashMap<String, Object>();
		Map<String, Object> sqlMap = new HashMap<String, Object>();
		List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

		try {

			int bookCd = registerMapper.getNewBookCd(params);

			if (bookCd < 1) {

				resultMap.put("EXIST", false);
				resultMap.put("MSG", "데이터가 없습니다.");

			}else {
				resultMap.put("BOOKCD", bookCd);
				resultMap.put("EXIST", true);
				registerMapper.updateNewBookCd(params);
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


	 public Map<String, Object> getBookRegistInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = registerMapper.getBookRegistInfo(params);

				if (listSqlMap.size() > 0) {
					resultMap = listSqlMap.get(0);
					resultMap.put("EXIST", true);

				}else {
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

	 public Map<String, Object> deleteBookInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();

			try {

				sqlMap = registerMapper.getBookStock(params);

				boolean isDelete = true;

				if(sqlMap !=null) {

					int stock = Util.getInt(sqlMap.get("STOCK"), -1);

					if(stock != 0) {
						isDelete = false;
						resultMap.put("MSG", "현재고가 존재하므로 삭제할 수 없습니다.");
						resultMap.put("SUCCESS", false);

					}else {
						for(int i = 0 ; i < CommonInfo.CHECKTABLE.length; i++) {
							params.put("TABLE", CommonInfo.CHECKTABLE[i][0]);
							sqlMap = registerMapper.getBookDeleteCheck(params);

							if(sqlMap !=null) {
								isDelete = false;
								resultMap.put("MSG", CommonInfo.CHECKTABLE[i][1]+"에 삭제대상 도서코드가 존재합니다.");
								resultMap.put("SUCCESS", false);
								break;
							}
						}
					}
				}

				if(isDelete) {
					int result = registerMapper.deleteBookInfoHMA08(params);
					result = registerMapper.deleteBookInfoHMA06(params);
					result = registerMapper.deleteBookInfoHMA07(params);
					result = registerMapper.deleteBookInfoHMA04(params);
					result = registerMapper.deleteBookInfoHRE03(params);
					result = registerMapper.deleteBookInfoHSA01(params);


					newParams.put("SHOPCD", params.get("SHOPCD"));
					newParams.put("DEPTCD", params.get("DEPTCD"));
					newParams.put("GROUPCD", params.get("GROUPCD"));
					newParams.put("STANDCD", params.get("STANDCD"));

					int cnt = registerMapper.getOrganKINDSU(newParams);
					newParams.put("KINDSU", cnt - 1);
					result = registerMapper.UpdateOrganKINDSU(newParams);

					newParams.put("STANDCD", 9999);
					cnt = registerMapper.getOrganKINDSU(newParams);
					newParams.put("KINDSU", cnt - 1);
					result = registerMapper.UpdateOrganKINDSU(newParams);

					newParams.put("GROUPCD", 99);
					cnt = registerMapper.getOrganKINDSU(newParams);
					newParams.put("KINDSU", cnt - 1);
					result = registerMapper.UpdateOrganKINDSU(newParams);

					newParams.put("DEPTCD", 99);
					cnt = registerMapper.getOrganKINDSU(newParams);
					newParams.put("KINDSU", cnt - 1);
					result = registerMapper.UpdateOrganKINDSU(newParams);

					newParams.put("SHOPCD", 99);
					cnt = registerMapper.getOrganKINDSU(newParams);
					newParams.put("KINDSU", cnt - 1);
					result = registerMapper.UpdateOrganKINDSU(newParams);

					newParams.clear();
					newParams.put("SHOPCD", params.get("SHOPCD"));
					newParams.put("BOOKCD", params.get("BOOKCD"));

					cnt = registerMapper.getBookUpdateFlag(newParams);

					if(cnt > 0) {
						LocalDateTime now = LocalDateTime.now();
						DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmSS");
						String formatedNow = now.format(formatter);

						newParams.put("UPDATEFLAG", 3);
						newParams.put("LASTTIME", formatedNow);
						newParams.put("DLLFLAG", 1);

						result = registerMapper.updateBookInfoHMA05(newParams);
					}

				}

				resultMap.put("SUCCESS", isDelete);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> updateBookInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();
			List<Object> listData = new ArrayList<Object>();
			List<Object> listData2 = new ArrayList<Object>();
			try {

				int result = registerMapper.updateBookInfoHMA08(params);
				result = registerMapper.updateBookInfoHMA12(params);
				result = registerMapper.deleteBookInfoHMA07(params);

				for(int i = 1 ; i < 7; i++) {
					String purchCdOrderData = "PURCH_"+i+"_DATA";

					if(params.containsKey(purchCdOrderData)) {
						Map<String, Object>oMap = (Map<String, Object>)params.get(purchCdOrderData);

						result = registerMapper.insertBookInfoHMA07(oMap);
						result = registerMapper.deleteBookInfoHMA06(oMap);

						String purchCdOrderData2 = "PURCH_DETAIL";
						listData = (List<Object>) oMap.get(purchCdOrderData2);

						for (Object oData2 : listData){
							Map<String, Object>oMapDetail = (Map<String, Object>)oData2;
							result = registerMapper.insertBookInfoHMA06(oMapDetail);

						}
					}
				}

				result = registerMapper.deleteBookInfoHMA04(params);

				if(params.containsKey("AUTHOR")) {
					listData = (List<Object>) params.get("AUTHOR");
					for (Object oData : listData){
						Map<String, Object>oMap = (Map<String, Object>)oData;

						result = registerMapper.insertBookInfoHMA04(oMap);
					}
				}

				int cnt = registerMapper.getBookUpdateFlag(params);
				LocalDateTime now = LocalDateTime.now();
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmSS");
				String formatedNow = now.format(formatter);

				newParams.put("SHOPCD", params.get("SHOPCD"));
				newParams.put("BOOKCD", params.get("BOOKCD"));
				newParams.put("BOOKNM", params.get("BOOKNM"));
				newParams.put("PRICE", params.get("PRICE"));
				newParams.put("GROUPCD", params.get("GROUPCD"));
				newParams.put("STANDCD", params.get("STANDCD"));
				newParams.put("LASTTIME", formatedNow);

				if(cnt > 0) {

					newParams.put("UPDATEFLAG", 2);
					newParams.put("DLLFLAG", 1);

					result = registerMapper.updateBookInfoHMA05(newParams);
				}else {

					newParams.put("UPDATEFLAG", 2);
					newParams.put("DLLFLAG", 1);
					result = registerMapper.insertBookInfoHMA05(newParams);
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


	 public Map<String, Object> insertBookInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();
			List<Object> listData = new ArrayList<Object>();
			List<Object> listData2 = new ArrayList<Object>();
			try {

				sqlMap= registerMapper.selectOrganInfo(params);

				if(sqlMap != null) {
					params.put("DEPTCD", sqlMap.get("DEPTCD"));
					params.put("GROUPCD", sqlMap.get("GROUPCD"));
				}else {
					params.put("DEPTCD", 1);
					params.put("GROUPCD", 1);
				}

				params.put("FIRSTSTORE", "");
				params.put("LASTSTORE", "");
				params.put("FIRSTSALES", 0);
				params.put("LASTSALES", "");
				params.put("STOCK", 0);
				params.put("COST", 0);
				params.put("AMOUNT", 0);
				params.put("ACT_STOCK", 0);
				params.put("ACT_COST", 0);
				params.put("ACT_PRICE", 0);
				params.put("PREV_PRICE", 0);
				params.put("PRICE_DATE", "");
				params.put("STAND_STOCK", 0);
				params.put("INP_PLAN_COUNT", 0);
				params.put("BARCODE_FG", 0);
				params.put("BOOK_POINT", 1);


				int result = registerMapper.insertBookInfoHMA08(params);



				params.put("BOOK_FLAG", 1);
				params.put("UP_END_FG", 2);

				result = registerMapper.insertBookInfoHMA12(params);

				result = registerMapper.deleteBookInfoHMA07(params);

				for(int i = 1 ; i < 7; i++) {
					String purchCdOrderData = "PURCH_"+i+"_DATA";

					if(params.containsKey(purchCdOrderData)) {
						Map<String, Object>oMap = (Map<String, Object>)params.get(purchCdOrderData);

						result = registerMapper.insertBookInfoHMA07(oMap);
						result = registerMapper.deleteBookInfoHMA06(oMap);

						String purchCdOrderData2 = "PURCH_DETAIL";
						listData = (List<Object>) oMap.get(purchCdOrderData2);

						for (Object oData2 : listData){
							Map<String, Object>oMapDetail = (Map<String, Object>)oData2;
							result = registerMapper.insertBookInfoHMA06(oMapDetail);

						}
					}
				}

				result = registerMapper.deleteBookInfoHMA04(params);

				if(params.containsKey("AUTHOR")) {
					listData = (List<Object>) params.get("AUTHOR");
					for (Object oData : listData){
						Map<String, Object>oMap = (Map<String, Object>)oData;

						result = registerMapper.insertBookInfoHMA04(oMap);
					}
				}

				int cnt = registerMapper.getBookUpdateFlag(params);
				LocalDateTime now = LocalDateTime.now();
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
				String formatedNow = now.format(formatter);

				newParams.put("SHOPCD", params.get("SHOPCD"));
				newParams.put("BOOKCD", params.get("BOOKCD"));
				newParams.put("BOOKNM", params.get("BOOKNM"));
				newParams.put("PRICE", params.get("PRICE"));
				newParams.put("GROUPCD", params.get("GROUPCD"));
				newParams.put("STANDCD", params.get("STANDCD"));
				newParams.put("LASTTIME", formatedNow);

				if(cnt > 0) {

					newParams.put("UPDATEFLAG", 1);
					newParams.put("DLLFLAG", 1);

					result = registerMapper.updateBookInfoHMA05(newParams);
				}else {

					newParams.put("UPDATEFLAG", 1);
					newParams.put("DLLFLAG", 1);
					result = registerMapper.insertBookInfoHMA05(newParams);
				}


				newParams.clear();
				newParams.put("SHOPCD", params.get("SHOPCD"));
				newParams.put("DEPTCD", params.get("DEPTCD"));
				newParams.put("GROUPCD", params.get("GROUPCD"));
				newParams.put("STANDCD", params.get("STANDCD"));

				cnt = registerMapper.getOrganKINDSU(newParams);
				newParams.put("KINDSU", cnt + 1);
				result = registerMapper.UpdateOrganKINDSU(newParams);

				newParams.put("STANDCD", 9999);
				cnt = registerMapper.getOrganKINDSU(newParams);
				newParams.put("KINDSU", cnt + 1);
				result = registerMapper.UpdateOrganKINDSU(newParams);

				newParams.put("GROUPCD", 99);
				cnt = registerMapper.getOrganKINDSU(newParams);
				newParams.put("KINDSU", cnt + 1);
				result = registerMapper.UpdateOrganKINDSU(newParams);

				newParams.put("DEPTCD", 99);
				cnt = registerMapper.getOrganKINDSU(newParams);
				newParams.put("KINDSU", cnt + 1);
				result = registerMapper.UpdateOrganKINDSU(newParams);

				newParams.put("SHOPCD", 99);
				cnt = registerMapper.getOrganKINDSU(newParams);
				newParams.put("KINDSU", cnt + 1);
				result = registerMapper.UpdateOrganKINDSU(newParams);


				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> getPurchaseInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = registerMapper.getPurchaseInfo(params);

				if (listSqlMap.size() > 0) {
					resultMap = listSqlMap.get(0);
					resultMap.put("EXIST", true);
					resultMap.put("PURCH_EXIST", true);
					resultMap.put("PUBSH_EXIST", false);
				} else {

					params.put("PUBSHCD", params.get("PURCHCD"));
					listSqlMap = registerMapper.getPublisherInfo(params);

					if (listSqlMap.size() > 0) {
						resultMap = listSqlMap.get(0);
						resultMap.put("EXIST", true);
						resultMap.put("PURCH_EXIST", false);
						resultMap.put("PUBSH_EXIST", true);
					} else {
						resultMap.put("EXIST", false);
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


	 public Map<String, Object> deletePurchaseInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();

			try {

				int cnt = registerMapper.getPurchaseCnt(params);

				if(cnt == 0)
				{
					newParams.put("PURCHCD", params.get("PURCHCD"));
					newParams.put("TABLE", "HMA02");
					int result = registerMapper.deleteTableByPurchaseCd(newParams);

					newParams.put("TABLE", "HSA02");
					result = registerMapper.deleteTableByPurchaseCd(newParams);

					newParams.put("TABLE", "HSA03");
					result = registerMapper.deleteTableByPurchaseCd(newParams);

					newParams.put("TABLE", "HMA24");
					result = registerMapper.deleteTableByPurchaseCd(newParams);

					newParams.put("TABLE", "HMA26");
					result = registerMapper.deleteTableByPurchaseCd(newParams);

					newParams.put("TABLE", "HMA11");
					newParams.put("PUBSHCD", params.get("PURCHCD"));
					result = registerMapper.deleteTableByPublishCd(newParams);

					resultMap.put("SUCCESS", true);
				}
				else {
					resultMap.put("SUCCESS", false);
					resultMap.put("MSG", "매입처별도서 테이블에 삭제하고자 하는 대상 매입처가 존재합니다.");
				}

				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> updatePurchaseInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();

			try {

				int result = registerMapper.updateHMA24(params);
				if(result == 0)
					registerMapper.insertHMA24(params);

				result = registerMapper.updateHMA02(params);

				int purchKbn = Util.getInt(params.get("PURCH_KBN"), -1);
				if(purchKbn == 1 || purchKbn == 4) {
					int cnt  =  registerMapper.getPublishCnt(params);
					if(cnt > 0)
						result = registerMapper.updateHMA11(params);
					else
						result = registerMapper.insertHMA11(params);
				}

				newParams.put("SHOPCD", params.get("SHOPCD"));
				sqlMap = registerMapper.getToday(newParams);

				if(sqlMap != null) {
					String today = sqlMap.get("TODAY").toString();
					newParams.put("PURCHCD", params.get("PURCHCD"));

					int cnt = registerMapper.getShopPerformance(newParams);

					if(cnt == 0) {
						newParams.put("PUR_DATE", today.subSequence(0, 6));
						result = registerMapper.insertHSA02(newParams);

						newParams.put("PUR_DATE", today);
						result = registerMapper.insertHSA03(newParams);
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

	 public Map<String, Object> insertPurchaseInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();

			try {

				int result = registerMapper.insertHMA02(params);

				int purchKbn = Util.getInt(params.get("PURCH_KBN"), -1);
				if(purchKbn == 1 || purchKbn == 4) {
					int cnt  =  registerMapper.getPublishCnt(params);
					if(cnt > 0)
						result = registerMapper.updateHMA11(params);
					else
						result = registerMapper.insertHMA11(params);
				}

				newParams.put("SHOPCD", params.get("SHOPCD"));
				sqlMap = registerMapper.getToday(newParams);

				if(sqlMap != null) {
					String today = sqlMap.get("TODAY").toString();
					newParams.put("PURCHCD", params.get("PURCHCD"));

					int cnt = registerMapper.getShopPerformance(newParams);

					if(cnt == 0) {
						newParams.put("PUR_DATE", today.subSequence(0, 6));
						result = registerMapper.insertHSA02(newParams);

						newParams.put("PUR_DATE", today);
						result = registerMapper.insertHSA03(newParams);
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



	 public Map<String, Object> getPublishInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> listSqlMap2 = new ArrayList<Map<String, Object>>();
			try {

				listSqlMap = registerMapper.getPublisherInfo(params);

				if (listSqlMap.size() > 0) {

					params.put("PURCHCD", params.get("PUBSHCD"));
					listSqlMap2 = registerMapper.getPurchaseInfo(params);

					int bookCnt = registerMapper.getPublisherSelBookCnt(params);

					resultMap = listSqlMap.get(0);
					resultMap.put("BOOK_CNT", bookCnt);
					resultMap.put("EXIST", true);
					resultMap.put("PUBSH_EXIST", true);
					resultMap.put("PURCH_EXIST", listSqlMap2.size() > 0);

				} else {

					params.put("PURCHCD", params.get("PUBSHCD"));
					listSqlMap = registerMapper.getPurchaseInfo(params);

					if (listSqlMap.size() > 0) {
						resultMap = listSqlMap.get(0);
						resultMap.put("EXIST", true);
						resultMap.put("PUBSH_EXIST", false);
						resultMap.put("PURCH_EXIST", true);
					} else {
						resultMap.put("EXIST", false);
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

	 public Map<String, Object> insertPublishInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> sqlMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();

			try {

				int result = registerMapper.insertHMA11(params);

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> updatePublishInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> sqlMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();

			try {

				int result = registerMapper.updateHMA11(params);

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> deletePublishInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> sqlMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();

			try {

				params.put("TABLE", "HMA11");
				int result = registerMapper.deleteTableByPublishCd(params);

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> getHolidayData(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = registerMapper.getHolidayData(params);

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

	 public Map<String, Object> insertHolidayData(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();
			List<Object> listData = new ArrayList<Object>();
			List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
			try {

				listData = (List<Object>) params.get("DATA");
				for (Object oData : listData){
					Map<String, Object>oMap = (Map<String, Object>)oData;
					listMap.add(oMap);
				}

				newParams.put("SHOPCD", params.get("SHOPCD"));
				newParams.put("LIST_DATA", listMap);

				registerMapper.insertHolidayData(newParams);

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> updateHolidayData(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Object> listData = new ArrayList<Object>();
			try {

				listData = (List<Object>) params.get("DATA");
				for (Object oData : listData){
					Map<String, Object>oMap = (Map<String, Object>)oData;
					registerMapper.updateHMA17(oMap);
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


	 public Map<String, Object> getReturnInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = registerMapper.getReturnInfo(params);

				if (listSqlMap.size() > 0) {
					resultMap = listSqlMap.get(0);
					resultMap.put("EXIST", true);
//					resultMap.put("DATA", listSqlMap);
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

	 public Map<String, Object> updateReturnInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();

			try {

				int reuslt = registerMapper.updateHMA03(params);

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }

	 public Map<String, Object> deleteReturnInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();

			try {

				int reuslt = registerMapper.deleteHMA03(params);

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }



	 public Map<String, Object> insertReturnInfo(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {
				listSqlMap = registerMapper.getReturnInfo(params);

				if (listSqlMap.size() < 1) {

					params.put("LAST_RET_DATE", "");
					params.put("EL_BANK_NM", "");
					params.put("EL_ONLINE_NO", "");

					int reuslt = registerMapper.insertHMA03(params);
					resultMap.put("SUCCESS", true);
				}
				else {
					resultMap.put("SUCCESS", false);
					resultMap.put("MSG", "매입처 정보가 존재합니다.");
				}



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

						sqlMap = registerMapper.getReturnBookExist(oMap);

						if(sqlMap == null)
							registerMapper.createReturnBook(oMap);
						else
							registerMapper.UpdateReturnBook(oMap);
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

				listSqlMap = registerMapper.getPurchInfo4return(params);

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

				listSqlMap = registerMapper.getGroupInfo4return(params);

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

				listSqlMap = registerMapper.getStoreInfo4return(params);

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

				listSqlMap = registerMapper.getReturnBookList(params);

				if (listSqlMap.size() > 0) {
					resultMap.put("EXIST", true);
					resultMap.put("DATA", listSqlMap);

//					List<Map<String, Object>> listPurchaseProcessMap = new ArrayList<Map<String, Object>>();

//					listPurchaseProcessMap = registerMapper.getPurchaseProcessList(params);
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
							registerMapper.deleteReturnBook(oMap);
						}else {
							id = Util.getInt(oMap.get("ID"), -1);

//							sqlMap = registerMapper.getReturnBookExist(oMap);
//
//							if(sqlMap == null)
//								registerMapper.createReturnBook(oMap);
//							else
								registerMapper.UpdateReturnBook4confirm(oMap);
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


				listSqlMap = registerMapper.getReturnBookList(params);

				if (listSqlMap.size() > 0) {

//					long hma06NookCd;
//					int hor02MaxSeq;
//					int returnChitNo;
//					int retKbn;
//					int gChitKbn;
//
//					for(Map<String, Object> oData : listSqlMap) {
//
//						retKbn = Util.getInt(oData.get("RET_KBN"), 0);
//
//						if(retKbn == 1)
//							gChitKbn = 28;
//						else
//							gChitKbn = 29;
//
//
//
//						returnChitNo = registerMapper.getRETURN_CHIT_NO
//
//
//
//
//						registerMapper.insertReturnBookConfirm(oData);
//
//					}
//					registerMapper.deleteReturnBookAll(params);


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
