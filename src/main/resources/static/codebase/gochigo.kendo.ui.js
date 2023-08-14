/*************************************************************************
	함수명: GochigoAlert UI
	설  명:
	인  자:
	리  턴:
	사용예:
***************************************************************************/

function GochigoAlertClose(content, isClose, titleText) {
	if (titleText === undefined) {
		titleText = fnGetSystemName();
		//titleText = "LEADERSTECH ERP";
	}

	$("<div></div>").kendoAlert({
		buttonLayout: "stretched",
		actions: [{
			action: function(e){
				if(isClose){
					if(opener){
						self.close();
					}
				}
			}
		}],
		minWidth : 200,
		title: titleText,
        content: content === undefined ? '시스템 오류가 발생했습니다. 관리자에게 문의하세요.' : content
    }).data("kendoAlert").open();
}


/*************************************************************************
	함수명: GochigoAlert UI
	설  명:
	인  자:
	리  턴:
	사용예:
***************************************************************************/

function GochigoAlert(content, isClose, titleText) {
	if (titleText === undefined) {
		titleText = fnGetSystemName();
		//titleText = "LEADERSTECH ERP";
	}

	$("<div></div>").kendoAlert({
		buttonLayout: "stretched",
		actions: [{
			action: function(e){
				if(isClose){
					if(opener){
						self.close();
					}
				}
			}
		}],
		minWidth : 200,
		title: titleText,
        content: content === undefined ? '시스템 오류가 발생했습니다. 관리자에게 문의하세요.' : content
    }).data("kendoAlert").open();
}

/*************************************************************************
함수명: GochigoAlertCollback UI
설  명:
인  자:
리  턴:
사용예:
***************************************************************************/
function GochigoAlertLocationHref(content, isClose, titleText, url) {
	if (titleText === undefined) {
		titleText = fnGetSystemName();
		//titleText = "LEADERSTECH ERP";
	}

	$("<div></div>").kendoAlert({
		buttonLayout: "stretched",
		actions: [{
			action: function(e){
				if(isClose){
					if(opener){
						self.close();
					}
				}
				window.location.href = url;
			}
		}],
		minWidth : 200,
		title: titleText,
        content: content === undefined ? '시스템 오류가 발생했습니다. 관리자에게 문의하세요.' : content
    }).data("kendoAlert").open();
}

/*************************************************************************
함수명: GochigoAlertCollback UI
설  명:
인  자:
리  턴:
사용예:
***************************************************************************/
function GochigoAlertCollback(content, isClose, titleText, id) {
	if (titleText === undefined) {
		titleText = fnGetSystemName();
		//titleText = "LEADERSTECH ERP";
	}

	$("<div></div>").kendoAlert({
		buttonLayout: "stretched",
		actions: [{
			action: function(e){
				if(isClose){
					if(opener){
						self.close();
					}
				}
				document.getElementById(id).focus();
			}
		}],
		minWidth : 200,
		title: titleText,
        content: content === undefined ? '시스템 오류가 발생했습니다. 관리자에게 문의하세요.' : content
    }).data("kendoAlert").open();
}

/*************************************************************************
함수명: GochigoAlertCollback UI
설  명:
인  자:
리  턴:
사용예:
***************************************************************************/
function GochigoAlertReload(content, isReload, titleText, id) {
	if (titleText === undefined) {
		titleText = fnGetSystemName();
		//titleText = "LEADERSTECH ERP";
	}

	$("<div></div>").kendoAlert({
		buttonLayout: "stretched",
		actions: [{
			action: function(e){
				if(isReload){
					location.reload();
				}
				document.getElementById(id).focus();
			}
		}],
		minWidth : 200,
		title: titleText,
        content: content === undefined ? '시스템 오류가 발생했습니다. 관리자에게 문의하세요.' : content
    }).data("kendoAlert").open();
}

/*************************************************************************
함수명: GochigoMoveSite
설  명:
인  자:
리  턴:
사용예:
***************************************************************************/
function GochigoAlertMove(content, url, titleText) {
	if (titleText === undefined) {
		titleText = fnGetSystemName();
		//titleText = "LEADERSTECH ERP";
	}

	$("<div></div>").kendoAlert({
		buttonLayout: "stretched",
		actions: [{
			action: function(e){
				location.href = url;
			}
		}],
		minWidth : 200,
		title: titleText,
        content: content === undefined ? '시스템 오류가 발생했습니다. 관리자에게 문의하세요.' : content
    }).data("kendoAlert").open();
}

/*************************************************************************
함수명: gochigoConfirm UI
설  명:
인  자:
리  턴:
사용예:
***************************************************************************/
function GochigoConfirm(content, titleText, callback) {
	if (titleText === undefined) {
		titleText = fnGetSystemName();
	}

	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				if(typeof callback) {
					callback();
				}
			}
		},
		{
			text: '닫기',
			action: function(e){
				return;
			}
		}],
		minWidth : 200,
		title: titleText,
	    content: content === undefined ? '시스템 오류가 발생했습니다. 관리자에게 문의하세요.' : content
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
