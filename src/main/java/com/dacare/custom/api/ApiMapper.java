package com.dacare.custom.api;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ApiMapper {

	public List<Map<String,Object>> getProductType(Map<String,Object> params);

	public Map<String,Object> getManageNoInfo(Map<String,Object> params);

	public Map<String,Object> getManageNoCheck(Map<String,Object> params);

	public Map<String,Object> getWarrantyType(Map<String,Object> params);

	public Map<String,Object> getSaleInfo(Map<String,Object> params);

	public int insertSaleInfo(Map<String, Object> params);

	public int updateSaleInfo(Map<String, Object> params);

	public int insertCustomerInfo(Map<String, Object> params);

	public int updateCouponInfo(Map<String, Object> params);

	public Map<String,Object> getSaleInfoForAsworld(Map<String,Object> params);

	public int deleteSaleInfo(Map<String, Object> params);

	public Map<String,Object> selectCustomerInfo(Map<String,Object> params);

	public int deleteCustomerInfo(Map<String, Object> params);

	public int updateCustomerInfo(Map<String, Object> params);

	public Map<String,Object> getSalePcInfo(Map<String,Object> params);

	public Map<String,Object> getSaleInfo4Danawa(Map<String,Object> params);






	public List<Map<String,Object>> getDataByDate(Map<String,Object> params);

	public void insertReservation(Map<String, Object> params);

	public int deleteReservation(Map<String, Object> params);
}
