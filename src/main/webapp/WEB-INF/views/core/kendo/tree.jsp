<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${param.mode!='layout'}">
<!DOCTYPE html>
<html>
<head>
    <title>tree</title>
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
<div id="example">
	<div id="treeview"></div>
	<script>
        var serviceRoot = "https://demos.telerik.com/kendo-ui/service";
        homogeneous = new kendo.data.HierarchicalDataSource({
            transport: {
                read: {
                    url: serviceRoot + "/Employees",
                    dataType: "jsonp"
                }
            },
            schema: {
                model: {
                    id: "EmployeeId",
                    hasChildren: "HasEmployees"
                }
            }
        });

        $("#treeview").kendoTreeView({
            dataSource: homogeneous,
            dataTextField: "FullName"
        });
	</script>
</div>
<c:if test="${param.mode!='layout'}">
</body>
</html>
</c:if>