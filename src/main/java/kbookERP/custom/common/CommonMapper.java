package kbookERP.custom.common;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CommonMapper {

	Map<String, Object> checkPurchCd(Map<String, Object> params);




    String getVoucherNo();

    String getPaymentNo();

    List<Map<String, Object>> getCode(Map<String, Object> params);

    List<Map<String, Object>> getCode2(Map<String, Object> params);

    List<Map<String, Object>> getCustomCode(Map<String, Object> params);

    int checkCodeListInfo(Map<String, Object> params);

    List<Map<String, Object>> getTable(Map<String, Object> params);

    List<Map<String, Object>> queryDT(Map<String, Object> params);

    void exequteQuery(Map<String, Object> params);

    Long exequteQueryLong(Map<String, Object> params);

    List<Map<String, Object>> exequteQueryDT(Map<String, Object> params);

    String getSeq(Map<String, Object> params);

    Map<String, Object> getCodeValue(Map<String, Object> params);

    Map<String, Object> getCodeName(Map<String, Object> params);


    Long queryLong(Map<String, Object> params);

    public void createVisibleColOne(Map<String, Object> params);

    public void createVisibleCol(Map<String, Object> params);

    public void updateVisibleCol(Map<String, Object> params);

    public List<Map<String, Object>> getVisibleCol(Map<String, Object> params);

    public List<Map<String, Object>> getTableCol(Map<String, Object> params);

    public int wirteUpdateLog(Map<String,Object> params);


    List<Map<String, Object>> getCodeTable(Map<String, Object> params);

    List<Map<String, Object>> getCodeListTable1(Map<String, Object> params);

    void updateCode(Map<String, Object> params);

    void updateSubCode(Map<String, Object> params);

    void updateCodeList(Map<String, Object> params);

    void createCode(Map<String, Object> params);

    void createCodeList(Map<String, Object> params);

    void deleteCode(Map<String, Object> params);

    void deleteCodeList(Map<String, Object> params);

    long getLastAutoIncreasedId();



}
