<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="customerUpdate"					value="/user/customerUpdate.json" />
<c:url var="dataList"					value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [CustomerDetail.js]");
	// $('.basicBtn').remove();
	 $('#saveBtn_customer_data').remove();

	 var infCond = '<button id="updateBtn_${sid}" onclick="fnCustomerUpdate()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';

	 	$('#${sid}_view-btns').prepend(infCond);

});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}

function fnCustomerUpdate() {

	console.log("CustomerList.fnCustomerUpdate() Load");

	var url = '${customerUpdate}';
	var params = "";

	params = {
            CUSTOMER_ID: $('#CUSTOMER_ID').val(),
            CUSTOMER_NM: $('#CUSTOMER_NM').val(),
            CUSTOMER_TYPE: $('#CUSTOMER_TYPE').val(),
            CUSTOMER_STATE: $('#CUSTOMER_STATE').val(),
            CUSTOMER_GRADE: $('#CUSTOMER_GRADE').val(),
            ADDRESS: $('#ADDRESS').val(),
            BANK_NM: $('#BANK_NM').val(),
            ACCOUNT_NO: $('#ACCOUNT_NO').val(),
            DEL_YN: $('#DEL_YN').val(),
            TEL: $('#TEL').val(),
            MOBILE: $('#MOBILE').val(),
	};

	var isSuccess = false;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

						$.ajax({
							url : url,
							type : "POST",
							data : params,
							async : false,
							success : function(data) {
								if(data.success){
									GochigoAlert(data.MSG);
									isSuccess = true;
								}
								else
									GochigoAlert(data.MSG);
							}
						});

						if(isSuccess)
				                fnDropBoxonChange();

	//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "고객 정보를 저장하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
