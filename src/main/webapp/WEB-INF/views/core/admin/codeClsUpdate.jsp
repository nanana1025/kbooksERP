<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlCodeClsUpdateJson"		value="/admin/codeClsUpdate.json" />

<!DOCTYPE html>
<html>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<meta charset="utf-8"/>

	<link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

	<script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="/codebase/kendo/messages/kendo.messages.ko-KR.min.js"></script>
	<script src="/codebase/gochigo.kendo.util.js"></script>
	<script src="/codebase/common.js"></script>
	<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>
		#popContainer {
			background-color: #eff2f7;
			border-top: 3px solid #61e7ff;
			height:100%;
		}
		.fieldSet {
			display: inline-block;
			margin: 10px 10px 20px 10px;
			background-color: #ffffff;
			border: 1px solid #d6d6d9;
		}
		.footer-btns {
			width:100%;
			height:47px;
			line-height: 46px;
			vertical-align: middle;
			text-align: center;
			position:absolute;
			bottom: 0px;
			background-color: #cdd4e0;
		}
		html,
		body
		{
			height:100%;
			margin:0;
			padding:0;
			overflow:hidden;
		}
    </style>
<script>
/**
 * created by janghs
 */

$(document).ready(function() {

	$('#CODE_updateBtn').kendoButton();
	var updateBtn = $('#CODE_updateBtn').data('kendoButton');
	updateBtn.bind('click', function(e) {
		var params = {
			CODE_CLS: $('#CODE_CLS').val(),
			CODE_CLS_NM: $('#CODE_CLS_NM').val(),
			SORT_SEQ: $('#SORT_SEQ').val(),
			UP_CODE_CLS: $('#UP_CODE_CLS').val(),
			CODE_CLS_DESC: $('#CODE_CLS_DESC').val()
		}

		var url = '${urlCodeClsUpdateJson}';
		var param = $.param(params);
		$.post(url, param, function(rJson) {
			var result = JSON.parse(rJson);
			GochigoAlert(result.rMsg, true);

			if(result.success) {
            	window.opener.fnObj('TREE_admin_code_tree').fnReloadTree();
            	self.close();
			}
        });
    });

	$('#CODE_cancelBtn').kendoButton();
	var cancelBtn = $('#CODE_cancelBtn').data('kendoButton');
	cancelBtn.bind('click', function(e) {
    	self.close();
    });

});

</script>
<div id="popContainer">
	<div class="header_title">
	<span class="pagetitle">
		<span class="k-icon k-i-grid-layout"></span>코드수정
	</span>
</div>
	<div>
		<fieldset class="fieldSet">
			<table>
				<colgroup>
					<col width="120px">
					<col width="*">
				</colgroup>
				<tbody>
				<tr>
					<td>코드분류</td>
					<td><input type="text" class="k-textbox" id="CODE_CLS" name="CODE_CLS" maxlength="10" style="width:400px" disabled="disabled" value="${code.code_cls}" /></td>
				</tr>
				<tr>
					<td>코드분류명</td>
					<td><input type="text" class="k-textbox" id="CODE_CLS_NM" name="CODE_CLS_NM" maxlength="200" style="width:400px" value="${code.code_cls_nm}"/></td>
				</tr>
				<tr>
					<td>정렬순서</td>
					<td><input type="text" class="k-textbox" id="SORT_SEQ" name="SORT_SEQ" style="width:400px" value="${code.sort_seq}" /></td>
				</tr>
				<tr>
					<td>상위코드분류</td>
					<td><input type="text" class="k-textbox" id="UP_CODE_CLS" name="UP_CODE_CLS" maxlength="10" style="width:400px" value="${code.up_code_cls}" /></td>
				<tr>
				<tr>
					<td>코드분류설명</td>
					<td><input type="text" class="k-textbox" id="CODE_CLS_DESC" name="CODE_CLS_DESC" maxlength="1000" style="width:400px" value="${code.code_cls_desc}"/></td>
				</tr>
				</tbody>
			</table>
		</fieldset>
		<!-- 	<table class="stcsTable"> -->
		<%-- 		<col width="25%"> --%>
		<%-- 		<col width="25%"> --%>
		<%-- 		<col width="25%"> --%>
		<%-- 		<col width="25%"> --%>
		<!-- 		<tr> -->
		<!-- 			<th class='st_th'>코드ID</th> -->
		<!-- 			<th class='st_th'>코드명</th> -->
		<!-- 			<th class='st_th'>정렬순서</th> -->
		<!-- 			<th class='st_th'>상위코드ID</th> -->
		<!-- 		<tr> -->
		<%-- 			<td class='st_td'><input type='text' id='CODE_CLS' name="CODE_CLS" maxlength="256" disabled="disabled" value="${code.code_cls}" /></td> --%>
		<%-- 			<td class='st_td'><input type='text' id='CODE_CLS_NM' name="CODE_CLS_NM" maxlength="256" value="${code.code_cls_nm}" /></td> --%>
		<%-- 			<td class='st_td'><input type='number' id='SORT_SEQ' name="SORT_SEQ" value="${code.sort_seq}" /></td> --%>
		<%-- 			<td class='st_td'><input type='text' id='UP_CODE_CLS' name="UP_CODE_CLS" maxlength="256" value="${code.up_code_cls}" /></td> --%>
		<!-- 		</tr> -->
		<!-- 		<tr> -->
		<!-- 			<th class='st_th' colspan="4">코드분류설명</th> -->
		<!-- 		</tr> -->
		<!-- 		<tr> -->
		<%-- 			<td class='st_td' colspan="4"><input style="width:95%" type='text' id='CODE_CLS_DESC' name="CODE_CLS_DESC" maxlength="1000" value="${code.code_cls_desc}"/></td> --%>
		<!-- 		</tr> -->
		<!-- 	</table> -->
	</div>
	<div class="footer-btns">
		<button id="CODE_updateBtn" class="basicBtn">수정</button>
		<button id="CODE_cancelBtn" class="basicBtn">닫기</button>
	</div>
</div>
</html>