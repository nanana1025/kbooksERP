<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlInsertVoucherPopup"			value="/charging/insertVoucherPopup.do" />
<c:url var="urlDeleteVoucherJson"			value="/charging/deleteVoucher.json" />
<c:url var="urlChangeVoucherUseYnPopup"		value="/charging/changeVoucherUseYnPopup.do" />

<style></style>
<script>
	var _licenseIds = [];
	var _matronIds = [];
	var _voucherIds = [];
	var _paymentNos = [];

	$(document).ready(function() {
		fnInit();
	});

	function fnInit() {
		$('.basicBtn').remove();
		$('#admin_voucher_list_gridbox').off('dblclick');
		var grid = $('#admin_voucher_list_gridbox').data('kendoGrid');
		grid.element.on("click", ".k-checkbox", selectRow);
		grid.bind('dataBound', fnClearParams);
	}

	function selectRow() {
		var row = $(this).closest("tr");
		var checked = this.checked;
		var grid = $('#admin_voucher_list_gridbox').data('kendoGrid');
		var localName = row[0].parentNode.localName;

		if(localName == 'thead') {
			var gridElements = $("#admin_voucher_list_gridbox").find('tbody').children('tr');
			$.each(gridElements, function(idx, gridElement) {
				var dataItem = grid.dataItem(gridElement);
				fnPushParams(checked, dataItem);
			});
		} else {
			var dataItem = grid.dataItem(row);
			fnPushParams(checked, dataItem);
		}
	}

	function fnPushParams(checked, dataItem) {
		if(checked) {
			_licenseIds.push(dataItem.license_id);
			_matronIds.push(dataItem.matron_id);
			_voucherIds.push(dataItem.voucher_id);
			_paymentNos.push(dataItem.payment_no);
		} else {
			var licenseIdIndex = _licenseIds.indexOf(dataItem.license_id);
			_licenseIds.splice(licenseIdIndex, 1);

			var matronIdIndex = _matronIds.indexOf(dataItem.matron_id);
			_matronIds.splice(matronIdIndex, 1);

			var voucherIdIndex = _voucherIds.indexOf(dataItem.voucher_id);
			_voucherIds.splice(voucherIdIndex, 1);

			var paymentNoIndex = _paymentNos.indexOf(dataItem.payment_no);
			_paymentNos.splice(paymentNoIndex, 1);
		}
	}

	function fnInsertVoucher() {
		if(_licenseIds.length == 0) {
			alert('이용권을 추가할 결제번호를 목록에서 선택해 주세요.');
			return;
		}

		if(_licenseIds.length > 1) {
			alert('목록을 하나만 선택해 주세요.');
			return;
		}

		var params = {
			LICENSE_ID: _licenseIds[0],
			S_MATRON_ID: _matronIds[0],
			PAYMENT_NO: _paymentNos[0]
		};

		var width = 600;
		var height = 210;
		var xPos  = (document.body.clientWidth * 0.5) - (width * 0.5);
		xPos += window.screenLeft;
		var yPos  = (screen.availHeight * 0.5) - (height * 0.5);

		window.open("${urlInsertVoucherPopup}?" + $.param(params), "insertVoucherPopup", "top=" + yPos + ", left=" + xPos + ", width=" + width + ", height=" + height + ", scrollbars=1");
	}

	function fnDeleteVoucher() {
		if(_licenseIds.length == 0) {
			alert('삭제할 이용권을 목록에서 선택해 주세요.');
			return;
		}

 		var url = '${urlDeleteVoucherJson}';
		var params = {
			VOUCHER_ID: _voucherIds.join(',')
		};

		$.post(url, params, function(data) {
			if(data) {
				if(data.success) {
					alert('이용권이 삭제됐습니다.');
					fnClearParams();
					fnReloadGrid();
				} else {
					alert('이용권 삭제에 실패했습니다.');
				}
			}
		});
	}

	function fnUpdateVoucherUseYn() {
		if(_licenseIds.length == 0) {
			alert('이용권을 목록에서 선택해 주세요.');
			return;
		}

		if(_licenseIds.length > 1) {
			alert('이용권을 한개만 선택해 주세요.');
			return;
		}

		var params = {
			VOUCHER_ID: _voucherIds[0]
		};

		var width = 620;
		var height = 307;
		var xPos  = (document.body.clientWidth * 0.5) - (width * 0.5);
		xPos += window.screenLeft;
		var yPos  = (screen.availHeight * 0.5) - (height * 0.5);
		window.open("${urlChangeVoucherUseYnPopup}?" + $.param(params), "changeVoucherUseYnPopup", "top=" + yPos + ", left=" + xPos + ", width=" + width + ", height=" + height + ", scrollbars=1");
	}

	function fnReloadGrid() {
		fnObj('LIST_${sid}').reloadGrid();
	}

	function fnClearParams() {
		_licenseIds = [];
		_matronIds = [];
		_voucherIds = [];
		_paymentNos = [];
	}
</script>
