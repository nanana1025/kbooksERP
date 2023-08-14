<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="dataList"					value="/customDataList.json" />
<c:url var="createOrder"					value="/order/createOrder.json" />
<c:url var="cancelOrder"					value="/order/cancelOrder.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [orderCustomerPart.js]");
//  	$('#admin_sale_order_customer_part_list_printBtn').remove();
//  	$('#admin_sale_order_customer_part_list_deleteBtn').remove();
 	$('.basicBtn').remove();


	window.onload = fuChangeDivWidth;
    window.onresize = fuChangeDivWidth;

    //fuChangeDivWidth();

    setTimeout(function() {

	}, 500);

});

function fuChangeDivWidth(){
    var Cwidth = $('#admin_sale_order_customer_part_list_header_title').width()-20;
    $('#admin_sale_order_customer_part_list_btns').css({'width':Cwidth+'px'});
}

function fnInsertOrderPart(){
	console.log("admin_sale_order_customer_part_list.fnInsertOrderPart() Load");

	var openerGrid = $('#admin_sale_order_customer_list_gridbox').data('kendoGrid');
	var openerSelItem = openerGrid.dataItem(openerGrid.select());
	if(!openerSelItem) {
		GochigoAlert('부모의 선택된 항목이 없습니다.');
		self.close();
	}

var ORDER_STATE = openerSelItem.order_state;

	if(ORDER_STATE == 'E') {
		GochigoAlert('견적중에는 추가할 수 없습니다.');
		return;
	}else if(ORDER_STATE == 'D') {
		GochigoAlert('확정상태의 주문은 수정할수 없습니다.');
		return;
	}else if(ORDER_STATE == 'R') {
		GochigoAlert('출고상태의 주문은 수정할수 없습니다.');
		return;
	}else if(ORDER_STATE == 'B') {
		GochigoAlert('반품상태의 주문은 수정할수 없습니다.');
		return;
	}

	fnObj('LIST_${sid}').onClickInsert('${sid}');

}

function fnDeleteOrderPart(){
	console.log("admin_sale_order_customer_part_list.fnDeleteOrderPart() Load");

	var openerGrid = $('#admin_sale_order_customer_list_gridbox').data('kendoGrid');
	var openerSelItem = openerGrid.dataItem(openerGrid.select());
	if(!openerSelItem) {
		GochigoAlert('부모의 선택된 항목이 없습니다.');
		self.close();
	}

	var ORDER_STATE = openerSelItem.order_state;

	if(ORDER_STATE == 'E') {
		GochigoAlert('견적중에는 삭제할 수 없습니다.');
		return;
	}else if(ORDER_STATE == 'D') {
		GochigoAlert('확정상태의 주문은 수정할수 없습니다.');
		return;
	}else if(ORDER_STATE == 'R') {
		GochigoAlert('출고상태의 주문은 수정할수 없습니다.');
		return;
	}else if(ORDER_STATE == 'B') {
		GochigoAlert('반품상태의 주문은 수정할수 없습니다.');
		return;
	}

	fnObj('LIST_${sid}').onClickDelete();
}




</script>
