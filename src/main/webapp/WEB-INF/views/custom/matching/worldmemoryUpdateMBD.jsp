<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />
<c:url var="dataList"					value="/dataList.json" />
<c:url var="updateWorldmemoryPrice"					value="/priceMatching/updateWorldmemoryPrice.json" />



<style>
</style>
<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>
<script>

$(document).ready(function() {

	console.log("load [worldmemoeyUpdate.js]");



	//$('#saveBtn_admin_component_matching_mem_list').remove();
	//$('#cancelBtn_admin_component_matching_mem_list').remove();


	setTimeout(function() {
		window.resizeTo(784, 540);

	 	var ID = $('#PART_KEY').val();
	 	var infCond = "";
	 	var infCond1 = "";

	 	console.log(ID);

// 	 	if(ID == null || ID == "")
// 	 	{

// 	 		infCond = '<button id="insert_componet_matching_list" onclick="fnInsertComponetMatching()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';
// 	 		infCond1 = '<button id="cancelbtn_admin_component_matching_cpu_list" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">닫기</button>';

// 	 	}
// 	 	else
// 	 	{
// 	 		infCond = '<button id="update_componet_matching_list" onclick="fnInsertComponetMatching()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">수정</button>';
// 	 		infCond1 = '<button id="cancelbtn_admin_component_matching_cpu_list" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">닫기</button>';
// 	 	}

// 	 	$('#admin_component_matching_cpu_list_view-btns').prepend(infCond1);
// 	 	$('#admin_component_matching_cpu_list_view-btns').prepend(infCond);
// // 	 	$('.k-button').css('float','right');

		SetInitDate();
// 		fnCancle();
 	}, 300);
});

function fnCancle(){
	console.log("load [fnCancle.js]");

	 $('#cancelbtn_admin_component_matching_mbd_list').kendoButton();
     var cancelBtn = $('#cancelbtn_admin_component_matching_mbd_list').data('kendoButton');
     cancelBtn.bind('click', function(e) {
         if(typeof(opener) == "undefined" || opener == null) {
             history.back();
         } else {
             window.close();
			}
     });

}

function SetInitDate(){
	console.log("load [SetInitDate.js]");

	var grid = opener.$('#admin_component_matching_mbd_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	var params = {
            MANUFACTURE_NM  : selItem.manufacture_nm,
			MODEL_NM        : selItem.model_nm
	}

	$('#MANUFACTURE_NM').val(params.MANUFACTURE_NM);
	$('#MODEL_NM').val(params.MODEL_NM);
// 	$('#PRICE_ID').val(params.PRICE_ID);

}

function fnInsertComponetMatching(){
	console.log("load [fnInsertComponetMatching.js]");

	var priceId = $('#PRICE_ID').val();
	var otherPurchasePartId = $('#OTHER_PURCHASE_PART_ID').val();

	if(priceId == null || priceId == ""){
		GochigoAlert("오류가 발생했습니다. 현재창을 닫고 다시 진행 해 주세요.");
		return;
	}

	if(otherPurchasePartId == null || otherPurchasePartId == ""){
		GochigoAlert("부품이 선택되지 않았습니다. 부품을 선택해 주세요.");
		return;
	}

	var url = '${updateWorldmemoryPrice}';

	var params = {
			PRICE_ID : $('#PRICE_ID').val(),
			OTHER_PURCHASE_PART_ID: $('#OTHER_PURCHASE_PART_ID').val(),
			COMPONENT_CD : $('#COMPONENT_CD').val(),
		};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				GochigoAlert(data.MSG);
			}
			else
				GochigoAlert(data.MSG);
		}
	});
}


</script>
