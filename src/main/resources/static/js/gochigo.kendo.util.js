/*************************************************************************
	함수명: selectedMenuId
	설  명: 선택한 메뉴의 인덱스 번호(ID)를 반환하는 함수
	인  자: item객체(kendoMenu onSelect 이벤트의 $(e.item), menu객체(this) )
	리  턴: 메뉴의 id 값
	사용예:
	selectedMenuId($(e.item), this);
***************************************************************************/
function selectedMenuId(item, menu) {
	var menuElement = item.closest(".k-menu"),
	dataItem = menu.options.dataSource,
	index = item.parentsUntil(menuElement, ".k-item").map(function () {
	    return $(menu).index();
	}).get().reverse();

	index.push(item.index());

	for (var i = 0, len = index.length; i < len; i++) {
	    dataItem = dataItem[index[i]];
	    dataItem = i < len-1 ? dataItem.items : dataItem;
	}
	return dataItem.id;
}


/*************************************************************************
함수명: GochigoValidator
설  명: Form 안에서 항목들의 유효성 검사
인  자: Form Id
리  턴: 메뉴의 id 값
사용예:
GochigoValidator('groupForm');
***************************************************************************/
function GochigoValidator(id) {
	var container = $('#' + id);
	return container.kendoValidator({
		errorTemplate : '<div class="k-widget k-tooltip k-tooltip-validation" style="margin:0.5em;">' +
		'#=message#<div class="k-callout k-callout-n"></div></div>',
	    rules: {
			inputRequiredRule : function(input) {
        		var ret = true;
        		if(input.is('input[type="text"]') && input.attr("data-required") !== undefined) {
        			if(input.val() == null || input.val() == '') {
        				ret = false;
        			} else {
            			ret = true;
        			}
        		}
        		return ret;
			},
			dateRule: function(input) {

				if(input.is('.calendar')) {
					var cDate = Date.parse($(input).val());
					if(!cDate) {
						return false;
					}
				}
				return true;
			},
			phoneRule : function(input) {
            	var ret = true;
            	if(input.is('input') && input.attr("data-phone-rule") != undefined) {
            		if(!$phoneRegex.test(input.val())) {
            			ret = false;
            		}
            	}
            	return ret;
            },
            telRule : function(input) {
            	var ret = true;
            	if(input.is('input') && input.attr("data-tel-rule") != undefined) {
            		if(!$telRegex.test(input.val())) {
            			ret = false;
            		}
            	}
            	return ret;
            },
            emailRule : function(input) {
            	var ret = true;
            	if(input.is('input') && input.attr("data-email-rule") != undefined) {
            		if(!$emailRegex.test(input.val())) {
            			ret = false;
            		}
            	}
            	return ret;
            },
            numberRule : function(input) {
            	var ret = true;
            	if(input.is('input') && input.attr("data-number-rule") != undefined) {
            		if(!$numberRegex.test(input.val())) {
            			ret = false;
            		}
            	}
            	return ret;
            },
            positiveNumberRule : function(input) {
            	var ret = true;
            	if(input.is('input') && input.attr("data-pnumber-rule") != undefined) {
            		if(!$pNumberRegex.test(input.val())) {
            			ret = false;
            		}
            	}
            	return ret;
            },
			positiveIntegerRule : function(input) {
            	var ret = true;
            	if(input.is('input') && input.attr("data-pinteger-rule") != undefined) {
            		if(!$pIntegerRegex.test(input.val())) {
            			ret = false;
            		}
            	}
            	return ret;
            },
            greaterthanZeroRule : function(input) {
            	var ret = true;
            	if(input.is('input') && input.attr("data-gtzero-rule") != undefined) {
            		var val = input.val();
            		var nVal = new Number(val);
					if(nVal <= 0) {
						ret = false;
					}
            	}
            	return ret;
            }
	    },
	    messages: {
	    	inputRequiredRule: '필수값 입력이 누락되었습니다.',
	    	dateRule: '날짜형식에 오류가 있습니다.',
			phoneRule : '핸드폰 형식에 오류가 있습니다.',
    		telRule : '전화번호 형식에 오류가 있습니다.',
    		emailRule : '이메일 형식에 오류가 있습니다.',
    		numberRule : '숫자 형식에 오류가 있습니다.',
    		positiveNumberRule : '실수 형식에 오류가 있습니다.',
    		positiveIntegerRule : '양의 정수 형식에 오류가 있습니다.',
    		greaterthanZeroRule : '0보다 커야 합니다.'
		}
	}).data('kendoValidator');
}