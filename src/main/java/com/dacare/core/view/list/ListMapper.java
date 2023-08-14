package com.dacare.core.view.list;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.dacare.util.map.LowerKeyMap;

@Mapper
public interface ListMapper {

	List<LowerKeyMap> getCubridDataListByXml(Map<String, Object> param);

    List<LowerKeyMap> getOracleDataListByXml(Map<String, Object> param);
    
    List<LowerKeyMap> getMariaDBDataListByXml(Map<String, Object> param);
    
    int getDataListByXmlCnt(Map<String, Object> param);

    List<Map<String,Object>> getSelectComboBySql(Map<String, Object> selectSql);
}