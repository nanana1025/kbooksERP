<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:if test="${param.mode !='layout'}">
<!DOCTYPE html>
<html>
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
    <script src="/codebase/gochigo.kendo.common.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.ui.js"></script>
    <script src="js/jquery.min.js"></script>

</c:if>
    <style>

    * {
        -webkit-user-select: text;
        -moz-user-select: text;
        -ms-user-select: text;
        user-select: text;
    }

    body
    {
        height:100%;
        margin:0;
        padding:0;
        overflow:hidden;
    }
    #${sid}_gridHml {
        height: 100%;
    }
    /* #${sid}_gridbox {
    	height: inherit;
    }
    #${sid}_btns {
        padding-right: 10px;
    }
	#${sid}_gridbox > .k-grid-content {
		height: calc(100% - 600px);
	} */
    .k-dropdown-wrap {
        padding-bottom: 1px;
    }

    .period-wrapper {
        display: inline-block;
        vertical-align: center;
    }

    .gridBtns, .grid-titl {
        display: inline-block;
    }

    #${sid}_searchDiv {
        color : #ffffff;
    }

	/* 페이저의 이동버튼이 타이틀바와 간섭하는 것 방지 */
	.k-pager-wrap .k-link, .k-pager-wrap .k-state-selected {
		z-index : 0;
	}

    .k-grid-header th.k-with-icon .k-link {
        margin-right: 0px;
        left: 0px;
        padding-right: 0px;
        padding-left: 5px;
    }


    </style>
    <script type="text/javascript">
    	var language = '${language}';
    	var cultrue = 'ko-KR';
    	if(language === 'en') {
    		cultrue = 'en-US';
    	}
    	var _listTitle = '${title}';
    	var _customKey = getCustomParameterByName('CUSTOMKEY');
    	var _customValue = getCustomParameterByName('CUSTOMVALUE');

//      	console.log("_customKey = "+_customKey);
//      	console.log("_customValue = "+_customValue);
        window['LIST_${sid}'] = {
            timeoutHnd : "",
            oid : "",
            objectIds : "${objectId}",  	  //콤마로 연결된 키 컬럼명(복수 지정 가능)
            filecolname : "${filecolname}",  //파일이 있는 경우 파일컬럼명
            flAuto : false,
            curHeader : "",
            _selItem : "",
            curRow: "",

            gridbox: function(){
            	kendo.culture(cultrue);

/* ===============   inline grid start  ==========================*/
                if("${gridInline}" == 'Y'){
                    $('#${sid}_gridbox').css("margin-top","0px");

                    var columns = JSON.parse('${columns}'.replaceAll("&bq;", "'"));
                    var commands = {
                    		attributes : { style: "text-align:center "},
                    		command: [
//                     			{ name : "add",
//                     			  text: "",
//                     			  className : "inlineButton",
//                     			  iconClass : "k-icon k-i-plus",
//                     			  click: function(e){
//                     				  this.addRow();
//                     				  $('.k-tooltip').hide();
//                     			  }
//                     			},
                    			{ name : "edit",
                    			  text: "",
                    			  className : "inlineButton",
                    			  iconClass : "k-icon k-i-edit",
                    			  click: function(e){
                    				  $('.k-tooltip').hide();
                    			  }
                    			},
                    			{ name : "destroy",
                    			  text: "",
                    			  className : "inlineButton",
                    			  iconClass : "k-icon k-i-close",
                    			  click: function(e){
                    				  $('.k-tooltip').hide();
                    			  }
                    			}
                    		],
                    		headerAttributes: {style: "vertical-align:middle;"},
                    		headerTemplate: "<div style='text-align:center;'><a role='button' class='k-button k-button-icontext k-grid-add inlineButton' onclick='javascript:fnObj(\"LIST_${sid}\").inlineAddRow();'><span class='k-icon k-i-plus'></span></a></div>",
                    		width: "6%"
                    }
                    columns.unshift(commands);

                    $.each(columns, function(idx, column){
                    	if(column.editable == "editableFalse()"){
                    		column.editable = function(e){ return false; }
                    	}
                    });


	                fnObj('LIST_${sid}').inlineSetColumn(columns);

	                var options = {
	                		dataSource: {
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
	                            serverSorting : true,
	                        },
	                        change: fnObj('LIST_${sid}').onChange,
	                        sortable: true,
	                        scrollable: true,
	                        selectable: "row",
                            resizable: true,
	                        columns:  columns,
	                        pageable: {
	                        	pageSizes: [10, 20, 30, 50],
	                            input: true,
	                            numeric: false,
	                            messages: {
	                            	display: '<spring:message code="page.display"/>',
	                            	page: '<spring:message code="page.page"/>',
	                            	of: '<spring:message code="page.of"/>',
	                            	empty : '<spring:message code="page.empty"/>',
	                            	itemsPerPage : ''
	                            }
	                        },
	                        filterable : {
	                        	extra: true,
	                        	operators: {
	                        		string: {
										startswith: '<spring:message code="startswith"/>',
										contains: '<spring:message code="contains"/>',
										eq: '<spring:message code="eq"/>',
										neq: '<spring:message code="neq"/>'
	                        		},
	                        		num: {
	                        			eq: "=",
	                        			neq: "!=",
	                        			isnull: '<spring:message code="isnull" />',
	                        			isnotnull: '<spring:message code="isnotnull" />',
	                        			gte: ">=",
	                        			lte: "<="
	                        		},
	                        		date: {
	                        			eq: "=",
	                        			gte: ">=",
	                        			lte: "<="
	                        		},
	                        		enums: {
	                        			eq: '<spring:message code="eq" />',
	                        			neq: '<spring:message code="neq" />'
	                        		}
	                        	},
	                        	messages: {
	                        		and: '<spring:message code="and" />',
	                        		clear: '<spring:message code="clear" />',
	                        		filter: '<spring:message code="filter" />',
	                        		info: '<spring:message code="info" />',
	                        		or: '<spring:message code="or" />',
	                        		selectValue: '<spring:message code="selectValue" />',
	                        	}
	                        },
	                        messages: {
	                            commands: {
	                                upload: '<spring:message code="command.upload"/>',
	                                download: '<spring:message code="command.download"/>'
	                            }
	                        },
	                        editable: {
	                            mode : "inline",
	                            confirmation : "삭제하시겠습니까?1"

	                        },
//	                         toolbar: [
//	                             { name : "create", text: '<spring:message code="toolbar.create"/>' , iconClass: "k-icon k-i-plus" }
//	                             , { name : "delete", text: '<spring:message code="toolbar.delete"/>' , iconClass: "k-icon k-i-minus"}
//	                             , { name : "save"  , text: '<spring:message code="toolbar.save"/>'   , iconClass: "k-icon k-i-check"}
//	                             , { name : "cancel", text: '<spring:message code="toolbar.cancel"/>'   , iconClass: "k-icon k-i-cancel"}
//	                         ],
	                        dataBound: function(e){
	                            if(typeof onDataBound == "function"){
	                                onDataBound();
	                            }
	                            // $("input[type='file']").kendoUpload();
	                            fnObj('LIST_${sid}').fileThumbnail();
// 	                            if(fnObj('LIST_${sid}').curRow){
//                             		fnObj('LIST_${sid}').reselectGrid();
//                             	}
	                            fnObj('LIST_${sid}').resizeGrid();

	                            <%--$("#${sid}_gridbox").kendoTooltip({--%>
	                            <%--    filter: ".k-grid-add",--%>
	                            <%--    position: "top",--%>
	                            <%--    content: "행추가"--%>
	                            <%--});--%>
	                            <%--$("#${sid}_gridbox").kendoTooltip({--%>
	                            <%--    filter: ".k-grid-edit",--%>
	                            <%--    position: "top",--%>
	                            <%--    content: "편집"--%>
	                            <%--});--%>
	                            <%--$("#${sid}_gridbox").kendoTooltip({--%>
	                            <%--    filter: ".k-grid-delete",--%>
	                            <%--    position: "top",--%>
	                            <%--    content: "삭제"--%>
	                            <%--});--%>
	                        },
	                        edit: function(e){
	                        	var updateText = $('.k-grid-update').contents();
		          				updateText[1].textContent = '';
		          				$('.k-grid-update').addClass('inlineButton');
		          				var cancelText = $('.k-grid-cancel').contents();
		          				cancelText[1].textContent = '';
		          				$('.k-grid-cancel').addClass('inlineButton');
	                        }
	                }

	                <c:if test="${kendoExtend != null && kendoExtend != ''}">
						var kendoExtend = ${kendoExtend} || {};
// 						console.log("dddddddddd1111dddddd");
	            		options = $.extend(true, options, kendoExtend);
	            	</c:if>
                    $('#${sid}_gridbox').kendoGrid(options);

                    $("#${sid}_gridbox").find(".k-grid-toolbar").on("click", ".k-grid-delete", function(e) {


                        e.preventDefault();
                        var _grid = $("#${sid}_gridbox").data("kendoGrid");
                        var selItem = _grid.dataItem(_grid.select());
                        if(selItem) {
                        	_grid.removeRow(_grid.select());
                        } else {
                        	GochigoAlert('<spring:message code="no.select.item" />');
                        }
                    });

                    //더블클릭 : ROW 수정모드 변경

                    <c:choose>
                    	<c:when test="${customSelect == null || customSelect == ''}">
	                    	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
	                            if($("#${sid}_gridbox").find(".k-grid-edit-row").length) {
	                                //edit모드

	                                $("#${sid}_gridbox").data("kendoGrid").cancelChanges();
	                                // kendo.GochigoAlert("이미 편집중인 항목이 있습니다.");
	                            } else {
	                            	var _grid = $("#${sid}_gridbox").data("kendoGrid");
	                                _grid.editRow(_grid.select());
	                            }
	                        });
                    	</c:when>
                    	<c:otherwise>
	                    	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function(){
	                    		if(typeof ${customSelect} === "function"){
	                    			${customSelect}();
	                    		}else{
	                    			GochigoAlert('<spring:message code="custom.function.warn"/>');
	                    		}

	                    	});
                    	</c:otherwise>
                    </c:choose>

                    //취소 클릭이벤트
                    $("#${sid}_gridbox").find(".k-grid-toolbar").on("click", ".k-grid-cancel", function(e) {
                        e.preventDefault();
                        var _grid = $("#${sid}_gridbox").data("kendoGrid");
                        _grid.cancelChanges();
                    });

                    var schema = $("#${sid}_gridbox").data('kendoGrid').dataSource.options.schema;
                    $("#${sid}_gridbox").data('schema', schema);

