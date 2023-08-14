<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${param.mode!='layout'}">
<!DOCTYPE html>
<html>
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
	<script src="/codebase/common.js"></script>
</c:if>
    <style>
		#popContainer {
			background-color: #eff2f7;
			border-top: 3px solid #61e7ff;
		}
    	.fieldSet {
			display: inline-block;
			margin: 10px 10px 30px 10px;
			background-color: #ffffff;
			border: 1px solid #d6d6d9;
		}
		.footer-btns {
			width:100%;
			height:47px;
			line-height: 46px;
			vertical-align: middle;
			text-align: center;
			position:absolute;
			bottom: 0px;
			background-color: #cdd4e0;
		}
		.view {
			float:left;
		}
		table.k-editor.disabled {
			background-color:black;
			opacity:0.1;
			z-index: 2;
		}
    </style>
    <script>
		var CRUD_${sid} = {
            sid 		: "${sid}",
            eventCols 	: "${eventCols}",
            updateType 	: "",
			keyCols 	: "${keyCols}",

            popupAutoResize : function() {//팝업리사이징
                var strWidth;
                var strHeight;

                //innerWidth / innerHeight / outerWidth / outerHeight 지원 브라우저
                if ( window.innerWidth && window.innerHeight && window.outerWidth && window.outerHeight ) {
                    strWidth = $('#popContainer').outerWidth() + (window.outerWidth - window.innerWidth);
                    strHeight = $('#popContainer').outerHeight() + (window.outerHeight - window.innerHeight);
                } else {
                    var strDocumentWidth = $(document).outerWidth();
                    var strDocumentHeight = $(document).outerHeight();

                    window.resizeTo ( strDocumentWidth, strDocumentHeight );

                    var strMenuWidth = strDocumentWidth - $(window).width();
                    var strMenuHeight = strDocumentHeight - $(window).height();

                    strWidth = $('#popContainer').outerWidth() + strMenuWidth;
                    strHeight = $('#popContainer').outerHeight() + strMenuHeight;
                }
                //resize
                window.resizeTo( strWidth, strHeight*1.1 );
            },

            onClickEdit : function() {
                CRUD_${sid}.doEnableAll();
                $('#saveBtn_${sid}').show();
                $('#editBtn_${sid}').hide();
            },

            onClickSave : function() {
                var validationRules = {
                    selectrequired : function(input) {
                        var ret = true;
                        if(input.is("select") && input.attr("required") != undefined) {
                            ret = input.val() != null;
                        }
                        return ret;
                    }
                };
                var validationMessages =  {
                    selectrequired: "Please select at least one item."
                }

                var validator = $("#frm_${sid}").kendoValidator({rules:validationRules, messages:validationMessages}).data("kendoValidator");

                if(this.updateType == "insert") {
					var keyArr = this.keyCols.split(",");
					$.each(keyArr, function(i,o) {
					    $("#"+o).removeAttr("required");
					});
                }

                if(validator.validate()) {

					var qStr="";
					var input = $('#frm_${sid} input[id]');
					if(input.length > 0){
						for(var i=0; i<input.length; i++){
							qStr += "&"+input[i].id+"="+fnEscapeStr(input[i].value);
						}
					}
					var select = $('#frm_${sid} select');
					if(select.length > 0){
						for(var i=0; i<select.length; i++){
							qStr += "&"+select[i].id+"="+fnEscapeStr(select[i].value);
						}
					}
					var input = $('#frm_${sid} input:not([id])[name]:checked'); //라디오버튼
					if(input.length > 0){
						for(var i=0; i<input.length; i++){
							qStr += "&"+input[i].name+"="+fnEscapeStr(input[i].value);
						}
					}
                    var textarea = $('#frm_${sid} textarea');
                    if(textarea.length > 0){
                        for(var i=0; i<textarea.length; i++){
                            qStr += "&"+textarea[i].name+"="+fnEscapeStr(textarea[i].value);
                        }
                    }

					qStr += "&updateType="+this.updateType;

					$.ajax({
						url : "<c:url value='/admin/dataUpdate.json'/>"+"?sid=${sid}"+encodeURI(qStr),
						success : function(data) {
							var jsonObj = $.parseJSON(data);
							if(jsonObj.success) {
								GochigoAlert('저장 되었습니다.');

								if(typeof postFunction === "function") {
									postFunction();
								}

								if(opener!=null) {
									opener.LIST_${sid}.reloadGrid();
									window.close();
								} else {
									location.reload();
								}

							} else {
								if(jsonObj.errMsg) {
									GochigoAlert(jsonObj.errMsg);
									return;
								} else {
									GochigoAlert('서버에서 오류가 발생했습니다. 잠시후 다시 시도해주세요');
									return;
								}
							}

						}
					});
                } else {

                }
			},

        	attachEvent : function() {
				//combo select 이벤트
				if(CRUD_${sid}.eventCols != ""){
					var eventCol = CRUD_${sid}.eventCols.split(",");
					for(var i=0; i < eventCol.length; i++){
						var eventSel = eventCol[i].split(":");
						var rootCol = eventSel[0];
						var objCol = eventSel[1];
                        CRUD_${sid}.assignComboSelect(rootCol, objCol);
					}
				}
			},

            assignComboSelect : function(rootCol, objCol) {
                var rootList = $('#frm_${sid} #'+rootCol).data('kendoDropDownList');
                rootList.bind("change", function(e){
                    var value = this.value();
                    var dataSource = new kendo.data.DataSource({
                        transport: {
                            read: {
                                url: "/admin/comboReload.json?sid=${sid}&col="+objCol+"&val="+value,
                                dataType : "json"
                            }
                        },
                        schema: {
                            data: "combo"
                        }
                    });
                    var objList = $('frm_${sid} #'+objCol).data('kendoDropDownList');
                    objList.setDataSource(dataSource);
                    //         		objList.dataSource.read();
                });
            },

            doAfterLoad : function() {
                var calLen = $('#frm_${sid} .calendar').length;
                if(calLen > 0){
                    $('.calendar').kendoDatePicker({
                        format: "yyyy-MM-dd",
                        culture: "ko-KR"
                    });
                }

                var selLen = $('#frm_${sid} .select').length;
                if(selLen > 0){
                    $('#frm_${sid} .select').kendoDropDownList({height:180});
                }

                var fileLen = $('#frm_${sid} .files').length;
                if(fileLen > 0){
                    $('#frm_${sid} .files').kendoUpload();
                }

            },

        	doDisableAll : function() {
				$('#frm_${sid} .view').prop('disabled', true);
				$('#frm_${sid} input').addClass("k-state-disabled");
				var list = $('#frm_${sid} select.select');
				$.each(list, function(idx, val){
					var dropDown = $(val).data('kendoDropDownList');
					dropDown.enable(false);
				});
				var calendar = $('#frm_${sid} .view .calendar');
				$.each(calendar, function(idx, val){
					var cal = $(val).data('kendoDatePicker');
					cal.enable(false);
				});
                var editor = $("#frm_${sid} textarea");
                if(editor.data().kendoEditor) {
                    $(editor.data().kendoEditor.body).attr("contenteditable", false);
                    $("#frm_${sid} .k-editor").addClass("k-state-disabled");
                } else {
                    if(editor) {
                    	$(editor).addClass("k-state-disabled");
                    }
                }
			},

        	doEnableAll : function() {
				$('#frm_${sid} .view').prop('disabled', false);
				$('#frm_${sid} input').removeClass("k-state-disabled");
				var list = $('#frm_${sid} select.select');
				$.each(list, function(idx, val){
					var dropDown = $(val).data('kendoDropDownList');
					dropDown.enable(true);
				});
				var calendar = $('#frm_${sid} .view .calendar');
				$.each(calendar, function(idx, val){
					var cal = $(val).data('kendoDatePicker');
					cal.enable(true);
				});

                var editor = $("#frm_${sid} textarea");
                if(editor.data().kendoEditor) {
                    $(editor.data().kendoEditor.body).attr("contenteditable", true);
                    $("#frm_${sid} .k-editor").removeClass("k-state-disabled");
                } else {
                    if(editor) {
                        $(editor).removeClass("k-state-disabled");
                    }
                }
			},

			initPage : function(urlStr) {
                var _url;
                if(urlStr) {
                    _url = urlStr;
                } else {
                    if(location.search) {
                        _url = '/admin/dataView.json'+location.search;
                    } else {
                        _url = '/admin/dataView.json?sid=${sid}';
                    }

                }

                if(getParamsAsObject(_url).cobjectval == "" || getParamsAsObject(_url).cobjectval == undefined) {
                    var isUptMode = false;
                    console.log(this.keyCols);

                    $.each(this.keyCols.split(","), function(i,o) {
                        if(getParamsAsObject(_url)[o]) {
                            isUptMode = true;
                            return false;
						}
                    });
					if(isUptMode) {
                        this.updateType = "update";
                    } else {
                        this.updateType = "insert";
                    }
                } else {
                    this.updateType = "update";
                }
				$.ajax({
                    url : _url,
                    dataType: 'json',
                    success : function(data) {
                        $("#tbl_${sid} > tbody:last-child").children().remove();
                        $("#tbl_${sid} > tbody:last-child").append(data.html);

                        CRUD_${sid}.doAfterLoad();
                        CRUD_${sid}.attachEvent();
                        CRUD_${sid}.doDisableAll();
                        $('#saveBtn_${sid}').hide();
                        $('#editBtn_${sid}').show();
                        <%--CRUD_${sid}.attachEvent();--%>
                        if(typeof(opener) != "undefined") {
                        	CRUD_${sid}.popupAutoResize();
						}
                    }

                });
            }
		};

        $(document).ready(function() {
            CRUD_${sid}.initPage();

            $('#editBtn_${sid}').kendoButton();
            var editBtn = $('#editBtn_${sid}').data('kendoButton');
            editBtn.bind('click', function(e) {
                CRUD_${sid}.onClickEdit();
            });
            $('#saveBtn_${sid}').kendoButton();
            var saveBtn = $('#saveBtn_${sid}').data('kendoButton');
            saveBtn.bind('click', function(e) {
                if(typeof preFunction === "function") {
                    if(preFunction()) {
                        CRUD_${sid}.onClickSave();
                    };
                } else {
                    CRUD_${sid}.onClickSave();
                }
            });
            $('#saveBtn_${sid}').hide();
            $('#cancelBtn_${sid}').kendoButton();
            var cancelBtn = $('#cancelBtn_${sid}').data('kendoButton');
            cancelBtn.bind('click', function(e) {

                if(typeof(opener) == "undefined" || opener==null) {
                    history.back();
                } else {
                    window.close();
				}
            });

        });
    </script>
<c:if test="${param.mode!='layout'}">
</head>
<body class="k-content" >
</c:if>
<div id="popContainer">
	<div class="header_title">
		<span class="pagetitle"><span class="k-icon k-i-copy"></span>${title}</span>
	</div>
	<div>
		<fieldSet class="fieldSet">
			<form id="frm_${sid}">
			<table id="tbl_${sid}">
				<col width="${labelWidth}"/>
				<col width="*"/>
				<tbody></tbody>
			</table>
			</form>
		</fieldSet>
	</div>
	<div class="footer-btns">
		<button id="editBtn_${sid}">수정</button>
		<button id="saveBtn_${sid}">저장</button>
		<button id="cancelBtn_${sid}">닫기</button>
	</div>
</div>
<script>
    ${pre_function_js}
    ${post_function_js}
</script>
<c:if test="${param.mode!='layout'}">
</body>
</html>
</c:if>
