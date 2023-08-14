<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="updateProductPrice"					value="/product/updateProductPrice.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {



	console.log("load [releaseProductData.js]");

	setTimeout(function() {
		$('#saveBtn_release_product_list').remove();
	 	var saveCond = '<button id="customSaveBtn_${sid}" onclick="fnUpdateInfo()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';
 		$('#release_product_list_view-btns').prepend(saveCond);
	}, 500);

});


function fnUpdateInfo() {
// 	여기에 입력

	var pGrid = opener.$('#release_product_list_gridbox').data('kendoGrid');
	var rows = pGrid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}


    var url = '${updateProductPrice}';

    var isSuccess = false;

  //시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '수정',
			action: function(e){
				//시작지점

				var listInventoeyId = [];
				 rows.each(function (index, row) {
					 var gridData = pGrid.dataItem(this);
					 listInventoeyId.push(gridData.inventory_id);
					 });

					var params = {
							LIST_INVENTORY_ID : listInventoeyId.toString(),
							PRICE: $('#PRICE').val()
						};

					$.ajax({
						url : url,
						type : "POST",
						data : JSON.stringify(params),
			    		contentType: "application/json",
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
//  				    		fnObj('LIST_${sid}').reloadGrid();
					    	opener.fnObj('LIST_release_product_list').reloadGrid();
						}

					//끝지점
			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "수정하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
