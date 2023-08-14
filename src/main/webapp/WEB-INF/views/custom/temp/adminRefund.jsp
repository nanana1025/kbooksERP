<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlInsertRefund"	value="/charging/insertRefund.json" />
<c:url var="urlUpdateRefund"	value="/charging/updateRefund.json" />

<style></style>
<script>
	$(document).ready(function() {
		var $saveBtn = $('#saveBtn_admin_refund_list');
		$saveBtn.off('click');
		$saveBtn.on('click', function() {
			var refundId = '${param.refund_id}';
			console.log(refundId);
			if(refundId)
				fnUpdateRefund();
			else
				fnInsertRefund();
		});

		$('#withdraw_account_number, #refund_account_number').on('keyup', function(e) {
			removeChar(e);
		});
	});

	function fnInsertRefund() {
		if(fnValidate()) {
			var url = '${urlInsertRefund}';
			var params = fnGetParams();
			$.post(url, params, function(data) {
				if(data) {
					if(data.success) {
						alert('환불 이력이 등록됐습니다.');
						opener.fnObj('LIST_${sid}').reloadGrid();
						self.close();
					} else {
						alert('환불 이력 등록이 실패했습니다.');
					}
				} else {
					alert('환불 이력 등록이 실패했습니다.');
				}
			});
		}
	}

	function fnUpdateRefund() {
		if(fnValidate()) {
			var url = '${urlUpdateRefund}';
			var params = fnGetParams();
			$.post(url, params, function(data) {
				if(data) {
					if(data.success) {
						alert('환불 이력이 수정됐습니다.');
						opener.fnObj('LIST_${sid}').reloadGrid();
						self.close();
					} else {
						alert('환불 이력 수정이 실패했습니다.');
					}
				} else {
					alert('환불 이력 수정이 실패했습니다.');
				}
			});
		}
	}

	function fnValidate() {
		if(!$('#payment_no').val()) {
			alert('결제번호는 필수 입력입니다.');
			return false;
		}

		var regex = /[0-9]/g;
		var withdrawAccountNumber = $('#withdraw_account_number').val();
		if(!regex.test(withdrawAccountNumber)) {
			alert('출금계좌번호는 숫자만 입력 가능합니다.');
			return false;
		}

		var refundAccountNumber = $('#refund_account_number').val();
		if(!regex.test(refundAccountNumber)) {
			alert('환불계좌번호는 숫자만 입력 가능합니다.');
			return false;
		}

		var refundAmount = $('#refund_amount').val();
		if(!regex.test(refundAmount)) {
			alert('환불금액은 숫자만 입력 가능합니다.');
			return false;
		}

		return true;
	}

	function fnGetParams() {
		return {
			REFUND_ID: $('#refund_id').val(),
			PAYMENT_NO: $('#payment_no').val(),
			WITHDRAW_BANK_CD: $('#withdraw_bank_cd').val(),
			WITHDRAW_ACCOUNT_NUMBER: $('#withdraw_account_number').val(),
			REFUND_BANK_CD: $('#refund_bank_cd').val(),
			REFUND_ACCOUNT_HOLDER: $('#refund_account_holder').val(),
			REFUND_ACCOUNT_NUMBER: $('#refund_account_number').val(),
			REFUND_AMOUNT: $('#refund_amount').val(),
			REFUND_DT: $('#refund_dt').val()
		};
	}
</script>
