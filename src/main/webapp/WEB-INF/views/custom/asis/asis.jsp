<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />



<style>
</style>
<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>
<script>

$(document).ready(function() {

	console.log("load [commonRemoveBtn.js]");

	$('.basicBtn').remove();
	//$('#selectBtn').remove();
 	$('#${sid}_gridbox').off('dblclick');


	setTimeout(function() {
// 		$('.basicBtn').remove();
// 		$('#selectBtn').remove();

// 		var infCond = '<button id="customSelectBtn" class="k-button" onclick="fnCustomSelect()" data-role="button" role="button" aria-disabled="false" tabindex="0">선택</button>';

// 		$('#popup_btns').prepend(infCond);
// 		opener.$('#COMPONENT_ID').attr("class", "include")

	}, 1000);
});


function customfunction_URL(){

	setTimeout(function() {
		var grid = $('#${sid}_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


		if(selItem.url == ''){return;}

		var url = selItem.url

    	window.open("<c:url value='"+url+"'/>");

	}, 10);



}

</script>
