<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="releaseInventoryUpdate"					value="/release/releaseInventoryUpdate.json" />
<c:url var="releaseReturnInventory"					value="/release/releaseReturnInventory.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [releaseSalePart.js]");

	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();



	setTimeout(function() {

// 	 	$('.k-button').css('float','right');
 	}, 500);


});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_header_title').width()-20;
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}

function prohibit(){
	console.log("${sid}.prohibit() Load");

	var pGrid = $('#release_sale_order_all_list_gridbox').data('kendoGrid');
	var pSelItem = pGrid.dataItem(pGrid.select());
	if(!pSelItem) {GochigoAlert('선택된 항목이 없습니다.'); return false;}

	if(pSelItem.release_state == 'R'){
		GochigoAlert('출고완료된 출고에는 재고를 추가할 수 없습니다.');
		return false;
	}

	return true;
}

function fnInsertReleaseInventory() {
	console.log("${sid}.fnInsertReleaseInventory() Load");

	if(!prohibit())
			return;

	var width = 800;
	var height = 450;

	var xn = "release_sale_Order_Part_Insert_DATA";

	console.log( '${ptype}');
	var pid = 'release_sale_order_all_list';
	var ptype = '${ptype}';
	var grid = $('#'+pid+'_gridbox').data('kendoGrid');
    var oid = 'RELEASE_ID';
    var queryString = "";

    if(pid && ptype == 'LIST'){
        var objArr = oid.split(",");
        var selItem = grid.dataItem(grid.select());
        if(selItem){
            var qParam = new Array();
            for(var i = 0; i < objArr.length; i++){
                qParam.push(selItem.get(objArr[i].toLowerCase()));
            }

            var pStr = qParam.join(","); //value 구분자

            queryString += '&pid=${pid}';
            queryString += '&objectid=' + oid;
            queryString += '&'+oid+'=' + pStr;
        }
    }

//     queryString += '&componentCd=' + componentCd;

// 	queryString += '&height=' + height;

console.log(queryString);

    var xPos  = (document.body.clientWidth /2) - (800 / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (600 / 2);
   window.open("<c:url value='/dataView.do'/>"+"?xn="+xn+"&sid="+pid+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

}

function fnReleaseReturnInventory() {

	console.log("${sid}.fnReleaseReturnInventory() Load");

	var url = '${releaseReturnInventory}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();

	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var pGrid = $('#release_sale_order_all_list_gridbox').data('kendoGrid');
	var selItem = pGrid.dataItem(pGrid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.release_state == 'R'){
		GochigoAlert('출고완료되어 변경할 수 없습니다.');
		return;
	}

	var isSuccess = false;
	var queryCustom = "";

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				var listInventoryId = [];
				 rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 listInventoryId.push(gridData.inventory_id);
					 });

				 queryCustom = "cobjectid=release_id&cobjectval="+selItem.release_id;

				var params = {
				        RELEASE_ID :selItem.release_id,
				        INVENTORY_ID : listInventoryId.toString(),
				        ORDER_ID :selItem.order_id
				    };

				$.ajax({
					url : url,
					type : "POST",
					data : params,
					async : false,
					success : function(data) {
						if(data.SUCCESS){
							isSuccess = true;
							GochigoAlert(data.MSG);
// 							fnObj('LIST_${sid}').reloadGridCustom(queryCustom);
						}
						else{
							GochigoAlert(data.MSG);
						}
					}
				});

				 if(isSuccess){
// 				    	fnObj('LIST_sale_order_releasepart_list').reloadGridCustom(queryCustom);
// 				    	fnObj('LIST_sale_order_customerpart_list').reloadGridCustom(queryCustom);

				    	fnObj('LIST_release_sale_order_all_list').reloadGrid();
						//fnClose();
					}
				//끝지점
			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택하신 재고를 재고 목록으로 반환하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
