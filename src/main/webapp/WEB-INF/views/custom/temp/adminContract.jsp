<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="urlChangeContractPopup"		value="/user/changeContractPopup.do" />

<style></style>
<script>
	$(document).ready(function() {
		$('#admin_hospital_contract_list_printBtn, #admin_hospital_contract_list_insertBtn, #admin_hospital_contract_list_deleteBtn').remove();
		$('#admin_hospital_contract_list_gridbox').off('dblclick');
	});

	function fnChangeContract() {
		var grid = $('#admin_hospital_contract_list_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		if(!selItem) {
			alert('계약여부를 변경할 병원을 선택해 주세요.');
			return;
		}

		var params = {
			HOSPITAL_ID: selItem.hospital_id,
			HOSPITAL_NM: selItem.hospital_nm,
			CONTRACT_YN: selItem.contract_yn
		};

		var width = 520;
		var height = 177;
		var xPos  = (document.body.clientWidth * 0.5) - (width * 0.5);
		xPos += window.screenLeft;
		var yPos  = (screen.availHeight * 0.5) - (height * 0.5);
		window.open("${urlChangeContractPopup}?" + $.param(params), "changeContractPopup", "top=" + yPos + ", left=" + xPos + ", width=" + width + ", height=" + height + ", scrollbars=1");
	}

	function fnReloadGrid() {
		fnObj('LIST_${sid}').reloadGrid();
	}
</script>
