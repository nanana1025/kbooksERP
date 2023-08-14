<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:url var="urlUserAdd" value="/member/admNewMember.do"/>
<c:url var="urlUserTypeSelect" value="/member/admNewMemberType.do"/> <%-- 회원가입 시 개인/기업 선택 화면 --%>
<c:url var="urlUserFindIdView" value="/member/userFindIdView.do"/>
<c:url var="urlUserPWFind" value="/member/userPasswordFindView.do"/>

<!DOCTYPE html>
<html>
<head>
    <title>Inventory Control</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1"/>
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

        .login-btn {
            width: 411px;
            height: 46px;
            background-color: #DA391D;
            border: 1px solid #DA391D;
            border-radius: 2px;
            text-align: center;
            color: #ffffff;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
        }

        .login-btn1 {
            width: 100px;
            height: 20px;
            background-color: #9a9a9a;
            border: 1px solid #9a9a9a;
            border-radius: 2px;
            text-align: center;
            color: #ffffff;
            font-size: 10px;
            font-weight: 800;
            cursor: pointer;
            margin: 0px 3px 0px 3px;
        }

    </style>
    <script>
        var _systemName = '${sysInfo.SYSTEM_NM}';
        $(document).ready(function () {
            $("#adminId").focus();

            $("#backBtn").click(function (event) {
                event.preventDefault();
                location.href = '/systemSel.do';
            });

            $("#registrationBtn").click(function (event) {
                event.preventDefault();
                location.href = '/systemSel.do';
            });
        });

        function fnLogin() {
            if ($("#adminId").val() == "") {
                alert("ID를 입력하세요.");
                $("#EMAIL").focus();
                return false;
            }
            if ($("#adminPw").val() == "") {
                alert("비밀번호를 입력해주세요.");
                $("#PW").focus();
                return false;
            }

            var validator = $("#loginFrm").kendoValidator().data("kendoValidator");

            $("#loginFrm").submit(function (event) {
                event.preventDefault();
                if (validator.validate()) {
                    $.post("/admin/admLoginProc.json", $("#loginFrm").serialize(), function (rJson) {
                        if (rJson.rMsg) {
                            GochigoAlert(rJson.rMsg);
                        }
                        if (rJson.urlNext) {
                            location.href = rJson.urlNext;
                        }
                    });
                }
            });
        }

        function fnJoin() {
            event.preventDefault();
            location.href = "${urlUserAdd}";
        }

        // 회원가입 선택(개인/기업) 화면으로 이동
        function fnSelectUserType() {
            event.preventDefault();
            location.href = "${urlUserTypeSelect}";
        }

        // 아이디 찾기
        function fnFindID() {
            event.preventDefault();
            console.log("1111");
            location.href = "${urlUserFindIdView}";
        }

        // 비밀번호 찾기
        function fnFindPW() {
            event.preventDefault();
            console.log("2222");
            location.href = "${urlUserPWFind}";
        }

    </script>
</head>
<body class="login">
<form id="loginFrm">
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
                        <input id="adminId" name="adminId" type="text" class="login-text" placeholder="ADMIN ID"
                               validationMessage="ID를 입력해주세요" required/>
                    </li>
                    <li>
                        <input id="adminPw" name="adminPw" type="password" class="login-text" placeholder="PASSWORD"
                               validationMessage="비밀번호를 입력해주세요" required/>
                    </li>
                    <li>
                        <div class="login-validate-msg">
                            <span class="k-invalid-msg" data-for="adminId"></span>
                            <span class="k-invalid-msg" data-for="adminPw"></span>
                        </div>
                    </li>
                    <li>
                        <div class="input_btn_wr">
                            <button class="login-btn" onClick="fnLogin()">로그인</button>
                            <br><br>
                            <button class="login-btn1" onClick="fnSelectUserType()">회원가입</button>
                            <button class="login-btn1" onClick="fnFindID()">아이디 찾기</button>
                            <button class="login-btn1" onClick="fnFindPW()">비밀번호 찾기</button>
                        </div>

                        <!--  <button type="submit" class="login-btn"><span class="k-icon k-i-login"></span>&nbsp;&nbsp;LOGIN</button> -->

                    </li>
                    <li class="mt15">
                        <%--<button type="button" style="margin-top:15px; width: 160px; height:20px; background-color: #273281; border:1px solid #202a75; border-radius: 23px; text-align: center; color: #ffffff; font-size:12px; font-weight: 500;">BACK</button>--%>
                        <!--                 <span id="backBtn" class="login-back-btn">개발자메뉴</span> -->
                        <!-- <span id="join" class="login-back-btn">사용자등록</span> -->
                    </li>
                    <li class="mt05 login-label-text">
                        <span class="pw-lost-text">기능  오류 발생 시 시스템 관리자에게 문의하세요</span>
                    </li>
                    <!--  <li>
                         <span class="login-notification">※ 시스템 설정에 등록된 관리자 ID로 로그인 하실 수 있습니다.</span>
                     </li> -->
                </ul>
            </div>
        </div>
    </div>
</form>
</body>
</html>