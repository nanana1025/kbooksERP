<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="insertConsignedReleaseInventory"				value="/consigned/insertConsignedReleaseInventory.json"/>

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

var _proxyPartId = getParameterByName('PROXY_PART_ID');

$(document).ready(function() {

	console.log("load [warehousingAllList.js]");
	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

	$('#${sid}_gridbox').off('dblclick');

});

function getParameterByName(name) {
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
			results = regex.exec(location.search);
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function fnClose(){
	window.close();
}

function fnSelectWarehousing(){

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var url = '${insertConsignedReleaseInventory}';

	var params = {
			PROXY_PART_ID: _proxyPartId
	};

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '추가',
			action: function(e){

				 var listInventoeyId = [];
				 var componentId = -1;
				 rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 listInventoeyId.push(gridData.inventory_id);
					 componentId = gridData.component_id;
					 });

				 params.INVENTORY_ID = listInventoeyId.toString();
				 params.COMPONENT_ID = componentId;

				$.ajax({
		    		url : url,
		    		type : "POST",
		    		data : params,
		    		async : false,
		    		success : function(data) {

		    			if(data.SUCCESS){
		    				opener.fnInitConsignedReleaseData();
		    				GochigoAlert(data.MSG, true, "dangol365 ERP");
		    			}else{
		    				GochigoAlert(data.MSG, false, "dangol365 ERP");
		    			}

		    		}
		    	});

			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택한 재고번호를 추가하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
