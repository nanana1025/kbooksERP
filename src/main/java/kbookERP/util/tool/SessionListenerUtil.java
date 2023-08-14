package kbookERP.util.tool;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.Hashtable;

public class SessionListenerUtil implements HttpSessionListener {

    public static SessionListenerUtil sessionManager = null;
    public static Hashtable sessionMonitor = null;
    public static Hashtable loginSessionMonitor = null;
    public static int maxSessionValidCount;

    @Autowired
    private Environment env;

    public SessionListenerUtil() {
        if(sessionMonitor == null) { sessionMonitor = new Hashtable(); }
        if(loginSessionMonitor == null) { loginSessionMonitor = new Hashtable(); }
        sessionManager = this;

        maxSessionValidCount = Integer.parseInt(env.getProperty("USER_COUNT", "10"));//null인경우 default 10
    }

    public static synchronized SessionListenerUtil getInstance() {
        if(sessionManager == null){
            sessionManager = new SessionListenerUtil();
        }
        return sessionManager;
    }

    public static int getActiveSessionCount() {
        return sessionMonitor.size();
    }

    public static int getActiveLoginSessionCount() {
        return loginSessionMonitor.size();
    }

    public static boolean isMaxSessionLogin() {
        boolean result = false;
        System.out.println("###############세션체크"+maxSessionValidCount+ " "+  getActiveLoginSessionCount());
        if(maxSessionValidCount <= getActiveLoginSessionCount()){
            result = true;
        }
        return result;
    }

    public static void setLoginSession(HttpSession session) {
        synchronized (loginSessionMonitor) {
            loginSessionMonitor.put(session.getId(), session);
        }
    }

    public static void setLogoutSession(HttpSession session) {
        synchronized(loginSessionMonitor) {
            loginSessionMonitor.remove(session.getId());
        }
    }

    @Override
    public void sessionCreated(HttpSessionEvent event) {
        HttpSession session = event.getSession();
        System.out.println("@@@@@@@@@@@@@@@@세션 생성@@@@@@@@@@@@@");
        synchronized(sessionMonitor) {
            sessionMonitor.put(session.getId(), session);
        }
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent event) {
        HttpSession session = event.getSession();
        System.out.println("@@@@@@@@@@@@@@@@세션 삭제@@@@@@@@@@@@@");
        synchronized(sessionMonitor) {
            sessionMonitor.remove(session.getId());
            loginSessionMonitor.remove(session.getId());
        }
    }

}

