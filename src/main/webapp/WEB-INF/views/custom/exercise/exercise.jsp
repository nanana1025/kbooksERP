<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="userInsert"					value="/exercise/userInsert.json" />
<c:url var="userUpdate"					value="/exercise/userUpdate.json" />


<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [exercise.jsp]");

 	$('#saveBtn_admin_user_list').remove();

 	setTimeout(function() {
	 	var ID = $('#ID').val();
	 	var infCond = "";

	 	console.log(ID);

	 	if(ID == null || ID == "")

	 		infCond = '<button id="insert_admin_user_list" onclick="fnInsertUser()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';
	 	else
	 		infCond = '<button id="update_admin_user_list" onclick="fnUpdateUser()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">수정</button>';

	 	$('#admin_user_list_view-btns').prepend(infCond);
// 	 	$('.k-button').css('float','right');
 	}, 300);

});


function fnInsertUser() {

	console.log("admin_user_list.fnInsertUser() Load");

	var ID = $('#ID').val();
	var NAME = $('#NAME').val();
	var AGE = $('#AGE').val();
	var HEIGHT = $('#HEIGHT').val();
	var WEIGHT = $('#WEIGHT').val();
	var ADDRESS = $('#ADDRESS').val();
	var CREATE_USER_ID = $('#CREATE_USER_ID').val();
	var UPDATE_USER_ID = $('#UPDATE_USER_ID').val();


	var url = '${userInsert}';
	var params = {
		ID : ID,
		NAME : NAME,
		AGE : AGE,
		HEIGHT : HEIGHT,
		WEIGHT : WEIGHT,
		ADDRESS : ADDRESS,
		CREATE_USER_ID : CREATE_USER_ID,
		UPDATE_USER_ID : UPDATE_USER_ID
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS)
				GochigoAlert(data.MSG);
			else
				GochigoAlert(data.MSG);
		}
	});
}


function fnUpdateUser() {
// 	여기에 입력




}

</script>
