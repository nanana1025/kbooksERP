<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>라이센스변경</title>
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
<script src="/codebase/moment.min.js"></script>
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
		kendoComponent();
		buttonEvent();
    });
	
    function fnClose() {
    	self.close();
    }
    
    function kendoComponent(){
    	var expDt = new Date('${view.expiry_dt}');
    	var minDt = expDt.setDate(expDt.getDate() + 1);
    	$("#extension_dt").kendoDatePicker({
    		format: 'yyyy-MM-dd',
    		culture: 'ko-KR',
    		depth: 'year',
    		start: 'year',
    	    min: new Date(minDt),
    	    change: function(){
    	    	var value = this.value();
    	    	var year = value.getFullYear();
    	    	var month = value.getMonth() + 1;
    	    	var daysInMonth = moment(year+"-"+month).daysInMonth();
    	    	var setValue = year + "-" + month + "-" + daysInMonth;
    	    	var datepicker = $("#extension_dt").data("kendoDatePicker");
    	    	datepicker.value(new Date(setValue));
    	    }
    	});
    }
    
    function buttonEvent() {
    	$('#saveBtn_change').kendoButton();
        var saveBtn = $('#saveBtn_change').data('kendoButton');
        saveBtn.bind('click', function(e) {
			var extension = $('#extension_dt').val();
			if(!extension){
				alert("연장할 유효기간을 입력해야 합니다.");
				return;
			}
			var url = "/charging/premiumuserChangeLicenseProc.json";
			var params = {
				MATRON_ID : $('#matron_id').val(),
				EXTENSION_DT : extension,
			}
			$.ajax({
				url : url,
				type : "POST",
				data : params,
				async : false,
				success : function(data) {
					if(data.success){
						alert(data.message);
						opener.fnObj('LIST_admin_premiumuser_list').reloadGrid();
						window.close();
					}
				}
			})
        });
        $('#cancelBtn_change').kendoButton();
        var cancelBtn = $('#cancelBtn_change').data('kendoButton');
        cancelBtn.bind('click', function(e) {
        	window.close();
        });
    }
	</script>
</head>
<body>
<div id="popContainer">
	<div id="freemail_header_title" class="header_title">
		<span class="pagetitle"><span class="k-icon k-i-copy"></span>라이센스변경</span>
	</div>
	<div class="content">
		<div id="freemail_view-btns" class="view_btns">
			<button id="saveBtn_change" class="">저장</button>
			<button id="cancelBtn_change">취소</button>
		</div>
		<fieldSet class="fieldSet">
			<input type="hidden" id="matron_id" name="matron_id" value="${view.matron_id}"/>
			<input type="hidden" id="user_id" name="user_id" value="${view.user_id}"/>
			<table id="tbl_freemail">
				<colgroup width="800px">
					<col width="150px"/>
					<col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<td style="text-align:right;">사용자명</td>
						<td><input type="text" id="user_nm" class="k-textbox" style="width:100%;" value="${view.user_nm}" disabled="disabled"/></td>
					</tr>
					<tr>
						<td style="text-align:right;">기존 유효기간</td>
						<td><input type="text" id="expiry_dt" class="k-textbox" style="width:100%;" value="${view.expiry_dt}" disabled="disabled"/></td>
					</tr>
					<tr>
						<td style="text-align:right;">기존 이용권번호</td>
						<td><input type="text" id="voucher_no" class="k-textbox" style="width:100%;" value="${view.voucher_no}" disabled="disabled"/></td>
					</tr>
					<tr>
						<td style="text-align:right;">결제수단</td>
						<td><input type="text" id="buy_type_nm" class="k-textbox" style="width:100%;" value="${view.buy_type_nm}" disabled="disabled"/></td>
					</tr>
					<tr>
						<td style="text-align:right;">결제주기</td>
						<td><input type="text" id="pay_cycle_nm" class="k-textbox" style="width:100%;" value="${view.pay_cycle_nm}" disabled="disabled"/></td>
					</tr>
					<tr>
						<td style="text-align:right;">연장 유효기간</td>
						<td><input type="text" id="extension_dt"/></td>
					</tr>
				</tbody>
			</table>
		</fieldSet>
	</div>
</div>
</body>
</html>