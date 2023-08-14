<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="companyUpdate"					value="/user/companyUpdate.json" />
<c:url var="dataList"					value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [CompanyDetail.js]");
	// $('.basicBtn').remove();
	 $('#saveBtn_company_data').remove();

	 var infCond = '<button id="updateBtn_${sid}" onclick="fnCompanyUpdate()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';

	 	$('#${sid}_view-btns').prepend(infCond);

});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}

function fnCompanyUpdate() {

	console.log("CompanyList.fnCompanyUpdate() Load");

	var url = '${companyUpdate}';
	var params = "";

	params = {
			COMPANY_ID: $('#COMPANY_ID').val(),
			COMPANY_NM: $('#COMPANY_NM').val(),
			COMPANY_CD: $('#COMPANY_CD').val(),
			COMPANY_TYPE: $('#COMPANY_TYPE').val(),
			TEL: $('#TEL').val(),
			ADDRESS: $('#ADDRESS').val(),
			CHIEF_NM: $('#CHIEF_NM').val(),
			COMPANY_NO: $('#COMPANY_NO').val(),
			ACCOUNT_BANK_NM: $('#ACCOUNT_BANK_NM').val(),
			ACCOUNT: $('#ACCOUNT').val(),
			DEL_YN: $('#DEL_YN').val()
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
	    content: "업체 정보를 저장하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
