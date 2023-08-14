package com.dacare.spring.config;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.dacare.dev.SystemService;
import com.dacare.util.constant.Cubrid;
import com.dacare.util.constant.MariaDB;
import com.dacare.util.constant.Oracle;
import com.dacare.util.tool.MenuAuthUtil;
import com.dacare.util.vo.User;

@Aspect
@Component
public class AspectManager {

    private static final Logger logger = LoggerFactory.getLogger(AspectManager.class);

    @Autowired
    SystemService systemService;

    @Value("${spring.datasource.dbtype}")
	String dbType;

    @Pointcut("execution(public * com.dangol365..*Controller.*(..))")
    public void requestAll() {
        logger.info("");
    }

    @Before("requestAll()")
    public void onBeforeHandler(JoinPoint joinPoint) throws Exception {
    	Map<String,Object> param = null;
    	String msg = "";
        for(Object o: joinPoint.getArgs()) {
            Map<String,Object> logParam = new HashMap<>();
            if( o instanceof HttpServletRequest) {
                HttpServletRequest req = (HttpServletRequest) o;
                HttpSession session = req.getSession();
                User usrInfo = (User) session.getAttribute("userInfo");

                if(usrInfo != null && "USER".equals(session.getAttribute("SESSION_USER_TYPE"))) {
                    logParam = MenuAuthUtil.checkMenuAuthMap(req);
                    if((boolean)logParam.get("isMatched")) {
                        logParam.put("user_id", usrInfo.getUser_id());
						String datetime = "";
						if ("CUBRID".equalsIgnoreCase(dbType)) {
							datetime = Cubrid.DATETIME;
						} else if ("ORACLE".equalsIgnoreCase(dbType)) {
							datetime = Oracle.DATE;
						} else if ("MARIADB".equalsIgnoreCase(dbType)) {
							datetime = MariaDB.DATETIME;
						}
                        logParam.put("sysdatetime", datetime);
                        systemService.saveLog(logParam);
                    }
                }
            }
            if( o instanceof Map<?,?>) {
            	param = (HashMap<String,Object>) o;
            	msg = String.format("\n[param : %s]", param);
            }
        }
        logger.debug(msg);
    }

    @After("requestAll()")
    public void onAfterHandler(JoinPoint joinPoint) {
//        logger.info("=============== onAfterHandler");
    }

//    public Map<String,Object> checkMenuAuth(HttpSession session, HttpServletRequest request) {
//        List<Map<String,Object>> menuInfo = (List<Map<String,Object>>)session.getAttribute("menuInfo");
//        boolean isMatched = false;
//        String reqUri = request.getRequestURI();
//        String qStr = request.getQueryString();
//
//        StringBuilder sb = new StringBuilder(reqUri).append("?").append(qStr);
//        String url = sb.toString();
//        String menuNm = "";
//        for(Map<String, Object> map : menuInfo) {
//            if(url.equals(map.get("url"))) {
//                isMatched = true;
//                menuNm = map.get("menu_nm").toString();
//                break;
//            }
//        }
//
//        Map<String,Object> rtnMap = new HashMap<>();
//        rtnMap.put("isMatched", isMatched);
//        rtnMap.put("reqUrl", url);
//        rtnMap.put("reqIP", request.getRemoteAddr());
//        rtnMap.put("menuNm", menuNm);
//
//        return rtnMap;
//    }
}
