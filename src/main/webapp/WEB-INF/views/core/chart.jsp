<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
    <script>

	    var defaultChartData = new kendo.data.DataSource({
            data: [
            	{ value: 10 , category: new Date(2019,0,1)},
            	{ value: 20 , category: new Date(2019,0,2)},
            	{ value: 30 , category: new Date(2019,0,3)},
            	{ value: 40 , category: new Date(2019,0,4)},
            	{ value: 50 , category: new Date(2019,0,5)},
            	{ value: 60 , category: new Date(2019,0,6)},
            	{ value: 70 , category: new Date(2019,0,7)}
            ]
        });

	    window['CHART_${sid}'] = {
	        chart : "",
	        _selItem: "",
	        chartDataSource: "",
	        initSeriesColors: "",

	        fnInitChart : function(){

	        	$.ajax({
					url : "/chartLoad.json",
					type : 'POST',
					data:{xn:"${xn}"},
					dataType: 'json',
					async:false,
					success: function(data) {
						if(data){
							if(data.length == 1){
								//디폴트 샘플 차트
								chartDataSource = defaultChartData;
							} else {
								chartDataSource = data;
							}
							var options = {
								dataSource: chartDataSource,
				          		title: {
				          			text: '${charttitle}'
				          		},
				          		change:function(e){
				          			console.log('##### chart change function #####');
				          		},
				          		legend: {
				          			position: "bottom"
				          		},
				          		series: [{
				          			<c:if test="${seriesName != null}">
				                    name: "${seriesName}",
				                    </c:if>
				                    <c:choose>
				                        <c:when test="${categoryField != null}">
					                    categoryField : "${categoryField}",
					                    </c:when>
				                        <c:otherwise>
				                        categoryField : "category",
				                        </c:otherwise>
			                        </c:choose>
				                    <c:choose>
				                        <c:when test="${field != null}">
					                    field : "${field}",
					                    </c:when>
				                        <c:otherwise>
				                        field: "value",
				                        </c:otherwise>
			                        </c:choose>
				                    <c:choose>
				                        <c:when test="${defaultType != null}">
					                    type : "${defaultType}"
					                    </c:when>
				                        <c:otherwise>
				                        type: "bar"
				                        </c:otherwise>
				                    </c:choose>
				                }],
				          		tooltip: {
				                    visible: '${visible}',
				                    template: '${template}'
				                },
				          		theme: "material"	
							}
							
							<c:if test="${kendoExtend != null && kendoExtend != ''}">
								var kendoExtend = ${kendoExtend} || {};                		
			            		options = $.extend(true, options, kendoExtend);
			            	</c:if>
		            	
							$("#${sid}_chart").kendoChart(options);

				       		fnObj('CHART_${sid}').chart = $("#${sid}_chart").data("kendoChart");
				       		fnObj('CHART_${sid}').initSeriesColors = fnObj('CHART_${sid}').chart.options.seriesColors;
	        	
							
						}else{
							GochigoAlert("chart item load fail");
						}
					}
				});

// 	       		if(chartDataSource.length > 0){
// 	       			var cid = '${param.cid}';
// 	       			if(!$("#"+cid+"_gridbox").data("kendoGrid")){
//                 		setTimeout(function(){
// 			       			var treeview = $("#tree").data("kendoTreeView");
// 			       			treeview.select($('#tree li')[0]);
//                 		},300);
//                 	} else {
//                 		var treeview = $("#tree").data("kendoTreeView");
// 		       			treeview.select($('#tree li')[0]);
//                 	}
// 	       		}

// 	       		if(typeof ${dataBound} === function){
// 	       			fnObj('CHART_${sid}').chart.bind('dataBound', ${dataBound})
// 	       		}
// 	       		if(typeof ${render} === function){
// 	       			fnObj('CHART_${sid}').chart.bind('render', ${render})
// 	       		}
// 	       		if(typeof ${seriesClick} === function){
// 	       			fnObj('CHART_${sid}').chart.bind('seriesClick', ${seriesClick})
// 	       		}
// 	       		if(typeof ${plotAreaClick} === function){
// 	       			fnObj('CHART_${sid}').chart.bind('plotAreaClick', ${plotAreaClick})
// 	       		}
				$('#${sid}_chart_type').kendoDropDownList({
					dataSource: [
						{ text: "BAR", value: "bar" },
						{ text: "COLUMN", value: "column" },
						{ text: "LINE", value: "line" },
						{ text: "AREA", value: "area" },
						{ text: "PIE", value: "pie" }
					],
					dataTextField: "text",
				    dataValueField: "value",
				    <c:choose>
	                    <c:when test="${defaultType != null}">
	                    value : "${defaultType}",
	                    </c:when>
	                    <c:otherwise>
	                    value: "bar",
	                    </c:otherwise>
	                </c:choose>
					  change: function(e) {
					    var value = this.value();
					    var chart = $("#${sid}_chart").data("kendoChart");
					    var options = chart.options;
					    var initColors = fnObj('CHART_${sid}').initSeriesColors;
					    chart.options.seriesColors = initColors;
					    $.each(options.series, function(idx,op){
					    	op.type = value;
					    	op.color = initColors[idx%fnObj('CHART_${sid}').initSeriesColors.length];
					    })
					    chart.setOptions(options);
					  }
				});
	        },

            resizeChart : function() {
	            var $chart = $("#${sid}_chart");
                var winHeight = $(window).height();
                var chartContentOffset =  $chart.offset().top;
                var contentHeight = winHeight - Math.ceil(chartContentOffset); //그리드 데이터 영역 높이 계산
                var bottomLine = $('#${sid}_bottomline');
                if(bottomLine.length > 0){
                	contentHeight -= bottomLine.height();
                }
                $("#${sid}_chart").height(contentHeight - 30).data("kendoChart").resize();
            },

            fnReloadChart : function(cobjectid, pStr) {

				if($('.${sid}_searchBtn').length > 0){
					$("#${sid}_chart").data("cobjectid", cobjectid);
					$("#${sid}_chart").data("pStr", pStr);
					$('.${sid}_searchBtn').trigger('click');
				} else {
            	
		        	$.ajax({
						url : "/chartLoad.json",
						type : 'POST',
						data:{xn:"${xn}", cobjectid: cobjectid, cobjectval: pStr},
						dataType: 'json',
						async:false,
						success: function(data) {
							if(data){
								chartDataSource = data;
							}else{
								GochigoAlert("chart item load fail");
							}
						}
					});
	
		        	$("#${sid}_chart").data("kendoChart").dataSource.data(chartDataSource);
				}
            },
            
            setUserHtml : function(userHtml) {
            	var htmls = userHtml;
            	$.each(htmls, function(idx, content){
            		var position = content.position;
            		var html = content.html;
            		if(position == "button"){
            			$('#${sid}_btns').append(html);
            		} else if(position == "title"){
            			$('#${sid}_header_title').append(html);
            		} else if(position == "caption"){
            			var preHtml = '<div id="${sid}_topline caption">'+html+'</div>';
            			$('#${sid}_header_title').after(preHtml);
            		} else if(position == "bottom"){
            			var preHtml = '<div id="${sid}_bottomline" style="height:30px;text-align:center;">'+html+'</div>';
            			$('#${sid}_chart').after(preHtml);
            		}
            	});
           		fnObj('CHART_${sid}').resizeChart();
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
                fnObj('CHART_${sid}').resizeChart();
            });
            if(!$("#${sid}_chart").data("kendoChart")){
            	fnObj('CHART_${sid}').fnInitChart();
            }
            fnObj('CHART_${sid}').resizeChart();
            
			if('${userHtml}'.length > 0){
	            var userHtml = JSON.parse('${userHtml}');
	            fnObj('CHART_${sid}').setUserHtml(userHtml);
            }
			
			if('${isDevMode}' == 'Y' && '${desc}'){
            	var html = "<button id='${sid}_descBtn' type='button' style='z-index:3000;' class='k-button' onclick='fnObj(\"CHART_${sid}\").openDesc();'>화면설명</button>";
            	$('#${sid}_header_title').append(html);
            }
	    });


    </script>
<c:if test="${param.mode!='layout'}">
	<body class="k-content">
</c:if>
	<c:forEach items="${ltobjectids}" var="ltobjectid">
		<input type="hidden" id="${ltobjectid}" value="">
	</c:forEach>
	<div id="${sid}_chartArea">
		<div id="${sid}_header_title" class="chartHeader header_title">
			${title}
		</div>
		<div id="${sid}_btns" class="chart_btns"></div>
		<div id="${sid}_chart_type" class="k-dropdownlist" style="top:20px;left:30px;position:relative;z-index:300;"></div>
		<div id="${sid}_chart" class="k-content themebg" style="width:100%;height:100%;margin-top:-20px;display:inline-block;"></div>
	</div>
<c:if test="${jsfileyn == 'Y'}">
<jsp:include page="${jsfileurl}"></jsp:include>
</c:if>
<c:if test="${param.mode!='layout'}">
</body>
</html>
</c:if>