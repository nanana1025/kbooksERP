<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />
<c:url var="dataList"					value="/dataList.json" />
<c:url var="updateCustomComponentMapping"					value="/priceMapping/updateCustomComponentMapping.json" />



<style>
</style>
<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>
<script>

$(document).ready(function() {

	console.log("load [LTComponent_update.js]");



	$('#saveBtn_${sid}').remove();
	//$('#cancelBtn_admin_component_matching_cpu_list').remove();


	setTimeout(function() {
// 		window.resizeTo(784, 0);

	 	var ID = $('#PART_KEY').val();
	 	var infCond = '<button id="updateBtn_${sid}" onclick="fnInsertComponetMatching()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';

	 	$('#${sid}_view-btns').prepend(infCond);
// 	 	$('.k-button').css('float','right');

// 		SetInitDate();

 	}, 300);
});


function fnInsertComponetMatching(){
	console.log("load [fnInsertComponetMatching.js]");

	var ltCustomPartId = $('#LT_CUSTOM_PART_ID').val();
	var priceId = $('#PRICE_ID').val();

	if(ltCustomPartId == null || ltCustomPartId == ""){
		GochigoAlert("부품이 선택되지 않았습니다. 부품을 선택해 주세요.");
		return;
	}

	if(priceId == null || priceId == ""){
		GochigoAlert("오류가 발생했습니다. 현재창을 닫고 다시 진행 해 주세요.");
		return;
	}

	var url = '${updateCustomComponentMapping}';

	var params = {
			LT_CUSTOM_PART_ID : ltCustomPartId,
			PRICE_ID: priceId
		};

	var isSuccess = false;

	var tGrid = opener.$("#${sid}_gridbox");
  	var tGridData = tGrid.data("kendoGrid").dataSource;
	var page = tGridData.page();

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
			 var typeCheck = opener.$('#type_cd').val();
			 var check = opener.$('#confirm_cd').val();

			 if(typeCheck == 'ALL' && check == 'ALL')
				 opener.fnObj('LIST_${sid}').reloadGrid();
			 else{
// 	             console.log("page = "+page) ;
				 opener.fnDropBoxonChange(page, 20);
			 }
		}


			//self.close();

}


</script>
