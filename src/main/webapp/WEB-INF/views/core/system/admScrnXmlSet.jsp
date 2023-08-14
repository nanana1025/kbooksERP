<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>관리자 화면 XML설정</title>
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
		.folderClass {
			background-color : #ffffb3;
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
            $('#folderAddBtn').kendoButton();
            var folderAddBtn = $('#folderAddBtn').data('kendoButton');
            folderAddBtn.bind('click', function(e) {
                doFolderAdd();
            });

            var homeBtn = $('#homeBtn').kendoButton();
            homeBtn.bind('click', function(e) {
                location.href = "/systemSel.do";
            });

        });

        function gridbox(){
        	var xPos  = (document.body.clientWidth /2) - (800 / 2);
            xPos += window.screenLeft;
            var yPos  = (screen.availHeight / 2) - (600 / 2);
            
            var dataSource = new kendo.data.TreeListDataSource({
                transport: {
                    read: {
                    	 url: "/system/xmlList.json?xmlOwner=ADMIN",
                         dataType: "json"
                    }
                },
                schema: {
                    model: {  
                    	id: "id",
                        expanded : true
                    }
                }
            });
            
            $('#gridbox').kendoTreeList({
                dataSource: dataSource,
                sortable: true,
//                 pageable: true,
                scrollable: true,
                selectable: "row",
                filterable : {
                	extra: false,
                	operators: {
                		string: {
                			contains: "~를 포함",
                			startswith: "~로 시작",
                			eq: "~와 동일한",
                			neq: "~와 다른"
                		},
                		number: {
                			eq: "=",
                			neq: "!=",
                			isnull: "값이 없는",
                			isnotnull: "값이 있는",
                			gte: ">=",
                			lte: "<="
                		},
                		date: {
                			eq: "=",
                			gte: ">=",
                			lte: "<="
                		}
                	},
                	messages: {
                		and: "그리고",
                		clear: "제거",
                		filter: "필터",
                		info: "입력한 조건의 항목을 보여줍니다.",
                		or: "또는"
                	}
                },
                dataBound: function(e) {
                	$('table[role="treegrid"] tr').removeClass('k-alt');
                	$('table[role="treegrid"] td:contains("ROOT")').closest('tr').addClass("folderClass");
                    $('table[role="treegrid"] td:contains("FOLDER")').closest('tr').addClass("folderClass");
                },
                columns: [
                	 {
                         field: "XML_FILE_NM",
                         title: "파일명",
                         template: "# if (SCRN_TYPE == 'ROOT' || SCRN_TYPE == 'FOLDER') { #" +
                     	"<span class='k-icon k-i-folder'></span>#:XML_FILE_NM#" +
                     	"# } else if (SCRN_TYPE == 'LAYOUT') { #" +
                     	"<span class='k-icon k-i-file-ascx'></span>#:XML_FILE_NM#" +
                     	"# } else { #" +
                     	"<span class='k-icon k-i-file'></span>#:XML_FILE_NM#" +
                     	"# } #"
                     },
                     {
                         field: "SCRN_TYPE",
                         title: "화면분류"
                     },
                     {
                         field: "XML_FOLDER",
                         title: "상위폴더명"
                     },
                     {
                         field: "XN",
                         title: "XN",
                         hidden: true
                     },
                     {
                         field: "LINK",
                         title: "LINK",
                         template: "# if (LINK == null) { #" +
                         "<span data-content=' '></span>" +
                         "# } else { #" +
                         "<a href='#:LINK#' onclick='window.open(this.href, \"linkPop\", \"top="+xPos+", left="+yPos+", width=1200, height=800\"); return false;' target='_blank'>" +
                         "<span class='k-icon k-i-search'></span>View</a>" +
                         "# } #",
                         attributes: {
                             style: "text-align:center;"
                         }
                     }
                   
                ]
            });
            
            $("#gridbox").on("click", "tr.folderClass", function(e) {
            	$(e.currentTarget).removeClass('folderClass');
            });
            
            $("#gridbox").on("click", "tr:not(.folderClass)", function(e) {
            	$('table[role="treegrid"] td:contains("ROOT")').closest('tr').addClass("folderClass");
                $('table[role="treegrid"] td:contains("FOLDER")').closest('tr').addClass("folderClass");
            });
        }

        function doOnFormInit(name) {
            if (name == 'addXml') {
            	 var grid = $('#gridbox').data('kendoTreeList');
                 var selectedItem = grid.dataItem(grid.select());
                 if(grid.select().length == 0) {
                     GochigoAlert('최상위 폴더나 하위 폴더를 선택해야 합니다.');
                     return;
                 }
                 var _xmlTp = selectedItem.SCRN_TYPE;
                 var _xmlFolder = selectedItem.XML_FOLDER;
                 var _xmlNm = selectedItem.XML_FILE_NM;
                 var folder = _xmlFolder + _xmlNm + "/";
            	if(_xmlTp != "ROOT" && _xmlTp != "FOLDER"){
                	GochigoAlert("최상위 폴더나 하위 폴더를 선택해야 합니다.");
                	return;
                }
                location.href = '<c:url value="/system/xmlSave.do?owner=ADMIN&xmlFolder="/>'+folder;
            } else if(name == 'delXml') {
                var grid = $('#gridbox').data('kendoTreeList');
                var selectedItem = grid.dataItem(grid.select());
                if(grid.select().length == 0) {
                    GochigoAlert('선택된 항목이 없습니다.');
                    return;
                }
//                 var _xmlNm = selectedItem.SID;
                var _xmlTp = selectedItem.SCRN_TYPE;
                var _xn = selectedItem.XN;
                $.ajax({
                	url:"<c:url value='/system/deleteXml.json'/>",
                    data:{xn:_xn, xmlTp: _xmlTp, xmlOwner: 'ADMIN'},
                    success: function(data,status) {
                        if(data.success){
                            GochigoAlert('삭제되었습니다.');
                            reloadGrid();
                        } else {
                            GochigoAlert('삭제에 실패했습니다.');
                            return;
                        }
                    }
                });
            } else if(name == 'editXml') {
                var grid = $('#gridbox').data('kendoTreeList');
                var selectedItem = grid.dataItem(grid.select());
                if(selectedItem == null) {
                    GochigoAlert('선택된 항목이 없습니다.');
                    return;
                }
//              var _sid = selectedItem.SID;
                var _scrnTp = selectedItem.SCRN_TYPE;
				var _xn = selectedItem.XML_FILE_NM;
				if(_scrnTp == "ROOT" || _scrnTp == "FOLDER"){
					GochigoAlert("폴더는 수정할 수 없습니다.");
					return;
				}
                location.href = "<c:url value='/system/xmlEdit.do'/>" + "?xn=" + _xn+"&xmlTp="+_scrnTp+"&owner=ADMIN";
            }
        }
        
        function doFolderAdd(){
       	 	var grid = $('#gridbox').data('kendoTreeList');
            var selectedItem = grid.dataItem(grid.select());
            var folderNm;
            if(selectedItem) {
	            if(selectedItem.SCRN_TYPE != "FOLDER" && selectedItem.SCRN_TYPE != "ROOT"){
	            	GochigoAlert("최상위 폴더나 폴더를 선택해야 합니다.");
	            	return;
	            }
            	var _xmlFolder = selectedItem.XML_FOLDER;
                var _xmlNm = selectedItem.XML_FILE_NM;
                folderNm = _xmlFolder + _xmlNm + "/";
            } else {
            	folderNm = '/adminXml/';
            }
            var xPos  = (document.body.clientWidth /2) - (800 / 2);
            xPos += window.screenLeft;
            var yPos  = (screen.availHeight / 2) - (600 / 2);
            window.open("/system/xmlFolderAdd.do?folderNm="+folderNm, "linkPop", "top="+yPos+", left="+xPos+", width=600, height=150");
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
        
        function reloadGrid() {
        	var grid = $('#gridbox').data('kendoTreeList');
        	grid.dataSource.read();
        }
    </script>
</head>
<body>
<div class=" k-content">
	<div class="header_title">
		<h1>화면 XML 설정</h1>
	</div>
	<div>
		<table width="100%">
			<tr>
				<td>
					<div style="float:right;">
						<button id="folderAddBtn">폴더생성</button>
						<button id="editBtn">EDIT</button>
						<button id="addBtn">ADD</button>
						<button id="delBtn">DEL</button>
						<button id="homeBtn">BACK</button>
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
</div>
</body>
</html>