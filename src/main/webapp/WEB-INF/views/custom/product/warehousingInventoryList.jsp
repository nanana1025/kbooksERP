<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="productDelete"				value="/product/productDelete.json"/>

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [releasegInventoryList.js]");

	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

	$('#${sid}_gridbox').off('dblclick');


	$('.release_product_inventory_list_gridbox.k-floatwrap').remove();
});


function fnProductDelete() {

	console.log("${sid}.fnProductDelete() Load");

	var url = '${productDelete}';

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


	params = {
			WAREHOUSING_ID: selItem.warehousing_id,
			INVENTORY_ID: selItem.inventory_id,
			BARCODE: selItem.barcode,
			TYPE: "W"

		};

	var isSuccess = false;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '삭제',
			action: function(e){
				//시작지점
				$.ajax({
					url : url,
					type : "POST",
					async : false,
					data : JSON.stringify(params),
					contentType: "application/json",
					success : function(data) {
						if(data.SUCCESS){
							isSuccess = true;
							GochigoAlert(data.MSG);
						}
						else{
							GochigoAlert(data.MSG);
						}
					}
				});

				if(isSuccess)
				{
					fnObj('LIST_${sid}').reloadGrid();
				}

				//끝지점
			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택한 제품을 삭제하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점

}



</script>
