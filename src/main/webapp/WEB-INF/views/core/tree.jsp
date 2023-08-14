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

	<script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="/codebase/common.js"></script>
</c:if>
	<style>
		#${sid}_treeArea {
			height: inherit;
		}
		.${sid}_treeContent {
			height: calc(100% - 36px);
			overflow: auto;
		}
	</style>
    <script>
	    var defaultData;
	    if('${defaultData}'){
	    	defaultData = [${defaultData}];
	    } else {
	    	defaultData = [
                { text: "기본 트리",  items: [
                    { text: "샘플 첫번째" },
                    { text: "트리에선 이렇게 보입니다." },
                    { text: "SQL이 없는 경우 보이는 트리입니다." }
                ] },
                { text: "기본 트리2", items: [
                    { text: "샘플 두번째" },
                    { text: "트리 샘플입니다." },
                    { text: "트리 SQL을 입력해주세요." }
                ] }
            ]
	    }
	    var defaultTreeData = new kendo.data.HierarchicalDataSource({
            data: defaultData
        });

	    window['TREE_${sid}'] = {
	        tree : "",
	        _selItem: "",
	        treeDataSource: "",

	        fnInitTree : function(){

	        	var sample = false;
	        	$.ajax({
					url : "/treeLoad.json",
					type : 'POST',
					data:{xn:"${xn}"},
					dataType: 'json',
					async:false,
					success: function(data) {
						if(data){
							if(data.length == 0){
								//디폴트 샘플 트리
								treeDataSource = defaultTreeData;
								sample = true;
							} else {
								treeDataSource = new kendo.data.HierarchicalDataSource({
				                    data: data,
				                    schema: {
				                        model: {
				                            id: "${treeid}",
				                            children: "items"
				                        }
				                    }
				                });
								sample = false;
							}
						}else{
							GochigoAlert("tree item load fail");
						}
					}
				});

	        	if(sample){
	        		$("#${sid}_tree").kendoTreeView({
		       			loadOnDemand: true,
						dataSource: treeDataSource,
		          		dataTextField: '${textcol}',
		          		dataImageUrlField: "icon",
					});
	        	} else {
	        		var options = {
        				loadOnDemand: false,
						dataSource: treeDataSource,
		          		dataTextField: '${textcol}',
		          		dataImageUrlField: "icon",
		          		expand: function(e) {
		          			//TODO 트리 노드 조회 ajax
		          			var tree = $("#${sid}_tree").data("kendoTreeView");
		          			var dataItem = tree.dataItem($(e.node));
		          			$.ajax({
		    					url : "/treeLoad.json",
		    					type : 'POST',
		    					data:{xn:"${xn}", '${treeupperid}': dataItem["${treeid}"]},
		    					dataType: 'json',
		    					async:false,
		    					success: function(data) {
		    						if(data){
	    								var removeUid = [];
	    								$.each(dataItem.children._data, function(idx, data){
	    									removeUid.push(data.uid);
	    								});
	    								$.each(removeUid, function(idx, id){
	    									tree.remove(tree.findByUid(id));
	    								});
										tree.append(data, $(e.node));
		    						}else{
		    							GochigoAlert("tree item load fail");
		    						}
		    					}
		    				});
		          		},
		          		change: function(e){
							var cids = '${param.cid}'.split(","); //WBS
							var cns = '${param.cn}'.split(",");
							var oid = '${oid}'; //exewbsid
							var ctypes = '${param.ctype}'.split(","); //list
							var cobjectids = '${cobjectids}';
							var caddparams = '${caddparams}';
							var addParamYn = false; //추가 파라미터 사용여부
	
	                        var objArr = oid.split(",");
	                        var cobjArr = cobjectids.split(";");

	                        //refAreaId에서 oid가 아닌 추가 파라미터를 사용하는 경우
	                        if(caddparams.replaceAll(";","")) { 
	                        	addParamYn = true;
								var paramArr = caddparams.split(";");
								objArr = []; //oid를 교체하기 위해 비운다
								cobjArr = []; //cobjectid를 교체하기 위해 비운다
								$.each(paramArr, function(idx, param){
									var objParam = param;
									if(objParam.indexOf("*") > -1){
										objParam = param.replaceAll("*","");
									}
									objArr.push(objParam); //oid를 추가파라미터의 id로 바꿈
									cobjArr.push(param); //cobjectid를 추가파라미터의 id로 바꿈
								});
							}
	                        var selectedtreenode = this.select();
	                        var selItem = fnObj('TREE_${sid}').tree.dataItem(selectedtreenode);
	                        if(selItem){
	                        	$.each(cids, function(idx,cid){
			                        var qStr = "";
									var ctype = ctypes[idx];
									var cobjectid = cobjArr[idx];
									var cn = cns[idx];
									window['TREE_${sid}']._selItem = selItem;
		
			                        var qParam = new Array();
		
			                        for(var i=0; i<objArr.length; i++){
			                        	var objs = objArr[i].split(",");
				                        if(objs.length > 1){
					                    	for(var j=0; j<objs.length; j++){
					                    		if(objs[j]){
						                        	qParam.push(selItem.get(objs[j]));
					                    		}
					                    	}
				                        } else {
				                        	if(objArr[i]){
					                    		qParam.push(selItem.get(objArr[i]));
				                        	}
				                        }
			                        }
			                        var pStr = qParam.join(",");
		
			                        qStr += '&cobjectid=' + cobjectid;
			                        qStr += '&cobjectval=' + pStr;
			                        
			                        if(ctype == 'LIST') {
			                        	if(fnObj('LIST_'+cid) != undefined && fnObj('LIST_'+cid) != null) {
			                                fnObj('LIST_'+cid).pParamStr = qStr;
		                                    $("#"+cid+"_gridbox").data("cstr", qStr); //자식 파라미터가 있는 경우 저장해둠(list에서 꺼내서 호출)
		                                    fnObj('LIST_'+cid).reloadGrid();
			                            }
			                        } else if(ctype == 'DATA') {
										fnObj('CRUD_'+cid).initPage("/dataView.json?xn="+cn+"&"+encodeURI(qStr));
			                        } else if(ctype == 'CHART') {
			                        	if(fnObj('CHART_'+cid) && !$("#"+cid+"_chart").data("kendoChart")){
			                        		fnObj('CHART_'+cid).fnInitChart();
			                        	}
			                        	if(fnObj('CHART_'+cid)){
											fnObj('CHART_'+cid).fnReloadChart(cobjectid, pStr);
			                        	}
			                        } else if(ctype == 'TREE') {
			                        	if(fnObj('TREE_'+cid) && !$("#"+cid+"_tree").data("kendoTreeView")){
			                        		fnObj('TREE_'+cid).fnInitTree();
			                        	}
			                        	if(fnObj('TREE_'+cid)){
											fnObj('TREE_'+cid).fnReloadTree(cobjectid, pStr);
			                        	}
			                        }
	                        	});
	                        }
						}
	        		}
	        		
	        		<c:if test="${kendoExtend != null && kendoExtend != ''}">
						var kendoExtend = ${kendoExtend} || {};                		
		           		options = $.extend(true, options, kendoExtend);
		           	</c:if>
		           	
		       		$("#${sid}_tree").kendoTreeView(options);
	        	}

	       		fnObj('TREE_${sid}').tree = $("#${sid}_tree").data("kendoTreeView");
	       		if(treeDataSource._data.length > 0){
	       			var cid = '${param.cid}';
	       			if(!$("#"+cid+"_gridbox").data("kendoGrid")){
                		setTimeout(function(){
			       			var treeview = $("#${sid}_tree").data("kendoTreeView");
			       			treeview.select($('#${sid}_tree li')[0]);
                		},300);
                	} else {
                		var treeview = $("#${sid}_tree").data("kendoTreeView");
		       			treeview.select($('#${sid}_tree li')[0]);
                	}
	       		}

	       		if('${expand}'){
		       		var treeview = $("#${sid}_tree").data("kendoTreeView");
		       		treeview.bind("expand", '${expand}');
	       		}
	       		if('${select}'){
		       		var treeview = $("#${sid}_tree").data("kendoTreeView");
		       		treeview.bind("select", '${select}');
	       		}
	        },

            resizeTree : function() {
            	/* var $tree = $("#tree");
	            var $treeAreaHeight = $('#treeArea').parent().height();
	            var $treeHeaderHeight = $('#treeArea').height();
                var winHeight = $(window).height();
                var treeContentOffset =  $tree.offset().top;
                var contentHeight = $treeAreaHeight - $treeHeaderHeight - 25;
                $("#tree").height(contentHeight); */
            },

            fnReloadTree : function(cobjectid, pStr) {

            	var treeDataSource;

	        	$.ajax({
					url : "/treeLoad.json",
					type : 'POST',
					data:{
						xn: '${xn}', cobjectid: cobjectid, cobjectval: pStr
					},
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

	        	$("#${sid}_tree").data("kendoTreeView").setDataSource(treeDataSource);
	        	
	        	if(treeDataSource._data && treeDataSource._data.length > 0){
	       			var cid = '${param.cid}';
	       			if(!$("#"+cid+"_gridbox").data("kendoGrid")){
                		setTimeout(function(){
			       			var treeview = $("#${sid}_tree").data("kendoTreeView");
			       			treeview.select($('#${sid}_tree li')[0]);
                		},300);
                	} else {
                		var treeview = $("#${sid}_tree").data("kendoTreeView");
		       			treeview.select($('#${sid}_tree li')[0]);
                	}
	       		}
	        	
	        	//userHtml bottom영역은 reload시 사라지므로 다시 생성
	        	if('${userHtml}'.length > 0){
		            var htmls = JSON.parse('${userHtml}');
	            	$.each(htmls, function(idx, content){
	            		var position = content.position;
	            		var html = content.html;
	            		if(position == "bottom"){
	            			var preHtml = '<div class="${sid}_bottomline">'+html+'</div>';
	            			$('#${sid}_tree>ul>li.k-item').last().after(preHtml);
	            		}
	            	});
	            }
            },
			reloadTree : function(text) {
				var treeView = $("#${sid}_tree").data("kendoTreeView");
				var selected = treeView.select();
				var item = treeView.dataItem(selected);
				item.set('${textcol}', text);
			},
            reselectTree : function() {
	        	var treeview = $("#${sid}_tree").data("kendoTreeView");
       			treeview.select(treeview.select());
            },
           	
            setUserHtml : function(userHtml) {
            	var htmls = userHtml;
            	$.each(htmls, function(idx, content){
            		var position = content.position;
            		var html = content.html;
            		if(position == "button"){
            			$('#${sid}_btns').prepend(html);
            		} else if(position == "title"){
            			$('#${sid}_header_title').append(html);
            		} else if(position == "caption"){
            			var preHtml = '<div class="${sid}_topline caption-box"><div class="caption">'+html+'</div></div>';
            			$('#${sid}_treeArea').find('.${sid}_treeContent').prepend(preHtml);
            		} else if(position == "bottom"){
            			var preHtml = '<div class="${sid}_bottomline">'+html+'</div>';
            			$('#${sid}_tree>ul>li.k-item').last().after(preHtml);
            		}
            	});
//             	fnObj('TREE_${sid}').resizeTree();	
            },
            
            openDesc: function() {
            	var desc = '${desc}';
            	var window = $('<div></div>')
            	.append(desc);
            	
            	window.kendoWindow({
                    width: "600px",
                    title: "화면 설명",
                    visible: false,
                    actions: [
                        "Minimize",
                        "Maximize",
                        "Close"
                    ],
                    open: function() {
                    	$('#${sid}_descBtn').hide();
                    },
                    close: function(){
                    	$('#${sid}_descBtn').show();
                    }
                }).data("kendoWindow").center().open();
            }
	    }

	    $(document).ready(function() {
            $(window).on("resize" , function() {
            	setTimeout(function(){
            		fnObj('TREE_${sid}').resizeTree();	
            	}, 50);
            });
            fnObj('TREE_${sid}').fnInitTree();
            //fnObj('TREE_${sid}').resizeTree();
            
            if('${userHtml}'.length > 0){
	            var userHtml = JSON.parse('${userHtml}');
	            fnObj('TREE_${sid}').setUserHtml(userHtml);
            }
            
            if('${isDevMode}' == 'Y' && '${desc}'){
            	var html = "<button id='${sid}_descBtn' type='button' style='z-index:3000;' class='k-button' onclick='fnObj(\"TREE_${sid}\").openDesc();'>화면설명</button>";
            	$('#${sid}_header_title').append(html);
            }
            
            var sessionTreeCol = sessionStorage.getItem('treeTextCol');
            if(!sessionTreeCol) {
            	sessionStorage.setItem('treeTextCol', '${textcol}');
            }
            
	    });
    </script>
<c:if test="${param.mode!='layout'}">
	<body class="k-content">
</c:if>
	<c:forEach items="${ltobjectids}" var="ltobjectid">
		<input type="hidden" id="${ltobjectid}" value="">
	</c:forEach>
	<div id="${sid}_treeArea">
		<div id="${sid}_header_title" class="treeHeader header_title">
			${title}
		</div>
		<div class="${sid}_treeContent">
			<div id="${sid}_btns" class="user_tree_btns">
			
			</div>
			<div id="${sid}_tree" class="k-content themebg" style="width:100%;float:left;"></div>
		</div>
	</div>
<c:if test="${jsfileyn == 'Y'}">
<jsp:include page="${jsfileurl}"></jsp:include>
</c:if>
<c:if test="${param.mode!='layout'}">
</body>
</html>
</c:if>