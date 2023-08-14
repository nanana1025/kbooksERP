<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>

<style>
</style>

<script>

$(document).ready(function() {

	console.log("load [productSelectableInventory.js]");

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
			INVENTORY_ID : selItem.inventory_id,
			COMPONENT_CD : selItem.component_cd,
			MODEL_NM : selItem.model_nm,
			SPEC_NM : selItem.spec_nm,
			LOCATION : selItem.location
		};


	if(selItem.lock_yn == 'Y'){
		//시작지점
		$("<div></div>").kendoConfirm({
			buttonLayout: "stretched",
			actions: [{
				text: '계속',
				action: function(e){

					opener.$('#BARCODE').val(params.BARCODE);
					opener.$('#INVENTORY_ID').val(params.INVENTORY_ID);
					opener.$('#MODEL_NM').val(params.MODEL_NM);
					opener.$('#SPEC_NM').val(params.SPEC_NM);

				    opener.$('#COMPONENT_CD').val(params.COMPONENT_CD);
				    const value = opener.$('#COMPONENT_CD option:selected').text();
				    opener.$('#COMPONENT_CD').siblings()[0].children[0].textContent = value;

				    opener.$('#LOCATION').val(params.LOCATION);
				    const value1 = opener.$('#LOCATION option:selected').text();
				    opener.$('#LOCATION').siblings()[0].children[0].textContent = value1;

				 	self.close();
				}
			},
			{
				text: '취소',
				action: function(e){
					return;
				}
			}],
			minWidth : 200,
			title: fnGetSystemName(),
		    content: "선택한 재고는 현재 출고 목록에 있습니다. 그래도 선택하시겠습니까?"
		}).data("kendoConfirm").open();
		//끝지점
	}else{
		opener.$('#BARCODE').val(params.BARCODE);
		opener.$('#INVENTORY_ID').val(params.INVENTORY_ID);
		opener.$('#MODEL_NM').val(params.MODEL_NM);
		opener.$('#SPEC_NM').val(params.SPEC_NM);

	    opener.$('#COMPONENT_CD').val(params.COMPONENT_CD);
	    const value = opener.$('#COMPONENT_CD option:selected').text();
	    opener.$('#COMPONENT_CD').siblings()[0].children[0].textContent = value;

	    opener.$('#LOCATION').val(params.LOCATION);
	    const value1 = opener.$('#LOCATION option:selected').text();
	    opener.$('#LOCATION').siblings()[0].children[0].textContent = value1;

	 	self.close();
	}
}

</script>
