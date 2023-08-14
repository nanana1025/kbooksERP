<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />



<style>
</style>
<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>
<script>

$(document).ready(function() {

	console.log("load [compCPUList.js]");

	//$('.basicBtn').remove();
	//$('#selectBtn').remove();
	$('#CPU_list_list_gridbox').off('dblclick');


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

	var grid = $('#CPU_list_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
			DATA_ID : selItem.data_id,
			COMPONENT_ID: selItem.component_id,
			MANUFACTURE_NM: selItem.manufacture_nm,
			SPEC_NM: selItem.spec_nm,
			MODEL_NM: selItem.model_nm,
			SOCKET_NM: selItem.socket_nm,
			CODE_NM: selItem.code_nm,
			CORE_CNT: selItem.core_cnt,
			THREAD_CNT: selItem.thread_cnt
		};

	opener.$('#COMPONENT_ID').val(params.COMPONENT_ID);
	opener.$('#MANUFACTURE_NM').val(params.MANUFACTURE_NM);
	opener.$('#SPEC_NM').val(params.SPEC_NM);
	opener.$('#MODEL_NM').val(params.MODEL_NM);
	opener.$('#SOCKET_NM').val(params.SOCKET_NM);
	opener.$('#CODE_NM').val(params.CODE_NM);
	opener.$('#CORE_CNT').val(params.CORE_CNT);
	opener.$('#CORE_CNT').siblings('.k-formatted-value').val(params.CORE_CNT);
	opener.$('#THREAD_CNT').val(params.THREAD_CNT);
	opener.$('#THREAD_CNT').siblings('.k-formatted-value').val(params.THREAD_CNT);

	opener.$('#MENU_CATEGORY').val("IVT");
	opener.$('#TYPE_CD').val("IVT");
	opener.$('#COMPONENT_ID').attr("class", "include")

	//console.log(params);

	self.close();
}

</script>
