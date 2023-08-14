<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${param.mode!='layout'}">
<!DOCTYPE html>
<html>
<head>
    <title>Index</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta charset="utf-8"/>
    <%--<link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>--%>
    <link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

    <script src="/js/jquery-1.12.4.js"></script>
    <script src="/codebase/kendo/kendo.all.min.js"></script>
    <script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>

    <style>
    </style>
    <script>

    </script>
</head>
<body>
</c:if>
<div class="header_title">
    <span class="pagetitle"><span class="k-icon k-i-information"></span>${sysInfo.SYSTEM_NAME} 시스템정보</span>
</div>
<div class="body-content">
    <table width="100%" class="tbl_type01">
        <colgroup>
            <col width="20%"/>
            <col width="*"/>
        </colgroup>
        <tbody>
            <tr>
                <th>시스템코드</th>
                <td>${sysInfo.SYSTEM_ID}</td>
            </tr>
            <tr>
                <th>시스템명</th>
                <td>${sysInfo.SYSTEM_NM}</td>
            </tr>
            <tr>
                <th>시스템생성일</th>
                <td>${sysInfo.CREATE_DT}</td>
            </tr>
            <tr>
                <th>관리자아이디</th>
                <td>${sysInfo.ADMIN_ID}</td>
            </tr>
            <tr>
                <th>로고 IMG</th>
                <td>
                    <c:if test="${sysInfo.LOGO_IMG_NM != null}">
                    <img src="/sys_img/${sysInfo.LOGO_IMG_NM}" height="100px">
                    </c:if>
                </td>
            </tr>
        </tbody>
    </table>
</div>
<c:if test="${param.mode!='layout'}">
</body>
</html>
</c:if>