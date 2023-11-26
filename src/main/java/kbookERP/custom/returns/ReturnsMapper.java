package kbookERP.custom.returns;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ReturnsMapper {


	public List<Map<String,Object>> getBookList4Return(Map<String,Object> params);

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

	public List<Map<String,Object>> getReturnBookListAll(Map<String,Object> params);

	public int deleteReturnBook(Map<String,Object> params);

	public int insertReturnBookConfirm(Map<String,Object> params);

	public int deleteReturnBookAll(Map<String,Object> params);

	public int getRETURN_CHIT_NO(Map<String,Object> params);

	public int updateRETURN_CHIT_NO(Map<String,Object> params);

	public int insertHRE04(Map<String,Object> params);

	public int checkHRE03(Map<String,Object> params);

	public int updateHRE03(Map<String,Object> params);





























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
