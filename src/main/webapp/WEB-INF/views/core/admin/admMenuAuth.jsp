<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${param.mode!='layout'}">
<!DOCTYPE html>
<html>
<title>${title}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta charset="utf-8"/>

    <link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

    <script src="/js/jquery-3.3.1.js"></script>
    <script src="/codebase/kendo/kendo.all.min.js"></script>
    <script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
</c:if>
    <style>
    </style>
    <body class="k-content">
<form id="frm">
<div class="header_title">
    <span class="pagetitle"><span class="k-icon k-i-grid-layout"></span> 권한 별 메뉴 설정</span>
</div>
<div style="padding:20px 20px 20px 20px;">
    <label for="authId">역할 : </label>
    <input id="authId" name="authId">

    <div style="float:right; text-align: center; padding:20px 10px 0px 20px">
        <button id="saveBtn">저장</button>
        <button id="backBtn">취소</button>
    </div>
</div>
<div id="gridHml" style="float:right; width:100%;">
    <div id="menuAuthTblDiv"  class="body-content" style="width: 100%; height:100%; text-align: center;">
        ${menuTbl}
    </div>
</div>
</form>

</body>
    <script>
    $(document).ready(function() {
        $("#saveBtn").kendoButton({icon:"edit"});
        $("#saveBtn").click(function(e) {
            e.preventDefault();
            onClickSaveBtn();
        });
        $("#backBtn").kendoButton({icon:"close"});
        $("#backBtn").click(function(e) {
            e.preventDefault();
            location.href = "/admin/layout.do?sid=MAIN";
        });

        $("#authId").kendoDropDownList({
            dataTextField : "AUTH_NM",
            dataValueField : "AUTH_ID",
            dataSource : ${authList},
            change: fnTblLoad
        });

        fnTblLoad();
    });

    $(window).on("resize", function() {
    	resizeTable();
    });

    function resizeTable() {
    	var winH = $(window).height();
        var winW = $(window).width();
    	var tblOffset = $("#menuAuthTblDiv").offset().top;

    	var tblH = winH - tblOffset - 30;
    	$("#menuAuthTblDiv").css("height",tblH+"px");
        $("#menuAuthTblDiv").css("width",winW-20+"px");
    }

    function fnTblLoad() {
        var _auth = $("#authId").val();

        $.ajax({
            url : '/admin/getMenuAuth.json',
            data : {authId:_auth},
            dataType : "html",
            success : function(data) {
                if(data) {
                    $("#menuAuthTblDiv").html('');
                    $("#menuAuthTblDiv").html(data);
                    $("#menuAuthTblDiv").css("overflow","auto");

                    resizeTable();

                    $("#readAll").change(function(e) {
                        var chkStatus = this.checked;
                        $("input[type='checkbox']").each(function() {
                            if(this.id.indexOf('read_chk')>-1) {
                                this.checked = chkStatus;
                            }
                        });
                    });

                    $("#crudAll").change(function(e) {
                        var chkStatus = this.checked;
                        $("input[type='checkbox']").each(function() {
                            if(this.id.indexOf('crud_chk')>-1) {
                                this.checked = chkStatus;
                            }
                        });
                        $("input[type='checkbox']").each(function() {
                            if(this.id.indexOf('read_chk')>-1) {
                                this.checked = chkStatus;
                            }
                        });
                    });

                    $("input[type='checkbox']").change(function(e) {
                        var _id = this.id;
                        var chkStatus = this.checked;
                        if(_id.indexOf('crud_chk')>-1) {
                            var chkId = $(this).attr("id").replace("crud_chk","");
                            $("#read_chk"+chkId).attr("checked", chkStatus);
                        }
                    });
                }
            }
        });
    }

    function onClickSaveBtn() {
        var _auth = $("#authId").val();
        if(!_auth) {
        	GochigoAlert('사용자 권한이 선택되지 않았습니다.');
            $("#authId").parent().focus();
            return;
        }

        $("input[type='checkbox']").each(function(i,o) {
            var _id = this.id;
            var chkStatus = this.checked;
            if(_id.indexOf('crud_chk')>-1) {
                var chkId = $(this).attr("id").replace("crud_chk","");
                $("#crud"+chkId).val(chkStatus?"C":"");
            }
            if(_id.indexOf('read_chk')>-1) {
                var chkId = $(this).attr("id").replace("read_chk","");
                $("#read"+chkId).val(chkStatus?"R":"");
            }
        });

        $.ajax({
            url : '/admin/saveMenuAuth.json',
            data : $("#frm").serialize(),
            type : "POST",
            async : false,
            success : function(data) {
                if(data=='success') {
                    GochigoAlert('저장되었습니다.');
                } else {
                    GochigoAlert('ERROR !! 잠시 후 다시 시도해주세요');
                }
            }
        });
    }

    function fnGoMain(){
        location.href = "/admin/layout.do?sid=MAIN";
    }
    </script>
</html>
