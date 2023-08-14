<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>




    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [test.js]");

	$('.basicBtn').remove();

	$('.k-grid-add').remove();

	setTimeout(function(){
		//$('.k-grid-delete').remove();
	},200);
});

</script>
