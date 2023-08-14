<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="compDelete"				value="/compInven/compDelete.json" />
<c:url var="compVisibleYn"				value="/compInven/compVisibleYn.json" />

<c:url var="pawdInit"					value="/user/userPawdInit.json" />
<c:url var="dataList"					value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>

<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [list_component.js]");
// 	$('.basicBtn').remove();
	//$('#admin_nurse_list_gridbox').off('dblclick');

// 	$('#${sid}_printBtn').remove();
		$('#${sid}_deleteBtn').remove();
	 	$('#${sid}_insertBtn').remove();

		var infCondVisibleYn = '<button id="${sid}_customVisibleYnBtn" type="button" onclick="fnUpdateVisibleYn()" class="k-button" style="float: right;">숨기기</button>';
		$('#${sid}_btns').prepend(infCondVisibleYn);
});


function fnDelComponent() {
	console.log("${sid}.fnDeleteComponent() Load");

	var url = '${compDelete}';

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
						COMPONENT_ID: selItem.component_id,
				};

				$.ajax({
					url : url,
					type : "POST",
					data : params,
					async : false,
					success : function(data) {
						if(data.SUCCESS){
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

function fnUpdateVisibleYn() {
	console.log("${sid}.fnUpdateVisibleYn() Load");

	var url = '${compVisibleYn}';

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var isSuccess = false;
	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				var listComponentId= [];
					rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 listComponentId.push(gridData.component_id);
				 });

				params = {
						LIST_COMPONENT_ID:  listComponentId.toString(),
						VISIBLE_YN: 0
				};

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
				}
				//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택한 품목을 숨김처리 하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점

 }

</script>
