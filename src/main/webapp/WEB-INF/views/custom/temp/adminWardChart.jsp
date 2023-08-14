<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="chartLoad"					value="/chartLoad.json" />

<style>
</style>
<script>

$(document).ready(function() {

	console.log("load [adminWardChart.js]");

	var monthCond = '<div id="searchDiv" style="position:relative;top:-10px;left:220px;z-index:200;">조회기간 <input id="ward_month_from" /> ~ <input id="ward_month_to" /></div>'
	$('#admin_statistics_ward_chart_chart').before(monthCond);

	$("#ward_month_from").kendoDatePicker({
        start: "year",
        depth: "year",
        format: "yyyy-MM",
        value : new Date(),
        change: function(e){
        	var fromDate = this.value();

        	var topicker = $("#ward_month_to").data("kendoDatePicker");
            topicker.setOptions({
                disableDates: function(date) {
                    if(fromDate == null){ return false; }
                    else if(date < fromDate){ return true; }
                    else { return false; }
                }
            });
        }
    });
	$("#ward_month_to").kendoDatePicker({
        start: "year",
        depth: "year",
        format: "yyyy-MM",
        value : new Date(),
        change : function(e){
        	var toDate = this.value();
            var frompicker = $("#ward_month_from").data("kendoDatePicker");
            frompicker.setOptions({
                disableDates: function(date) {
                    if(toDate == null){ return false; }
                    else if(date > toDate){ return true; }
                    else { return false; }
                }
            });
        }
    });

	var searchBtn = '<button type="button" id="ward_searchBtn" class="${sid}_searchBtn">검색</button>';
	$('#searchDiv').append(searchBtn);

	$('#ward_searchBtn').kendoButton();
    var wardSearchBtn = $('#ward_searchBtn').data('kendoButton');

    wardSearchBtn.bind('click', function(e) {

    	console.log("admin_statistics_ward_chart.wardSearchBtn() Load");

    	var url = '${chartLoad}';
    	var cobjectid = $("#admin_statistics_ward_chart_chart").data('cobjectid');
    	var pStr = $("#admin_statistics_ward_chart_chart").data('pStr');

    	$.ajax({
			url : url,
			type : 'POST',
			data:{xn:"${xn}", cobjectid: cobjectid, cobjectval: pStr, start_dt: $('#ward_month_from').val(), end_dt: $('#ward_month_to').val() },
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


    	//$("#admin_statistics_ward_chart_chart").kendoChart(chartDataSource);

    	$("#admin_statistics_ward_chart_chart").data("kendoChart").dataSource.data(chartDataSource);

    });
});

</script>
