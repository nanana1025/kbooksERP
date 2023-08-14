<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta charset="utf-8"/>
    <link rel="stylesheet" type="text/css" href="codebase/css/examples-offline.css"/>
    <link rel="stylesheet" type="text/css" href="codebase/kendo/css/kendo.common.min.css"/>
    <link rel="stylesheet" type="text/css" href="codebase/css/kendo.custom.css"/>

    <script src="js/jquery-3.3.1.js"></script>
    <script src="codebase/kendo/kendo.all.min.js"></script>
    <script src="codebase/kendo/jszip.min.js"></script>
    <script src="codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
    <script src="codebase/common.js"></script>
    <style>
    .k-dropdown-wrap {
        padding-bottom: 1px;
    }
    .period-wrapper {
        display: inline-block;
        vertical-align: center;
    }
    </style>
    <script>
    
	    $(document).ready(function() {
            $(window).on("resize" , function() {
                TREE_${trid}.resizeTree();
            });
	    	TREE_${trid}.fnInitTree();
            TREE_${trid}.resizeTree();
	    });

	    var TREE_${trid} = {
	        tree : "", 
	        
	        fnInitTree : function(){
	        	
				var treeDataSource;
			
	        	$.ajax({
					url : "/treeLoad.json",
					type : 'POST',
					data:{trid:"${sid}"},
					dataType: 'json',
					async:false,
					success: function(data) {
						if(data){
							treeDataSource = data;
						}else{
							GochigoAlert("tree item load fail");
						}
					}
				});
	        	
	       		$("#tree").kendoTreeView({
	          		  dataSource: treeDataSource,
	          		  dataTextField: "${textcol}",
	          		  select:function(e){
	          			var selectedtreenode = e.node;
	    	       		var dataItem = TREE_${trid}.tree.dataItem(selectedtreenode);
	    	       		
	    	       		var sttobjectids = "${ttobjectids}";
	    	       		var ttobjectids = [];
	    	       		ttobjectids = sttobjectids.split(',');
	    	       	  
	    	       		var sltobjectids = "${ltobjectids}";
	    	       		var ltobjectids = [];
	    	       		ltobjectids = sltobjectids.split(',');
	    	       		
	    	       		for(var i = 0; i < ltobjectids.length; i++){
	    	       			if(ltobjectids[i] != null && ltobjectids[i] != '' && ttobjectids[i] != null && ttobjectids[i] != ''){
	    	       				var val = ttobjectids[i];
	    	       				$('#'+ltobjectids[i]).val(dataItem[val]);
	    	       			}
	    	       		}
	    	       		
	    	       		LIST_${sid}.reloadGrid();
	          		  }
	          		});	
	       		
	       		TREE_${trid}.tree = $("#tree").data("kendoTreeView");
// 	       		TREE_${trid}.tree.bind('select',fnTreeSelect);
	        	
	        },

            resizeTree : function() {
	            var $tree = $("#tree");
                var winHeight = $(window).height();
                var treeContentOffset =  $tree.offset().top;
                var contentHeight = winHeight - Math.ceil(treeContentOffset); //그리드 데이터 영역 높이 계산


                $("#tree").height(contentHeight - 20);
            }
	        
// 	        fnTreeSelect : function(e){
// 	       		var selectedtreenode = e.node;
// 	       		var dataItem = TREE_${sid}.tree.dataItem(selectedtreenode);
	       		
// 	       		var sttobjectids = "${ttobjectids}";
// 	       		var ttobjectids = [];
// 	       		ttobjectids = sttobjectids.split(',');
	       	  
// 	       		var sltobjectids = "${ltobjectids}";
// 	       		var ltobjectids = [];
// 	       		ltobjectids = sltobjectids.split(',');
	       		
// 	       		for(var i = 0; i < ltobjectids.length; i++){
// 	       			if(ltobjectids[i] != null && ltobjectids[i] != '' && ttobjectids[i] != null && ttobjectids[i] != ''){
// 	       				var val = ttobjectids[i];
// 	       				$('#'+ltobjectids[i]).val(dataItem[val]);
// 	       			}
// 	       		}
	       		
// 	       		LIST_${sid}.reloadGrid();
// 	       	}
	    }
        
    </script>
</head>
<body>
	<c:forEach items="${ltobjectids}" var="ltobjectid">
		<input type="hidden" id="${ltobjectid}" value="">
	</c:forEach>
<div id="treeArea">
<div class="tree-titl">
    <span class="k-icon k-i-list-unordered k-i-list-bulleted"></span>
    <strong>${treetitle}</strong>
</div>
<div id="tree" class="k-content themebg" style="width:100%;height:100%;float:left;padding-top:10px;"></div>
</div>
</body>
</html>