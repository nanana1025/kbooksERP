<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>알림메일</title>
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
<script src="/codebase/common.js"></script>
<script src="/codebase/default.js"></script>
<script src="/codebase/gochigo.kendo.common.js"></script>
<script src="/codebase/gochigo.kendo.util.js"></script>
<script src="/codebase/gochigo.kendo.util.js"></script>

<style type="text/css">
#popContainer {
	background-color: #eff2f7;
	width: 100%;
	height: 100%;
}
.fieldSet {
	display: inline-block;
	margin: 10px 10px;
	background-color: #ffffff;
	border: 1px solid #d6d6d9;
}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		fnSetUserNmAndEmail();
		kendoComponent();
		buttonEvent();

		$('iframe.k-content').contents().find('html').on('click', function(e){
			$('iframe.k-content').contents().find('body').focus();
		});
    });

	function fnSetUserNmAndEmail() {
		var userNmStr = opener._userNms.join(',');
		$('#user_nm').val(userNmStr);

		var emailStr = opener._emails.join(',');
		$('#send_to').val(emailStr);
	}

    function fnClose() {
    	self.close();
    }

    function kendoComponent() {
    	$('#mail_content').kendoEditor({
    		resizable: {content: true, toolbar: false},
    		tools: [
    			'bold','italic','underline','strikethrough','fontName','fontSize','foreColor','backColor',
    			'justifyLeft','justifyCenter','justifyRight','justfifyFull',
    			'insertUnorderedList','insertOrderedList','indent','outdent',
    			'createLink','insertImage',
    			'tableWizard','createTable'
    		],
    		imageBrowser: {
    			path: "admin",
    			messages: {
    				dropFilesHere: "파일을 드래그하십시오."
    			},
    			transport: {
    				read: "/imageBrowser/read",
    				destroy: {
    					url : "/imageBrowser/destroy",
    					type : "POST"
    				},
    				create: {
    					url : "/imageBrowser/create",
    					type : "POST"
    				},
    				thumbnailUrl: "/imageBrowser/thumbnail",
    				uploadUrl: "/imageBrowser/upload",
    				imageUrl: location.origin+"/imageBrowser/image?path={0}"
    			}
    		}
    	});
    }

    function buttonEvent() {
    	$('#saveBtn_freemail').kendoButton();
        var saveBtn = $('#saveBtn_freemail').data('kendoButton');
        saveBtn.bind('click', function(e) {
			var title = $('#mail_title').val();
			var editor = $("#mail_content").data("kendoEditor");
			var content = editor.value();
			if(!title){
				alert("제목이 없습니다.");
				return;
			}
			if(!content){
				alert("내용이 없습니다.");
				return;
			}
			var url = "/charging/premiumuserSendMailProc.json";
			var params = {
				ADDRESS : $('#send_to').val(),
				TITLE : title,
				CONTENT : content
			}
			$.ajax({
				url : url,
				type : "POST",
				data : params,
				async : false,
				success : function(data) {
					if(data.success){
						alert(data.message);
						fnReloadGrid();
						window.close();
					}
				}
			})
        });
        $('#cancelBtn_freemail').kendoButton();
        var cancelBtn = $('#cancelBtn_freemail').data('kendoButton');
        cancelBtn.bind('click', function(e) {
        	window.close();
        });
    }
	</script>
</head>
<body>
<div id="popContainer">
	<div id="freemail_header_title" class="header_title">
		<span class="pagetitle"><span class="k-icon k-i-copy"></span>알림메일</span>
	</div>
	<div class="content">
		<div id="freemail_view-btns" class="view_btns">
			<button id="saveBtn_freemail" class="">발송</button>
			<button id="cancelBtn_freemail">취소</button>
		</div>
		<fieldSet class="fieldSet">
			<input type="hidden" id="FILE_COL" name="FILE_COL" value=""/>
			<table id="tbl_freemail">
				<colgroup width="800px">
					<col width="100px"/>
					<col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<td style="text-align:right;">받는 사용자명</td>
						<td><input type="text" id="user_nm" class="k-textbox" style="width:100%;" value="" disabled="disabled"/></td>
					</tr>
					<tr>
						<td style="text-align:right;">받는 메일 주소</td>
						<td><input type="text" id="send_to" class="k-textbox" style="width:100%;" value="" disabled="disabled"/></td>
					</tr>
					<tr>
						<td style="text-align:right;">제목</td>
						<td><input type="text" id="mail_title" class="k-textbox" style="width:100%;"/></td>
					</tr>
					<tr>
						<td style="text-align:right;">내용</td>
						<td><textarea id="mail_content"  class="k-textbox" rows="12" style="width:100%;"></textarea></td>
					</tr>
				</tbody>
			</table>
		</fieldSet>
	</div>
</div>
</body>
</html>
