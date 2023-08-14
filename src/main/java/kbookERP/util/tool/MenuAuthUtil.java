package kbookERP.util.tool;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;

import kbookERP.util.Utils;

@Component
public class MenuAuthUtil {
	
	public static Map<String,Object> checkMenuAuthMap(HttpServletRequest request) {
		HttpSession session = request.getSession();
		
        List<Map<String,Object>> menuInfo = (List<Map<String,Object>>)session.getAttribute("menuInfo");
        if(menuInfo != null) {
        	boolean isMatched = false;
            String reqUri = request.getRequestURI();
            String qStr = request.getQueryString();

            StringBuilder sb = new StringBuilder(reqUri).append("?").append(qStr);
            String url = sb.toString();
            String menuNm = "";
            for(Map<String, Object> map : menuInfo) {
                if(url.equals(map.get("url"))) {
                    isMatched = true;
                    menuNm = map.get("menu_nm").toString();
                    break;
                }
            }

            Map<String,Object> rtnMap = new HashMap<>();
            rtnMap.put("isMatched", isMatched);
            rtnMap.put("reqUrl", url);
            rtnMap.put("reqIP", request.getRemoteAddr());
            rtnMap.put("menuNm", menuNm);

            return rtnMap;
        } else {
        	return null;
        }
    }
	
	public static boolean checkMenuAuth(HttpSession session, HttpServletRequest request) {
        List<Map<String,Object>> menuInfo = (List<Map<String,Object>>)session.getAttribute("menuInfo");
        boolean hasAuth = false;
        String reqUri = request.getRequestURI();
        String qStr = request.getQueryString();

        StringBuilder sb = new StringBuilder(reqUri).append("?").append(qStr);
        String url = sb.toString();

        Map<String,Object> matchMenuMap = null;

        for(Map<String, Object> map : menuInfo) {
            if(url.equals(map.get("url"))) {
                matchMenuMap = map;
            }
        }

        if(matchMenuMap==null) {
            //메뉴 목록에 없는 url
        	session.setAttribute("authTp", "C");
            hasAuth = true;
        } else {
        	session.setAttribute("authTp", matchMenuMap.get("auth_type"));
            if("N".equals(Utils.nvl(matchMenuMap.get("auth_type")))) {
                hasAuth = false;
            } else {
                hasAuth = true;
            }
        }

        return hasAuth;
    }
	
	public static boolean checkMenuAuthUrl(HttpServletRequest request, String urlStr) {
		HttpSession session = request.getSession();
		
        List<Map<String,Object>> menuInfo = (List<Map<String,Object>>)session.getAttribute("menuInfo");
        
        if(menuInfo == null) { return false; }
        
        boolean hasAuth = false;

        Map<String,Object> matchMenuMap = null;

        for(Map<String, Object> map : menuInfo) {
            if(urlStr.equals(map.get("url"))) {
                matchMenuMap = map;
                break;
            }
        }

        if(matchMenuMap==null) {
            //메뉴 목록에 없는 url
        	session.setAttribute("authTp", "C");
            hasAuth = true;
        } else {
        	session.setAttribute("authTp", matchMenuMap.get("auth_type"));
            if("N".equals(Utils.nvl(matchMenuMap.get("auth_type")))) {
                hasAuth = false;
            } else {
                hasAuth = true;
            }
        }

        return hasAuth;
    }
	
}
