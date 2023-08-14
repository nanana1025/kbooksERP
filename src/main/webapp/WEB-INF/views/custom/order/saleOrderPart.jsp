<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="releaseReturnAllInventory"					value="/order/releaseReturnAllInventory.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [saleOrderPar.js]");
	$('#${sid}_deleteBtn').remove();
 	$('#${sid}_printBtn').remove();
 	$('#${sid}_insertBtn').remove();
	$('#${sid}_gridbox').off('dblclick');

	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
 		fnReleaseInventoryList();
    });

    setTimeout(function() {
    	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
     		fnReleaseInventoryList();
        });
	}, 500);


});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}


function fnReleaseInventoryList() {

	console.log("${sid}.fnReleaseInventoryList() Load");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(selItem.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
			ORDER_ID : selItem.order_id
	    };

	var url = "&cobjectid=order_id&cobjectval="+params.ORDER_ID;

	fnWindowOpen("/layoutNewW.do?xn=sale_Order_ReleasePart_LAYOUT"+url,"component_id", "W");

}


function fnReleaseReturnAlllInventory(){

	console.log('sale_order_part_list_list.fnReleaseReturnAlllInventory() Load');

	var url = '${releaseReturnAllInventory}';

// 	var grid = $('#${sid}_gridbox').data('kendoGrid');
// 	var rows = grid.select();

// 	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var pGrid = $('#sale_order_all_list_gridbox').data('kendoGrid');
	var selItem = pGrid.dataItem(pGrid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


	if(selItem.order_cnt == '0'){
		GochigoAlert('주문 품목이 없습니다.');
		return;
	}else if(selItem.release_cnt == '0'){
		GochigoAlert('출고 목록이 없습니다.');
		return;
	}




	if(selItem.order_state == 'R' || selItem.order_state == 'RW'){
		GochigoAlert('출고단계인 주문은 변경할 수 없습니다.');
		return;
	}
// 	else if(selItem.order_state == 'C'){
// 		GochigoAlert('취소된 주문은 변경할 수 없습니다.');
// 		return;
// 	}else if(selItem.order_state == 'O'){
// 		GochigoAlert('주문(견적 대기)중인 주문은 변경할 수 없습니다.');
// 		return;
// 	}

	var isSuccess = false;
	var queryCustom = "";

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

// 				var listInventoryId = [];
// 				var componentId = '';
// 				var orderId = '';
// 				 rows.each(function (index, row) {
// 					 var gridData = grid.dataItem(this);
// 					 componentId = gridData.component_id;
// 					 orderId = gridData.order_id;
// 					 listInventoryId.push(gridData.inventory_id);
// 					 });

// 				 queryCustom = "cobjectid=order_id,component_id&cobjectval="+orderId+','+componentId;

				var params = {
				        ORDER_ID :selItem.order_id,
// 				        INVENTORY_ID : listInventoryId.toString(),
// 				        COMPONENT_ID :componentId
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
// 							fnObj('LIST_${sid}').reloadGridCustom(queryCustom);
						}
						else{
							GochigoAlert(data.MSG);
						}
					}
				});

				 if(isSuccess){
// 				    	fnObj('LIST_sale_order_releasepart_list').reloadGridCustom(queryCustom);
// 				    	fnObj('LIST_sale_order_customerpart_list').reloadGridCustom(queryCustom);

				    	fnObj('LIST_sale_order_all_list').reloadGrid();
						//fnClose();
					}
				//끝지점
			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "확인을 누르면 현재 주문의 모든 재고가 재고 목록에 반환됩니다."
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
