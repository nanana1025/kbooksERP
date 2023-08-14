<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core"%>
<style>
</style>
<script>
/**
 * crated by janghs
 */
var _userNms = [];
var _emails = [];
var _mailRecvYns = [];
var _matronIds = [];

$(document).ready(function() {
	$('.basicBtn').remove();
	setTimeout(function() {
		initGrid();
	}, 1000);
});

function initGrid() {
	$('#admin_freeuser_list_gridbox').off('dblclick');
	var grid = $('#admin_freeuser_list_gridbox').data('kendoGrid');
	grid.element.on("click", ".k-checkbox", selectRow);
	grid.bind('dataBound', fnClearParams);
}

function selectRow() {
	var row = $(this).closest("tr");
	var checked = this.checked;
	var grid = $('#admin_freeuser_list_gridbox').data('kendoGrid');
	var localName = row[0].parentNode.localName;

	if(localName == 'thead') {
		var gridElements = $("#admin_freeuser_list_gridbox").find('tbody').children('tr');
		$.each(gridElements, function(idx, gridElement) {
			var dataItem = grid.dataItem(gridElement);
			fnPushUserNmAndEmail(checked, dataItem);
		});
	} else {
		var dataItem = grid.dataItem(row);
		fnPushUserNmAndEmail(checked, dataItem);
	}
}

function fnPushUserNmAndEmail(checked, dataItem) {
	if(checked) {
		_userNms.push(dataItem.user_nm);
		_emails.push(dataItem.login_id);
		_mailRecvYns.push(dataItem.mail_recv_yn);
		_matronIds.push(dataItem.matron_id);
	} else {
		var userNmIndex = _userNms.indexOf(dataItem.user_nm);
		_userNms.splice(userNmIndex, 1);

		var emailIndex = _emails.indexOf(dataItem.login_id);
		_emails.splice(emailIndex, 1);

		var mailRecvYnIndex = _mailRecvYns.indexOf(dataItem.mail_recv_yn);
		_mailRecvYns.splice(mailRecvYnIndex, 1);

		var matronIdIndex = _matronIds.indexOf(dataItem.matron_id);
		_matronIds.splice(matronIdIndex, 1);
	}
}

function fnSendAd() {
  	if(_userNms.length == 0) {
		alert('사용자를 선택해 주세요.');
		return;
	}

  	var ismailRecv = true;
  	$.each(_mailRecvYns, function(idx, mailRecvYn) {
  		if(mailRecvYn == 'N') {
  			alert('메일 수신을 동의하지 않은 사용자는 메일을 보낼 수 없습니다.');
  			ismailRecv = false;
  			return false;
  		}
  	});

  	if(ismailRecv) {
		var width = 800;
		var height = 465;
		var xPos  = (document.body.clientWidth * 0.5) - (width * 0.5);
		xPos += window.screenLeft;
		var yPos  = (screen.availHeight * 0.5) - (height * 0.5);
		window.open("/charging/freeuserSendMailP.do", "freeuserSendMailP", "top=" + yPos + ", left=" + xPos + ", width=" + width + ", height=" + height + ", scrollbars=1");
  	}
}

function fnClearParams() {
	_userNms = [];
	_emails = [];
	_mailRecvYns = [];
	_matronIds = [];
}

function fnOfferVoucher() {
  	if(_userNms.length == 0) {
		alert('사용자를 선택해 주세요.');
		return;
	}

	var width = 800;
	var height = 380;
	var xPos  = (document.body.clientWidth * 0.5) - (width * 0.5);
	xPos += window.screenLeft;
	var yPos  = (screen.availHeight * 0.5) - (height * 0.5);
	window.open("/charging/offerVoucherP.do", "offerVoucherPopup", "top="+yPos+", left="+xPos+", width="+ width +", height="+ height +", scrollbars=1");
}

function fnReloadGrid() {
	fnObj('LIST_${sid}').reloadGrid();
}
</script>
