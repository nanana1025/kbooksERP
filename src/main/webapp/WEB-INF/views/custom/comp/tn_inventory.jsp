<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="inventoryDelete"					value="/compInven/invenDelete.json" />
<c:url var="dataList"					value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>
    <script src="/codebase/common.js"></script>

<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [tn_inventory.js]");
	//$('.basicBtn').remove();
	//$('#admin_nurse_list_gridbox').off('dblclick');


	$('#admin_inventory_list_deleteBtn').remove();

	var infCond = '<label>재고상태 &nbsp;&nbsp;&nbsp;</label><input id="inventory_state_check" style = "width: 150px;"/>';

	$('#admin_inventory_list_btns').prepend(infCond);

	$('.k-button').css('float','right');
	$('#admin_inventory_delete_btn').insertBefore('#admin_inventory_list_printBtn');

	var stateCodeValueArray = ["ALL", "E", "S", "R", "T", "D"];
	var stateContentTextArray = ["전체",
								"입고",
								"입고 대기",
								"출고",
								"출고 대기",
								"삭제"
								];

	var dataArray = new Array();


	for(var i = 0; i<stateCodeValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = stateContentTextArray[i];
		datainfo.value =  stateCodeValueArray[i];
		dataArray.push(datainfo);
	}

	$("#inventory_state_check").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"ALL",
        height: 130,
        change: fnDropBoxonChange
      });

	//fnDropBoxonChange();

	window.onload = fuChangeDivWidth;
    window.onresize = fuChangeDivWidth;

    fuChangeDivWidth();


});

function fuChangeDivWidth(){
    var Cwidth = $('#admin_inventory_list_header_title').width()-20;
    $('#admin_inventory_list_btns').css({'width':Cwidth+'px'});
}

function fnDeleteComponent() {

	//GochigoAlert('현재 사용할 수 없는 기능입니다.');
	//return;

	console.log("admin_inventory_list.fnDeleteComponent() Load");

	var url = '${inventoryDelete}';
	var params = "";
	var msg = "";
	var grid = $('#admin_inventory_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var compStateCd = selItem.state_cd;
	var barcode = selItem.barcode;

	if(compStateCd == 'D'){
		GochigoAlert('이미 삭제된 재고 정보 입니다.');
		return;
	}

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

					params = {
						BARCODE: barcode
					};


					$.ajax({
						url : url,
						type : "POST",
						data : params,
						async : false,
						success : function(data) {
							if(data.success){
								GochigoAlert(data.MSG);
								fnObj('LIST_admin_inventory_list').reloadGrid();
							}
							else
								GochigoAlert(data.MSG);
						}
					});

					//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "정말 삭제하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점


}

function fnDropBoxonChange(){

	console.log("admin_inventory_list.fnDropBoxonChange() Load");

	var url = '${dataList}';
	var check = $('#inventory_state_check').val();
	var cobjectid = "INVENTORY_STATE"
	var qStr = "";

	if(check != "ALL"){
		cobjectval = check;
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + cobjectval;
	}

	var dataSource = {
           transport: {
               read: {
            	   url: "<c:url value='"+url+"'/>"+"?xn=admin_inventory_list"+"&"+qStr,
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
	var grid = $("#admin_inventory_list_gridbox").data("kendoGrid");
 	grid.setDataSource(dataSource);

}


</script>
