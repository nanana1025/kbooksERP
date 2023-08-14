<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlChangeContractJson"	value="/user/changeContract.json" />

<!DOCTYPE html>
<html>
<head>
<title>계약 여부 변경</title>
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
		 $("#CONTRACT_YN").kendoDropDownList({
             dataTextField: "text",
             dataValueField: "value",
             dataSource: [{text:"미계약", value:"N"},{text:"계약",value:"Y"}],
             value: $('#PARAM_CONTRACT_YN').val()
         });
    });

	function fnChangeContract() {
		var url = '${urlChangeContractJson}';
		var params = {
			HOSPITAL_ID: $('#HOSPITAL_ID').val(),
			CONTRACT_YN: $('#CONTRACT_YN').val()
		};

		$.post(url, params, function(data) {
			if(data) {
				if(data.success) {
					alert('계약여부가 변경됐습니다.');
					opener.fnReloadGrid();
					fnClose();
				} else {
					alert('계약여부 변경이 실패했습니다.');
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
		<span class="pagetitle"><span class="k-icon k-i-copy"></span>계약 여부</span>
	</div>
	<div class="content">
		<div id="partial_cancellation_view-btns" class="view_btns">
			<button id="saveBtn" class="k-button" onclick="fnChangeContract();">변경</button>
			<button id="cancelBtn" class="k-button" onclick="fnClose();">취소</button>
		</div>
		<fieldSet class="fieldSet">
			<input type="hidden" id="FILE_COL" name="FILE_COL" value=""/>
			<input type="hidden" id="HOSPITAL_ID" name="HOSPITAL_ID" value="${param.HOSPITAL_ID}"/>
			<input type="hidden" id="PARAM_CONTRACT_YN" name="PARAM_CONTRACT_YN" value="${param.CONTRACT_YN}"/>
			<table id="cancel-amt-table">
				<colgroup width="600px">
					<col width="100px"/>
					<col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<td style="text-align: right;">병원명</td>
						<td><input type="text" id="HOSPITAL_NM" class="HOSPITAL_NM k-textbox" style="width: 100%;" value="${param.HOSPITAL_NM}" disabled="disabled" /></td>
					</tr>
					<tr>
						<td style="text-align: right;"><span class="requiredDot">* </span>계약여부</td>
						<td>
            				<input id="CONTRACT_YN" style="width: 100%;" />
						</td>
					</tr>
				</tbody>
			</table>
		</fieldSet>
	</div>
</div>
</body>
</html>
