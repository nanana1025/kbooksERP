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

    <script src="/js/jquery-3.3.1.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
</c:if>
    <script>
    
	    window['TREE_${sid}'] = {
	        tree : "", 
	        _selItem: "",
	        treeDataSource: "",
	        
	        fnInitTree : function(){
	        	
	        	$.ajax({
					url : "/admin/getTree.json",
					type : 'POST',
					data:{sid:"${sid}"},
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
	          		dataTextField: '${textcol}',
	          		change:function(e){

						var cid = '${param.cid}'; //WBS
						var oid = '${param.oid}'; //exewbsid
						var ctype = '${param.ctype}'; //list
						var cobjectid = '${param.cobjectid}';
                        var qStr = "";

                        var objArr = oid.split(",");
                        var cobjArr = cobjectid.split(",");
                        var selectedtreenode = this.select();
                        var selItem = fnObj('TREE_${sid}').tree.dataItem(selectedtreenode);
                        window['TREE_${sid}']._selItem = selItem;

                        var qParam = new Array();

                        for(var i=0; i<objArr.length; i++){
                            qParam.push(selItem.get(objArr[i]));
                        }
                        var pStr = qParam.join("|^|");

                        qStr += '&cobjectid=' + encodeURI(cobjectid);
                        qStr += '&cobjectval=' + encodeURI(pStr);

                        if(ctype == 'LIST') {
                        	if(!$("#"+cid+"_gridbox").data("kendoGrid")){
                        		setTimeout(function(){},200);
                        	}
                        	if(fnObj('LIST_${param.cid}') != undefined || fnObj('LIST_${param.cid}') != null) {
                                fnObj('LIST_${param.cid}').pParamStr = qStr;
                                $("#"+cid+"_gridbox").data("kendoGrid").dataSource.transport.options.read.url = "<c:url value='/admin/dataList.json'/>"+"?sid="+cid+qStr;
                                $("#"+cid+"_gridbox").data("kendoGrid").dataSource.read();
                            }
                        } else if(ctype == 'CRUD') {
							fnObj('CRUD_${param.cid}').initPage("<c:url value='/admin/dataView.json'/>"+"?sid="+cid+"&"+qStr);
                        }
					}
				});
	       		fnObj('TREE_${sid}').tree = $("#tree").data("kendoTreeView");
	       		if(treeDataSource.length > 0){
	       			var cid = '${param.cid}';
	       			if(!$("#"+cid+"_gridbox").data("kendoGrid")){
                		setTimeout(function(){
			       			var treeview = $("#tree").data("kendoTreeView");
			       			treeview.select($('#tree li.k-first'));
                		},200);
                	} else {
                		var treeview = $("#tree").data("kendoTreeView");
		       			treeview.select($('#tree li.k-first'));	
                	}
	       		}
	        },
	        
            resizeTree : function() {
	            var $tree = $("#tree");
                var winHeight = $(window).height();
                var treeContentOffset =  $tree.offset().top;
                var contentHeight = winHeight - Math.ceil(treeContentOffset); //그리드 데이터 영역 높이 계산
                $("#tree").height(contentHeight - 20);
            },
            
            fnReloadTree : function() {
            	
            	var treeDataSource;
    			
	        	$.ajax({
					url : "/admin/getTree.json",
					type : 'POST',
					data:{sid:"${sid}"},
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
	        	
	        	$("#tree").data("kendoTreeView").dataSource.data(treeDataSource);
            },
            
            reselectTree : function() {
	        	var treeview = $("#tree").data("kendoTreeView");
       			treeview.select(treeview.select());	
            }
	    }

        $(document).ready(function() {
            $(window).on("resize" , function() {
                fnObj('TREE_${sid}').resizeTree();
            });
            fnObj('TREE_${sid}').fnInitTree();
            fnObj('TREE_${sid}').resizeTree();

//             if("${mode}" == 'layout'){
//             	var firstItem = $('#tree').children().children().children()[1].children[0];
//             	setTimeout(function(){TREE_${sid}.tree.select(firstItem);},500);
//             }
        });

    </script>
<c:if test="${param.mode!='layout'}">
	<body class="k-content">
</c:if>
	<c:forEach items="${ltobjectids}" var="ltobjectid">
		<input type="hidden" id="${ltobjectid}" value="">
	</c:forEach>
	<div id="treeArea">
	<div class="header_title">
		<span class="pagetitle"><span class="k-icon k-i-grid-layout k-i-list-unordered k-i-list-bulleted"></span>${treetitle}</span>
		<span style="float:right;margin-right:5px;"><button type="button" id="btnDialog" class="k-button"><span class="k-icon k-i-gear"></span></button></span>
	</div>
	<div id="tree" class="k-content themebg" style="height:100%;float:left;padding-top:10px;margin-left:12px;"></div>
	</div>

<div id="treeHeader" class="treeHeader" style="display: none;"></div>
<c:if test="${jsfileyn == 'Y'}">
<jsp:include page="${jsfileurl}"></jsp:include>
</c:if>

<script>
    if($("#treeHeader").html() != "") {
        var dialog = $("#treeHeader");
        var btnDialog = $("#btnDialog");
        dialog.kendoWindow({
			// width : 80,
            title: false,
            closable : true,
            modal : false,
			position : {
                top : $("#btnDialog").offset().bottom,
				left : $(".header_title").width() - 200
			},
            options : {
                width: 200
            }
        });

        dialog.data("kendoWindow").close();

        btnDialog.click(function() {
            if(dialog.data("kendoWindow").options.visible) {
                btnDialog.removeClass("k-state-active");
                dialog.data("kendoWindow").close();
            } else {
                btnDialog.addClass("k-state-active");
                dialog.data("kendoWindow").open();
            }
        });
    }
</script>

<c:if test="${param.mode!='layout'}">
</body>
</html>
</c:if>
