<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Inventory Control</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta charset="utf-8"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
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
    <script src="/codebase/gochigo.kendo.common.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>

    <style>
        .fieldSet {
            display: inline-block;
            margin-bottom: 10px;
        }
        html,
        body
        {
            height:100%;
            margin:0;
            padding:0;
            overflow:auto;
        }
        .title > h2 {
            color:#fff;
            font-size:15px;
            line-height:35px;
            padding-left:18px;
            background:#415169;
            margin:0px;
        }
        .fieldlist {
            margin: 0 0 -2em;
            padding: 0;
        }

        .fieldlist li {
            list-style: none;
            padding-top: 0.5em;
            padding-bottom: 0.5em;
            text-align: center;
        }
    </style>
    <script>
    var _systemName = '${sysInfo.SYSTEM_NM}';

        function onLogin() {
            var validator = $("#devLoginFrm").kendoValidator().data("kendoValidator");
            if(validator.validate()) {
                $.ajax({
                    url :'/devLogin.json',
                    data : {pwd : $("#pwd").val()},
                    success : function(rJson) {
                        if(rJson.isLoginPass) {
                            if(btnTp == "system")location.href = "/system/systemInfo.do";
                            else if(btnTp == "xml")location.href = "/system/xmlSel.do";
                        } else {
                            GochigoAlert('개발자 Password 확인 후 다시 시도해주세요');
                        }

                    }
                });
            }
        }

        function onCancel(e) {

        }

        var btnTp = '';

        $(document).ready(function() {

            $(document).keypress(function(e) {
                if(e.which == 13) {
                    if($(".k-dialog").css("display") == "block") {
                        onLogin(e);
                    }
                }
            });

            var dialog = $("#dialog_dev_login");

            function onClickBtn(e) {
                var $trgtId = $(e.event.target).closest(".k-button").attr("id");
            }
//             $("#systemSetBtn").kendoButton({
//                 click : function(e) {
//                     if($("#s_usr_tp").val() == 'DEV') {
//                         location.href="/system/systemInfo.do";
//                     } else {
//                         btnTp = 'system';
//                         if(dialog.data("kendoDialog")==null) {
//                             dialog.kendoDialog({
//                                 width : "300px",
//                                 title : "개발자 로그인",
//                                 closable : true,
//                                 modal : false,
//                                 content : "<div id='devLoginFrm'>" +
//                                             "<label for=\"pwd\">Developer Password</label>&nbsp;&nbsp;" +
//                                             "<input type=\"password\" id=\"pwd\" class=\"k-textbox\" value=\"gochigodev\" required validationMessage='비밀번호를 입력해주세요'>" +
//                                           "</div>",
//                                 actions : [
//                                     {text : "LOGIN", primary : true, action: onLogin},
//                                     {text : "CANCEL", action : onCancel}
//                                 ]
//                             });
//                         } else {
//                             dialog.data("kendoDialog").open();
//                         }
//                         $("#pwd").focus();
//                     }
//                 }
//             });
//             $("#xmlSetBtn").kendoButton({
//                 click : function() {
//                     if($("#isEmptySystemInfo").val()=='true') {
//                         GochigoAlert('등록된 시스템정보가 없습니다.');
//                     } else {
//                         if ($("#s_usr_tp").val() == 'DEV') {
//                             location.href = "/system/xmlSel.do";
//                         } else {
//                             btnTp = 'xml';
//                             if (dialog.data("kendoDialog") == null) {
//                                 dialog.kendoDialog({
//                                     width: "300px",
//                                     title: "개발자 로그인",
//                                     closable: true,
//                                     modal: false,
//                                     content: "<div id='devLoginFrm'><label for=\"pwd\">Developer Password</label>&nbsp;&nbsp;<input type=\"password\" id=\"pwd\" class=\"k-textbox\" value=\"gochigodev\" required validationMessage='비밀번호를 입력해주세요'></div>",
//                                     actions: [
//                                         {text: "LOGIN", primary: true, action: onLogin},
//                                         {text: "CANCEL", action: onCancel}
//                                     ]
//                                 });
//                             } else {
//                                 dialog.data("kendoDialog").open();
//                             }
//                             $("#pwd").focus();
//                         }
//                     }

//                 }
//             });
            $("#adminViewBtn").kendoButton({
                click : function() {
                    location.href = "/admin/login.do";
                }
            });
            $("#userViewBtn").kendoButton({
                click : function() {
                    location.href = "/";
                }
            });

            $("#menuSetBtn").kendoButton({
                click : function() {
                    if($("#s_usr_tp").val() == 'DEV' || $("#s_usr_tp").val() == 'ADM') {
                        location.href="/system/menuXmlSet.do";
                    } else {
                        xmlTp = 'menu';
                        loginDev();
                    }
                }
            });
            $("#admMenuSetBtn").kendoButton({
                click : function() {
                    if($("#s_usr_tp").val() == 'DEV' || $("#s_usr_tp").val() == 'ADM') {
                        location.href="/system/admMenuXmlSet.do";
                    } else {
                        xmlTp = 'admMenu';
                        loginDev();
                    }
                }
            });
            $("#scrnSetBtn").kendoButton({
                click : function() {
                    if($("#s_usr_tp").val() == 'DEV' || $("#s_usr_tp").val() == 'ADM') {
                        location.href="/system/scrnXmlSet.do";
                    } else {
                        xmlTp = 'scrn';
                        loginDev();
                    }
                }
            });
            $("#admScrnSetBtn").kendoButton({
                click : function() {
                    if($("#s_usr_tp").val() == 'DEV' || $("#s_usr_tp").val() == 'ADM') {
                        location.href="/system/admScrnXmlSet.do";
                    } else {
                        xmlTp = 'admScrn';
                        loginDev();
                    }
                }
            });
        });

        function onLogin(e) {
            var validator = $("#devLoginFrm").kendoValidator().data("kendoValidator");

            if(validator.validate()) {
                $.ajax({
                    url :'/devLogin.json',
                    data : {pwd : $("#pwd").val()},
                    success : function(rJson) {
                        if(rJson.isLoginPass) {
                            if(xmlTp == 'menu')location.href = "/system/menuXmlSet.do";
                            else if(xmlTp == 'admMenu')location.href = "/system/admMenuXmlSet.do";
                            else if(xmlTp == 'admScrn')location.href = "/system/admScrnXmlSet.do";
                            else if(xmlTp == 'scrn')location.href = "/system/scrnXmlSet.do";
                        } else {
                            GochigoAlert('개발자 Password 확인 후 다시 시도해주세요');
                        }

                    }
                });
            }
        }

		function loginDev() {
            var dialog = $("#dialog_dev_login");
            if(dialog.data("kendoDialog")==null || dialog.data("kendoDialog")==undefined) {
                dialog.kendoDialog({
                    width : "300px",
                    title : "개발자 로그인",
                    closable : true,
                    modal : false,
                    content : "<div id='devLoginFrm'><label for=\"pwd\">Developer Password</label>&nbsp;&nbsp;<input type=\"password\" id=\"pwd\" class=\"k-textbox\" value=\"gochigodev\" required validationMessage='비밀번호를 입력해주세요'></div>",
                    actions : [
                        {text : "LOGIN", primary : true, action: onLogin},
                        {text : "CANCEL", action : onCancel}
                    ]
                });
            } else {
                dialog.data("kendoDialog").open();
            }
            $("#pwd").focus();
		}
    </script>
