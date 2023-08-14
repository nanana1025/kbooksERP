<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="invenDelete"				value="/compInven/invenDelete.json" />
<c:url var="print"						value="/print/print.json"/>
<c:url var="pawdInit"					value="/user/userPawdInit.json" />
<c:url var="dataList"					value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>

<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [list_inventory.js]");
	$('.basicBtn').remove();
	//$('#admin_nurse_list_gridbox').off('dblclick');

});


function fnDelInventory() {
	console.log("${sid}.fnDelInventory() Load");

	var url = '${invenDelete}';

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var warehousingId = selItem.state_cd;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				params = {
						INVENTORY_ID: selItem.inventory_id,
				};

				$.ajax({
					url : url,
					type : "POST",
					data : params,
					async : false,
					success : function(data) {
						if(data.success){
							GochigoAlert(data.MSG);
							fnObj('LIST_${sid}').reloadGrid();
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
	    content: "정말 삭제하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점

 }

function fnPrint() {
// 	console.log("${sid}.fnPrint() Load");

// 	var url = '${print}';

// 	var params = "";
// 	var msg = "";
// 	var grid = $('#${sid}_gridbox').data('kendoGrid');
// 	var selItem = grid.dataItem(grid.select());
// 	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


// 	var warehousingId = selItem.state_cd;

// 	//시작지점
// 	$("<div></div>").kendoConfirm({
// 		buttonLayout: "stretched",
// 		actions: [{
// 			text: '확인',
// 			action: function(e){
// 				//시작지점

// 				params = {
// 						INVENTORY_ID: selItem.inventory_id,
// 				};

// 				$.ajax({
// 					url : url,
// 					type : "POST",
// 					data : params,
// 					async : false,
// 					success : function(data) {
// 						if(data.success){
// 							GochigoAlert(data.MSG);
// 							fnObj('LIST_${sid}').reloadGrid();
// 						}
// 						else{
// 							GochigoAlert(data.MSG);
// 						}
// 					}
// 				});
// 				//끝지점
// 			}
// 		},
// 		{
// 			text: '닫기'
// 		}],
// 		minWidth : 200,
// 		title: fnGetSystemName(),
// 	    content: "정말 삭제하시겠습니까?"
// 	}).data("kendoConfirm").open();
// 	//끝지점

 }

</script>
