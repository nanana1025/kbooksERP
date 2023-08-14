<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="dataList"							value="/customDataList.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

var _pid = -1;

$(document).ready(function() {

	console.log("load [warehousingPopupjs]");
// 	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

	if('${sid}' == 'produce_warehousing_partcompare_examine'){
		var  infCond = '<button id="produce_warehousing_closeBtn" class="ml k-button" data-role="button" role="button" onclick="fnClose()" aria-disabled="false" tabindex="0" style="float: right;"> 닫기</button>';
		$('#produce_warehousing_partcompare_examine_header_title').prepend(infCond);
	}

	$('#${sid}_gridbox').off('dblclick');

	_pid = getParameterByName('pid');

    fnGridInit();
});

function fnClose(){
	self.close();
}


function fnGridInit(){

	console.log("warehousingAllList.fnGridInit() Load");

	var openerGrid = opener.$('#'+_pid+'_gridbox').data('kendoGrid');
	var openerSelItem = openerGrid.dataItem(openerGrid.select());
	if(!openerSelItem) {
		GochigoAlert('부모의 선택된 항목이 없습니다.');
		self.close();
	}


	var url = '${dataList}';
	var check = $('#warehousing_state').val();
	var cobjectid = "WAREHOUSING_ID";
	var cobjectval = openerSelItem.warehousing_id;
	var qStr = "";
	var sid = '${sid}';
	var listNm = "";

	if(sid == 'produce_warehousing_partcompare_customer')
		listNm ='Produce_warehousing_PartCompare_Customer_LIST';
	else
		listNm ='Produce_warehousing_PartCompare_Examine_LIST';


    qStr += '&cobjectid=' + cobjectid;
    qStr += '&cobjectval=' + cobjectval;


	var dataSource = {
           transport: {
               read: {
            	   url: "<c:url value='"+url+"'/>"+"?xn="+listNm+"&"+qStr,
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
	var grid = $("#${sid}_gridbox").data("kendoGrid");
 	grid.setDataSource(dataSource);
}

function getParameterByName(name) {
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
			results = regex.exec(location.search);
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}


</script>
