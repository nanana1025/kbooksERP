<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />



<style>
</style>
<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>
<script>

$(document).ready(function() {

	console.log("load [onlyPrint.js]");

	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();
	$('#${sid}_printBtn').remove();
	$('#${sid}_gridbox').off('dblclick');


	setTimeout(function() {
// 		$('.basicBtn').remove();
// 		$('#selectBtn').remove();

// 		var infCond = '<button id="customSelectBtn" class="k-button" onclick="fnCustomSelect()" data-role="button" role="button" aria-disabled="false" tabindex="0">선택</button>';

// 		$('#popup_btns').prepend(infCond);
// 		opener.$('#COMPONENT_ID').attr("class", "include")

	}, 1000);
});

function fnclose(){
	self.opener = self;
	window.close();
}

function fnSelectInventory(){

	console.log("${sid}.fnSelectInventory() Load");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				 rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);

						opener.fnAddInventoryExternal(gridData.barcode);

					 });

				 opener.fnInitConsignedReleaseInventory();
				 fnObj('LIST_${sid}').reloadGrid();
				 GochigoAlert('부품이 추가되었습니다.');
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택한 재고를 출고 부품에 추가하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점

}

</script>
