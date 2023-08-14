<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="dataList"					value="/customDataList.json" />

<style>
</style>
<script>

$(document).ready(function() {

	console.log("load [adminNurseMemList.js]");

	$('#admin_approve_nurse_list_gridbox').off('dblclick');

	setTimeout(function() {
		fnCustomListReload();
	}, 500);
});

function fnCustomListReload(){

	console.log("admin_approve_nurse_list.fnCustomListReload() Load");

	var url = '${dataList}';
	var cobjectid = "MATRON_ID"
  	var pStr = opener.$("#matron_id").val();
	var grid = opener.opener.$('#admin_matron_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());

     var qStr = "";
     qStr += '&cobjectid=' + cobjectid;
     qStr += '&cobjectval=' + pStr;
     qStr += '&USER_ID='+selItem.user_id;

		var dataSource = {
               transport: {
                   read: {
                	   url: "<c:url value='"+url+"'/>"+"?xn=admin_approve_nurse_list"+"&"+qStr,
                        dataType: "json"
                   },
                   parameterMap: function (data, type) {
                   	if(data.filter){
                     	  //필터 시 날짜 변환
                     	  var filters = data.filter.filters;
                     	  $.each(filters, function(idx, filter){
	                        	if(filter.value && typeof filter.value.getFullYear === "function"){
	                        		var year = filter.value.getFullYear();
	                        		var month = filter.value.getMonth()+1;
	                        		if(month < 10){ month = "0"+month; }
	                        		var date = filter.value.getDate();
	                        		if(date < 10){ date = "0"+date; }
	                        		var valStr = year+"-"+month+"-"+date;
	                        		filter.value = valStr;
	                        	}
                     	  });
                       	}
                     return data;
                   }
               },
               error : function(e) {
               	console.log(e);
               },
               schema: {
                   data: 'gridData',
                   total: 'total',
                   model:{
                        id:"${grididcol}",
                       fields: JSON.parse('${fields}')
                   }
               },
               pageSize: 20,
               serverPaging: true,
               serverSorting : true,
               serverFiltering: true
           };
	var grid = $("#admin_approve_nurse_list_gridbox").data("kendoGrid");
     grid.setDataSource(dataSource);
}





</script>
