<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="updateNtbPrice"					value="/price/updateNtbPrice.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [updateNtbPrice.js]");

	$('#saveBtn_ntb_price').remove();
	var saveCond = '<button id="updateBtn_ntb_price" onclick="fnUpdatePrice()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">수정</button>';
 	$('#ntb_price_view-btns').prepend(saveCond);

	setTimeout(function(){

	},500);
});




function fnUpdatePrice(){
	console.log("${sid}.fnUpdatePrice() Load");

	var url = '${updateNtbPrice}';

	var params = {
			NTB_PRICE_ID : $("#NTB_PRICE_ID").val(),
			NTB_LIST_ID : $("#NTB_LIST_ID").val(),
			NTB_CATEGORY : $("#NTB_CATEGORY").val(),
			NTB_CODE : $("#NTB_CODE").val(),
			NTB_NAME : $("#NTB_NAME").val(),
			NTB_GENERATION : $("#NTB_GENERATION").val(),
			NTB_NICKNAME : $("#NTB_NICKNAME").val(),

			LT_PURCHASE_PRICE_MAJOR : $("#LT_PURCHASE_PRICE_MAJOR").val(),
			LT_PURCHASE_PRICE_ETC : $("#LT_PURCHASE_PRICE_ETC").val(),
			LT_DANAWA_PRICE_MAJOR : $("#LT_DANAWA_PRICE_MAJOR").val(),
			LT_DANAWA_PRICE_ETC : $("#LT_DANAWA_PRICE_ETC").val(),
			LT_DEALER_PRICE_MAJOR : $("#LT_DEALER_PRICE_MAJOR").val(),
			LT_DEALER_PRICE_ETC : $("#LT_DEALER_PRICE_ETC").val()

		};

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '수정',
			action: function(e){
				//시작지점



					$.ajax({
						url : url,
						type : "POST",
						data : params,
						async : false,
						success : function(data) {
							if(data.SUCCESS){

								 opener.initNTBList();
								 var grid = opener.$("#notebook-grid").data("kendoGrid");
								 var gData = grid.dataSource.data();

								 var i;
								 for(i=0;i<gData.length; i++)
								 	if(gData[i].NTB_LIST_ID == params.NTB_PRICE_ID)
							 		{
								 		grid.select("tr:eq("+i+")");
										break;
							 		}


								 GochigoAlertClose(data.MSG, true, "dangolERP");

							}
							else{
								GochigoAlert(data.MSG);
							}
						}
					});

					//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "수정하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
