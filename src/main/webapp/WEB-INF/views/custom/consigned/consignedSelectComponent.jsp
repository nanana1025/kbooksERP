<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>


<script src="/codebase/gochigo.kendo.ui.js"></script>

<style>

</style>
<script>


$(document).ready(function() {

	console.log("load [consignedSelectComponent.js]");

	$('.basicBtn').remove();
	$('#${sid}_gridbox').off('dblclick');


});


function fnCustomSelect(){

	console.log("Function fnCustomSelect()");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.');
	return;}

	if(selItem.lt_custom_part_id == null || selItem.lt_custom_part_id < 1){
		GochigoAlert('매핑된 부품이 없습니다.');
		return;
	}
	var params = {
			LT_CUSTOM_PART_ID: selItem.lt_custom_part_id,
			PART_NAME : selItem.lt_part_name,
			PART_KEY : selItem.lt_part_key,
			COMPONENT_ID : selItem.component_id
		};

	opener.$('#LT_CUSTOM_PART_ID').val(params.LT_CUSTOM_PART_ID);
	opener.$('#PART_NAME').val(params.PART_NAME);
	opener.$('#PART_KEY').val(params.PART_KEY);
	opener.$('#COMPONENT_ID').val(params.COMPONENT_ID);



	self.close();
}


function fnCancel(){
	self.close();
}


</script>
