<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Menu XML설정</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta charset="utf-8"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>

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
		.header_title > h1 {
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
            padding-bottom: 2em;
        }

        .fieldlist label {
            display: block;
            padding-bottom: 1em;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 12px;
            color: #444;
        }

        .k-textbox {
             width: 100%;
         }

        .tbl_type01 {border:1px solid #ebebeb;width:100%;}
        .tbl_type01 th{height:35px;background:#f2f5f7;border:1px solid #ebebeb;text-align:center;color:#222;}
        .tbl_type01 td{padding:10px 5px;border:1px solid #ebebeb;vertical-align:top;text-align:left;}
	</style>
    <script>
    var _systemName = '${sysInfo.SYSTEM_NM}';
    var confirm;

        $(document).ready(function() {

            $("#btn-xml-save").click(function() {
            	GochigoConfirm('메뉴를 변경하면 서버가 재시작됩니다. 저장 후 F5를 눌러 새로고침 하십시오.');
            	//afterConfirm 호출
            });

            $("#btn-xml-list").click(function() {
                location.reload();
            })

            $("#preViewBtn").click(function() {
                location.href = "/system/menuPreview.do?sid="+$("#systemId").val()+"&OWNER=ADMIN";
            });

            $("#btn-xml-back").click(function() {
                location.href = "/systemSel.do";
            });
        });

        $(document).keydown(function(event) {
            //ctrl + s : save
            if((event.ctrlKey || event.metaKey) && event.which == 83) {
                // Save Function
                event.preventDefault();
                $("#btn-xml-save").click();
                return false;
            }
        });

        function afterConfirm() {
        	var $xmlType = $("#xmlType");
            var $xmlStr = $("#xmlStr");

            if(!$xmlStr.val()) {
                GochigoAlert('XML TEXT를 입력해주세요.');
                $xmlStr.focus();
                return;
            }

            var _param = {
                systemId : $("#systemId").val(),
                xmlType  : $xmlType.val(),
                xmlStr   : $xmlStr.val(),
                owner    : 'ADMIN'
            };

            $.ajax({
                url: "<c:url value='/system/saveMenuXml.json'/>",
                type: "POST",
                data : _param,
                success: function(rtnObj) {
                    if (rtnObj.success) {
                        location.reload();
                    } else {
                        GochigoAlert('에러가 발생했습니다 잠시후 다시 시도해주세요');
                    }
                },
                error : function(err) {
                    GochigoAlert(err.responseJSON.message);
                }

            });
        }
    </script>
</head>
<body>
<div class=" k-content">
	<div class="header_title">
		<h1>메뉴 XML 설정</h1>
	</div>
	<div>
        <input type="hidden" id="xmlType" value="MENU">
        <input type="hidden" id="systemId" value="${systemId}">
        <table id="xmlTbl" class="tbl_type01">
            <colgroup>
                <col width="10%">
                <col width="90%">
            </colgroup>
            <thead>
                <tr>
                    <th>시스템ID</th>
                    <td>${systemId}</td>
                </tr>
                <tr>
                    <th>시스템명</th>
                    <td>${systemName}</td>
                </tr>
            </thead>
            <tbody>
                <%--<tr>--%>
                    <%--<th>--%>
                        <%--<label for="xmlName">메뉴ID</label>--%>
                    <%--</th>--%>
                    <%--<td>--%>
                        <%--<input type="text" id="xmlName" name="xmlName" class="k-textbox" placeholder="메뉴ID입력" style="ime-mode:disabled; width: 50%;" value="${xmlName}">--%>
                        <%--<button type="button" class="k-button" id="preViewBtn">미리보기</button>--%>
                    <%--</td>--%>
                <%--</tr>--%>
                <tr>
                    <th><label for="xmlStr">XML TEXT</label></th>
                    <td><textarea class="k-textbox" id="xmlStr" name="xmlStr" rows="30" placeholder="xml 문자열 입력">${xmlStr}</textarea></td>
                </tr>
            </tbody>
        </table>
    </div>
    <div style="text-align: center;">
        <button class="k-button k-primary" id="btn-xml-save">SAVE</button>&nbsp;
        <button class="k-button" id="btn-xml-list">CANCEL</button>
        <button class="k-button" id="preViewBtn">미리보기</button>
        <button class="k-button" id="btn-xml-back">BACK</button>
	</div>
</div>
</body>
</html>