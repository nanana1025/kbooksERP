<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>


<c:url var="LTPurchasePriceUpdate"									value="/priceMatching/LTPurchasePriceUpdate.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [partPriceUpdate.js]");

	$('#saveBtn_${sid}').remove();

	setTimeout(function(){
		var infCond = '<button id="update_${sid}" onclick="fnPriceUpdate()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">수정</button>';
		$('#${sid}_view-btns').prepend(infCond);
	},500);
});


function fnPriceUpdate() {
	console.log("${sid}.fnPriceUpdate()");

// 	여기에 입력
    var LT_PURCHASE_PRICE_ID = $('#LT_PURCHASE_PRICE_ID').val();
    var PRICE_ID = $('#PRICE_ID').val();
    var PRICE = $('#PRICE').val()  * 1;
    var COMPONENT_ID = $('#COMPONENT_ID').val();

	if(!$.isNumeric(PRICE)){
		GochigoAlert('가격은 숫자만 입력해주세요.');
		return;
	}
	if(PRICE < 1){
		GochigoAlert('가격은 양수만 입력 가능합니다.');
		return;
	}


    var url = '${LTPurchasePriceUpdate}';

    var params = {
    		LT_PURCHASE_PRICE_ID : LT_PURCHASE_PRICE_ID,
    		PRICE_ID : PRICE_ID,
    		PRICE : PRICE,
    		COMPONENT_ID : COMPONENT_ID
    };

    var isSuccess = false;

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
//     	opener.fnObj('LIST_admin_produce_warehousing_all_list').reloadGrid();
    	opener.fnObj('LIST_${sid}').reloadGrid()
		//fnClose();
	}
}

</script>
