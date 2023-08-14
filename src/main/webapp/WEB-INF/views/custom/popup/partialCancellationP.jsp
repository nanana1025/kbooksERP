<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlCancelPaymentJson"	value="/charging/cancelPayment.json" />

<!DOCTYPE html>
<html>
<head>
<title>결제 부분취소</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta charset="utf-8"/>

<link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
<link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
<link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
<link rel="stylesheet" type="text/css" href="/codebase/style.css"/>
<script src="/js/jquery-1.12.4.js"></script>
<script src="/codebase/kendo/kendo.all.min.js"></script>
<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
<script src="/codebase/kendo/messages/kendo.messages.ko-KR.min.js"></script>
<script src="/codebase/common.js"></script>
<script src="/codebase/default.js"></script>
<script src="/codebase/gochigo.kendo.common.js"></script>
<script src="/codebase/gochigo.kendo.util.js"></script>
<script src="/codebase/gochigo.kendo.util.js"></script>

<style type="text/css">
#popContainer {
	background-color: #eff2f7;
	width: 100%;
	height: 100%;
}
.fieldSet {
	display: inline-block;
	margin: 10px 10px;
	background-color: #ffffff;
	border: 1px solid #d6d6d9;
}
</style>
<script type="text/javascript">
	$(document).ready(function() {
 		$('#CancelAmtView').on('keyup', function(e) {
 			removeChar(e);
 		});
    });

	function fnCancelPaymentPart() {
		if(!$('#CancelAmt').val()) {
			alert('부분취소금액을 입력해 주세요.');
			return;
		}

		var url = '${urlCancelPaymentJson}';
		var params = {
			LICENSE_ID: $('#LICENSE_ID').val(),
			MATRON_ID: $('#MATRON_ID').val(),
			TID: $('#TID').val(),
			CancelAmt: $('#CancelAmt').val(),
			PayMethod: fnGetPayMethod(),
			partialCancelCode: 1
		};

		$.post(url, params, function(data) {
			if(data) {
				alert(data.resultMsg);
				if(data.success) {
					opener.fnObj('LIST_${sid}').reloadGrid();
					fnClose();
				}
			}
		});
	}

	function fnGetPayMethod() {
		var payMethod;
		var buyTypeCd = $('#BUY_TYPE_CD').val();
		if(buyTypeCd == 'C')
			payMethod = 'CARD';
		else if(buyTypeCd == 'D')
			payMethod = 'BANK';

		return payMethod;
	}

	function fnClose() {
		self.close();
	}
</script>
</head>
<body>
<div id="popContainer">
	<div id="partial_cancellation_header_title" class="header_title">
		<span class="pagetitle"><span class="k-icon k-i-copy"></span>결제 부분취소</span>
	</div>
	<div class="content">
		<div id="partial_cancellation_view-btns" class="view_btns">
			<button id="saveBtn" class="k-button" onclick="fnCancelPaymentPart();">결제 부분취소</button>
			<button id="cancelBtn" class="k-button" onclick="fnClose();">취소</button>
		</div>
		<fieldSet class="fieldSet">
			<input type="hidden" id="FILE_COL" name="FILE_COL" value=""/>
			<input type="hidden" id="LICENSE_ID" name="LICENSE_ID" value="${param.LICENSE_ID}"/>
			<input type="hidden" id="MATRON_ID" name="MATRON_ID" value="${param.MATRON_ID}"/>
			<input type="hidden" id="TID" name="TID" value="${param.TID}"/>
			<input type="hidden" id="BUY_TYPE_CD" name="BUY_TYPE_CD" value="${param.BUY_TYPE_CD}"/>
			<input type="hidden" id="CancelAmt" class="CancelAmt" value="" />
			<table id="cancel-amt-table">
				<colgroup width="600px">
					<col width="150px"/>
					<col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<td style="text-align: right;">결제금액(원)</td>
						<td><input type="text" id="amt" class="amt k-textbox" style="width: 100%;" value="${param.TOTAL_AMOUNT_VIEW}" disabled="disabled" /></td>
					</tr>
					<tr>
						<td style="text-align: right;">결제취소금액(원)</td>
						<td><input type="text" id="amt" class="amt k-textbox" style="width: 100%;" value="${param.PAYMENT_CANCELLATION_AMOUNT_VIEW}" disabled="disabled" /></td>
					</tr>
					<tr>
						<td style="text-align: right;">부분취소금액(원)</td>
						<td><input type="text" id="CancelAmt" class="CancelAmtView k-textbox" style="width: 100%;" value="" /></td>
					</tr>
				</tbody>
			</table>
		</fieldSet>
	</div>
</div>
</body>
</html>
