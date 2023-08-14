<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<title>${title}</title>
    <style>
    .logo {
    	height: 20px;
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
				data:{menu_sid:"${menu_sid}", xn: "${xn}"},
				dataType: 'json',
				async:false,
				success: function(data) {
					if(data){
						fnObj('MENU_${menu_sid}').menuDataSource = JSON.parse(data.menuJson);

						 $("#menu").kendoPanelBar({
			                 dataSource: fnObj('MENU_${menu_sid}').menuDataSource,
			                 select : function(e){
			           			var item = $(e.item),
			           				menuElement = item.closest(".k-menu");
								var parents = item.parentsUntil(menuElement, '.k-item');
								var index = item.index();
								if(parents.length > 0){
									index = parents.index();
								}
			           			fnObj('MENU_${menu_sid}').selectedMenu = index;
			           			$.ajax({
			        				url : "/setMenuIndex.json",
			        				type : 'POST',
			        				data:{selectedMenu : fnObj('MENU_${menu_sid}').selectedMenu},
			        				dataType: 'JSON',
			        				async:true,
			        				success: function(data) {
			        				}
			        			})
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
        	if('${navMain}') {
        		html += "<div class='subHomeDiv'>";
            	html += '<img class="subHome" src="codebase/imgs/icon_topnavi_home.png" onclick="MENU_${menu_sid}.fnGoMain();"/>';
         		html += '<img class="subRightarrow" src="codebase/imgs/icon_topnavi_rightarrow.png"/>';
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

     		//menu select event
     		if(data.selectedIndex >= 0){
	     		var idx = data.selectedIndex;
	        	var p = $('#menu>li')[idx];
	        	$(p).addClass('k-menu-selected');
     		}

        	//panelbar open
        	var panelBar = $("#menu").data("kendoPanelBar");
         	panelBar.expand($("li.k-menu-selected"));
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

            var xPos  = (document.body.clientWidth /2) - (800 / 2);
            xPos += window.screenLeft;
            var yPos  = (screen.availHeight / 2) - (600 / 2);
            window.open("<c:url value='/dataView.do'/>"+"?sid=USER_EDIT"+ encodeURI(viewParam), "dataView", "top="+yPos+", left="+xPos+", width=800, height=600");
        }
    };

    function fnGoHome() {
    	$.ajax({
			url : "/removeMenuIndex.json",
			type : 'POST',
			dataType: 'JSON',
			async:true,
			success: function(data) {
		    	location.href = "${sessionScope.home}";
			}
		});
    }


    $(document).ready(function() {
    	fnObj('MENU_${menu_sid}').fnInitMenu();
    });
    </script>

<div style="padding-left: 10px; padding-top: 5px;" class="k-content">
    <ul>
        <li>
            <h1 class="mainTitle">
<%--                     <img src="/sys_img/${sysInfo.LOGO_IMG_NM}" height="35px"> --%>
                <c:if test="${sysInfo.LOGO_IMG_NM != null}">
                    <img src="/sys_img/logo.png" height="35px" onclick="fnGoHome();">
                </c:if>
                <c:if test="${sysInfo.LOGO_IMG_NM == null}">
                    <strong>${sysInfo.SYSTEM_NM}</strong>
                </c:if>
            </h1>
        </li>
        <li >
            <div style="float:right; font-size:medium; cursor: pointer; margin-right: 13px;height:40px;">
                 <img src="/codebase/imgs/icon_logout.png"><span class="topInfo" onclick="MENU_${menu_sid}.goLogout()">Logout</span>
            </div>
        </li>
    </ul>

</div>
<div id="menu" style="font-size: 11px;margin-top: 29px;">
</div>