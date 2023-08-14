<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlIDCheck"					value="/member/idCheckProc.json" />
<c:url var="urlEmailCheck"				value="/member/emailCheckProc.json" />
<c:url var="urlNickNameCheck"			value="/member/nickNameCheckProc.json" />
<c:url var="urlSave"					value="/member/userInstProc.json" />
<c:url var="urlLogin"					value="/admin/login.do" />

<c:url var="urlUserAdd" value="/member/admNewMember.do"/>
<c:url var="urlCompanyAdd" value="/member/admNewCompany.do"/>

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
	<link rel="stylesheet" type="text/css" href="/codebase/css/sub_style.css"/>

    <script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="/codebase/kendo/messages/kendo.messages.ko-KR.min.js"></script>
	<script src="/codebase/kendo/jszip.min.js"></script>
    <script src="/codebase/common.js"></script>
    <script src="/codebase/default.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.ui.js"></script>
    <script src="/js/gochigo.utils.js"></script>
    <script src="/js/gochigo.kendo.ui.js"></script>

    <script>
        function fnJoinPrivate() {
            event.preventDefault();
            location.href = "${urlUserAdd}";
        }

        function fnJoinCompany() {
            event.preventDefault();
            location.href = "${urlCompanyAdd}";
        }
    </script>

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

	.user_type > span {
		cursor: pointer;
	}

    .user_type_select_section {
        width: 60%;
        margin: auto;
        margin-top: 10%;
    }

    .user_type_list {
        display: grid;
        grid-template-columns: 50% 50%;
        width: 80%;
        margin: auto;
    }

    .user_type {
        text-align: center;
        font-size: 18px;
        padding: 20px;
        margin: 10px;
        border: 0px;
        border-radius: 0px;
    }

    .user_type a {
        color: black;
    }

    .sc_title {
        padding: 30px;
    }

    </style>


</head>

<body class="login">

	<div id="loginFrm" >
        <div class="login-div">

            <div class="user_type_select_section k-content">

                <div class="sc_title">
                    <div class="title_line"></div>
                            <h2>회원가입 유형 선택</h2>
                            <hr>
                </div>

                <div class="user_type_list">
                    <button class="user_type btn_cl" onclick="fnJoinPrivate()" style="background-color: lightblue"> 개인회원가입 </button>
                    <button class="user_type btn_cl" onclick="fnJoinCompany()" style="background-color: lightpink"> 기업회원가입 </button>
                </div>

                <div class="sc_title" style="padding-bottom: 0px; margin-bottom: 10px;">
                    <div style="border-bottom: 0.1px solid lightgray"></div>
                </div>

                <div class="input_btn_wr2 mgt20">
                    <a href="/admin/login.do" class="cc" style="margin-bottom: 25px;">로그인 화면으로 이동</a>
                </div>

            </div>

        </div>
	</div>
</body>
</html>