/* ===============   inline grid end  ==========================*/
                } else {

                	/* ===============   grid start  ==========================*/

                	var options = {
                			excel: {
                                allPages: true
                            },
                            excelExport: function(e) {
                           	  var columns = e.workbook.sheets[0].columns;
                           	  columns.forEach(function(column){
                           	    // also delete the width if it is set
                           	    delete column.width;
                           	    column.autoWidth = true;
                           	  });
                           	},

                            dataSource: {
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
                                serverSorting : true,
                            },
    	                    change: fnObj('LIST_${sid}').onChange,

                            sortable: true,
                            scrollable: true,
                            resizable: true,
                            persistSelection: true,
    						<c:if test="${checkbox != 'Y'}">
                            	selectable: "row",
                            </c:if>
                            columns:  JSON.parse('${columns}'.replaceAll("&bq;", "'")),
                            pageable: {
                            	pageSizes: [10, 20, 30, 50],
                                input: true,
                                numeric: false,
                                messages: {
                                	display: '<spring:message code="page.display"/>',
                                	page: '<spring:message code="page.page"/>',
                                	of: '<spring:message code="page.of"/>',
                                	empty : '<spring:message code="page.empty"/>',
                                	itemsPerPage : ''
                                }
                            },
    						<c:if test="${gridxscrollyn == 'Y'}">
    							resizable : true,
    							scrollable: true,
    	                        columnResizeHandleWidth: 5,
    						</c:if>
                            filterable : {
                            	extra: true,
                            	operators: {
                            		string: {
                            			contains: '<spring:message code="contains" />',
                            			startswith: '<spring:message code="startswith" />',
                            			eq: '<spring:message code="eq" />',
                            			neq: '<spring:message code="neq" />',
                            		},
                            		num: {
                            			eq: "=",
                            			neq: "!=",
                            			isnull: '<spring:message code="isnull" />',
                            			isnotnull: '<spring:message code="isnotnull" />',
                            			gte: ">=",
                            			lte: "<="
                            		},
                            		date: {
                            			eq: "=",
                            			gte: ">=",
                            			lte: "<="
                            		},
                            		enums: {
                            			eq: '<spring:message code="eq" />',
                            			neq: '<spring:message code="neq" />'
                            		}
                            	},
                            	messages: {
                            		and: '<spring:message code="and" />',
                            		clear: '<spring:message code="clear" />',
                            		filter: '<spring:message code="filter" />',
                            		info: '<spring:message code="info" />',
                            		or: '<spring:message code="or" />',
                            		selectValue: '<spring:message code="selectValue" />',
                            	}
                            },
                            dataBound: function(e){
                            	if(typeof onDataBound == "function"){
                                	onDataBound();
                    			}

                            	fnObj('LIST_${sid}').lockColumnResize();
                            	fnObj('LIST_${sid}').fileThumbnail();

                            	var dataType = typeof fnObj('LIST_${sid}').curRow;
                            	if(dataType == 'number'){
                            		fnObj('LIST_${sid}').reselectGrid();
                            	}
                            	fnObj('LIST_${sid}').resizeGrid();
                            }
                	}

                	<c:if test="${kendoExtend != null && kendoExtend != ''}">
						var kendoExtend = ${kendoExtend} || {};
                		options = $.extend(true, options, kendoExtend);
                	</c:if>

                	$('#${sid}_gridbox').kendoGrid(options);


                    var schema = $("#${sid}_gridbox").data('kendoGrid').dataSource.options.schema;
                    $("#${sid}_gridbox").data('schema', schema);

                    <c:choose>
                    	<c:when test = "${customSelect == null || customSelect == '' }">
                    	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
                            var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
                            var viewParam = "";
                                viewParam += '&pid=${sid}';
                            viewParam += "&objectid="+fnObj('LIST_${sid}').objectIds;
                            $.each(objectIdArr, function(i,o) {
                                var $grid = $("#${sid}_gridbox").data("kendoGrid");
                                var selItem = $grid.dataItem($grid.select());
                                if(o.indexOf(".") > 0){
                                    o = o.substring(o.indexOf(".")+1, o.length);
                                }
                                o = o.trim();
                                viewParam += "&"+$.trim(o)+"="+encodeURIComponent(selItem[$.trim(o.toLowerCase())]);
                            });

                            var xPos  = (document.body.clientWidth /2) - (800 / 2);
                            xPos += window.screenLeft;
                            var yPos  = (screen.availHeight / 2) - (600 / 2);
                            window.open("<c:url value='/dataView.do'/>"+"?xn=${xn}&sid=${sid}" + viewParam, "dataView", "top="+yPos+", left="+xPos+", width=800, height=600, scrollbars=yes, resizable=yes");
                        });
                    	</c:when>
                    <c:otherwise>
                    	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function(){
                    		if(typeof ${customSelect} === "function"){
                    			${customSelect}();
                    		}else{
                    			GochigoAlert('<spring:message code="custom.function.warn"/>');
                    		}
                    	});
                    </c:otherwise>
                    </c:choose>

                }

                if('${param.cid}') {
                	var grid = $('#${sid}_gridbox').data("kendoGrid");
                	grid.bind("dataBound", function(e){
                		if(e.sender._data.length > 0){
                		 	grid.select("tr:eq(0)");
                		} else {
                			fnObj('LIST_${sid}').onChange();
                		}
                	});
                }

                $("#${sid}_gridbox th").on("click", function(e) {
                	fnObj('LIST_${sid}').curHeader = e.currentTarget.dataset.field;
                });

                $("#${sid}_gridbox").on("click", "tr", function(e) {
                	if('${grididcol}' && "${gridInline}" != 'Y'){
                		var grid = $("#${sid}_gridbox").data("kendoGrid");
	                	var dataItem = grid.dataItem($(e.target).closest('tr'));
	                	var id = dataItem.get('${grididcol}');
	                	fnObj('LIST_${sid}').curRow = id;
                	} else{
                		if($(e.target).closest('tr').length > 0){
	                		fnObj('LIST_${sid}').curRow = $(e.target).closest('tr')[0].rowIndex;
                		}
                	}
                	if('${checkbox}' == "Y"){
                		if(e.target.className.indexOf("k-checkbox") < 0){
	                		var boxes = $('.k-checkbox');
	                		$.each(boxes, function(idx, box){
	                			if($(box).attr('aria-label') == "Select all rows"){
	                				$(this).prop('checked', false);
	                			} else{
	                				if($(box).closest('tr').is('.k-state-selected')){
		               	                $(box).click();
		               	            }
	                			}
	                		});
                			$(e.currentTarget).find('.k-checkbox').click();
                		}
                	}
                });

                <%--$("#${sid}_gridbox").kendoTooltip({--%>
                <%--    filter: "th span",--%>
                <%--    position: "top",--%>
                <%--    content: function (e) {--%>
                <%--        var target = e.target; // the element for which the tooltip is shown--%>
                <%--        var tooltip = $(target).data("tooltip");--%>
                <%--        return tooltip; // set the element text as content of the tooltip--%>
                <%--    }--%>
                <%--});--%>

                <%--$("#${sid}_gridbox").kendoTooltip({--%>
                <%--    filter: "td:not(:has(>*))", //체크박스나 파일은 제외--%>
                <%--    position: "top",--%>
                <%--    content: function (e) {--%>
                <%--        var target = e.target; // the element for which the tooltip is shown--%>
                <%--        return target.text(); // set the element text as content of the tooltip--%>
                <%--    }--%>
                <%--});--%>
            },

            inlineSetColumn: function(columns){
            	$.each(columns, function(i,column) {
            		if(column.columns){
            			fnObj('LIST_${sid}').inlineSetColumn(column.columns);
            		} else {
		            	var attr = column.attributes;
		                if(attr.class == "select"){
		                    column.editor = function(container, options){
		                        $('<input name="' + options.field + '"/>')
		                            .appendTo(container)
		                            .kendoDropDownList({
		                                autoBind: true,
		                                dataTextField: "text",
		                                dataValueField: "value",
		                                optionLabel:"Select...",
		                                dataSource: {
		                                    transport: {
		                                        read: {
		                                            url: "/gridDropdownList.json"+"?xn=${xn}&col="+options.field,
		                                            dataType: "json"
		                                        }
		                                    },
		                                    schema: {
		                                        data: "combo"
		                                    }
		                                },
										dataBound : function(e) {
		                                }
		                            });
		                    };

		                } else if(attr.class == "date"){
		                    column.format = "{0:yyyy-MM-dd}";
		                    column.editor = function(container, options){
		                        $('<input class="calendaringrid" data-text-field="' + options.field + '" data-value-field="' + options.field + '" data-bind="value:' + options.field + '" data-format="' + options.format + '"/>')
		                            .appendTo(container)
		                            .kendoDatePicker({
		                                format: "yyyy-MM-dd",
		                                culture: cultrue
		                            });
		                    };
		                } else if(attr.class == "checkbox"){
		                    column.editor = function(container, options){
		                        if (options.model[options.field] != "Y") {
		                            options.model[options.field] = null;
		                        }

		                        var guid = kendo.guid();
		                        $('<input class="checkboxingrid k-checkbox" id="' + guid + '" type="checkbox" name="'+options.field+'" data-type="boolean">').appendTo(container);
		                        $('<label class="checkboxingrid k-checkbox-label" for="' + guid + '">&#8203;</label>').appendTo(container);

		                    };
		                } else if(attr.class == "key"){
		                	column.editor = function(container, options){
		                    	if(!options.model[options.field]){
		                			var insertValue;
		                    		$.ajax({
		                                url : "/gridKeyInsertValue.json"+"?xn=${xn}&col="+options.field,
		                                success : function(data, status) {
		                                    insertValue = data.insertValue;
			                                $('<span id="' + options.field + '_show">자동생성</span>').appendTo(container);
			                                $('<input type="hidden" id="' + options.field + '" value="'+insertValue+'"/>').appendTo(container);
			                                options.model[options.field] = insertValue;
		                                },
		                                error: function(req, stat, error) {
		                                	if(req.responseJSON.message){
		            	                        GochigoAlert(req.responseJSON.message);
		                                	} else {
		            	                        GochigoAlert(req.responseText);
		                                	}
		                                }
		                            });
		                		} else {
		                			$('<span id="' + options.field + '">'+options.model[options.field]+'</span>').appendTo(container);
		                		}
		                    };
		                } else if(attr.class == "num"){
		                    column.editor = function(container, options){
		                    	var format = attr.format;
								var numFormatExp = /^n\d$/;
								var frmStr = '';
// 								console.log("야ㅕ기요!!!!");
								if(format == 'price'){
									frmStr = '###,###원';
								} else if(format == 'percent'){
									frmStr = '#.0\\%';
								} else if(format == 'date'){
									frmStr = '#일';
								} else if(format == 'week'){
									frmStr = '#주';
								} else if(format == 'month'){
									frmStr = '#월';
								} else if(format == 'year'){
									frmStr = '#년';
								} else if(format == 'seq'){
									frmStr = '#번';
								} else if(format && format.match(numFormatExp)){
									frmStr = format;
								} else {
									frmStr = '###,###';
								}
		                        $('<input class="" id="' + options.field + '" type="text" name="'+options.field+'" data-value-field="' + options.field + '" data-bind="value:' + options.field + '"/>')
		                        .appendTo(container)
		                        .kendoNumericTextBox({
		   							format : frmStr,
		   							min : attr.min,
		   							max : attr.max
		   						});
		                    };
		                } else if(attr.class == "mask"){
		                    column.editor = function(container, options){
		                        $('<input class="k-textbox" id="' + options.field + '" type="text" name="'+options.field+'" data-value-field="' + options.field + '" data-bind="value:' + options.field + '"/>')
		                        .appendTo(container)
		                        .kendoMaskedTextBox({
		   							mask : attr.mask,
		   							unmaskOnPost: true,
									change : function() {
										if(attr.maskname == 'ssn'){
											var value = this.value();
											var ssnExp = /^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-[1-4][0-9]{6}$/;
											if(!ssnExp.test(value)){
												kendo.GochigoAlert("주민등록번호 형식과 일치하지 않습니다.");
												this.value("");
											}
										} else if(attr.maskname == 'email'){
											var value = this.value();
											var emailExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
											if(!emailExp.test(value)){
												kendo.GochigoAlert("이메일 형식과 일치하지 않습니다.");
												this.value("");
											}
										}
									}
		   						});
		                    };
		                }
            		}
            	});
            },

            inlineAddRow: function() {
            	var grid = $('#${sid}_gridbox').data('kendoGrid');
            	grid.addRow();
            },

            onChange: function(args) {

//             	console.log("args:l" + args);

            	<c:choose>
	            	<c:when test="${customChange == null || customChange == ''}">
//  	            	if(args)
	            	{
		                var grid = $('#${sid}_gridbox').data('kendoGrid');
	// 	                if(grid.columns[0].selectable){
	// 	                	console.log("The selected product ids are: [" + this.selectedKeyNames().join(", ") + "]");
	// 	                }else{
		                	var cids = '${param.cid}'.split(",");
		                	var cns = '${param.cn}'.split(",");
		                    var oid = '${oid}';
		                    var ctypes = '${param.ctype}'.split(",");
		                    var cobjectids = '${cobjectids}';
		                    var caddparams = '${caddparams}';
							var addParamYn = false; //추가 파라미터 사용여부

		                    var objArr = oid.split(",");
		                    var cobjArr = cobjectids.split(";");

//  		                    console.log("cobjArr " +cobjArr);

		                    //refAreaId에서 oid가 아닌 추가 파라미터를 사용하는 경우
	                        if(caddparams.replaceAll(";","")) {
	                        	addParamYn = true;
								var paramArr = caddparams.split(";");
								objArr = []; //oid를 교체하기 위해 비운다
								cobjArr = []; //cobjectid를 교체하기 위해 비운다

								$.each(paramArr, function(idx, param){

									var objParam = param;
									if(objParam.indexOf("*") > -1){
										objParam = param.replaceAll("*","");
									}
									objArr.push(objParam); //oid를 추가파라미터의 id로 바꿈
									cobjArr.push(param); //cobjectid를 추가파라미터의 id로 바꿈
								});
							}

		                    _selItem = grid.dataItem(grid.select());
		                    var selItem = grid.dataItem(grid.select());
		                    var qParam = new Array();



		                    if(selItem){
			                    for(var i=0; i<objArr.length; i++){
			                        var objs = objArr[i].split(",");
			                        if(objs.length > 1){
				                    	for(var j=0; j<objs.length; j++){
				                        	qParam.push(selItem.get(objs[j]));
				                    	}
			                        } else {
				                    	qParam.push(selItem.get(objArr[i]));

			                        }
			                    }
		                    }else{
		                    	qParam.push(-1);
		                    }

// 		                    console.log("qParam " +qParam);


		                    $.each(cids, function(idx,cid){
			                    var pStr = qParam.join(","); //value 구분자

			                    var pStrValue = pStr.split(',')[idx];
			                    var ctype = ctypes[idx];
								var cobjectid = cobjArr[idx];
								var pStrId = cobjectid.split(',');
								var cn = cns[idx];

			                    var qStr = "";
			                    qStr += '&cobjectid=' + cobjectid;

			                    if(cid == 'price_statistics_catetory_price_list' || cid == 'price_statistics_component_catetory_price_list')	//파라미터 2개 이상 넘기는 부분
			                   	 	qStr += '&cobjectval=' + pStr;
			                    else{
			                    	if(pStrId.length > 1)
			                    		qStr += '&cobjectval=' + pStr;
			                    	else
			                    		qStr += '&cobjectval=' + pStrValue;

			                    }

			                    if(ctype == 'LIST') {
			                    	if(fnObj('LIST_'+cid) != undefined && fnObj('LIST_'+cid) != null) {

			                        	console.log("asdfasdfassd = cid = "+cid);

			                    		var customUrl = ""
		                    			if(cid == 'warehousing_product_inventory_list' || cid == 'release_product_inventory_list' )
		                    				customUrl =  "<c:url value='/dataListCustom.json'/>"+"?xn="+cn+"&"+qStr+"&sid="+cid;
	                    				else if(cid == 'release_product_list' || cid == 'warehousing_product_list')
	                    					customUrl = "<c:url value='/dataListProductCustom.json'/>"+"?xn="+cn+"&"+qStr+"&sid="+cid;
		                    			else if(cid == 'checkntb_list' || cid == 'checkallinone_list' || cid == 'checkinventory_list')
		                    				customUrl =  "<c:url value='/dataListCheck.json'/>"+"?xn="+cn+"&"+qStr+"&sid="+cid;
		                    			else if(cid == 'checkntb2nd_list' || cid == 'checkinventory2nd_list')
			                    			customUrl =  "<c:url value='/dataListCheck2nd.json'/>"+"?xn="+cn+"&"+qStr+"&sid="+cid;
			                    		else if(cid == 'componentCheck_list' || cid == 'componentCheck_list')
				                    		customUrl =  "<c:url value='/dataListCheckComponent.json'/>"+"?xn="+cn+"&"+qStr+"&sid="+cid;
		                    			else if(cid == 'price_statistics_catetory_price_list' || cid == 'price_statistics_component_catetory_price_list')
			                    			customUrl =  "<c:url value='/dataListPriceStatistics.json'/>"+"?xn="+cn+"&"+qStr+"&sid="+cid;
		                    			else if(cid == 'consigned_checkinventory_list')
			                    			customUrl =  "<c:url value='/dataListConsignedCheck.json'/>"+"?xn="+cn+"&"+qStr+"&sid="+cid;
                                        else
                                        	customUrl =  "<c:url value='/dataList.json'/>"+"?xn="+cn+"&"+qStr+"&sid="+cid;

			                    		var dataSource = {
			                                    transport: {
			                                        read: {
			                                             	url: customUrl,
															dataType: "json"
			                                        },
			                                        parameterMap: function (data, type) {
			                                        	if(data.filter){
			                                          	  //필터 시 날짜 변환
			                                          	  var filters = data.filter.filters;
			                                          	  $.each(filters, function(idx, filter){
			                    	                        	if(filter.value && typeof filter.value.getFullYear === "function"){
			                    	                        		var year = filter.value.getFullYear();
			                    	                        		var month = filter.value.getMonth()+1;
			                    	                        		if(month < 10){ month = "0"+month; }
			                    	                        		var date = filter.value.getDate();
			                    	                        		if(date < 10){ date = "0"+date; }
			                    	                        		var valStr = year+"-"+month+"-"+date;
			                    	                        		filter.value = valStr;
			                    	                        	}
			                                          	  });
			                                            	}
			                                          return data;
			                                        }
			                                    },
			                                    error : function(e) {
			                                    	console.log(e);
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
			                                    serverSorting : true,
			                                    serverFiltering: true
			                                };



			                    		var grid = $("#"+cid+"_gridbox").data("kendoGrid");
			                    		$("#"+cid+"_gridbox").data("cstr", qStr); //자식 파라미터가 있는 경우 저장해둠(list에서 꺼내서 호출)
			                            grid.setDataSource(dataSource);
		                    		}
			                    } else if(ctype == 'DATA') {
									setTimeout(function() {
										fnObj('CRUD_'+cid).initPage('/dataView.json?xn=' + cn + "&" + qStr+"&sid="+cid);
									}, 100);
		        	            } else if(ctype == 'CHART') {
		                        	if(!$("#"+cid+"_chart").data("kendoChart")){
		                        		fnObj('CHART_'+cid).fnInitChart();
		                        	}
									fnObj('CHART_'+cid).fnReloadChart(cobjectid, pStr);
		                        }
		                    });
						}
	            	</c:when>
	            	<c:otherwise>
	            	if(typeof ${customChange} === "function"){
	            		${customChange}();
	            	}else{
	            		GochigoAlert('customChange Function을 바르게 정의하십시오');
	            	}

	            	</c:otherwise>
	            </c:choose>

            },

            //검색
            doSearch: function(){
            	fnObj('LIST_${sid}').reloadGrid();
            },
            //그리드 reload
            reloadGrid: function(firstPage){


//             console.log("여기요");

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

                //자식 list인 경우 자식 파라미터를 연결해줌
                var grid = $("#${sid}_gridbox");

                var cstr = grid.data("cstr");
                                if(cstr){
                                	qStr += cstr;
                                }

                var gridData = grid.data("kendoGrid").dataSource;

                var __params = "";

                if(typeof fnDynamicSearchCondition === "function" && fnDynamicSearchCondition() !== undefined) {
                	if(__TARGET_GRID_SID) {
                		if(__TARGET_GRID_SID === '${xn}') {
                			__params = '/dataList.json?xn=${xn}&sid=${sid}' +encodeURI(qStr) + '&'+ fnDynamicSearchCondition();
                		} else {
                			__params = '/dataList.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
                		}
                	} else {
                		__params = '/dataList.json?xn=${xn}&sid=${sid}' +encodeURI(qStr) + '&'+ fnDynamicSearchCondition();
                	}
                } else {

//                  	console.log("sid = ${sid}");

                	if("${sid}" == "pricemapping_lt_cpu_list" || "${sid}" == "admin_Price_CPU_list" || "${sid}" == "admin_lt_purchase_cpu_part_list"){
        				__params = '/dataListCustomPrice.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
           			}
                	else if("${sid}" == "warehousing_product_inventory_list" || "${sid}" == "release_product_inventory_list")
        				__params = '/dataListCustom.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
       				else if("${sid}" == "release_product_list" || "${sid}" == "warehousing_product_list")
             			__params = '/dataListProductCustom.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
        			else if("${sid}" == 'checkntb_list' || "${sid}" == 'checkallinone_list' || "${sid}" == 'checkinventory_list' )
            				__params = '/dataListCheck.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
        			else if("${sid}" == 'checkntb2nd_list' || "${sid}" == 'checkinventory2nd_list')
        				__params = '/dataListCheck2nd.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
        			else if("${sid}" == 'componentCheck_list' || "${sid}" == 'componentCheck_list')
            			__params = '/dataListCheckComponent.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
        			else if("${sid}" == 'warehousing_mbd_product_inventory_list' ||"${sid}" == 'release_mbd_product_inventory_list' )
       					__params =  '/dataListCustomMBDProduct.json?xn=${xn}&sid=${sid}'+encodeURI(qStr);
     				else if("${sid}" == 'consigned_checkinventory_list')
          				__params =  '/dataListConsignedCheck.json?xn=${xn}&sid=${sid}'+encodeURI(qStr);
                    else{

//                      	console.log("encodeURI(qStr) = "+encodeURI(qStr));
                   		if(_customKey == "")
                   			__params = '/dataList.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
                   		else
                   			__params = '/dataList.json?xn=${xn}&sid=${sid}' +encodeURI(qStr)+'&CUSTOMKEY='+_customKey+'&CUSTOMVALUE='+_customValue;
                   }
                }

//                 console.log("__params =" + __params);

                var dataSource = {
                    transport: {
                        read: {
                            url: __params,
                            dataType: "json"
                        },
                        parameterMap: function (data, type) {
                        	if(data.filter){
                          	  //필터 시 날짜 변환
                          	  var filters = data.filter.filters;
                          	  $.each(filters, function(idx, filter){
    	                        	if(filter.value && typeof filter.value.getFullYear === "function"){
    	                        		var year = filter.value.getFullYear();
    	                        		var month = filter.value.getMonth()+1;
    	                        		if(month < 10){ month = "0"+month; }
    	                        		var date = filter.value.getDate();
    	                        		if(date < 10){ date = "0"+date; }
    	                        		var valStr = year+"-"+month+"-"+date;
    	                        		filter.value = valStr;
    	                        	}
                          	  });
                            	}
                          return data;
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
                    page: gridData.page(),
                    pageSize: 20,
                    serverPaging: true,
                    serverSorting : true,
                    serverFiltering: true
                };

//                 console.log("${gridInline}" == 'Y');

                if("${gridInline}" == 'Y'){
                	dataSource = {
						transport: {
							read: {
								url: __params,
								dataType: "json"
							},
							<c:choose>
								<c:when test="${customDelete == 'Y'}">
                                	destroy : ${customDelete}(options),
                                </c:when>
                                <c:otherwise>
	                                destroy : {
	                                    url : "<c:url value='/gridDataDelete.json'/>",
	                                    dataType: "json",
	                                    complete : function (jqXhr, textStatus) {

	                                        if (textStatus == 'success') {
	                                            var result = jQuery.parseJSON(jqXhr.responseText);
	                                            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
	                                        } else {
	                                            GochigoAlert('DELETE FAIL!');
	                                            return;
	                                        }
	                                    }
	                                },
								</c:otherwise>
							</c:choose>
							<c:choose>
                                <c:when test="${customUpdate == 'Y'}">
                                	update : ${customUpdate}(options),
                                </c:when>
                                <c:otherwise>
	                                update : {
	                                    url : "<c:url value='/gridDataUpdate.json'/>",
	                                    dataType: "json",
	                                    complete : function (jqXhr, textStatus) {
	                                        if (textStatus == 'success') {
	                                            var result = jQuery.parseJSON(jqXhr.responseText);
	                                            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
	                                        } else {
	                                            GochigoAlert('<spring:message code="update.fail"/>');
	                                        }
	                                    }
	                                },
                               	</c:otherwise>
							</c:choose>
							<c:choose>
                                <c:when test="${customInsert == 'Y'}">
                                	create : ${customInsert}(options),
                                </c:when>
                                <c:otherwise>
	                                create : {
	                                    url : "<c:url value='/gridDataInsert.json'/>",
	                                    dataType: "json",
	                                    complete : function (jqXhr, textStatus) {
	                                        if (textStatus == 'success') {
	                                            var result = jQuery.parseJSON(jqXhr.responseText);
	                                            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
	                                        } else {
	                                            GochigoAlert('INSERT FAIL!');
	                                        }
	                                    }
	                                },
                                </c:otherwise>
							</c:choose>
							parameterMap : function(options, operation) {
				                 if(options.filter){
				                     //필터 시 날짜 변환
				                     if(options.filter.filters[0].value && typeof options.filter.filters[0].value.getFullYear === "function"){
				                         var year = options.filter.filters[0].value.getFullYear();
				                         var month = options.filter.filters[0].value.getMonth()+1;
				                         if(month < 10){ month = "0"+month; }
				                         var date = options.filter.filters[0].value.getDate();
				                         if(date < 10){ date = "0"+date; }
				                         var valStr = year+"-"+month+"-"+date;
				                         options.filter.filters[0].value = valStr;
				                     }
								}
								if(operation == "update" || operation == "destroy") {

									var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
									var OIDS = [];
									var _model = options.models[0];

									$.each(objectIdArr, function(i,o) {
										o = o.trim();
										if(_model[o.toLowerCase()] != undefined && _model[o.toLowerCase()] != "") OIDS.push(_model[o.toLowerCase()]);
									});

									var qStr = "";
									var columns = [];
									var ccolumns = [];

									$.each(JSON.parse('${columns}'), function(i,o) {
										if(o.attributes){
											if(o.attributes.class != "date" && o.attributes.class != "checkbox" && o.attributes.class != "select" ) columns.push(o.field);
											else if(o.attributes.class == "checkbox" ) ccolumns.push(o.field);
										} else if(o.columns){
											$.each(o.columns, function(idx, column){
												if(column.attributes.class != "date" && column.attributes.class != "checkbox" && column.attributes.class != "select" ) columns.push(column.field);
												else if(column.attributes.class == "checkbox" ) ccolumns.push(column.field);
											});
										}

									});

                                        $.each(columns, function(i,o) {
                                            if(o != undefined){
                                                var lselcol = o;
                                                var paramvalue = _model[lselcol];

                                                //console.log("lselcol=" + lselcol);
                                                //console.log("paramvalue=" + paramvalue);

                                                 if(paramvalue != null && typeof paramvalue == "object") {
                                                    paramvalue = _model[lselcol].value;
                                                }
                                                if(paramvalue == null) paramvalue = "";

                                                if(paramvalue) qStr += "&"+lselcol+"="+paramvalue;

                                                if(o == "deletable" && paramvalue == "N" && operation == "destroy"){
                                           			GochigoAlert("삭제할 수 없는 항목입니다.");

                                           			return encodeURI("xn=${xn}&deletable=N");

                                            	}

                                            }
                                        });


                                        $.each(ccolumns, function(i,o) {
                                        	 console.log("o != undefined=" + o != undefined);

                                            if(o != undefined){
                                                var lselcol = o;
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
                                            qStr += "&"+vf+"="+o.value;
                                        });
                                        var selects = $('input[data-role="dropdownlist"]').find().prevObject;
                                        $.each(selects, function(i,o) {
                                            var vf = o.getAttribute("name");
                                            qStr += "&"+vf+"="+o.value;
                                        });
                                        return encodeURI("xn=${xn}"+qStr);

                                    } else if(operation == "create") {
                                        // debugger;
                                        var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
                                        var OIDS = [];
                                        var _model = options.models[0];
                                        $.each(objectIdArr, function(i,o) {
                                        	o = o.trim();
                                            if(_model[o.toLowerCase()] != undefined && _model[o.toLowerCase()] != "") OIDS.push(_model[o.toLowerCase()]);
                                        });

                                        var qStr = "";
                                        var columns = [];
                                        var ccolumns = [];

                                        $.each(JSON.parse('${columns}'), function(i,o) {
        									console.log("checkboc select");

                                        	if(o.attributes){
	                                            if(o.attributes.class != "date" && o.attributes.class != "checkbox" && o.attributes.class != "select") columns.push(o.field);
	                                            else if(o.attributes.class == "checkbox" ) ccolumns.push(o.field);
                                        	} else if(o.columns){
                                        		$.each(o.columns, function(idx, column){
                                        			if(column.attributes.class != "date" && column.attributes.class != "checkbox" && column.attributes.class != "select") columns.push(column.field);
    	                                            else if(column.attributes.class == "checkbox" ) ccolumns.push(column.field);
                                        		});
                                        	}
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

                                        var calendars = $("input.calendaringrid").find().prevObject;
                                        $.each(calendars, function(i,o) {
                                            var vf = o.getAttribute("data-value-field");
                                            qStr += "&"+vf+"="+o.value;
                                        });
                                        var selects = $('input[data-role="dropdownlist"]').find().prevObject;
                                        $.each(selects, function(i,o) {
                                            var vf = o.getAttribute("name");
                                            qStr += "&"+vf+"="+o.value;
                                        });

                                        return encodeURI("xn=${xn}"+qStr);
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
                                    fields: JSON.parse('${fields}')
                                }
                            },
                            pageSize: 20,
                            serverPaging: true,
                            serverSorting : true,
                            batch: true
                	};
                }

                var grid = $("#${sid}_gridbox").data("kendoGrid");
                if(firstPage){

                	console.log("first page")
                	grid.dataSource.page(1);
                }
				grid.setDataSource(dataSource);

// 				fnObj('LIST_${sid}').reselectGrid();

                fnObj('LIST_${sid}').fileThumbnail();


            },
            //그리드 reload
            reloadGridCustom: function(queryCustom){

//             	//부모그리드가 0건이면 자식그리드 출력 안 함
//               	console.log("여기요!!!!");

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

                if(queryCustom != null){
                	qStr += '&'+queryCustom;
                }

                //자식 list인 경우 자식 파라미터를 연결해줌
                var grid = $("#${sid}_gridbox");
                var gridData = grid.data("kendoGrid").dataSource;

                var __params = "";

                if(typeof fnDynamicSearchCondition === "function" && fnDynamicSearchCondition() !== undefined) {
                	if(__TARGET_GRID_SID) {
                		if(__TARGET_GRID_SID === '${xn}') {
                			__params = '/dataList.json?xn=${xn}&sid=${sid}' +encodeURI(qStr) + '&'+ fnDynamicSearchCondition();
                		} else {
                			__params = '/dataList.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
                		}
                	} else {
                		__params = '/dataList.json?xn=${xn}&sid=${sid}' +encodeURI(qStr) + '&'+ fnDynamicSearchCondition();
                	}
                } else {

                	if("${sid}" == "warehousing_product_inventory_list" || "${sid}" == "release_product_inventory_list")
        				__params = '/dataListCustom.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
       				else if("${sid}" == "release_product_list" ||"${sid}" == "warehousing_product_list")
           				__params = '/dataListProductCustom.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
       				else if("${sid}" == 'warehousing_mbd_product_inventory_list' ||"${sid}" == 'release_mbd_product_inventory_list' )
       					__params =  '/dataListCustomMBDProduct.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
        			else if("${sid}" == "checkntb_list" || "${sid}" == "checkallinone_list" ||  "${sid}" == "checkinventory_list")
        				__params = '/dataListCheck.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
       				else if("${sid}" == "checkntb2nd_list" ||  "${sid}" == "checkinventory2nd_list")
           				__params = '/dataListCheck2nd.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
         			else if("${sid}" == "componentCheck_list" ||  "${sid}" == "componentCheck_list")
               			__params = '/dataListCheckComponent.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
               		else if("${sid}" == "consigned_checkinventory_list")
                   		__params = '/dataListConsignedCheck.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
                   	else
                    	__params = '/dataList.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);

//                  		console.log("encodeURI(qStr = "+encodeURI(qStr));
                }

//                 console.log("__params =" + __params);

                var dataSource = {
                    transport: {
                        read: {
                            url: __params,
                            dataType: "json"
                        },
                        parameterMap: function (data, type) {
                        	if(data.filter){
                          	  //필터 시 날짜 변환
                          	  var filters = data.filter.filters;
                          	  $.each(filters, function(idx, filter){
    	                        	if(filter.value && typeof filter.value.getFullYear === "function"){
    	                        		var year = filter.value.getFullYear();
    	                        		var month = filter.value.getMonth()+1;
    	                        		if(month < 10){ month = "0"+month; }
    	                        		var date = filter.value.getDate();
    	                        		if(date < 10){ date = "0"+date; }
    	                        		var valStr = year+"-"+month+"-"+date;
    	                        		filter.value = valStr;
    	                        	}
                          	  });
                            	}
                          return data;
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
                    page: gridData.page(),
                    pageSize: 20,
                    serverPaging: true,
                    serverSorting : true,
                    serverFiltering: true
                };

//                 console.log("${gridInline}" == 'Y');

                if("${gridInline}" == 'Y'){
                	dataSource = {
						transport: {
							read: {
								url: __params,
								dataType: "json"
							},
							<c:choose>
								<c:when test="${customDelete == 'Y'}">
                                	destroy : ${customDelete}(options),
                                </c:when>
                                <c:otherwise>
	                                destroy : {
	                                    url : "<c:url value='/gridDataDelete.json'/>",
	                                    dataType: "json",
	                                    complete : function (jqXhr, textStatus) {

	                                        if (textStatus == 'success') {
	                                            var result = jQuery.parseJSON(jqXhr.responseText);
	                                            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
	                                        } else {
	                                            GochigoAlert('DELETE FAIL!');
	                                            return;
	                                        }
	                                    }
	                                },
								</c:otherwise>
							</c:choose>
							<c:choose>
                                <c:when test="${customUpdate == 'Y'}">
                                	update : ${customUpdate}(options),
                                </c:when>
                                <c:otherwise>
	                                update : {
	                                    url : "<c:url value='/gridDataUpdate.json'/>",
	                                    dataType: "json",
	                                    complete : function (jqXhr, textStatus) {
	                                        if (textStatus == 'success') {
	                                            var result = jQuery.parseJSON(jqXhr.responseText);
	                                            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
	                                        } else {
	                                            GochigoAlert('<spring:message code="update.fail"/>');
	                                        }
	                                    }
	                                },
                               	</c:otherwise>
							</c:choose>
							<c:choose>
                                <c:when test="${customInsert == 'Y'}">
                                	create : ${customInsert}(options),
                                </c:when>
                                <c:otherwise>
	                                create : {
	                                    url : "<c:url value='/gridDataInsert.json'/>",
	                                    dataType: "json",
	                                    complete : function (jqXhr, textStatus) {
	                                        if (textStatus == 'success') {
	                                            var result = jQuery.parseJSON(jqXhr.responseText);
	                                            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
	                                        } else {
	                                            GochigoAlert('INSERT FAIL!');
	                                        }
	                                    }
	                                },
                                </c:otherwise>
							</c:choose>
							parameterMap : function(options, operation) {
				                 if(options.filter){
				                     //필터 시 날짜 변환
				                     if(options.filter.filters[0].value && typeof options.filter.filters[0].value.getFullYear === "function"){
				                         var year = options.filter.filters[0].value.getFullYear();
				                         var month = options.filter.filters[0].value.getMonth()+1;
				                         if(month < 10){ month = "0"+month; }
				                         var date = options.filter.filters[0].value.getDate();
				                         if(date < 10){ date = "0"+date; }
				                         var valStr = year+"-"+month+"-"+date;
				                         options.filter.filters[0].value = valStr;
				                     }
								}
								if(operation == "update" || operation == "destroy") {

									var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
									var OIDS = [];
									var _model = options.models[0];

									$.each(objectIdArr, function(i,o) {
										o = o.trim();
										if(_model[o.toLowerCase()] != undefined && _model[o.toLowerCase()] != "") OIDS.push(_model[o.toLowerCase()]);
									});

									var qStr = "";
									var columns = [];
									var ccolumns = [];

									$.each(JSON.parse('${columns}'), function(i,o) {
										if(o.attributes){
											if(o.attributes.class != "date" && o.attributes.class != "checkbox" && o.attributes.class != "select" ) columns.push(o.field);
											else if(o.attributes.class == "checkbox" ) ccolumns.push(o.field);
										} else if(o.columns){
											$.each(o.columns, function(idx, column){
												if(column.attributes.class != "date" && column.attributes.class != "checkbox" && column.attributes.class != "select" ) columns.push(column.field);
												else if(column.attributes.class == "checkbox" ) ccolumns.push(column.field);
											});
										}

									});

                                        $.each(columns, function(i,o) {
                                            if(o != undefined){
                                                var lselcol = o;
                                                var paramvalue = _model[lselcol];

                                                //console.log("lselcol=" + lselcol);
                                                //console.log("paramvalue=" + paramvalue);

                                                 if(paramvalue != null && typeof paramvalue == "object") {
                                                    paramvalue = _model[lselcol].value;
                                                }
                                                if(paramvalue == null) paramvalue = "";

                                                if(paramvalue) qStr += "&"+lselcol+"="+paramvalue;

                                                if(o == "deletable" && paramvalue == "N" && operation == "destroy"){
                                           			GochigoAlert("삭제할 수 없는 항목입니다.");

                                           			return encodeURI("xn=${xn}&deletable=N");

                                            	}

                                            }
                                        });


                                        $.each(ccolumns, function(i,o) {
                                        	 console.log("o != undefined=" + o != undefined);

                                            if(o != undefined){
                                                var lselcol = o;
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
                                            qStr += "&"+vf+"="+o.value;
                                        });
                                        var selects = $('input[data-role="dropdownlist"]').find().prevObject;
                                        $.each(selects, function(i,o) {
                                            var vf = o.getAttribute("name");
                                            qStr += "&"+vf+"="+o.value;
                                        });
                                        return encodeURI("xn=${xn}"+qStr);

                                    } else if(operation == "create") {
                                        // debugger;
                                        var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
                                        var OIDS = [];
                                        var _model = options.models[0];
                                        $.each(objectIdArr, function(i,o) {
                                        	o = o.trim();
                                            if(_model[o.toLowerCase()] != undefined && _model[o.toLowerCase()] != "") OIDS.push(_model[o.toLowerCase()]);
                                        });

                                        var qStr = "";
                                        var columns = [];
                                        var ccolumns = [];

                                        $.each(JSON.parse('${columns}'), function(i,o) {
                                        	if(o.attributes){
	                                            if(o.attributes.class != "date" && o.attributes.class != "checkbox" && o.attributes.class != "select") columns.push(o.field);
	                                            else if(o.attributes.class == "checkbox" ) ccolumns.push(o.field);
                                        	} else if(o.columns){
                                        		$.each(o.columns, function(idx, column){
                                        			if(column.attributes.class != "date" && column.attributes.class != "checkbox" && column.attributes.class != "select") columns.push(column.field);
    	                                            else if(column.attributes.class == "checkbox" ) ccolumns.push(column.field);
                                        		});
                                        	}
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

                                        var calendars = $("input.calendaringrid").find().prevObject;
                                        $.each(calendars, function(i,o) {
                                            var vf = o.getAttribute("data-value-field");
                                            qStr += "&"+vf+"="+o.value;
                                        });
                                        var selects = $('input[data-role="dropdownlist"]').find().prevObject;
                                        $.each(selects, function(i,o) {
                                            var vf = o.getAttribute("name");
                                            qStr += "&"+vf+"="+o.value;
                                        });

                                        return encodeURI("xn=${xn}"+qStr);
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
                                    fields: JSON.parse('${fields}')
                                }
                            },
                            pageSize: 20,
                            serverPaging: true,
                            serverSorting : true,
                            batch: true
                	};
                }

                var grid = $("#${sid}_gridbox").data("kendoGrid");
				grid.setDataSource(dataSource);

                fnObj('LIST_${sid}').fileThumbnail();


            },
            reloadGridCustomPrice: function(queryCustom){

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

                if(queryCustom != null){
                	qStr += '&'+queryCustom;
                }

                //자식 list인 경우 자식 파라미터를 연결해줌
                var grid = $("#${sid}_gridbox");
                var gridData = grid.data("kendoGrid").dataSource;

                var __params = "";

                if(typeof fnDynamicSearchCondition === "function" && fnDynamicSearchCondition() !== undefined) {
                	if(__TARGET_GRID_SID) {
                		if(__TARGET_GRID_SID === '${xn}') {
                			__params = '/customDataListPrice.json?xn=${xn}&sid=${sid}' +encodeURI(qStr) + '&'+ fnDynamicSearchCondition();
                		} else {
                			__params = '/customDataListPrice.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
                		}
                	} else {
                		__params = '/customDataListPrice.json?xn=${xn}&sid=${sid}' +encodeURI(qStr) + '&'+ fnDynamicSearchCondition();
                	}
                } else {
                    	__params = '/customDataListPrice.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
                }

                var dataSource = {
                    transport: {
                        read: {
                            url: __params,
                            dataType: "json"
                        },
                        parameterMap: function (data, type) {
                        	if(data.filter){
                          	  //필터 시 날짜 변환
                          	  var filters = data.filter.filters;
                          	  $.each(filters, function(idx, filter){
    	                        	if(filter.value && typeof filter.value.getFullYear === "function"){
    	                        		var year = filter.value.getFullYear();
    	                        		var month = filter.value.getMonth()+1;
    	                        		if(month < 10){ month = "0"+month; }
    	                        		var date = filter.value.getDate();
    	                        		if(date < 10){ date = "0"+date; }
    	                        		var valStr = year+"-"+month+"-"+date;
    	                        		filter.value = valStr;
    	                        	}
                          	  });
                            	}
                          return data;
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
                    page: gridData.page(),
                    pageSize: 20,
                    serverPaging: true,
                    serverSorting : true,
                    serverFiltering: true
                };

//                 console.log("${gridInline}" == 'Y');

                if("${gridInline}" == 'Y'){
                	dataSource = {
						transport: {
							read: {
								url: __params,
								dataType: "json"
							},
							<c:choose>
								<c:when test="${customDelete == 'Y'}">
                                	destroy : ${customDelete}(options),
                                </c:when>
                                <c:otherwise>
	                                destroy : {
	                                    url : "<c:url value='/gridDataDelete.json'/>",
	                                    dataType: "json",
	                                    complete : function (jqXhr, textStatus) {

	                                        if (textStatus == 'success') {
	                                            var result = jQuery.parseJSON(jqXhr.responseText);
	                                            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
	                                        } else {
	                                            GochigoAlert('DELETE FAIL!');
	                                            return;
	                                        }
	                                    }
	                                },
								</c:otherwise>
							</c:choose>
							<c:choose>
                                <c:when test="${customUpdate == 'Y'}">
                                	update : ${customUpdate}(options),
                                </c:when>
                                <c:otherwise>
	                                update : {
	                                    url : "<c:url value='/gridDataUpdate.json'/>",
	                                    dataType: "json",
	                                    complete : function (jqXhr, textStatus) {
	                                        if (textStatus == 'success') {
	                                            var result = jQuery.parseJSON(jqXhr.responseText);
	                                            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
	                                        } else {
	                                            GochigoAlert('<spring:message code="update.fail"/>');
	                                        }
	                                    }
	                                },
                               	</c:otherwise>
							</c:choose>
							<c:choose>
                                <c:when test="${customInsert == 'Y'}">
                                	create : ${customInsert}(options),
                                </c:when>
                                <c:otherwise>
	                                create : {
	                                    url : "<c:url value='/gridDataInsert.json'/>",
	                                    dataType: "json",
	                                    complete : function (jqXhr, textStatus) {
	                                        if (textStatus == 'success') {
	                                            var result = jQuery.parseJSON(jqXhr.responseText);
	                                            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
	                                        } else {
	                                            GochigoAlert('INSERT FAIL!');
	                                        }
	                                    }
	                                },
                                </c:otherwise>
							</c:choose>
							parameterMap : function(options, operation) {
				                 if(options.filter){
				                     //필터 시 날짜 변환
				                     if(options.filter.filters[0].value && typeof options.filter.filters[0].value.getFullYear === "function"){
				                         var year = options.filter.filters[0].value.getFullYear();
				                         var month = options.filter.filters[0].value.getMonth()+1;
				                         if(month < 10){ month = "0"+month; }
				                         var date = options.filter.filters[0].value.getDate();
				                         if(date < 10){ date = "0"+date; }
				                         var valStr = year+"-"+month+"-"+date;
				                         options.filter.filters[0].value = valStr;
				                     }
								}
								if(operation == "update" || operation == "destroy") {

									var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
									var OIDS = [];
									var _model = options.models[0];

									$.each(objectIdArr, function(i,o) {
										o = o.trim();
										if(_model[o.toLowerCase()] != undefined && _model[o.toLowerCase()] != "") OIDS.push(_model[o.toLowerCase()]);
									});

									var qStr = "";
									var columns = [];
									var ccolumns = [];

									$.each(JSON.parse('${columns}'), function(i,o) {

										if(o.attributes){
											if(o.attributes.class != "date" && o.attributes.class != "checkbox" && o.attributes.class != "select" ) columns.push(o.field);
											else if(o.attributes.class == "checkbox" ) ccolumns.push(o.field);
										} else if(o.columns){
											$.each(o.columns, function(idx, column){
												if(column.attributes.class != "date" && column.attributes.class != "checkbox" && column.attributes.class != "select" ) columns.push(column.field);
												else if(column.attributes.class == "checkbox" ) ccolumns.push(column.field);
											});
										}

									});

                                        $.each(columns, function(i,o) {
                                            if(o != undefined){
                                                var lselcol = o;
                                                var paramvalue = _model[lselcol];

                                                //console.log("lselcol=" + lselcol);
                                                //console.log("paramvalue=" + paramvalue);

                                                 if(paramvalue != null && typeof paramvalue == "object") {
                                                    paramvalue = _model[lselcol].value;
                                                }
                                                if(paramvalue == null) paramvalue = "";

                                                if(paramvalue) qStr += "&"+lselcol+"="+paramvalue;

                                                if(o == "deletable" && paramvalue == "N" && operation == "destroy"){
                                           			GochigoAlert("삭제할 수 없는 항목입니다.");

                                           			return encodeURI("xn=${xn}&deletable=N");

                                            	}

                                            }
                                        });


                                        $.each(ccolumns, function(i,o) {
                                        	 console.log("o != undefined=" + o != undefined);

                                            if(o != undefined){
                                                var lselcol = o;
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
                                            qStr += "&"+vf+"="+o.value;
                                        });
                                        var selects = $('input[data-role="dropdownlist"]').find().prevObject;
                                        $.each(selects, function(i,o) {
                                            var vf = o.getAttribute("name");
                                            qStr += "&"+vf+"="+o.value;
                                        });
                                        return encodeURI("xn=${xn}"+qStr);

                                    } else if(operation == "create") {
                                        // debugger;
                                        var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
                                        var OIDS = [];
                                        var _model = options.models[0];
                                        $.each(objectIdArr, function(i,o) {
                                        	o = o.trim();
                                            if(_model[o.toLowerCase()] != undefined && _model[o.toLowerCase()] != "") OIDS.push(_model[o.toLowerCase()]);
                                        });

                                        var qStr = "";
                                        var columns = [];
                                        var ccolumns = [];

                                        $.each(JSON.parse('${columns}'), function(i,o) {
                                        	if(o.attributes){
	                                            if(o.attributes.class != "date" && o.attributes.class != "checkbox" && o.attributes.class != "select") columns.push(o.field);
	                                            else if(o.attributes.class == "checkbox" ) ccolumns.push(o.field);
                                        	} else if(o.columns){
                                        		$.each(o.columns, function(idx, column){
                                        			if(column.attributes.class != "date" && column.attributes.class != "checkbox" && column.attributes.class != "select") columns.push(column.field);
    	                                            else if(column.attributes.class == "checkbox" ) ccolumns.push(column.field);
                                        		});
                                        	}
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

                                        var calendars = $("input.calendaringrid").find().prevObject;
                                        $.each(calendars, function(i,o) {
                                            var vf = o.getAttribute("data-value-field");
                                            qStr += "&"+vf+"="+o.value;
                                        });
                                        var selects = $('input[data-role="dropdownlist"]').find().prevObject;
                                        $.each(selects, function(i,o) {
                                            var vf = o.getAttribute("name");
                                            qStr += "&"+vf+"="+o.value;
                                        });

                                        return encodeURI("xn=${xn}"+qStr);
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
                                    fields: JSON.parse('${fields}')
                                }
                            },
                            pageSize: 20,
                            serverPaging: true,
                            serverSorting : true,
                            batch: true
                	};
                }

                var grid = $("#${sid}_gridbox").data("kendoGrid");
				grid.setDataSource(dataSource);

                fnObj('LIST_${sid}').fileThumbnail();


            },
            reloadGridCustomConsigned: function(queryCustom){

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

                if(queryCustom != null){
                	qStr += '&'+queryCustom;
                }

                //자식 list인 경우 자식 파라미터를 연결해줌
                var grid = $("#${sid}_gridbox");
                var gridData = grid.data("kendoGrid").dataSource;

                var __params = "";

                if(typeof fnDynamicSearchCondition === "function" && fnDynamicSearchCondition() !== undefined) {
                	if(__TARGET_GRID_SID) {
                		if(__TARGET_GRID_SID === '${xn}') {
                			__params = '/customDataListConsigned.json?xn=${xn}&sid=${sid}' +encodeURI(qStr) + '&'+ fnDynamicSearchCondition();
                		} else {
                			__params = '/customDataListConsigned.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
                		}
                	} else {
                		__params = '/customDataListConsigned.json?xn=${xn}&sid=${sid}' +encodeURI(qStr) + '&'+ fnDynamicSearchCondition();
                	}
                } else {
                    	__params = '/customDataListConsigned.json?xn=${xn}&sid=${sid}' +encodeURI(qStr);
                }

                var dataSource = {
                    transport: {
                        read: {
                            url: __params,
                            dataType: "json"
                        },
                        parameterMap: function (data, type) {
                        	if(data.filter){
                          	  //필터 시 날짜 변환
                          	  var filters = data.filter.filters;
                          	  $.each(filters, function(idx, filter){
    	                        	if(filter.value && typeof filter.value.getFullYear === "function"){
    	                        		var year = filter.value.getFullYear();
    	                        		var month = filter.value.getMonth()+1;
    	                        		if(month < 10){ month = "0"+month; }
    	                        		var date = filter.value.getDate();
    	                        		if(date < 10){ date = "0"+date; }
    	                        		var valStr = year+"-"+month+"-"+date;
    	                        		filter.value = valStr;
    	                        	}
                          	  });
                            	}
                          return data;
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
                    page: gridData.page(),
                    pageSize: 20,
                    serverPaging: true,
                    serverSorting : true,
                    serverFiltering: true
                };

//                 console.log("${gridInline}" == 'Y');

                if("${gridInline}" == 'Y'){
                	dataSource = {
						transport: {
							read: {
								url: __params,
								dataType: "json"
							},
							<c:choose>
								<c:when test="${customDelete == 'Y'}">
                                	destroy : ${customDelete}(options),
                                </c:when>
                                <c:otherwise>
	                                destroy : {
	                                    url : "<c:url value='/gridDataDelete.json'/>",
	                                    dataType: "json",
	                                    complete : function (jqXhr, textStatus) {

	                                        if (textStatus == 'success') {
	                                            var result = jQuery.parseJSON(jqXhr.responseText);
	                                            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
	                                        } else {
	                                            GochigoAlert('DELETE FAIL!');
	                                            return;
	                                        }
	                                    }
	                                },
								</c:otherwise>
							</c:choose>
							<c:choose>
                                <c:when test="${customUpdate == 'Y'}">
                                	update : ${customUpdate}(options),
                                </c:when>
                                <c:otherwise>
	                                update : {
	                                    url : "<c:url value='/gridDataUpdate.json'/>",
	                                    dataType: "json",
	                                    complete : function (jqXhr, textStatus) {
	                                        if (textStatus == 'success') {
	                                            var result = jQuery.parseJSON(jqXhr.responseText);
	                                            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
	                                        } else {
	                                            GochigoAlert('<spring:message code="update.fail"/>');
	                                        }
	                                    }
	                                },
                               	</c:otherwise>
							</c:choose>
							<c:choose>
                                <c:when test="${customInsert == 'Y'}">
                                	create : ${customInsert}(options),
                                </c:when>
                                <c:otherwise>
	                                create : {
	                                    url : "<c:url value='/gridDataInsert.json'/>",
	                                    dataType: "json",
	                                    complete : function (jqXhr, textStatus) {
	                                        if (textStatus == 'success') {
	                                            var result = jQuery.parseJSON(jqXhr.responseText);
	                                            $("#${sid}_gridbox").data("kendoGrid").dataSource.fetch();
	                                        } else {
	                                            GochigoAlert('INSERT FAIL!');
	                                        }
	                                    }
	                                },
                                </c:otherwise>
							</c:choose>
							parameterMap : function(options, operation) {
				                 if(options.filter){
				                     //필터 시 날짜 변환
				                     if(options.filter.filters[0].value && typeof options.filter.filters[0].value.getFullYear === "function"){
				                         var year = options.filter.filters[0].value.getFullYear();
				                         var month = options.filter.filters[0].value.getMonth()+1;
				                         if(month < 10){ month = "0"+month; }
				                         var date = options.filter.filters[0].value.getDate();
				                         if(date < 10){ date = "0"+date; }
				                         var valStr = year+"-"+month+"-"+date;
				                         options.filter.filters[0].value = valStr;
				                     }
								}
								if(operation == "update" || operation == "destroy") {

									var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
									var OIDS = [];
									var _model = options.models[0];

									$.each(objectIdArr, function(i,o) {
										o = o.trim();
										if(_model[o.toLowerCase()] != undefined && _model[o.toLowerCase()] != "") OIDS.push(_model[o.toLowerCase()]);
									});

									var qStr = "";
									var columns = [];
									var ccolumns = [];

									$.each(JSON.parse('${columns}'), function(i,o) {

										if(o.attributes){
											if(o.attributes.class != "date" && o.attributes.class != "checkbox" && o.attributes.class != "select" ) columns.push(o.field);
											else if(o.attributes.class == "checkbox" ) ccolumns.push(o.field);
										} else if(o.columns){
											$.each(o.columns, function(idx, column){
												if(column.attributes.class != "date" && column.attributes.class != "checkbox" && column.attributes.class != "select" ) columns.push(column.field);
												else if(column.attributes.class == "checkbox" ) ccolumns.push(column.field);
											});
										}

									});

                                        $.each(columns, function(i,o) {
                                            if(o != undefined){
                                                var lselcol = o;
                                                var paramvalue = _model[lselcol];

                                                //console.log("lselcol=" + lselcol);
                                                //console.log("paramvalue=" + paramvalue);

                                                 if(paramvalue != null && typeof paramvalue == "object") {
                                                    paramvalue = _model[lselcol].value;
                                                }
                                                if(paramvalue == null) paramvalue = "";

                                                if(paramvalue) qStr += "&"+lselcol+"="+paramvalue;

                                                if(o == "deletable" && paramvalue == "N" && operation == "destroy"){
                                           			GochigoAlert("삭제할 수 없는 항목입니다.");

                                           			return encodeURI("xn=${xn}&deletable=N");

                                            	}

                                            }
                                        });


                                        $.each(ccolumns, function(i,o) {
                                        	 console.log("o != undefined=" + o != undefined);

                                            if(o != undefined){
                                                var lselcol = o;
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
                                            qStr += "&"+vf+"="+o.value;
                                        });
                                        var selects = $('input[data-role="dropdownlist"]').find().prevObject;
                                        $.each(selects, function(i,o) {
                                            var vf = o.getAttribute("name");
                                            qStr += "&"+vf+"="+o.value;
                                        });
                                        return encodeURI("xn=${xn}"+qStr);

                                    } else if(operation == "create") {
                                        // debugger;
                                        var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
                                        var OIDS = [];
                                        var _model = options.models[0];
                                        $.each(objectIdArr, function(i,o) {
                                        	o = o.trim();
                                            if(_model[o.toLowerCase()] != undefined && _model[o.toLowerCase()] != "") OIDS.push(_model[o.toLowerCase()]);
                                        });

                                        var qStr = "";
                                        var columns = [];
                                        var ccolumns = [];

                                        $.each(JSON.parse('${columns}'), function(i,o) {
                                        	if(o.attributes){
	                                            if(o.attributes.class != "date" && o.attributes.class != "checkbox" && o.attributes.class != "select") columns.push(o.field);
	                                            else if(o.attributes.class == "checkbox" ) ccolumns.push(o.field);
                                        	} else if(o.columns){
                                        		$.each(o.columns, function(idx, column){
                                        			if(column.attributes.class != "date" && column.attributes.class != "checkbox" && column.attributes.class != "select") columns.push(column.field);
    	                                            else if(column.attributes.class == "checkbox" ) ccolumns.push(column.field);
                                        		});
                                        	}
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

                                        var calendars = $("input.calendaringrid").find().prevObject;
                                        $.each(calendars, function(i,o) {
                                            var vf = o.getAttribute("data-value-field");
                                            qStr += "&"+vf+"="+o.value;
                                        });
                                        var selects = $('input[data-role="dropdownlist"]').find().prevObject;
                                        $.each(selects, function(i,o) {
                                            var vf = o.getAttribute("name");
                                            qStr += "&"+vf+"="+o.value;
                                        });

                                        return encodeURI("xn=${xn}"+qStr);
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
                                    fields: JSON.parse('${fields}')
                                }
                            },
                            pageSize: 20,
                            serverPaging: true,
                            serverSorting : true,
                            batch: true
                	};
                }

                var grid = $("#${sid}_gridbox").data("kendoGrid");
				grid.setDataSource(dataSource);

                fnObj('LIST_${sid}').fileThumbnail();


            },
            reload: function() {
            	var pid = $('#pid').val();
            	if(opener == null) {
					if(pid) {
						if(pid.indexOf('TREE') > -1) {
							var sessionText = sessionStorage.getItem('treeTextCol');
							var selectedItem = grid.dataItem(grid.select());
							var text = selectedItem[sessionText];
							fnObj('TREE_'+pid).reloadTree(text);
						} else if(pid.indexOf('LIST') > -1) {
							// fnObj('LIST_'+pid).reloadGrid();
                            // fnObj('LIST_'+pid).refresh();
                            fnObj('LIST_'+pid).dataSource.read();
						}
					} else {

					}

				} else {

				}
            },
            //검색조건 키인 시 자동 검색
            <%--enableAutosubmit: function(state){--%>
            <%--LIST_${sid}.flAuto = state;--%>
            <%--document.getElementById("submitButton").disabled = state--%>
            <%--},--%>

            onClickInsert: function() {
            	var pid = '${pid}';
            	var ptype = '${ptype}';
            	var grid = $('#'+pid+'_gridbox').data('kendoGrid');
                var oid = '${objectId}';
                var queryString = "";

                if(pid && ptype == 'LIST'){
	                var objArr = oid.split(",");
	                var selItem = grid.dataItem(grid.select());
	                if(selItem){
		                var qParam = new Array();
		                for(var i = 0; i < objArr.length; i++){
		                    qParam.push(selItem.get(objArr[i]));
		                }

		                var pStr = qParam.join(","); //value 구분자

		                queryString += '&pid=${pid}';
		                queryString += '&pobjectid=' + oid;
		                queryString += '&pobjval=' + pStr;
	                }
                }

                if(pid && ptype == 'TREE'){
                	queryString += '&pid=${pid}';
                	var treeview = $("#${pid}_tree").data("kendoTreeView");
                	var data = treeview.dataItem(treeview.select());
                	var pobjectids = '${pobjectids}'.split(",");
                	var pobjval = "";
                	$.each(pobjectids, function(idx, pobjectid){
                		pobjval += data.get(pobjectid);
                	});

                	queryString += '&pobjectid='+pobjectids+'&pobjval='+pobjval;
                }

                var xPos  = (document.body.clientWidth /2) - (800 / 2);
                xPos += window.screenLeft;
                var yPos  = (screen.availHeight / 2) - (600 / 2);
                window.open("<c:url value='/dataEdit.do'/>"+"?xn=${xn}&sid=${sid}"+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width=800, height=600, scrollbars=1");
            },

            onClickDelete: function() {
            	var pid = '${pid}';
            	var ptype = '${ptype}';
            	var grid = $('#${sid}_gridbox').data('kendoGrid');
                var selectedItem = grid.dataItem(grid.select());
                if(!selectedItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

                var content = "삭제하시겠습니까?";

        		$("<div></div>").kendoConfirm({
        			buttonLayout: "stretched",
        			actions: [{
        				text: '확인',
        				action: function(e){
				                var objectIdArr = fnObj('LIST_${sid}').objectIds.split(",");
				                var OIDS = [];
				                $.each(objectIdArr, function(i,o) {
				                	if(o.indexOf(".") > 0){
				                		o = o.substring(o.indexOf(".")+1, o.length);
				                	}

				                    var selItem = grid.dataItem(grid.select());
// 				                    console.log(selItem);
				                    o = o.trim();
				                    if(selItem) OIDS.push(selItem[o.toLowerCase()]);
// 				                    console.log(OIDS);
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
				                    url : "<c:url value='"+url+"'/>"+"?xn=${xn}&sid=${sid}&"+encodeURI(delParam),
				                    success : function(data, status) {
				                        if(status === 'success') {
				                            GochigoAlert('<spring:message code="delete.success" />');
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
				                    	if(req.responseJSON.message){
					                        GochigoAlert(req.responseJSON.message);
				                    	} else {
					                        GochigoAlert(req.responseText);
				                    	}

				                    }
				                });
        				}
        			},
        			{
        				text: '닫기'
        			}],
        			minWidth : 200,
        			title: fnGetSystemName(),
        		    content: "삭제하시겠습니까?"
        		}).data("kendoConfirm").open();
            },

            doAfterLoad: function() {
                var calLen = $('#${sid}_searchBlock .calendar').length;
                if(calLen > 0 && $('#${sid}_searchBlock .calendar[id][data-role="datepicker"]').length == 0){
                    $('#${sid}_searchBlock .calendar').kendoDatePicker({
                        format: "yyyy-MM-dd",
                        culture: cultrue
                    });
                }

                var selLen = $('#${sid}_searchBlock .select').length;
                if(selLen > 0){
                    $('#${sid}_searchBlock .select').kendoDropDownList();
                }

                if('${isDevMode}' == 'Y' && '${desc}'){
                	var html = "<button id='${sid}_descBtn' type='button' style='z-index:3000;' class='k-button' onclick='fnObj(\"LIST_${sid}\").openDesc();'>화면설명</button>";
                	$('#${sid}_header_title').append(html);
                }
            },

            openDesc: function() {
            	var desc = '${desc}';
            	var window = $('<div></div>')
            	.append(desc);

            	window.kendoWindow({
                    width: "600px",
                    title: "화면 설명",
                    visible: false,
                    actions: [
                        "Minimize",
                        "Maximize",
                        "Close"
                    ],
                    open: function() {
                    	$('#${sid}_descBtn').hide();
                    },
                    close: function(){
                    	$('#${sid}_descBtn').show();
                    }
                }).data("kendoWindow").center().open();
            },

            // kendo grid 용 resize grid
            resizeGrid: function() {
            	var adjustHeight = 0; // 보정치 (브라우저 보정치였는데, 일단 ie11 크롬에서는 보정치 필요없음)

            	// 전체크기 계산
            	var gridHml = $("#${sid}_gridHml");
            	var gridHmlHeight = gridHml.height();

            	// list 의 userHteml 영역 크기 계산
            	var buttonAreaHeight = $('#${sid}_gridHml').find('.grid_btns:visible').outerHeight(false);
            	var bottomAreaHeight = $(".${sid}_bottomline").outerHeight(false); // userHtml 에서 bottom 이 있는 경우
            	var titleAreaHeight = $('#${sid}_searchBlock').find('.header_title30').height();

            	// caption 영역의 margin 과 title 영역은 겹침
            	var captionAreaOuterHeight = $(".${sid}_topline").outerHeight(true);
            	var captionAreaHeight = $(".${sid}_topline").outerHeight(false);
            	var captionAreaMarginHeight = captionAreaOuterHeight - captionAreaHeight;

            	// caption 영역의 크기 보정
            	if (captionAreaMarginHeight >= titleAreaHeight) {
            		// 마진영역보다 타이틀영역이 작을 경우에는 남는 만큼을 caption 영역에 추가
            		captionAreaHeight += (captionAreaMarginHeight - titleAreaHeight);
            	}
            	else {
            		// 마진영역보다 타이틀영역이 클 경우에는 넘친 caption 영역만큼을 제외
            		var captionAreaContentHeight = $(".${sid}_topline").height();
            		var captionAreaPaddingTopHeight = (captionAreaHeight - captionAreaContentHeight / 2);
            		captionAreaHeight -= captionAreaPaddingTopHeight;
            	}

            	var gridElement = $("#${sid}_gridbox");

            	// gridBox의 header 와 pager 영역 높이 계산
            	var gridHeaderHeight = gridElement.find(".k-grid-header").outerHeight(false);
            	var gridPagerHeight = gridElement.find(".k-grid-pager").outerHeight(false);

				// gridBox 의 높이 계산 및 설정
            	var gridboxHeight = gridHmlHeight - (titleAreaHeight+captionAreaHeight+buttonAreaHeight+bottomAreaHeight) - 2;  /* 그리드 위아래 보더1 */

            	// gridBox 의 크기가 지나치게 작을 때에는 업데이트하지 않음
            	if (gridboxHeight < (gridHeaderHeight*2 + gridPagerHeight)) {
            		gridboxHeight = gridHeaderHeight*2 + gridPagerHeight;
            	}
           		gridElement.height(gridboxHeight-adjustHeight);

               	// gridContent 의 높이 설정
               	var contentHeight = gridboxHeight - (gridHeaderHeight+gridPagerHeight);
               	var dataArea = gridElement.find(".k-grid-content").first();
               	dataArea.height(contentHeight-adjustHeight);


//             	console.log("gridboxHeight:{0}, contentHeight:{1}".format(gridboxHeight, gridboxHeight - (gridHeaderHeight+gridPagerHeight)));
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
	           					html += "<a href='/downloadDirect.json?fileId=" + encodeURI(fileId+"_"+fileSeq) + "'><span data-id='"+fileName+ "' title='" + encodeURI(fileId+"_"+fileSeq) + "' class='image-thumbnail k-icon k-i-" + fileType + "'></span></a>";
           					} else {
	           					html += "<a title='" + fileName + "' href='/downloadDirect.json?fileId=" + encodeURI(fileId+"_"+fileSeq) + "'><span class='k-icon k-i-" + fileType + "'></span></a>";
           					}

           					$(this).html(html);

/*            					if(fileType == "image") {
	           					$('#filetag_' + idx + "_" + i).kendoTooltip({
 	           						//filter: "span .k-icon.k-i-image",
	           						content: kendo.template($("#template").html()),
	           						width: 200,
	           						height: 200,
	           						position: "bottom",
	           				      	error: function(e) {
	           				        	console.log("error");
	           				      	}
	           					});
           					} */
            			}
           			}
           		});

				// $('span.image-thumbnail').kendoTooltip({
 				// 	//filter: "span .k-icon.k-i-image",
				// 	content: kendo.template($("#template").html()),
				// 	width: 200,
				// 	height: 200,
				// 	position: "bottom",
				//    	error: function(e) {
				//       	console.log("error");
				//    	}
				// });
            },

            reselectGrid : function() {
            	//클릭했던 row를 다시 선택해준다.

            	var grid = $("#${sid}_gridbox").data("kendoGrid");
            	setTimeout(function(){
            		if("${grididcol}"){
						var datas = grid._data;
						var index;
						$.each(datas, function(idx, val){
							if(val.get('${grididcol}') == fnObj('LIST_${sid}').curRow){
								index = idx;
								return;
							}
						});
		            	grid.select("tr:eq("+index+")");
            		} else {
		            	grid.select("tr:eq("+fnObj('LIST_${sid}').curRow+")");
            		}
            	}, 100);
            },

            lockColumnResize : function() {

            	var grid = $('#${sid}_gridbox').data('kendoGrid');
            	if('${width}'){
                    var lockedCol = $('#${sid}_gridbox .k-grid-header-locked');
					if(lockedCol.length > 0){
						var locked = 0;
						var cols = 0;
						for (var i = 0; i < grid.columns.length; i++) {
							var gcolumns = grid.columns[i].columns; //그룹컬럼
							if(gcolumns){
								for(var j=0; j< gcolumns.length; j++){
									var hidden = grid.columns[i].columns[j].hidden;
									if(!hidden) {
										cols++;
									}
								}
							}

							var hidden = grid.columns[i].hidden;
							var lock = grid.columns[i].locked;
							if(!hidden && lock){
								locked++;
							}

							var field = grid.columns[i].field;
							if(!hidden && field) {
								cols++;
							}
						}

						var headerWidth = $('#${sid}_gridbox .k-grid-header').css("width");
						var secondWidth = $('#${sid}_gridbox .k-grid-header-wrap').css("width");
						var calWidth = headerWidth.replaceAll("px","");
						//width 조정
				      	$('#${sid}_gridbox .k-grid-header-locked').css("width", headerWidth.replaceAll("px","") * locked/cols);
				      	$('#${sid}_gridbox .k-grid-content-locked').css("width", headerWidth.replaceAll("px","") * locked/cols);
						$('#${sid}_gridbox .k-grid-header-wrap').css("width", calWidth * (cols-locked)/cols -17);
						$('#${sid}_gridbox .k-grid-content').css("width", calWidth * (cols-locked)/cols);
						//height 조정
				      	$('#${sid}_gridbox .k-grid-content-locked tr').css("height", "31px");
						$('#${sid}_gridbox .k-grid-content tr').css("height", "31px");
						//table width 조정
						$('#${sid}_gridbox .k-grid-header-wrap table').css("width", secondWidth.replaceAll("px","") * '${width}'/100 * (cols-locked)/cols);
						$('#${sid}_gridbox .k-grid-content table').css("width", secondWidth.replaceAll("px","") * '${width}'/100 * (cols-locked)/cols);
						//$('#${sid}_gridbox .k-grid-content-expander').css("width", $('#${sid}_gridbox .k-grid-content > table').css("width"));
					} else {
                    	$('#${sid}_gridbox table').css('width', '${width}%');
					}
            	}
            },

            setUserHtml : function(userHtml) {
            	var htmls = userHtml;
            	$.each(htmls, function(idx, content){
            		var position = content.position;
            		var html = content.html;
            		if(position == "button"){
            			if('${editable}' == 'Y'){
            				$('#${sid}_insertBtn').after(html);
            			} else {
	            			$('#${sid}_btns').prepend(html);
            			}
            		} else if(position == "title"){
            			$('#${sid}_header_title').append(html);
            		} else if(position == "caption"){
            			var preHtml = '<div class="${sid}_topline caption" style="margin-top:40px;">'+html+'</div>';
            			$('#${sid}_searchBlock').after(preHtml);
            		} else if(position == "bottom"){
            			var preHtml = '<div class="${sid}_bottomline" style="padding:5px 0px;">'+html+'</div>';
            			$('#${sid}_gridbox').after(preHtml);
            		}
            	});
           		fnObj('LIST_${sid}').resizeGrid();
            }
        }

        function fnChildReloadGrid(pid) {
        	fnObj('LIST_' + pid).onChange(true);
        }

        function onClick(e) {
            if ($(e.target).hasClass("k-checkbox-label")) {
                return;
            }
            var row = $(e.target).closest("tr");
            var checkbox = $(row).find(".k-checkbox");

            checkbox.click();
        }

        $(document).ready(function() {
            $(window).on("resize" , function() {
                setTimeout(function(){
               		fnObj('LIST_${sid}').resizeGrid();
	                var grid = $('#${sid}_gridbox').data('kendoGrid');
	                grid.refresh();
                }, 300);

            });

            $('#${sid}_searchDiv').find('input[type="text"]').on('keydown', function(e) {
				if (e.keyCode == 13) {
					fnObj('LIST_${sid}').reloadGrid();
				}
            });
			if($('#${sid}_insertBtn').length > 0) {
	            $('#${sid}_insertBtn').kendoButton();
	            var insertBtn = $('#${sid}_insertBtn').data('kendoButton');
	            insertBtn.bind('click', function(e) {
	            	fnObj('LIST_${sid}').onClickInsert('${sid}');
	            });
			}
			if($('#${sid}_deleteBtn').length > 0) {
            	$('#${sid}_deleteBtn').kendoButton();
            	var deleteBtn = $('#${sid}_deleteBtn').data('kendoButton');
            	deleteBtn.bind('click', function(e) {
		        	fnObj('LIST_${sid}').onClickDelete();
            	});
			}
            if($('#${sid}_searchBtn').length > 0) {
                $('#${sid}_searchBtn').kendoButton();
                var searchBtn = $('#${sid}_searchBtn').data('kendoButton');
                searchBtn.bind('click', function(e) {
                	fnObj('LIST_${sid}').reloadGrid(true);
                });
            }
			if($('#${sid}_printBtn').length > 0) {
            	$('#${sid}_printBtn').kendoButton();
            	var printBtn = $('#${sid}_printBtn').data('kendoButton');
            	printBtn.bind('click', function(e) {
            		var grid = $('#${sid}_gridbox').data("kendoGrid");
            		grid.options.excel.fileName = '${title}_' + kendo.toString(new Date, 'yyyyMMdd') + '.xlsx';
            		grid.saveAsExcel();
            	});
			}


            fnObj('LIST_${sid}').doAfterLoad();
            if(typeof setSearchCondition == "function"){
            	setSearchCondition();
    		}
           	fnObj('LIST_${sid}').gridbox();

            if('${param.ptype}' === '') {
            	fnObj('LIST_${sid}').reloadGrid();
            }

            setTimeout(function(){
	            fnObj('LIST_${sid}').resizeGrid();
	            fnObj('LIST_${sid}').calEvent();
            },300);

            if(!opener) {
            	$("#${fid}_popgrid_btns").remove();
            }

            if('C' != '${sessionScope.authTp}') {
                $(".crud").remove();
            }

            if('${userHtml}'.length > 0){
	            var userHtml = JSON.parse('${userHtml}');
	            fnObj('LIST_${sid}').setUserHtml(userHtml);
            }

            if($('.${sid}_userBtn').length > 0) {
                $('.${sid}_userBtn').kendoButton();
            }

            //editable이 N인 경우 그리드 margin-top 조정
            if('${editable}' == 'N'){
            }
        });

        function getCustomParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                    results = regex.exec(location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

    </script>

     <script id="template" type="text/x-kendo-template">
        <div class="template-wrapper">
			<div>#=target.data('id')#</div>
            <img style="width:100%;height:100%;" src="/downloadDirect.json?fileId=#=target.data('title')#" alt="#=target.data('title')#" />
        </div>
     </script>

<c:if test="${param.mode!='layout'}">
<body class="k-content">
</c:if>
<div id="${sid}_gridHml" style="width:100%;background-color: #eef2f7;display: inline-block;">
	<div id="${sid}_searchBlock" class="searchBlock">
		<div id="${sid}_header_title" class="header_title30">
            <span class="pagetitle">${title}</span>
        </div>
        <div id="${sid}_header_search" class="header_search">
            ${searchHml}
        </div>
	</div>
<c:if test="${gridInline  != 'Y' and editable == 'Y'}">
	<div id="${sid}_btns" class="grid_btns">
		<button id="${sid}_printBtn" class="basicBtn"><spring:message code="print" /></button>
		<button id="${sid}_insertBtn" class="basicBtn"><spring:message code="insert" /></button>
		<button id="${sid}_deleteBtn" class="basicBtn"><spring:message code="delete" /></button>
	</div>
</c:if>

	<div id="${sid}_gridbox" class="grid_box"></div>
</div>
<c:if test="${userJs ne null and userJs != ''}">
	<jsp:include page="${userJs}"></jsp:include>
</c:if>
<c:if test="${param.mode!='layout'}">
<div id="${fid}_popgrid_btns" style="text-align:center; margin-top:8px;">
   	 <button id="${fid}_confirmBtn" class="k-button" onclick="LIST_${fid}.fnConfirm()"><spring:message code="confirm" /></button>
     <button id="${fid}_cancelBtn" class="k-button" onclick="LIST_${fid}.fnCancel()"><spring:message code="cancel" /></button>
</div>
</c:if>
</body>
</html>