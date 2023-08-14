<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />



<style>
</style>
<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>
<script>

$(document).ready(function() {

	console.log("load [common.js]");

	//$('.basicBtn').remove();
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

</script>
