<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="getCodeListCustom"					value="/common/getCodeListCustom.json" />
<c:url var="dataList"					value="/customDataList.json" />
<c:url var="consignedProcess"					value="layoutCustom.do" />
<c:url var="consignedPopup"					value="/CustomP.do"/>


    <script src="/codebase/gochigo.kendo.ui.js"></script>

<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [consignedAll.js]");
	// $('.basicBtn').remove();
	 $('#${sid}_deleteBtn').remove();
	 $('#${sid}_insertBtn').remove();
	 $('#${sid}_gridbox').off('dblclick');

});



function customfunction_R_RECEIPT(){
// 	console.log("되는건가요?!?!?!?");

	var url = '${consignedProcess}';

	setTimeout(function() {
		var grid = $('#${sid}_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

		var proxyState = selItem.proxy_state * 1;
		var content;
		if(proxyState < 5){ //반품
			content = "process";
		}else{
			content = "return";
		}


		var params = {
				content: content,
				KEY: "PROXY_ID",
				VALUE: selItem.proxy_id
			};

		var query = "?content="+params.content+"&KEY="+params.KEY+"&"+params.KEY+"="+params.VALUE;
		window.location.href = url+query;


	}, 10);

}

function customfunction_R_INVOICE(){
// 	console.log("되는건가요?!?!?!?");

	setTimeout(function() {
		var grid = $('#${sid}_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


		if(selItem.invoice == ''){return;}
		var params = {
				content: "process",
				KEY: "PROXY_ID",
				VALUE: selItem.proxy_id
			};

		fnWindowOpenInvoice("/layoutNewList.do?xn=consigned_Invoice_LAYOUT&KEY="+params.KEY+"&VALUE="+params.VALUE,"component_id","S");

	}, 10);



}


</script>
