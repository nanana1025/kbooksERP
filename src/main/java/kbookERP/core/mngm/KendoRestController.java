package kbookERP.core.mngm;

import java.io.BufferedReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;

import kbookERP.admin.AdminMapper;
import kbookERP.util.Utils;

@Controller
public class KendoRestController {
    @Autowired
    AdminMapper adminMapper;

//    @GetMapping("/kendo/rest/list.json")
//    @ResponseBody
//    public String test(@RequestParam Map<String,Object> params) throws Exception{
//        System.out.println("================== list ==================");
//        System.out.println(params);
//        System.out.println("================== list ==================");
//
//        int posStart = 0;
//        int take = 0;
//        if(params.get("skip") != null) {
//            posStart = Integer.parseInt(params.get("skip").toString())+1;
//        } else {
//            posStart = 1;
//        }
//        if(params.get("take") != null) {
//            take = Integer.parseInt(params.get("take").toString());
//        } else {
//            take = 10;
//        }
//
//        params.put("startNum"   , posStart-1);
//        params.put("endNum"     , take);
//
//        String clause = "";
//        if (params.get("sort[0][field]") != null && !"".equals(params.get("sort[0][field]"))) {
//            String direction = "desc".equals(params.get("sort[0][dir]")) ? " DESC" : " ASC";
//            clause += " ORDER BY " + params.get("sort[0][field]") + " " + direction;
//        }
//
//        params.put("orderBy", clause);
//
//        ObjectMapper om = new ObjectMapper();
//
//        List<Map<String,Object>> list = adminMapper.kendoTestList(params);
//        Map<String,Object> map = adminMapper.kendoTestListCnt(params);
//        map.put("list", list);
//
//        return om.writeValueAsString(map);
////        return map;
//    }
//
//    @RequestMapping("/kendo/rest/create.json")
//    @ResponseBody
//    public String create(@RequestParam Map<String,Object> params) throws Exception {
//        System.out.println("================== create ==================");
//        System.out.println(params);
//        System.out.println("================== create ==================");
//
//        params.put("create_id", 2);
//        params.put("use_yn", "Y");
//        int rslt = adminMapper.kendoTestInsert(params);
//
//        return getResult(rslt>0, "저장되었습니다.");
//    }
//
//    @RequestMapping("/kendo/rest/update.json")
//    @ResponseBody
//    public String update(@RequestParam Map<String,Object> params) throws Exception {
//        System.out.println("================== update ==================");
//        System.out.println(params);
//        System.out.println("================== update ==================");
//
//        params.put("update_id", 2);
//        int rslt = adminMapper.kendoTestUpdate(params);
//
//        return getResult(rslt>0, "저장되었습니다.");
//    }
//
//    @RequestMapping("/kendo/rest/destroy.json")
//    @ResponseBody
//    public String destroy(@RequestParam Map<String,Object> params) throws Exception {
//        System.out.println("================== destroy ==================");
//        System.out.println(params);
//        System.out.println("================== destroy ==================");
//
//        int rslt = adminMapper.kendoTestDelete(params);
//
//        return getResult(rslt>0, "삭제되었습니다.");
//    }
//
//    public String getResult(boolean isSuccess, String msg) throws Exception {
//        Map<String,Object> map = new HashMap<String,Object>();
//        map.put("success" , isSuccess);
//        map.put("msg", Utils.nvl(msg));
//        ObjectMapper om = new ObjectMapper();
//        return om.writeValueAsString(map);
//    }
//
//    @RequestMapping("/kendo/rest/getCombo.json")
//    @ResponseBody
//    public String getComboJson(@RequestParam Map<String,Object> params) throws Exception {
//        List<Map<String,Object>> list = adminMapper.kendoTestGetComboJson(params);
//        Map<String,Object> rslt = new HashMap<String,Object>();
//        rslt.put("combo", list);
//        return new ObjectMapper().writeValueAsString(list);
//    }
//
//    private String readJSONStringFromRequestBody(HttpServletRequest request){
//        StringBuffer json = new StringBuffer();
//        String line = null;
//
//        try {
//            BufferedReader reader = request.getReader();
//            while((line = reader.readLine()) != null) {
//                json.append(line);
//            }
//
//        }catch(Exception e) {
//            System.out.println("Error reading JSON string: " + e.toString());
//        }
//        return json.toString();
//    }

}
