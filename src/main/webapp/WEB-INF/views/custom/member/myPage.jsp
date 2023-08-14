<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="userUpdate"					value="/user/userUpdate.json" />



    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [myPage.js]");
	//$('#admin_nurse_list_gridbox').off('dblclick');


	setTimeout(function() {

        $('#PW').removeAttr("readonly");
        $('#PW').removeAttr("disabled");
        $('#RE_PW').removeAttr("readonly");
        $('#RE_PW').removeAttr("disabled");

 		var infCond = '<button id="update_${sid}" onclick="fnUpdateUser()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';

 		$('#saveBtn_${sid}').remove();
	 	$('#${sid}_view-btns').prepend(infCond);
 	}, 500);

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
    var PW = $('#PW').val();
    var RE_PW = $('#RE_PW').val();
    var USER_NM = $('#USER_NM').val();
    var EMAIL = $('#EMAIL').val();
    var MOBILE = $('#MOBILE').val();
    var TEL = $('#TEL').val();
    var COMPANY_CD = $('#COMPANY_CD').val();
    var DEPT_CD = $('#DEPT_CD').val();

    //비밀번호 체크
    if(PW != "" || RE_PW != "") {
        if(PW != RE_PW ) {
            GochigoAlert("비밀번호와 비밀번호확인이 일치하지 않습니다.");
            $("#PW").focus();
            return false;
        }

        // 비밀번호 길이
        if (PW.length < 8 || PW.length > 16) {
            GochigoAlert("비밀번호는 8 ~ 16 자리로 입력해야 합니다.");
            return false;
        }

        // 비밀번호 조합
        if (!fnInValidPasswordComplexity(PW)) {
            GochigoAlert("비밀번호는 영문(대문자/소문자), 숫자, 특수문자의 조합으로 입력해야 합니다.");
            return false;
        }

        // 연속성 체크 (동일문자를 3번연속 사용 금지, (1,2,3)이나 (a,b,c)등 연속되는 숫자 및 영문 사용 금지)
        if (!fnContinuityPassword(PW)){
            return false;
        }
    }

    var url = '${userUpdate}';

    var params = {
    		USER_ID : USER_ID,
            PW : PW,
    		USER_NM : USER_NM,
    		EMAIL : EMAIL,
    		MOBILE : MOBILE,
    		TEL : TEL,
    		COMPANY_CD : COMPANY_CD,
    		DEPT_CD : DEPT_CD,
    };

    $.ajax({
        url : url,
        type : "POST",
        data : params,
        async : false,
        success : function(data) {
            if(data.SUCCESS){
//             	opener.fnDropBoxonChange();
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
