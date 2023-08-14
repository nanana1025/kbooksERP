<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="updateWarehousingData"					value="/produce/updateWarehousingData.json" />

<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {
	console.log("load [consignedWarehousingData.jsp]");

    $('#saveBtn_consigned_warehousing_data').remove();

 	setTimeout(function() {
        var infCond = '<button id="insert_consigned_warehousing_data" onclick="fnUpdateWarehousing()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';
	 	$('#consigned_warehousing_data_view-btns').prepend(infCond);
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

function fnUpdateWarehousing() {
	console.log("consigned_warehousing_data.fnUpdateWarehousing() Load");

	// key
    var COMPONENT_ID = $('#COMPONENT_ID').val(); // COMPONENT_ID
    var WAREHOUSING_ID = $('#WAREHOUSING_ID').val(); // inventoryId INT
    var WAREHOUSING = $('#WAREHOUSING').val(); // 입고번호
    var WAREHOUSING_DT = $('#WAREHOUSING_DT').val(); // 입고일자 DATE
    var WAREHOUSING_TYPE = $('#WAREHOUSING_TYPE').val(); // 입고 타입
    var CUSTOMER_ID = $('#CUSTOMER_ID').val(); // 거래처
    var COMPANY_ID = $('#COMPANY_ID').val(); // 거래처
    var WAREHOUSING_STATE = $('#WAREHOUSING_STATE').val(); // 진행상태 - 포맷 체크
    var MODEL_NM = $('#MODEL_NM').val(); // 품목명
    var SPEC_NM = $('#SPEC_NM').val(); // 스펙정보
    var PART_CNT = $('#PART_CNT').val(); // 수량 SMALLINT
    var PRICE = $('#PRICE').val(); // 신청가 BIGINT - LONG
    var UPDATE_USER_ID = $('#UPDATE_USER_ID').val(); // 처리자  -- CHECK
//     var BARCODE = $('#BARCODE').val(); // 관리번호 - inventory
    var REGISTER_DT = $('#REGISTER_DT').val(); // 등록일자 DATE
    var COMPONENT_CD = $('#COMPONENT_CD').val(); // 부품명 - inventory
    var PROPERTY_CAT = $('#PROPERTY_CAT').val(); // 자산분류 - 포맷 체크 - inventory
//     var INVENTORY_CAT = $('#INVENTORY_CAT').val(); // 재고분류 - 포맷 체크 - inventory
    var LOCATION = $('#LOCATION').val(); // 저장위치 - 포맷 체크

	var url = '${updateWarehousingData}';
	var isSuccess = false;

	var params = {
//         INVENTORY_ID : INVENTORY_ID,
 		WAREHOUSING_ID : WAREHOUSING_ID,
        COMPONENT_ID : COMPONENT_ID,
        WAREHOUSING : WAREHOUSING,
        WAREHOUSING_DT : WAREHOUSING_DT,
        WAREHOUSING_TYPE: WAREHOUSING_TYPE,
        CUSTOMER_ID : CUSTOMER_ID,
        COMPANY_ID : COMPANY_ID,
        WAREHOUSING_STATE : WAREHOUSING_STATE,
        MODEL_NM : MODEL_NM,
        SPEC_NM : SPEC_NM,
        PART_CNT : PART_CNT,
        PRICE : PRICE,
        UPDATE_USER_ID : UPDATE_USER_ID,
//         BARCODE : BARCODE,
        REGISTER_DT : REGISTER_DT,
        COMPONENT_CD : COMPONENT_CD,
        PROPERTY_CAT : PROPERTY_CAT,
//         INVENTORY_CAT : INVENTORY_CAT,
        LOCATION : LOCATION,
	};

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점
			$.ajax({
				url : url,
				type : "POST",
				data : params,
				async : false,
				success : function(data) {
					if(data.SUCCESS) {
						setWarehousing(params);
						GochigoAlert(data.MSG);
						isSuccess = true;
					    //fnObj('LIST_${sid}').reloadGrid();

					} else {
						GochigoAlert(data.MSG);
					}
				}
			});

			if(isSuccess)
				fnObj('LIST_consigned_warehousing_all_list').reloadGrid();

			//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "입고정보를 수정하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}


function setWarehousing(params){

	console.log("consigned_warehousing_data.setWarehousing() Load");

	var grid = $('#consigned_warehousing_all_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


// 	selItem.warehousing = params.WAREHOUSING;
// 	selItem.warehousing_dt = params.WAREHOUSING_DT;

		fnObj('LIST_consigned_warehousing_all_list').reloadGrid();

//     var params = {
//		DATA_ID : selItem.data_id,
//		COMPONENT_ID: selItem.component_id,
//		MANUFACTURE_NM: selItem.manufacture_nm,
//		MODEL_NM: selItem.model_nm,
//		REVISION: selItem.revision,
//		CAPACITY: selItem.capacity,
//		STG_TYPE: selItem.stg_type,
//		BUS_TYPE: selItem.bus_type,
//		BANDWIDTH: selItem.bandwidth,
//		SPEED: selItem.speed,
//		FEATURE: selItem.feature,
//	};



}

</script>
