<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${param.mode!='layout'}">
<!DOCTYPE html>
<html>
<head>
    <title>grid</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<meta charset="utf-8"/>
	<%--<link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>--%>
	<link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/kendo.spaero.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

	<script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="/codebase/common.js"></script>
	<%--<script src="/js/sockjs-0.3.4.js"></script>--%>
	<%--<script src="/js/stomp.js"></script>--%>
</head>
	<style>
		body {
			font-size: 13px !important;
			font-family: "Noto Sans Korean", sans-serif;
		}
	</style>
</c:if>

<script type="text/javascript">

    $(document).ready(function() {
        $(window).on("resize" , function() {
            setInterval(fnObj('LIST_${sid}').resizeGrid , 300);
        });

        $('#${sid}_searchDiv').find('input[type="text"]').on('keydown', function(e) {
            if (e.keyCode == 13) {
                fnObj('LIST_${sid}').reloadGrid();
            }
        });
        if($('#${sid}_searchBtn').length > 0) {
            $('#${sid}_searchBtn').kendoButton();
            var searchBtn = $('#${sid}_searchBtn').data('kendoButton');
            searchBtn.bind('click', function(e) {
                fnObj('LIST_${sid}').reloadGrid();
            });
        }

        setTimeout(function(){
            fnObj('LIST_${sid}').doAfterLoad();
            fnObj('LIST_${sid}').calEvent();
            if(typeof setSearchCondition == "function"){
                setSearchCondition();
            }
            fnObj('LIST_${sid}').gridbox();
            if('${param.ptype}' != "TREE"){
                <%--fnObj('LIST_${sid}').reloadGrid();--%>
            }
            fnObj('LIST_${sid}').resizeGrid();
        },300);

        if(!opener) {
            $("#${fid}_popgrid_btns").remove();
        }

        if('C' != '${sessionScope.authTp}') {
            $(".crud").remove();
        }

    });

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

			$('#${sid}_gridbox').css("margin-top","0px");

			var columns = JSON.parse('${columns}'.replaceAll("&bq;", "'"));

			$.each(columns, function(i,column) {
				var attr = column.attributes;
				if(attr.class == "select_sql"){
					column.editor = function(container, options){
						$('<input required name="' + options.field + '"/>')
							.appendTo(container)
							.kendoDropDownList({
								autoBind: true,
								dataTextField: "text",
								dataValueField: "value",
                                optionLabel:"Select...",
								dataSource: {
									transport: {
										read: {
											url: "/gridDropdownList.json"+"?sid=${sid}&col="+options.field,
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
								culture: "ko-KR"
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
                            url: "<c:url value='/dataList.json'/>"+"?sid=${sid}",
                            dataType: "json"
						},
						destroy : {
							url : "<c:url value='/gridDataDelete.json'/>",
							dataType: "json",
                            complete : function (jqXhr, textStatus) {
                                if (textStatus == 'success') {
                                    var result = jQuery.parseJSON(jqXhr.responseText);
                                    $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
                                } else {
                                    GochigoAlert('DELETE FAIL!');
                                }
                            }
                        },
						update : {
						    url : "<c:url value='/gridDataUpdate.json'/>",
							dataType: "json",
                            complete : function (jqXhr, textStatus) {
                                if (textStatus == 'success') {
                                    var result = jQuery.parseJSON(jqXhr.responseText);
                                    console.log(result);
                                    $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
                                } else {
                                    GochigoAlert('UPDATE FAIL!');
                                }
                            }
                        },
						create : {
                            url : "<c:url value='/gridDataInsert.json'/>",
                            dataType: "json",
                            complete : function (jqXhr, textStatus) {
                                if (textStatus == 'success') {
                                    var result = jQuery.parseJSON(jqXhr.responseText);
                                    console.log(result);
                                    $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
                                } else {
                                    GochigoAlert('INSERT FAIL!');
                                }
                            }
                        },
						parameterMap : function(options, operation) {
							if(operation == "update" || operation == "destroy") {
                                var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
                                var OIDS = [];
                                var _model = options.models[0];
                                $.each(objectIdArr, function(i,o) {
                                    if(_model[o.toLowerCase()] != undefined && _model[o.toLowerCase()] != "") OIDS.push(_model[o.toLowerCase()]);
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
                                        var paramvalue = _model[lselcol];

                                        if(paramvalue != null && typeof paramvalue == "object") {
                                            paramvalue = _model[lselcol].value;
										}
                                        if(paramvalue == null) paramvalue = "";
                                        qStr += "&"+lselcol+"="+paramvalue;
                                    }
                                });


                                $.each(ccolumns, function(i,o) {
                                    if(o != undefined){
                                        var lselcol = o;
// 	 				   	       			var selcol = lselcol.toUpperCase();
                                        var paramvalue = _model[lselcol];
                                        if(paramvalue == true) paramvalue = "Y";
                                        else if(paramvalue == false) paramvalue = "N";
                                        else if(paramvalue == null) paramvalue = "";
                                        _model[lselcol] = paramvalue;

                                        if(paramvalue) qStr += "&"+lselcol+"="+paramvalue;
                                    }
                                });

                                var calendars = $("input.calendaringrid").find().prevObject;
                                $.each(calendars, function(i,o) {
                                    var vf = o.getAttribute("data-value-field");
// 	    				   	    	var vfstr = vf.toUpperCase();
                                    qStr += "&"+vf+"="+o.value;
                                });
								console.log("sid=${sid}"+qStr);
								return encodeURI("sid=${sid}"+qStr);

                            } else if(operation == "create") {
                                var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
                                var OIDS = [];
                                var _model = options.models[0];
                                $.each(objectIdArr, function(i,o) {
                                    if(_model[o.toLowerCase()] != undefined && _model[o.toLowerCase()] != "") OIDS.push(_model[o.toLowerCase()]);
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
                                        var paramvalue = _model[lselcol];

                                        if(paramvalue == null) paramvalue = "";
                                        qStr += "&"+lselcol+"="+paramvalue;
                                    }
                                });

                                $.each(ccolumns, function(i,o) {
                                    if(o != undefined){
                                        var lselcol = o;
// 	 				   	       			var selcol = lselcol.toUpperCase();
                                        var paramvalue = _model[lselcol];
                                        if(paramvalue == true) paramvalue = "Y";
                                        else if(paramvalue == false) paramvalue = "N";
                                        else if(paramvalue == null) paramvalue = "";
                                        _model[lselcol] = paramvalue;

                                        if(paramvalue) qStr += "&"+lselcol+"="+paramvalue;
                                    }
                                });
								console.log("sid=${sid}"+qStr);
                                return encodeURI("sid=${sid}"+qStr);
                            }else if(operation == "read") {
                                return options;
                            }
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
				filterable : {
					extra: false,
					operators: {
						string: {
							startswith: "~로 시작",
							contains: "~를 포함",
							eq: "~와 동일한",
							neq: "~와 다른"
						}
					}
				},
				editable: {
				    mode : "inline",
					confirmation : "삭제하시겠습니까?"

				},
				toolbar: [
					  { name : "create", text: "행추가" , iconClass: "k-icon k-i-plus" }
					, { name : "delete", text: "행삭제" , iconClass: "k-icon k-i-minus"}
					, { name : "save"  , text: "저장"   , iconClass: "k-icon k-i-check"}
                    , { name : "cancel", text: "취소"   , iconClass: "k-icon k-i-cancel"}
				],
				dataBound : function(e) {

				}
			});

            if('${param.cid}') {
                var grid = $('#${sid}_gridbox').data("kendoGrid");
                grid.bind("dataBound", function(e){
                    grid.select("tr:eq(0)");
                });
            }

            //삭제 버튼 클릭 : DB 삭제 처리(DESTROY 연계)
            $("#${sid}_gridbox").find(".k-grid-toolbar").on("click", ".k-grid-delete", function(e) {
                e.preventDefault();
                var _grid = $("#${sid}_gridbox").data("kendoGrid");
                var selItem = _grid.dataItem(_grid.select());
                if(selItem) {
                    _grid.removeRow(_grid.select());
                } else {
                    GochigoAlert('선택항목 없음');
                }
            });

            //더블클릭 : ROW 수정모드 변경
            $("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {

                if($("#${sid}_gridbox").find(".k-grid-edit-row").length) {
                    //edit모드
                    $("#${sid}_gridbox").data("kendoGrid").cancelChanges();
					// GochigoAlert("이미 편집중인 항목이 있습니다.");
                } else {
                    var _grid = $("#${sid}_gridbox").data("kendoGrid");
                    _grid.editRow(_grid.select());
				}
            });

            //취소 클릭이벤트
            $("#${sid}_gridbox").find(".k-grid-toolbar").on("click", ".k-grid-cancel", function(e) {
                e.preventDefault();
                var _grid = $("#${sid}_gridbox").data("kendoGrid");
                _grid.cancelChanges();
            });

            <%--$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {--%>
                <%--var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");--%>
                <%--var viewParam = "";--%>
                <%--if('${param.pid}') {--%>
                    <%--viewParam += '&pid=${param.pid}';--%>
                <%--}--%>
                <%--viewParam += "&objectid="+fnObj('LIST_${sid}').objectIds;--%>
                <%--$.each(objectIdArr, function(i,o) {--%>
                    <%--var $grid = $("#${sid}_gridbox").data("kendoGrid");--%>
                    <%--var selItem = $grid.dataItem($grid.select());--%>
                    <%--if(o.indexOf(".") > 0){--%>
                        <%--o = o.substring(o.indexOf(".")+1, o.length);--%>
                    <%--}--%>

                    <%--viewParam += "&"+$.trim(o)+"="+escape(selItem[$.trim(o.toLowerCase())]);--%>
                <%--});--%>

                <%--var xPos  = (document.body.clientWidth /2) - (800 / 2);--%>
                <%--xPos += window.screenLeft;--%>
                <%--var yPos  = (screen.availHeight / 2) - (600 / 2);--%>
                <%--window.open("<c:url value='/dataView.do'/>"+"?sid=${sid}" + encodeURI(viewParam), "dataView", "top="+yPos+", left="+xPos+", width=800, height=600");--%>
            <%--});--%>

            $("#${sid}_gridbox th").on("click", function(e) {
                fnObj('LIST_${sid}').curHeader = e.currentTarget.dataset.field;
            });

        <%--    var grid = $("#${sid}_gridbox").data("kendoGrid");--%>
        <%--    grid.thead.kendoTooltip({--%>
        <%--        filter: "th",--%>
        <%--        position: "top",--%>
        <%--        content: function (e) {--%>
        <%--            var target = e.target; // the element for which the tooltip is shown--%>
        <%--            return target.text(); // set the element text as content of the tooltip--%>
        <%--        }--%>
        <%--    });--%>
        <%--},--%>

        //검색
        doSearch: function(){
            fnObj('LIST_${sid}').reloadGrid();
        },
        //그리드 reload
        reloadGrid: function(){

            //부모그리드가 0건이면 자식그리드 출력 안 함
            if("${param.pid}"){
                var pid = "${param.pid}";
                var pgrid = $("#"+pid+"_gridbox").data("kendoGrid");
                if(pgrid){
                    var rows = pgrid.items();
                    if(rows.length == 0){
                        return;
                    }
                }
            }
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
            console.log("1111111111111111111111111111111111");
            $("#${sid}_gridbox").data("kendoGrid").dataSource.transport.options.read.url = "<c:url value='/dataList.json'/>"+"?sid=${sid}&"+encodeURI(qStr);
            $("#${sid}_gridbox").data("kendoGrid").dataSource.read();

            var __params = "";
            if(typeof fnDynamicSearchCondition === "function" && fnDynamicSearchCondition() !== undefined) {
                if(__TARGET_GRID_SID) {
                    if(__TARGET_GRID_SID === '${sid}') {
                        __params = '/dataList.json?sid=${sid}&' +encodeURI(qStr) + '&'+ fnDynamicSearchCondition();
                        console.log("여기요111111111111");
                    } else {
                        __params = '/dataList.json?sid=${sid}&' +encodeURI(qStr); console.log("여기요222222");
                    }
                } else {
                    __params = '/dataList.json?sid=${sid}&' +encodeURI(qStr) + '&'+ fnDynamicSearchCondition(); console.log("여기요333");
                }
            } else {
                __params = '/dataList.json?sid=${sid}&' +encodeURI(qStr); console.log("여기요44444");
            }

            $("#${sid}_gridbox").data("kendoGrid").dataSource.transport.options.read.url = __params;

            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();

            fnObj('LIST_${sid}').fileThumbnail();

        },

        doAfterLoad: function() {
            var calLen = $('#${sid}_searchBlock .calendar').length;
            if(calLen > 0 && $('.calendar[id][data-role="datepicker"]').length == 0){
                $('#${sid}_searchBlock .calendar').kendoDatePicker({
                    format: "yyyy-MM-dd",
                    culture: "ko-KR"
                });
            }

            var selLen = $('#${sid}_searchBlock .select').length;
            if(selLen > 0){
                $('#${sid}_searchBlock .select').kendoDropDownList();
            }
        },

        // kendo grid 용 resize grid
        resizeGrid: function() {
            var gridHml = $("#${sid}_gridHml");
            var gridElement = $("#${sid}_gridbox"),
                dataArea = gridElement.find(".k-grid-content").first(),
                otherElements = gridElement.children().not(".k-grid-content"),
                otherElementsHeight = 0;
            otherElements.each(function () {
                otherElementsHeight += Math.ceil($(this).outerHeight());
            });

            var gridHmlHeight = gridHml.height();

            var winHeight = $(window).height() -22; //푸터영역 22
            var gridContentOffset = $("#${sid}_gridbox .k-grid-header").offset().top;//그리드 헤더까지 상단 offset
            var contentHeight = 0;

            contentHeight = winHeight - Math.ceil(gridContentOffset) - Math.ceil(otherElementsHeight); //그리드 데이터 영역 높이 계산
            dataArea.height(contentHeight);

            if("${param.mode}" == 'layout') {
                if(gridHmlHeight > gridContentOffset) {
                    contentHeight = gridHmlHeight - Math.ceil(gridContentOffset) - Math.ceil(otherElementsHeight) + $("#${sid}_searchBlock").offset().top;; //그리드 데이터 영역 높이 계산
                } else {
                    contentHeight = winHeight - Math.ceil(gridContentOffset) - Math.ceil(otherElementsHeight); //그리드 데이터 영역 높이 계산
                }
                dataArea.height(contentHeight-15); //하단 margin 15
            }

            if("${param.mode}" != 'layout') {
                contentHeight = winHeight - Math.ceil(gridContentOffset) - Math.ceil(otherElementsHeight); //그리드 데이터 영역 높이 계산
                dataArea.height(contentHeight - 37);
            }
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
            $.each(fileRows, function(idx, fileRow) {
                var fileTextArr = fileRow.innerText;

                if(fileTextArr) {
                    var fileText = fileTextArr.split("/");
                    var html = "";

                    for(var i = 0; i < fileText.length; i++) {
                        var fileInfo = fileText[i].split("|");
                        var fileId = fileInfo[0];
                        var fileSeq = fileInfo[1];
                        var fileName = fileInfo[2];
                        var fileExt = fileInfo[3];
                        var fileType = "txt";

                        if(fileExt == "gif" || fileExt == "png" || fileExt == "bmp" || fileExt == "jpg" || fileExt == "jpeg") { fileType = "image"; }
                        else if(fileExt=="xls"||fileExt=="xlsx"){fileType = "excel"}
                        else if(fileExt=="dox"||fileExt=="docx"){fileType = "word"}
                        else if(fileExt=="ppt"||fileExt=="pptx"){fileType = "ppt"}
                        else if(fileExt=="pdf"){fileType = "pdf"}
                        else { fileType = "txt"; }

                        if(fileType == "image") {
                            html += "<a href='/downloadDirect.json?fileName=" + encodeURI(fileName) + "'><span data-id='"+fileName+ "' title='" + encodeURI(fileName) + "' class='image-thumbnail k-icon k-i-" + fileType + "'></span></a>";
                        } else {
                            html += "<a title='" + encodeURI(fileName) + "' href='/downloadDirect.json?fileName=" + encodeURI(fileName) + "'><span class='k-icon k-i-" + fileType + "'></span></a>";
                        }

                        $(this).html(html);
                    }
                }
            });

            // $('span.image-thumbnail').kendoTooltip({
            //     //filter: "span .k-icon.k-i-image",
            //     content: kendo.template($("#template").html()),
            //     width: 200,
            //     height: 200,
            //     position: "bottom",
            //     error: function(e) {
            //         console.log("error");
            //     }
            // });
        }
    }

    function fnChildReloadGrid(pid) {
        fnObj('LIST_' + pid).onChange();
    }

    function onClick(e) {
        if ($(e.target).hasClass("k-checkbox-label")) {
            return;
        }
        var row = $(e.target).closest("tr");
        var checkbox = $(row).find(".k-checkbox");

        checkbox.click();
    };
</script>




<script id="template" type="text/x-kendo-template">
	<div class="template-wrapper">
		<div>#=target.data('id')#</div>
		<img style="width:100%;height:100%;" src="/downloadDirect.json?fileName=#=target.data('title')#" alt="#=target.data('title')#" />
	</div>
</script>

<c:if test="${param.mode!='layout'}">
	<body class="k-content">
</c:if>
<div id="${sid}_gridHml" style="width:100%;background-color: #eef2f7;display: inline-block;">
	<div id="${sid}_searchBlock">
		<div class="header_title30">
			<span class="pagetitle">${title}</span>
		</div>
		<div class="header_search">
			${searchHml}
		</div>
	</div>
	<div id="${sid}_gridbox" class="grid_box"></div>
</div>
<c:if test="${jsfileyn == 'Y'}">
	<jsp:include page="${jsfileurl}"></jsp:include>
	<%-- 	<div id="${sid}_customHtml"></div> --%>
</c:if>
<c:if test="${param.mode!='layout'}">
	<div id="${fid}_popgrid_btns" style="text-align:center; margin-top:8px;">
		<button id="${fid}_confirmBtn" class="k-button" onclick="LIST_${fid}.fnConfirm()">확인</button>
		<button id="${fid}_cancelBtn" class="k-button" onclick="LIST_${fid}.fnCancel()">취소</button>
	</div>
	</body>
	</html>
</c:if>