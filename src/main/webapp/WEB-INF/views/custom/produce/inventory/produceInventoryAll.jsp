<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />



<style>
</style>
<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>
<script>

$(document).ready(function() {

	console.log("load [onlyPrint.js]");

	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();
	$('#${sid}_gridbox').off('dblclick');

	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
		fnProduceInventoryList();
    });

	setTimeout(function() {
// 		$('.basicBtn').remove();
// 		$('#selectBtn').remove();

// 		var infCond = '<button id="customSelectBtn" class="k-button" onclick="fnCustomSelect()" data-role="button" role="button" aria-disabled="false" tabindex="0">선택</button>';

// 		$('#popup_btns').prepend(infCond);
// 		opener.$('#COMPONENT_ID').attr("class", "include")

	}, 1000);
});

function fnProduceInventoryList(){

	console.log("${sid}.fnProduceInventoryList() Load");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(selItem.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
			INVENTORY_STATE : selItem.inventory_state,
	        COMPONENT_ID : selItem.component_id,
	        INVENTORY_CAT : selItem.inventory_cat,
	    };


	var url = "&pid=${sid}&CUSTOMKEY=COMPONENT_ID,INVENTORY_TYPE&CUSTOMVALUE="+params.COMPONENT_ID+",N";

	fnWindowOpen("/layoutNewList.do?xn=Inventory_Detail_LAYOUT"+url,"component_id", "S");

}

function fnWindowOpen(url, callbackName, size) {
    var width, height;
    if(size == "S"){
    	width = "1100";
    	height = "600";
    } else if(size == "M") {
    	width = "1024";
    	height = "768";
    } else if(size == "L") {
    	width = "1280";
    	height = "900";
    }else if(size == "F") {
    	width = $( window ).width()*0.95;
    	height = $( window ).height()*0.95;
    } else {
    	width = "800";
    	height = "600"
    }
	var xPos  = (document.body.clientWidth /2) - (width / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (height / 2);
    window.open("<c:url value='"+url+"'/>"+"&callbackName="+callbackName, "produceInventoryAll", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
}

</script>
