<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<meta charset="utf-8"/>
    <link rel="stylesheet" type="text/css" href="/codebase/fonts/NotoSansKR/stylesheets/NotoSansKR-Hestia.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

    <script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="/codebase/kendo/jszip.min.js"></script>
    <script src="/codebase/common.js"></script>
    <script src="/codebase/default.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <style>
		#scrnArea {
			height: 100% !important;
		}
		#content {
			height: calc(100% - 22px);
		}
</style>
<script>
var menuMode = "vertical";

	$(document).ready(function() {
		 $('.grid_btns button').remove();
        setTimeout(function(){
	        $('.grid_btns button').remove();
	        $('#scrnArea').css('top', '0px');
	        setButton();
        }, 300);
	});

	function fnSelect() {
		var sid = area1_obj.sid;
		var grid = $('#'+sid+'_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		if(!selItem){
			GochigoAlert("선택된 행이 없습니다.");
			return;
		}
		<c:choose>
			<c:when test='${not empty callbackName}'>
				if(typeof opener.${callbackName} === "function") {
					opener.${callbackName}(selItem);
					self.close();
				}
			</c:when>
			<c:otherwise>
				opener.popupSelect(selItem);
				self.close();
			</c:otherwise>
		</c:choose>
	}

	function setButton() {
// 		var html = '<div id="popup_btns" style="text-align:right; margin-top:8px;">'+
// 					   	 '<button id="selectBtn" class="k-button" onclick="fnSelect()">선택</button>'+
// 					     '<button id="closeBtn" class="k-button" onclick="fnClose()">취소</button>'+
// 					'</div>';

		var html = '<div id="popup_btns" style="margin-top:8px;">'+
						'<button id="closeBtn" class="k-button" style="float:right;" onclick="fnClose()">취소</button>'+
					   	 '<button id="selectBtn" class="k-button" style="float:right;" onclick="fnSelect()">선택</button>'+
					'</div>';
		$('.grid_btns').append(html);

		$('#selectBtn').kendoButton();
        $('#closeBtn').kendoButton();
        var closeBtn = $('#closeBtn').data('kendoButton');
        closeBtn.bind('click', function(e) {
        	self.close();
        });
	}
</script>
<meta charset="UTF-8">
<title><sitemesh:write property='title' /></title>
<sitemesh:write property='head'/>
</head>
<body>
<div id="content">
	<div id="menuArea"></div>
	<sitemesh:write property='body'/>
</div>

</body>
</html>