<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="deleteConsignedInventory"					value="/consigned/deleteConsignedInventory.json" />
<c:url var="updateConsignedInventory"					value="/consigned/updateConsignedInventory.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

 var _pid = getParameterByName('pid');

$(document).ready(function() {

	console.log("load [consignedCompanyInventoryList.js]");
	$('.basicBtn ').remove();
	 $('#${sid}_gridbox').off('dblclick');


});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}




function fnInventoryDel() {

	console.log("${sid}.fnInventoryDel() Load");

	var url = '${deleteConsignedInventory}';

	console.log("pid = "+_pid);
	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	var rows = grid.select();
	if(selItem == null || rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}
// 	else if(rows.length > 1) {GochigoAlert('삭제는 하나의 부품만 처리 가능합니다.'); return;}

	var isSuccess = true;
	var rows = grid.select();
	rows.each(function (index, row) {
	 var gridData = grid.dataItem(this);

	 	if(gridData.inventory_state == 'R'){
			GochigoAlert('출고된 재고가 포함되어 있습니다.'); return;
			msg = '출고된 재고가 포함되어 있습니다.'; isSuccess = false; return;
		}else if(gridData.lock_yn == 'Y'){
			msg = '사용중인 재고가 포함되어 있습니다.'; isSuccess = false; return;
		}
 	});

	if(!isSuccess){
		 GochigoAlert(msg); return;
	 }

	if(selItem.inventory_state == 'R'){
		GochigoAlert('이미 출고된 재고입니다.'); return;
	}else if(selItem.inventory_state == 'D'){
		GochigoAlert('이미 삭제된 재고입니다.'); return;
	}else if(selItem.lock_yn == 'Y'){
		GochigoAlert('사용중인 재고입니다.'); return;
	}

	var params = {
	        COMPANY_ID : selItem.company_id,
	        COMPONENT_ID : selItem.component_id,
	        INVENTORY_ID : selItem.inventory_id,
	        INVENTORY_STATE: 'D',
	        TYPE: "C"
	    };

	var isSuccess = false;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				var listInventoryId= [];
					rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 listInventoryId.push(gridData.inventory_id);
				 });

				params.LIST_INVENTORY_ID = listInventoryId.toString();

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
				    		fnObj('LIST_${sid}').reloadGrid();
				    	opener.fnObj('LIST_'+_pid).reloadGrid();
					}

				//끝지점
			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "<h3>선택한 재고를 <font color=red>생산 대행 재고 </font>목록에서 삭제하시겠습니까?</h3>"
	}).data("kendoConfirm").open();
	//끝지점


}

