<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${param.mode!='layout'}">
<!DOCTYPE html>
<html>
<head>
    <title>menu</title>
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
<div id="k-content">
	<ul id="menu">
		<li>
			Products
			<ul>
				<li>
					Furniture
					<ul>
						<li>Tables & Chairs</li>
						<li>Sofas</li>
						<li>Occasional Furniture</li>
						<li>Children's Furniture</li>
						<li>Beds</li>
					</ul>


				</li>
				<li>
					Decor
					<ul>
						<li>Bed Linen</li>
						<li>Throws</li>
						<li>Curtains & Blinds</li>
						<li>Rugs</li>
						<li>Carpets</li>
					</ul>
				</li>
				<li>
					Storage
					<ul>
						<li>Wall Shelving</li>
						<li>Kids Storage</li>
						<li>Baskets</li>
						<li>Multimedia Storage</li>
						<li>Floor Shelving</li>
						<li>Toilet Roll Holders</li>
						<li>Storage Jars</li>
						<li>Drawers</li>
						<li>Boxes</li>
					</ul>

				</li>
				<li>
					Lights
					<ul>
						<li>Ceiling</li>
						<li>Table</li>
						<li>Floor</li>
						<li>Shades</li>
						<li>Wall Lights</li>
						<li>Spotlights</li>
						<li>Push Light</li>
						<li>String Lights</li>
					</ul>
				</li>
			</ul>
		</li>
		<li>
			Stores
			<ul>
				<li>
					<div id="template" style="padding: 10px;">
						<h2>Around the Globe</h2>
						<ol>
							<li>United States</li>
							<li>Europe</li>
							<li>Canada</li>
							<li>Australia</li>
						</ol>
						<img src="../content/web/menu/map.png" alt="Stores Around the Globe" />
						<button class="k-button">See full list</button>
					</div>
				</li>
			</ul>
		</li>
		<li>
			Blog
		</li>
		<li>
			Company
		</li>
		<li>
			Events
		</li>
		<li disabled="disabled">
			News
		</li>
	</ul>
</div>
<script>
	var menuMode = '${param.menuMode}';
	$(document).ready(function() {

		if(menuMode == 'vertical') {
			//mode = top 일 경우 menu
			$("#menu").kendoMenu({});
		} else {
			//mode = left 일 경우 panelbar
			$("#menu").kendoPanelBar({
                expandMode : "single"
			});
		}

	});
</script>
<c:if test="${param.mode!='layout'}">
</body>
</html>
</c:if>