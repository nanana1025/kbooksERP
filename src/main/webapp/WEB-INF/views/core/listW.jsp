<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
	<meta charset="utf-8"/>
	<%--<meta id="_csrf" name="_csrf" content="${_csrf.token}"/>--%>
	<%--<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}"/>--%>
	<link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

	<script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="/codebase/common.js"></script>
	<script src="/codebase/gochigo.kendo.ui.js"></script>

    <style>
    .k-dropdown-wrap {
        padding-bottom: 1px;
    }
    .period-wrapper {
        display: inline-block;
        vertical-align: center;
    }
	.grid-titl {
		padding-top:20px;
		margin-top:0px;
	}
    </style>
    <script type="text/javascript">
        $(document).ready(function() {

            $(window).on("resize" , function() {
                setInterval(fnObj('LIST_${sid}').resizeGrid , 300);
            });

            $('#${sid}_insertBtn').kendoButton();
            var insertBtn = $('#${sid}_insertBtn').data('kendoButton');
            insertBtn.bind('click', function(e) {
            	fnObj('LIST_${sid}').onClickInsert('${sid}');
            });
            $('#${sid}_deleteBtn').kendoButton();
            var deleteBtn = $('#${sid}_deleteBtn').data('kendoButton');
            deleteBtn.bind('click', function(e) {
            	fnObj('LIST_${sid}').onClickDelete();
            });
            if($('#${sid}_searchBtn').length > 0) {
                 $('#${sid}_searchBtn').kendoButton();
                var searchBtn = $('#${sid}_searchBtn').data('kendoButton');
                searchBtn.bind('click', function(e) {
                	fnObj('LIST_${sid}').reloadGrid();
                });
            }
            // }

            fnObj('LIST_${sid}').doAfterLoad();
            fnObj('LIST_${sid}').calEvent();
            if(typeof setSearchCondition == "function"){
            	setSearchCondition();
    		}
            fnObj('LIST_${sid}').gridbox();
            fnObj('LIST_${sid}').reloadGrid();
            fnObj('LIST_${sid}').resizeGrid();

        });

        var language = '${language}';
    	var cultrue = 'ko-KR';
    	if(language === 'en') {
    		cultrue = 'en-US';
    	}

        window['LIST_${sid}'] = {
            timeoutHnd : "",
            oid : "",
            objectIds : "${objectId}",  	  //콤마로 연결된 키 컬럼명(복수 지정 가능)
            filecolname : "${filecolname}",  //파일이 있는 경우 파일컬럼명
            flAuto : false,
            curHeader : "",
            _selItem : "",

            gridbox: function(){

                kendo.culture("ko-KR");

                if("${gridInline}" == 'Y'){
                    $('#${sid}_gridbox').css("margin-top","0px");

                    var columns = JSON.parse('${columns}'.replaceAll("&bq;", "'"));

                    $.each(columns, function(i,column) {
                        var attr = column.attributes;
                        if(attr.class == "select_sql"){
                            column.editor = function(container, options){
                                $('<input required name="' + options.field + '"/>')
                                    .appendTo(container)
                                    .kendoDropDownList({
// 			                            autoBind: true,
                                        dataTextField: "text",
                                        dataValueField: "value",
                                        dataSource: {
                                            transport: {
                                                read: {
                                                    url: "/dropdownList.json"+"?sid=${sid}&col="+options.field,
                                                    dataType: "json"
                                                }
                                            },
                                            schema: {
                                                data: "combo"
                                            }
                                        }
                                    });
                            };

                        }else if(attr.class == "calendar"){
                            column.format = "{0:yyyy-MM-dd}";
                            column.editor = function(container, options){
                                $('<input class="calendaringrid" data-text-field="' + options.field + '" data-value-field="' + options.field + '" data-bind="value:' + options.field + '" data-format="' + options.format + '"/>')
                                    .appendTo(container)
                                    .kendoDatePicker({
                                        format: "yyyy-MM-dd",
                                        culture: cultrue
                                    });
                            };
                        }else if(attr.class == "checkbox"){
                            column.editor = function(container, options){
                                if (options.model[options.field] != "Y") {
                                    options.model[options.field] = null;
                                }

                                var guid = kendo.guid();
                                $('<input class="checkboxingrid k-checkbox" id="' + guid + '" type="checkbox" name="'+options.field+'" data-type="boolean">').appendTo(container);
                                $('<label class="checkboxingrid k-checkbox-label" for="' + guid + '">&#8203;</label>').appendTo(container);

                            };
                        }
                    });

                    var command = {
                        command : {
                            name: "upload"
                            ,click : function(e){
                                var tr = $(e.target).closest("tr"); // get the current table row (tr)
                                // get the data bound to the current table row
                                var data = this.dataItem(tr);
                                var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
                                var OIDS = [];
                                var str = "";
                                $.each(objectIdArr, function(i,o) {
                                    str += "&"+o+"="+data[o.toLowerCase()];
                                });
                                <%--var fileCol = "";--%>
                                <%--if(data[LIST_${sid}.filecolname.toLowerCase()]){--%>
                                    <%--fileCol = data[LIST_${sid}.filecolname.toLowerCase()];--%>
                                <%--}--%>
                                window.open("/uploadWindow.do"+"?sid=${sid}&FILE_COL="+fnObj('LIST_${sid}').filecolname+str,"_blank","width=600,height=600,top=200,left=200");
                            }
                        }
                        ,title:"파일첨부"
                        ,width:"70px"
                        ,attributes: {
                            style: "text-align: center;"
                        }
                        ,headerAttributes: {
                            style: "text-align: center;"
                        }
                    };

					if(this.filecolname != "") {
                        columns.splice(columns.length - 1, 0, command);
                    }
                    <%--$('#${sid}_btns').hide();--%>
                    $('#${sid}_gridbox').kendoGrid({
                        dataSource: {
                            transport: {
                                read: {
//                                     url: "<c:url value='/dataList.json'/>"+"?sid=${sid}",
//                                     dataType: "json"
                                }
                            },
                            schema: {
                                data: 'gridData',
                                total: 'total',
                                model:{
                                    id:"${grididcol}",
                                    fields: JSON.parse('${schemafields}')
                                }
                            },
                            pageSize: 20,
                            serverPaging: true,
                            serverSorting : true,
                            batch: true
                        },
                        change: fnObj('LIST_${sid}').onChange,
                        sortable: true,
                        scrollable: true,
                        selectable: "row",
                        columns:  columns,
                        pageable: {
                            input: true,
                            numeric: false
                        },
                        messages: {
                            commands: {
                                cancel: "취소",
                                canceledit: "취소",
                                create: "새 행 생성",
                                destroy: "삭제",
                                edit: "수정",
                                save: "저장",
                                select: "선택",
                                update: "저장",
                                upload: "파일첨부",
                                download: "다운로드"
                            }
                        },
                        editable: "inline",
                        toolbar: ["create"],
                        save: function(e) {
                            var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
                            var OIDS = [];

                            $.each(objectIdArr, function(i,o) {
                                console.log(e.model[o.toLowerCase()]);
                                if(e.model[o.toLowerCase()] != undefined && e.model[o.toLowerCase()] != "") OIDS.push(e.model[o.toLowerCase()]);
                            });

                            var qStr = "";
                            var columns = [];
                            var ccolumns = [];

                            $.each(JSON.parse('${columns}'), function(i,o) {
                                if(o.attributes.class != "calendar" && o.attributes.class != "checkbox" ) columns.push(o.field);
                                else if(o.attributes.class == "checkbox" ) ccolumns.push(o.field);
                            });

                            $.each(columns, function(i,o) {
                                if(o != undefined){
                                    var lselcol = o;
//     				   	       			var selcol = lselcol.toUpperCase();
                                    var paramvalue = e.model[lselcol];

                                    if(paramvalue == null) paramvalue = "";
                                    qStr += "&"+lselcol+"="+paramvalue;
                                }
                            });

                            $.each(ccolumns, function(i,o) {
                                if(o != undefined){
                                    var lselcol = o;
// 	 				   	       			var selcol = lselcol.toUpperCase();
                                    var paramvalue = e.model[lselcol];
                                    if(paramvalue == true) paramvalue = "Y";
                                    else if(paramvalue == false) paramvalue = "N";
                                    else if(paramvalue == null) paramvalue = "";
                                    e.model[lselcol] = paramvalue;

                                    if(paramvalue) qStr += "&"+lselcol+"="+paramvalue;
                                }
                            });

                            var calendars = $("input.calendaringrid").find().prevObject;
                            $.each(calendars, function(i,o) {
                                var vf = o.getAttribute("data-value-field");
// 	    				   	    	var vfstr = vf.toUpperCase();
                                qStr += "&"+vf+"="+o.value;
                            });

// 	    				   	 	var checkboxes = $("input.checkboxingrid ").find().prevObject;
// 	    				   	    $.each(checkboxes, function(i,o) {
// 	    				   	    	var vf = o.getAttribute("name");
// 	    				   	    	var vfstr = vf.toUpperCase();
// 	    				   	    	console.log(o);
// 	    				   	    	console.log(o.value);
// 	    				   	    	var val;
// 	    				   	    	if(o.value == "on") val = 'Y';
// 	    				   	    	if(o.value == "off") val = 'N';
// 	 				   	       		qStr += "&"+vfstr+"="+val;
// 	 			   	       		});


                            if(OIDS.length > 0){
                                // 수정(Update)
                                console.log("update ajax bf");
                                $.ajax({
                                    url: "<c:url value='/dataUpdate.json'/>"+"?sid=${sid}"+qStr ,
                                    dataType: "json",
                                    success: function(result) {
                                        var $grid = $("#${sid}_gridbox").data("kendoGrid");
                                        $grid.refresh();
                                        console.log("update ajax af");
                                    },
                                    error: function(result) {
                                    }
                                });
                            }else{
                                // 생성(Insert)
                                $.ajax({
                                    url: "<c:url value='/dataInsert.json'/>"+"?sid=${sid}"+qStr ,
                                    dataType: "json",
                                    success: function(result) {
                                        var $grid = $("#${sid}_gridbox").data("kendoGrid");
                                        $grid.refresh();
                                    },
                                    error: function(result) {
                                    }
                                });
                            }
                        },
                        remove: function(e) {
                            var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
                            var OIDS = [];
                            $.each(objectIdArr, function(i,o) {
                                OIDS.push(e.model[o.toLowerCase()]);
                            });

                            var delParam = "";
                            $.each(OIDS, function(i,o) {
                                delParam += "&"+objectIdArr[i]+"="+o;
                            });

                            $.ajax({
                                url: "<c:url value='/dataDelete.json'/>"+"?sid=${sid}"+delParam ,
                                dataType: "json", // "jsonp" is required for cross-domain requests; use "json" for same-domain requests
                                // send the updated data items as the "models" service parameter encoded in JSON
                                success: function(result) {
                                    console.log(result);
                                    // notify the data source that the request succeeded
                                },
                                error: function(result) {
                                    // notify the data source that the request failed
                                }
                            });
                        },
                        cancel: function(e) {
// 	    			   	      e.preventDefault();
                        },
                        dataBound : function(e) {
//                                 LIST_${sid}.resizeGrid();
                        }
                    });
                }else{
                    $('#${sid}_gridbox').kendoGrid({
                        dataSource: {
                            transport: {
                                read: {
//                                     url: "<c:url value='/dataList.json'/>"+"?sid=${sid}",
//                                     dataType: "json"
                                }
                            },
                            error : function(e) {
                                GochigoAlert(e.xhr.responseJSON.message);
                            },
                            schema: {
                                data: 'gridData',
                                total: 'total',
                                model:{
                                     id:"${grididcol}",
                                    fields: JSON.parse('${fields}')
                                }
                            },
                            pageSize: 20,
                            serverPaging: true,
                            serverSorting : true
                        },
                        change: fnObj('LIST_${sid}').onChange,
                        sortable: true,
                        scrollable: true,
                        persistSelection: true,
//         	    			height: "10%",
                        selectable: "row",
                        columns:  JSON.parse('${columns}'.replaceAll("&bq;", "'")),
                        pageable: {
                            input: true,
                            numeric: false
                        },
                        dataBound: function(e){
                        	fnObj('LIST_${sid}').fileThumbnail();
                        	fnObj('LIST_${sid}').resizeGrid();
                        }
                    });
                }

                if('${param.cid}'){
                	var grid = $('#${sid}_gridbox').data("kendoGrid");
                	grid.bind("dataBound", function(e){
                		 grid.select("tr:eq(0)");
                	});
                }

                $("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
                    var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
                    var viewParam = "";
                    if('${param.pid}') {
                    	viewParam += '&pid=${param.pid}';
                    }
                    viewParam += "&objectid="+fnObj('LIST_${sid}').objectIds;
                    $.each(objectIdArr, function(i,o) {
                        var $grid = $("#${sid}_gridbox").data("kendoGrid");
                        var selItem = $grid.dataItem($grid.select());
                        if(o.indexOf(".") > 0){
                    		o = o.substring(o.indexOf(".")+1, o.length);
                    	}

                        viewParam += "&"+$.trim(o)+"="+selItem[$.trim(o.toLowerCase())];

                    });

                    var xPos  = (document.body.clientWidth /2) - (800 / 2);
                    xPos += window.screenLeft;
                    var yPos  = (screen.availHeight / 2) - (600 / 2);
                    window.open("<c:url value='/dataView.do'/>"+"?sid=${sid}"+ encodeURI(viewParam), "dataView", "top="+yPos+", left="+xPos+", width=800, height=600");
                });

                $("#${sid}_gridbox th").on("click", function(e) {
                	fnObj('LIST_${sid}').curHeader = e.currentTarget.dataset.field;
                });
            },

            onChange: function(args) {
                var grid = $('#${sid}_gridbox').data('kendoGrid');
                if(grid.columns[0].selectable){
                	console.log("The selected product ids are: [" + this.selectedKeyNames().join(", ") + "]");
                }else{
                	var cid = '${param.cid}';
                    var oid = '${param.oid}';
                    var ctype = '${param.ctype}';
                    var cobjectid = '${param.cobjectid}';
                    var qStr = "";

                    var objArr = oid.split(",");
                    var cobjArr = cobjectid.split(",");
                    _selItem = grid.dataItem(grid.select());
                    var selItem = grid.dataItem(grid.select());
                    var qParam = new Array();
                    for(var i=0; i<objArr.length; i++){
                        qParam.push(selItem.get(objArr[i]));
                    }

                    var pStr = qParam.join(","); //value 구분자

                    qStr += '&cobjectid=' + cobjectid;
                    qStr += '&cobjectval=' + pStr;

                    if(ctype == 'LIST') {

                        if(window.s_col != null) {
                            qStr += '&orderBy=' + window.s_col;
                            qStr += '&direction=' + window.a_direction;
                        }

                        $("#"+cid+"_gridbox").data("kendoGrid").dataSource.transport.options.read.url = "<c:url value='/dataList.json'/>"+"?sid="+cid+"&"+qStr;
                        $("#"+cid+"_gridbox").data("kendoGrid").dataSource.read();
                    } else if(ctype == 'CRUD') {
                        fnObj('CRUD_${param.cid}').initPage("<c:url value='/dataView.json'/>"+"?sid="+cid+"&"+qStr);
                    }

                    if('${childtabid}'){
                        var stids = "${ctobjectids}";
                        var tids = [];
                        tids = stids.split(",");
                        var str = "";
                        var qStr = "";

                        for(var i = 0; i < tids.length; i++){
                            var selItem = grid.dataItem(grid.select());
                            str += selItem.get(tids[i].toLowerCase());
                            if(i != tids.length - 1){
                                str += ",";
                            }
                        }
                        if(str.indexOf(",")>-1){
                            var has = new RegExp("^[,\,]+$").test(str);
                            if(has) str="";
                        }else{
                            var has = new RegExp("^[ \ ]+$").test(str);
                            if(has) str="";
                        }
                        qStr += '&tobjectid=' + str;
                        if(window.s_col != null) {
                            qStr += '&orderBy=' + window.s_col;
                            qStr += '&direction=' + window.a_direction;
                        }
                        $("#${childtabid}_gridbox").data("kendoGrid").dataSource.transport.options.read.url = "<c:url value='/dataList.json'/>"+"?sid=${sid}+&sid=${childtabid}&"+qStr;
                        $("#${childtabid}_gridbox").data("kendoGrid").dataSource.read();
                    }
                }
            },

            //검색
            doSearch: function(){
            	fnObj('LIST_${sid}').reloadGrid();
            },
            //그리드 reload
            reloadGrid: function(){
                var qStr="";
                var input = $('#${sid}_searchDiv input');
                if(input.length > 0){
                    $.each(input, function(i,o) {
                        if(o.type == 'checkbox') {
                            qStr += "&"+o.id+"="+o.checked;
                        } else {
                            qStr += "&"+o.id+"="+o.value;
                        }

                    });

                    for(var i=0; i<input.length; i++){
                        qStr += "&"+input[i].id+"="+input[i].value;
                    }
                }
                var select = $('#${sid}_searchDiv select');
                if(select.length > 0){
                    for(var i=0; i<select.length; i++){
                        qStr += "&"+select[i].id+"="+select[i].value;
                    }
                }
                if(window.s_col != null) {
                    qStr += '&orderBy=' + window.s_col;
                    qStr += '&direction=' + window.a_direction;
                }
                $("#${sid}_gridbox").data("kendoGrid").dataSource.transport.options.read.url = "<c:url value='/dataList.json'/>"+"?sid=${sid}&"+qStr;
                $("#${sid}_gridbox").data("kendoGrid").dataSource.read();

                fnObj('LIST_${sid}').fileThumbnail();

            },
            //검색조건 키인 시 자동 검색
            <%--enableAutosubmit: function(state){--%>
            <%--LIST_${sid}.flAuto = state;--%>
            <%--document.getElementById("submitButton").disabled = state--%>
            <%--},--%>

            onClickInsert: function() {
            	var pid = '${param.pid}';
            	var ptype = '${param.ptype}';
            	var grid = $('#'+pid+'_gridbox').data('kendoGrid');
                var oid = '${param.oid}';
                var queryString = "";

                if(pid && ptype == 'LIST'){
	                var objArr = oid.split(",");
	                var selItem = grid.dataItem(grid.select());
	                var qParam = new Array();
	                for(var i = 0; i < objArr.length; i++){
	                    qParam.push(selItem.get(objArr[i]));
	                }

	                var pStr = qParam.join(","); //value 구분자

	                queryString += '&pid=${param.pid}';
	                queryString += '&objectid=' + oid;
	                queryString += '&objectval=' + pStr;
                }

                if(pid && ptype == 'TREE'){
                	queryString += '&pid=${param.pid}';
                }

                var xPos  = (document.body.clientWidth /2) - (800 / 2);
                xPos += window.screenLeft;
                var yPos  = (screen.availHeight / 2) - (600 / 2);
                window.open("<c:url value='/dataEdit.do'/>"+"?sid=${sid}"+queryString, "dataEdit", "top="+yPos+", left="+xPos+", width=800, height=600, scrollbars=1");
            },

            onClickDelete: function() {
            	var pid = '${param.pid}';
            	var ptype = '${param.ptype}';
            	var grid = $('#${sid}_gridbox').data('kendoGrid');
                var selectedItem = grid.dataItem(grid.select());
                if(!selectedItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}
                var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
                var OIDS = [];
                $.each(objectIdArr, function(i,o) {
                	if(o.indexOf(".") > 0){
                		o = o.substring(o.indexOf(".")+1, o.length);
                	}
                    var selItem = grid.dataItem(grid.select());
                    if(selItem) OIDS.push(selItem[o]);
                });

                var delParam = '';
                if(pid) {
                	delParam += "&pid=" + pid;
                }

                $.each(OIDS, function(i,o) {
                	var objectId = objectIdArr[i];
                	if(objectId.indexOf(".") > 0){
                		objectId = objectId.substring(objectId.indexOf(".")+1, objectId.length);
                	}
                    delParam += "&"+objectId+"="+o;
                });

                var url = "/dataDelete.json";
				if('${customDeleteUrl}'){
					url = '${customDeleteUrl}';
				}
                $.ajax({
                    url : "<c:url value='"+url+"'/>"+"?sid=${sid}&"+delParam,
                    success : function(data, status) {
                        if(status === 'success') {
                            GochigoAlert('삭제 되었습니다.');
                            if(data.pid && ptype == "LIST") {
                            	fnChildReloadGrid(data.pid);
                            } else if(data.pid && ptype == "TREE"){
                            	fnObj('TREE_'+pid).reselectTree();
                            } else {
                            	fnObj('LIST_${sid}').reloadGrid();
                            }

                        }
                    },
                    error: function(req, stat, error) {
                        GochigoAlert(req.responseText);
                    }
                });
            },

            doAfterLoad: function() {
                var calLen = $('.calendar').length;
                if(calLen > 0 && $('.calendar[id][data-role="datepicker"]').length == 0){
                    $('.calendar').kendoDatePicker({
                        format: "yyyy-MM-dd",
                        culture: cultrue
                    });
                }

                var selLen = $('.select').length;
                if(selLen > 0){
                    $('.select').kendoDropDownList();
                }

            },

            // kendo grid 용 resize grid
            resizeGrid: function() {
            	var gridHml = $("#${sid}_gridHml");
                var gridElement = $("#${sid}_gridbox"),
                    dataArea = gridElement.find(".k-grid-content").first(),
                    otherElements = gridElement.children().not(".k-grid-content"),
                    otherElementsHeight = 0;
                otherElements.each(function() {
                    otherElementsHeight += Math.ceil($(this).outerHeight());
                });

                var gridHmlHeight = gridHml.height();
                var winHeight = $(window).height();
                var gridContentOffset =  $("#${sid}_gridbox .k-grid-header").offset().top;//그리드 헤더까지 상단 offset

                var contentHeight = 0;

				if("${param.mode}" == 'layout') {
					if(gridHmlHeight > gridContentOffset) {
		                contentHeight = gridHmlHeight - Math.ceil(gridContentOffset) - Math.ceil(otherElementsHeight) + $("#${sid}_searchBlock").offset().top;; //그리드 데이터 영역 높이 계산
		            } else {
		                contentHeight = winHeight - Math.ceil(gridContentOffset) - Math.ceil(otherElementsHeight); //그리드 데이터 영역 높이 계산
		            }
		            dataArea.height(contentHeight );
        		}

	            if("${param.mode}" != 'layout') {
	            	contentHeight = winHeight - Math.ceil(gridContentOffset) - Math.ceil(otherElementsHeight); //그리드 데이터 영역 높이 계산
	                dataArea.height(contentHeight - 42);
	        	}

            },
            fnGoMain: function(){
                location.href = "/";
            },

            MergeGridRows : function(gridId, colTitle) {

                $('#' + gridId + '>.k-grid-content>table').each(function (index, item) {
                    var dimension_col = 1;
                    // First, scan first row of headers for the "Dimensions" column.
                    $('#' + gridId + '>.k-grid-header>.k-grid-header-wrap>table').find('th').each(function () {
                        var _this = $(this);
                        if (_this.text() == colTitle) {
                            var bgColor = _this.css('background-color');
                            var foreColor = _this.css('color');
                            var rightBorderColor = _this.css('border-right-color');

                            // first_instance holds the first instance of identical td
                            var first_instance = null;
                            var cellText = '';
                            var arrCells = [];
                            $(item).find('tr').each(function () {
                                // find the td of the correct column (determined by the colTitle)
                                var dimension_td = $(this).find('td:nth-child(' + dimension_col + ')');

                                if (first_instance == null) {
                                    first_instance = dimension_td;
                                    cellText = first_instance.text();
                                } else if (dimension_td.text() == cellText) {
                                    // if current td is identical to the previous
                                    // dimension_td.css('border-top', '0px');
                                } else {
                                    // this cell is different from the last
                                    arrCells = fnObj('LIST_${sid}').ChangeMergedCells(arrCells, cellText, true);
                                    //first_instance = dimension_td;
                                    cellText = dimension_td.text();
                                }
                                arrCells.push(dimension_td);
                                dimension_td.text("");
                                // dimension_td.css('background-color', 'white').css('color', 'black').css('border-bottom-color', 'transparent');
                            });
                            arrCells = fnObj('LIST_${sid}').ChangeMergedCells(arrCells, cellText, true);
                            return;
                        }
                        dimension_col++;
                    });

                });
            },
            ChangeMergedCells : function(arrCells, cellText, addBorderToCell) {
                var cellsCount = arrCells.length;
                if (cellsCount > 1) {
                    var index = parseInt(cellsCount / 2);
                    var cell = null;
                    if (cellsCount % 2 == 0) { // even number
                        cell = arrCells[index - 1];
                        arrCells[index - 1].css('vertical-align', 'bottom');
                    }
                    else { // odd number
                        cell = arrCells[index];
                    }
                    cell.text(cellText);
                    if (addBorderToCell) {
                        arrCells[cellsCount - 1].css('border-bottom', 'solid 1px #ddd');

                    }

                    arrCells = []; // clear array for next item
                }
                if (cellsCount == 1) {
                    cell = arrCells[0];
                    cell.text(cellText);
                    arrCells[0].css('border-bottom', 'solid 1px #ddd');
                    arrCells = [];
                }
                return arrCells;
            },

            calEvent: function() {
                var fromCals = $('#${sid}_searchBlock input[id*="_date_from"]');
                $.each(fromCals, function(idx, from) {
                    var preName = from.id.substring(0, from.id.indexOf("_date_from"));
                    var frompicker = $("#"+from.id).data("kendoDatePicker");
                    frompicker.bind("change", function(){
                        var toId = preName + "_date_to";
                        var fromDate = frompicker.value();

                        var topicker = $("#"+toId).data("kendoDatePicker");
                        topicker.setOptions({
                            disableDates: function(date) {
                                if(fromDate == null){ return false; }
                                else if(date < fromDate){ return true; }
                                else { return false; }
                            }
                        });
                    });
                });

                var toCals = $('#${sid}_searchBlock input[id*="_date_to"]');
                $.each(toCals, function(idx, to) {
                    var preName = to.id.substring(0, to.id.indexOf("_date_to"));
                    var topicker = $("#"+to.id).data("kendoDatePicker");
                    topicker.bind("change", function(){
                        var fromId = preName + "_date_from";
                        var toDate = topicker.value();

                        var frompicker = $("#"+fromId).data("kendoDatePicker");
                        frompicker.setOptions({
                            disableDates: function(date) {
                                if(toDate == null){ return false; }
                                else if(date > toDate){ return true; }
                                else { return false; }
                            }
                        });
                    });
                });
            },

            fileThumbnail : function() {
            		var fileRows = $('.fileInfo');
            		$.each(fileRows, function(idx,fileRow){
            			var fileTextArr = fileRow.innerText;
            			if(fileTextArr){
	            			var fileText = fileTextArr.split("/");
           					var html = "";
	            			for(var i=0;i<fileText.length;i++){
	            				var fileInfo = fileText[i].split("|");
	           					var fileId = fileInfo[0];
	           					var fileSeq = fileInfo[1];
	           					var fileName = fileInfo[2];
	           					var fileExt = fileInfo[3];
	           					var fileType = "txt";
	           					if(fileExt=="gif"||fileExt=="png"||fileExt=="bmp"||fileExt=="jpg"||fileExt=="jpeg"){fileType = "image"}
	           					else if(fileExt=="xls"||fileExt=="xlsx"){fileType = "excel"}
	           					else if(fileExt=="dox"||fileExt=="docx"){fileType = "word"}
	           					else if(fileExt=="ppt"||fileExt=="pptx"){fileType = "ppt"}
	           					else if(fileExt=="pdf"){fileType = "pdf"}
	           					else {fileType = "txt"}
	           					if(fileType == "image"){
		           					html += "<a href='/downloadDirect.json?fileName="+fileName+"'><span id='filetag_"+idx+"_"+i+"' title='"+fileName+"' class='k-icon k-i-"+fileType+"'></span></a>";
	           					} else {
		           					html += "<a title='"+fileName+"' href='/downloadDirect.json?fileName="+fileName+"'><span class='k-icon k-i-"+fileType+"'></span></a>";
	           					}
	           					$(this).html(html);

	           					if(fileType == "image"){
		           					$('#filetag_'+idx+"_"+i).kendoTooltip({
	// 	           						filter: "span",
		           						content: kendo.template($("#template").html()),
		           						width: 200,
		           						height: 200,
		           						position: "bottom"
		           					});
	           					}
	            			}
            			}
            		});
            }
        }

        function fnChildReloadGrid(pid) {
        	fnObj('LIST_' + pid).onChange();
        }


    </script>

     <script id="template" type="text/x-kendo-template">
        <div class="template-wrapper">
			<div>#=target.data('title')#</div>
            <img style="width:100%;height:100%;" src="/downloadDirect.json?fileName=#=target.data('title')#" alt="#=target.data('title')#" />
        </div>
     </script>
</head>
<body>
    	<div id="${sid}_gridHml" class="k-content" style="width:100%;">
		<div id="${sid}_searchBlock">
			<div class="header_title">
	            <span class="pagetitle">${title}</span>
	        </div>
			${searchHml}
<%-- 			<c:if test="${listmode != 'view'}"> --%>
			<div id="${sid}_btns" style="float:right;">
				<button id="${sid}_insertBtn" class="basicBtn">등록</button>
				<button id="${sid}_deleteBtn" class="basicBtn">삭제</button>
			</div>
<%-- 			</c:if> --%>
		</div>
		<div id="${sid}_gridbox" style="margin-top: 40px;"></div>
	</div>
    <div id="${fid}_popgrid_btns" style="text-align:center; margin-top:8px;">
    	 <button id="${sid}_confirmBtn" class="k-button" onclick="LIST_${fid}.fnConfirm()">확인</button>
	     <button id="${sid}_cancelBtn" class="k-button" onclick="LIST_${fid}.fnCancel()">취소</button>
    </div>
    <c:if test="${jsfileyn == 'Y'}">
		<jsp:include page="${jsfileurl}"></jsp:include>
		<div id="${sid}_customHtml"></div>
	</c:if>
</body>
</html>