<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="insertProductInventory"					value="/product/insertProductInventory.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [productPartData.js]");



	setTimeout(function() {

		$('.k-i-windows').attr("onclick", 'javascript:fnObj("CRUD_${sid}").fnWindowOpen("/layoutSelectP.do?xn=product_Selectable_Inventory_LAYOUT","fnLinkCallback_BARCODE","W");');

		$( '#BARCODE' ).removeAttr( 'readonly' );
		$( '#BARCODE' ).removeAttr( 'disabled' );

 		$('#saveBtn_${sid}').remove();

 		var infCond  = '<button id="insert_${sid}" onclick="fnProductInventoryInsert()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">추가</button>';

	 	$('#${sid}_view-btns').prepend(infCond);
// 	 	$('.k-button').css('float','right');

	 	var openerGrid = opener.$('#release_productinfo_list_gridbox').data('kendoGrid');
		var openerSelItem = openerGrid.dataItem(openerGrid.select());
		if(!openerSelItem) {
			GochigoAlert('제품이 선택되지 않았습니다.');
// 			self.close();
		}

		$('#P_INVENTORY_ID').val(openerSelItem.inventory_id);
		$('#RELEASE_ID').val(openerSelItem.release_id);

 	}, 500);

	setTimeout(function() {
		$('.k-i-windows').attr("onclick", 'javascript:fnObj("CRUD_${sid}").fnWindowOpen("/layoutSelectP.do?xn=product_Selectable_Inventory_LAYOUT","fnLinkCallback_BARCODE","W");');
		$( '#BARCODE' ).removeAttr( 'readonly' );
		$( '#BARCODE' ).removeAttr( 'disabled' );

		var openerGrid = opener.$('#release_productinfo_list_gridbox').data('kendoGrid');
		var openerSelItem = openerGrid.dataItem(openerGrid.select());
		if(!openerSelItem) {
// 			GochigoAlert('제품이 선택되지 않았습니다.');
// 			self.close();
		}

		$('#P_INVENTORY_ID').val(openerSelItem.inventory_id);
		$('#RELEASE_ID').val(openerSelItem.release_id);
	}, 1000);


});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_header_title').width()-20;
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}

function fnProductInventoryInsert() {
// 	여기에 입력

// 	var pGrid = opener.$('#release_productinfo_list_gridbox').data('kendoGrid');
// 	var selItem = pGrid.dataItem(pGrid.select());
// 	if(!selItem) {GochigoAlert('선택된 제품이 없습니다.'); return;}


    var P_INVENTORY_ID = $('#P_INVENTORY_ID').val();
    var INVENTORY_ID = $('#INVENTORY_ID').val();
    var BARCODE = $('#BARCODE').val();
    var RELEASE_ID = $('#RELEASE_ID').val();


    P_INVENTORY_ID = P_INVENTORY_ID*1;
    INVENTORY_ID = INVENTORY_ID*1;

    if(P_INVENTORY_ID < 0 ){
    	GochigoAlert('부품재고 번호가 올바르지 않습니다. 다시 시도해주세요.');
    	return false;
    }

    if(BARCODE == ""){
    	GochigoAlert('바코드가 입력되지 않았습니다. 바코드를 입력 또는 선택하세요.');
    	return false;
    }

    if(INVENTORY_ID <= 0){
    	INVENTORY_ID = -1;
    }



    var url = '${insertProductInventory}';

    var params = {
    		INVENTORY_ID : P_INVENTORY_ID,
    		C_INVENTORY_ID : INVENTORY_ID,
    		RELEASE_ID: RELEASE_ID,
    		BARCODE : BARCODE,
    		TYPE : "O"
    };

    var isSuccess = false;
    var queryCustom = "cobjectid=inventory_id&cobjectval="+P_INVENTORY_ID;

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
//     	opener.fnObj('admin_product_list').reloadGrid();
    	opener.fnObj('LIST_${sid}').reloadGridCustom(queryCustom);
		//fnClose();
	}
}

function fnWindowOpen(url, callbackName, size) {
    var width, height;
    if(size == "S"){
    	width = "800";
    	height = "600";
    } else if(size == "M") {
    	width = "1024";
    	height = "768";
    } else if(size == "L") {
    	width = "1280";
    	height = "900";
    }else if(size == "W") {
    	width = "1600";
    	height = "800";
    }else if(size == "F") {
    	width = $( window ).width()*0.95;
    	height = $( window ).height()*0.95;
    } else {
    	width = "800";
    	height = "600"
    }
	var xPos  = (document.body.clientWidth /2) - (width / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (height / 2);
    window.open("<c:url value='"+url+"'/>"+"&callbackName="+callbackName, "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
}

</script>
