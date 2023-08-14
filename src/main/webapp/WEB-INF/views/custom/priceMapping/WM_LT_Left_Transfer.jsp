<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="updateCustomUseYN"								value="/priceMapping/updateCustomUseYN.json" />
<c:url var="customDataListPrice"								value="/customDataListPrice.json" />
<c:url var="transferMapping"										value="/priceMapping/transferMapping.json" />

<c:url var="dataList"													value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>


<style>

</style>
<script>

var _L_ID;
var _R_ID;

$(document).ready(function() {

	console.log("load [WM_LT_Transfer_Left_List.js]");

	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

	fnChangeDivWidth();
	$('#pricemapping_transfLefterbtn').css('float','right');

	var label= '<label id="lbleft">매핑여부</label>';
	$('#${sid}_btns').prepend(label);
	$('#lbleft').css('float','left');

	init1();
});

function fnChangeDivWidth(){
    var Cwidth = $('#${sid}_header_title').width();
    $('#${sid}_btns').css({'width':Cwidth-15+'px'});
}


function init1(){

	console.log("${sid}.init1() Load");

	var openerGrid = opener.$('#pricemapping_wm_wm_left_list_gridbox').data('kendoGrid');
	var openerSelItem = openerGrid.dataItem(openerGrid.select());
	if(!openerSelItem) {
		GochigoAlert('부모의 선택된 항목이 없습니다.');
		self.close();
	}

	$('#lbleft').text(openerSelItem.part_name);

	var url = '${dataList}';

	var qStr = "";

	qStr += '&cobjectid=WORLDMEMORY_ID';
    qStr += '&cobjectval=' + openerSelItem.other_purchase_part_id;


    fnObj('LIST_${sid}').reloadGridCustomPrice(qStr);
}


function fnLeftToRight(){


	var url = '${transferMapping}';

	var openerGridL = opener.$('#pricemapping_wm_wm_left_list_gridbox').data('kendoGrid');
	var openerSelItemL = openerGridL.dataItem(openerGridL.select());
	if(!openerSelItemL) {
		GochigoAlert('부모의 선택된 항목이 없습니다.');
		return;
	}

	var openerGridR = opener.$('#pricemapping_wm_wm_right_list_gridbox').data('kendoGrid');
	var openerSelItemR = openerGridR.dataItem(openerGridR.select());
	if(!openerSelItemR) {
		GochigoAlert('부모의 선택된 항목이 없습니다.');
		return;
	}

	var L_ID = openerSelItemL.other_purchase_part_id;
	var R_ID = openerSelItemR.other_purchase_part_id;

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

					var listPartId = [];
					 rows.each(function (index, row) {
						 var gridData = grid.dataItem(this);
						 listPartId.push(gridData.lt_custom_part_id);
					 });

					var params = {
							PART_ID : listPartId.toString(),
							TARGET_ID : R_ID
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
						 init1();
						 init2();
						 opener.fnObj('LIST_pricemapping_wm_wm_left_list').reloadGrid();
						 opener.fnObj('LIST_pricemapping_wm_wm_right_list').reloadGrid();


					}

					//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "<h3>선택한 LT 매핑 부품을 오른쪽 W사 부품으로 매핑하시겠습니까?</h3>"
	}).data("kendoConfirm").open();
	//끝지점

}


</script>
