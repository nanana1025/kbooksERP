/*************************************************************************
	함수명: GochigoAlert UI
	설  명:
	인  자:
	리  턴:
	사용예:
***************************************************************************/
function GochigoAlert(content, titleText, callback) {
	if (titleText === undefined) {
		titleText = fnGetSystemName()
	}

	$('<div class="gochigo-alert"></div>').kendoAlert({
		buttonLayout: "stretched",
		minWidth : 200,
		title: titleText,
		content: content === undefined ? '시스템 오류가 발생했습니다. 관리자에게 문의하세요.' : content,
		actions: [{
			text: '확인',
			action: function(e){
				if(callback) {
					callback();
				}
			}
		}],
		open: function(e) {
			$(e.sender.element).prev().removeClass('k-header');
		}
    }).data("kendoAlert").open();
}

/*************************************************************************
함수명: GochigoConfirm UI
설  명:
인  자:
	content: 확인문구
	titleText: 확인창 제목
	callback: 확인시 실행할 함수(익명함수로 작성)
리  턴:
사용예:
***************************************************************************/
function GochigoConfirm(content, titleText, callback) {
	if (!titleText) {
		titleText = fnGetSystemName();
	}

	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		minWidth : 200,
		title: titleText,
	    content: content === undefined ? '시스템 오류가 발생했습니다. 관리자에게 문의하세요.' : content,
		actions: [{
			text: '확인',
			action: function(e){
				if(typeof callback) {
					callback();
				}
			}
		},
		{
			text: '취소',
			action: function(e){
				return;
			}
		}],
		open: function(e) {
			$(e.sender.element).prev().removeClass('k-header');
		}
	}).data("kendoConfirm").open();
}

/*************************************************************************
함수명: GochigoShleeConfirm UI
설  명:
인  자:
	content: 확인문구
리  턴:
    확인: true
    닫기: false
사용예:
***************************************************************************/
function GochigoShleeConfirm(content) {
		var titleText = fnGetSystemName();

	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		minWidth : 200,
		title: titleText,
	    content: content === undefined ? '시스템 오류가 발생했습니다. 관리자에게 문의하세요.' : content,
		actions: [{
			text: '확인',
			action: function(e){
				return true;
			}
		},
		{
			text: '취소',
			action: function(e){
				return false;
			}
		}],
		open: function(e) {
			$(e.sender.element).prev().removeClass('k-header');
		}
	}).data("kendoConfirm").open();
}

/*************************************************************************
함수명: GochigoWindow UI
설  명: 팝업창
인  자: id: kendoWindow 객체 ID, title: 팝업제목, width: 팝업넓이, activeMethod: 팝업창 open 후의 발생할 이벤트
리  턴:
사용예: GochigoWindow -> GochigoKendoWindow 이용바람!!! (동일기능)
***************************************************************************/
function GochigoWindow(id, title, width, activeMethod, openMethod, closeMethod) {
	$('#' + id).kendoWindow({
		width: (width + "px"),
	   	title: title,
	   	visible: false,
	   	autoFocus: true,
	    actions: ['Close'],
	    activate: function(e) {
	    	if(activeMethod) {
	    		activeMethod();
	    	}
	    	$('#' + id).prev().removeClass('k-header').addClass('k-window-header');
	    },
		open: function(e) {
			if(openMethod) {
				openMethod();
			}
			$('#' + id).find('div.btn-group-footer').find('button.k-button').css('border-radius', '0px');
		},
		close: function(e) {
			if(closeMethod) {
				closeMethod();
			}
		}
	}).data("kendoWindow").center().open();

	var dialog = $("#" + id).data("kendoWindow");
	dialog.title(title);

	$('.k-window-titlebar').on('dblclick', function(e){
		e.preventDefault();
		return false;
	});
}


/*************************************************************************
kendo pager 한글화
***************************************************************************/
(function ($, undefined) {
	if (kendo.ui.Pager) {
		kendo.ui.Pager.prototype.options.messages =
		$.extend(true, kendo.ui.Pager.prototype.options.messages,{
		  "allPages": "전체",
		  "display": "{0} - {1} 중 {2} 항목",
		  "empty": "표시할 항목이 없습니다",
		  "page": "페이지",
		  "of": "전체 {0}",
		  "itemsPerPage": "페이지당 항목 수",
		  "first": "첫 페이지로 가기",
		  "previous": "이전 페이지로 가기",
		  "next": "다음 페이지로 가기",
		  "last": "마지막 페이지로 가기",
		  "refresh": "새로고침",
		  "morePages": "더 보기"
		});
	}
})(window.kendo.jQuery);

