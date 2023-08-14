<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<meta charset="utf-8"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/fonts/NotoSansKR/stylesheets/NotoSansKR-Hestia.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

    <script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="/codebase/kendo/messages/kendo.messages.ko-KR.min.js"></script>
	<script src="/codebase/kendo/jszip.min.js"></script>
    <script src="/codebase/common.js"></script>
    <script src="/codebase/default.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <style>
    html,
    body
    {
        height:100%;
        margin:0;
        padding:0;
        overflow:hidden;
    }

     #siddle,
     #htbody,#siddleright
     {
         height:100%;
     }

     #htbody,#siddleright
     {
         border-width: 0;
     }
    .k-dropdown-wrap {
        padding-bottom: 1px;
    }
    .period-wrapper {
        display: inline-block;
        vertical-align: center;
    }
    #menu ul li{
/*     	width:150px; */
    }
    .k-menu-horizontal > .k-last /* for all horizontal menus */
	{
	   border-width: 0;
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
	.subBackground {/* position:absolute; */ /* background-color:#35455E; */ border:1px solid #28364C; height: 35px;}
 	.subNavBarOut {float: left;}
	.subHome {margin: 0px; padding-top: 12px;padding-left: 20px;cursor: pointer;height: 15px;}
	.subRightarrow {margin: 0px;padding-left: 20px;padding-right: 20px;padding-top: 13px;height: 10px;}
    .ml {
        margin-left: 15px;
    }
    </style>
    <script>
        // var token = $("meta[name='_csrf']").attr("content");
        // var header = $("meta[name='_csrf_header']").attr("content");
        //
        // $(function() {
        //     $(document).ajaxSend(function(e, xhr, options) {
        //         xhr.setRequestHeader(header, token);
        //     });
        // });

        $(document).ready(function() {
        	var layoutList = '${layoutList}';
        	var layoutJson = $.parseJSON(layoutList);

        	var sid = '${sid}';
        	var title = '${title}';
        	var layouttype = '${layouttype}';

            if(layouttype == 1){

                var a1 = layoutJson[0];
                var a2 = layoutJson[1];

                var a1url = a1.curl + '?' + $.param(a1);
                var a2url = a2.curl + '?' + $.param(a2);

                $("#htbody").kendoSplitter({
                    orientation: "vertical",
                    panes: [
                        {
                          	contentUrl	: a1url,
                            collapsible	: ( a1.collapsible != undefined ) ? a1.collapsible : "" ,
                            resizable	: ( a1.resizable != undefined ) ? a1.resizable : "" ,
                            size		: ( a1.size != undefined ) ? a1.size : ""
                        },
                        {
                           	contentUrl	: a2url,
                            collapsible	: ( a2.collapsible != undefined ) ? a2.collapsible : "" ,
                            resizable	: ( a2.resizable != undefined ) ? a2.resizable : "" ,
                            size		: ( a2.size != undefined ) ? a2.size : ""
                        }
                    ]

                });
            }else if(layouttype == 2){

                var a1 = layoutJson[0];
                var a2 = layoutJson[1];
                var a3 = layoutJson[2];

                var a1url = a1.curl + '?' + $.param(a1);
                var a2url = a2.curl + '?' + $.param(a2);
                var a3url = a3.curl + '?' + $.param(a3);

                $("#htbody").kendoSplitter({
                    orientation: "vertical",
                    panes: [
                        {
							contentUrl	: a1url ,
                            collapsible	: ( a1.collapsible != undefined ) ? a1.collapsible : "" ,
                            resizable	: ( a1.resizable != undefined ) ? a1.resizable : "" ,
                            size		: ( a1.size != undefined ) ? a1.size : ""
                        }
                    ]
                });

                $("#middle").kendoSplitter({
                    orientation: "horizontal",
                    panes: [
                        {
							contentUrl	: a2url ,
                            collapsible	: ( a2.collapsible != undefined ) ? a2.collapsible : "" ,
                            resizable	: ( a2.resizable != undefined ) ? a2.resizable : "" ,
                            size		: ( a2.size != undefined ) ? a2.size : ""
                        },
                        {
                           	contentUrl	: a3url ,
                            collapsible	: ( a3.collapsible != undefined ) ? a3.collapsible : "" ,
                            resizable	: ( a3.resizable != undefined ) ? a3.resizable : "" ,
                            size		: ( a3.size != undefined ) ? a3.size : ""
                        }
                    ]
                });

            }else if(layouttype == 3){

                var a1 = layoutJson[0];
                var a2 = layoutJson[1];
                var a3 = layoutJson[2];
                var a4 = layoutJson[3];
                var a1url = a1.curl + '?' + $.param(a1);
                var a2url = a2.curl + '?' + $.param(a2);
                var a3url = a3.curl + '?' + $.param(a3);
                var a4url = a4.curl + '?' + $.param(a4);

                $("#htbody").kendoSplitter({
                    orientation: "vertical",
                    panes: [
                        {
                           	contentUrl	: a1url,
                            collapsible	: ( a1.collapsible != undefined ) ? a1.collapsible : "" ,
                            resizable	: ( a1.resizable != undefined ) ? a1.resizable : "" ,
                            size		: ( a1.size != undefined ) ? a1.size : ""
                        },
                        {
                        }
                    ]
                });

                $("#middle").kendoSplitter({
                    orientation: "horizontal",
                    panes: [
                        {
							contentUrl	: a2url ,
                            collapsible	: ( a2.collapsible != undefined ) ? a2.collapsible : "" ,
                            resizable	: ( a2.resizable != undefined ) ? a2.resizable : "" ,
                            size		: ( a2.size != undefined ) ? a2.size : ""
                        },
                        {}
                    ]
                });

                $("#middleright").kendoSplitter({
                    orientation: "vertical",
                    panes: [
                        {
                         	contentUrl	: a3url ,
                            collapsible	: ( a3.collapsible != undefined ) ? a3.collapsible : "" ,
                            resizable	: ( a3.resizable != undefined ) ? a3.resizable : "" ,
                            size		: ( a3.size != undefined ) ? a3.size : ""
                        },
                        {
                          	contentUrl	: a4url ,
                            collapsible	: ( a4.collapsible != undefined ) ? a4.collapsible : "" ,
                            resizable	: ( a4.resizable != undefined ) ? a4.resizable : "" ,
                            size		: ( a4.size != undefined ) ? a4.size : ""
                        }
                    ]
                });

            }else if(layouttype == 4) {
        	    var a1 = layoutJson[0];
        	    var a2 = layoutJson[1];

                var a1url = a1.curl + '?' + $.param(a1);
                var a2url = a2.curl + '?' + $.param(a2);

        	    $("#htbody").kendoSplitter({
					orientation: "horizontal",
					panes: [
						{
                            contentUrl	: a1url ,
                            collapsible	: ( a1.collapsible != undefined ) ? a1.collapsible : "" ,
                            resizable	: ( a1.resizable != undefined ) ? a1.resizable : "" ,
                            size		: ( a1.size != undefined ) ? a1.size : ""
						},
                        {
							contentUrl	: a2url ,
                            collapsible	: ( a2.collapsible != undefined ) ? a2.collapsible : "" ,
                            resizable	: ( a2.resizable != undefined ) ? a2.resizable : "" ,
                            size		: ( a2.size != undefined ) ? a2.size : ""
                        }
					]
				});
            } else if(layouttype == 5) {
                var a1 = layoutJson[0];
                var a2 = layoutJson[1];
                var a3 = layoutJson[2];

                var a1url = a1.curl + '?' + $.param(a1);
                var a2url = a2.curl + '?' + $.param(a2);
                var a3url = a3.curl + '?' + $.param(a3) + '&scrtype=bottom';

                $("#htbody").kendoSplitter({
                    orientation: "horizontal",
                    panes: [
                        {
                            contentUrl	: a1url ,
                            collapsible	: ( a1.collapsible == "true" ) ? true : false ,
                            resizable	: ( a1.resizable == "true" ) ? true : false ,
                            size		: ( a1.size != undefined ) ? a1.size : ""
                        }
                    ]
                });

                $("#right").kendoSplitter({
                    orientation: "vertical",
                    panes: [
                        {
                            contentUrl	: a2url ,
                            collapsible	: ( a2.collapsible == "true") ? true : false ,
                            resizable	: ( a2.resizable == "true" ) ? true : false ,
                            size		: ( a2.size != undefined ) ? a2.size : ""
                        },
                        {
                            contentUrl	: a3url ,
                            collapsible	: ( a3.collapsible == "true" ) ? true : false ,
                            resizable	: ( a3.resizable == "true" ) ? true : false ,
                            size		: ( a3.size != undefined ) ? a3.size : ""
                        }
                    ]
                });
            }
		});
    </script>
</head>
<body>
<c:if test="${layouttype == '1'}">
	<div id="htbody" >
	    <div id="top"></div>
	    <div id="siddle"></div>
	</div>
</c:if>
<c:if test="${layouttype == '2'}">
	<div id="htbody" >
	    <div id="top"></div>
	    <div id="siddle">
	    	<div id="siddleleft"></div>
	    	<div id="siddleright"></div>
	    </div>

	</div>
</c:if>
<c:if test="${layouttype == '3'}">
	<div id="htbody" >
	    <div id="top"></div>
	    <div id="siddle">
	    	<div id="siddleleft"></div>
	    	<div id="siddleright">
	    		<div id="siddlerighttop"></div>
	    		<div id="siddlerightbottom"></div>
	    	</div>
	    </div>
	</div>
</c:if>
<c:if test="${layouttype == '4'}">
	<div id="htbody">
	    <div id="left"></div>
	    <div id="right"></div>
	</div>
</c:if>
<c:if test="${layouttype == '5'}">
	<div id="htbody">
	    <div id="left"></div>
	    <div id="right">
	    	<div id="righttop"></div>
	    	<div id="rightbottom"></div>
	    </div>
	</div>
</c:if>
</body>
</html>