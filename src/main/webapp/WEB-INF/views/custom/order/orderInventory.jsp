<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="InventoryToReleaseList"					value="/order/InventoryToReleaseList.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [orderCustomer.js]");
 	$('#${sid}_deleteBtn').remove();
 	$('#${sid}_printBtn').remove();
 	$('#${sid}_insertBtn').remove();
 	$('#${sid}_gridbox').off('dblclick');

    setTimeout(function() {

	}, 500);


});


function fnReleaseInventory() {

	console.log("${sid}.fnReleaseInventory() Load");

	var url = '${InventoryToReleaseList}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}


	var sGrid = $('#sale_order_part_list_gridbox').data('kendoGrid');
	var sSelItem = sGrid.dataItem(sGrid.select());
	if(!sSelItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var orderCnt = sSelItem.cnt;
	orderCnt = orderCnt*1;

	var orderReleaseCnt = sSelItem.release_cnt;
	orderReleaseCnt = orderReleaseCnt*1;


	var pGrid = $('#sale_order_all_list_gridbox').data('kendoGrid');
	var selItem = pGrid.dataItem(pGrid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.order_state == 'R' || selItem.order_state == 'RW'){
		GochigoAlert('출고단계인 주문은 변경할 수 없습니다.');
		return;
	}else if(selItem.order_state == 'C'){
		GochigoAlert('취소된 주문입니다.');
		return;
	}else if(selItem.order_state == 'O'){
		GochigoAlert('주문(견적 대기)중인 주문입니다.');
		return;
	}

	if(orderReleaseCnt >= orderCnt){
		GochigoAlert('선택한 주문의 품목은 최대 '+orderCnt+'개 출고 가능합니다.(출고 수량 확인)'); return;
	}

	if(rows.length > orderCnt){
		GochigoAlert('선택한 주문의 품목은 최대 '+orderCnt+'개 출고 가능합니다.(현재 선택한 재고: '+rows.length+'개)'); return;
	}

	var treeYN = 'N';
	 rows.each(function (index, row) {
		 var gridData = grid.dataItem(this);
		 var check = gridData.tree_yn;

		 if(check =='Y'){
			 treeYN = 'Y';
		 }
	 });

	var msg = "";

	if(treeYN == 'Y'){
		msg = '선택하신 재고 중 제품인 재고가 존재합니다. 종속된 재고 모두를 출고 목록에 추가하시겠습니까?'
	}else{
		msg = "선택하신 재고를 출고목록에 추가하시겠습니까?";
	}


	var isSuccess = false;
	var queryCustom = "";

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				var listInventoryId = [];
				var componentId = '';
				 rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 componentId = gridData.component_id;
					 listInventoryId.push(gridData.inventory_id);
					 });

				queryCustom = "cobjectid=component_id&cobjectval="+componentId;

				var params = {
				        ORDER_ID : selItem.order_id,
				        INVENTORY_ID : listInventoryId.toString(),
				        COMPONENT_ID : componentId
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
// 				    	fnObj('LIST_sale_order_all_list').reloadGridCustom(queryCustom);
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
	    content: msg
	}).data("kendoConfirm").open();
	//끝지점
}
</script>
