<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="dataList"					value="/customDataList.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>



$(document).ready(function() {

	console.log("load [produceAllList.js]");
	$('.basicBtn').remove();
// 	$('#admin_produce_all_list_gridbox').off('dblclick');

	var infCond = '<label>입고상태 &nbsp;&nbsp;&nbsp;</label><input id="warehousing_state" style = "width: 150px;"/>';

	$('#admin_produce_all_list_btns').prepend(infCond);

	$('.k-button').css('float','right');

	var stateCodeValueArray = ["ALL","E","W","D"];
	var stateContentTextArray = ["전체",
								"입고",
								"입고 대기",
								"삭제"];

	var dataArray = new Array();

	for(var i = 0; i<stateCodeValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = stateContentTextArray[i];
		datainfo.value =  stateCodeValueArray[i];
		dataArray.push(datainfo);
	}

	$("#warehousing_state").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"ALL",
        height: 130,
        change: fnDropBoxonChange
      });

	window.onload = fuChangeDivWidth;
    window.onresize = fuChangeDivWidth;

    fuChangeDivWidth();

    fnDropBoxonChange();

});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}


function fnDropBoxonChange(){

	console.log("produceAllList.fnDropBoxonChange() Load");

	var url = '${dataList}';
	var check = $('#warehousing_state').val();
	var cobjectid = "WAREHOUSING_STATE"
	var qStr = "";

   	if(check == "ALL"){
	    qStr += '&cnobjectid=' + cobjectid;
	    qStr += '&cnobjectval=D';
	}else if(check == "D"){
		cobjectval = check;
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + cobjectval;
	}else{
		cobjectval = check;
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + cobjectval;

	    qStr += '&cnobjectid=' + cobjectid;
	    qStr += '&cnobjectval=D';
	}

	var dataSource = {
           transport: {
               read: {
            	   url: "<c:url value='"+url+"'/>"+"?xn=admin_produce_all_list"+"&"+qStr,
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
            resizable: true,
           pageSize: 20,
           serverPaging: true,
           serverSorting : true,
           serverFiltering: true
       };
	var grid = $("#admin_produce_all_list_gridbox").data("kendoGrid");
 	grid.setDataSource(dataSource);


}

</script>
