<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<meta charset="utf-8"/>
    <link rel="stylesheet" type="text/css" href="/codebase/fonts/NotoSansKR/stylesheets/NotoSansKR-Hestia.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

    <script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="/codebase/kendo/jszip.min.js"></script>
    <script src="/codebase/common.js"></script>
    <script src="/codebase/default.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <style>
		#scrnArea {
			height: 100% !important;
		}
		#content {
			height: calc(100% - 22px);
		}
</style>

</script>
<meta charset="UTF-8">
<title><sitemesh:write property='title' /></title>
<sitemesh:write property='head'/>
</head>
<body>
<div id="content">
	<div id="menuArea"></div>
	<sitemesh:write property='body'/>
</div>

</body>
</html>