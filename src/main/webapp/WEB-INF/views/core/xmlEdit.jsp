<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Index</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />

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
        var _xn = '${xn}';
        _xn = _xn.replace(".xml", "").replace(".XML", "");
        var _type = '${xmlTp}'.toUpperCase();
        var _xmlOwner = '${xmlOwner}';

		$(document).ready(function() {
        	$('#saveBtn').kendoButton();
        	var saveBtn = $('#saveBtn').data('kendoButton');
        	saveBtn.bind('click', function(e) {
        		onClickSave();
        	});

        	$('#cancelBtn').kendoButton();
        	var cancelBtn = $('#cancelBtn').data('kendoButton');
        	cancelBtn.bind('click', function(e) {
        		if(_xmlOwner == "ADMIN"){
	                location.href = "/system/admScrnXmlSet.do";
        		} else {
	                location.href = "/system/scrnXmlSet.do";
        		}
        	});

            $("#previewBtn").click(function() {
                var previewUrl = getUrlByScrnType(_type);
                if(!previewUrl){
                	GochigoAlert("xml 타입이 부적합합니다.");
                	return;
                }
                fnPreview(previewUrl+"?xn="+_xn);
            });
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

		function onClickSave() {
			
			$.ajax({
                url : "<c:url value='/system/editXml.json'/>",
                type : "post",
                data : {
                	xn : '${xn}',
                	xmlString : $('#XML_EDITOR').val(),
                	xmlOwner : _xmlOwner
                },
                success : function(data, status, xhr) {
                    if(status=='success') {
                        GochigoAlert('저장이 완료되었습니다.');
                    }
                    if(data.message) {
                        GochigoAlert(data.message);
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
                case "LIST" : rtnUrl = "/list.do";   break;
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
                // If Control or Command key is pressed and the S key is pressed
                // run save function. 83 is the key code for S.
                if((event.ctrlKey || event.metaKey) && event.which == 83) {
                    // Save Function
                    event.preventDefault();
                    onClickSave();
                    return false;
                }
            }
        );
    </script>
</head>
<div class="header_title">
	<h1>화면 XML 등록</h1>
</div>
<div class="demo-section wide k-content">
	<div class="fl w40p">
		<table class="tbl_type01">
			<thead>
			<tr><th>XML정보</th></tr>
			</thead>
			<tbody>
			<tr>
				<td>
					<ul class="fieldlist">
						<li>
							<label for="XML_ID">XML NAME</label>
							<input id="xn" type="text" class="k-textbox" style="width: 100%;" value="${xn}" readonly/>
						</li>
<!-- 						<li> -->
<!-- 							<label for="XML_TP">XML TYPE</label> -->
<%-- 							<input id="XML_TP" type="text" class="k-textbox" style="width: 100%;" value="${scrnTp}" readonly/> --%>
<!-- 						</li> -->
						<li>
							<label for="XML_EDITOR">XML EDITOR</label>
							<textarea id="XML_EDITOR" name="xmlStr" class="k-textbox" style="width: 100%;"  rows="30" >${xmlString}</textarea>
						</li>
						<li style="text-align: center;">
							<button  class="k-button k-primary" id="saveBtn">SAVE</button>
							<button class="k-button" id="cancelBtn">BACK</button>
							<button class="k-button" id="previewBtn">미리보기</button>
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
		<table style="width: 100%;height: 100%;">
			<tr><td><div id="previewArea" style="width: 100%; height: 664px; border:1px solid #ebebeb;"></div></td></tr>
		</table>
	</div>
</div>
<div id="mask" class="mask"></div>
</body>
</html>