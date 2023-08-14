<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:url var="urlCheckListNTB" value="/checkListNTB.do"/>

<script src="/codebase/gochigo.kendo.ui.js"></script>

<!DOCTYPE html>
<html>
<title>${title}</title>

    <style>
    .logo {
        margin-top: 5px;
    	height: 32px;
    	cursor: pointer;
    }
    .topInfo {
    	font-size: 13px;
    	top: -3px;
    	position:relative;
    }
    </style>
    <script>
    var _language = '${sessionScope.language}';
    window['MENU_${menu_sid}'] = {

        menuDataSource : "",
        selectedMenu : "",

        fnInitMenu : function(){

        	var menutype = "${menutype}";

        	$.ajax({
				url : "/menuItemLoad.json",
				type : 'POST',
				data:{
					menu_sid : "${menu_sid}",
					xn: "${xn}"
				},
				dataType: 'JSON',
				async:true,
				success: function(data) {
					if(!data.SUCCESS){

				     	var debugUrlHost = "localhost:3691";
				     	var urlHost = window.location.host;

// 				     	if((urlHost != debugUrlHost)){
// 				     		GochigoAlertMove("세션이 종료되었습니다. 로그인 페이지로 이동합니다.", "/logout.do");
// 				     	}
					}

					if(data){
						fnObj('MENU_${menu_sid}').menuDataSource = JSON.parse(data.menuJson);

			           	$('#menu').kendoMenu({
			           		dataSource: fnObj('MENU_${menu_sid}').menuDataSource,
//                             scrollable: true,
			           		select : function(e){
			           			var item = $(e.item),
			           				menuElement = item.closest(".k-menu");
								var parents = item.parentsUntil(menuElement, '.k-item');
								var index = item.index();
								var mainNavId = index;
								var subNavId;

								if(parents.length == 1){
									subNavId = mainNavId;
									index = parents.index();
									mainNavId = index;
									console.log("index = "+index);
								}
								else if(parents.length > 1){

									var parentss = parents.closest(".k-menu");
									var parentsss = parents.parentsUntil(parentss, '.k-item');

									index = parents.index();

									var mainNavIds = index;
									subNavId = mainNavIds;
									index = parentsss.index();
									mainNavId = index;

// 								alert(mainNavId);
// 								alert(mainNavIds);
								}

								var source = fnObj('MENU_${menu_sid}').menuDataSource;
								var navMain = source[mainNavId].text;
								var navSub;
								if(subNavId > -1){
									navSub = source[mainNavId].items[subNavId].text;
								}


			           			fnObj('MENU_${menu_sid}').selectedMenu = index;
			           			$.ajax({
			        				url : "/setMenuIndex.json",
			        				type : 'POST',
			        				data:{
			        					selectedMenu : fnObj('MENU_${menu_sid}').selectedMenu,
			        					navMain : navMain,
			        					navSub : navSub
			        				},
			        				dataType: 'JSON',
			        				async:true,
			        				success: function(data) {
			        				}
			        			});
			           		}
			           	});

			           	$('#menu').find("img").each(function(){
			           	     $( this ).parent().parent().addClass( "img" );
			           	});

			           	fnObj('MENU_${menu_sid}').menuAfterSet(data);

					}else{
						GochigoAlert("menu item load fail");
					}

				}
			})

        },

        fnGoMain : function(){
        	location.href = "/";
        },

        menuAfterSet : function(data) {
        	var html = '';
        	if(data.navMain) {
        		html += "<div class='subHomeDiv'>";
            	html += '<img class="subHome" src="/codebase/imgs/icon_topnavi_home.png" onclick="MENU_${menu_sid}.fnGoMain();"/>';
         		html += '<img class="subRightarrow" src="/codebase/imgs/icon_topnavi_rightarrow.png"/>';
         		html += data.navMain;
         		if(data.navSub) {
         			html += '<img class="subRightarrow" src="/codebase/imgs/icon_topnavi_rightarrow.png"/>';
             		html += data.navSub;
         		}
         		html += '</div>';
        	}

     		$('#menu > .k-last').after(html);
     		if($('.subHomeDiv').length > 1){
       			$('.subHomeDiv')[0].remove();
       		}

     		if(data.selectedIndex >= 0){
	     		var idx = data.selectedIndex;
	        	var p = $('#menu>li')[idx];
	        	$(p).addClass('k-menu-selected');
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
            viewParam += "&objectid=USER_ID";
            viewParam += "&USER_ID=${sessionScope.userInfo.user_id}";

            var xPos  = (document.body.clientWidth /2) - (800 / 2);
            xPos += window.screenLeft;
            var yPos  = (screen.availHeight / 2) - (600 / 2);
            window.open("<c:url value='/dataView.do'/>"+"?xn=myPage_DATA&sid=mypage_data"+ encodeURI(viewParam), "dataView", "top="+yPos+", left="+xPos+", width=800, height=600");
        },
        goDownload: function() {
            location.href="/downloadInventoryCheckFile/WareHousingMaster.zip?fileType=kor";
        }
    };

    function fnGoCheckListNTB() {
        event.preventDefault();
        window.open("${urlCheckListNTB}", "window", "width=1000px, height=800px");
    }

    function fnGoHome() {
    	$.ajax({
			url : "/removeMenuIndex.json",
			type : 'POST',
			dataType: 'JSON',
			async:true,
			success: function(data) {
// 		    	location.href = "${sessionScope.home}";
				location.href = "/admin/layout.do?xn=MAIN_LAYOUT";
			}
		});
    }

    $(document).ready(function() {
    	fnObj('MENU_${menu_sid}').fnInitMenu();

//     	var debugUrlHost = "localhost:3691";
//     	var urlHost = window.location.host;
//     	var userId = "${sessionScope.userInfo.user_id}";

//     	if((urlHost != debugUrlHost) && userId == ""){
//     		GochigoAlertMove("세션이 종료되었습니다. 로그인 페이지로 이동합니다.", "/logout.do");
//     	}

    });
    </script>

<div style="padding-left: 10px; line-height: 40px; vertical-align: middle;" class="k-content">
    <ul>
        <li>
            <h2 id="mainTitle" style="height:40px;">
                <c:if test="${sysInfo.LOGO_IMG_NM != null}">
                    <img src="/sys_img/logo.png" class="logo" onclick="fnGoHome();">
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
                 <div style="float:right; font-size:medium; cursor: pointer; margin-right: 20px;height:40px;">
                    <img src="/codebase/imgs/download.png" style="position:relative;top:4px;width:25px">
                    <span class="topInfo" onclick="MENU_${menu_sid}.goDownload()">검수프로그램 다운로드</span>
                </div>
<!--                 <div style="float:right; font-size:medium; cursor: pointer; margin-right: 40px;height:40px;"> -->
<!--                     <img src="/codebase/imgs/icon_member.png" style="position:relative;top:4px;width:25px"> -->
<!--                     <span class="topInfo" onclick="fnGoCheckListNTB()">NTB 체크</span> -->
<!--                 </div> -->
                <!-- <div style="float:right; font-size:medium; cursor: pointer; margin-right: 20px;height:40px;">
                	<a href="/layout.do?xn=WBS_LAYOUT&language=en">English</a>
                </div>
                <div style="float:right; font-size:medium; cursor: pointer; margin-right: 20px;height:40px;">
                	<a href="/layout.do?xn=WBS_LAYOUT&language=ko">한글</a>
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