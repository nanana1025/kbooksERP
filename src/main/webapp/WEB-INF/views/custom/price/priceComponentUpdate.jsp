<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="priceComponentUpdate"					value="/price/priceComponentUpdate.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

var _COLNAME = ["PRICE_COMPONENT_LT_PURCHASE"
	,"PRICE_COMPONENT_DANAWA_PURCHASE"
	,"PRICE_COMPONENT_LT_DEALER_PURCHASE"
	,"PRICE_COMPONENT_LT_DEALER_SALE"
	,"PRICE_COMPONENT_LT_EXPORT_PRICE"
	,"PRICE_COMPONENT_LT_SALE"
	,"PRICE_COMPONENT_PH_SALE"
	,"PRICE_COMPONENT_OTHER1_SALE"
	,"PRICE_COMPONENT_OTHER2_SALE"
	,"PRICE_COMPONENT_OTHER3_SALE"];

var _TABLENAME = ["TN_COMPONENT_LT_PURCHASE_PRICE"
	,"TN_COMPONENT_DANAWA_PURCHASE_PRICE"
	,"TN_COMPONENT_LT_DEALER_PURCHASE_PRICE"
	,"TN_COMPONENT_LT_DEALER_SALE_PRICE"
	,"TN_COMPONENT_LT_EXPORT_SALE_PRICE"
	,"TN_COMPONENT_LT_SALE_PRICE"
	,"TN_COMPONENT_PH_SALE_PRICE"
	,"TN_COMPONENT_OTHER1_SALE_PRICE"
	,"TN_COMPONENT_OTHER2_SALE_PRICE"
	,"TN_COMPONENT_OTHER3_SALE_PRICE"];

var _PRICE = new Array();

$(document).ready(function() {

	console.log("load [priceComponentUpdate.js]");

	$('#saveBtn_${sid}').remove();
	var saveCond = '<button id="customSaveBtn_${sid}" onclick="fnUpdatePrice()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">수정</button>';
 	$('#${sid}_view-btns').prepend(saveCond);




	setTimeout(function(){
		//$('.k-grid-delete').remove();

		for(var i = 0 ; i < _COLNAME.length; i++){
			var id = "#"+_COLNAME[i];
			_PRICE[i] = $(id).val();
		}

	},500);
});




function fnUpdatePrice(){
	console.log("${sid}.fnUpdatePrice() Load");

	var url = '${priceComponentUpdate}';

	var params = "";
	var msg = "";

// 	var isChange = false;
// 	for(var i = 0 ; i < _COLNAME.length; i++){
// 		var id = "#"+_COLNAME[i];

// 		if(_PRICE[i] != $(id).val()){
// 			isChange = true;
// 			break;
// 		}
// 	}

	if($("#PRICE_ID").val() == '' || $("#PRICE_ID").val() == null){
		GochigoAlert('오류가 발생했습니다. 다시 시도해주세요.'); return;
	}

// 	if(!isChange){
// 		GochigoAlert('변경된 가격이 없습니다.'); return;
// 	}

	var lisPriceTable = [];
	var lisPriceKey = [];
	var lisPrice = [];

	for(var i = 0 ; i < _COLNAME.length; i++){
		var id = "#"+_COLNAME[i];
		var price = 0;

		if($(id).val() !='' && $(id).val() != null)
			price = $(id).val();

// 		if(_PRICE[i] != price){
			lisPriceTable.push(_TABLENAME[i]);
			lisPriceKey.push(_COLNAME[i]);
			lisPrice.push(price);
// 		}
	}


	var isSuccess = false;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

					var params = {
							PRICE_ID : $("#PRICE_ID").val(),
							PRICE_TABLE : lisPriceTable.toString(),
							PRICE_KEY : lisPriceKey.toString(),
							PRICE : lisPrice.toString()
						};

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
							else{
								GochigoAlert(data.MSG);
							}
						}
					});

					 if(isSuccess){
					    	fnObj('LIST_price_component_list').reloadGrid();
						}

					//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택한 부품의 가격을 수정하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
