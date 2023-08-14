<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="companyComponentInsert"				value="/consigned/companyComponentInsert.json"/>

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

var _key = getParameterByName('KEY');
var _listCompanyId = getParameterByName('VALUE');

$(document).ready(function() {

	console.log("load [companyList.js]");
	$('.basicBtn').remove();

	setTimeout(function() {
		 $('#${sid}_gridbox').off('dblclick');
	}, 1000);


});




function fnCompanyComponentInsert() {

	console.log("companyList.fnCompanyComponentInsert() Load");
	var url = '${companyComponentInsert}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	 var params = {
			 COMPONENT_ID: _listCompanyId
	        };


	//시작지점
		$("<div></div>").kendoConfirm({
			buttonLayout: "stretched",
			actions: [{
				text: '확인',
				action: function(e){
					//시작지점

					 var listCompanyId = [];
					 rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 listCompanyId.push(gridData.company_id);
					 });

					 params.COMPANY_ID = listCompanyId.toString();

						$.ajax({
							url : url,
							type : "POST",
							data : params,
							async : false,
							success : function(data) {
								if(data.SUCCESS){
									GochigoAlert(data.MSG, true, "dangol365 erp");
								}
								else{
									GochigoAlert(data.MSG);
								}
							}
						});

						//끝지점
				}
			},
			{
				text: '닫기'
			}],
			minWidth : 200,
			title: fnGetSystemName(),
		    content: "선택한 업체에 부품 정보를 추가하시겠습니까?"
		}).data("kendoConfirm").open();
		//끝지점
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}


</script>
