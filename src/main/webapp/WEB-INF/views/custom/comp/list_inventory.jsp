<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="deltProc"					value="/user/userDeltProc.json" />
<c:url var="pawdInit"					value="/user/userPawdInit.json" />
<c:url var="dataList"					value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>

<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [list_inventory.js]");
	//$('.basicBtn').remove();
	//$('#admin_nurse_list_gridbox').off('dblclick');


	var id = $('.grid_btns').attr('id');
	var btnId = id.replace("btns", "deleteBtn");
	$('#'+btnId).remove();
});


</script>
