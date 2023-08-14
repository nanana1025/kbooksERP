<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlIDCheck"					value="/member/idCheckProc.json" />
<c:url var="urlEmailCheck"				value="/member/emailCheckProc.json" />
<c:url var="urlNickNameCheck"			value="/member/nickNameCheckProc.json" />
<c:url var="urlSave"					value="/member/userInstProc.json" />
<c:url var="urlLogin"					value="/admin/login.do" />
<c:url var="urlCompanyIDCheck"			value="/member/companyIdCheckProc.json" />


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
    	$(document).ready(function(){

    		//document.onkeydown = doNotReload;

    		$("#EMAIL").keyup(function(){
    			$("#EMAIL_CHECK").val("F");
    		});

    		$("#NICK_NM").keyup(function(){
    			$("#NICK_NM_CHECK").val("F");
    		});

    	});

    	function doNotReload(){
    	    if( (event.ctrlKey == true && (event.keyCode == 78 || event.keyCode == 82)) || (event.keyCode == 116) ) {
    	        event.keyCode = 0;
    	        event.cancelBubble = true;
    	        event.returnValue = false;
    	    }
    	}

    	function insertEmailAddr() {
    		if ($("#emailSecond").val().toString() !== "etc") {
				$("#emailCustom").attr("disabled", true);
				$("#emailCustom").val($("#emailSecond").val());
			} else {
				$("#emailCustom").attr("disabled", false);
				$("#emailCustom").val('');
			}
		}

		// 사업자 등록번호 유효성 체크
		function fnCheckCompanyNo() {
    		const companyNo = $("#companyNo").val().replaceAll("-","");
			if(companyNo == null || companyNo == ""){
				GochigoAlert("사업자 등록번호를 입력하세요");
				$("#ID").focus();
				return false;
			}
			if (companyNo.length !== 10) {
				GochigoAlert("사업자 등록번호는 10자리 숫자로 입력해주세요.");
				return false;
			}

			const numberPattern = /[0-9]/;
			for(let i=0; i < companyNo.length; i++) {
				if (!numberPattern.test(companyNo[i])) {
					GochigoAlert("사업자 등록번호는 10자리 숫자로 입력해주세요.");
					return false;
				}
			}

			$.ajax({
				url : "${urlCompanyIDCheck}",
				async: false,
				data : fnParam(),
				type: "POST",
				success : function(data, status) {
					$("#COMPANY_NM").val("");
					$("#COMPANY_NM").removeAttr("readOnly");

					if(data.COMPANYID_CHECK){
						GochigoAlert("사업자 등록번호가 확인되었습니다.");
						$("#COMPANYNO_CHECK").val("OK");
						if (data.COMPANY_ID !== "-1"){
							$("#COMPANY_ID").val(data.COMPANY_ID);
							$("#COMPANY_NM").val(data.COMPANY_NM);
							$("#COMPANY_NM").attr("readOnly",true);
						}
					} else {
						GochigoAlert("오류가 발생했습니다. 관리자에게 문의하세요.");
						$("#COMPANYNO_CHECK").val("F");
						$("#COMPANY_NO").focus();
					}
				},
				error: function(req, stat, error) {
				}
			});

			// GochigoAlert("사업자 등록번호가 확인되었습니다.");
			// $("#COMPANYNO_CHECK").val("OK");
    		return true;
		}

    	// 아이디 중복체크
    	function fnFindID() {
    		if($("#ID").val() == null || $("#ID").val() == ""){
    			GochigoAlert("ID를 입력하세요");
    			$("#ID").focus();
    			return false;
    		}

    		$.ajax({
    	        url : "${urlIDCheck}",
    	        async: false,
    	        data : fnParam(),
    	        type: "POST",
    	        success : function(data, status) {
    	        	if(data.ID_CHECK){
    	        		GochigoAlert("해당 아이디는 사용 가능합니다.");
    					$("#ID_CHECK").val("OK");
    				} else {
    					if(data.ERROR)
    						GochigoAlert("오류가 발생했습니다. 관리자에게 문의하세요.");

    					else{
    						GochigoAlert("이미 가입되어 있는 아이디입니다.\n다른 아이디를 입력해주세요.");
    					}

    					$("#ID_CHECK").val("F");
    					$("#ID").focus();
    				}
    	        },
    	        error: function(req, stat, error) {
    	        }
    	    });

    		return false;

    	}

    	// 이메일 중복체크
    	function fnFindEmail() {
    		// 이메일 형식 체크
    		if(!$("#emailFirst").val()){
    			$("#emailFirst").focus();
    			return;
    		}
			if($("#emailSecond").val().toString() === "etc") {
				if (!$('#emailCustom').val()) {
					$("#emailCustom").focus();
					return;
				}
			} else if($("#emailSecond").val().toString() === "select") {
				$("#emailSecond").focus();
				return;
			} else {
				if (!$('#emailSecond').val()) {
					$("#emailSecond").focus();
					return;
				}
			}

    		$.ajax({
    	        url : "${urlEmailCheck}",
    	        async: false,
    	        data : fnParam(),
    	        type: "POST",
    	        success : function(data, status) {
    	        	if(data.EMAIL_CHECK){
    	        		GochigoAlert("해당 이메일은 사용 가능합니다.");
    					$("#EMAIL_CHECK").val("OK");
    				} else {
    					if(data.ERROR)
    						GochigoAlert("오류가 발생했습니다. 관리자에게 문의하세요.");
    					else{
    						GochigoAlert("이미 가입되어 있는 이메일입니다.\n다른 이메일을 입력해주세요.");
    					}

    					$("#EMAIL_CHECK").val("F");
    					$("#EMAIL").focus();
    				}
    	        },
    	        error: function(req, stat, error) {
    	        }
    	    });
    	}
    	function fnEmailCk() {
    		// 이메일 형식 체크
    		var check = false;
    		$.ajax({
    	        url : "${urlEmailCheck}",
    	        async: false,
    	        data : fnParam(),
    	        type: "POST",
    	        success : function(data, status) {
    	        	if(data.EMAIL_CHECK){
    	        		check = true;
    				} else {
    					GochigoAlert("이미 가입되어 있는 이메일입니다.\n다른 이메일을 입력해주세요.");
    					$("#EMAIL_CHECK").val("F");
    					$("#EMAIL").focus();
    				}
    	        },
    	        error: function(req, stat, error) {
    	        }
    	    });

    		return check;
    	}

    	// 가입하기
    	function fnSave() {
    		// 사용자구분
    		// var USER_TYPE_CD = $("input:radio[name='USER_TYPE_CD']:checked").val();

    		if($("#ID_CHECK").val() == "F"){
    			GochigoAlert("아이디 중복체크를 실행해주세요.");
    			$("#ID").focus();
    			return false;
    		}

			if($("#COMPANYNO_CHECK").val() == "F"){
				GochigoAlert("사업자 등록번호 체크를 실행해주세요.");
				$("#companyNo").focus();
				return false;
			}

    		if($("#EMAIL_CHECK").val() == "F"){
    			GochigoAlert("이메일 중복체크를 실행해주세요.");
    			$("#EMAIL").focus();
    			return false;
    		}

    		if($("#COMPANY_NM").val() == ""){
				GochigoAlert("회사 이름을 입력해주세요.");
				$("#COMPANY_NM").focus();
				return false;
			}

    		//비밀번호 체크
    		var PW = $("#PW").val();
    		if(PW != "") {
    			if(PW != $("#RE_PW").val() ) {
    				GochigoAlert("비밀번호와 비밀번호확인이 일치하지 않습니다.");
    				$("#PW").focus();
    				return false;
    			}
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

    		if (!$('#hp2').val() || !$('#hp3').val()) {
				GochigoAlert("휴대폰 번호를 입력해주세요.");
				if (!$('#hp2').val()) {
					$('#hp2').focus();
				} else {
					$('#hp3').focus();
				}
				return  false;
			}

    		GochigoKendoProgressLoading("#kendo-loader");	// 로딩바 생성

    		var isSuccess = false;
			console.log(fnParam());
    		$.ajax({
    	        url : "${urlSave}",
    	        async: false,
    	        data : fnParam(),
    	        type: "POST",
    	        success : function(data, status) {
    	        	GochigoAlert(data.MSG);
                	GochigoKendoProgressClose("#kendo-loader");	// 로딩바 제거
    	        	if(data.success)
    	        		isSuccess = true;
    	        },
    	        error: function(req, stat, error) {
    	        }
    	    });

    		if(isSuccess){
    			setTimeout(function() {
    				location.href = "${urlLogin}";
    				}, 5000);
    		}

    		/*
    		$.post("${urlSave}", fnParam(), function(data) {
    			GochigoAlert(data.MSG);
            	GochigoKendoProgressClose("#kendo-loader");	// 로딩바 제거

            	if(data.success){
    				location.href = "${urlLogin}";
            	}
    		});*/

    		//location.href = "${urlLogin}";
    	}

    	// 파라미터
    	function fnParam() {
    		return {
    			USER_ID: $("#ID").val()
				, USER_TYPE_CD : "C"
				, USER_NM: $("#USER_NM").val()
				, COMPANY_NO: $("#companyNo").val().replaceAll("-","")
    			, EMAIL :  $("#emailFirst").val() + "@" + (($("#emailSecond").val().toString() !== "etc") ? $("#emailSecond").val() : $("#emailCustom").val())
    			, MOBILE : $("#hp1").val() + $("#hp2").val() + $("#hp3").val()
				, TEL : (!!$("#tel2").val() && !!$("#tel3").val()) ? ($("#tel1").val() + $("#tel2").val() + $("#tel3").val()) : ""
				, FAX : (!!$("#fax1").val() && !!$("#fax2").val() && !!$("#fax3").val()) ? ($("#fax1").val() + $("#fax2").val() + $("#fax3").val()) : ""
    			, PW : $("#PW").val()
				, POSITION: $("#position").val()
				, COMPANY_NM: $("#COMPANY_NM").val()
				, COMPANY_ID: $("#COMPANY_ID").val()
    		};
    	}


    </script>
</head>
<body class="login">
<div id="loginFrm" >
<div class="login-div">
    <div class="login-section1 k-content">
<div class="sc_title">
		<div class="title_line"></div>
				<h2>기업 회원가입</h2>
			</div>

			<div class="sc_form">
				<div class="section">
					<span class="essential">*</span>
					<span class="txt_title">필수 입력정보</span>
					<table class="tbl_h">
	                	<caption>Basic</caption>
						<colgroup>
							<col width="16%">
							<col width="*">
						</colgroup>
						<tbody>
<%--							<tr>--%>
<%--								<th><span class="essential">*</span>사용자 구분</th>--%>
<%--								<td>--%>
<%--									<div class="inputwrap input_btn_wr2 user_type" style="justify-content:flex-start;">--%>
<%--										<input type="radio" name="USER_TYPE_CD" value="S" style="margin-right: 10px;"> <span>관리자</span>--%>
<%--										<input type="radio" name="USER_TYPE_CD" value="U" checked="checked" style="margin-left: 30px; margin-right: 10px;"> <span>사용자</span>--%>
<%--										<input type="radio" name="USER_TYPE_CD" value="E" style="margin-left: 30px; margin-right: 10px;"> <span>기타(외부)</span>--%>
<%--									</div>--%>
<%--								</td>--%>
<%--							</tr>--%>
							<tr>
								<th><span class="essential">*</span>ID</th>
								<td>
									<div class="inputwrap input_btn_wr2">
										<input type="text" class="w100_95p dis_inbl login_input1 login_input2" id="ID" name="ID" class="MB10" value="" placeholder="ID">
										<input type="hidden" id="ID_CHECK" name="ID_CHECK" value="F">
										 <button class="dis_inbl btn_cl login_button" onClick="fnFindID()">중복체크</button>
									</div>
								</td>
							</tr>
							<tr>
								<th><span class="essential">*</span>사업자등록번호</th>
								<td>
									<div class="inputwrap input_btn_wr2">
										<input type="text" class="w100_95p dis_inbl login_input1 login_input2" id="companyNo" name="companyNo" class="MB10" value="" placeholder="사업자등록번호">
										<input type="hidden" id="COMPANYNO_CHECK" name="COMPANYNO_CHECK" value="F">
										<input type="hidden" id="COMPANY_ID" name="COMPANY_ID" value="-1">
										<button class="dis_inbl btn_cl login_button" onClick="fnCheckCompanyNo()">체크</button>
									</div>
									<span style="display: inline-block">하이픈(-)을 제외하고 입력해주세요.</span>
								</td>
							</tr>
							<tr>
								<th><span class="essential">*</span>E-MAIL</th>
								<td>
									<div class="inputwrap input_btn_wr2">
										<div class="mailArea">
											<input type="hidden" name="memEmail" value>
											<input type="text" class="iText login_input1" title="이메일아이디" id="emailFirst" name="memEmail" maxlength="50"></input>
											<span class="addr">@</span>
											<input type="text" class="iText login_input1" title="이메일주소" id="emailCustom" value="선택해주세요" disabled>
												<div class="customSelect mailSelect" style="display: inline-block;">
												<select class="iText login_input1 login_input2" id="emailSecond" name="memEmail3" onChange="insertEmailAddr()">
													<option value="select">선택해주세요</option>
													<option value="naver.com">naver.com</option>
													<option value="hanmail.net">hanmail.net</option>
													<option value="gmail.com">gmail.com</option>
													<option value="nate.com">nate.com</option>
													<option value="hotmail.com">hotmail.com</option>
													<option value="freechal.com">freechal.com</option>
													<option value="hanmir.com">hanmir.com</option>
													<option value="korea.com">korea.com</option>
													<option value="paran.com">paran.com</option>
													<option value="etc">직접입력</option>
												</select>
											</div>
										</div>

										<button class="dis_inbl btn_cl login_button" onClick="fnFindEmail()">중복체크</button>

									</div>
									<span>이메일 주소는 비밀번호 찾기, 새로운 기능 등을 알릴 경우  사용됩니다.</span>
								</td>
							</tr>
							<tr>
								<th><span class="essential">*</span>회사 이름</th>
								<td>
									<input type="text" id="COMPANY_NM" class="login_input1 input_width2" name="COMPANY_NM" value="" placeholder="회사 이름">
								</td>
							</tr>
							<tr>
								<th><span class="essential">*</span>사용자 이름</th>
								<td>
									<input type="text" id="USER_NM" class="login_input1 input_width2" name="USER_NM" value="" placeholder="사용자 이름">
								</td>
							</tr>
							<tr>
								<th><span class="essential">*</span>비밀번호</th>
								<td>
									<input type="password" class="login_input1 login_input2 input_width2" name="PW" id="PW" placeholder="비밀번호" />
									<span style="display: inline-block">비밀번호는 영문(대문자/소문자), 숫자, 특수문자의 조합으로 입력해야 합니다.</span>
								</td>
							</tr>
							<tr>
								<th><span class="essential">*</span>비밀번호 확인</th>
								<td>
									<input type="password" class="login_input1 login_input2 input_width2" name="RE_PW" id="RE_PW" placeholder="비밀번호 확인" class="MB10" />
								</td>
							</tr>
							<tr>
								<th><span class="essential"></span>&nbsp&nbsp&nbsp직급</th>
								<td>
									<input class="login_input1 input_width2" id="position" name="POSITION"/>
								</td>
							</tr>
							<tr>
								<th><span class="essential">*</span>MOBILE</th>
								<td>
									<div class="phoneNumber">
										<div class=customSelect">
											<select class="iText login_input1 input_width" id="hp1">
												<option value="010" selected="selected">010</option>
												<option value="011">011</option>
												<option value="016">016</option>
												<option value="017">017</option>
												<option value="018">018</option>
												<option value="019">019</option>
												<option value="0139">0139</option>
											</select>
											<span class="hypen">-</span>
											<input type="text" class="iText_short login_input1 input_width" id="hp2" title="앞번호4자리" maxlength="4">
											<span class="hypen">-</span>
											<input type="text" class="iText_short login_input1 input_width" id="hp3" title="뒷번호4자리" maxlength="4">
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<th>&nbsp&nbspTEL</th>
								<td>
									<div class="telephoneNumber">
										<div class=customSelect">
											<select class="iText login_input1 input_width" id="tel1">
												<option value="02" selected="selected">02</option>
												<option value="031">031</option>
												<option value="051">051</option>
												<option value="053">053</option>
												<option value="032">032</option>
												<option value="062">062</option>
												<option value="042">042</option>
												<option value="052">052</option>
												<option value="044">044</option>
												<option value="033">033</option>
												<option value="043">043</option>
												<option value="041">041</option>
												<option value="063">063</option>
												<option value="061">061</option>
												<option value="054">054</option>
												<option value="055">055</option>
												<option value="064">064</option>
											</select>
											<span class="hypen">-</span>
											<input type="text" class="iText_short login_input1 input_width" id="tel2" title="앞번호4자리" maxlength="4">
											<span class="hypen">-</span>
											<input type="text" class="iText_short login_input1 input_width" id="tel3" title="뒷번호4자리" maxlength="4">
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<th>&nbsp&nbspFAX</th>
								<td>
									<div class="faxNumber">
										<div class=customSelect">
											<input type="text" class="iText_short login_input1 input_width" id="fax1" title="앞번호4자리" maxlength="4">
											<span class="hypen">-</span>
											<input type="text" class="iText_short login_input1 input_width" id="fax2" title="중간번호4자리" maxlength="4">
											<span class="hypen">-</span>
											<input type="text" class="iText_short login_input1 input_width" id="fax3" title="뒷번호4자리" maxlength="4">
										</div>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="input_btn_wr2 mgt20">
				<a href="/admin/login.do" class="cc">취소 </a>
				<button class="sb" onClick="fnSave()">가입하기</button>
				</div>
			</div>
    </div>
</div>
</div>
</body>
</html>