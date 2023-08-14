<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:if test="${param.mode!='layout'}">
<!DOCTYPE html>
<html>
<head>
	<title>${title}</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<meta charset="utf-8"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

	<script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="/codebase/kendo/messages/kendo.messages.ko-KR.min.js"></script>
	<script src="/codebase/common.js"></script>
	<script src="/codebase/default.js"></script>
    <script src="/codebase/gochigo.kendo.common.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.ui.js"></script>
	<script src="/js/gochigo.kendo.ui.js"></script>
</c:if>
    <style>
		#popContainer {
			background-color: #eff2f7;
			/* display: flex;
			display: -ms-flexbox; */
			flex-direction: column;
			height: 100%;
		}
		.content {
			/* flex: 1; */
			background-color: #ffffff;
			border: 1px solid #d6d6d9;
			width: inherit;
			height: calc(100% - 57px);
			overflow: auto;
		}
		.fieldSet {
			display: inline-block;
			margin: 10px 10px;
			background-color: #ffffff;
			border: 1px solid #d6d6d9;
		}
		.fileRow {
			line-height: 2.0em;
			border: 1px solid #ceced2;
			border-radius: 4px;
			padding-left: 4px;
			padding-right: 4px;
		}
		img.inline-thumb { width: 150px; }
		.btnbox {
			text-align: center;
			padding: 1rem 1rem;
		}
 		table {
			border-spacing : 0;
 		}
  		table td{
			padding : 3px;
  		}
    </style>
    <script>
    	var w = $(window).width();
    	var validator;

		window['CRUD_${sid}'] = {
            sid 		: "${sid}",
        	eventCols 	: "${eventCols}",
        	customHeight : "${height}",

        	popupAutoResize : function() {//팝업리사이징
                var strHeight;

                if ( window.innerWidth && window.innerHeight && window.outerWidth && window.outerHeight ) {
                    strHeight = $('#popContainer').outerHeight() + (window.outerHeight - window.innerHeight);
                } else {
                    var strDocumentHeight = $(document).outerHeight();

                    window.resizeTo ( w, strDocumentHeight );

                    var strMenuHeight = strDocumentHeight - $(window).height();

                    strHeight = $('#popContainer').outerHeight() + strMenuHeight;
                }
                //resize

                if(strHeight > 600) {
                	strHeight = 600;
                }

                 if(${height} > 0 )
                 	strHeight = "${height}";

                window.resizeTo( w, strHeight);
            },

        	onClickList : function() {
            	location.href="<c:url value='/dataList.do'/>"+"?sid="+fnObj('CRUD_${sid}').sid;
        	},

			onClickSave : function() {
				if('${objectid}') {
					if('${objectval}') {
						var key = '${objectid}';
						var value = '${objectval}';
						$('#' + key).val(value);
					}
				}

				if(validator.validate()) {
					var readonlyInputs = $('input[readonly="readonly"]');
					var proc = true;
					$.each(readonlyInputs, function(idx, input){
						if(!validator.validateInput(input)){
							proc = false;
							return false;
						}
					});
					if(!proc) return;

					if(typeof fnOnClickSaveUpdateAfterFunction === "function") {
	                	var flag = fnOnClickSaveUpdateAfterFunction();
	                	if(!flag) {
	                		return;
	                	}
	                }

					//파일 업로드 시작
					var fileExist = false;
					if($('.files').length > 0){
						$.each($('.files'), function(idx, val){
							if(val.files.length > 0){
								fileExist = true;
							}
						});
					}

					if(fileExist){
                        $('#frm_${sid}').submit(function(event){
                        	event.preventDefault();
                        	var url=$(this).attr("action");
                        	var formData = new FormData(this);
                        	var select = $('#frm_${sid} select');
                        	if(select.length > 0){
        						for(var i=0; i<select.length; i++){
        							formData.append(select[i].id, select[i].value);
        						}
        					}
                        	$.ajax({
                                url: url,
                                async: false,
                                type: $(this).attr("method"),
                                data: formData,
                                processData: false,
                                contentType: false,
                                success: function (data, status)
                                {
                                	for(var i=0;i<$('.fileId').length;i++){
                                	  	for(var key in data){
                                		  if(key == $($('.fileId')[i]).closest('tr').find('input[id]')[0].id){
                                			  $('.fileId')[i].value = data[key];
                                		  }
                                	  	}
                                	  }
                                	  //저장 프로세스
                                	  fnObj('CRUD_${sid}').saveProc();
                                },
                                error: function (xhr, desc, err)
                                {
                                }
                            });

                        });
//                         var fileCol = [];
//                         for(var i=0;i<$('.files').length;i++){
//                         	if($('.files')[i].files.length > 0){
//                               	fileCol.push($($('.files')[i].closest('tr')).find('input[id]')[0].id);
//                         	}
//                         }
//                         $('#FILE_COL').val(fileCol);
						$('#frm_${sid}').submit();
					//파일 업로드 종료
					} else{
						//파일 없는 경우 저장
						fnObj('CRUD_${sid}').saveProc();
					}
				} else {
	        		GochigoAlert("필수 입력값을 확인하십시오.");
	            }
       		},

       		saveProc : function() {
       			var queryString = "";
				if('${pid}') {
					queryString += '&pid=${pid}';
				}

				var input = $('#frm_${sid} input[id]:not(.exclude)');
				if(input.length > 0){
					for(var i = 0; i < input.length; i++){
						queryString += "&"+input[i].id+"="+encodeURI(input[i].value);
					}
				}
				var input = $('#frm_${sid} input:checked([type="checkbox"]):not(.exclude)');
				if(input.length > 0){
					for(var i = 0; i < input.length; i++){
						queryString += "&"+input[i].id+"="+encodeURI(input[i].value);
					}
				}
				var select = $('#frm_${sid} select:not(.exclude)');
				if(select.length > 0){
					for(var i = 0; i < select.length; i++){
						queryString += "&"+select[i].id+"="+encodeURI(select[i].value);
					}
				}
				var input = $('#frm_${sid} input:not([id])[name]:checked:not(.exclude)'); //라디오버튼
				if(input.length > 0){
					for(var i = 0; i < input.length; i++){
						queryString += "&"+input[i].name+"="+encodeURI(input[i].value);;
					}
				}
                var textarea = $('#frm_${sid} textarea:not(.exclude)');
                if(textarea.length > 0){
                    for(var i=0; i<textarea.length; i++){
                        queryString += "&"+textarea[i].name+"="+encodeURI(textarea[i].value);
                    }
                }

                <c:choose>
					<c:when test='${not empty customInsert}'>
						if(typeof ${customInsert} === "function") {
							${customInsert}();
	                    }
					</c:when>
					<c:otherwise>
						$.ajax({
							url : "<c:url value='/dataInsert.json'/>"+"?xn=${xn}"+queryString,
							success : function(data) {

								//console.log('CRUD_${sid}');
								fnObj('CRUD_${sid}').postInsertFunc(data);
								GochigoAlertClose('저장 되었습니다.', true, "DANGOL365 ERP");
							}
						});
					</c:otherwise>
				</c:choose>
       		},

       		postInsertFunc : function(data) {
       			var jsonObj = $.parseJSON(data);
				if(jsonObj.success) {
                    if(typeof postFunction === "function") {
                        postFunction();
                    }
                   	if(opener.$('#${pid}_tree').length > 0){
                   		opener.fnObj('TREE_${pid}').reselectTree();
                   		//self.close();
					} else if(opener.fnObj('LIST_${sid}')) {
						opener.fnObj('LIST_${sid}').reloadGrid();
						//self.close();
					} else { //자식 그리드
                    	opener.fnChildReloadGrid(jsonObj.pid);
                    	//self.close();
                    }
					//GochigoAlert('저장 되었습니다.', true);
					//window.close 는 GochigoAlert에서 처리
				} else {
					if(jsonObj.errMsg) {
						GochigoAlert(jsonObj.errMsg);
						return;
					} else {
						GochigoAlert('서버에서 오류가 발생했습니다. 잠시후 다시 시도해주세요');
						return;
					}
				}
       		},

        	onClickCancel : function() {
				if(self.opener) {
					window.close();
				} else {
					history.back();
				}

        	},

        	attachEvent : function(eventCols) {
				//combo select 이벤트
				if(eventCols != ""){
					var eventCol = eventCols.toString().split(",");
					for(var i=0; i < eventCol.length; i++){
						var eventSel = eventCol[i].split(":");
						var rootCol = eventSel[0];
						var objCol = eventSel[1];
						fnObj('CRUD_${sid}').assignComboSelect(rootCol, objCol);
					}
				}
			},

        	assignComboSelect : function(rootCol, objCol) {
            	var rootList = $('#'+rootCol).data('kendoDropDownList');
            	rootList.bind("change", function(e){
	                var value = this.value();
	                var dataSource = new kendo.data.DataSource({
						transport: {
							read: {
								url: "/comboReload.json?sid=${sid}&col="+objCol+"&val="+value,
								dataType : "json"
							}
						},
						schema: {
							data: "combo"
						}
					});
					var objList = $('#'+objCol).data('kendoDropDownList');
					objList.setDataSource(dataSource);
					objList.bind("dataBound", function(e){
                    	objList.select(0);
                    });
	//         		objList.dataSource.read();
				});
        	},

        	getTreeItems : function(objCol, upItem){
				var rtData;
				$.ajax({
					url : "/getTreeItems.json?sid=${sid}&col="+objCol/* +"&upItem="+upItem */
					, async : false
					,success : function(data, status, xhr) {
						if(status=='success') {
							rtData = data;
						}
					}
				});
				return rtData;
			},

        	doAfterLoad : function() {
        		var calLen = $('#frm_${sid}').find('.calendar').length;
				if(calLen > 0){
					$('#frm_${sid}').find('.calendar').kendoDatePicker({
						format: "yyyy-MM-dd",
						culture: "ko-KR",
						open: function(e){
							/* setTimeout(function(){
								var calId = e.sender.element[0].id + "_dateview";
								var offsetTop = $('#'+calId).offset().top;
								var calHeight = $('#'+calId).outerHeight();
								var sumCalHeight = offsetTop + calHeight;
								var bottomHeight = $('.footer-btns').height();
// 								var strWidth;
				            	var strHeight;
								//innerWidth / innerHeight / outerWidth / outerHeight 지원 브라우저
								if ( window.innerWidth && window.innerHeight && window.outerWidth && window.outerHeight ) {
// 									strWidth = $('#popContainer').outerWidth() + (window.outerWidth - window.innerWidth);
									strHeight = $('#popContainer').outerHeight() + (window.outerHeight - window.innerHeight);
								} else {
// 									var strDocumentWidth = $(document).outerWidth();
									var strDocumentHeight = $(document).outerHeight();

									window.resizeTo ( w, strDocumentHeight );

// 									var strMenuWidth = strDocumentWidth - $(window).width();
									var strMenuHeight = strDocumentHeight - $(window).height();

// 									strWidth = $('#popContainer').outerWidth() + strMenuWidth;
									strHeight = $('#popContainer').outerHeight() + strMenuHeight;
								}
								if(sumCalHeight > $('#popContainer').outerHeight()){
									window.resizeTo( w, sumCalHeight+(bottomHeight*2+21));
								}
							},200); */
						},
						close: function(e){
							//fnObj('CRUD_${sid}').popupAutoResize();
						}
					});
				}

				var selLen = $('#frm_${sid} select.select').length;
				if(selLen > 0){
					var sels = $('#frm_${sid} select.select');
					$.each(sels, function(idx, sel){
						if($(sel)[0].length > 8){
							$(sel).kendoDropDownList({
								height: 150,
								filter: 'contains',
								open: function(e){
									/* setTimeout(function(){
										var dropDownId = e.sender.element[0].id;
										var offsetTop = $('#'+dropDownId)[0].parentElement.offsetTop;
										var listHeight = $('#'+dropDownId+'-list .k-list-scroller').height();
										var sumCalHeight = offsetTop + listHeight;
										var bottomHeight = $('.footer-btns').height();
// 										var strWidth;
						            	var strHeight;
										//innerWidth / innerHeight / outerWidth / outerHeight 지원 브라우저
										if ( window.innerWidth && window.innerHeight && window.outerWidth && window.outerHeight ) {
// 											strWidth = $('#popContainer').outerWidth() + (window.outerWidth - window.innerWidth);
											strHeight = $('#popContainer').outerHeight() + (window.outerHeight - window.innerHeight);
										} else {
// 											var strDocumentWidth = $(document).outerWidth();
											var strDocumentHeight = $(document).outerHeight();

											window.resizeTo ( w, strDocumentHeight );

// 											var strMenuWidth = strDocumentWidth - $(window).width();
											var strMenuHeight = strDocumentHeight - $(window).height();

// 											strWidth = $('#popContainer').outerWidth() + strMenuWidth;
											strHeight = $('#popContainer').outerHeight() + strMenuHeight;
										}
										if(sumCalHeight > $('#popContainer').outerHeight()){
											window.resizeTo( w, sumCalHeight+(bottomHeight*2+21));
										}
									},200); */
								},
								close: function(e){
									//fnObj('CRUD_${sid}').popupAutoResize();
								}
							});
						} else {
							$(sel).kendoDropDownList({
								height:200,
								open: function(e){
									/* setTimeout(function(){
										var dropDownId = e.sender.element[0].id;
										var offsetTop = $('#'+dropDownId)[0].parentElement.offsetTop;
										var listHeight = $('#'+dropDownId+'-list .k-list-scroller').height();
										var sumCalHeight = offsetTop + listHeight;
										var bottomHeight = $('.footer-btns').height();
// 										var strWidth;
						            	var strHeight;
										//innerWidth / innerHeight / outerWidth / outerHeight 지원 브라우저
										if ( window.innerWidth && window.innerHeight && window.outerWidth && window.outerHeight ) {
// 											strWidth = $('#popContainer').outerWidth() + (window.outerWidth - window.innerWidth);
											strHeight = $('#popContainer').outerHeight() + (window.outerHeight - window.innerHeight);
										} else {
// 											var strDocumentWidth = $(document).outerWidth();
											var strDocumentHeight = $(document).outerHeight();

											window.resizeTo ( w, strDocumentHeight );

// 											var strMenuWidth = strDocumentWidth - $(window).width();
											var strMenuHeight = strDocumentHeight - $(window).height();

// 											strWidth = $('#popContainer').outerWidth() + strMenuWidth;
											strHeight = $('#popContainer').outerHeight() + strMenuHeight;
										}
										if(sumCalHeight > $('#popContainer').outerHeight()){
											window.resizeTo( w, sumCalHeight+(bottomHeight*2+21));
										}
									},200); */
								},
								close: function(e){
									//fnObj('CRUD_${sid}').popupAutoResize();
								}
							});
						}
					});
				}

				var fileLen = $('#frm_${sid} .files').length;
				if(fileLen > 0){
					$('#frm_${sid} .files').kendoUpload({
						select : fnObj('CRUD_${sid}').onSelect,
						remove : fnObj('CRUD_${sid}').onRemove
					});
				}

				var numericLen = $('#frm_${sid} .numeric').length;
				if(numericLen > 0){
					var numerics = $('#frm_${sid} .numeric');
					$.each(numerics, function(idx, elm){
						var format = $(elm).data('format');
						var numFormatExp = /^n\d$/;
						var min = $(elm).data('min');
						var max = $(elm).data('max');
						var frmStr = '';
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
						} else if(format == 'plain'){
							frmStr = '##############################';
						} else if(format && format.match(numFormatExp)){
							frmStr = format;
						} else if(format){
							frmStr = '###,###'+format;
						} else {
							frmStr = '###,###';
						}
						$(elm).kendoNumericTextBox({
							format : frmStr,
							min : min,
							max : max
						});
					});
				}

				var maskedLen = $('#frm_${sid} .masked').length;
				if(maskedLen > 0){
					var masked = $('#frm_${sid} .masked');
					$.each(masked, function(idx, elm){
						var mask = $(elm).data('mask');
						var maskname = $(elm).data('maskname');
						$(elm).kendoMaskedTextBox({
							mask : mask,
							unmaskOnPost: true,
							change : function() {
								if(maskname == 'ssn'){
									var value = this.value();
									var ssnExp = /^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-[1-4][0-9]{6}$/;
									if(!ssnExp.test(value)){
										GochigoAlert("주민등록번호 형식과 일치하지 않습니다.");
										this.value("");
									}
								} else if(maskname == 'email'){
									var value = this.value();
									var emailExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
									if(!emailExp.test(value)){
										GochigoAlert("이메일 형식과 일치하지 않습니다.");
										this.value("");
									}
								}
							}
						});
					});
				}

				<%--$("#frm_${sid}").kendoTooltip({--%>
                <%--    filter: "input[data-tooltip]",--%>
                <%--    position: "top",--%>
                <%--    content: function (e) {--%>
                <%--        var target = e.target; // the element for which the tooltip is shown--%>
                <%--        var tooltip = $(target).data("tooltip");--%>
                <%--        return tooltip; // set the element text as content of the tooltip--%>
                <%--    }--%>
                <%--});--%>

				var pobjid = '${pobjectid}'.split(",");
            	var pobjval = '${pobjval}'.split(",");
	            if('${pobjectid}'){
	            	$.each(pobjid, function(idx, obj){
		            	if($("select#"+obj).length > 0){
			            	var dropdownlist = $("#"+obj).data("kendoDropDownList");
			            	dropdownlist.value(pobjval[idx]);
		            	}
	            	});
	            }

	            if('${isDevMode}' == 'Y' && '${desc}'){
                	var html = "<button id='${sid}_descBtn' type='button' style='z-index:3000;' class='k-button' onclick='fnObj(\"CRUD_${sid}\").openDesc();'>화면설명</button>";
                	$('#${sid}_header_title').append(html);
                }

				var validationRules = {
                    selectrequired : function(input) {
                        var ret = true;
                        if(input.is("select") && input.attr("required") != undefined) {
                            ret = input.val() != null;
                        }
                        return ret;
                    },
                    minlength : function(input) {
                    	var ret = true;
                    	if(input.is("input") && input.attr("minlength") != undefined) {
                    		ret = input.val().length >= input.attr("minlength");
                    	}
                    	return ret;
                    },
                    maxlength : function(input) {
                    	var ret = true;
                    	if(input.is("input") && input.attr("maxlength") != undefined) {
                    		ret = input.val().length <= input.attr("maxlength");
                    	}
                    	return ret;
                    }
                };
                var validationMessages =  {
                    selectrequired: "Please select at least one item.",
                    minlength : "최소 입력길이보다 짧습니다.",
                    maxlength : "최대 입력길이보다 깁니다."
                }

                validator = $("#frm_${sid}").kendoValidator({
                	rules: validationRules,
                	messages: validationMessages,
                	validateOnBlur: true
               	}).data("kendoValidator");

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

			initPage : function() {

        	    $.ajax({
					url : '/dataEdit.json',
					data : {
					    xn:'${xn}',
					    sid:'${sid}',
					    objectid : '${objectid}',
					    objectval : '${objectval}'

					},
					dataType: 'json',
					success : function(data) {

                        $("#tbl_${sid} > tbody:last-child").append(data.html);
                        fnObj('CRUD_${sid}').doAfterLoad();
                        fnObj('CRUD_${sid}').attachEvent(data.eventCols);
                        if(opener){
                        	fnObj('CRUD_${sid}').popupAutoResize();
                        }
                        if(typeof fnViewHtmlLoadAfterFunction === "function") {
                        	fnViewHtmlLoadAfterFunction();
                        }
                    }

				});
            },

            onSelect : function() {
            	setTimeout(function () {
	            	var fileCol = [];
	                for(var i=0;i<$('.files').length;i++){
	                	for(var j=0;j<$('.files')[i].files.length;j++){
	                      	fileCol.push($($('.files')[i]).closest('tr').find('input[id]')[0].id);
	                	}
	                }
	                $('#FILE_COL').val(fileCol);
	             }, 100);
            },
            onRemove : function() {
            	setTimeout(function () {
	            	var fileCol = [];
	                for(var i=0;i<$('.files').length;i++){
	                	for(var j=0;j<$('.files')[i].files.length;j++){
	                      	fileCol.push($($('.files')[i]).closest('tr').find('input[id]')[0].id);
	                	}
	                }
	                $('#FILE_COL').val(fileCol);
            	}, 100);
            },

            fnWindowOpen: function(url, callbackName, size) {
                var width, height;
                if(size == "S"){
                	width = "800";
                	height = "600";
                } else if(size == "M") {
                	width = "1024";
                	height = "768";
                } else if(size == "W") {
                	width = "1600";
                	height = "808";
                }else if(size == "L") {
                	width = "1280";
                	height = "900";
                } else {
                	width = "800";
                	height = "600"
                }
            	var xPos  = (document.body.clientWidth /2) - (width / 2);
                xPos += window.screenLeft;
                var yPos  = (screen.availHeight / 2) - (height / 2);
                window.open("<c:url value='"+url+"'/>"+"&callbackName="+callbackName, "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
            },

            setUserHtml : function(userHtml) {
            	var htmls = userHtml;
            	$.each(htmls, function(idx, content){
            		var position = content.position;
            		var html = content.html;
            		if(position == "bottom"){
            			$('#${sid}_footer-btns').prepend(html);
            		} else if(position == "title"){
            			$('#${sid}_header_title').append(html);
            		} else if(position == "caption"){
            			var preHtml = '<div class="${sid}_topline caption">'+html+'</div>';
            			$('#${sid}_header_title').after(preHtml);
            		}
            	});
            }

		};

		$(document).ready(function() {
			//fnObj('CRUD_${sid}').initPage();
			if('${param.pid}' === '' || opener) {
				fnObj('CRUD_${sid}').initPage();
			}
            $('#saveBtn_${sid}').kendoButton();
            var saveBtn = $('#saveBtn_${sid}').data('kendoButton');
            saveBtn.bind('click', function(e) {
                if(typeof preFunction === "function") {
                    if(preFunction()) {
                    	fnObj('CRUD_${sid}').onClickSave();
                    };
                } else {
                	fnObj('CRUD_${sid}').onClickSave();
                }
            });
            $('#cancelBtn_${sid}').kendoButton();
            var cancelBtn = $('#cancelBtn_${sid}').data('kendoButton');
            cancelBtn.bind('click', function(e) {
                if(typeof(opener) != "undefined") {
                    history.back();
                }
                window.close();
            });

            /* setTimeout(function () {
            	var pobjid = '${pobjectid}'.split(",");
            	var pobjval = '${pobjval}'.split(",");
	            if('${pobjectid}'){
	            	$.each(pobjid, function(idx, obj){
		            	if($("select#"+obj).length > 0){
			            	var dropdownlist = $("#"+obj).data("kendoDropDownList");
			            	dropdownlist.value(pobjval[idx]);
		            	}
	            	});
	            }
            }, 100); */

            if(opener == null) {
            	$('#cancelBtn_${sid}').hide();
            }

            if('${userHtml}'.length > 0){
	            var userHtml = JSON.parse('${userHtml}');
	            fnObj('CRUD_${sid}').setUserHtml(userHtml);
            }
        });

    </script>
<c:if test="${param.mode!='layout'}">
</head>
<body class="k-content">
</c:if>
<div id="popContainer">
	<div id="${sid}_header_title" class="header_title">
		<span class="pagetitle"><span class="k-icon k-i-copy"></span>${title}</span>
	</div>
	<div class="content">
		<div id="${sid}_view-btns" class="view_btns">
			<button id="saveBtn_${sid}" class="crud"><spring:message code="save"/></button>
			<button id="cancelBtn_${sid}"><spring:message code="close"/></button>
		</div>
		<fieldset class="fieldSet">
			<input type="hidden" id="objectid" value="${objectid}"/>
			<form id="frm_${sid}" method="post" enctype="multipart/form-data" action="/uploadInsert.json">
			<input type="hidden" name="xn" value="${xn}"/>
			<input type="hidden" name="sid" value="${sid}"/>
			<input type="hidden" id="objectval" value="${objectval}"/>
			<input type="hidden" id="FILE_COL" name="FILE_COL" value=""/>
			<table id="tbl_${sid}">
				<colgroup width="2100px">
					<c:choose>
						<c:when test="${lines == 2}">
							<col width="${label1Width}"/>
							<col width="*"/>
							<col width="${label2Width}"/>
							<col width="*"/>
						</c:when>
						<c:otherwise>
							<col width="${labelWidth}"/>
							<col width="*"/>
						</c:otherwise>
					</c:choose>
				</colgroup>
				<tbody></tbody>
				<%--${formData}--%>
			</table>
			<input type="hidden" id="ie_only_dummy_value_field" name="ie_only_dummy_value_field" value="-1"/>
			</form>
		</fieldset>
	</div>
</div>
<script>
    ${pre_function_js}
    ${post_function_js}
</script>
<c:if test="${jsfileyn == 'Y'}">
	<jsp:include page="${jsfileurl}"></jsp:include>
</c:if>
</body>
</html>