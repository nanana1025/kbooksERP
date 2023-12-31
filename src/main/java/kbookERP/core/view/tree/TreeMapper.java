package kbookERP.core.view.tree;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kbookERP.util.map.LowerKeyMap;

@Mapper
public interface TreeMapper {

    List<LowerKeyMap> treeLoad(Map<String, Object> map);

    List<LowerKeyMap> codeTree(Map<String, Object> map);
}