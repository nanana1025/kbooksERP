<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>

<style>
</style>

<script>

$(document).ready(function() {

	console.log("load [inventoryList.js]");

	//$('.basicBtn').remove();
	//$('#selectBtn').remove();
	$('#inventory_list_gridbox').off('dblclick');

	setTimeout(function() {
	$('#selectBtn').removeAttr("onclick");
	$('#selectBtn').attr("onclick", "fnCustomSelect();");

  	}, 1000);

});


function fnCustomSelect(){

	console.log("Function fnCustomSelect()");

	//var url = '${selectCPU}';

	var grid = $('#inventory_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.');
	return;}

	var params = {
			MODEL_NM : selItem.model_nm,
			SPEC_NM : selItem.spec_nm,
			COMPONENT_CD : selItem.component_cd,
			BARCODE : selItem.barcode,
			INVENTORY_ID : selItem.inventory_id,
			REGISTER_DT: selItem.register_dt
		};

	opener.$('#INVENTORY_ID').val(params.INVENTORY_ID);
	opener.$('#BARCODE').val(params.BARCODE);
	opener.$('#MODEL_NM').val(params.MODEL_NM);
	opener.$('#SPEC_NM').val(params.SPEC_NM);
//   	opener.$('#COMPONENT_CD').val(params.COMPONENT_CD);
//     opener.$('#COMPONENT_CD').siblings('.k-formatted-value').val(params.COMPONENT_CD);

    opener.$('#COMPONENT_CD').val(params.COMPONENT_CD);
    const value = opener.$('#COMPONENT_CD option:selected').text();
    opener.$('#COMPONENT_CD').siblings()[0].children[0].textContent = value;

    opener.$('#REGISTER_DT').val(params.REGISTER_DT);


	self.close();
}

</script>
