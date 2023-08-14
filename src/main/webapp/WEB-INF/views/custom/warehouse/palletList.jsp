<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="updatePallet"					value="/warehouse/updatePallet.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>



$(document).ready(function() {

	console.log("load [palletProcess.js]");
	$('#${sid}_deleteBtn').remove();

	setTimeout(function() {
		//$("#${sid}_deleteBtn").attr("onclick", null);
		//$("#${sid}_deleteBtn").attr("onclick", 'fnUpdate();');
	}, 500);

});

function fuChangeDivWidth(){


}


function fnUpdatePallet(){


	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var url = '${updatePallet}';

	params = {
		PALLET_ID: selItem.pallet_id,
		USE_YN: 'N'
	};

    $("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '삭제',
			action: function(e){
				//시작지점

		    $.ajax({
		        url : url,
		        type : "DELETE",
		        data : JSON.stringify(params),
				contentType: "application/json",
		        async : false,
		        success : function(data) {
		            if(data.SUCCESS){
		            	 fnObj('LIST_${sid}').reloadGrid();
		            	 GochigoAlert("처리되었습니다.");
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
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택한 적재위치를 삭제하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점



}

</script>
