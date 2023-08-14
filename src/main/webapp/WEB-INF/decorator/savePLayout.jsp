<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

        setTimeout(function(){
	        $('.grid_btns button').remove();
	        $('.header_title').remove();
	        $('#scrnArea').css('top', '0px');
// 	        setButton();
        }, 200);
	});

// 	function setButton() {
// 		var html = '<div id="popup_btns" style="text-align:center; margin-top:8px;">'+
// 					   	 '<button id="saveBtn" class="k-button">저장</button>'+
// 					     '<button id="closeBtn" class="k-button">취소</button>'+
// 					'</div>';
// 		var btnDiv = $('.grid_btns');
// 		if(btnDiv.length > 0){
// 			$('.grid_btns').append(html);
// 		} else {
// 			$('.searchBlock').after(html);
// 		}

// 		$('#saveBtn').kendoButton();
// 		var saveBtn = $('#saveBtn').data('kendoButton');
//         saveBtn.bind('click', function(e) {
//         	fnObj('CRUD_${crudid}').onClickSave();
//         });
//         $('#closeBtn').kendoButton();
//         var closeBtn = $('#closeBtn').data('kendoButton');
//         closeBtn.bind('click', function(e) {
//         	self.close();
//         });
// 	}
</script>
<meta charset="UTF-8">
<title><sitemesh:write property='title' /></title>
<sitemesh:write property='head'/>
</head>
<body>
<sitemesh:write property='body'/>

</body>
</html>