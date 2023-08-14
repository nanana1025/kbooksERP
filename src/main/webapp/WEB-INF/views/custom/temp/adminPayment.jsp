<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlCancelPaymentJson"			value="/charging/cancelPayment.json" />
<c:url var="urlPartialCancellationPopup"	value="/charging/partialCancellationPopup.do" />
<c:url var="urlRepayJson"					value="/charging/repay.json" />
<c:url var="urlCancelRepayJson"				value="/charging/cancelRepay.json" />

<style></style>
<script>
	$(document).ready(function() {
		$('.basicBtn').remove();
		//$('#admin_payment_user_list_gridbox, #admin_payment_hist_list_gridbox, #admin_payment_voucher_list_gridbox').off('dblclick');
	});

	function fnCancelFullPayment() {
		var grid = $('#admin_payment_hist_list_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		var checkSelectMessage = '결제 전체 취소할 이력을 선택해 주세요.';
		var checkPayStatusMessage = '결제상태가 완료인 이력만 결제 전체취소가 가능합니다.';
		var payStatus = 'S';
		if(fnCheckSelectItem(selItem, checkSelectMessage) && fnCheckPayStatus(selItem, checkPayStatusMessage, payStatus)) {
			var url = '${urlCancelPaymentJson}';
			var params = {
				LICENSE_ID: selItem.license_id,
				MATRON_ID: selItem.matron_id,
				TID: selItem.regular_payment_no,
				PAY_CYCLE_CD: selItem.pay_cycle_cd,
				CancelAmt: selItem.total_amount,
				partialCancelCode: 0
			};

			$.post(url, params, function(data) {
				if(data) {
					alert(data.resultMsg);
					if(data.success) {
						fnObj('LIST_${sid}').reloadGrid();
					}
				}
			});
		}
	}

	function fnCancelPartPayment() {
		var grid = $('#admin_payment_hist_list_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		var checkSelectMessage = '결제 부분 취소할 이력을 선택해 주세요.';
		var checkPayStatusMessage = '결제상태가 완료인 이력만 결제 부분취소가 가능합니다.';
		var payStatus = 'S';
		if(fnCheckSelectItem(selItem, checkSelectMessage) && fnCheckPayStatus(selItem, checkPayStatusMessage, payStatus)) {
			var totalAmountView = selItem.total_amount_view;
			var paymentCancellationAmountView = selItem.payment_cancellation_amount_view;
			var params = {
				LICENSE_ID: selItem.license_id,
				MATRON_ID: selItem.matron_id,
				TID: selItem.regular_payment_no,
				BUY_TYPE_CD: selItem.buy_type_cd,
				TOTAL_AMOUNT_VIEW: totalAmountView.substring(0, totalAmountView.length - 1),
				PAYMENT_CANCELLATION_AMOUNT_VIEW: paymentCancellationAmountView.substring(0, paymentCancellationAmountView.length - 1)
			};

			var width = 600;
			var height = 208;
			var xPos  = (document.body.clientWidth * 0.5) - (width * 0.5);
			xPos += window.screenLeft;
			var yPos  = (screen.availHeight * 0.5) - (height * 0.5);

			window.open("${urlPartialCancellationPopup}?" + $.param(params), "partialCancellationP", "top=" + yPos + ", left=" + xPos + ", width=" + width + ", height=" + height + ", scrollbars=1");
		}
	}

	function fnRepay() {
		var grid = $('#admin_payment_hist_list_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		var checkSelectMessage = '환불처리할 이력을 선택해 주세요.';
		var checkPayStatusMessage = '결제상태가 완료인 이력만 환불처리가 가능합니다.';
		var payStatus = 'S';
		if(fnCheckSelectItem(selItem, checkSelectMessage) && fnCheckPayStatus(selItem, checkPayStatusMessage, payStatus)) {
			var url = '${urlRepayJson}';
			var params = {
				LICENSE_ID: selItem.license_id
			};

			$.post(url, params, function(data) {
				if(data.success) {
					alert('환불처리가 성공했습니다.');
					fnObj('LIST_${sid}').reloadGrid();
				} else {
					alert('환불처리가 실패했습니다.');
				}
			});
		}
	}

	function fnCancelRepay() {
		var grid = $('#admin_payment_hist_list_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		var checkSelectMessage = '환불취소할 이력을 선택해 주세요.';
		var checkPayStatusMessage = '결제상태가 환불인 이력만 환불취소가 가능합니다.';
		var payStatus = 'R';
		if(fnCheckSelectItem(selItem, checkSelectMessage) && fnCheckPayStatus(selItem, checkPayStatusMessage, payStatus)) {
			var url = '${urlCancelRepayJson}';
			var params = {
				LICENSE_ID: selItem.license_id
			};

			$.post(url, params, function(data) {
				if(data.success) {
					alert('환불취소가 성공했습니다.');
					fnObj('LIST_${sid}').reloadGrid();
				} else {
					alert('환불취소가 실패했습니다.');
				}
			});
		}
	}

	function fnCheckSelectItem(selItem, message) {
		if(!selItem) {
			alert(message);
			return false;
		}

		return true;
	}

	function fnCheckPayStatus(selItem, message, payStatus) {
		var flag = false;

		if(selItem) {
			var selectPayStatus = selItem.pay_status_cd;
			if(selectPayStatus == payStatus) {
				flag = true;
			} else {
				alert(message);
			}
		}

		return flag;
	}
</script>
