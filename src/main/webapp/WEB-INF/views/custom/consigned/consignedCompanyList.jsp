<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [consignedCompanyList.js]");

	setTimeout(function() {

    	$('#${sid}_gridbox').click(function(){
    		var checkBox = $("[id*='chVisible']");
    		var checked = checkBox.is(":checked");
    		checkBox.prop("checked", false);
		});



	}, 1000);

});


</script>
