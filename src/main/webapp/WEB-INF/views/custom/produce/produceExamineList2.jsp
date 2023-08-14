<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="createWarehousing"					value="/produce/createWarehousing.json" />
<c:url var="deleteWarehousing"					value="/produce/deleteWarehousing.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [warehousingExameList2.js]");

	$('#admin_produce_examine_list_printBtn').remove();
	$('#admin_produce_examine_list_deleteBtn').remove();
	$('#admin_produce_examine_list_insertBtn').remove();

// 	$(".k-grid-update").on('click', function(event){
// 		console.log("11212121212121212121212121");
// 	});

// 	k-grid-update


// 	window.onload = fuChangeDivWidth;
//     window.onresize = fuChangeDivWidth;

//     fuChangeDivWidth();
// 	$('#admin_produce_warehousing_examine_list_gridbox').off('dblclick');

// 	$("#admin_produce_warehousing_examine_list_gridbox").on("dblclick", "tr.k-state-selected", function() {
//         if($("#admin_produce_warehousing_examine_list_gridbox").find(".k-grid-edit-row").length) {
//             //edit모드

//             $("#admin_produce_warehousing_examine_list_gridbox").data("kendoGrid").cancelChanges();
//             // kendo.GochigoAlert("이미 편집중인 항목이 있습니다.");
//         } else {
//         	console.log("ㄷㄷㄷㄷㄷㄷㄷㄷ");
//         	var _grid = $("#admin_produce_warehousing_examine_list_gridbox").data("kendoGrid");
//             _grid.editRow(_grid.select());
//         }
//     });


});

function fuChangeDivWidth(){
    var Cwidth = $('#admin_produce_warehousing_all_list_searchDiv').width();
    $('#admin_produce_warehousing_all_list_btns').css({'width':Cwidth+'px'});
}


function fnCreateWarehousing1() {

	console.log("admin_produce_warehousing_all_list.fnCreateWarehousing() Load");

	var url = '${createWarehousing}';

	$.ajax({
		url : url,
		type : "POST",
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				fnObj('LIST_${sid}').reloadGrid();
			}
			else{
				GochigoAlert(data.MSG);
			}
		}
	});

}


function fnDeleteWarehousing1() {

	console.log("admin_produce_warehousing_all_list.fnDeleteWarehousing() Load");

	var url = '${deleteWarehousing}';

	var params = "";
	var msg = "";
	var grid = $('#admin_produce_warehousing_all_list_gridbox').data('kendoGrid');
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
						WAREHOUSING_ID: selItem.warehousing_id,
					};

					$.ajax({
						url : url,
						type : "POST",
						data : params,
						async : false,
						success : function(data) {
							if(data.SUCCESS){
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

</script>
