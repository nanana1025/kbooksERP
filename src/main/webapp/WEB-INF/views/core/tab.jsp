<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${param.mode !='layout'}">
<!DOCTYPE html>
<html>
<title>${title}</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta charset="utf-8"/>

<link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
<link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
<link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

<script src="/js/jquery-1.12.4.js"></script>
<script src="/codebase/kendo/kendo.all.min.js"></script>
<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
<script src="/codebase/common.js"></script>
</c:if>
<style>
	#tabstrip .k-content{
		overflow: hidden;
	}
</style>
    <script>
	    window['TAB_${tabid}'] = {
	        tabs : "", 
	        
	        fnInitTab : function(){
	        	
	        	fnObj('TAB_${tabid}').tabs = $("#tabstrip").kendoTabStrip({
	                animation: false,
					dataTextField: "title",
					dataContentUrlField: "url",
				    dataSource: JSON.parse('${tabDataSource}'),
				    activate: fnObj('TAB_${tabid}').onActivate,
				    select: fnObj('TAB_${tabid}').onSelect,
	            }).data('kendoTabStrip');
	        	
	        	var tabs = $('#tabstrip .k-item');
	        	$.each(tabs, function(idx, tab){
	        		if(idx != 0){
	        			fnObj('TAB_${tabid}').tabs.reload(tab);
	        		}
	        	});
	        	
	        	fnObj('TAB_${tabid}').tabs.select($("#tabstrip li:first"));
	        },

            resizeTab : function() {
	            var _jsonStr = '${scenes}';
	            var _selTab = fnObj('TAB_${tabid}').tabs.select();
	            var _selIdx = $(_selTab).index();
	            var _scenesJson = $.parseJSON(_jsonStr);

	            //tab영역 resize
	            var tabElement = $("#tabstrip"),
	            	dataArea = tabElement.find(".k-content"),
	            	otherElements = tabElement.children().not(".k-content"),
	            	otherElementsHeight = 0;
	                otherElements.each(function () {
	                    otherElementsHeight += Math.ceil($(this).outerHeight());
	                });
	            var winHeight = $(window).height() -55; //푸터영역 55
	            var tabLiOffset = $("#tabstrip .k-tabstrip-items").offset().top;//그리드 헤더까지 상단 offset
	            var contentHeight = 0;
	            
	            contentHeight = winHeight - Math.ceil(tabLiOffset) - Math.ceil(otherElementsHeight); //그리드 데이터 영역 높이 계산
                dataArea.height(contentHeight);
	            
                $.each(_scenesJson, function(i,o) {
                    if(o.type == 'LIST' && i == _selIdx) {
                        var sceneId = 'LIST_'+o.id;
                        fnObj(sceneId).resizeGrid();
                    } else if(o.type == 'DATA' && i == _selIdx){
                        var sceneId = 'frm_'+o.id;
		                $("#"+sceneId).find(kendo.roleSelector("editor")).kendoEditor("refresh");
                    }
                });

            },
            
            onActivate : function(e) {
            	var tab = fnObj('TAB_${tabid}').tabs;
            	var select = tab.select();
            	var selectedIndex = select.index();
            	var pid;
            	if(selectedIndex >= 0){
	            	var tabSource = JSON.parse('${tabDataSource}');
	            	pid = tabSource[selectedIndex].pid;
            	}
            	var ptype = tabSource[selectedIndex].ptype;
            	if(ptype == "TREE"){
            		if(fnObj('TREE_'+pid)){
            			fnObj('TREE_'+pid).reselectTree();
            		}
            	} else if(ptype == "LIST"){
            		if(fnObj('LIST_'+pid)){
            			fnObj('LIST_'+pid).onChange();
            		}
            	}
            	TAB_${tabid}.resizeTab();
            },
            
            onSelect : function(e) {
            	var tab = fnObj('TAB_${tabid}').tabs;
            	var select = tab.select();
            	var selectedIndex = select.index();
            	var pid;
            	if(selectedIndex >= 0){
	            	var tabSource = JSON.parse('${tabDataSource}');
	            	pid = tabSource[selectedIndex].pid;
            	}
            	if(!pid){
            		tab.reload($(e.item));
            	}
            }
	    }

        $(document).ready(function() {
            $(window).on("resize" , function() {
            	TAB_${tabid}.resizeTab();
            });
            fnObj('TAB_${tabid}').fnInitTab();
        });
    </script>
<c:if test="${param.mode!='layout'}">
</head>
<body>
</c:if>
<div id="tabstrip"></div>
<c:if test="${param.mode!='layout'}">
</body>
</html>
</c:if>