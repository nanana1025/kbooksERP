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
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>

	<style>
		#gridBox > table {
			table-layout: fixed;
		}
	</style>
	<script>
		var _systemName = '${sysInfo.SYSTEM_NM}';
		
        $(document).ready(function() {

            $(window).on("resize" , function() {
                resizeGrid();
            });
            gridbox();
            resizeGrid();

            $('#addBtn').kendoButton();
            var addBtn = $('#addBtn').data('kendoButton');
            addBtn.bind('click', function(e) {
                doOnFormInit("addXml");
            });
            $('#delBtn').kendoButton();
            var delBtn = $('#delBtn').data('kendoButton');
            delBtn.bind('click', function(e) {
                doOnFormInit("delXml");
            });
            $('#editBtn').kendoButton();
            var editBtn = $('#editBtn').data('kendoButton');
            editBtn.bind('click', function(e) {
                doOnFormInit("editXml");
            });

            var homeBtn = $('#homeBtn').kendoButton();
            homeBtn.bind('click', function(e) {
                location.href = "/";
        });

        });

        function gridbox(){
            $('#gridbox').kendoGrid({
                dataSource: {
                    transport: {
                        read: {
                            url: "/system/xmlList.json",
                            dataType: "json"
                        }
                    },
                    pageSize: 20,
                    serverPaging: false
                },
                sortable: true,
                pageable: true,
                scrollable: true,
                selectable: "row",
                columns: [
// 		        { selectable: true },
                    {
                        field: "SID",
                        title: "화면ID"
                    },
                    {
                        field: "SCRNTP",
                        title: "화면분류"
                    },
                    {
                        field: "XMLNAME",
                        title: "파일명"
                    },
                    {
                        field: "LINK",
                        title: "LINK",
                        template: "# if (LINK == null) { #" +
                        "<span data-content=' '></span>" +
                        "# } else { #" +
                        "<a href='#:LINK#'>LINK</a>" +
                        "# } #",
                        attributes: {
                            style: "text-align:center;"
                        }
                    }
                ]
            });
        }

        function doOnFormInit(name) {
            if (name == 'addXml') {
                location.href = '<c:url value="/system/xmlSave.do"/>';
            } else if(name == 'delXml') {
                var grid = $('#gridbox').data('kendoGrid');
                var selectedItem = grid.dataItem(grid.select());
                if(grid.select().length == 0) {
                    GochigoAlert('선택된 항목이 없습니다.');
                    return;
                }
                var _xmlNm = selectedItem.SID;
                var _xmlTp = selectedItem.SCRNTP;
                $.ajax({
                    url:"<c:url value='/system/deleteXml.json'/>",
                    data:{xmlName:_xmlNm, xmlType:_xmlTp},
                    success: function(data,status) {
                        if(data.success){
                            GochigoAlert('삭제되었습니다.');
                            gridbox();
                        } else {
                            GochigoAlert('삭제에 실패했습니다.');
                            return;
                        }
                    }
                });
            } else if(name == 'editXml') {
                var grid = $('#gridbox').data('kendoGrid');
                var selectedItem = grid.dataItem(grid.select());
                if(selectedItem == null) {
                    GochigoAlert('선택된 항목이 없습니다.');
                    return;
                }
                var xmlId = selectedItem.XMLNAME;
                location.href = "<c:url value='/system/xmlEdit.do'/>" + "?XML_ID=" + xmlId;
            }
        }

        // kendo grid 용 resize grid
        function resizeGrid() {
            var gridElement = $("#gridbox"),
                dataArea = gridElement.find(".k-grid-content").first(),
                otherElements = gridElement.children().not(".k-grid-content"),
                otherElementsHeight = 0;
            otherElements.each(function() {
                otherElementsHeight += Math.ceil($(this).outerHeight());
            });
            var winHeight = $(window).height();
            var gridContentOffset =  $("#gridbox .k-grid-header").offset().top;//그리드 헤더까지 상단 offset
            var contentHeight = winHeight - Math.ceil(gridContentOffset) - Math.ceil(otherElementsHeight); //그리드 데이터 영역 높이 계산

            dataArea.height(contentHeight - 10);

        }
	</script>
</head>
<body>
<div class="header_title">
	<h1>화면 XML 정의</h1>
</div>
<div class="demo-section wide k-content">
<table width="100%">
	<tr>
		<td>
			<div style="float:right;">
				<button id="editBtn">EDIT</button>
				<button id="addBtn">ADD</button>
				<button id="delBtn">DEL</button>
				<button id="homeBtn">HOME</button>
			</div>
		</td>
	</tr>
	<tr>
		<td>
			<div id="gridbox" style="width:100%; height:100%;"></div>
		</td>
	</tr>
</table>
</div>
</body>
</html>
