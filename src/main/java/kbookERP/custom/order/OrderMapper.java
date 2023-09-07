package kbookERP.custom.order;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OrderMapper {

	public List<Map<String,Object>> getSaleDataListRate(Map<String,Object> params);

	public List<Map<String,Object>> getSaleDataListGroup(Map<String,Object> params);

	public List<Map<String,Object>> getSaleDataAuthorList(Map<String,Object> params);

	public List<Map<String,Object>> getSaleDataEstiList(Map<String,Object> params);

	public List<Map<String,Object>> getSaleDataRetList(Map<String,Object> params);

	public List<Map<String,Object>> getSaleDataOrdList(Map<String,Object> params);

	public List<Map<String,Object>> getSaleDataInpList(Map<String,Object> params);

	public List<Map<String,Object>> getSaleDataInpRatioList(Map<String,Object> params);

	public Map<String,Object> getSaleDataEsti(Map<String,Object> params);

	public Map<String,Object> getSaleDataRet(Map<String,Object> params);

	public Map<String,Object> getSaleDataOrd(Map<String,Object> params);

	public Map<String,Object> getSaleDataInp(Map<String,Object> params);

	public Map<String,Object> getSaleDataInpRatio(Map<String,Object> params);

	public List<Map<String,Object>> getOrderDataList(Map<String,Object> params);

	public Map<String,Object> checkPurchCd(Map<String,Object> params);

	public  Map<String,Object> getOrderBookExist(Map<String,Object> params);

	public int createOrderBook(Map<String,Object> params);

	public int UpdateOrderBook(Map<String,Object> params);

	public int deleteOrderBookInfo(Map<String,Object> params);

	public int selectOrderBookInfo(Map<String,Object> params);

	public int updateOrderBookInfo(Map<String,Object> params);

	public  Map<String,Object> getOrderBookOne(Map<String,Object> params);

	public List<Map<String,Object>> selectOrderBookList(Map<String,Object> params);

	public int getHOR02MaxSeq(Map<String,Object> params);

	public int insertOrderBookConfirm(Map<String,Object> params);

	public List<Map<String,Object>> getUnregisteredBookList(Map<String,Object> params);

	public int deleteUnregisterdOrderBook(Map<String,Object> params);

	public int insertUnregisterdOrderBook(Map<String,Object> params);

	public int getUnregisterdOrderBookMaxRowNo(Map<String,Object> params);

	public List<Map<String,Object>> getRegisterdOrderBookList(Map<String,Object> params);

	public List<Map<String,Object>> getUnregisterdOrderBookList(Map<String,Object> params);

	public List<Map<String,Object>> getRegisteredOrderDataList(Map<String,Object> params);

	public List<Map<String,Object>> getUnregisteredOrderDataList(Map<String,Object> params);


}
