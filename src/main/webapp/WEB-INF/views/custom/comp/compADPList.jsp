<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />



<style>
</style>
<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>
<script>

$(document).ready(function() {

	console.log("load [compADPList.js]");

	//$('.basicBtn').remove();
	//$('#selectBtn').remove();
	$('#ADP_list_list_gridbox').off('dblclick');


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

	var grid = $('#ADP_list_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
			DATA_ID : selItem.data_id,
			COMPONENT_ID: selItem.component_id,
			MANUFACTURE_NM: selItem.manufacture_nm,
			OUTPUT_AMPERE: selItem.output_ampere,
			OUTPUT_TYPE: selItem.output_type,
			OUTPUT_WATT: selItem.output_watt,
			CLASS_NM: selItem.class_nm
		};

	opener.$('#COMPONENT_ID').val(params.COMPONENT_ID);
	opener.$('#MODEL_NM').val(params.MODEL_NM);
	opener.$('#MANUFACTURE_NM').val(params.MANUFACTURE_NM);
	opener.$('#OUTPUT_AMPERE').val(params.OUTPUT_AMPERE);
	opener.$('#OUTPUT_AMPERE').siblings('.k-formatted-value').val(params.OUTPUT_AMPERE);
	opener.$('#OUTPUT_TYPE').val(params.OUTPUT_TYPE);
	opener.$('#OUTPUT_WATT').val(params.OUTPUT_WATT);
	opener.$('#OUTPUT_WATT').siblings('.k-formatted-value').val(params.OUTPUT_WATT);
	opener.$('#CLASS_NM').val(params.CLASS_NM);

// 	opener.$('#MAX_MEM').siblings('.k-formatted-value').val(params.MAX_MEM);


	opener.$('#MENU_CATEGORY').val("IVT");
	opener.$('#TYPE_CD').val("IVT");
	opener.$('#COMPONENT_ID').attr("class", "include")

	//console.log(params);

	self.close();
}

</script>
