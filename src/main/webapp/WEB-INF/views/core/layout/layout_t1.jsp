<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>${sysInfo.SYSTEM_NM} | ${title}</title>
<style>
html, body {
	height: 100%;
	margin: 0;
	padding: 0;
	overflow: hidden;
}

#menuArea {
	height: 100%;
}

#scrnArea {
	height: 100%;
}
</style>
<script>
		var _systemName = '${sysInfo.SYSTEM_NM}';
		var language = '${language}';
        var menu_sid = '${menu_sid}';
        var layoutList  = '${layoutList}';
        var layoutJson  = $.parseJSON(layoutList);
        var area1_obj = layoutJson[0];
        var area2_obj = layoutJson[1];
        var area1_url = area1_obj.curl + '?' + $.param(area1_obj);
        if(language !== '') {
        	area1_url += '&language=' + language;
        }

        var LAYOUT_${sid} = {

            init : function() {
                $("#content").kendoSplitter({
                    orientation: menuMode,
                    panes : [
                        {
//                             contentUrl  : "/menu.do?menu_sid=" + menu_sid + "&sid=" + "${sid}" + "&menuMode="+menuMode+"&mode=layout",
                            collapsible	: false ,
                            resizable	: false ,
                            size: (menuMode=='vertical')? 85 : 260
                        },
                        {
                            contentUrl  : area1_url ,
                            collapsible	: ( area1_obj.collapsible == 'Y' ) ? true : false ,
                            resizable	: ( area1_obj.resizable == 'Y' ) ? true : false ,
                            size		: ( area1_obj.width != undefined ) ? area1_obj.width : ""
                        }
                    ],
                    error : function(e){
                    	if(e.status == "error"){
	                    	GochigoAlert(JSON.parse(e.xhr.responseText).errMsg);
                    	}
                    }
                });
            }
        };

        $(document).ready(function() {
            LAYOUT_${sid}.init();
        });
    </script>
</head>
<body>
	<div id="scrnArea">
		<div id="pane1"></div>
	</div>
</body>
</html>