<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="deleteConsignedInventory"					value="/consigned/deleteConsignedInventory.json" />


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
	if(selItem == null || selItem.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}


	if(selItem.inventory_state == 'R'){
		GochigoAlert('이미 출고된 재고입니다.'); return;
	}else if(selItem.inventory_state == 'D'){
		GochigoAlert('이미 삭제된 재고입니다.'); return;
	}


	var params = {
	        COMPANY_ID : selItem.company_id,
	        COMPONENT_ID : selItem.component_id,
	        INVENTORY_ID : selItem.inventory_id,
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


function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}


</script>
