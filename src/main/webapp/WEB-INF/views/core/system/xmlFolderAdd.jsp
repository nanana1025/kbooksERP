<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>XML폴더 추가</title>
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
	<script src="/codebase/kendo/jszip.min.js"></script>
    <script src="/codebase/common.js"></script>
    <script src="/codebase/default.js"></script>
    <script src="/codebase/gochigo.kendo.common.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
	<style>

	</style>
    <script>
        $(document).ready(function() {
			$('#new_folder_nm').val(decodeURI('${folderNm}'));
			$('#addBtn').kendoButton();
            var addBtn = $('#addBtn').data('kendoButton');
            addBtn.bind('click', function(e) {
                addFolder();
            });
            $('#closeBtn').kendoButton();
            var closeBtn = $('#closeBtn').data('kendoButton');
            closeBtn.bind('click', function(e) {
                self.close();
            });
        });
        
		function addFolder(){
			var newFolderNm = $('#new_folder_nm').val();
			if(!newFolderNm){
				GochigoAlert("폴더명을 입력하십시오.");
				return;
			}
			$.ajax({
                url:"<c:url value='/system/addXmlFolder.json'/>",
                method: "POST",
                data : {newFolderNm:newFolderNm},
                success: function(data,status) {
                    if(data.success){
                        GochigoAlert('폴더가 생성되었습니다.');
                        opener.reloadGrid();
                    } else {
                        GochigoAlert('폴더 생성에 실패했습니다.');
                        return;
                    }
                }
            });
		}
    </script>
</head>
<body>
<div class="popContainer">
	<div class="header_title">
		<h3>XML폴더 추가</h1>
	</div>
	<div>
		<table class="tbl_type01">
			<tr>
				<th>폴더명</th>
				<td>
					<input class='k-textbox' style="width:95%;" type="text" id="new_folder_nm" name="new_folder_nm"/>
				</td>
			</tr>
		</table>
	</div>
	<div style="text-align:center;">
		<button id="addBtn">생성</button>
		<button id="closeBtn">닫기</button>
	</div>
</div>
</body>
</html>