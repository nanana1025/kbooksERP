<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>



$(document).ready(function() {

	console.log("load [palletProcess.js]");

	console.log("pid = ${pid}");

	var grid = opener.$('#${pid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	setTimeout(function() {
		$("#WAREHOUSE_ID").val(selItem.warehouse_id);
	}, 1000);

});

function fuChangeDivWidth(){


}

</script>
