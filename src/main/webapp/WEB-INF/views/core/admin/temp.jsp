<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlUserAdd"				value="/admin/admNewMember.do" />
<c:url var="urlUserFindIdView"			value="/admin/userFindIdView.do" />
<c:url var="urlUserPWFind"				value="/admin/userPasswordFindView.do" />

<!DOCTYPE html>
<html>
<head>
    <title>Inventory Control</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta charset="utf-8"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/fonts/NotoSansKR/stylesheets/NotoSansKR-Hestia.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

    <script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="/codebase/kendo/messages/kendo.messages.ko-KR.min.js"></script>
	<script src="/codebase/kendo/jszip.min.js"></script>
    <script src="/codebase/common.js"></script>
    <script src="/codebase/default.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.ui.js"></script>

    <style>
    ::placeholder { /* Chrome, Firefox, Opera, Safari 10.1+ */
        color: #ffffff;
        opacity: 1; /* Firefox */
    }
    :-ms-input-placeholder { /* Internet Explorer 10-11 */
        color: #ffffff;
    }
    ::-ms-input-placeholder { /* Microsoft Edge */
        color: #ffffff;
    }
    .fieldlist li {
    		padding-bottom: 0;
	}

    </style>
    <script>
    	var _systemName = '${sysInfo.SYSTEM_NM}';
        $(document).ready(function() {
            $("#adminId").focus();

          });
        });

        

    </script>
</head>
<body class="login">
<form id="loginFrm" >
<div class="login-div">
    <div class="login-section k-content">

    </div>
</div>
</form>
</body>
</html>