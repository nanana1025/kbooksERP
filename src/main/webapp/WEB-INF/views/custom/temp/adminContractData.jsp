<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<style></style>
<script>
	$(document).ready(function() {
		setTimeout(function() {
			fnSetHospitalId()
		}, 1000);
	});

	function fnSetHospitalId() {
		var grid = opener.$('#admin_hospital_contract_list_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		if(selItem)
			$('#hospital_id').val(selItem.hospital_id);
	}
</script>