function fnInventoryRelease() {

	console.log("${sid}.fnInventoryRelease() Load");

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(selItem == null || selItem.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var isSuccess = true;
	var rows = grid.select();
	rows.each(function (index, row) {
	 var gridData = grid.dataItem(this);

	 	if(gridData.inventory_cat == 'F'){
	 		msg = '불량 재고가 포함되어 있습니다. 불량재고는 출고할수 없습니다.'; isSuccess = false; return;
		}else if(gridData.lock_yn == 'Y'){
			msg = '사용중인 재고가 포함되어 있습니다.'; isSuccess = false; return;
		}
	 });

	 if(!isSuccess){
		 GochigoAlert(msg); return;
	 }

// 	if(selItem.inventory_state == 'R'){
// 		GochigoAlert('이미 출고된 재고입니다.'); return;
// 	}else if(selItem.inventory_state == 'D'){
// 		GochigoAlert('이미 삭제된 재고입니다.'); return;
// 	}else if(selItem.inventory_cat == 'F'){
// 		GochigoAlert('불량 재고는 출고할수 없습니다..'); return;
// 	}else if(selItem.lock_yn == 'Y'){
// 		GochigoAlert('사용중인 재고입니다.'); return;
// 	}

	var params = {
	        INVENTORY_ID : selItem.inventory_id,
	        INVENTORY_STATE: "R"
	    };

	var contents = "<h3>선택한 부품을 출고로 변경하시겠습니까?</h3>"
	fnInventoryUpdate(params, contents);

}

function fnInventoryEntry() {

	console.log("${sid}.fnInventoryEntry() Load");

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(selItem == null || selItem.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var isSuccess = true;
	var rows = grid.select();
	rows.each(function (index, row) {
	 var gridData = grid.dataItem(this);

// 	 	if(gridData.inventory_state == 'R'){
// 		 	msg = '출고된 재고가 포함되어 있습니다.'; isSuccess = false; return;
// 		}else
		if(gridData.lock_yn == 'Y'){
			msg = '사용중인 재고가 포함되어 있습니다.'; isSuccess = false; return;
		}
	 });

	 if(!isSuccess){
		 GochigoAlert(msg); return;
	 }

// 	if(selItem.inventory_state == 'R'){
// 		GochigoAlert('이미 출고된 재고입니다.'); return;
// 	}else if(selItem.inventory_state == 'D'){
// 		GochigoAlert('이미 삭제된 재고입니다.'); return;
// 	}else if(selItem.inventory_cat == 'F'){
// 		GochigoAlert('불량 재고는 출고할수 없습니다..'); return;
// 	}else if(selItem.lock_yn == 'Y'){
// 		GochigoAlert('사용중인 재고입니다.'); return;
// 	}

	var params = {
	        INVENTORY_ID : selItem.inventory_id,
	        INVENTORY_STATE: "E"
	    };

	var contents = "<h3>선택한 부품을 재고로 변경하시겠습니까?</h3>"
	fnInventoryUpdate(params, contents);

}

function fnInventoryGood() {

	console.log("${sid}.fnInventoryGood() Load");

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(selItem == null || selItem.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var isSuccess = true;
	var rows = grid.select();
	rows.each(function (index, row) {
	 var gridData = grid.dataItem(this);

	 	if(gridData.inventory_state == 'R'){
	 		msg = '출고된 재고가 포함되어 있습니다.'; isSuccess = false; return;
		}else if(gridData.lock_yn == 'Y'){
			msg = '사용중인 재고가 포함되어 있습니다.'; isSuccess = false; return;
		}else if(selItem.inventory_state == 'D'){
			msg = '삭제된 재고가 포함되어 있습니다.'; isSuccess = false; return;
		}
 	});

	 if(!isSuccess){
		 GochigoAlert(msg); return;
	 }

// 	if(selItem.inventory_state == 'R'){
// 		GochigoAlert('이미 출고된 재고입니다.'); return;
// 	}else if(selItem.inventory_state == 'D'){
// 		GochigoAlert('이미 삭제된 재고입니다.'); return;
// 	}else if(selItem.inventory_cat == 'G'){
// 		GochigoAlert('양품재고입니다.'); return;
// 	}else if(selItem.lock_yn == 'Y'){
// 		GochigoAlert('사용중인 재고입니다.'); return;
// 	}

	var params = {
	        INVENTORY_ID : selItem.inventory_id,
	        INVENTORY_CAT: "G"
	    };

	var contents = "<h3>선택한 재고를 양품으로 변경하시겠습니까?</h3>"
	fnInventoryUpdate(params, contents);

}

function fnInventoryFault() {

	console.log("${sid}.fnInventoryFault() Load");

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(selItem == null || selItem.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var isSuccess = true;
	var rows = grid.select();
	rows.each(function (index, row) {
	 var gridData = grid.dataItem(this);

		if(gridData.inventory_state == 'R'){
	 		msg = '출고된 재고가 포함되어 있습니다.'; isSuccess = false; return;
		}else if(gridData.lock_yn == 'Y'){
			msg = '사용중인 재고가 포함되어 있습니다.'; isSuccess = false; return;
		}else if(selItem.inventory_state == 'D'){
			msg = '삭제된 재고가 포함되어 있습니다.'; isSuccess = false; return;
		}
 	});

	if(!isSuccess){
		 GochigoAlert(msg); return;
	 }

// 	if(selItem.inventory_state == 'R'){
// 		GochigoAlert('이미 출고된 재고입니다.'); return;
// 	}else if(selItem.inventory_state == 'D'){
// 		GochigoAlert('이미 삭제된 재고입니다.'); return;
// 	}else if(selItem.inventory_cat == 'F'){
// 		GochigoAlert('불량재고입니다.'); return;
// 	}else if(selItem.lock_yn == 'Y'){
// 		GochigoAlert('사용중인 재고입니다.'); return;
// 	}

	var params = {
	        INVENTORY_ID : selItem.inventory_id,
	        INVENTORY_CAT: "F"
	    };

	var contents = "<h3>선택한 재고를 불량으로 변경하시겠습니까?</h3>"
	fnInventoryUpdate(params, contents);

}

function fnInventoryUpdate(params, contents) {

	console.log("${sid}.fnInventoryUpdate() Load");

	var url = '${updateConsignedInventory}';

	var isSuccess = false;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){

				//시작지점
				var grid = $('#${sid}_gridbox').data('kendoGrid');
				var rows = grid.select();

				var listInventoryId= [];
					rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 listInventoryId.push(gridData.inventory_id);
				 });

				params.LIST_INVENTORY_ID = listInventoryId.toString();

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
 			    		fnObj('LIST_${sid}').reloadGrid();
			    		opener.fnObj('LIST_'+_pid).reloadGrid();
				}

				//끝지점
			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: contents
	}).data("kendoConfirm").open();
	//끝지점


}


function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}


</script>
