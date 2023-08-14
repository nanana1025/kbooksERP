<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>TREE LIST TEST PAGE</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<meta charset="utf-8"/>
	<link rel="stylesheet" type="text/css" href="codebase/css/examples-offline.css"/>
	<link rel="stylesheet" type="text/css" href="codebase/kendo/css/kendo.common.min.css"/>
	<link rel="stylesheet" type="text/css" href="codebase/css/kendo.custom.css"/>

	<script src="js/jquery-3.3.1.js"></script>
	<script src="codebase/kendo/kendo.all.min.js"></script>
	<script src="codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
    <script>
        var TREELIST = {
            fnGrid : function () {
                $('#treeList').kendoTreeList({
                    dataSource: {
                        transport: {
                            read: {
                                url: "<c:url value='/treeListTest.json'/>",
                                dataType: "json"
                            }
                        },
                        schema: {
                            model : {
                                id : "exewbsid",
                                parentId : "upprwbsid",
                                fields : {
                                    upprwbsid : { field: "upprwbsid", nullable: true }
                                },
                                expanded : true
                            }
                        }
                    },
                    columns: [
                        { field: "wbsnm" },
                        { field: "prcrnm" },
                        { field: "takedays" },
                        { field: "planstrtdt" },
                        { field: "planenddt" },
                        { field: "plancmntuowt" }
                    ],
                    sortable: true,
                    scrollable: true,
                    selectable: "row"
                });

                $("#treeList").on("dblclick", "tr.k-state-selected", function() {
                    top.paramSend('test');
                });
            },


            // kendo grid 용 resize grid
            resizeGrid : function() {console.log('resize grid');
                var gridElement = $("#treeList"),
                    dataArea = gridElement.find(".k-grid-content").first(),
                    otherElements = gridElement.children().not(".k-grid-content"),
                    otherElementsHeight = 0;
                otherElements.each(function() {
                    otherElementsHeight += Math.ceil($(this).outerHeight());
                });
                var winHeight = $(window).height();
                var gridContentOffset =  $("#treeList .k-grid-header").offset().top;//그리드 헤더까지 상단 offset
                var contentHeight = winHeight - Math.ceil(gridContentOffset) - Math.ceil(otherElementsHeight); //그리드 데이터 영역 높이 계산
                dataArea.height(contentHeight-10);

            },

            reloadGrid : function() { console.log('reloadGrid');
                GochigoAlert('reload Grid');
            }
        };

        $(document).ready(function() {

            $(window).on("resize" , function() {
                TREELIST.resizeGrid();
            });
            TREELIST.fnGrid();

            TREELIST.resizeGrid();
        });


    </script>
</head>
<body>
<table>
    <tr>
        <td>
            <div id="treeList"></div>
        </td>
    </tr>
</table>

</body>
</html>