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
    .logo {
    	height: 50px;
    	cursor: pointer;
    }
    .topInfo {
    	font-size: 13px;
    	top: -3px;
    	position:relative;
    }
    </style>
    <script>

    window['MENU_${menu_sid}'] = {

        menuDataSource : "",

        fnInitMenu : function(){

        	var menutype = "${menutype}";

        	$.ajax({
				url : "/menuItemLoad.json",
				type : 'POST',
				data:{menu_sid:"${menu_sid}"},
				dataType: 'json',
				async:false,
				success: function(data) {
					if(data){
						fnObj('MENU_${menu_sid}').menuDataSource = data;
					}else{
						GochigoAlert("menu item load fail");
					}
				}
			})

        	if(menutype == 'top'){

            	$('#menu').kendoMenu({
            		dataSource:fnObj('MENU_${menu_sid}').menuDataSource,
            		select: function(e) {
                   		console.log(e.item);
                    },
                    scrollable: true
            	});

            	$('#menu').find("img").each(function(){
            	     $( this ).parent().parent().addClass( "img" );
            	});

            	fnObj('MENU_${menu_sid}').menuAfterSet();

        	}else if(menutype == 'panelbar'){
        		 $("#menu").kendoPanelBar({
                     dataSource: fnObj('MENU_${menu_sid}').menuDataSource,
                     select: function(e) {
                    	 console.log(e);
                     }
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
        },

        menuAfterSet : function() {
        	var html = '';
        	if('${navMain}') {
        		html += "<div class='subHomeDiv'>";
            	html += '<img class="subHome" src="codebase/imgs/icon_topnavi_home.png" onclick="MENU_${menu_sid}.fnGoMain();"/>';
         		html += '<img class="subRightarrow" src="codebase/imgs/icon_topnavi_rightarrow.png"/>';
         		html += '${navMain}';
         		if('${navSub}') {
         			html += '<img class="subRightarrow" src="codebase/imgs/icon_topnavi_rightarrow.png"/>';
             		html += '${navSub}';
         		}
         		html += '</div>';
        	}

     		$('#menu > .k-last').after(html);
     		if($('.subHomeDiv').length > 1){
       			$('.subHomeDiv')[0].remove();
       		}
        },

        goLogout: function() {
        	location.href = "/logout.do";
        },
        goHelp: function() {
        	GochigoAlert("준비중입니다.");
        },
        goEditUser: function() {
            var viewParam = "";
            viewParam += "&objectid=user_id";
            viewParam += "&user_id=${sessionScope.userInfo.user_id}";
            console.log(viewParam);

            var xPos  = (document.body.clientWidth /2) - (800 / 2);
            xPos += window.screenLeft;
            var yPos  = (screen.availHeight / 2) - (600 / 2);
            window.open("<c:url value='/dataView.do'/>"+"?sid=USER_EDIT"+ encodeURI(viewParam), "dataView", "top="+yPos+", left="+xPos+", width=800, height=600");
        }
    };

    function fnGoHome() {
    	if('${sessionScope.userInfo.auth_id}' == '1'){
	    	location.href = "/layout.do?sid=CUSTOMER_MATERIAL_CHECK";
    	} else {
	    	location.href = "/dashboard.do";
    	}
    }

    $(document).ready(function() {
    	fnObj('MENU_${menu_sid}').fnInitMenu();
    });
    </script>
<c:if test="${param.mode!='layout'}">
<body class="k-content">
</c:if>

<c:if test="${menutype == 'top'}">
<div style="padding-left: 10px; line-height: 40px; vertical-align: middle;" class="k-content">
    <ul>
        <li>
            <h2 id="mainTitle" style="height:40px;">
                <c:if test="${sysInfo.LOGO_IMG_NM != null}">
                    <img src="/sys_img/${sysInfo.LOGO_IMG_NM}" class="logo" onclick="fnGoHome()" >
                </c:if>
                <c:if test="${sysInfo.LOGO_IMG_NM == null}">
                    <strong>${sysInfo.SYSTEM_NM}</strong>
                </c:if>
                <div style="float:right; font-size:medium; cursor: pointer; margin-right: 13px;height:40px;">
                    <img src="/codebase/imgs/icon_logout.png" style="position:relative;top:4px;width:25px">
                    <span class="topInfo" onclick="MENU_${menu_sid}.goLogout()">Logout</span>
                </div>
                <div style="float:right; font-size:medium; cursor: pointer; margin-right: 20px;height:40px;">
                    <img src="/codebase/imgs/icon_help.png" style="position:relative;top:4px;width:25px">
                    <span class="topInfo" onclick="MENU_${menu_sid}.goHelp()">도움말</span>
                </div>
                <div style="float:right; font-size:medium; cursor: pointer; margin-right: 20px;height:40px;">
                    <img src="/codebase/imgs/icon_member.png" style="position:relative;top:4px;width:25px">
                    <span class="topInfo" onclick="MENU_${menu_sid}.goEditUser()">${sessionScope.userInfo.user_nm} 님</span>
                </div>
                <!-- <div style="float:right; font-size:medium; cursor: pointer; margin-right: 20px;height:40px;">
                	<a href="/layout.do?xn=WBS_LAYOUT&lang=en">English</a>
                </div>
                <div style="float:right; font-size:medium; cursor: pointer; margin-right: 20px;height:40px;">
                	<a href="/layout.do?xn=WBS_LAYOUT&lang=ko">한글</a>
                </div> -->
            </h2>
        </li>
        <%--<li>--%>
            <%--<h3 style="margin-top: 10px;float: right;">--%>
            <%--<span>${sessionScope.userInfo.user_nm} 님</span>--%>
            <%--</h3>--%>
        <%--</li>--%>
    </ul>
</div>
<div id="menu" style="border: none !important;"></div>
<!-- <div id="nav" class="subBackground"> -->
<!--     <div class="subNavBarOut"> -->
<%--         <img class="subHome" src="codebase/imgs/icon_topnavi_home.png" onclick="MENU_${menu_sid}.fnGoMain();"/> --%>
<!--     </div> -->
<!--     <div class="subNavBarOut"> -->
<!--         <img class="subRightarrow" src="codebase/imgs/icon_topnavi_rightarrow.png"/> -->
<!--     </div> -->
<%--     <div class="subNavBarOut">${navMain}</div> --%>
<%--     <c:if test="${navSub != null}"> --%>
<!--     <div class="subNavBarOut"> -->
<!--         <img class="subRightarrow" src="codebase/imgs/icon_topnavi_rightarrow.png"/> -->
<!--     </div> -->
<%--     <div class="subNavBarOut">${navSub}</div> --%>
<%--     </c:if> --%>
<!-- </div> -->

</c:if>
<c:if test="${menutype == 'panelbar'}">
<div style="padding-left: 10px; padding-top: 5px;" class="k-content">
    <ul>
        <li>
            <h1 class="mainTitle">
                <c:if test="${sysInfo.LOGO_IMG_NM != null}">
                    <img src="/sys_img/${sysInfo.LOGO_IMG_NM}" height="100px">
                </c:if>
                <c:if test="${sysInfo.LOGO_IMG_NM == null}">
                    <strong>${sysInfo.SYSTEM_NM}</strong>
                </c:if>
            </h1>
        </li>
        <%--<li >--%>
            <%--<h3 style="margin-top: 10px;">--%>
                <%--<span>${sessionScope.userInfo.user_nm} 님</span>--%>
            <%--</h3>--%>
        <%--</li>--%>
<!--         <li > -->
<!--             <button id="logoutBtn" style="float: right; margin-right: 5px;" title="로그아웃"> -->
<!--                 <span class="k-icon k-i-logout"></span> -->
<!--             </button> -->
<!--         </li> -->
    </ul>

</div>
    <div id="menu" style="font-size: 11px;margin-top: 29px;">

    </div>
</c:if>

<c:if test="${param.mode!='layout'}">
</body>
</html>
</c:if>