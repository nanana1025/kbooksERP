<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta charset="utf-8"/>
	<%--<meta id="_csrf" name="_csrf" content="${_csrf.token}"/>--%>
	<%--<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}"/>--%>
	<link rel="stylesheet" type="text/css" href="codebase/css/examples-offline.css"/>
	<link rel="stylesheet" type="text/css" href="codebase/kendo/css/kendo.common.min.css"/>
	<link rel="stylesheet" type="text/css" href="codebase/css/kendo.custom.css"/>

	<script src="js/jquery-3.3.1.js"></script>
	<script src="codebase/kendo/kendo.all.min.js"></script>
	<script src="codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="codebase/common.js"></script>
    <style>
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
        // var token = $("meta[name='_csrf']").attr("content");
        // var header = $("meta[name='_csrf_header']").attr("content");
        //
        // $(function() {
        //     $(document).ajaxSend(function(e, xhr, options) {
        //         xhr.setRequestHeader(header, token);
        //     });
        // });


        $(document).ready(function() {
            $("#file").kendoUpload({
                multiple:false
            });
        });
	</script>
</head>
<body class="k-content">
<div id="example">
	<div class="box">
		<h4>Information</h4>
		<p>
			The Upload can be used as a drop-in replacement
			for file input elements. This "synchronous" mode does not require
			special handling on the server.
		</p>
	</div>
	<form method="post" action="/uploadFile">
		<div class="demo-section k-content">
			<input name="file" id="file" type="file" aria-label="file" />
			<p style="padding-top: 1em; text-align: right">
				<button type="submit" class="k-button k-primary">Submit</button>
			</p>
		</div>
	</form>
</div>
</body>
</html>