package kbookERP.admin;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kbookERP.util.vo.User;

@Mapper
public interface AdminMapper {

	int insertUser(Map<String,Object> params);

    List<Map<String,Object>> getAuthInfo(Map<String,Object> params);

    int updateUserAuth(Map<String,Object> params);

    int saveMenuAuth(Map<String,Object> params);

    int deleteMenuAuth(String authId);

    List<Map<String,Object>> getMenuAuth(String authId);

    int codeClsInsert(Map<String,Object> params);
    int codeClsUpdate(Map<String,Object> params);
    int codeClsDelete(Map<String,Object> params);
    int codeClsSubDelete(Map<String,Object> params);

    Map<String,Object> codeClsInfo(Map<String,Object> params);

    int getUserInfoById(Map<String,Object> params);
    User getUserInfoByUserId(Map<String,Object> params);
    int pwInit(Map<String,Object> params);

    User getAdminInfo(String userId);

    Map<String,Object> getAuthById(Map<String,Object> params);



    int setUserInsert(Map<String,Object> params);
    int setUserUpdate(Map<String,Object> params);
}
