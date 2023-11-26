package kbookERP.custom.register;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface RegisterMapper {


	public int getNewBookCd(Map<String,Object> params);

	public int updateNewBookCd(Map<String,Object> params);

	public List<Map<String,Object>> getBookRegistInfo(Map<String,Object> params);

	public Map<String,Object> getBookStock(Map<String,Object> params);

	public Map<String,Object> getBookDeleteCheck(Map<String,Object> params);

	public int deleteBookInfoHMA08(Map<String,Object> params);

	public int deleteBookInfoHMA06(Map<String,Object> params);

	public int deleteBookInfoHMA07(Map<String,Object> params);

	public int deleteBookInfoHMA04(Map<String,Object> params);

	public int deleteBookInfoHRE03(Map<String,Object> params);

	public int deleteBookInfoHSA01(Map<String,Object> params);

	public int getOrganKINDSU(Map<String,Object> params);

	public int UpdateOrganKINDSU(Map<String,Object> params);

	public int getBookUpdateFlag(Map<String,Object> params);

	public int updateBookInfoHMA05(Map<String,Object> params);

	public int updateBookInfoHMA08(Map<String,Object> params);

	public int updateBookInfoHMA12(Map<String,Object> params);

	public int insertBookInfoHMA06(Map<String,Object> params);

	public int insertBookInfoHMA04(Map<String,Object> params);

	public int insertBookInfoHMA05(Map<String,Object> params);

	public int insertBookInfoHMA07(Map<String,Object> params);

	public Map<String,Object> selectOrganInfo(Map<String,Object> params);

	public int insertBookInfoHMA08(Map<String,Object> params);

	public int insertBookInfoHMA12(Map<String,Object> params);

	public List<Map<String,Object>> getPurchaseInfo(Map<String,Object> params);

	public List<Map<String,Object>> getPublisherInfo(Map<String,Object> params);

	public int getPurchaseCnt(Map<String,Object> params);

	public int deleteTableByPurchaseCd(Map<String,Object> params);

	public int deleteTableByPublishCd(Map<String,Object> params);

	public int updateHMA02(Map<String,Object> params);

	public int updateHMA11(Map<String,Object> params);

	public int getPublishCnt(Map<String,Object> params);

	public int updateHMA24(Map<String,Object> params);

	public int insertHMA24(Map<String,Object> params);

	public Map<String,Object> getToday(Map<String,Object> params);

	public int getShopPerformance(Map<String,Object> params);

	public int insertHSA02(Map<String,Object> params);

	public int insertHSA03(Map<String,Object> params);

	public int insertHMA02(Map<String,Object> params);

	public int insertHMA11(Map<String,Object> params);

	public int getPublisherSelBookCnt(Map<String,Object> params);

	public List<Map<String,Object>> getHolidayData(Map<String,Object> params);

	public int insertHolidayData(Map<String,Object> params);

	public int updateHMA17(Map<String,Object> params);

	public List<Map<String,Object>> getReturnInfo(Map<String,Object> params);

	public int updateHMA03(Map<String,Object> params);

	public int insertHMA03(Map<String,Object> params);

	public int deleteHMA03(Map<String,Object> params);






































	public List<Map<String,Object>> getPurchaseProcessList(Map<String,Object> params);

	public List<Map<String,Object>> getPurchaseRate(Map<String,Object> params);

	public int getReturnPlanCnt(Map<String,Object> params);

	public Map<String,Object> getReturnBookExist(Map<String,Object> params);

	public int createReturnBook(Map<String,Object> params);

	public int UpdateReturnBook(Map<String,Object> params);

	public int UpdateReturnBook4confirm(Map<String,Object> params);

	public List<Map<String,Object>> getPurchInfo4return(Map<String,Object> params);

	public List<Map<String,Object>> getGroupInfo4return(Map<String,Object> params);

	public List<Map<String,Object>> getStoreInfo4return(Map<String,Object> params);

	public List<Map<String,Object>> getReturnBookList(Map<String,Object> params);

	public int deleteReturnBook(Map<String,Object> params);

	public int insertReturnBookConfirm(Map<String,Object> params);

	public int deleteReturnBookAll(Map<String,Object> params);










	public Map<String,Object> getPubshInfo(Map<String,Object> params);

	public Map<String,Object> getDeptInfo(Map<String,Object> params);

	public Map<String,Object> getGroupInfo(Map<String,Object> params);

	public Map<String,Object> getStandInfo(Map<String,Object> params);

	public List<Map<String,Object>> getStoreList(Map<String,Object> params);

	public Map<String,Object> checkHMA02(Map<String,Object> params);

	public List<Map<String,Object>> getSearchBookList(Map<String,Object> params);

	public List<Map<String,Object>> getSearchBookList4Purchase(Map<String,Object> params);



	public List<Map<String,Object>> getBookPurchInfo(Map<String,Object> params);

	public List<Map<String,Object>> getNewBooksList(Map<String,Object> params);

	public List<Map<String,Object>> getBestSellerBooksList(Map<String,Object> params);

	public Map<String,Object> getBookInfoDetail(Map<String,Object> params);

	public Map<String,Object> getShopBookInfoDetail(Map<String,Object> params);

	public List<Map<String,Object>> getPurchaseList(Map<String,Object> params);

	public List<Map<String,Object>> getPurchaseList4Order(Map<String,Object> params);

	public  Map<String,Object> getPurchaseDetail(Map<String,Object> params);

	public List<Map<String,Object>> getPublisherList(Map<String,Object> params);

	public List<Map<String,Object>> getSaleDataList(Map<String,Object> params);

	public List<Map<String,Object>> getBookPurchaseInfo(Map<String,Object> params);

	public List<Map<String,Object>> getPublisherOutcome(Map<String,Object> params);

	public List<Map<String,Object>> getPublisherLDA(Map<String,Object> params);

	public List<Map<String,Object>> getPublisherLDB(Map<String,Object> params);

	public List<Map<String,Object>> getPublisherWarehouse(Map<String,Object> params);

	public List<Map<String,Object>> getOrderBookPurchRate(Map<String,Object> params);

	public int getOrderBookInpCnt(Map<String,Object> params);

	public int getOrderBookOrdCnt(Map<String,Object> params);

	public int getOrderBookReturnCnt(Map<String,Object> params);

	public int getOrderBookEstiCnt(Map<String,Object> params);

	public List<Map<String,Object>> getVirtualShopCd(Map<String,Object> params);



}
