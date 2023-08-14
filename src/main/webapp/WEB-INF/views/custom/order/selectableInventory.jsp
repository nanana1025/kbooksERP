<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>

<style>
</style>

<script>

$(document).ready(function() {

	console.log("load [selectableInventory.js]");

	//$('.basicBtn').remove();
	//$('#selectBtn').remove();
	$('#${sid}_gridbox').off('dblclick');

	setTimeout(function() {
//	 	$('#selectBtn').removeAttr("onclick");
		$('#selectBtn').attr("onclick", "fnCustomSelect();");

	  	}, 500);

	setTimeout(function() {
// 	$('#selectBtn').removeAttr("onclick");
	$('#selectBtn').attr("onclick", "fnCustomSelect();");

  	}, 1000);

});


function fnCustomSelect(){

	console.log("Function fnCustomSelect()");

	//var url = '${selectCPU}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.');
	return;}

	var params = {
			BARCODE : selItem.barcode,
			INVENTORY_ID : selItem.inventory_id
		};

	opener.$('#BARCODE').val(params.BARCODE);
	opener.$('#INVENTORY_ID').val(params.INVENTORY_ID);

//   	opener.$('#COMPONENT_CD').val(params.COMPONENT_CD);
//     opener.$('#COMPONENT_CD').siblings('.k-formatted-value').val(params.COMPONENT_CD);

//     opener.$('#COMPONENT_CD').val(params.COMPONENT_CD);
//     const value = opener.$('#COMPONENT_CD option:selected').text();
//     opener.$('#COMPONENT_CD').siblings()[0].children[0].textContent = value;

//     opener.$('#REGISTER_DT').val(params.REGISTER_DT);


	self.close();
}

</script>
