<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="bomTreeInsert"					value="/produce/bomTreeInsert.json" />


<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [producePartData.jsp]");

 	setTimeout(function() {

// 	 	$('#saveBtn_admin_produce_part_list').remove();

 		var ID = $('#INVENTORY_ID').val();

 		if(ID == null || ID == "") {

  			$('.k-i-windows').attr("onclick", 'javascript:fnObj("CRUD_${sid}").fnWindowOpen("/layoutSelectP.do?xn=produce_part_inventory_LAYOUT","fnLinkCallback_MODEL_NM","null");');

	 		$('#BARCODE').removeAttr("readonly");
	 		$('#BARCODE').removeAttr("disabled");

	 		$('#saveBtn_admin_produce_part_list').remove();
		 	var saveCond = '<button id="customSaveBtn_${sid}" onclick="fnInsertInfo()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';
		 	$('#admin_produce_part_list_view-btns').prepend(saveCond);

	 		var infCond = '<button id="inputBarcode_${sid}" onclick="fnChangeBarcodeTextboxCondition()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">관리번호 활성화</button>';
		 	$('#admin_produce_part_list_view-btns').prepend(infCond);

		 	var openerGrid = opener.$('#admin_inventory_all_list_gridbox').data('kendoGrid');
			var openerSelItem = openerGrid.dataItem(openerGrid.select());
			if(!openerSelItem) {
				GochigoAlert('부모의 선택된 항목이 없습니다.');
				self.close();
			}

			$('#INVENTORY_ID').val(openerSelItem.inventory_id);
 		}else{

			$('.k-i-windows').attr("onclick", null);
		}



});

function fnChangeBarcodeTextboxCondition() {
		$('#BARCODE').removeAttr("readonly");
		$('#BARCODE').removeAttr("disabled");
}

function fnClose(){
	console.log("load [fnClose.js]");

	if(typeof(opener) == "undefined" || opener == null) {
		history.back();
	} else {
		window.close();
	}
}


function fnInsertInfo() {
// 	여기에 입력
console.log("${sid}.fnInsertInfo() Load");

	var openerGrid = opener.$('#admin_inventory_all_list_gridbox').data('kendoGrid');
	var openerSelItem = openerGrid.dataItem(openerGrid.select());
	if(!openerSelItem) {
		GochigoAlert('부모의 선택된 항목이 없습니다.');
		self.close();
	}

	var BARCODE = $('#BARCODE').val();
    var INVENTORY_ID = $('#INVENTORY_ID').val();
    var C_INVENTORY_ID = $('#C_INVENTORY_ID').val();

    if(INVENTORY_ID != openerSelItem.inventory_id){
    	GochigoAlert('오류가 발생했습니다.다시 시도해 주세요.');
		self.close();
    }


    var url = '${bomTreeInsert}';
    var params = {
        BARCODE : BARCODE,
        INVENTORY_ID : INVENTORY_ID,
        C_INVENTORY_ID : C_INVENTORY_ID
    };

    var isSuccess = false;

    $.ajax({
        url : url,
        type : "POST",
        data : params,
        async : false,
        success : function(data) {
            if(data.SUCCESS){
            	kendo.alert(data.MSG);
            	isSuccess = true;

            }
            else{
                GochigoAlert(data.MSG);
                //fnClose();
            }
        }
    });

    if(isSuccess){
		opener.fnObj('LIST_admin_inventory_all_list').reloadGrid();
		//self.close();
	}
}

</script>
