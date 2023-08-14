<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="chartLoad"					value="/chartLoad.json" />

<style>
</style>
<script>

$(document).ready(function() {

	console.log("load [adminMonthChart.js]");

	//범위로 지정하는 경우에 주석 사용
	//var monthCond = '<div id="searchDivMonth" style="position:relative;top:-10px;left:220px;z-index:200;">조회기간&nbsp;&nbsp;&nbsp;<input id="ward_year_from" /> ~ <input id="ward_year_to" /></div>'
	var monthCond = '<div id="searchDivMonth" style="position:relative;top:-10px;left:220px;z-index:200;">조회기간&nbsp;&nbsp;&nbsp;<input id="ward_year_from" /></div>'
	$('#admin_statistics_month_chart_chart').before(monthCond);

	var data = new Array();

	for(var i = 2015; i< 2022; i++)
	{
		var datainfo = new Object();
		datainfo.text = i;
		datainfo.value = i;
		data.push(datainfo);
	}


	$("#ward_year_from").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: data,
        value:new Date().getFullYear(),
        height: 100
      });

	$("#ward_year_to").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: data,
        value:new Date().getFullYear(),
        height: 100
      });

	var searchBtn = '<button type="button" id="month_searchBtn" class="${sid}_searchBtn">검색</button>';
	$('#searchDivMonth').append(searchBtn);

	$('#month_searchBtn').kendoButton();
    var monthSearchBtn = $('#month_searchBtn').data('kendoButton');

    monthSearchBtn.bind('click', function(e) {

    	console.log("admin_statistics_month_chart.wardSearchBtn() Load");

    	var url = '${chartLoad}';
    	var cobjectid = $("#admin_statistics_month_chart_chart").data('cobjectid');
    	var pStr = $("#admin_statistics_month_chart_chart").data('pStr');

    	$.ajax({
			url : url,
			type : 'POST',
			//범위로 지정하는 경우에 주석 사용
			//data:{xn:"${xn}", cobjectid: cobjectid, cobjectval: pStr, start_dt: $('#ward_year_from').val()+'01', end_dt: $('#ward_year_to').val()+'12' },
			data:{xn:"${xn}", cobjectid: cobjectid, cobjectval: pStr, start_dt: $('#ward_year_from').val()+'01', end_dt: $('#ward_year_from').val()+'12' },
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

    	$("#admin_statistics_month_chart_chart").data("kendoChart").dataSource.data(chartDataSource);
    });
});

</script>
