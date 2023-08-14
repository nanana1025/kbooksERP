<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />
<c:url var="dataList"					value="/dataList.json" />
<c:url var="updateCustomPartMapping"					value="/priceMapping/updateCustomPartMapping.json" />



<style>
</style>
<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>
<script>

$(document).ready(function() {

	console.log("load [LT_WM_update.js]");



	$('#saveBtn_${sid}').remove();
	//$('#cancelBtn_admin_component_matching_cpu_list').remove();


	setTimeout(function() {
// 		window.resizeTo(784, 0);

	 	var ID = $('#PART_KEY').val();
	 	var infCond = '<button id="updateBtn_pricemapping_lt_wm_list" onclick="fnInsertComponetMatching()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';

	 	$('#${sid}_view-btns').prepend(infCond);
// 	 	$('.k-button').css('float','right');

		//SetInitDate();

		 console.log("1111= ${sid}");
		 console.log("222="+ '${sid}' == 'pricemapping_wm_lt_list');

 	}, 300);
});


function fnInsertComponetMatching(){
	console.log("load [fnInsertComponetMatching.js]");

	var ltCustomPartId = $('#LT_CUSTOM_PART_ID').val();
	var otherPurchasePartId = $('#OTHER_PURCHASE_PART_ID').val();

	if(ltCustomPartId == null || ltCustomPartId == ""){
		GochigoAlert("오류가 발생했습니다. 현재창을 닫고 다시 진행 해 주세요.");
		return;
	}

	if(otherPurchasePartId == null || otherPurchasePartId == ""){
		GochigoAlert("부품이 선택되지 않았습니다. 부품을 선택해 주세요.");
		return;
	}

	var url = '${updateCustomPartMapping}';

	var params = {
			LT_CUSTOM_PART_ID : ltCustomPartId,
			OTHER_PURCHASE_PART_ID: otherPurchasePartId
		};

	var isSuccess = false;

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				GochigoAlert(data.MSG);
				isSuccess = true;
			}
			else
				GochigoAlert(data.MSG);
		}
	});

	 if(isSuccess){
		 console.log("1111= ${sid}");
		 console.log("222="+ '${sid}' == 'pricemapping_wm_lt_list');
		 if('${sid}' == 'pricemapping_wm_lt_list'){
			 opener.fnObj('LIST_${sid}').reloadGrid();
		 }
		 else{
			opener.fnObj('LIST_pricemapping_lt_wm_list').reloadGrid();
			//self.close();
		 }
	}
}


</script>
