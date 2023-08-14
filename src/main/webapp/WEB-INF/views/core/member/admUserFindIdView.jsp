<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlFindId"					value="/member/findIdProc.json" />



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

    	});

    	// 이메일 중복체크
    	function fnFindId() {
    		// 이메일 형식 체크
    		if(!fnEMailCheck($("#EMAIL").val())){
    			$("#EMAIL").focus();
    			return;
    		}

    		$.ajax({
    	        url : "${urlFindId}",
    	        async: false,
    	        data : fnParam(),
    	        type: "POST",
    	        success : function(data, status) {
    	        	if(data.result){
    	        		GochigoAlert("ID는 ["+data.USER_ID+"] 입니다.");
    				} else {
    					if(data.ERROR)
    						GochigoAlert("오류가 발생했습니다. 관리자에게 문의하세요.");
    					else{
    						GochigoAlert("가입 정보가 없습니다.");
    					}
    				}
    	        },
    	        error: function(req, stat, error) {
    	        }
    	    });
    	}

    	// 파라미터
    	function fnParam() {
    		return {
    			EMAIL : $("#EMAIL").val()
    		};
    	}

    </script>
</head>
<body class="login">
<div id="loginFrm" >
	<div class="login-div">
    	<div class="login-section2 k-content">
			<div class="sc_title">
			<div class="title_line">
				<h2>ID 찾기</h2>
			</div>
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
								<th>E-MAIL로 찾기</th>
								<td>
									<div class="inputwrap input_btn_wr2">
										<input type="text" class="w100_95p dis_inbl" id="EMAIL" name="EMAIL" class="MB10" value="" placeholder="E-MAIL">
										<button class="dis_inbl btn_cl" onClick="fnFindId()">ID 찾기</button>
									</div>
								</td>
							</tr>

						</tbody>
					</table>
				</div>
				<div class="input_btn_wr2 mgt20">
				<a href="/admin/login.do" class="cc">로그인 화면으로 이동 </a>
				</div>
			</div>
    </div>
</div>
</div>
</body>
</html>