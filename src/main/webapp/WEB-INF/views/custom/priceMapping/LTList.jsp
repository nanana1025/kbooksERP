<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />
<c:url var="dataList"					value="/customDataList.json" />

<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>

<style>
</style>

<script>

$(document).ready(function() {

	console.log("load [worldmemoeyList.js]");

	//$('.basicBtn').remove();
	//$('#selectBtn').remove();
	$('#${sid}_gridbox').off('dblclick');

	setTimeout(function() {
	$('#selectBtn').removeAttr("onclick");
	$('#selectBtn').attr("onclick", "fnCustomSelect();");


  	}, 1000);



  // 부품 타입 필터 END

//     setTimeout(function() {
// 		$('.basicBtn').remove();
// 		$('#selectBtn').remove();

// 		var infCond = '<button id="customSelectBtn" class="k-button" onclick="fnCustomSelect()" data-role="button" role="button" aria-disabled="false" tabindex="0">선택</button>';
// 		$('#popup_btns').prepend(infCond);
// 		//$('#popup_btns').css('text-align','right');
//         opener.$('#OTHER_PURCHASE_PART_ID').attr("class", "include");

//  		window.onload = fuChangeDivWidth;
//     	window.onresize = fuChangeDivWidth;

//    		fuChangeDivWidth();

// 	}, 1000);

});

function fuChangeDivWidth(){
	console.log("fuChangeDivWidth()");
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});

}

function fnCustomSelect(){

	console.log("Function fnCustomSelect()");

	//var url = '${selectCPU}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.');
	return;}

	var params = {
			LT_CUSTOM_PART_ID : selItem.lt_custom_part_id,
			COMPONENT_CD : selItem.component_cd,
			PART_KEY : selItem.part_key,
			PART_NAME: selItem.part_name,
			PRICE: selItem.price,
			CREATE_DT: selItem.create_dt
		};

	opener.$('#LT_CUSTOM_PART_ID').val(params.LT_CUSTOM_PART_ID);
	opener.$('#LT_PART_KEY').val(params.PART_KEY);
	opener.$('#LT_PART_NAME').val(params.PART_NAME);
  	// opener.$('#COMPONENT_CD').val(params.COMPONENT_CD);
    // opener.$('#COMPONENT_CD').siblings('.k-formatted-value').val(params.COMPONENT_CD);
	opener.$('#PRICE').val(params.PRICE);
 	opener.$('#PRICE').siblings('.k-formatted-value').val(params.PRICE);

	self.close();
}


</script>
