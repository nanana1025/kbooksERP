<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="dataList"					value="/customDataList.json" />
<c:url var="createOrder"					value="/order/createOrder.json" />
<c:url var="cancelOrder"					value="/order/cancelOrder.json" />
<c:url var="returnOrder"					value="/order/returnOrder.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [orderCustomerData.js]");

	$('#saveBtn_admin_sale_order_customer_list').attr("onclick", "fnOrderUpdate()");

});

function fnOrderUpdate(){

	console.log("${sid}.fnOrderUpdate() Load");

	var orderState = $('#ORDER_STATE').val();

	if(orderState =='R'){
		opener.$('#admin_sale_order_customer_list_back_btn').show();
	} else {
		opener.$('#admin_sale_order_customer_list_back_btn').hide();
	}

	if(orderState =='O'){
		opener.$('#admin_sale_order_customer_list_estimate_btn').show();
	} else {
		opener.$('#admin_sale_order_customer_list_estimate_btn').hide();
	}

	if(orderState =='C'){
		opener.$('#admin_sale_order_customer_list_cancel_btn').hide();
	} else {
		opener.$('#admin_sale_order_customer_list_cancel_btn').show();
	}
}

</script>
