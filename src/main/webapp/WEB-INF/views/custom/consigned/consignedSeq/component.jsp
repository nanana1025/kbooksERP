<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="addConsignedComponentSeq"				value="/consigned/addConsignedComponentSeq.json"/>

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [companyList.js]");
	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

	setTimeout(function() {
		 $('#${sid}_gridbox').off('dblclick');
	}, 1000);


});



function fnAddSeqList() {

	console.log("consignedSeq.fnAddSeqList() Load");
	var url = '${addConsignedComponentSeq}';

	var pGrid = $('#produce_model_list_gridbox').data('kendoGrid');
	var pSelItem = pGrid.dataItem(pGrid.select());
	if(!pSelItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	 var params = {
			 COMPONENT_ID: pSelItem.component_id,
			 SUB_COMPONENT_ID: selItem.component_id,
			 COMPANY_ID: selItem.company_id

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

									fnObj('LIST_consigned_component_seq_list').reloadGrid();
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
		    content: "선택한 모델을 추가하시겠습니까?"
		}).data("kendoConfirm").open();
		//끝지점
}


</script>
