<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
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
    <script src="/codebase/gochigo.kendo.util.js"></script>
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
    	.pw-lost-text {
    		color: rgba(153, 153, 153, 1);
    	}
    	.login-label-text {
    		text-align: left !important;
    		padding: 0 4rem;
    	}
    	.fieldlist li {
    		padding-bottom: 0;
		}

    </style>
    <script>
    	var _systemName = '${sysInfo.SYSTEM_NM}';
        $(document).ready(function() {

        	location.href = "/admin/login.do";

//         	$('#login_user_id').focus();

//             var validator = $("#loginFrm").kendoValidator().data("kendoValidator");

//             $("#loginFrm").submit(function(event) {
//                event.preventDefault();
//                if(validator.validate()) {
//                    $.post("/loginProc.json", $("#loginFrm").serialize(), function(rJson) {
//                       if(rJson.rMsg) {
//                           GochigoAlert(rJson.rMsg);
//                       }
//                       if(rJson.urlNext) {
//                           location.href = rJson.urlNext;
//                       }
//                    });
//                }
//             });

//             $("#join").click(function(event) {
//                 event.preventDefault();
//                 window.open("/dataEdit.do?xn=JOIN","joinFrm","width=780,height=500,top=200,left=800");
//             });
        });

    </script>
</head>
<body class="login">
<form id="loginFrm" >
<div class="login-div">
    <div class="login-section k-content">
        <div class="login-logo-section">
            <ul class="fieldlist login-logo">
                <li>
                    <img src="/sys_img/${sysInfo.LOGO_IMG_NM}" height="100px; "><br>
                </li>
            </ul>
        </div>
        <div class="login-form">
	        <ul class="fieldlist">
	            <li>
	                <input id="login_user_id" name="login_user_id" type="text" class="login-text"  placeholder="ID" validationMessage="ID를 입력해주세요" required/>
	            </li>
	            <li>
	                <input id="pw" name="pw" type="password" class="login-text"  placeholder="PASSWORD"  validationMessage="비밀번호를 입력해주세요" required/>
	            </li>
	            <li>
		            <div class="login-validate-msg">
		                <span class="k-invalid-msg" data-for="login_user_id"></span>
		                <span class="k-invalid-msg" data-for="pw"></span>
		            </div>
	            </li>
	            <li>
	                <button type="submit" class="login-btn"><span class="k-icon k-i-login"></span>&nbsp;&nbsp;LOGIN</button>
	            </li>
	            <li class="mt15 login-label-text">
	                <%--<button type="button" style="margin-top:15px; width: 160px; height:20px; background-color: #273281; border:1px solid #202a75; border-radius: 23px; text-align: center; color: #ffffff; font-size:12px; font-weight: 500;">BACK</button>--%>
	                <span id="join" class="login-back-btn">사용자등록</span>
	            </li>
	            <li class="mt05 login-label-text">
	            	<span class="pw-lost-text">비밀번호 분실 시 시스템 관리자에게 문의하세요</span>
	            </li>
	        </ul>
   		</div>
	</div>
</div>
</form>
</body>
</html>