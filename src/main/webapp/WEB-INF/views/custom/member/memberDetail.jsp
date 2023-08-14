<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="userUpdate"					value="/user/userUpdate.json" />



    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [memberDetail.js]");
	//$('#admin_nurse_list_gridbox').off('dblclick');


	setTimeout(function() {

 		var infCond = '<button id="update_${sid}" onclick="fnUpdateUser()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';

 		$('#saveBtn_admin_member_list').remove();
	 	$('#${sid}_view-btns').prepend(infCond);
// 	 	$('.k-button').css('float','right');
 	}, 1000);

});

function fnClose(){
	console.log("load [fnClose.js]");

	if(typeof(opener) == "undefined" || opener == null) {
		history.back();
	} else {
		window.close();
	}
}

function fnUpdateUser() {
	console.log("fnUpdateUser()");

// 	여기에 입력
    var USER_ID = $('#USER_ID').val();
    var USER_NM = $('#USER_NM').val();
    var EMAIL = $('#EMAIL').val();
    var MOBILE = $('#MOBILE').val();
    var TEL = $('#TEL').val();
    var COMPANY_CD = $('#COMPANY_CD').val();
    var DEPT_CD = $('#DEPT_CD').val();
    var USER_TYPE_CD = $('#USER_TYPE_CD').val();
    var STATE_CD = $('#STATE_CD').val();



    var url = '${userUpdate}';

    var params = {
    		USER_ID : USER_ID,
    		USER_NM : USER_NM,
    		EMAIL : EMAIL,
    		MOBILE : MOBILE,
    		TEL : TEL,
    		COMPANY_CD : COMPANY_CD,
    		DEPT_CD : DEPT_CD,
    		USER_TYPE_CD : USER_TYPE_CD,
    		STATE_CD : STATE_CD,
    };

    $.ajax({
        url : url,
        type : "POST",
        data : params,
        async : false,
        success : function(data) {
            if(data.SUCCESS){
            	opener.fnDropBoxonChange();
                GochigoAlert(data.MSG);
            	//fnClose();
            }
            else{
                GochigoAlert(data.MSG);
                //fnClose();
            }
        }
    });
}

</script>
