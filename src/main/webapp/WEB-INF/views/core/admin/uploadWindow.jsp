<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<title>${title}</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<meta charset="utf-8"/>
	<link rel="stylesheet" type="text/css" href="codebase/css/examples-offline.css"/>
	<link rel="stylesheet" type="text/css" href="codebase/kendo/css/kendo.common.min.css"/>
	<link rel="stylesheet" type="text/css" href="codebase/css/kendo.custom.css"/>

	<script src="js/jquery-3.3.1.js"></script>
	<script src="codebase/kendo/kendo.all.min.js"></script>
	<script src="codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<style>
		html,
		body
		{
			height:100%;
			margin:0;
			padding:0;
			overflow:hidden;
		}
		.window-title > h1{
			color: #fff;
			font-family: 'Nanum Barun Gothic';
			font-size: 15px;
			line-height: 35px;
			padding-left: 18px;
			background: #415169;
			margin: 0px;
		}
		.pop_container > h1{
			float: left;
			padding-left: 20px;
			line-height: 30px;
			font-family: 'Nanum Barun Gothic';
			font-size: 15px;
			color: #222;
			/* 	    background: url(../images/icon_content_list.png) no-repeat 0 9px; */
			/* 	    background-position-y: 5.5px; */
			width: 100%;
			margin-top: 10px;
			margin-bottom: 5px;
		}
		.window-wrapper{
			padding-top:50px;

		}
		.pop_container{
			height:100%;
			padding: 0 20px 18px 20px;
			border-bottom: 1px solid #f0f0f2;
			background: #e9eef3;
			font-family: 'Nanum Barun Gothic';
		}
		.dropZoneElement {
			position: relative;
			display: inline-block;
			border: 1px solid #c7c7c7;
			width: 100%;
			height: 120px;
			text-align: left;
		}
		.fileselect {
			width:21px;
			position:absolute;
			left:0;
		}
		.filename {
			width:100px;
			position:absolute;
			right:275px;
		}
		.status {
			width:78px;
			position:absolute;
			right:120px;
		}
		.filesize {
			width:81px;
			position:absolute;
			right:20px;
		}
		.upld_header {
			background-color: #fbfbfb;
			border-bottom: 1px solid #f3f3f3;
			height:20px;
		}
	</style>
	<script>

        $(document).ready(function() {
            $("#files").kendoUpload({
//         		async: {
//                     saveUrl: "/upload.json",
//                     removeUrl: "remove",
//                     autoUpload: true,
//                 },
            });
        });

	</script>
</head>
<body>
<div class="window-title"><h1>파일 업로드</h1></div>
<div class="pop_container">
	<h1>파일 리스트 ( ${sname}  >  ${fname}  >  ID : ${id} )</h1>
	<div class="window-wrapper">
		<form method="post" action="/upload.json">
			<div class="demo-section k-content">
				<input name="files" id="files" type="file" aria-label="files" />
				<p style="padding-top: 1em; text-align: right">
					<button type="submit" class="k-button k-primary">저장</button>
				</p>
			</div>
			<c:forEach items="${object}" var="obj">
				<input type="hidden" name="${obj.objectId}" value="${obj.objectVal}"/>
			</c:forEach>
			<input type="hidden" name="FILE_COL" value="${fileColName}"/>
			<input type="hidden" name="sid" value="${sid}"/>
		</form>
	</div>
</div>
</body>
</html>