package kbookERP.spring.resolver;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

@Component
public class GochigoSimpleMappingExceptionResolver extends SimpleMappingExceptionResolver{


	@Override
	@ExceptionHandler(value=Exception.class)
	protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception e) {

		if(request.getHeader("AJAX") != null && request.getHeader("AJAX").equals("true")) {
			Integer statusCode = 404;//determineStatusCode(request, viewName);
			if(statusCode != null) {
				applyStatusCodeIfPossible(request, response, statusCode);
			}
			ModelAndView mv = new ModelAndView();
			e.printStackTrace(); //개발용
			mv.addObject("errMsg", e.getMessage());
			mv.setView(new MappingJackson2JsonView());
			return mv;
		} else {
			ModelAndView mv = new ModelAndView("/core/error");
			mv.addObject("timestamp", new Date());
			mv.addObject("status", 500);
			mv.addObject("message", e.getMessage());
			mv.addObject("exception", e.getCause());
			StringBuffer sb = new StringBuffer();
			for(StackTraceElement st : e.getStackTrace()) {
				sb.append(st.toString());
				sb.append("\n");
			}
			e.printStackTrace(); //개발용
			mv.addObject("trace", sb.toString());

			return mv;
		}
	}
}
