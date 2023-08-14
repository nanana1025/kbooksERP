<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="releaseInventory"					value="/order/releaseInventory.json" />
<c:url var="dataList"					value="/customDataList.json" />
<c:url var="createRelease"					value="/release/createRelease.json" />



<c:url var="cancelRelease"					value="/release/cancelRelease.json" />
<c:url var="returnRelease"					value="/release/returnRelease.json" />
<c:url var="release"					value="/release/release.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [releaseOverallList.js]");

 	$('#${sid}_deleteBtn').remove();
 	$('#${sid}_printBtn').remove();
 	$('#${sid}_insertBtn').remove();

 	$('#${sid}_gridbox').off('dblclick');

 	var infCond = '<label>출고상태 &nbsp;&nbsp;&nbsp;</label><input id="release_state" style = "width: 150px;"/>';

	$('#${sid}_btns').prepend(infCond);

	$('.k-button').css('float','right');


	var stateCodeValueArray = ["ALL","W","R","C","B"];
	var stateContentTextArray = ["전체",
								"출고대기",
								"출고",
								"취소",
								"반품"];

	var dataArray = new Array();

	for(var i = 0; i<stateCodeValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = stateContentTextArray[i];
		datainfo.value =  stateCodeValueArray[i];
		dataArray.push(datainfo);
	}

	$("#release_state").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"ALL",
        height: 180,
        change: fnDropBoxonChange
      });

	window.onload = fuChangeDivWidth;
    window.onresize = fuChangeDivWidth;

    fuChangeDivWidth();

});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_header_title').width()-20;
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}


function fnDropBoxonChange(){

	console.log("releaseOverall.fnDropBoxonChange() Load");

	var url = '${dataList}';
	var check = $('#release_state').val();
	var cobjectid = "RELEASE_STATE"
	var qStr = "";

	if(check != "ALL"){
		cobjectval = check;
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + cobjectval;
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
