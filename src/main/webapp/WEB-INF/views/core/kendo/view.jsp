<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${param.mode!='layout'}">
<!DOCTYPE html>
<html>
<head>
    <title>view</title>
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
</c:if>
	<div class="k-content">
		<ul class="fieldlist">
			<li>
				<label for="simple-input">Input</label>
				<input id="simple-input" type="text" class="k-textbox" style="width: 100%;" />
			</li>
			<li>
				<label for="simple-textarea">Textarea</label>
				<textarea id="simple-textarea" class="k-textbox" style="width: 100%;" ></textarea>
			</li>
			<li>
				<label for="icon-left">Input with icon on the left</label>
				<span class="k-textbox k-space-left" style="width: 100%;" >
                    <input type="text" id="icon-left" />
                    <a href="#" class="k-icon k-i-search">&nbsp;</a>
                </span>
			</li>
			<li>
				<label for="icon-right">Input with icon on the right</label>
				<span class="k-textbox k-space-right" style="width: 100%;" >
                    <input type="text" id="icon-right"/>
                    <a href="#" class="k-icon k-i-search">&nbsp;</a>
                </span>
			</li>
			<li>
				<h4>Buttons</h4>
				<button class="k-button">Default</button>&nbsp;
				<button class="k-button k-primary">Primary</button>
			</li>
			<li>
				<h4>Link as Button</h4>
				<a href="http://www.google.com" class="k-button">google.com</a>
			</li>
		</ul>
		<style>
			.fieldlist {
				margin: 0 0 -2em;
				padding: 0;
			}

			.fieldlist li {
				list-style: none;
				padding-bottom: 2em;
			}

			.fieldlist label {
				display: block;
				padding-bottom: 1em;
				font-weight: bold;
				text-transform: uppercase;
				font-size: 12px;
				color: #444;
			}

		</style>
	</div>
<c:if test="${param.mode!='layout'}">
</body>
</html>
</c:if>