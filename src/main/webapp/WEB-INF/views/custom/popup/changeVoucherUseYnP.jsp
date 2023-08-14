<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlChangeUseYnJson"	value="/charging/changeUseYn.json" />

<!DOCTYPE html>
<html>
<head>
<title>이용권 사용 여부 변경</title>
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
		$("#USE_YN").kendoDropDownList({value: $('#VIEW_USE_YN').val()});
    });

	function fnChangeUseYn() {
		var url = '${urlChangeUseYnJson}';
		var params = {
			VOUCHER_ID: $('#VOUCHER_ID').val(),
			USE_YN: $('#USE_YN').val()
		};

		$.post(url, params, function(data) {
			if(data) {
				if(data.success) {
					alert('이용권 사용여부가 변경됐습니다.');
					opener.fnReloadGrid();
					fnClose();
				} else {
					alert('이용권 사용여부 변경이 실패했습니다.');
				}
			}
		});
	}

	function fnClose() {
		self.close();
	}
</script>
</head>
<body>
<div id="popContainer">
	<div id="partial_cancellation_header_title" class="header_title">
		<span class="pagetitle"><span class="k-icon k-i-copy"></span>이용권 사용 여부</span>
	</div>
	<div class="content">
		<div id="partial_cancellation_view-btns" class="view_btns">
			<button id="saveBtn" class="k-button" onclick="fnChangeUseYn();">변경</button>
			<button id="cancelBtn" class="k-button" onclick="fnClose();">취소</button>
		</div>
		<fieldSet class="fieldSet">
			<input type="hidden" id="FILE_COL" name="FILE_COL" value=""/>
			<input type="hidden" id="VOUCHER_ID" name="VOUCHER_ID" value="${param.VOUCHER_ID}"/>
			<input type="hidden" id="VIEW_USE_YN" name="VIEW_USE_YN" value="${view.USE_YN}"/>
			<table id="cancel-amt-table">
				<colgroup width="600px">
					<col width="100px"/>
					<col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<td style="text-align: right;">결제번호</td>
						<td><input type="text" id="PAYMENT_NO" class="PAYMENT_NO k-textbox" style="width: 100%;" value="${view.PAYMENT_NO}" disabled="disabled" /></td>
					</tr>
					<tr>
						<td style="text-align: right;">이용권번호</td>
						<td><input type="text" id="VOUCHER_NO" class="VOUCHER_NO k-textbox" style="width: 100%;" value="${view.VOUCHER_NO}" disabled="disabled" /></td>
					</tr>
					<tr>
						<td style="text-align: right;">간호사 수</td>
						<td><input type="text" id="NURSE_CNT_NM" class="NURSE_CNT_NM k-textbox" style="width: 100%;" value="${view.NURSE_CNT_NM}" disabled="disabled" /></td>
					</tr>
					<tr>
						<td style="text-align: right;">근무확정 월</td>
						<td><input type="text" id="CONFIRM_DATE" class="CONFIRM_DATE k-textbox" style="width: 100%;" value="${view.CONFIRM_DATE}" disabled="disabled" /></td>
					</tr>
					<tr>
						<td style="text-align: right;">사용일자</td>
						<td><input type="text" id="UPDATE_DT" class="UPDATE_DT k-textbox" style="width: 100%;" value="${view.UPDATE_DT}" disabled="disabled" /></td>
					</tr>
					<tr>
						<td style="text-align: right;">사용여부</td>
						<td>
							<select id="USE_YN" name="USE_YN" style="width: 100%;">
								<option value="N">미사용</option>
								<option value="Y">사용</option>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
		</fieldSet>
	</div>
</div>
</body>
</html>
