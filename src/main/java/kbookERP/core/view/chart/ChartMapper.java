package kbookERP.core.view.chart;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kbookERP.util.map.LowerKeyMap;

@Mapper
public interface ChartMapper {

    List<LowerKeyMap> chartLoad(Map<String, Object> map);
}