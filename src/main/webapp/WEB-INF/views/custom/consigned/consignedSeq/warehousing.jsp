<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="addConsignedSeq"				value="/consigned/addConsignedSeq.json"/>

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [companyList.js]");
	$('#produce_warehousing_consigned_list_printBtn').remove();
	$('#produce_warehousing_consigned_list_insertBtn').remove();
	$('#produce_warehousing_consigned_list_deleteBtn').remove();

	setTimeout(function() {
		 $('#${sid}_gridbox').off('dblclick');
	}, 1000);


});



function fnAddSeqList() {

	console.log("consignedSeq.fnAddSeqList() Load");
	var url = '${addConsignedSeq}';

	var pGrid = $('#consigned_company_list_gridbox').data('kendoGrid');
	var pSelItem = pGrid.dataItem(pGrid.select());
	if(!pSelItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	 var params = {
			 WAREHOUSING_ID: selItem.warehousing_id,
			 COMPANY_ID: pSelItem.company_id

	        };


	//시작지점
		$("<div></div>").kendoConfirm({
			buttonLayout: "stretched",
			actions: [{
				text: '추가',
				action: function(e){
					//시작지점
						$.ajax({
							url : url,
							type : "POST",
							data : params,
							async : false,
							success : function(data) {
								if(data.SUCCESS){

									fnObj('LIST_consigned_warehousing_seq_list').reloadGrid();
									GochigoAlert(data.MSG);
								}
								else{
									GochigoAlert(data.MSG);
								}
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
		    content: "선택한 입고번호를 추가하시겠습니까?"
		}).data("kendoConfirm").open();
		//끝지점
}


</script>
