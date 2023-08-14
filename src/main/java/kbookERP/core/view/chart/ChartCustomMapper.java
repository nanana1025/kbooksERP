package kbookERP.core.view.chart;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kbookERP.util.map.LowerKeyMap;

@Mapper
public interface ChartCustomMapper {

    List<LowerKeyMap> statWardChart(Map<String, Object> map);
    List<LowerKeyMap> statMonthChart(Map<String, Object> map);
}