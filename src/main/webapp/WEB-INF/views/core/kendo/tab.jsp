<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>tab</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<meta charset="utf-8"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

	<script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
</head>
<body>
<div id="example">
	<div id="tabstrip">
		<ul>
			<li class="k-state-active">Dimensions &amp; Weights</li>
			<li>Engine</li>
			<li>Chassis</li>
		</ul>
	</div>
</div>
<script>
    $(document).ready(function () {
        var ts = $("#tabstrip").kendoTabStrip({
            animation: { open: { effects: "fadeIn"} },
            contentUrls: [
                '/kendo/tree.do',
                '/kendo/grid.do',
                '/kendo/view.do'
            ]
        }).data('kendoTabStrip');
    });
</script>

<style>
	#tabstrip {
		min-width: 400px;
		margin-bottom: 20px;
	}
	#tabstrip .k-content
	{
		height: 100%;
		overflow: auto;
	}
	.specification {
		min-width: 670px;
		margin: 10px 0;
		padding: 0;
	}
	.specification dt, dd {
		min-width: 140px;
		float: left;
		margin: 0;
		padding: 5px 0 8px 0;
	}
	.specification dt {
		clear: left;
		width: 100px;
		margin-right: 7px;
		padding-right: 0;
		opacity: 0.7;
	}
	.specification:after, .wrapper:after {
		content: ".";
		display: block;
		clear: both;
		height: 0;
		visibility: hidden;
	}
</style>
</body>
</html>