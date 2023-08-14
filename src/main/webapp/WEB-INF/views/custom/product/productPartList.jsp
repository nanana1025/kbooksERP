<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="deleteProductInventory"					value="/product/deleteProductInventory.json" />

<script src="/codebase/gochigo.kendo.ui.js"></script>

<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [productPartList.js]");
// 	$('.basicBtn').remove();
	$('#${sid}_printBtn').remove();
// 	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();
	$('#${sid}_gridbox').off('dblclick');

});

function fnCustomDelete() {
	console.log("${sid}.fnCustomDelete() Load");

	var url = '${deleteProductInventory}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var sGrid = $('#admin_product_list_gridbox').data('kendoGrid');
	var sSelItem = sGrid.dataItem(sGrid.select());
	if(!sSelItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


	var isSuccess = false;
	var isPRefresh = false;
	var queryCustom = "";

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				var listInventoryId = [];
				var pInventoryId = sSelItem.inventory_id;

				 rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 listInventoryId.push(gridData.inventory_id);
					 });

				queryCustom = "cobjectid=inventory_id&cobjectval="+pInventoryId;

				var params = {
						INVENTORY_ID : pInventoryId,
				        C_INVENTORY_ID : listInventoryId.toString()
				    };

				$.ajax({
					url : url,
					type : "POST",
					data : params,
					async : false,
					success : function(data) {
						if(data.SUCCESS){
							isSuccess = true;
							GochigoAlert(data.MSG);
							isPRefresh = data.PREFRESH;
// 							fnObj('LIST_${sid}').reloadGridCustom(queryCustom);
						}
						else{
							GochigoAlert(data.MSG);
						}
					}
				});

				 if(isSuccess){
					 if(isPRefresh){
						 fnObj('LIST_admin_product_list').reloadGrid();
					 }else{
						 fnObj('LIST_${sid}').reloadGridCustom(queryCustom);
// 						fnObj('LIST_sale_order_all_list').reloadGrid();
						//fnClose();
					 }
				}
				//끝지점
			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "<h3>선택한 재고를 <font color=red>제품 목록</font>에서 삭제하시겠습니까?</h3><br><b><font color=blue>[재고 삭제가 아닌 제품에서 분리임. 재고 삭제는 \'생산-입고\' 화면에서 수행]</font>"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
