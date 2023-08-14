<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>

<style>
</style>

<script>

$(document).ready(function() {

	console.log("load [componentList.js]");

	//$('.basicBtn').remove();
	//$('#selectBtn').remove();
	$('#component_list_gridbox').off('dblclick');

	setTimeout(function() {
	$('#selectBtn').removeAttr("onclick");
	$('#selectBtn').attr("onclick", "fnCustomSelect();");

  	}, 1000);

});


function fnCustomSelect(){

	console.log("Function fnCustomSelect()");

	//var url = '${selectCPU}';

	var grid = $('#component_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.');
	return;}

	var params = {
			MODEL_NM : selItem.model_nm,
			SPEC_NM : selItem.spec_nm,
			COMPONENT_CD : selItem.component_cd,
 			COMPONENT : selItem.component,
			COMPONENT_ID : selItem.component_id,
 			MANUFACTURE_NM: selItem.manufacture_nm
		};

	opener.$('#COMPONENT_ID').val(params.COMPONENT_ID);
	opener.$('#COMPONENT').val(params.COMPONENT);
	opener.$('#MODEL_NM').val(params.MODEL_NM);
	opener.$('#SPEC_NM').val(params.SPEC_NM);
	opener.$('#CNT').val(1);
	opener.$('#CNT').siblings('.k-formatted-value').val(1);
	opener.$('#COMPONENT_CD').val(params.COMPONENT_CD);
	const value = opener.$('#COMPONENT_CD option:selected').text();
	opener.$('#COMPONENT_CD').siblings()[0].children[0].textContent = value;
	opener.$('#MANUFACTURE_NM').val(params.MANUFACTURE_NM);

	self.close();
}

</script>
