<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />



<style>
</style>
<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>
<script>

$(document).ready(function() {

	console.log("load [compVGAList.js]");

	//$('.basicBtn').remove();
	//$('#selectBtn').remove();
	$('#VGA_list_list_gridbox').off('dblclick');


	setTimeout(function() {
		$('.basicBtn').remove();
		$('#selectBtn').remove();

		var infCond = '<button id="customSelectBtn" class="k-button" onclick="fnCustomSelect()" data-role="button" role="button" aria-disabled="false" tabindex="0">선택</button>';

		$('#popup_btns').prepend(infCond);
		opener.$('#COMPONENT_ID').attr("class", "include")

	}, 1000);
});

function fnCustomSelect(){
	console.log("Function fnCustomSelect()");

	//var url = '${selectCPU}';

	var grid = $('#VGA_list_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
			DATA_ID : selItem.data_id,
			COMPONENT_ID: selItem.component_id,
			MANUFACTURE_NM: selItem.manufacture_nm,
			REVISION: selItem.revision,
			CODE_NM: selItem.code_nm,
			CODE_FAMILY_NM: selItem.code_family_nm,
			MEM_TYPE: selItem.mem_type,
			CAPACITY: selItem.capacity,
			BANDWIDTH: selItem.bandwidth,
			MODEL_NM: selItem.model_nm,
			TECH_NM: selItem.tech_nm,
			VENDOR_NM: selItem.vendor_nm
		};

	opener.$('#COMPONENT_ID').val(params.COMPONENT_ID);
	opener.$('#MODEL_NM').val(params.MODEL_NM);
	opener.$('#MANUFACTURE_NM').val(params.MANUFACTURE_NM);
	opener.$('#REVISION').val(params.REVISION);
	opener.$('#CODE_NM').val(params.CODE_NM);
	opener.$('#CODE_FAMILY_NM').val(params.CODE_FAMILY_NM);
	opener.$('#MEM_TYPE').val(params.MEM_TYPE);
	opener.$('#CAPACITY').val(params.CAPACITY);
	opener.$('#BANDWIDTH').val(params.BANDWIDTH);
	opener.$('#TECH_NM').val(params.TECH_NM);
	opener.$('#TECH_NM').siblings('.k-formatted-value').val(params.TECH_NM);
	opener.$('#VENDOR_NM').val(params.VENDOR_NM);
// 	opener.$('#MAX_MEM').siblings('.k-formatted-value').val(params.MAX_MEM);


	opener.$('#MENU_CATEGORY').val("IVT");
	opener.$('#TYPE_CD').val("IVT");
	opener.$('#COMPONENT_ID').attr("class", "include")

	//console.log(params);

	self.close();
}

</script>