</head>
<body>
<input type="hidden" id="s_usr_tp" value="${sessionScope.SESSION_USER_TYPE}">
<input type="hidden" id="isEmptySystemInfo" value="${isEmptySystemInfo}">
<div id="example" >
    <div class="demo-section k-content">
        <div class="title">
            <h2 style="margin-bottom: 1em;">Inventory Control</h2>
        </div>

        <ul class="fieldlist">
<!--             <li> -->
<!--                 <button type="button" id="systemSetBtn" style="width: 150px; height: 80px;">System Set</button> -->
<!--                 <button type="button" id="xmlSetBtn" style="width: 150px; height: 80px;">XML Set</button> -->
<!--             </li> -->
            <li>
                <button type="button" id="admMenuSetBtn" style="width: 150px; height: 80px;">관리자 메뉴정의</button>
				<button type="button" id="menuSetBtn" style="width: 150px; height: 80px;">사용자 메뉴정의</button>
            </li>
            <li>
                <button type="button" id="admScrnSetBtn" style="width: 150px; height: 80px;">관리자 화면정의</button>
				<button type="button" id="scrnSetBtn" style="width: 150px; height: 80px;">사용자 화면정의</button>
            </li>
            <li>
                <button type="button" id="adminViewBtn" style="width: 150px; height: 80px;">관리자 화면이동</button>
                <button type="button" id="userViewBtn" style="width: 150px; height: 80px;">사용자 화면이동</button>
            </li>
        </ul>
    </div>
    <div class="demo-section k-content">
    	<table class="tbl_type01">
    		<colgroup>
	    		<col width="30%">
	    		<col width="70%">
    		</colgroup>
    		<tbody>
                    <tr>
                        <th>DB</th>
<%--                         <td>${db_url}</td> --%>
                    </tr>
                    <tr>
                        <th>DB_USERNAME</th>
<%--                         <td>${db_username}</td> --%>
                    </tr>
                    <tr>
                        <th>DB_PASSWORD</th>
<%--                         <td>${db_password}</td> --%>
                    </tr>
            </tbody>
    	</table>
    </div>
</div>

<div id="dialog_dev_login"></div>
</body>
</html>