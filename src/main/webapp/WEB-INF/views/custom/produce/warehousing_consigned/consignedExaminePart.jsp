<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="updateConsignedComponentBulk"					value="/compInven/updateConsignedComponentBulk.json" />

<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

var _inventoryType = getParameterByName('INVENTORY_TYPE');
var _sid = getParameterByName('sid');

$(document).ready(function() {

	console.log("load [warehousingExaminePart.jsp]");

 	$('#saveBtn_'+_sid).remove();


 	setTimeout(function() {
	 	var ID = $('#BARCODE').val();
	 	var infCond = "";

	 		infCond = '<button id="update_warehousing_consigned_examine_list" onclick="updateInfo()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">수정</button>';

	 	$('#'+_sid+'_view-btns').prepend(infCond);
// 	 	$('.k-button').css('float','right');


		var componentCd = $('#COMPONENT_CD').val();
		if(componentCd != 'CPU' && componentCd != 'MBD' && componentCd != 'STG' && componentCd != 'MEM' && componentCd != 'MON' && componentCd != 'VGA')
			$('#MODEL_NM').attr("readonly",true);
 	}, 500);

});

function fnClose(){
	console.log("load [fnClose.js]");

	window.close();

}

function getParameterByName(name) {
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
			results = regex.exec(location.search);
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}


function updateInfo() {

	console.log("saveBtn_warehousing_consigned_examine_list.updateInfo() Load");

	var COMPONENT_ID = $('#COMPONENT_ID').val();
	var WAREHOUSING_ID = $('#WAREHOUSING_ID').val();
	var MODEL_NM = $('#MODEL_NM').val();
	var LOCATION = $('#LOCATION').val();
	var USE_RANGE = $('#USE_RANGE').val();
	var RELEASE_COMPANY_ID = $('#RELEASE_COMPANY_ID').val();
	var INIT_PRICE = $('#INIT_PRICE').val();
	var RELEASE_PRICE = $('#RELEASE_PRICE').val();
	var COMPONENT_CD = $('#COMPONENT_CD').val();



	var url = '${updateConsignedComponentBulk}';

	var params = {
			COMPONENT_ID : COMPONENT_ID,
			WAREHOUSING_ID : WAREHOUSING_ID,
			MODEL_NM: MODEL_NM,
			COMPONENT_CD: COMPONENT_CD,
			LOCATION : LOCATION,
			USE_RANGE : USE_RANGE,
			RELEASE_COMPANY_ID : RELEASE_COMPANY_ID,
			INIT_PRICE : INIT_PRICE,
			RELEASE_PRICE : RELEASE_PRICE,
			INVENTORY_TYPE : _inventoryType
	};

	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '수정',
			action: function(e){
				//시작지점
				$.ajax({
					url : url,
					type : "POST",
		    		data : JSON.stringify(params),
		    		contentType: "application/json",
					async : false,
					success : function(data) {
						if(data.SUCCESS)
						{
							opener.fnObj('LIST_'+_sid).reloadGrid();
							GochigoAlert(data.MSG, true, "dangol365 ERP");

						}
						else
						{
							GochigoAlert(data.MSG);
						}
					}
				});

			}
		},
		{
			text: '취소',

		}],
		minWidth : 200,
		title: "dangol365 ERP",
	    content: "정보를 수정하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
