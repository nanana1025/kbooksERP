<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>시스템설정</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta charset="utf-8"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>

	<style>
		.header_title > h1 {
			color:#fff;
			font-size:15px;
			line-height:35px;
			padding-left:18px;
			background:#415169;
			margin:0px;
		}
	</style>
    <script>
		function onSelectFile(e) {
		    var files = e.files;
            var acceptedFiles = [".jpg", ".jpeg", ".png", ".gif"]
            var isAcceptedImageFormat = ($.inArray(files[0].extension, acceptedFiles)) != -1

            if (!isAcceptedImageFormat) {
                e.preventDefault();
                GochigoAlert("Image must be jpeg, png or gif");
            }
		}
        var fileInfo =  [${fileInfo}];

		function saveData() {
		    var _url = "";
		    if($("#editMode").val()=="C") {
                _url = "/system/saveSystemInfo.json";
			} else {
                _url = "/system/updateSystemInfo.json";
			}
            var frm = $("#frm")[0];
            var fdata = new FormData(frm);

            $("#saveBtn").prop("disabled", true);

            $.ajax({
                type:"POST",
                enctype : "multipart/form-data",
                url : _url,
                data :  fdata,
                processData : false,
                contentType : false,
                cache : false,
                timeout : 600000,
                success : function(data) {
                    if(data.success) {
                        GochigoAlert('저장완료');
                       location.reload();
                    } else {
                        GochigoAlert(data.errMsg);
                        $("#saveBtn").prop("disabled", false);
					}
                },
                error : function(e) {
                    $("#saveBtn").prop("disabled", false);
                }
            });
		}

		$(document).ready(function() {

		    $("#logoImg").kendoUpload({
			    multiple : false,
			    select : onSelectFile
				// ,files : fileInfo

		   });

           $("#dataTable input").css("width", "100%");
		   var validator = $("#frm").kendoValidator().data("kendoValidator");

		   $("#saveBtn").click(function(event){
		       event.preventDefault();

               if(validator.validate()) {
                   saveData();
			   }
		   });

            $("#menuBtn").click(function(event){
				location.href = "/systemSel.do";
            });

            $("#fileDel").click(function() {
                $.ajax({
                    url : '/system/delFile.do',
                    data : {
                        orgFileName : $("#orgFileName").val(),
                        systemId : $("#systemId").val()
                    },
                    success : function(data) {
                        if(data.success) {
                            $("#fileInfo").remove();
                        }
                    }
                });
            });
		});
    </script>
</head>
<body>
<div class="demo-section k-content">
	<div class="header_title">
		<h1>시스템 설정</h1>
	</div>
	<div>
		<form id="frm">
			<input type="hidden" id="systemId" name="systemId" value="${systemInfo.SYSTEM_ID}">
			<input type="hidden" id="editMode" name="editMode" value="${editMode}">
		<div>
			<table width="100%" class="tbl_type01">
				<colgroup>
					<col style="width:30%;"/>
					<col style="width:70%;"/>
				</colgroup>
				<tbody>
<!--                     <tr> -->
<!--                         <th>DB</th> -->
<%--                         <td>${db_url}</td> --%>
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <th>DB_USERNAME</th> -->
<%--                         <td>${db_username}</td> --%>
<!--                     </tr> -->
<!--                     <tr> -->
<!--                         <th>DB_PASSWORD</th> -->
<%--                         <td>${db_password}</td> --%>
<!--                     </tr> -->
<!-- 					<tr> -->
<!-- 						<th> -->
<!-- 							<label for="systemName" class="required">시스템명</label> -->
<!-- 						</th> -->
<!-- 						<td> -->
<%-- 							<input type="text" id="systemName" name="systemName" class="k-textbox" style="width: 100%;" required validationMessage="시스템명을 필수 항목입니다." value="${systemInfo.SYSTEM_NM}"/> --%>
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<th> -->
<!-- 							<label for="adminId">관리자ID</label> -->
<!-- 						</th> -->
<!-- 						<td> -->
<%-- 							<input type="text" id="adminId" name="adminId"  class="k-textbox" style="width: 100%;" required validationMessage="관리자ID는 필수 항목입니다." value="${systemInfo.ADMIN_ID}"> --%>
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<th> -->
<!-- 							<label for="adminPw">관리자PW</label> -->
<!-- 						</th> -->
<!-- 						<td> -->
<%-- 							<input type="text" id="adminPw" name="adminPw"  class="k-textbox" style="width: 100%;" required validationMessage="관리자Password는 필수 항목입니다." value="${systemInfo.ADMIN_PW}"> --%>
<!-- 						</td> -->
<!-- 					</tr> -->
					<tr>
						<th>
							<label for="systemName" class="required">시스템명</label>
						</th>
						<td>
							<input type="text" id="systemName" name="systemName" class="k-textbox" style="width: 100%;" required validationMessage="시스템명을 필수 항목입니다." value="${systemInfo.SYSTEM_NM}"/>
						</td>
					</tr>
					<tr>
						<th>
							<label for="copyright">copyright</label>
						</th>
						<td>
							<textarea id="copyright" name="copyright"  class="k-textbox"  rows="5" style="width: 100%;">${systemInfo.COPYRIGHT}</textarea>
						</td>
					</tr>
					<tr>
						<th>
							<label for="logoImg">로고<br>[높이:40px 기준]</label>
						</th>
						<td>
                            <c:if test="${systemInfo.LOGO_IMG_NM != null}">
                            <div id="fileInfo" style="width: 100%;margin-bottom: 10px;">
                                <a href="/download.do?fileName=${systemInfo.LOGO_IMG_NM}">${systemInfo.LOGO_IMG_NM}</a>
                                <button type="button" id="fileDel" class="k-button" style="float: right;">삭제</button>
                            </div>
                            </c:if>
							<input type="hidden" id="orgFileName" name="orgFileName" value="${systemInfo.LOGO_IMG_NM}">
							<input type="file" id="logoImg" name="logoImg" class="files"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div style="text-align: center;">
			<button type="button" id="saveBtn" class="k-button k-primary">SAVE</button>
			<button type="reset" class="k-button">CANCEL</button>
			<button type="button" id="menuBtn" class="k-button">BACK</button>
		</div>
	</div>
	</form>
</div>
</body>
</html>