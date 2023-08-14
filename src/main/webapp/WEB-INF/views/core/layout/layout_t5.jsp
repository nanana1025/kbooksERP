<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>${sysInfo.SYSTEM_NM} | ${title}</title>
    <style>
    html,
    body
    {
        height:100%;
        margin:0;
        padding:0;
        overflow:hidden;
    }

    #menuArea {
        height : 100%;
    }
    #scrnArea {
        height : 100%;
    }
    </style>
    <script>
    	var _systemName = '${sysInfo.SYSTEM_NM}';
    	var language = '${language}';
        var scrnMode = '${scrnMode}';
        var scrnArea, subArea;
        var menu_sid = '${menu_sid}';
        var layoutList  = '${layoutList}';
        var layoutJson  = $.parseJSON(layoutList);
        var area1_obj = layoutJson[0];
        var area2_obj = layoutJson[1];
        var area3_obj = layoutJson[2];
        var area4_obj = layoutJson[3];
        var area1_url = area1_obj['curl'] + '?' + $.param(area1_obj);
        var area2_url = area2_obj['curl'] + '?' + $.param(area2_obj);
        var area3_url = area3_obj['curl'] + '?' + $.param(area3_obj);
        var area4_url = area4_obj['curl'] + '?' + $.param(area4_obj);
        if(language !== '') {
        	area1_url += '&language=' + language;
        	area2_url += '&language=' + language;
        	area3_url += '&language=' + language;
        	area4_url += '&language=' + language;
        }
        var pane1_ready;
        var pane2_ready;
        var pane3_ready;
        var pane4_ready;

        var LAYOUT_${sid} = {

            init : function() {
                $("#content").kendoSplitter({
                    orientation: menuMode,
                    panes : [
                        {
//                         	contentUrl  : "/menu.do?menu_sid=" + menu_sid + "&sid=" + "${sid}" + "&menuMode="+menuMode,
                            collapsible	: false ,
                            resizable	: false ,
                            size: (menuMode=='vertical')? 85 : 260
                        }
                    ]
                });
                $("#scrnArea").kendoSplitter({
                    orientation: 'vertical',
                    panes : [
                        {
                            collapsible	:  ( area1_obj.collapsible == 'Y' ) ? true : false ,
                            resizable	: ( area1_obj.resizable == 'Y' ) ? true : false
                        },
                        { collapsible	: ( area3_obj.collapsible == 'Y' ) ? true : false }
                    ],
                    resize: function(e) {
                        $.each(layoutJson, function(idx, area){
                        	if(area.curl == "/list.do"){
                        		if(fnObj('LIST_'+area.sid) != null && typeof fnObj('LIST_'+area.sid).resizeGrid === "function"){
	                        		fnObj('LIST_'+area.sid).resizeGrid();
                        		}
                        	}
                        });
                    },
                    error : function(e){
                    	if(e.status == "error"){
	                    	GochigoAlert(JSON.parse(e.xhr.responseText).errMsg);
                    	}
                    }
                });

                $("#topArea").kendoSplitter({
                    orientation: "horizontal",
                    panes : [
                        {
                            contentUrl  : area1_url,
                            collapsible	: ( area1_obj.collapsible == 'Y' ) ? true : false ,
                            resizable	: ( area1_obj.resizable == 'Y' ) ? true : false ,
                            size		: ( area1_obj.width != undefined ) ? area1_obj.width : ""
                        },
                        {
                            contentUrl  : area2_url,
                            collapsible	: ( area2_obj.collapsible == 'Y' ) ? true : false ,
                            resizable	: ( area2_obj.resizable == 'Y' ) ? true : false ,
                            size		: ( area2_obj.width != undefined ) ? area2_obj.width : ""
                        }
                    ],
                    contentLoad: function(e) {
                    	if(area1_obj.height){
	               			var scrnSplitter = $("#scrnArea").data('kendoSplitter');
	               			scrnSplitter.size("#topArea", area1_obj.height);
	               			scrnSplitter.resize();
	               		}
                    	if(area3_obj.height){
	               			var scrnSplitter = $("#scrnArea").data('kendoSplitter');
	               			scrnSplitter.size("#botArea", area3_obj.height);
	               			scrnSplitter.resize();
	               		}
                    	$(e.pane.children).ready(function(){
                    		if(e.pane.id == "pane1"){
                    			pane1_ready = true;
                    		} else if(e.pane.id == "pane2"){
                    			pane2_ready = true;
                    		}
                    	});
                    	fnObj('LAYOUT_${sid}').triggerChildEvent();
                    },
                    error : function(e){
                    	if(e.status == "error"){
	                    	GochigoAlert(JSON.parse(e.xhr.responseText).errMsg);
                    	}
                    }
                });

                $("#botArea").kendoSplitter({
                    orientation: "horizontal",
                    panes : [
                        {
                            contentUrl  : area3_url,
                            collapsible	: ( area3_obj.collapsible == 'Y' ) ? true : false ,
                            resizable	: ( area3_obj.resizable == 'Y' ) ? true : false ,
                            size		: ( area3_obj.width != undefined ) ? area3_obj.width : ""
                        },
                        {
                            contentUrl  : area4_url,
                            collapsible	: ( area4_obj.collapsible == 'Y' ) ? true : false ,
                            resizable	: ( area4_obj.resizable == 'Y' ) ? true : false ,
                            size		: ( area4_obj.width != undefined ) ? area4_obj.width : ""
                        }
                    ],
                    contentLoad: function(e) {
//                     		if(area3_obj.height){
//                     			var botSplitter = $("#botArea").data('kendoSplitter');
//                     			botSplitter.size("#pane3", area3_obj.height);
//                     			botSplitter.size("#pane4", area3_obj.height);
//                     			botSplitter.resize();
//                     		}
						$(e.pane.children).ready(function(){
                    		if(e.pane.id == "pane3"){
                    			pane3_ready = true;
                    		} else if(e.pane.id == "pane4"){
                    			pane4_ready = true;
                    		}
                    	});
						fnObj('LAYOUT_${sid}').triggerChildEvent();
                    },
                    error : function(e){
                    	if(e.status == "error"){
                    		GochigoAlert(JSON.parse(e.xhr.responseText).errMsg);
                    	}
                    }
                });
                scrnArea = $("#scrnArea").data('kendoSplitter');
                topArea = $("#topArea").data('kendoSplitter');
                botArea = $("#botArea").data('kendoSplitter');
            },

            triggerChildEvent: function(){
            	if(pane1_ready && pane2_ready && pane3_ready && pane4_ready){
        			$.each(layoutJson, function(idx, layout){
        				if(layout.type == "LIST"){
        					if(!layout.pid && layout.cid){
        						fnObj('LIST_'+layout.id).onChange();
        					}
        				} else if(layout.type == "TREE"){
        					fnObj('TREE_'+layout.id).reselectTree();
        				}
        			});
        		}
            }
        };

        $(document).ready(function() {
        	LAYOUT_${sid}.init();
        });
    </script>
</head>
<body>
    <div id="scrnArea">
        <div id="topArea">
        	<div id="pane1"></div>
            <div id="pane2"></div>
        </div>
        <div id="botArea">
            <div id="pane3"></div>
            <div id="pane4"></div>
        </div>
    </div>
</body>
</html>