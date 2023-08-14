<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="releaseInventoryInsert"					value="/release/releaseInventoryInsert.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [releaseSalePartData.js]");



	setTimeout(function() {

		$('.k-i-windows').attr("onclick", 'javascript:fnObj("CRUD_${sid}").fnWindowOpen("/layoutSelectP.do?xn=selectable_Inventory_LAYOUT","fnLinkCallback_BARCODE","W");');

		$( '#BARCODE' ).removeAttr( 'readonly' );
		$( '#BARCODE' ).removeAttr( 'disabled' );

 		$('#saveBtn_${sid}').remove();

 		var infCond  = '<button id="insert_${sid}" onclick="fnReleaseInventoryInsert()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">추가</button>';

	 	$('#${sid}_view-btns').prepend(infCond);
// 	 	$('.k-button').css('float','right');
 	}, 500);

	setTimeout(function() {
		$('.k-i-windows').attr("onclick", 'javascript:fnObj("CRUD_${sid}").fnWindowOpen("/layoutSelectP.do?xn=selectable_Inventory_LAYOUT","fnLinkCallback_BARCODE","W");');
		$( '#BARCODE' ).removeAttr( 'readonly' );
		$( '#BARCODE' ).removeAttr( 'disabled' );
	}, 1000);


});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_header_title').width()-20;
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}

function fnReleaseInventoryInsert() {
// 	여기에 입력

	var pGrid = opener.$('#release_sale_order_all_list_gridbox').data('kendoGrid');
	var selItem = pGrid.dataItem(pGrid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.release_state == 'R'){
		GochigoAlert('출고된 주문은 변경할 수 없습니다.');
		return;
	}

    var RELEASE_ID = $('#RELEASE_ID').val();
    var INVENTORY_ID = $('#INVENTORY_ID').val();
    var BARCODE = $('#BARCODE').val();
    var ORDER_ID = $('#ORDER_ID').val();
    var BOX_ID = $('#BOX_ID').val();
    var BOX = $('#BOX').val();

    var RELEASE_TYPE = $('#RELEASE_TYPE').val();
    var BOX_NO = $('#BOX_NO').val();
    var LOCATION = $('#LOCATION').val();
    var BOX_TYPE = $('#BOX_TYPE').val();


    RELEASE_ID = RELEASE_ID*1;
    BARCODE = BARCODE.trim();
    BOX_ID = BOX_ID*1;
    BOX_NO = BOX_NO*1;

    if(RELEASE_ID < 1 || RELEASE_ID == ""){
    	GochigoAlert('출고 번호가 올바르지 않습니다. 다시 시도해주세요.');
    	return false;
    }
    if(BARCODE == ""){
    	GochigoAlert('재고 번호가 올바르지 않습니다. 다시 시도해주세요.');
    	return false;
    }
    if(BOX_ID == ""){
    	GochigoAlert('BOX가 생성되지 않았습니다. BOX를 먼저 생성해 주세요.');
    	return false;
    }
    if(BOX_ID < 1 ){
    	GochigoAlert('BOX 번호가 올바르지 않습니다. 다시 시도해주세요.');
    	return false;
    }
    if(BOX_NO < 1 || BOX_NO > 1000){
    	GochigoAlert('BOX 번호는 0 ~ 999 사이의 정수만 입력 가능합니다.');
    	return false;
    }

    var url = '${releaseInventoryInsert}';

    var params = {
    		RELEASE_ID : RELEASE_ID,
    		INVENTORY_ID : INVENTORY_ID,
    		ORDER_ID : ORDER_ID,
    		BARCODE : BARCODE,
    		BOX_ID : BOX_ID,
    		BOX : BOX,
    		RELEASE_TYPE : RELEASE_TYPE,
    		BOX_NO : BOX_NO,
    		LOCATION : LOCATION,
    		BOX_TYPE : BOX_TYPE
    };

    var isSuccess = false;
    var queryCustom = "cobjectid=release_id&cobjectval="+RELEASE_ID;

    $.ajax({
        url : url,
        type : "POST",
        data : params,
        async : false,
        success : function(data) {
            if(data.SUCCESS){
            	isSuccess = true;
                GochigoAlert(data.MSG);
            	//fnClose();
            }
            else{
                GochigoAlert(data.MSG);
                //fnClose();
            }
        }
    });

    if(isSuccess){
    	opener.fnObj('LIST_release_sale_order_all_list').reloadGrid();
//     	opener.fnObj('LIST_release_sale_order_all_list').reloadGridCustom(queryCustom);
		//fnClose();
	}
}

</script>
