<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<title>${title}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta charset="utf-8"/>

    <link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

    <script src="/js/jquery-1.12.4.js"></script>
    <script src="/codebase/kendo/kendo.all.min.js"></script>
    <script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
    <style>
    .k-dropdown-wrap {
        padding-bottom: 1px;
    }
    .period-wrapper {
        display: inline-block;
        vertical-align: center;
    }
    #menu > li ul {
/*          width:max-content;  */
        font-size: 100%;
    }
    #menu > li {
/*          width:160px; */
        font-size: 130%;
    }
	#menu > .img{
		float:right;
		width:50px !important;
		padding-left:0 !important;
		padding-right:0 !important;
		border-left:0 !important;
		border-right:0 !important;
	}
	.subNavBarOut{
		display:inline-block;
/* 		color:rgb(255,255,255); */
		line-height:35px;
	}
	.subBackground {/* position:absolute; */ /* background-color:#35455E; */ border:1px solid #28364C; height: 35px; margin-top: 2px;}
 	.subNavBarOut {float: left;}
	.subHome {margin: 0px; padding-top: 12px;padding-left: 20px;cursor: pointer;height: 15px;}
	.subRightarrow {margin: 0px;padding-left: 20px;padding-right: 20px;padding-top: 13px;height: 10px;}
    .ml {
        margin-left: 15px;
    }

    </style>
    <script>
    
    $(document).ready(function() {
    	fnInitMenu();

    	$("#menu a").click(function(e) {
    	    e.preventDefault();
        });

    	$("#backBtn").click(function(e) {
    	   location.href = "/system/menuXmlSet.do";
        });
    });
    
    var menuDataSource = "";

    function fnInitMenu(){

        var menutype = "${menutype}";

        $.ajax({
            url : "/menuItemLoad.json",
            type : 'POST',
            data:{sid:"${param.sid}"},
            dataType: 'json',
            async:false,
            success: function(data) {
                if(data){
                    menuDataSource = data;
                }else{
                    GochigoAlert("menu item load fail");
                }
            }
        })

        if(menutype == 'top'){

            $('#menu').kendoMenu({
                dataSource:menuDataSource,
                scrollable: true
            })

            $('#menu').find("img").each(function(){
                 $( this ).parent().parent().addClass( "img" );
            });

        }else if(menutype == 'panelbar'){
             $("#menu").kendoPanelBar({
                 dataSource: menuDataSource
//                      select: onSelect
//                      expand: onExpand,
//                      collapse: onCollapse,
//                      activate: onActivate,
//                      contentLoad: onContentLoad,
//                      error: onError,
//                      contentUrls: [ , , , "../content/web/panelbar/ajax/ajaxContent1.html", "error.html" ]
             });
            $("#menu").data("kendoPanelBar").expand($("#menu .k-link"), true);

            // $('#logoutBtn').kendoButton();
            // var logoutBtn = $('#logoutBtn').data('kendoButton');
            // logoutBtn.bind('click', function(e) {
            //     location.href = "/logout.do";
            // });
        }
    }

    function fnGoMain(){
        location.href = "/";
    }
    </script>
<body class="k-content">
<div class="header_title">
    <h1>메뉴 미리보기</h1>
</div>
<c:if test="${menutype == 'top'}">
    <div style="padding-left: 10px; padding-top: 5px;" class="k-content">
        <ul>
            <li>
                <h1 id="exampleTitle">
                    <c:if test="${sysInfo.IMG_NAME != null}">
                        <img src="/sys_img/${sysInfo.IMG_NAME}">
                    </c:if>
                    <c:if test="${sysInfo.IMG_NAME == null}">
                        <strong>${sysInfo.SYSTEM_NAME}</strong>
                    </c:if>
                </h1>
            <%--<li >--%>
                <%--<button id="logoutBtn" style="float: right; margin-right: 5px;" title="로그아웃">--%>
                    <%--<span class="k-icon k-i-logout"></span>--%>
                <%--</button>--%>
            <%--</li>--%>
        </ul>
    </div>
    <div id="menu" ></div>
</c:if>
<div style="float:left; width:40%">
    <table class="tbl_type01">
        <thead>
        <tr>
            <th>MENU XML</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>
                <textarea id="xmlStr" rows="35" style="width: 99%;">${xmlStr}</textarea>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<div style="float: left; width: 40%">
    ${menuTbl}
</div>
<c:if test="${menutype == 'panelbar'}">
<div style="float: left;width:20%;">
<div style="padding-left: 10px; padding-top: 5px;" class="k-content">
    <ul>
        <li>
            <h1 id="exampleTitle">
                <c:if test="${sysInfo.IMG_NAME != null}">
                    <img src="/sys_img/${sysInfo.IMG_NAME}">
                </c:if>
                <c:if test="${sysInfo.IMG_NAME == null}">
                    <strong>${sysInfo.SYSTEM_NAME}</strong>
                </c:if>
            </h1>
        </li>
        <%--<li >--%>
            <%--<h3 style="margin-top: 10px;">--%>
                <%--<span>${sessionScope.userInfo.user_nm} 님</span>--%>
            <%--</h3>--%>
        <%--</li>--%>
        <li >
            <%--<button id="logoutBtn" style="float: right; margin-right: 5px;" title="로그아웃">--%>
                <%--<span class="k-icon k-i-logout"></span>--%>
            <%--</button>--%>
        </li>
    </ul>
</div>
<div id="menu" style="font-size: 11px;margin-top: 29px;"></div>
</div>
</c:if>
<div style="clear: both; text-align: center; padding:20px 20px 20px 20px;">
    <button class="k-button" id="backBtn">BACK</button>
</div>
</body>
</html>