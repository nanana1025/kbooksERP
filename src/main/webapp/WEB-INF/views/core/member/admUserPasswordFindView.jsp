<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlFindPasswd"					value="/member/findPassWdProc.json" />
<c:url var="urlResetPasswd"					value="/member/resetPasswdProc.json" />



<!DOCTYPE html>
<html>
<head>
    <title>Inventory Control</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta charset="utf-8"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/fonts/NotoSansKR/stylesheets/NotoSansKR-Hestia.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/style.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/sub_style.css"/>

    <script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="/codebase/kendo/messages/kendo.messages.ko-KR.min.js"></script>
	<script src="/codebase/kendo/jszip.min.js"></script>
    <script src="/codebase/common.js"></script>
    <script src="/codebase/default.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.ui.js"></script>
    <script src="/js/gochigo.utils.js"></script>
    <script src="/js/gochigo.kendo.ui.js"></script>

    <style>
    ::placeholder { /* Chrome, Firefox, Opera, Safari 10.1+ */
        color: #ffffff;
        opacity: 1; /* Firefox */
    }
    :-ms-input-placeholder { /* Internet Explorer 10-11 */
        color: #ffffff;
    }
    ::-ms-input-placeholder { /* Microsoft Edge */
        color: #ffffff;
    }
    .fieldlist li {
    		padding-bottom: 0;
	}

	.user_type > span {
		cursor: pointer;
	}

    </style>
    <script>
    	var _systemName = '${sysInfo.SYSTEM_NM}';
    	var _mainView;
    	var _userId;
    	var _Email;

    	$(document).ready(function(){

    		$("#resetPasswd").hide();
    		$("#newPassWd").hide();
    		$("#newPassWdConfirm").hide();
    		_mainView = $('.login-section3');

    	});




    	// 비밀번호 찾기
    	function fnFindPW() {
    		// 이메일 형식 체크

    		if($("#ID").val() == null || $("#ID").val() == ""){
    			GochigoAlert("ID를 입력하세요");
    			$("#ID").focus();
    			return false;
    		}

    		if(!fnEMailCheck($("#EMAIL").val())){
    			$("#EMAIL").focus();
    			return;
    		}

    		$.ajax({
    	        url : "${urlFindPasswd}",
    	        async: false,
    	        data : fnParam(),
    	        type: "POST",
    	        success : function(data, status) {
    	        	if(data.result){
    	        		_userId = $("#ID").val();
    	            	_Email = $("#EMAIL").val();

    	            	$("#resetPasswd").show();
    	            	$("#newPassWd").show();
    	        		$("#newPassWdConfirm").show();

    	        		_mainView.css('height','454px');

    	        		GochigoAlert("회원정보가 확인되었습니다. 아래 화면에서 새로운 비밀번호를 입력하세요.");

    				} else {
    					if(data.ERROR)
    						GochigoAlert("오류가 발생했습니다. 관리자에게 문의하세요.");
    					else{
    						GochigoAlert("가입 정보가 없습니다.");
    						$("#resetPasswd").hide();
    						$("#newPassWd").hide();
    			    		$("#newPassWdConfirm").hide();
    			    		_mainView.css('height','300px');
    					}
    				}
    	        },
    	        error: function(req, stat, error) {
    	        }
    	    });
    	}

    	// 가입하기
    	function fnChangePW() {

    		//비밀번호 체크
    		var PW = $("#PW").val();
    		if(PW != "") {
    			if(PW != $("#RE_PW").val() ) {
    				GochigoAlert("비밀번호와 비밀번호확인이 일치하지 않습니다.");
    				$("#PW").focus();
    				return false;
    			}
    		}

//     		// 비밀번호 길이
//     		if (PW.length < 8 || PW.length > 16) {
//     			GochigoAlert("비밀번호는 8 ~ 16 자리로 입력해야 합니다.");
//     			return false;
//     		}

//     		// 비밀번호 조합
//     		if (!fnInValidPasswordComplexity(PW)) {
//     			GochigoAlert("비밀번호는 영문(대문자/소문자), 숫자, 특수문자의 조합으로 입력해야 합니다.");
//     			return false;
//     		}

//     		// 연속성 체크 (동일문자를 3번연속 사용 금지, (1,2,3)이나 (a,b,c)등 연속되는 숫자 및 영문 사용 금지)
//     		if (!fnContinuityPassword(PW)){
//     			return false;
//     		}

    		// 이메일 중복 체크
//     		if(!fnEmailCk()){
//     			return false;
//     		}

    		// 별명 중복 체크
//     		if(!fnNickNameCk()){
//     			return false;
//     		}

    		var isSuccess = false

    		$.ajax({
    	        url : "${urlResetPasswd}",
    	        async: false,
    	        data : fnParamWithPw(),
    	        type: "POST",
    	        success : function(data, status) {
    	        	if(data.success)
    	        		GochigoAlert(data.MSG);
    	        	else
    	        		GochigoAlert(data.MSG);
    	        },
    	        error: function(req, stat, error) {
    	        }
    	    });
    	}

    	// 파라미터
    	function fnParam() {
    		return {
    			USER_ID: $("#ID").val()
    			, EMAIL : $("#EMAIL").val()
    		};
    	}
    	function fnParamWithPw() {
    		return {
    			USER_ID: _userId
    			, EMAIL : _Email
    			, PW : $("#PW").val()
    		};
    	}

    </script>
</head>
<body class="login">
<div id="loginFrm" >
<div class="login-div">
    <div class="login-section3 k-content">
<div class="sc_title">
		<div class="title_line"></div>
				<h2>비밀번호 찾기 </h2>
			</div>

			<div class="sc_form">
				<div class="section">
					<table class="tbl_h">
	                	<caption>Basic</caption>
						<colgroup>
							<col width="22%">
							<col width="*">
						</colgroup>
						<tbody>
							<tr>
								<th>ID</th>
								<td>
									<div class="inputwrap">
										<input type="text" class="w100_18p dis_inbl" id="ID" name="ID" class="MB10" value="" placeholder="ID">
									</div>
								</td>
							</tr>
							<tr>
								<th>E-MAIL</th>
								<td>
									<div class="inputwrap">
										<input type="text" class="w100_18p dis_inbl" id="EMAIL" name="EMAIL" class="MB10" value="" placeholder="E-MAIL">
									</div>
								</td>
							</tr>
							<tr >
								<td>
								</td>
								<td>
									<div class="inputwrap input_btn_wr2">
										<button class="dis_inbl btn_cl1" onClick="fnFindPW()">비밀번호 찾기</button>
									</div>
								</td>
							</tr>

							<tr id = "newPassWd">
								<th>새로운 비밀번호</th>
								<td>
									<input type="password" name="PW" id="PW" placeholder="비밀번호" />
									<span>비밀번호는 영문(대문자/소문자), 숫자, 특수문자의 조합으로 입력해야 합니다.</span>
								</td>
							</tr>
							<tr id = "newPassWdConfirm">
								<th>비밀번호 확인</th>
								<td>
									<input type="password" name="RE_PW" id="RE_PW" placeholder="비밀번호 확인" class="MB10" />
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="input_btn_wr2 mgt20">
				<a href="/admin/login.do" class="cc">로그인 화면으로 이동 </a>
				<button id = "resetPasswd" class="sb" onClick="fnChangePW()">비밀번호 변경하기</button>
				</div>
			</div>
    </div>
</div>
</div>
</body>
</html>