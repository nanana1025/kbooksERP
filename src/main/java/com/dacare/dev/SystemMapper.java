package com.dacare.dev;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.dacare.util.map.LowerKeyMap;

@Mapper
public interface SystemMapper {
    int saveSystemInfo(Map<String, Object> params);
    int updateSystemInfo(Map<String, Object> params);

    String getSystemId();
    Map<String,Object> getSystemInfoList(Map<String,Object> params);
    int getSystemInfoCnt();
    int updateMenuInfo(Map<String,Object> params);
    int deleteImgInfo(Map<String,Object> params);

    List<LowerKeyMap> getXmlList(Map<String, Object> param);

    int deleteXml(Map<String, Object> map);

    void saveLog(Map<String,Object> params);
}
