package kbookERP.core.mngm;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kbookERP.util.map.LowerKeyMap;

@Mapper
public interface MngmMapper {

    List<LowerKeyMap> getDataListByXml(Map<String, Object> param);

    int getDataListByXmlCnt(Map<String, Object> param);

    List<Map<String,Object>> getSelectComboBySql(Map<String, Object> selectSql);

    List<Map<String,Object>> getSelectTreeItemBySql(Map<String, Object> selectSql);

    Map<String,Object> getDataViewByXml(Map<String, Object> param);

    List<Map<String,Object>> getColAttr(Map<String, Object> param);

    String getFileIdBySql(Map<String, Object> param);

    List<Map<String,Object>> getFileNameBySql(Map<String, Object> param);

    int setDataUpdate(Map<String, Object> param);

    int setDataInsert(Map<String, Object> param);

    int setDataDelete(Map<String, Object> param);

    List<LowerKeyMap> treeTest(Map<String, Object> map);

    List<Map<String,Object>> treeListTest();

    String getInsCondValue(Map<String, Object> param);
}