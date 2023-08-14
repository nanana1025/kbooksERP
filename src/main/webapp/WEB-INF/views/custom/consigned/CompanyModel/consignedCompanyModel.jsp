<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="consignedModelDelete"					value="/consigned/consignedModelDelete.json" />
<c:url var="consignedModelInsert"					value="/consigned/consignedModelInsert.json" />
<c:url var="consignedPopup"							value="/CustomP.do"/>


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [consignedCompanyModel.js]");
	 $('.basicBtn').remove();

});


function fnModelInsert() {

	console.log("consignedCompanyModel.fnModelInsert() Load");

	var grid = $('#consigned_company_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var url = '${consignedModelInsert}';

	params={
			COMPANY_ID: selItem.company_id,
			MODEL_NM: " "
	};

	var isSuccess = false;

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
							GochigoAlert(data.MSG, true, "dangol365 ERP");

							if(data.SUCCESS)
								fnObj('LIST_${sid}').reloadGrid();
						}
					});

	//끝지점
			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "모델을 추가하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점

}


function fnModelDelete() {

	console.log("consignedCompanyModel.fnModelDelete() Load");

	var url = '${consignedModelDelete}';
	var params = "";
	var msg = "";

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


	var isSuccess = false;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '삭제',
			action: function(e){
				//시작지점

						params = {
								MODEL_LIST_ID: selItem.model_list_id
						};

						$.ajax({
							url : url,
							type : "POST",
							data : params,
							async : false,
							success : function(data) {
								GochigoAlert(data.MSG, true, "dangol365 ERP");

								if(data.SUCCESS)
									fnObj('LIST_${sid}').reloadGrid();
							}
						});

	//끝지점
			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택하신 모델을 삭제 하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
