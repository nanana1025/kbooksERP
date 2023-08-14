<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>


<c:url var="customDataListPrice"									value="/customDataListPrice.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [priceLTPurchaseList.js]");

	$('.basicBtn').remove();
	$('#${sid}_gridbox').off('dblclick');

	var infCondType = '&nbsp;&nbsp;&nbsp;<label>타입 &nbsp;&nbsp;&nbsp;</label><input id="type_cd" style = "width: 100px;"/>';
	$('#${sid}_btns').prepend(infCondType);

	var typeValueArray = ["ALL", "NTB", "DESKTOP"];
	var typeTextArray = ["전체",
								"NTB",
								"DESKTOP"];

	var dataArray = new Array();

	for(var i = 0; i<typeValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = typeValueArray[i];
		datainfo.value =  typeValueArray[i];
		dataArray.push(datainfo);
	}

	$("#type_cd").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"ALL",
        height: 100,
        change: fnDropBoxonChange
      });

	 fuChangeDivWidth();

// 	$('.k-grid-add').remove();

	setTimeout(function(){
		//$('.k-grid-delete').remove();
	},200);
});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}

function fnDropBoxonChange(page=0, pageSize = 0){

	console.log("${sid}.fnDropBoxonChange() Load");

	var url = '${customDataListPrice}';
// 	var check = $('#confirm_cd').val();
// 	var cobjectid = "OTHER_PURCHASE_PRICE_CONFIRM"
	var qStr = "";

//    	if(check == "ALL"){
// 	}else{
// 		qStr += '&cobjectid=' + cobjectid;
// 	    qStr += '&cobjectval=' + check;
// 	}

   	var typeCheck = $('#type_cd').val();

    qStr += '&typeCobjectval=' + typeCheck;

    if(page > 0 && pageSize > 0){
    	 qStr += '&CustomPage=' + page;
    	 qStr += '&CustomPageSize=' + pageSize;
    }

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

</script>