/*************************************************************************
함수명: GochigoKendoWindow UI
설  명:
인  자:
리  턴:
사용예:
***************************************************************************/
function GochigoKendoWindow($obj, options, activeMethod, openMethod, closeMethod) {
	// 타이틀제거를 위해서 사용
	if (options) {
		options.title = false;
	}

	var options2 = $.extend(true, {
		        modal: true,
		        visible: false,
		        autoFocus: true,
		        title: false,
			    content: "",
			    activate: function(e) {
			    	if(activeMethod) {
			    		activeMethod();
			    	}
//			    	$obj.prev().removeClass('k-header').addClass('k-window-header');
			    },
				open: function(e) {
					if(openMethod) {
						openMethod();
					}
//					$obj.find('div.btn-group-footer').find('button.k-button').css('border-radius', '0px');
				},
				close: function(e) {
					if(closeMethod) {
						closeMethod();
					}
				}
			}, options);
	$obj.kendoWindow(options2);
}
function GochigoKendoWindowOpen($obj){
	$obj.data("kendoWindow").open();
}
function GochigoKendoWindowClose($obj){
	$obj.data("kendoWindow").close();
}

function GochigoWindowOpen(id){
	$('#' + id).data("kendoWindow").open();
}
function GochigoWindowClose(id){
	$('#' + id).data("kendoWindow").close();
}

/*************************************************************************
함수명: GochigoKendoDisplayLoading UI
설  명:
인  자:
리  턴:
사용예: GochigoKendoProgressLoading(document.body); or GochigoKendoProgressLoading("#container");
***************************************************************************/
function GochigoKendoProgressLoading(target) {
    var element = $(target);
    kendo.ui.progress(element, true);
}
function GochigoKendoProgressClose(target) {
    var element = $(target);
    kendo.ui.progress(element, false);
}

/*************************************************************************
함수명: GochigoKendoMultiCheckDropDown
설  명: 드롭다운리스트를 만들때 체크박스가 포함된 멀티선택 리스트를 생성한다.
인  자:
리  턴:
사용예: GochigoKendoMultiCheckDropDown("#dropDown", options, true);
***************************************************************************/
function GochigoKendoMultiCheckDropDown(dropDown, options, checkAll) {
	var checkBoxOptions = {
			template : kendo.template('<div class="check-item"><input type="checkbox" name="#= LABEL #" value="#= VALUE #" class="check-input"/>'
				    +'<span>#= LABEL #</span></div>'),
			select : function(e) {
				e.preventDefault();
			}
	}
	$.extend(true, options, checkBoxOptions);

	var dropDownList = $(dropDown).kendoDropDownList(options).data('kendoDropDownList');

	dropDownList.list.find(".check-input,.check-item").bind("click", function(e) {
        var $item = $(this);
        var $input;

        if($item.hasClass("check-item"))
        {
            // Text was clicked
            $input = $item.children(".check-input");
            $input.prop("checked", !$input.is(':checked'));
        }
        else
            // Checkbox was clicked
            $input = $item;

        // Check all clicked?
        if($input.val() == "" && checkAll)
            dropdown.list.find(".check-input").prop("checked", $input.is(':checked'));

        updateDropDown(dropDownList, checkAll)

        e.stopImmediatePropagation();
    });

	updateDropDown(dropDownList, checkAll);
}

function updateDropDown(dropDownList, checkAll)
{
    var items= [];

    dropDownList.list.find(".check-input").each(function() {
        var $input = $(this);
        if($input.val() != "" && $input.is(':checked'))
            items.push($input.next().text());
    });

    // Check the Check All if all the items are checked
    if(checkAll)
    	$(dropDownList.list.find(".check-input")[0]).prop("checked", items.length == dropDownList.list.find(".check-input").length - 1);

    dropDownList.text(items.toString());
}

/*************************************************************************
함수명: GochigoKendoGetMultiCheckDropDownValue
설  명: 멀티체크드롭다운리스트의 값을 배열형태로 리턴받는다.
인  자:
리  턴:
사용예: GochigoKendoGetMultiCheckDropDownValue("#dropDown");
***************************************************************************/
function GochigoKendoGetMultiCheckDropDownValue(dropDown) {
	var checked = $(dropDown+'_listbox').find('input[type=checkbox]:checked');
	var vals = [];
	$.each(checked, function(idx, elm){
		vals.push($(elm).val());
	});
	return vals;
}