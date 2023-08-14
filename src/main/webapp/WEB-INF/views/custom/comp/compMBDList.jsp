<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />



<style>
</style>
<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>
<script>

$(document).ready(function() {

	console.log("load [compMBDist.js]");

	//$('.basicBtn').remove();
	//$('#selectBtn').remove();
	$('#MBD_list_list_gridbox').off('dblclick');


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

	var grid = $('#MBD_list_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
			DATA_ID : selItem.data_id,
			COMPONENT_ID: selItem.component_id,
			MANUFACTURE_NM: selItem.manufacture_nm,
			NB_NM: selItem.nb_nm,
			SB_NM: selItem.sb_nm,
			MEM_TYPE: selItem.mem_type,
			MAX_MEM: selItem.max_mem,
			SKU_NM: selItem.sku_nm,
			FAMILY_NM: selItem.family_nm
		};

	opener.$('#COMPONENT_ID').val(params.COMPONENT_ID);
	opener.$('#MANUFACTURE_NM').val(params.MANUFACTURE_NM);
	opener.$('#NB_NM').val(params.NB_NM);
	opener.$('#SB_NM').val(params.SB_NM);
	opener.$('#MEM_TYPE').val(params.MEM_TYPE);
	opener.$('#MAX_MEM').val(params.MAX_MEM);
	opener.$('#MAX_MEM').siblings('.k-formatted-value').val(params.MAX_MEM);
	opener.$('#SKU_NM').val(params.SKU_NM);
	opener.$('#FAMILY_NM').val(params.THREAD_CNT);

	opener.$('#MENU_CATEGORY').val("IVT");
	opener.$('#TYPE_CD').val("IVT");
	opener.$('#COMPONENT_ID').attr("class", "include")

	//console.log(params);

	self.close();
}

</script>
