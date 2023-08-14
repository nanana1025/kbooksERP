<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
%><%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"
%><%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions"
%><%@ taglib prefix="fmt"		uri="http://java.sun.com/jsp/jstl/fmt"
%><%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags"
%><%@ taglib prefix="sec" 		uri="http://www.springframework.org/security/tags"
%><%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	if(request.getProtocol().equals("HTTP/1.1")){
		response.setHeader("Cache-Control", "no-cache");
	}

	/* fn:replace(sometext, newLine, '<br/>') 을 사용할 수 있도록 하기 위해 pageContext 에 newLine 추가 */
	pageContext.setAttribute("newLine", "\n");
%>