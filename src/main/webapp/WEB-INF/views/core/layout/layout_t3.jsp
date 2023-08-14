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

        var menu_sid = '${menu_sid}';
        var layoutList  = '${layoutList}';
        var layoutJson  = $.parseJSON(layoutList);
        var area1_obj = layoutJson[0];
        var area2_obj = layoutJson[1];
        var area3_obj = layoutJson[2];
        var area2_url = area2_obj['curl'] + '?' + $.param(area2_obj);
        var area1_url = area1_obj['curl'] + '?' + $.param(area1_obj);
        var area3_url = area3_obj['curl'] + '?' + $.param(area3_obj);
        if(language !== '') {
        	area1_url += '&language=' + language;
        	area2_url += '&language=' + language;
        	area3_url += '&language=' + language;
        }
        var pane1_ready;
        var pane2_ready;
        var pane3_ready;

        console.log("area2_obj.width = "+area2_obj.width);

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
                        },
                        {

                        }
                    ]
                });
                $("#scrnArea").kendoSplitter({
                    orientation: 'horizontal',
                    panes : [
                        {
                            contentUrl  : area1_url,
                            collapsible	: ( area1_obj.collapsible == 'Y' ) ? true : false ,
                            resizable	: ( area1_obj.resizable == 'Y' ) ? true : false ,
                            size		: ( area1_obj.width != undefined ) ? area1_obj.width : ""
                        },
                        { }
                    ],
                    error : function(e){
                    	if(e.status == "error"){
	                    	GochigoAlert(JSON.parse(e.xhr.responseText).errMsg);
                    	}
                    },
                    contentLoad: function(e){
                    	$(e.pane.children).ready(function(){
                    		if(e.pane.id == "pane1"){
                    			pane1_ready = true;
                    		}
                    	});
                    	fnObj('LAYOUT_${sid}').triggerChildEvent();
                    }
                });
                $("#subArea").kendoSplitter({
                    orientation: scrnMode,
                    panes : [
                        {
                            contentUrl  : area2_url,
                            collapsible	: ( area2_obj.collapsible == 'Y' ) ? true : false ,
                            resizable	: ( area2_obj.resizable == 'Y' ) ? true : false ,
                            size		: ( area2_obj.width != undefined ) ? area2_obj.width : ""
//                             		size		: ( area2_obj.width != undefined ) ? "1000" : ""

                        },
                        {
                            contentUrl  : area3_url,
                            collapsible	: ( area3_obj.collapsible == 'Y' ) ? true : false ,
                            resizable	: ( area3_obj.resizable == 'Y' ) ? true : false ,
                            size		: ( area3_obj.width != undefined ) ? area3_obj.width : ""
                        }
                    ],
                    contentLoad: function(e) {
                    	if(scrnMode == 'vertical'){
                    		if(area2_obj.height){
                    			var subSplitter = $("#subArea").data('kendoSplitter');
                    			subSplitter.size("#pane2", area2_obj.height);
                    			subSplitter.resize();
                    		}
                    		if(area3_obj.height){
                    			var subSplitter = $("#subArea").data('kendoSplitter');
                    			subSplitter.size("#pane3", area3_obj.height);
                    			subSplitter.resize();
                    		}
                       	}
                    	$(e.pane.children).ready(function(){
                    		if(e.pane.id == "pane2"){
                    			pane2_ready = true;
                    		} else if(e.pane.id == "pane3"){
                    			pane3_ready = true;
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
            },

            triggerChildEvent: function(){
            	if(pane1_ready && pane2_ready && pane3_ready){
        			$.each(layoutJson, function(idx, layout){
        				if(layout.type == "LIST"){
        					if(!layout.pid && layout.cid){
        						fnObj('LIST_'+layout.id).onChange();
        					}
        					fnObj('LIST_'+layout.id).resizeGrid();
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
        <div id="pane1"></div>
        <div id="subArea">
            <div id="pane2"></div>
            <div id="pane3"></div>
        </div>
    </div>
</body>
</html>