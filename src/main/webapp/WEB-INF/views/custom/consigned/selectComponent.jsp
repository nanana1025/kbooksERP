<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="compDelete"				value="/compInven/compDelete.json" />
<c:url var="pawdInit"					value="/user/userPawdInit.json" />
<c:url var="dataList"					value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>

<style>

</style>
<script>

var _componentCd = getParameterByName('componentCd');

$(document).ready(function() {

	console.log("load [list_component.js]");
	$('.basicBtn').remove();
	$('#${sid}_gridbox').off('dblclick');

	fnDropBoxonChange();


	setTimeout(function() {
		$('#selectBtn').removeAttr("onclick");
		$('#selectBtn').attr("onclick", "fnCustomSelect();");
	},1000);

});


function fnCustomSelect(){

	console.log("Function fnCustomSelect()");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.');
	return;}

// 	var componentCd = $('.header_title30').text().trim();
// 	if(componentCd == 'CPU')
// 	{

		var params = {
				LT_CUSTOM_PART_ID: selItem.lt_custom_part_id,
				PART_NAME : selItem.part_name,
				PART_KEY : selItem.part_key
			};

// 		var _CPUNAME = ["제조사","모델명","상세스펙","코드명","소켓","코어수"] ;
		opener.$('#LT_CUSTOM_PART_ID').val(params.LT_CUSTOM_PART_ID);
		opener.$('#PART_NAME').val(params.PART_NAME);
		opener.$('#PART_KEY').val(params.PART_KEY);

// 	}


//  	console.log(params.OTHER_PURCHASE_PART_ID);
//  	console.log(params.PART_KEY);
//  	console.log(params.PART_NAME);


	self.close();
}

function fnDropBoxonChange(){

	console.log("produceAllList.fnDropBoxonChange() Load");

	var url = '${dataList}';

	var qStr = "";

	    qStr += '&cobjectid=COMPONENT_CD';
	    qStr += '&cobjectval='+_componentCd;


	var dataSource = {
           transport: {
               read: {
            	   url: "<c:url value='"+url+"'/>"+"?xn=${sid}"+"&"+qStr,
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

function fnCancel(){
	self.close();
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}


</script>
