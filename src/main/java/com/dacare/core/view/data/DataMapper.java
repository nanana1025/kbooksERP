package com.dacare.core.view.data;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.dacare.util.map.UMap;

@Mapper
public interface DataMapper {

	Map<String,Object> getDataViewByXml(Map<String, Object> param);

	List<Map<String,Object>> getSelectComboBySql(Map<String, Object> selectSql);

	List<Map<String,Object>> getFileNameBySql(Map<String, Object> param);
	String getFileIdBySql(Map<String, Object> param);

    int setDataUpdate(Map<String, Object> param);

    int setDataInsert(Map<String, Object> param);

    int copyData(Map<String, Object> param);

    int setDataDelete(Map<String, Object> param);

    List<UMap> getColAttr(Map<String, Object> param);
    List<UMap> getOracleColAttr(Map<String, Object> param);
    List<UMap> getMariaDBColAttr(Map<String, Object> param);

    String getInsCondValue(Map<String, Object> param);
    String getOracleInsCondValue(Map<String, Object> param);
    String getMariaDBInsCondValue(Map<String, Object> param);

    long getSerialNo(Map<String, Object> param);

    void updateSerialNo(Map<String, Object> param);

    int setCompManageInsert(Map<String, Object> param);

    int setInvenManageInsert(Map<String, Object> param);

    int setInvenManageMulitInsert(Map<String, Object> param);

    int setInvenInfoInsert(Map<String, Object> param);

	public void insertLTPurchasePriceInfo(Map<String,Object> params);

	public void updateLTPurchasePriceIdInTnPrice(Map<String,Object> params);

	public Map<String, Object> selectLTPurchasePriceId(Map<String,Object> params);

	public void insertTnPriceData(Map<String,Object> params);




}