<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="inventorySimpleUpdate"					value="/produce/inventorySimpleUpdate.json" />

<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {
	console.log("load [produceProduceData.jsp]");

    $('#saveBtn_admin_produce_warehousing_data').remove();
    $('#saveBtn_admin_produce_produce_data').remove();

 	setTimeout(function() {

		$('#saveBtn_admin_produce_produce_data').remove();
 		$('.k-i-windows').attr("onclick", null);
 		infCond = '<button id="update_admin_produce_produce_data" onclick="fnUpdateInfo()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">수정</button>';

	 	$('#admin_produce_produce_data_view-btns').prepend(infCond);

 	}, 500);
});

function fnClose(){
	console.log("load [fnClose.js]");

	if(typeof(opener) == "undefined" || opener == null) {
		history.back();
	} else {
		window.close();
	}
}

function fnUpdateInfo() {
	console.log("produceProduceData.fnUpdateInfo() Load");

	 var params = {
		        INVENTORY_CAT : $('#INVENTORY_CAT').val(),
		        SELLING_PRICE : $('#SELLING_PRICE').val(),
		        PROPERTY_CAT : $('#PROPERTY_CAT').val(),
		        LOCATION : $('#LOCATION').val(),
		        INVENTORY_ID : $('#INVENTORY_ID').val()
		    };

	 var url = '${inventorySimpleUpdate}';

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS) {
				setWarehousing(params);
				GochigoAlert(data.MSG);
			    //fnObj('LIST_${sid}').reloadGrid();

			} else {
				GochigoAlert(data.MSG);
			}
		}
	});
}


function setWarehousing(params){

	console.log("admin_produce_produce_data.setWarehousing() Load");

	var grid = $('#admin_inventory_all_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	fnObj('LIST_admin_inventory_all_list').reloadGrid();
}

</script>
