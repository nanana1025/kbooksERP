<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="matronUpdate"					value="/user/userMatronUpdate.json" />
<c:url var="replyUserData"					value="/user/userReplyUserData.json" />

<script>
	$(document).ready(function() {

		console.log("load [adminMatron.js]");

		var url = '${replyUserData}';

		setTimeout(function() {

			$('#user_id').on("change", function(){
					fnSetNursesInfo();
			});

			window["fnLinkCallback_user_id"] =  function(data){
				if(data) {
					$('#user_id').val(data.user_id);
					$('#user_nm').val(data.nurse_nm);
			 	}
			}


			window["MatronUpdate"] =  function(){

				var params = {
					WARD_NM: $('#ward_nm').val(),
					WARD_NO: $('#ward_no').val(),
					MATRON_ID: $('#matron_id').val(),
					USER_ID: $('#user_id').val()
				};

				$.ajax({
					url : url,
					type : "POST",
					data : params,
					success : function(data) {
						if(data.success)
							GochigoAlert('수정되었습니다', true);
						else
							GochigoAlert('오류가 발생했습니다. 관리자에게 문의하세요.', true);
					}
				});
			}
		}, 1200);
	});



function fnSetNursesInfo(){
	console.log("admin_matron_data.fnSetNursesInfo() Load");

	var url = '${replyUserData}';

	var params = {
		USER_ID: $('#user_id').val()
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			$('#user_nm').val(data.user_nm);
		}
	});

}

</script>
