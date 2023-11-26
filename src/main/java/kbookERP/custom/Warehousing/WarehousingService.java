package kbookERP.custom.Warehousing;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kbookERP.custom.search.SearchMapper;
import kbookERP.custom.register.RegisterMapper;
import kbookERP.custom.util.Util;

@Service
public class WarehousingService {

	@Autowired
	private WarehousingMapper warehousingMapper;

	@Autowired
	private SearchMapper searchMapper;

	@Autowired
	private RegisterMapper registerMapper;

	public Map<String, Object> getWarehousingBookList(Map<String, Object> params) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

		try {

//			listSqlMap = warehousingMapper.getWarehousingBookList(params);
			listSqlMap = warehousingMapper.getWarehousingBookList(params);

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


	public Map<String, Object> checkHMA12HMA08_LOG(Map<String, Object> params) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
//		Map<String, Object> newParams = new HashMap<String, Object>();
		Map<String, Object> sqlMap = new HashMap<String, Object>();
		List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

		try {

			sqlMap = warehousingMapper.geBookCdInHMA12HMA08_LOG(params);

			if (sqlMap != null) {
				resultMap.put("EXIST", true);
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


	 public Map<String, Object> insertWarehousingBook(Map<String, Object> params) throws Exception {

			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			Map<String, Object> oMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			List<Object> listData = new ArrayList<Object>();

			try {

				if (params.containsKey("DATA")) {
					listData = (List<Object>) params.get("DATA");

					int value;
					int tradeItem;
					int mKBN;
					int rateKbn;

					newParams.put("SHOPCD", params.get("SHOPCD"));
					newParams.put("PURCHCD", params.get("PURCHCD"));

					for (Object oData : listData){
						oMap = (Map<String, Object>)oData;

						tradeItem = Util.getInt(oMap.get("TRADE_ITEM"), 0);

						if(tradeItem == 2 || tradeItem == 12)
							mKBN = 20;
						else
							mKBN = 10;

						newParams.put("BOOKCD", oMap.get("BOOKCD"));
						newParams.put("RATE", oMap.get("RATE"));
						newParams.put("RATE_KBN_S", mKBN);
						newParams.put("RATE_KBN_E", mKBN + 10);


						listSqlMap = searchMapper.getOrderBookPurchRateKbn(newParams);

						if(listSqlMap.size() > 0)
							rateKbn = Util.getInt(listSqlMap.get(0).get("RATE_KBN"), 0);
						else
							rateKbn = 0;

						value = warehousingMapper.getHIN03RowNum(newParams) + 1;
						oMap.put("SEQ_NO", value);
						oMap.put("RATE_KBN", rateKbn);

						sqlMap = warehousingMapper.getCodeHma08(newParams);

						if(sqlMap == null) {
							oMap.put("DEPTCD", 0);
							oMap.put("STANDCD", 0);
							oMap.put("PUBLISHCD", 0);
							oMap.put("ISBN_FG", 0);
							oMap.put("GROUPCD", 0);
						}
						else{
							oMap.put("DEPTCD", sqlMap.get("DEPTCD"));
							oMap.put("STANDCD", sqlMap.get("STANDCD"));
							oMap.put("PUBLISHCD", sqlMap.get("PUBLISHCD"));
							oMap.put("ISBN_FG", sqlMap.get("ISBN_FG"));
							oMap.put("GROUPCD", sqlMap.get("GROUPCD"));
						}

						int result = warehousingMapper.insertHIN03(oMap);

						if(oMap.containsKey("VCNT_EXIST")) {

							value = warehousingMapper.getHLS01RowNum(oMap) + 1;
							oMap.put("ROW_NO", value);

							value = warehousingMapper.getRATE_KBN(oMap);
							oMap.put("RATE_KBN", value);

							result = warehousingMapper.insertHLS01(oMap);
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


	 public Map<String, Object> getPurchInfo4Warehousing(Map<String, Object> params) throws Exception {

			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				listSqlMap = warehousingMapper.getPurchInfo4Warehousing(params);

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

	 public Map<String, Object> deleteWarehousingBook(Map<String, Object> params) throws Exception {

			Map<String, Object> resultMap = new HashMap<String, Object>();
//			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			try {

				int result = warehousingMapper.deleteHOR02(params);
				result = warehousingMapper.deleteHIN03(params);

				resultMap.put("SUCCESS", true);
				return resultMap;

			} catch (Exception ex) {
				System.out.println("error: " + ex);

				resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
			}
	    }


	 public Map<String, Object> confirmWarehousingBook(Map<String, Object> params) throws Exception {

			Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();

			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();

			List<Object> listPurchase = new ArrayList<Object>();
			List<Object> listTime = new ArrayList<Object>();

			try {

				sqlMap = registerMapper.getToday(params);
				String today = sqlMap.get("TODAY").toString();
//
//				LocalDateTime now = LocalDateTime.now();
//				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
//				String formatedNow = now.format(formatter);
//
//				if(!formatedNow.equals(today)) {
//					resultMap.put("MSG", "영업전처리를 하지 않았습니다");
//					resultMap.put("SUCCESS", false);
//					return resultMap;
//				}
//
//				int bsbffg = warehousingMapper.getBS_BF_FG(params);
//
//				if(bsbffg != 2) {
//					resultMap.put("MSG", "영업전처리를 하지 않았습니다");
//					resultMap.put("SUCCESS", false);
//					return resultMap;
//				}
//
				int separate = Util.getInt(params.get("SEPARATE"), 1);

				if (params.containsKey("DATA")) {

					newParams.put("SHOPCD", params.get("SHOPCD"));

					int tradeItem;
					int mKBN;
					int inpCnt;
					int inpPlanCnt;
					int cnt;
					int purchCd;
					long bookCd;
					String inpTime = "-1";
					String preInpTime = "-1";
					Map<String, Object> oMapP= new HashMap<String, Object>();
					Map<String, Object> oMap = new HashMap<String, Object>();
					List<Object>listData = new ArrayList<Object>();

					listPurchase = (List<Object>) params.get("DATA");

					for(Object listP : listPurchase) {
						 oMapP = (Map<String, Object>)listP;
						 purchCd = Util.getInt(oMapP.get("PURCHCD"), -1);
						 newParams.put("PURCHCD", purchCd);

						 listTime = (List<Object>) oMapP.get("DATAP");

						 int purchase_chit_no = warehousingMapper.getPURCHASE_CHIT_NO(params);
							warehousingMapper.UpdatePURCHASE_CHIT_NO(params);

						int index = 0;
						for (Object oDataT : listTime){
							listData = (List<Object>) oDataT;

							if(separate == 1 && index++ != 0) {
								purchase_chit_no = warehousingMapper.getPURCHASE_CHIT_NO(params);
								warehousingMapper.UpdatePURCHASE_CHIT_NO(params);
							}

							for(Object oData : listData){
								oMap = (Map<String, Object>)oData;

								inpTime = oMap.get("INP_TIME").toString();
								bookCd = Util.getLong(oMap.get("BOOKCD"), -1);

								//System.out.println("P= "+ purchCd+",\t T = "+ inpTime+",\t B = "+ bookCd+",\t C = "+ purchase_chit_no);

								oMap.put("CHIT_NO", purchase_chit_no);


								tradeItem = Util.getInt(oMap.get("TRADE_ITEM"), 0);

								if(tradeItem == 1 || tradeItem == 11)
									mKBN = 20;
								else
									mKBN = 21;

								oMap.put("CHIT_KBN", mKBN);
								oMap.put("PUR_DATE", today);
								oMap.put("INP_DATE", today);


								int result = warehousingMapper.insertHIN02(oMap);


								sqlMap = warehousingMapper.getHOR02(oMap);

								if(sqlMap != null) {

									inpPlanCnt = Util.getInt(sqlMap.get("INP_PLAN_COUNT"), 0);
									inpCnt = Util.getInt(oMap.get("INP_COUNT"), 0);

									if(inpCnt >= inpPlanCnt)
										sqlMap.put("INP_NOTCNT", 0);
									else
										sqlMap.put("INP_NOTCNT", inpPlanCnt - inpCnt);

									sqlMap.put("INP_COUNT", inpCnt);

									cnt = warehousingMapper.getHIN01Cnt(sqlMap);

									if(cnt == 0)
										result = warehousingMapper.insertHIN01(sqlMap);
									else
										result = warehousingMapper.updateHIN01(sqlMap);
								}
							}
						}

						int result = warehousingMapper.deleteHIN03ByPurchCd(newParams);

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

	 public Map<String, Object> getWarehousingBookList4Barcode(Map<String, Object> params) throws Exception {

			Map<String, Object> resultMap = new HashMap<String, Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
//			Map<String, Object> sqlMap = new HashMap<String, Object>();
			try {

//				listSqlMap = warehousingMapper.getWarehousingBookList(params);
				listSqlMap = warehousingMapper.getWarehousingBookList4Barcode(params);

				if (listSqlMap.size() > 0) {

					for(Map<String, Object> oData : listSqlMap) {

						oData.put("AUTHOR_KBN", 1);
						String authorNm = warehousingMapper.getAUTHORNM(oData);
						oData.put("AUTHORNM", authorNm);

						int sRate = Util.getInt(oData.get("INP_RATE"), 0);
						oData.put("RATE", sRate);

						int chitKbn = Util.getInt(oData.get("CHIT_KBN"), 0);
						if(chitKbn == 20){
							oData.put("RATE_KBN", true);
							oData.put("RATE_KBN_E", 20);
						}
						else {
							oData.put("RATE_KBN", 30);
							oData.put("RATE_KBN_S", 20);
							oData.put("RATE_KBN_E", 30);
						}

						int rate = warehousingMapper.getRATE_KBN(oData);
						oData.put("RATE_KBN", rate);

						int purProcess = warehousingMapper.getPUR_PROCESS(oData);
						oData.put("PUR_PROCESS", purProcess);
					}


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


	 public Map<String, Object> updateWarehousingBookList4Barcode(Map<String, Object> params) throws Exception {

			Map<String, Object> resultMap = new HashMap<String, Object>();
//			Map<String, Object> newParams = new HashMap<String, Object>();
			Map<String, Object> dataMap = new HashMap<String, Object>();

			List<Object> listData = new ArrayList<Object>();

			try {
				if (params.containsKey("DATA")) {

					listData = (List<Object>) params.get("DATA");

					for(Object oData : listData) {
						dataMap = (Map<String, Object>)oData;

						warehousingMapper.UpdateBarcodeFg(dataMap);
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





















































}
