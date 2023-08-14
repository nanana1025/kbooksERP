package kbookERP.spring.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kbookERP.util.vo.User;

@Component
public class SaveLogInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String ipAddr = request.getRemoteAddr();
        HttpSession session = request.getSession();
        User user = (User)session.getAttribute("userInfo");

        String _url = request.getRequestURI();
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) {
        String url = request.getRequestURI();
        String ipAddr = request.getRemoteAddr();
        String userId = request.getParameter("user_id");
        String userNm = request.getParameter("user_nm");
        System.out.println("request_shlee = "+request);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {

    }
}
