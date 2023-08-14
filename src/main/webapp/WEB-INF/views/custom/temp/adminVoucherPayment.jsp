<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlCancelPaymentJson"	value="/charging/cancelPayment.json" />

<style></style>
<script>
	$(document).ready(function() {
		$('.basicBtn').remove();
		$('#admin_payment_hist_list_gridbox').off('dblclick');
	});

	function fnCancelPayment() {
		var grid = $('#admin_freeuser_list_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		if(!selItem) {
			alert('결제 취소할 이력을 선택해 주세요.');
			return;
		}

		var cancelMsg = '고객 요청';
		var url = '${urlCancelPaymentJson}';
		var params = {
			LICENSE_ID: selItem.license_id,
			MATRON_ID: selItem.matron_id,
			TID: selItem.regular_payment_no,
			EXPIRY_DT: selItem.expiry_dt,
			PAY_CYCLE_CD: selItem.pay_cycle_cd,
			CancelAmt: selItem.total_amount,
			CancelMsg: cancelMsg
		};

		$.post(url, params, function(data) {
			if(data) {
				alert(data.resultMsg);
			}
		});
	}
</script>
