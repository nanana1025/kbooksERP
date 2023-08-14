<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

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
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '입력',
			action: function(e){

				opener.$('#warehousing_'+_proxyPartId).val(selItem.warehousing);
				fnClose();
			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택한 접수번호를 입력하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
