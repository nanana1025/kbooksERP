<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${param.mode!='layout'}">
<!DOCTYPE html>
<html>
<title>${title}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta charset="utf-8"/>

    <link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

    <script src="/js/jquery-1.12.4.js"></script>
    <script src="/codebase/kendo/kendo.all.min.js"></script>
    <script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
    <script src="/codebase/common.js"></script>
</c:if>
    <style>
    .k-dropdown-wrap {
        padding-bottom: 1px;
    }
    .period-wrapper {
        display: inline-block;
        vertical-align: center;
    }
    .ml {
        margin-left: 15px;
    }
    </style>
    <script>

    var MENU_${sid} = {

        menuDataSource : ${menuJson},

        fnInitMenu : function(){

        	var menutype = "${menutype}";

        	if(menutype == 'top'){

            	$('#menu').kendoMenu({
            		dataSource:MENU_${sid}.menuDataSource,
                    scrollable: true
            	})

            	$('#menu').find("img").each(function(){
            	     $( this ).parent().parent().addClass( "img" );
            	});

        	} else if(menutype == 'panelbar'){
        		 $("#menu").kendoPanelBar({
                     dataSource: MENU_${sid}.menuDataSource
//                      select: onSelect,
//                      expand: onExpand,
//                      collapse: onCollapse,
//                      activate: onActivate,
//                      contentLoad: onContentLoad,
//                      error: onError,
//                      contentUrls: [ , , , "../content/web/panelbar/ajax/ajaxContent1.html", "error.html" ]
                 });

        	}

        },

        fnGoMain : function(){
        	location.href = "/";
        }
    };

    $(document).ready(function() {
        MENU_${sid}.fnInitMenu();
    });

    function fnLogout() {
    	location.href = "/admin/logout.do";
    }
    </script>
<c:if test="${param.mode!='layout'}">
<body class="k-content">
</c:if>

<c:if test="${menutype == 'top'}">
<div style="padding-left: 10px; padding-top: 5px; height:40px;" class="k-content">
    <ul>
        <li>
            <h2 id="mainTitle">
                <c:if test="${sysInfo.LOGO_IMG_NM != null}">
                    <img src="/sys_img/${sysInfo.LOGO_IMG_NM}" height="50px"> 관리자
                </c:if>
                <c:if test="${sysInfo.LOGO_IMG_NM == null}">
                    ${sysInfo.SYSTEM_NM} 관리자
                </c:if>
                <div style="float:right; font-size:medium; cursor: pointer; margin-top:5px; margin-right: 20px;" onclick="javascript:fnLogout();">
	            	<img src="/codebase/imgs/icon_logout.png" ><span style="font-size: 13px;">Logout</span>
	            </div>
            </h2>
		</li>
    </ul>
</div>
<div id="menu" ></div>
<%--<div id="nav" class="subBackground">--%>
    <%--<div class="subNavBarOut">--%>
        <%--<img class="subHome" src="codebase/imgs/icon_topnavi_home.png" onclick="MENU_${sid}.fnGoMain();"/>--%>
    <%--</div>--%>
    <%--<div class="subNavBarOut">--%>
        <%--<img class="subRightarrow" src="codebase/imgs/icon_topnavi_rightarrow.png"/>--%>
    <%--</div>--%>
    <%--<div class="subNavBarOut">${navMain}</div>--%>
    <%--<div class="subNavBarOut">--%>
        <%--<img class="subRightarrow" src="codebase/imgs/icon_topnavi_rightarrow.png"/>--%>
    <%--</div>--%>
    <%--<div class="subNavBarOut">${navSub}</div>--%>
<%--</div>--%>
</c:if>
<c:if test="${menutype == 'panelbar'}">
<div style="padding-left: 10px; padding-top: 5px;" class="k-content">
    <ul>
        <li>
            <h3 id="exampleTitle">
                <c:if test="${sysInfo.LOGO_IMG_NM != null}">
                    <img src="/sys_img/${sysInfo.LOGO_IMG_NM}" height="50px">
                </c:if>
                <c:if test="${sysInfo.LOGO_IMG_NM == null}">
                    <strong>${sysInfo.SYSTEM_NM}</strong>
                </c:if>
            </h3>
        </li>
        <%--<li >--%>
            <%--<h3 style="margin-top: 10px;">--%>
                <%--<span>${sessionScope.userInfo.user_nm} 님</span>--%>
            <%--</h3>--%>
        <%--</li>--%>
        <li >
            <button id="logoutBtn" style="float: right; margin-right: 5px;" title="로그아웃">
                <span class="k-icon k-i-logout"></span>
            </button>
        </li>
    </ul>

</div>
    <div id="menu" style="font-size: 11px;margin-top: 29px;"></div>
</c:if>

<c:if test="${param.mode!='layout'}">
</body>
</html>
</c:if>