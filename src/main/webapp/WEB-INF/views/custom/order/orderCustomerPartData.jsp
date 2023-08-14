<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="orderCompInsert"					value="/order/orderCompInsert.json" />
<c:url var="orderCompUpdate"					value="/order/orderCompUpdate.json" />

<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [orderCustomerPartData.jsp]");

 	setTimeout(function() {

// 	 	$('#saveBtn_admin_produce_part_list').remove();

 		var ID = $('#COMPONENT_ID').val();

//  		$("#saveBtn_admin_sale_order_customer_part_list").attr('id','saveBtn_admin_sale_order_customer_part_list_custom');                    //TestID를 NoID로 변경한다.

//  		$('#saveBtn_admin_sale_order_customer_part_list_custom').attr("onclick", "fnCustomerOrderUpdate()");

 		$('#saveBtn_${sid}').remove();
 		var infoCond = "";
 		if(ID == null || ID == "") {

  			$('.k-i-windows').attr("onclick", 'javascript:fnObj("CRUD_${sid}").fnWindowOpen("/layoutSelectP.do?xn=component_LAYOUT","fnLinkCallback_MODEL_NM","null");');
		 	infoCond = '<button id="custom_SaveBtn_${sid}" onclick="fnInsertInfo()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';

		 	var openerGrid = opener.$('#admin_sale_order_customer_list_gridbox').data('kendoGrid');
			var openerSelItem = openerGrid.dataItem(openerGrid.select());
			if(!openerSelItem) {
				GochigoAlert('부모의 선택된 항목이 없습니다.');
				self.close();
			}

			$('#ORDER_ID').val(openerSelItem.order_id);
 		}else{

 			var infoCond = '<button id="updateBtn_admin_sale_order_customer_part_list" onclick="fnUpdateInfo()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">수정</button>';
			$('.k-i-windows').attr("onclick", null);
		}

 		$('#${sid}_view-btns').prepend(infoCond);

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

function fnUpdateInfo(){

	console.log("${sid}.fnUpdateInfo() Load");

	var openerGrid = opener.$('#admin_sale_order_customer_list_gridbox').data('kendoGrid');
	var openerSelItem = openerGrid.dataItem(openerGrid.select());
	if(!openerSelItem) {
		GochigoAlert('부모의 선택된 항목이 없습니다.');
		self.close();
	}

	var ORDER_STATE = openerSelItem.order_state;

	if(ORDER_STATE == 'E') {
		GochigoAlert('견적중에는 수정할수 없습니다.');
		return;
	}else if(ORDER_STATE == 'D') {
		GochigoAlert('확정상태의 주문은 수정할수 없습니다.');
		return;
	}else if(ORDER_STATE == 'R') {
		GochigoAlert('출고상태의 주문은 수정할수 없습니다.');
		return;
	}else if(ORDER_STATE == 'B') {
		GochigoAlert('반품상태의 주문은 수정할수 없습니다.');
		return;
	}

    var ORDER_ID = $('#ORDER_ID').val();
    var COMPONENT_ID = $('#COMPONENT_ID').val();
    var CNT = $('#CNT').val();



    if(ORDER_ID != openerSelItem.order_id){
    	GochigoAlert('오류가 발생했습니다.다시 시도해 주세요.');
		self.close();
    }


    var url = '${orderCompUpdate}';
    var params = {
    	ORDER_ID : ORDER_ID,
    	COMPONENT_ID : COMPONENT_ID,
    	CNT : CNT
    };

    var isSuccess = false;
    var queryCustom = "cobjectid=order_id&cobjectval="+ORDER_ID;

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
                //fnClose();
            }
        }
    });

    if(isSuccess){
    	opener.fnObj('LIST_admin_sale_order_customer_part_list').reloadGridCustom(queryCustom);
		//fnClose();
	}

}


function fnInsertInfo() {
// 	여기에 입력
console.log("${sid}.fnInsertInfo() Load");

	var openerGrid = opener.$('#admin_sale_order_customer_list_gridbox').data('kendoGrid');
	var openerSelItem = openerGrid.dataItem(openerGrid.select());
	if(!openerSelItem) {
		GochigoAlert('부모의 선택된 항목이 없습니다.');
		self.close();
	}

var ORDER_STATE = openerSelItem.order_state;

	if(ORDER_STATE == 'E') {
		GochigoAlert('견적중에는 추가할 수 없습니다.');
		return;
	}else if(ORDER_STATE == 'D') {
		GochigoAlert('확정상태의 주문은 수정할수 없습니다.');
		return;
	}else if(ORDER_STATE == 'R') {
		GochigoAlert('출고상태의 주문은 수정할수 없습니다.');
		return;
	}else if(ORDER_STATE == 'B') {
		GochigoAlert('반품상태의 주문은 수정할수 없습니다.');
		return;
	}

    var ORDER_ID = $('#ORDER_ID').val();
    var COMPONENT_ID = $('#COMPONENT_ID').val();
    var CNT = $('#CNT').val();

    if(ORDER_ID != openerSelItem.order_id){
    	GochigoAlert('오류가 발생했습니다.다시 시도해 주세요.');
		self.close();
    }


    var url = '${orderCompInsert}';
    var params = {
    	ORDER_ID : ORDER_ID,
    	COMPONENT_ID : COMPONENT_ID,
    	CNT : CNT
    };

    var isSuccess = false;
    var queryCustom = "cobjectid=order_id&cobjectval="+ORDER_ID;

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
                //fnClose();
            }
        }
    });

    if(isSuccess){
    	opener.fnObj('LIST_admin_sale_order_customer_part_list').reloadGridCustom(queryCustom);
		//fnClose();
	}
}

</script>
