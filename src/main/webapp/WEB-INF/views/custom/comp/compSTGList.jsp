<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />



<style>
</style>
<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>
<script>

$(document).ready(function() {

	console.log("load [compSTGList.js]");

	$('.basicBtn').remove();
	$('#selectBtn').remove();
	$('#STG_list_list_gridbox').off('dblclick');


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

	var grid = $('#STG_list_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
			DATA_ID : selItem.data_id,
			COMPONENT_ID: selItem.component_id,
			MANUFACTURE_NM: selItem.manufacture_nm,
			MODEL_NM: selItem.model_nm,
			REVISION: selItem.revision,
			CAPACITY: selItem.capacity,
			STG_TYPE: selItem.stg_type,
			BUS_TYPE: selItem.bus_type,
			BANDWIDTH: selItem.bandwidth,
			SPEED: selItem.speed,
			FEATURE: selItem.feature,
		};

	opener.$('#COMPONENT_ID').val(params.COMPONENT_ID);
	opener.$('#MODEL_NM').val(params.MODEL_NM);
	opener.$('#MANUFACTURE_NM').val(params.MANUFACTURE_NM);
	opener.$('#MODEL_NM').val(params.MODEL_NM);
	opener.$('#REVISION').val(params.REVISION);
	opener.$('#CAPACITY').val(params.CAPACITY);
	opener.$('#STG_TYPE').val(params.STG_TYPE);
	opener.$('#BUS_TYPE').val(params.BUS_TYPE);
	opener.$('#BANDWIDTH').val(params.BANDWIDTH);
	opener.$('#BANDWIDTH').siblings('.k-formatted-value').val(params.BANDWIDTH);
	opener.$('#SPEED').val(params.SPEED);
	opener.$('#FEATURE').val(params.FEATURE);
// 	opener.$('#MAX_MEM').siblings('.k-formatted-value').val(params.MAX_MEM);


	opener.$('#MENU_CATEGORY').val("IVT");
	opener.$('#TYPE_CD').val("IVT");
	opener.$('#COMPONENT_ID').attr("class", "include")

	//console.log(params);

	self.close();
}

</script>
