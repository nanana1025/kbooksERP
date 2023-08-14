<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [priceUpdate.jsp]");

 	setTimeout(function() {
  		var openerGrid = opener.$('#consigned_component_list_gridbox').data('kendoGrid');
		var openerSelItem = openerGrid.dataItem(openerGrid.select());

		var companyId = openerSelItem.company_id;

		if(companyId == "") {
			GochigoAlert("업체명을 가져올수 없습니다. 다시 시도해 주세요.", true, "dangol365 ERP");
		}

		$('#COMPANY_ID').val(companyId);

 	}, 500);
});

</script>
