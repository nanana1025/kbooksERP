<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Index</title>
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
    <script>
	    var _systemName = '${sysInfo.SYSTEM_NM}';	
	    var _xmlOwner = '${xmlOwner}';
   		var _xmlFolder = '${xmlFolder}';

        $(document).ready(function() {
           $("#xmlType").kendoDropDownList({
        	   select: function(e) {
        		   var item = e.item;
        		   if(item.text() == 'LIST'){
        			   $('#xn').val('');
        			   $('#xn').val($('#xn').val()+"_LIST.xml");
        		   } else if(item.text() == 'DATA') {
        			   $('#xn').val('');
        			   $('#xn').val($('#xn').val()+"_DATA.xml");
        		   } else if(item.text() == 'TREE') {
        			   $('#xn').val('');
        			   $('#xn').val($('#xn').val()+"_TREE.xml");
        		   } else if(item.text() == 'LAYOUT') {
        			   $('#xn').val('');
        			   $('#xn').val($('#xn').val()+"_LAYOUT.xml");
        		   }
        	   }
           });
           $('#xmlFolder').val(_xmlFolder);

           $("#previewBtn").hide();

           $("#saveBtn").click(function() {
               onClickSave();
           });

           $("#listBtn").click(function() {
        	   if(_xmlOwner == "ADMIN"){
	               location.href = "/system/admScrnXmlSet.do";
        	   } else {
	               location.href = "/system/scrnXmlSet.do";
        	   }
           });

           $("#previewBtn").click(function() {
               var xn = $("#xn").val();
               xn = xn.substring(0, xn.indexOf("."));
               if(xn == "") {
                   GochigoAlert('저장된 xml파일이 없습니다.');
                   return;
               }
               var previewUrl = getUrlByScrnType($("#xmlType").val());
               fnPreview(previewUrl+"?xn="+xn+"&mode=layout");
               // $.ajax({
               //     url : "/dataList.do?sid=WBS",
               //     success : function(hml) {
               //         $("#previewArea").html(hml);
               //     }
               // });
           });

           function fnPreview(url) {
               $.ajax({
                   url : url,
                   success : function(hml) {
                       $("#previewArea").html(hml);
                       fnMask();
                   }
               });
           }
        });

        function onClickSave() {
            var $xmlType = $("#xmlType");
            var $xmlStr = $("#xmlStr");
            var $xmlFolder = $("#xmlFolder");
            var $xn = $("#xn");

            if(!$xmlType.val()) {
                GochigoAlert('XML 유형을 입력해주세요.');
                $xmlType.focus();
                return;
            }

            if(!$xmlStr.val()) {
                GochigoAlert('XML TEXT를 입력해주세요.');
                $xmlStr.focus();
                return;
            }


            var xmlString = $xmlStr.val();

            if(!$xmlFolder.val()) {
                GochigoAlert('XML 폴더명이 없습니다.');
                return;
            }
            if(!$xn.val()) {
                GochigoAlert('XML 파일명이 없습니다.');
                return;
            }


            var _param = {
                xmlType : $("#xmlType").val(),
                xmlStr : $("#xmlStr").val(),
                xmlFolder : $("#xmlFolder").val(),
                xn : $("#xn").val(),
                xmlOwner : _xmlOwner
            };

            $.ajax({
                url: "<c:url value='/system/saveXml.json'/>",
                type: "POST",
                data : _param,
                success: function(rtnObj) {
                    if (rtnObj != null) {
                    	if(rtnObj.message){
	                        GochigoAlert(rtnObj.message);
                    	}
                        GochigoAlert('저장이 완료되었습니다.');
//                         $("#previewBtn").show();
                        // fnPreview("/dataView.do?sid="+_sid)
                    } else {
                        GochigoAlert('에러가 발생했습니다 잠시후 다시 시도해주세요');
                    }
                },
                error : function(err) {
                    GochigoAlert(err.responseJSON.message);
                }

            });
        }

        function getUrlByScrnType(type) {
            var rtnUrl = '';
            switch(type){
                case "LIST" : rtnUrl = "/dataList.do";   break;
                case "DATA" : rtnUrl = "/dataView.do";   break;
                case "TAB"  : rtnUrl = "/tab.do";        break;
                case "TREE" : rtnUrl = "/tree.do";       break;
                case "LAYOUT" : rtnUrl = "/layout.do";   break;
            }
            return rtnUrl;
        }

        function fnMask() {
            var maskWidth = $("#previewArea").width();
            var maskHeight = $("#previewArea").height();
            var maskTop = $("#previewArea").offset().top;
            var maskLeft = $("#previewArea").offset().left;

            $("#mask").css({
                "width"		:maskWidth,
                "height"	:maskHeight,
                "top"		:maskTop,
                "left"		:maskLeft,
                "text-align":"center",
                "font-size" : "2em"
            });

            $("#mask").fadeIn(500);
            // $("#mask").fadeTo("slow", 0.8);
        }
        $(window).resize(function() {
            fnMask();
        });

        $(document).keydown(function(event) {
            //ctrl + s : save
            if((event.ctrlKey || event.metaKey) && event.which == 83) {
                // Save Function
                event.preventDefault();
                onClickSave();
                return false;
            }
        });
    </script>
</head>
<body>
<div class="header_title">
    <h1>화면 XML 등록</h1>
</div>
<div class="demo-section wide k-content">
<div class="fl w40p">
    <table class="tbl_type01">
        <thead>
            <tr><th>XML등록</th></tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <ul class="fieldlist2">
                        <li>
                            <label for="xmlType">Xml유형</label>
                            <select id="xmlType" name="xmlType" style="width: 85%;float:right;" >
                                <option value="">선택</option>
                                <option value="LIST">LIST</option>
                                <option value="DATA">DATA</option>
                                <option value="TREE">TREE</option>
                                <option value="LAYOUT">LAYOUT</option>
                            </select>
                        </li>
                        <li>
                            <label for="xmlFolder">XML폴더명</label>
                            <input id="xmlFolder" name="xmlFolder" type="text" class="k-textbox" style="width: 85%;float:right;background:#dedee0;" disabled="disabled"/>
                        </li>
                        <li>
                            <label for="xmlName">XML파일명</label>
                            <input id="xn" name="xn" type="text" class="k-textbox" style="width: 85%;float:right;"/>
                        </li>
                        <li>
                            <label for="xmlStr">XML TEXT</label>
                            <textarea id="xmlStr" name="xmlStr" class="k-textbox" style="width: 100%;"  rows="30" ></textarea>
                        </li>
                        <li style="text-align: center;">
                            <button class="k-button k-primary" id="saveBtn">SAVE</button>
                            <button class="k-button" id="previewBtn">미리보기</button>
                            <button class="k-button" id="listBtn">BACK</button>
                        </li>
                    </ul>
                </td>
            </tr>
        </tbody>
    </table>
</div>
<div class="fl w60p">
    <table class="tbl_type01">
        <thead>
            <tr>
                <th>미리보기</th>
            </tr>
        </thead>
    </table>
    <table>
        <tr><td><div id="previewArea" style="width: 100%; height: 100%; border:1px solid #ebebeb;"></div></td></tr>
    </table>
</div>
</div>
<div id="mask" class="mask"></div>
</body>
</html>