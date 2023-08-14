package kbookERP.core.view.list;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kbookERP.util.map.LowerKeyMap;

@Mapper
public interface ListCustomMapper {

	List<LowerKeyMap> statConditionComponentList(Map<String, Object> param);
	List<LowerKeyMap> statConditionComponentListCnt(Map<String, Object> param);

	List<LowerKeyMap> statApproveNurseList(Map<String, Object> param);
	List<LowerKeyMap> statConditionMatronList(Map<String, Object> param);
	List<LowerKeyMap> statConditionNurseList(Map<String, Object> param);
	List<LowerKeyMap> statConditionMemberListCnt(Map<String, Object> param);
	List<LowerKeyMap> statConditionCompanyListCnt(Map<String, Object> param);

}