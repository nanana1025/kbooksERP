<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlInsertVoucherJson"	value="/charging/insertVoucher.json" />

<!DOCTYPE html>
<html>
<head>
<title>이용권 등록</title>
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
		$("#NURSE_CNT_CD").kendoDropDownList();

 		$('#VOUCHER_CNT').on('keyup', function(e) {
 			removeChar(e);
 		});
    });

	function fnInsertVoucher() {
		if(!$('#VOUCHER_CNT').val()) {
			alert('이용권 추가 개수를 입력해 주세요.');
			return;
		}

		var url = '${urlInsertVoucherJson}';
		var params = {
			LICENSE_ID: $('#LICENSE_ID').val(),
			MATRON_ID: $('#MATRON_ID').val(),
			PAYMENT_NO: $('#PAYMENT_NO').val(),
			NURSE_CNT_CD: $('#NURSE_CNT_CD').val(),
			VOUCHER_CNT: $('#VOUCHER_CNT').val()
		};

		$.post(url, params, function(data) {
			if(data) {
				if(data.success) {
					alert('이용권이 추가됐습니다.');
					opener.fnReloadGrid();
					fnClearParams();
					fnClose();
				} else {
					alert('이용권 추가에 실패했습니다.');
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
		<span class="pagetitle"><span class="k-icon k-i-copy"></span>이용권 등록</span>
	</div>
	<div class="content">
		<div id="partial_cancellation_view-btns" class="view_btns">
			<button id="saveBtn" class="k-button" onclick="fnInsertVoucher();">이용권 추가</button>
			<button id="cancelBtn" class="k-button" onclick="fnClose();">취소</button>
		</div>
		<fieldSet class="fieldSet">
			<input type="hidden" id="FILE_COL" name="FILE_COL" value=""/>
			<input type="hidden" id="LICENSE_ID" name="LICENSE_ID" value="${param.LICENSE_ID}"/>
			<input type="hidden" id="MATRON_ID" name="MATRON_ID" value="${param.MATRON_ID}"/>
			<table id="cancel-amt-table">
				<colgroup width="800px">
					<col width="150px"/>
					<col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<td style="text-align: right;">결제번호</td>
						<td><input type="text" id="PAYMENT_NO" class="PAYMENT_NO k-textbox" style="width: 100%;" value="${param.PAYMENT_NO}" disabled="disabled" /></td>
					</tr>
					<tr>
						<td style="text-align: right;">간호사 수</td>
						<td>
							<select id="NURSE_CNT_CD" class="NURSE_CNT_CD" style="width: 100%;">
								<c:forEach var="row" items="${NURSE_CNT_CD}">
									<option value="${row.CODE_CD}">${row.CODE_NM}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td style="text-align: right;">개수</td>
						<td><input type="text" id="VOUCHER_CNT" class="VOUCHER_CNT k-textbox" style="width: 100%;" value="" /></td>
					</tr>
				</tbody>
			</table>
		</fieldSet>
	</div>
</div>
</body>
</html>
