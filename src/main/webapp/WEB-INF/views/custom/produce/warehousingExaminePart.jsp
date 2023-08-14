<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="warehousingExamineInsert"					value="/produce/warehousingExamineInsert.json" />
<c:url var="warehousingExamineUpdate"					value="/produce/warehousingExamineUpdate.json" />


<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [warehousingExaminePart.jsp]");

 	$('#saveBtn_admin_produce_warehousing_examine_list').remove();


 	setTimeout(function() {
	 	var ID = $('#BARCODE').val();
	 	var infCond = "";

	 	if(ID == null || ID == "")
	 		infCond = '<button id="insert_admin_produce_warehousing_examine_list" onclick="fnInsertInfo()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';
	 	else{
 	 		$('#BARCODE').attr("readonly", "readonly");
// 	 		$('#BARCODE').attr("disable", "disable");

	 		$('.k-i-windows').attr("onclick", null);
	 		infCond = '<button id="update_admin_produce_warehousing_examine_list" onclick="fnUpdateInfo()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">수정</button>';
	 	}

	 	$('#admin_produce_warehousing_examine_list_view-btns').prepend(infCond);
// 	 	$('.k-button').css('float','right');
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

function prohibit(){
	console.log("${sid}.prohibit() Load");

	var pGrid = opener.$('#admin_produce_warehousing_all_list_gridbox').data('kendoGrid');
	var pSelItem = pGrid.dataItem(pGrid.select());
	if(!pSelItem) {GochigoAlert('선택된 항목이 없습니다.'); return false;}


	if(pSelItem.warehousing_state == 'C'){
		GochigoAlert('검수 완료된 입고에는 부품을 추가할 수 없습니다.');
		return false;
	}else if(pSelItem.warehousing_state == 'F'){
		GochigoAlert('완료된 입고에는 부품을 추가할 수 없습니다.');
		return false;
	}

	return true;
}


function fnInsertInfo() {

	console.log("admin_produce_warehousing_examine_list.fnInsertInfo() Load");

	var BARCODE = $('#BARCODE').val();
	BARCODE = BARCODE.trim();
	if(BARCODE == ""){
		GochigoAlert('관리번호가 입력되지 않았습니다.');
		return false;
	}


	if(!prohibit())
		return;


	var INIT_PRICE = $('#INIT_PRICE').val();
	var INVENTORY_CAT = $('#INVENTORY_CAT').val();
	var ADJUST_PRICE = $('#ADJUST_PRICE').val();
	var ADJUST_DES = $('#ADJUST_DES').val();
	var FINAL_PRICE = $('#FINAL_PRICE').val();
	var PROPERTY_CAT = $('#PROPERTY_CAT').val();
	var LOCATION = $('#LOCATION').val();
	var WAREHOUSING_ID = opener.$('#WAREHOUSING_ID').val();
	var INVENTORY_ID = $('#INVENTORY_ID').val();
 	var RELEASE_PRICE = $('#RELEASE_PRICE').val();
 	var RELEASE_COMPANY_ID = $('#RELEASE_COMPANY_ID').val();


	var url = '${warehousingExamineInsert}';
	var params = {
			BARCODE : BARCODE,
			INIT_PRICE : INIT_PRICE,
			INVENTORY_CAT : INVENTORY_CAT,
			ADJUST_PRICE : ADJUST_PRICE,
			ADJUST_DES : ADJUST_DES,
			FINAL_PRICE : FINAL_PRICE,
			PROPERTY_CAT : PROPERTY_CAT,
			LOCATION : LOCATION,
			WAREHOUSING_ID : WAREHOUSING_ID,
			INVENTORY_ID : INVENTORY_ID,
			RELEASE_COMPANY_ID : RELEASE_COMPANY_ID,
	        RELEASE_PRICE: RELEASE_PRICE
	};

	var isSuccess = false;

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS)
			{
				isSuccess = true;
				GochigoAlert(data.MSG);

			}
			else
			{
				GochigoAlert(data.MSG);
				//fnClose();
			}
		}
	});

	if(isSuccess){
		opener.fnObj('LIST_admin_produce_warehousing_all_list').reloadGrid();
		//opener.fnObj('LIST_${sid}').reloadGrid();
		//fnClose();
	}

}


function fnUpdateInfo() {
// 	여기에 입력
    var BARCODE = $('#BARCODE').val();
    var INIT_PRICE = $('#INIT_PRICE').val();
    var INVENTORY_CAT = $('#INVENTORY_CAT').val();
    var ADJUST_PRICE = $('#ADJUST_PRICE').val();
    var ADJUST_DES = $('#ADJUST_DES').val();
    var FINAL_PRICE = $('#FINAL_PRICE').val();
    var PROPERTY_CAT = $('#PROPERTY_CAT').val();
    var LOCATION = $('#LOCATION').val();
    var WAREHOUSING_ID = $('#WAREHOUSING_ID').val();
    var INVENTORY_ID = $('#INVENTORY_ID').val();
    var RELEASE_PRICE = $('#RELEASE_PRICE').val();
 	var RELEASE_COMPANY_ID = $('#RELEASE_COMPANY_ID').val();


    var url = '${warehousingExamineUpdate}';
    var params = {
        BARCODE : BARCODE,
        INIT_PRICE : INIT_PRICE,
        INVENTORY_CAT : INVENTORY_CAT,
        ADJUST_PRICE : ADJUST_PRICE,
        ADJUST_DES : ADJUST_DES,
        FINAL_PRICE : FINAL_PRICE,
        PROPERTY_CAT : PROPERTY_CAT,
        LOCATION : LOCATION,
        WAREHOUSING_ID : WAREHOUSING_ID,
        INVENTORY_ID : INVENTORY_ID,
        RELEASE_COMPANY_ID : RELEASE_COMPANY_ID,
        RELEASE_PRICE: RELEASE_PRICE
    };

    var isSuccess = false;
    var queryCustom = "cobjectid=warehousing_id&cobjectval="+WAREHOUSING_ID;

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
    	opener.fnObj('LIST_admin_produce_warehousing_all_list').reloadGrid();
//     	opener.fnObj('LIST_${sid}').reloadGridCustom(queryCustom);
		//fnClose();
	}
}

</script>
