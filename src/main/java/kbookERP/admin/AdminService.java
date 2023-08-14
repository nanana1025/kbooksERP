package kbookERP.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminService {
    @Autowired
    AdminMapper adminMapper;

    public List<Map<String,Object>> getAuthInfo(Map<String,Object> params) throws Exception {
        List<Map<String,Object>> dbRslt = adminMapper.getAuthInfo(params);

        Map<String,Object> nMap = new HashMap<>();
        nMap.put("AUTH_ID", null);
        nMap.put("AUTH_NM", "선택");

        List<Map<String,Object>> rtnList = new ArrayList<>();
        rtnList.add(nMap);
        rtnList.addAll(dbRslt);

        return rtnList;
    }

    public List<Map<String,Object>> getMenuAuth(String authId) throws Exception {
        return adminMapper.getMenuAuth(authId);
    }

}
