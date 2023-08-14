<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<c:url var="getConsignedInfo"					value="/consigned/getConsignedInfo.json" />
<c:url var="getRelatedConsignedInfo"					value="/consigned/getRelatedConsignedInfo.json" />

<c:url var="getConsignedComponentFullInfo"					value="/consigned/getConsignedComponentFullInfo.json" />
<c:url var="getConsignedAdjustInfo"		value="/consigned/getConsignedAdjustInfo.json" />
<c:url var="updateReceiptStatus"			value="/consigned/updateReceiptStatus.json" />

<c:url var="getCodeListCustom"				value="/common/getCodeListCustom.json" />
<c:url var="companyDelete"					value="/user/companyDelete.json" />
<c:url var="companyInsert"						value="/user/companyInsert.json" />
<c:url var="getConsignedDateList"			value="/consigned/getConsignedDateList.json" />
<c:url var="consignedComponentContract"			value="/consigned/consignedComponentContract.json" />
<c:url var="consignedComponentExtract"			value="/consigned/consignedComponentExtract.json" />
<c:url var="consignedComponentCopy"			value="/consigned/consignedComponentCopy.json" />
<c:url var="updateProxyComponentUnit"						value="/consigned/updateProxyComponentUnit.json"/>
<c:url var="updatePrice"						value="/consigned/updatePrice.json"/>

<c:url var="createReceipt"						value="/consigned/createReceipt.json"/>
<c:url var="updateReceipt"						value="/consigned/updateReceipt.json"/>
<c:url var="returnReceipt"						value="/consigned/returnReceipt.json"/>
<c:url var="updateAdjust"						value="/consigned/updateAdjust.json"/>
<c:url var="consignedUpdateDetail"						value="/consigned/consignedUpdateDetail.json"/>
<c:url var="getLicenceInfo"						value="/consigned/getLicenceInfo.json"/>

<c:url var="executeQuery"						value="/common/executeQuery.json"/>
<c:url var="consignedProcess"				value="layoutCustom.do" />
<c:url var="consignedPopup"					value="/CustomP.do"/>


<c:url var="dataList"					value="/customDataList.json" />


<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	<title>DANGOL365 ERP | 생산대행</title>

 	<link rel="stylesheet" type="text/css" href="/codebase/css/custom_style.css"/>
	<script src="/codebase/gochigo.kendo.ui.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

	<style>
		.k-widget .k-datepicker {
			top: -1px;
		}
		.k-i-calendar {
			top: -2px;
		}
		.col-input {
			height: 24px;
		}
		.table-inner-col-input {
			height: 24px;
		}
	</style>

	<script type="text/javascript">

 		var _CODE = ["CPU", "MBD", "MEM", "VGA", "SSD", " HDD", "MON", "CAS", "ADP", "POW", "KEY", "MOU", "FAN", "CAB", "BAT"];

 		var _RECEIPT_STATUS = ["RECEIPT_DT", "PROCESS_DT", "POSTPONE_DT", "CANCEL_DT", "RELEASE_DT", "RETURN_REQUEST_DT", "RETURN_IN_DT", "EXCHANGE_DT", "RETURN_CANCEL_DT", "RETURN_COMPLETE_DT"];
 		var _RECEIPT_STATUS_NAME = ["접수", "처리중", "보류", "취소", "출고완료", "반품요청", "반품입고", "교환출고", "반품취소", "반품완료"];

 		var _listComponentId = new Array();

 		var _proxyId;
 		var _companyId;

 		var _pProxyId;
 		var _rProxyId;
 		var _cProxyId;

 		var _proxyState;

 		var _userId;
 		var _userName;
 		var _userType = "U";

 		var _stateDateData = new Array();

 		var _componentInfo;
 		var _componentCnt = 0;

 		var _selectedRow = null;

 		var _consignedState = 0;

 		var _countCheck = 0;

 		var _examCheckYn = "N";

 		var _typeId = 1;

		$(document).ready(function() {

			console.log("consigned_receipt.jsp");

			totalProductCount = 0;

			// 제품유형 추가
            $('#PC_TYPE').empty();

            // 판매처 추가
            $('#COMPANY_ID').empty();

            // 판매경로 추가
            $('#SALE_ROOT').empty();

			// 보증기간 추가
			$('#GUARANTEE_DUE').empty();

			fnInitData();

			var default_period_month = 1;
			var default_start_date = new Date();
			var default_end_date = new Date();
			default_end_date.setMonth(default_end_date.getMonth() + default_period_month);

            $("#datetimepicker_acceptance_date").kendoDatePicker({
                format: "yyyy-MM-dd",
                value: new Date()
            });

			$("#datetimepicker_acceptance_start").kendoDatePicker({
				format: "yyyy-MM-dd",
                value: default_start_date,
				change: changeGuaranteeDate()
			});

			$("#datetimepicker_acceptance_end").kendoDatePicker({
				format: "yyyy-MM-dd",
                value: default_end_date,
                change: changeGuaranteeDate()
			});

			for(var j=0; j<10; j++) {
				var id = 'process-info-date' + j ;
				var selector = $("[id*='"+id+"']");
				selector.kendoDatePicker({
					format: "yyyy-MM-dd",
// 					change: changeGuaranteeDate()
				});
			}

			for(var k=1; k<4; k++) {
				var selector = $("[id*='release-dt" + k +"']");
// 				console.log(selector);
				selector.kendoDatePicker({
					format: "yyyy-MM-dd",
// 					change: changeGuaranteeDate()
				});
			}

			$("#chCopyUserInfo").change(function(){
		      fnCopyUserInfo();
		    });

			var key = getParameterByName('KEY');
			_proxyId = getParameterByName(key);


			fnInitConsignedData();
			fnInitConsignedAdjust();
			fnInitConsignedLicence();
			fnInitConsignedDateTooltip();

			//setTableRowClickEvent();

			//console.log("_proxyState = "+_proxyState);
			if(_proxyState  != 1)
				lockComponent();

			if(_pProxyId > 0 || _rProxyId > 0 || _cProxyId > 0 ){
				$('#related_receipt_no_info').show();
				fnInitRelatedConsignedData();
			}

			setTooltipOnIcon($("[id*='btnGoReceiptList"), "전체리스트");
			setTooltipOnIcon($("[id*='delivery_invoidce"), "수정");
			setTooltipOnIcon($("[id*='couponEditBtn"), "수정");
			setTooltipOnIcon($("[id*='couponSaveBtn"), "저장");
			setTooltipOnIcon($("[id*='SNEditBtn"), "수정");
			setTooltipOnIcon($("[id*='SNSaveBtn"), "저장");
			setTooltipOnIcon($("[id*='modifComponent"), "부품정보수정");
			setTooltipOnIcon($("[id*='compareReleaseComponent"), "부품 할당");
			setTooltipOnIcon($("[id*='componentContract"), "자사재고변경");
			setTooltipOnIcon($("[id*='componentExtract"), "재고삭제");
			setTooltipOnIcon($("[id*='componentCopy"), "재고복사");

			$(".col-input-number").attr("readonly",true);
			$("#original_price").attr("readonly",true);



		});

		function lockComponent(){

			if(_proxyState != 0){
				$('#consigned_receipt_cancel_btn').attr("disabled","disabled");
				$('#PC_TYPE').attr("disabled","disabled");
				$('#datetimepicker_acceptance_date').attr("readonly",true);
				$('#GUARANTEE_DUE').attr("disabled","disabled");
				$('#datetimepicker_acceptance_start').attr("readonly",true);
				$('#datetimepicker_acceptance_end').attr("readonly",true);
				$('#SALE_ROOT').attr("disabled","disabled");
				$("input[name='RELEASE_TYPE']").attr('disabled',true);
				$('#DES').attr("readonly",true);
				$('#REQUEST').attr("readonly",true);
				$('#chCopyUserInfo').attr("disabled","disabled");
				$('#CUSTOMER_NM_S').attr("readonly",true);
				$('#CUSTOMER_NM_R').attr("readonly",true);
				$('#TEL_S').attr("readonly",true);
				$('#TEL_R').attr("readonly",true);
				$('#MOBILE_S').attr("readonly",true);
				$('#MOBILE_R').attr("readonly",true);
				$('#find_postal_code').attr("disabled","disabled");
				$('#ADDRESS').attr("readonly",true);
				$('#ADDRESS_DETAIL').attr("readonly",true);
			}


			$('#delivery_invoidce').attr("disabled","disabled");
			$('#couponEditBtn').attr("disabled","disabled");
			$('#couponSaveBtn').attr("disabled","disabled");
			$('#SNEditBtn').attr("disabled","disabled");
			$('#SNSaveBtn').attr("disabled","disabled");

			$('#modifComponent').attr("disabled","disabled");
			$('#compareReleaseComponent').attr("disabled","disabled");
			$('#componentContract').attr("disabled","disabled");
			$('#componentCopy').attr("disabled","disabled");
			$('#componentExtract').attr("disabled","disabled");
			$('#componentContractExtract').attr("disabled","disabled");
			$('#consigned_update_adjust').attr("disabled","disabled");


			$('#price-produce-select').attr("disabled","disabled");
			$('#price-produce-input').attr("readonly",true);
			$('#price-reproduce-select').attr("disabled","disabled");
			$('#price-reproduce-input').attr("readonly",true);
			$('#price-delivery-select').attr("disabled","disabled");
			$('#price-delivery-input').attr("readonly",true);
			$('#price-quick-select').attr("disabled","disabled");
			$('#price-quick-input').attr("readonly",true);

			$('#release-dt1').attr("readonly",true);

// 			$('#price-produce').attr("disabled","disabled");
// 			$('#price-reproduce').attr("disabled","disabled");
// 			$('#price-delivery').attr("disabled","disabled");
// 			$('#price-quick').attr("disabled","disabled");

			$(".col-input-number").attr("readonly",true);
			$(".col-input-number-price").attr("readonly",true);

		}

		function unLockComponent(){

			$('#consigned_receipt_cancel_btn').removeAttr("disabled");
			$('#PC_TYPE').removeAttr("disabled");
			$('#datetimepicker_acceptance_date').attr("readonly",false);
			$('#GUARANTEE_DUE').removeAttr("disabled");
			$('#datetimepicker_acceptance_start').attr("readonly",false);
			$('#datetimepicker_acceptance_end').attr("readonly",false);
			$('#SALE_ROOT').removeAttr("disabled");
			$("input[name='RELEASE_TYPE']").removeAttr("disabled");
			$('#DES').attr("readonly",false);
			$('#REQUEST').attr("readonly",false);
			$('#chCopyUserInfo').removeAttr("disabled");
			$('#CUSTOMER_NM_S').attr("readonly",false);
			$('#CUSTOMER_NM_R').attr("readonly",false);
			$('#TEL_S').attr("readonly",false);
			$('#TEL_R').attr("readonly",false);
			$('#MOBILE_S').attr("readonly",false);
			$('#MOBILE_R').attr("readonly",false);
			$('#find_postal_code').removeAttr("disabled");
			$('#ADDRESS').attr("readonly",false);
			$('#ADDRESS_DETAIL').attr("readonly",false);

			$('#delivery_invoidce').removeAttr("disabled");
			$('#couponEditBtn').removeAttr("disabled");
			$('#couponSaveBtn').removeAttr("disabled");
			$('#SNEditBtn').removeAttr("disabled");
			$('#SNSaveBtn').removeAttr("disabled");

			$('#modifComponent').removeAttr("disabled");
			$('#compareReleaseComponent').removeAttr("disabled");
			$('#componentContract').removeAttr("disabled");
			$('#componentCopy').removeAttr("disabled");
			$('#componentExtract').removeAttr("disabled");
			$('#componentContractExtract').removeAttr("disabled");
			$('#consigned_update_adjust').removeAttr("disabled");


			$('#price-produce-select').removeAttr("disabled");
			$('#price-produce-input').attr("readonly",false);
			$('#price-reproduce-select').removeAttr("disabled");
			$('#price-reproduce-input').attr("readonly",false);
			$('#price-delivery-select').removeAttr("disabled");
			$('#price-delivery-input').attr("readonly",false);
			$('#price-quick-select').removeAttr("disabled");
			$('#price-quick-input').attr("readonly",false);

			$('#release-dt1').attr("readonly",false);

// 			$('#price-produce').removeAttr("disabled");
// 			$('#price-reproduce').removeAttr("disabled");
// 			$('#price-delivery').removeAttr("disabled");
// 			$('#price-quick').removeAttr("disabled");

			$(".col-input-number").attr("readonly", true);
			$(".col-input-number-price").attr("readonly", false);

		}



		function setCountCheck(countCheck){
			_countCheck = countCheck;
		}

		function setTableRowClickEvent(){
			$("#tbl_consigned_component_data tr").click(function() {

				_selectedRow = $(this).children();

				var rowIdx = _selectedRow.closest("tr").prevAll().length;

				for(var i = 0; i < _componentCnt; i++) {

					var checkBox = $("[id*='checkComponent_" + i +"']");

					if(i == rowIdx)
						checkBox.prop("checked", true);
					else
						checkBox.prop("checked", false);

				}
			});
		}

		function shlee()
		{
			console.log("1111");
		}


		function fnChangeCheckAll()
		{
			var checkBox = $("[id*='checkAll']");
			var checked = checkBox.is(":checked");

			for(var i = 0; i < _componentCnt; i++) {
				var checkBox = $("[id*='checkComponent_" + i +"']");
				checkBox.prop("checked", checked);
			}
		}

		function fnPrintJobOrder(){

			 var width, height;

			    var url = '${consignedPopup}';

				var query = "?content=consignedOrderSheet&KEY=PROXY_ID&PROXY_ID="+_proxyId;

				var width, height;

				width = "811";
		 		height = "842";

				var xPos  = (document.body.clientWidth /2) - (width / 2);
			    xPos += window.screenLeft;
			    var yPos  = (screen.availHeight / 2) - (height / 2);

			    window.open("<c:url value='"+url+query+"'/>", "consignedJobOrderPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
		}

		function fnInsertReleaseInventory(){ 	// 현재 사용하지 않음

			var checkCnt = 0;
			for(var i = 0; i < _componentCnt; i++) {
				var checkBox = $("[id*='checkComponent_" + i +"']");
				var checked = checkBox.is(":checked");
				if(checked)
					checkCnt++;
			}

			if(checkCnt == 0){GochigoAlert("선택된 부품이 없습니다..", false, "dangol365 ERP"); return;}


			var url = '${consignedPopup}';



			var query = "?content=consignedReleaseInventory&KEY=PROXY_PART_ID&PROXY_PART_ID="+_selectedRow.eq(0).text()+"&KEY1=COMPONENT_ID&COMPONENT_ID="+_selectedRow.eq(2).text()+"&KEY2=CONSIGNED_TYPE&CONSIGNED_TYPE="+_selectedRow.eq(3).text()+"&KEY3=COMPANY_ID&COMPANY_ID="+	$('#COMPANY_ID').val();

			var width, height;

			width = "500";
	    	height = "540";

			var xPos  = (document.body.clientWidth /2) - (width / 2);
		    xPos += window.screenLeft;
		    var yPos  = (screen.availHeight / 2) - (height / 2);

		    window.open("<c:url value='"+url+query+"'/>", "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);


		}

		function fnComponentCopy(){

			var lisProxyPartId = [];
			var checkCnt = 0;
			for(var i = 0; i < _componentCnt; i++) {

				var checkBox = $("[id*='checkComponent_" + i +"']");
				var checked = checkBox.is(":checked");
				if(checked){
					checkCnt++;
					var row = checkBox.parent().parent();
					//var consignedType = row.children().eq(3).text()*1;
					//if(consignedType == 1)
						lisProxyPartId.push(row.children().eq(0).text());
				}
			}

			if(checkCnt == 0){GochigoAlert("선택된 부품이 없습니다.", false, "dangol365 ERP"); return;}

			var url = '${consignedComponentCopy}';

			var params = {
					PROXY_PART_ID: lisProxyPartId.toString()
	    	};

			$("<div></div>").kendoConfirm({
	    		buttonLayout: "stretched",
	    		actions: [{
	    			text: '추가',
	    			action: function(e){
	    				//시작지점
					    	$.ajax({
					    		url : url,
					    		type : "POST",
					    		data : params,
					    		async : false,
					    		success : function(data) {

					    			GochigoAlert(data.MSG, false, "dangol365 ERP");

					    			if(data.SUCCESS)
					    				location.reload(true);

					    		}
					    	});
	    			}
	    		},
	    		{
	    			text: '취소',

	    		}],

	    		minWidth : 200,
	    		title: "dangol365 ERP",
	    	    content: "선택하신 부품을 추가하시겠습니까?()"
	    	}).data("kendoConfirm").open();
	    	//끝지점
		}

		function fnComponentContract(){

			var lisProxyPartId = [];
			var checkCnt = 0;
			for(var i = 0; i < _componentCnt; i++) {

				var checkBox = $("[id*='checkComponent_" + i +"']");
				var checked = checkBox.is(":checked");
				if(checked){
					checkCnt++;
					var row = checkBox.parent().parent();
					var consignedType = row.children().eq(3).text()*1;
					if(consignedType == 1)
						lisProxyPartId.push(row.children().eq(0).text());
				}
			}


			if(checkCnt == 0){GochigoAlert("선택된 생산대행 부품이 없습니다..", false, "dangol365 ERP"); return;}

// 			if(_selectedRow.eq(3).text() == '2'){
// 				GochigoAlert("이미 자사재고 처리된 부품입니다.", false, "dangol365 ERP");
// 				return;
// 			}

			var url = '${consignedComponentContract}';

			var params = {
					PROXY_PART_ID: lisProxyPartId.toString(),
					CONSIGNED_TYPE: 2
	    	};

			$("<div></div>").kendoConfirm({
	    		buttonLayout: "stretched",
	    		actions: [{
	    			text: '변경',
	    			action: function(e){
	    				//시작지점
					    	$.ajax({
					    		url : url,
					    		type : "POST",
					    		data : JSON.stringify(params),
					    		contentType: "application/json",
					    		async : false,
					    		success : function(data) {

					    			GochigoAlert(data.MSG, false, "dangol365 ERP");

					    			if(data.SUCCESS)
					    				location.reload(true);

					    		}
					    	});
	    			}
	    		},
	    		{
	    			text: '취소',

	    		}],
	    		minWidth : 200,
	    		title: "dangol365 ERP",
	    	    content: "선택하신 부품 중 생산대행 제품을 자사재고로 변경하시겠습니까?(입고번호는 초기화 됩니다)"
	    	}).data("kendoConfirm").open();
	    	//끝지점

		}

		function fnComponentExtract(){

			var lisProxyPartId = [];
			var checkCnt = 0;
			for(var i = 0; i < _componentCnt; i++) {

				var checkBox = $("[id*='checkComponent_" + i +"']");
				var checked = checkBox.is(":checked");
				if(checked){
					checkCnt++;
					var row = checkBox.parent().parent();
					//var consignedType = row.children().eq(3).text()*1;
					//if(consignedType == 1)
						lisProxyPartId.push(row.children().eq(0).text());
				}
			}

			if(checkCnt == 0){GochigoAlert("선택된 부품이 없습니다..", false, "dangol365 ERP"); return;}

			var url = '${consignedComponentExtract}';

			var params = {
					PROXY_PART_ID:lisProxyPartId.toString()
	    	};

			$("<div></div>").kendoConfirm({
	    		buttonLayout: "stretched",
	    		actions: [{
	    			text: '삭제',
	    			action: function(e){
	    				//시작지점
					    	$.ajax({
					    		url : url,
					    		type : "POST",
					    		data : params,
					    		async : false,
					    		success : function(data) {

					    			GochigoAlert(data.MSG, false, "dangol365 ERP");

					    			if(data.SUCCESS)
					    				location.reload(true);

					    		}
					    	});
	    			}
	    		},
	    		{
	    			text: '취소',

	    		}],
	    		minWidth : 200,
	    		title: "dangol365 ERP",
	    	    content: "선택하신 부품을 삭제하시겠습니까?"
	    	}).data("kendoConfirm").open();
	    	//끝지점

		}




		function fnChangeReceiptStatus(index) {
			console.log("CompanyList.fnChangeReceiptStatus() Load");


			var checkBox = $("[id*='receipt_status_" + index +"']");
			var checked = checkBox.is(":checked");

			if(!checked){
				checkBox.prop("checked", true);
				return;
			}


// 			if(_userType != 'M' && _userType != 'S' ){
// 				if(_rProxyId > 0){
// 					checkBox.prop("checked", false);
// 					GochigoAlert("반품처리된 접수는 변경할 수 없습니다.",false,"dangol365erp");
// 					return;
// 				}

// 				if(_proxyState == 4){
// 					checkBox.prop("checked", false);
// 					GochigoAlert("출고완료된 접수는 변경할 수 없습니다.",false,"dangol365erp");
// 					return;
// 				}
// 			}

			var checkState;
			var url = '${updateReceiptStatus}';


			if(checked){
				checkState = 1;
				msg = "생산 대행 상태를 '"+_RECEIPT_STATUS_NAME[index]+"'로 변경하시겠습니까?";
			}
			else{
				checkState = 0;
				msg = "'"+_RECEIPT_STATUS_NAME[index]+"'상태를 해제하시겠습니까?";
			}

// 			for(var k=9; k > -1; k--) {
// 				var checkId = $("[id*='receipt_status_" + k +"']");
// 				if(checkId.is(":checked")){
// 					_proxyState = k;
// 					break;
// 				}
// 			}

			var params = {
					PROXY_ID: _proxyId,
					CHECKED: checkState,
					PROXY_STATE: index,
					KEY: _RECEIPT_STATUS[index],
					KEY_NUM: index
	    	};

			if(index == 4)
				params.RELEASE_CHARGE = $('#release-sum').text();
			else
				params.RELEASE_CHARGE = 0;

			$("<div></div>").kendoConfirm({
	    		buttonLayout: "stretched",
	    		actions: [{
	    			text: '확인',
	    			action: function(e){
	    				//시작지점
					    	$.ajax({
					    		url : url,
					    		type : "POST",
					    		data : params,
					    		async : false,
					    		success : function(data) {
					    				if(index == 3)
					    					GochigoAlertReload("처리되었습니다.", true, "dangol365 ERP");
				    					else{
				    						GochigoAlert("처리되었습니다.", false, "dangol365 ERP");

						    				for(var i = 0; i < 5; i++){
							    				var checkBox = $("[id*='receipt_status_" + i +"']");

							    				if(i == index)
							    					checkBox.prop("checked", true);
							    				else
							    					checkBox.prop("checked", false);
						    				}

						    				var checkDt = $("[id*='process-info-date" + index +"']");

						    				if(checked){
						    					 var default_start_date = new Date();
						    					 checkDt.get(0).value = default_start_date.toISOString().substring(0, 10);
						    				}
						    				else
						    					checkDt.get(0).value = '';

						    				updateTooltip($("[id*='process-info-date" + index +"']"), index);

						    				console.log("index = "+index);

						    				if(index > 1 && index < 5 ){
												if(index == 4)
						    						$('#consigned_return_btn').show();
												else
													$('#consigned_return_btn').hide();
												lockComponent();
						    				}
											else{
												$('#consigned_return_btn').hide();
												unLockComponent();
											}
				    					}

					    		}
					    	});
	    			}
	    		},
	    		{
	    			text: '취소',
	    			action: function(e){
		    			if(checked){
		    				checkBox.prop("checked", false);
		    			}
		    			else{
		    				checkBox.prop("checked", true);
		    			}
	    			}

	    		}],
	    		minWidth : 200,
	    		title: "dangol365 ERP",
	    	    content: msg
	    	}).data("kendoConfirm").open();
	    	//끝지점
		}

		function fnInitConsignedDateTooltip(){
			console.log("consigned.fnInitConsignedDateTooltip() Load");

			var url = '${getConsignedDateList}';

			var params = {
	    			PROXY_ID: _proxyId
	    	};

			$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : params,
	    		async : false,
	    		success : function(data) {

	    			if(data.SUCCESS){

	    				_stateDateData[0] = data.RECEIPT_DT_LIST;
	    				_stateDateData[1] = data.PROCESS_DT_LIST;
	    				_stateDateData[2] = data.POSTPONE_DT_LIST;
	    				_stateDateData[3] = data.CANCEL_DT_LIST;
	    				_stateDateData[4] = data.RELEASE_DT_LIST;


						setTooltip($("[id*='process-info-date" + 0 +"']"), data.RECEIPT_DT_LIST, 0);
						setTooltip($("[id*='process-info-date" + 1 +"']"), data.PROCESS_DT_LIST, 1);
						setTooltip($("[id*='process-info-date" + 2 +"']"), data.POSTPONE_DT_LIST, 2);
						setTooltip($("[id*='process-info-date" + 3 +"']"), data.CANCEL_DT_LIST, 3);
						setTooltip($("[id*='process-info-date" + 4 +"']"), data.RELEASE_DT_LIST, 4);

						for(var i = 0 ; i< 5; i++)
							if(_stateDateData[i] == null)
								_stateDateData[i] = "";
	    			}
	    		}
	    	});

		}

		function setTooltip(variable, listdate, index){

			if(listdate == null)
				return;

			var tooltipText = "";
			for(var i=0; i<listdate.length; i++){
				tooltipText = tooltipText + listdate[i] + "<br>";
			}

			_stateDateData[index] = tooltipText;

			variable.kendoTooltip({
 				content: tooltipText,
				callout: false
			});
		}

		function setTooltipOnIcon(variable, context){

			var tooltipText = context;

			variable.kendoTooltip({
 				content: tooltipText,
				callout: false
			});
		}

		function updateTooltip(variable,  index){

			_stateDateData[index] =  kendo.format("{0:yyyy-MM-dd}", new Date())+ ' / ' + _userId + '<br>'+_stateDateData[index]

			variable.kendoTooltip({
 				content: _stateDateData[index],
				callout: false
			});
		}


		function fnInitConsignedLicence(){

			console.log("CompanyList.fnInitConsignedLicence() Load");

			var url = '${getLicenceInfo}';
			var params = {
	    			PROXY_ID: _proxyId
	    	};

// 			console.log("_examCheckYn = "+_examCheckYn);
			if(_examCheckYn == "Y"){

				$.ajax({
		    		url : url,
		    		type : "POST",
		    		data : params,
		    		async : false,
		    		success : function(data) {

		    			if(data.SUCCESS){

							var mbd = data.MBD;
							var cpu = data.CPU;



							if(mbd != null){
								$('#manufature_old').val(mbd.MANUFACTURE_NM);
			    				$('#manufature_new').val(mbd.MANUFACTURE_NM);

			    				$('#modelNm_old').val(mbd.MBD_MODEL_NM+"/"+mbd.PRODUCT_NAME);
			    				$('#modelNm_new').val(mbd.MBD_MODEL_NM+"/"+mbd.PRODUCT_NAME);

			    				$('#snNo_old').val(mbd.SERIAL_NO+"/"+mbd.SYSTEM_SN);
			    				$('#snNo_new').val(mbd.SERIAL_NO+"/"+mbd.SYSTEM_SN);

			    				if(data.REUSE)
			    					$('#serialId').text("제품 S/N  **반품재고");
			    				else
			    					$('#serialId').text("제품 S/N");

							}

							if(cpu != null){

								$('#cpuInfo_old').val(cpu.MODEL_NM);
			    				$('#cpuInfo_new').val(cpu.MODEL_NM);
							}
		    			}
		    		}
		    	});

			}

		}

		function fnInitRelatedConsignedData(){

			console.log("CompanyList.fnInitRelatedConsignedData() Load");

			var url = '${getRelatedConsignedInfo}';

			var params = {
	    			PROXY_ID: _proxyId,
	    			P_PROXY_ID: _pProxyId,
	    			R_PROXY_ID: _rProxyId,
	    			C_PROXY_ID: _cProxyId
	    	};

			$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : params,
	    		async : false,
	    		success : function(data) {

	    			if(data.SUCCESS){
 	    				setRelatedConsignedInfo(data.DATA);
	    			}
	    		}
	    	});
		}

		function setRelatedConsignedInfo(DATA){
			var consigned_items = DATA;

			if(consigned_items.length > 0) {

				$(".related_consigned_items").empty();

				var fontColor = 'BLUE';

				for(var i=0; i<consigned_items.length; i++) {


					var color;

					if(i%2 == 1) color = "#E6E6E6";
					else color = "#FFFFFF"



					var item = '<tr>';

					item +='<td style="display:none;">'+consigned_items[i].PROXY_ID+'</td>';

					item +='<td  class="col-title-center" style="color:'+fontColor+'; background-color:'+color+'; height: 27px; cursor: pointer;" onClick = fnShowRelatedInfo('+consigned_items[i].PROXY_ID+','+consigned_items[i].PROXY_STATE+')>'+consigned_items[i].RECEIPT+'</td>';
					item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+consigned_items[i].RECEIPT_DTS+'</td>';
					item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+consigned_items[i].CUSTOMER_NM+'</td>';
					item +='<td  class="col-title-left" style="background-color:'+color+'; height: 27px;">'+consigned_items[i].COMPANY_NM+'</td>';
					item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+consigned_items[i].PROXY_STATE_NM+'</td>';
					item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+consigned_items[i].PC_TYPE_NM+'</td>';
					item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+consigned_items[i].COMPLETE_DTS+'</td>';

					item += '</tr>';
					$(".related_consigned_items").append(item);
				}

			}
		}

		function fnShowRelatedInfo(proxyId, proxyState){


			var url = '${consignedProcess}';


			 	proxyState = proxyState * 1;
				var content;
				if(proxyState < 5){ //반품
					content = "process";
				}else{
					content = "return";
				}


				var params = {
						content: content,
						KEY: "PROXY_ID",
						VALUE: proxyId
					};

				//시작지점
				$("<div></div>").kendoConfirm({
					buttonLayout: "stretched",
					actions: [{
						text: '이동',
						action: function(e){

		 					var query = "?content="+params.content+"&KEY="+params.KEY+"&"+params.KEY+"="+params.VALUE;
		 					window.location.href = url+query;

							//끝지점
						}
					},
					{
						text: '취소'
					}],
					minWidth : 150,
					title: "DANGOL 365",
				    content: "선택한 접수 정보로 이동하시겠습니까?<br>페이지를 이동하면 저장하지 않은 정보가 사라질 수 있습니다."
				}).data("kendoConfirm").open();
				//끝지점

		}




		function fnInitConsignedData() {
			console.log("CompanyList.fnInitConsignedData() Load");

			var url = '${getConsignedInfo}';
			var params = {
	    			PROXY_ID: _proxyId
	    	};

			$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : params,
	    		async : false,
	    		success : function(data) {

	    			if(data.SUCCESS){

 	    				_proxyState = data.PROXY_STATE * 1;

 	    				_userId = data.USER_ID;
 	    				_userName = data.USER_NAME;
 	    				_userType = data.USER_TYPE;

 	    				_pProxyId = data.P_PROXY_ID * 1;
 	    		 		_rProxyId = data.R_PROXY_ID * 1;
 	    		 		_cProxyId = data.C_PROXY_ID * 1;
 	    		 		_companyId = data.COMPANY_ID;

 	    		 		_countCheck = data.COUNT_CHECK * 1;

 	    		 		_examCheckYn = data.EXAM_CHECK_YN;

 	    		 		_typeId = data.PC_TYPE;

 	    				$('#PROXY_ID').val(data.PROXY_ID);
	    				$('#RECEIPT_NO').val(data.RECEIPT);
	    				$('#datetimepicker_acceptance_date').val(data.RECEIPT_DT);
	    				$('#PC_TYPE').val(data.PC_TYPE);
	    				$('#RECEIPT_DT').val(data.RECEIPT_DT);
	    				$('#SALE_ROOT').val(data.SALE_ROOT);
	    				$("input:radio[name='RELEASE_TYPE']:radio[value='"+data.RELEASE_TYPE+"']").prop('checked', true);
	    				$('#COMPANY_ID').val(data.COMPANY_ID);
	    				$('#DES').val(data.DES);
	    				$('#REQUEST').val(data.REQUEST);
	    				$('#GUARANTEE_DUE').val(data.GUARANTEE_DUE);
	    				$('#datetimepicker_acceptance_start').val(data.GUARANTEE_START);
	    				$('#datetimepicker_acceptance_end').val(data.GUARANTEE_END);

	    				$('#CUSTOMER_NM_S').val(data.CUSTOMER_NM_S);
	    				$('#CUSTOMER_NM_R').val(data.CUSTOMER_NM_R);
	    				$('#TEL_S').val(data.TEL_S);
	    				$('#TEL_R').val(data.TEL_R);
	    				$('#MOBILE_S').val(data.MOBILE_S);
	    				$('#MOBILE_R').val(data.MOBILE_R);
	    				$('#POSTAL_CD').val(data.POSTAL_CD);
	    				$('#ADDRESS').val(data.ADDRESS);
	    				$('#ADDRESS_DETAIL').val(data.ADDRESS_DETAIL);

	    				$('#coupon_mange').val(data.COUPON_MANAGE);
 			    		$('#coupon_customer').val(data.COUPON_CUSTOMER);

 			    		$('#COA_TYPE_OLD').val(data.OLD_COA);
 			    		$('#COA_TYPE_NEW').val(data.NEW_COA);
 			    		$('#coaNo_old').val(data.OLD_COA_SN);
 			    		$('#coaNo_new').val(data.NEW_COA_SN);

	    				for(var i = 0; i < 5; i++){
		    				var checkBox = $("[id*='receipt_status_" + i +"']");

		    				if(i == data.RELEASE_STATE)
		    					checkBox.prop("checked", true);
		    				else
		    					checkBox.prop("checked", false);
	    				}


	    				if(data.RECEIPT_DT != null){
	    					$("[id*='process-info-date0']").val(data.RECEIPT_DT);
// 	    					$("[id*='receipt_status_0']").prop("checked", true);
	    				}
// 	    				else
// 	    					$("[id*='receipt_status_0']").prop("checked", false);

	    				if(data.PROCESS_DT != null){
	    					$("[id*='process-info-date1']").val(data.PROCESS_DT);
// 	    					$("[id*='receipt_status_1']").prop("checked", true);
	    				}
// 	    				else
// 	    					$("[id*='receipt_status_1']").prop("checked", false);

	    				if(data.POSTPONE_DT != null){
	    					$("[id*='process-info-date2']").val(data.POSTPONE_DT);
// 	    					$("[id*='receipt_status_2']").prop("checked", true);
	    				}
// 	    				else
// 	    					$("[id*='receipt_status_2']").prop("checked", false);

	    				if(data.CANCEL_DT != null){
	    					$("[id*='process-info-date3']").val(data.CANCEL_DT);
// 	    					$("[id*='receipt_status_3']").prop("checked", true);
	    				}
// 	    				else
// 	    					$("[id*='receipt_status_3']").prop("checked", false);

	    				if(data.RELEASE_DT != null){
	    					$("[id*='process-info-date4']").val(data.RELEASE_DT);
// 	    					$("[id*='receipt_status_4']").prop("checked", true);
	    				}
// 	    				else
// 	    					$("[id*='receipt_status_4']").prop("checked", false);

	    				$('#coupon_mange').val(data.COUPON_MANAGE);
// 	    				$('#coupon_customer').val(data.COUPON_CUSTOMER);

	    				var returnYn = data.RETURN_YN * 1;
	    				//if(returnYn == 1){

// 	    					$('#processInfo').css("width", "31.4%");
// 	    					$('#returnInfo').show();
// 	    					$('#return_header').show();
// 	    					$('#tbl_consigned_return_info_data').show();
// 	    					$('#consigned_return_btn').hide();

							if(data.RELEASE_STATE == 4){
								if(data.RETURN_REQUEST_DT == null)
									$('#consigned_return_btn').show();
								else
									$('#consigned_return_btn').hide();

							}

		    				if(data.RETURN_REQUEST_DT != null){
		    					$("[id*='process-info-date5']").val(data.RETURN_REQUEST_DT);
		    					$("[id*='receipt_status_5']").prop("checked", true);
		    					$('#consigned_return_btn').hide();
		    				}
		    				else
		    					$("[id*='receipt_status_5']").prop("checked", false);

		    				if(data.RETURN_IN_DT != null){
		    					$("[id*='process-info-date6']").val(data.RETURN_IN_DT);
		    					$("[id*='receipt_status_6']").prop("checked", true);
		    				}
		    				else
		    					$("[id*='receipt_status_6']").prop("checked", false);

		    				if(data.EXCHANGE_DT != null){
		    					$("[id*='process-info-date7']").val(data.EXCHANGE_DT);
		    					$("[id*='receipt_status_7']").prop("checked", true);
		    				}
		    				else
		    					$("[id*='receipt_status_7']").prop("checked", false);

		    				if(data.RETURN_CANCEL_DT != null){
		    					$("[id*='process-info-date8']").val(data.RETURN_CANCEL_DT);
		    					$("[id*='receipt_status_8']").prop("checked", true);
		    				}
		    				else
		    					$("[id*='receipt_status_8']").prop("checked", false);


		    				if(data.RETURN_COMPLETE_DT != null){
		    					$("[id*='process-info-date9']").val(data.RETURN_COMPLETE_DT);
		    					$("[id*='receipt_status_9']").prop("checked", true);
		    				}
		    				else
		    					$("[id*='receipt_status_9']").prop("checked", false);
	    				//}

		    				var listInvoice = data.INVOICE;

		    				if(listInvoice.length >0){

		    					var deliveryCnt = listInvoice.length;
		    					var deliveryCompany = listInvoice[0].COMPANY_NM;
		    					var deliveryInvoice = listInvoice[0].INVOICE;


		    					if(deliveryCnt == 1){
		    						$('#delivery_type').val(deliveryCompany);
		    						$('#delivery_invoice').val(deliveryInvoice);
		    					}
		    					else{
		    						$('#delivery_type').val(deliveryCompany);
		    						$('#delivery_invoice').val(deliveryInvoice + ' 외 ' + (deliveryCnt-1) + '건');
		    					}
		    				}

		    				setConsignedComponent(data.DATA);
	    			}
	    		}
	    	});
		}

		function fnInitConsignedAdjust() {
			console.log("CompanyList.fnInitConsignedAdjust() Load");

			var url = '${getConsignedAdjustInfo}';

			var params = {
	    			PROXY_ID: _proxyId,
	    			COMPANY_ID: _companyId,
	    			ADJUSTMENT_TYPE: 1,
	    			TYPE_ID: _typeId
	    	};

			$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : params,
	    		async : false,
	    		success : function(data) {

	    			_stateDateData[31] = "";

	    			if(data.SUCCESS){

	    				var price = data.PRICE *1;
	    				if(price > -1){
		    				$("#original_price").val('￦'+data.PRICE);
		    				$("#original_price").text(data.PRICE);
	    				}

	    				$('#price-produce-input').val(data.PRICE_PRODUCE);
// 	    				document.getElementById("price-produce-select").style.display = "none";
// 	    				document.getElementById("price-produce-input").style.display = "block";

	    				$('#price-reproduce-input').val(data.PRICE_REPRODUCE);
// 	    				document.getElementById("price-reproduce-select").style.display = "none";
// 	    				document.getElementById("price-reproduce-input").style.display = "block";

	    				$('#price-delivery-input').val(data.PRICE_DEILIVERY);
// 	    				document.getElementById("price-delivery-select").style.display = "none";
// 	    				document.getElementById("price-delivery-input").style.display = "block";

	    				$('#price-quick-input').val(data.PRICE_QUICK);
// 	    				document.getElementById("price-quick-select").style.display = "none";
// 	    				document.getElementById("price-quick-input").style.display = "block";

	    				$('#release-dt1').val(data.REGISTER_DT);

	    				$('#registerDt-history').val(data.REGISTER_HISTORY);

	    				_stateDateData[31] = data.REGISTER_DT_LIST;

 	    				setTooltip($("[id*='release-dt" + 1 +"']"), data.REGISTER_DT_LIST, 30+1);
// 	    				setTooltip($("[id*='registerDt-history']"), data.REGISTER_DT_LIST, 30);

						if(_stateDateData[31] == null)
							_stateDateData[31] = "";
	    			}
	    			else{
	    				if(data.DEFAULT){

	    					$('#price-produce-input').val(data.PRICE_PRODUCE);
// 		    				document.getElementById("price-produce-select").style.display = "none";
// 		    				document.getElementById("price-produce-input").style.display = "block";

		    				$('#price-reproduce-input').val(data.PRICE_REPRODUCE);
// 		    				document.getElementById("price-reproduce-select").style.display = "none";
// 		    				document.getElementById("price-reproduce-input").style.display = "block";

		    				$('#price-delivery-input').val(data.PRICE_DEILIVERY);
// 		    				document.getElementById("price-delivery-select").style.display = "none";
// 		    				document.getElementById("price-delivery-input").style.display = "block";

		    				$('#price-quick-input').val(data.PRICE_QUICK);
// 		    				document.getElementById("price-quick-select").style.display = "none";
// 		    				document.getElementById("price-quick-input").style.display = "block";



	    				}
	    			}

	    			fnComputeReleaseSum()

	    		}
	    	});
		}

		function fnInitConsignedComponent() {
			console.log("CompanyList.fnInitConsignedComponent() Load");

			var url = '${getConsignedComponentFullInfo}';

			var params = {
	    			PROXY_ID: _proxyId,
	    			COMPANY_ID: _companyId
	    	};

			$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : params,
	    		async : false,
	    		success : function(data) {

	    			if(data.SUCCESS){

	    				setConsignedComponent(data.DATA);
	    				fnComputeReleaseSum();
	    				//setTableRowClickEvent();
	    			}
	    		}
	    	});
		}


	function setConsignedComponent(DATA){
		var consigned_items = DATA;
		var totalCnt = 0;
		var totalReleaseCnt = 0;
		var totalReleasePrice = 0;

		_componentInfo = [];
		_componentCnt = consigned_items.length;

		$(".consigned_items").empty();

		if(consigned_items.length > 0) {

			for(var i=0; i<consigned_items.length; i++) {

				_componentInfo[i] = consigned_items[i];

				var componentId = consigned_items[i].COMPONENT_ID;
				var componentCd = consigned_items[i].COMPONENT_CD;

				var color;

				var fontColor;

				if(i%2 == 1) color = "#E6E6E6";
				else color = "#FFFFFF"

				var componentCnt = consigned_items[i].COMPONENT_CNT;
				var releaseCnt = consigned_items[i].RELEASE_CNT * 1;
				var asignYn = releaseCnt == 1? 'O':'X';
				var readonly = releaseCnt == 0? 'readonly="readonly"':'';
				var price = consigned_items[i].PROXY_PRICE;
// 				if(price == '' || price == null) price = 0;
// 				var totalPrice = price * releaseCnt;
				price += "";
				totalPrice += "";

				totalCnt += (componentCnt *1) ;
				totalReleaseCnt += releaseCnt ;
				totalReleasePrice += (price*1);

				var consignedType = consigned_items[i].CONSIGNED_TYPE;
				var proxyPartId = consigned_items[i].PROXY_PART_ID;

				if(consignedType == 2)
					fontColor = 'RED';
				else
					fontColor = 'BLACK';


				var item = '<tr>';

				item +='<td style="display:none;">'+proxyPartId+'</td>';
				item +='<td style="display:none;">'+consigned_items[i].PROXY_ID+'</td>';
				item +='<td style="display:none;">'+consigned_items[i].COMPONENT_ID+'</td>';
				item +='<td style="display:none;">'+consigned_items[i].CONSIGNED_TYPE+'</td>';


				item +='<td ><input type="checkbox" id="checkComponent_'+i+'" unchecked></td>';
				item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+';">'+componentCd+'</td>';
				item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+';">'+consigned_items[i].DETAIL_DATA+'</td>';
// 				item +='<td><input id="componentId-cnt-'+componentCd+'-'+componentId+'-'+consignedType+'" type="number" onchange="numberWithCommas('+proxyPartId+',this.value)" class="view k-textbox col-input-number" value="'+componentCnt+'" min="0" max="999" style="color:'+fontColor+'; background-color:'+color+';"></td>';
				item +='<td><input id="componentId-releasecnt-'+componentCd+'-'+consignedType+'" type="text" class="view k-textbox col-input-normal" value="'+asignYn+'" style="color:'+fontColor+'; background-color:'+color+';" readonly="readonly"></td>';
				item +='<td><input id="price_'+proxyPartId+'" type="text" class="view k-textbox col-input-number-price" onchange="priceWithCommas('+proxyPartId+','+releaseCnt+', this.value)" value="'+price.replace(/\B(?=(\d{3})+(?!\d))/g, ",")+'" style="padding-right:5px; color:'+fontColor+'; background-color:'+color+';" '+readonly+' ></td>';
// 				item +='<td><input id="total_price_'+proxyPartId+'" type="text" class="view k-textbox col-input-number-totalPrice" value="'+totalPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ",")+'" style="padding-right:5px; color:'+fontColor+'; background-color:'+color+';" readonly="readonly"></td>';

				item +='<td style="display:none;">' + componentId + '</td>';
				item += '</tr>';
				$(".consigned_items").append(item);
			}

		}
		totalReleasePrice = totalReleasePrice+"";
		$("#numOfComponent").text("TOTAL: "+consigned_items.length+" EA");
		$("#numOfRelease").text("합계: "+totalReleaseCnt+" EA");
		$("#totalPrice").text("합계: "+'￦ '+totalReleasePrice.replace(/\B(?=(\d{3})+(?!\d))/g, ","));

		$("#original_price").val('￦'+totalReleasePrice.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		$("#original_price").text(totalReleasePrice);
		//computeTotalPrice();
		//fnComputeReleaseSum();

// 		$("#tbl_consigned_receipt_product_data").click(function(){
// // 			$(this).toggleClass("clicked");
// 		});
	}

	function fnUpdateComponentUnit(proxyPartId, componentCnt){

    	var params = {
    			PROXY_PART_ID: proxyPartId,
    			COMPONENT_CNT: componentCnt,
    	}

   		var url = '${updateProxyComponentUnit}';

    	$.ajax({
    		url : url,
    		type : "POST",
    		data : JSON.stringify(params),
    		contentType: "application/json",
    		async : false,
    		success : function(data) {
			}
    	});

    }

	function fnUpdateReleaseInventoryPrice(proxyPartId, price){

    	var params = {
    			PROXY_PART_ID: proxyPartId,
    			PRICE: price,
    	}

   		var url = '${updatePrice}';

    	$.ajax({
    		url : url,
    		type : "POST",
    		data : JSON.stringify(params),
    		contentType: "application/json",
    		async : false,
    		success : function(data) {
			}
    	});

    }


	function priceWithCommas(proxyPartId, asign, x) {
		if(asign > 0){
			fnUpdateReleaseInventoryPrice(proxyPartId, x);
			var price = x.replace(/\B(?=(\d{3})+(?!\d))/g, ",")
			$("#price_"+proxyPartId).val(price);
			$("#total_price_"+proxyPartId).val(price);
			$("#price_"+proxyPartId).text(x);
			$("#total_price_"+proxyPartId).text(x);

	 		computePrice();
	 		fnComputeReleaseSum();
		}else{
			$("#price_"+proxyPartId).val(0);
			$("#price_"+proxyPartId).text(0);
		}
	}



	function numberWithCommas(proxyPartId, x) {
		fnUpdateComponentUnit(proxyPartId, x);

// 		var id = $('#price_'+componentId+'-'+consignedType);
// 		var price = parseInt(id.val().replace(/,/g,"")) * x;
// 		price += "";
// 		var toatalPriceId = $('#total_price_'+componentId+'-'+consignedType);

// 		toatalPriceId.val(price.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); // 정규식을 이용해서 3자리 마다 , 추가

		computeCnt();
//  		computeTotalPrice();
	}

	function computeCnt(){
		var totalCnt = 0;
		var inputs = $(".col-input-number");
		for(var i=0; i<inputs.length; i++) {
			var component = $(".col-input-number")[i];
			var cnt = component.value * 1;
			totalCnt += cnt;
		}

		$("#numOfInventory").text("합계: "+totalCnt+" EA");
	}

	function computePrice(){
		var totalPrice= 0;
		var inputs = $(".col-input-number-price");
		for(var i=0; i<inputs.length; i++) {
			var component = $(".col-input-number-price")[i];
			var price = component.value;
			totalPrice += (parseInt(price.replace(/,/g,""))*1);
		}

		var price = totalPrice+"";

		$("#totalPrice").text("합계: "+'￦ '+price.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		$("#original_price").val('￦'+price.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		$("#original_price").text(totalPrice);
	}

	function computeTotalPrice(){
		var totalPrice= 0;
		var inputs = $(".col-input-number-totalPrice");
		for(var i=0; i<inputs.length; i++) {
			var component = $(".col-input-number-totalPrice")[i];
			var price = component.value;
			totalPrice += (parseInt(price.replace(/,/g,""))*1);
		}

		var price = totalPrice+"";
		var price = price.replace(/\B(?=(\d{3})+(?!\d))/g, ",");

		$("#original_price").val('￦'+price);
		$("#original_price").text(totalPrice);
	}

	function original_price_change()
	{
		var value = $("#original_price").val();
		var price = value.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		$("#original_price").val('￦'+price);
		$("#original_price").text(value);

		fnComputeReleaseSum();
// 		console.log(value);
	}


    function fnInitData() {

    	console.log("CompanyList.fnCompanyInsert() Load");

    	var url = '${getCodeListCustom}';

    	var isSuccess = false;

    	var listCode = [];
    	listCode.push("CD0903");	// PC_TYPE
    	listCode.push("CD0905");	//SALE_ROOT
    	listCode.push("CD0906");	//GUARANTEE_DUE


    	var listCustom = [];
    	listCustom.push("TN_MODEL_LIST");
    	listCustom.push("TN_COMPANY_MST"); //COMPANY_ID

    	var listCustomKey = [];
    	listCustomKey.push("MODEL_NM");
    	listCustomKey.push("MODEL_LIST_ID");
    	listCustomKey.push("COMPANY_NM");
    	listCustomKey.push("COMPANY_ID");

    	var listCustomContition = [];
    	listCustomContition.push("1=1");
    	listCustomContition.push("COMPANY_TYPE = 'C'");

    	var listCustomOrder = [];
    	listCustomOrder.push("MODEL_LIST_ID");
    	listCustomOrder.push("COMPANY_ID");

    	var params = {
    			CODE: listCode.toString(),
    			CUSTOM: listCustom.toString(),
    			CUSTOM_KEY: listCustomKey.toString(),
    			CUSTOM_CONDITION: listCustomContition.toString(),
    			CUSTOM_ORDER: listCustomOrder.toString(),
    	};


    	$.ajax({
    		url : url,
    		type : "POST",
    		data : params,
    		async : false,
    		success : function(data) {
    			var listPCType = data.CD0903;
     			for(var i=0; i<listPCType.length; i++)
     				$("#PC_TYPE").append('<option value="' + listPCType[i].V+ '">' + listPCType[i].K+ '</option>');

     			var listSaleRoot = data.CD0905;
     			for(var i=0; i<listSaleRoot.length; i++)
     				$("#SALE_ROOT").append('<option value="' + listSaleRoot[i].V+ '">' + listSaleRoot[i].K+ '</option>');

     			var listguaranteeTerm = data.CD0906;
     			for(var i=0; i<listguaranteeTerm.length; i++)
     				$("#GUARANTEE_DUE").append('<option value="' + listguaranteeTerm[i].V+ '">' + listguaranteeTerm[i].K+ '</option>');

//      			var listModelCd = data.TN_MODEL_LIST;
//      			for(var i=0; i<listModelCd.length; i++)
//      				$("#MODEL_CD").append('<option value="' + listModelCd[i].V+ '">' + listModelCd[i].K+ '</option>');

     			var listCompanyId = data.TN_COMPANY_MST;
     			for(var i=0; i<listCompanyId.length; i++)
     				$("#COMPANY_ID").append('<option value="' + listCompanyId[i].V+ '">' + listCompanyId[i].K+ '</option>');
    		}
    	});
    }

    function getParameterByName(name) {
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
				results = regex.exec(location.search);
		return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	}

    function fnCopyUserInfo(){
    	if($("#chCopyUserInfo").is(":checked")){
    		var customerNmS = $('#CUSTOMER_NM_S').val();

        	$('#CUSTOMER_NM_R').val(customerNmS);
        	var TelS = $('#TEL_S').val();
        	$('#TEL_R').val(TelS);

        	var mobileS = $('#MOBILE_S').val();
        	$('#MOBILE_R').val(mobileS);
        }

    }

    function fnReturnOrder(){
    	var url = '${returnReceipt}';

    	var query = "UPDATE TN_PROXY SET RETURN_YN = 1, COMPLETE_DT = NULL,  PROXY_STATE = 5, RETURN_REQUEST_DT = NOW(), UPDATE_USER_ID = '{USER_ID}', UPDATE_DT = NOW() WHERE PROXY_ID = "+_proxyId;

    	var params = {
    			PROXY_ID : _proxyId
//         		QUERY:  query
    	}

   		$("<div></div>").kendoConfirm({
    		buttonLayout: "stretched",
    		actions: [{
    			text: '확인',
    			action: function(e){
    				//시작지점
				    	$.ajax({
				    		url : url,
				    		type : "POST",
				    		data : params,
				    		async : false,
				    		success : function(data) {
				    				GochigoAlert("반품요청되었습니다.", false, "dangol365 ERP");

// 				    				$('#processInfo').css("width", "31.4%");
// 			    					$('#returnInfo').show();
// 			    					$('#return_header').show();
// 			    					$('#tbl_consigned_return_info_data').show();
// 			    					$('#consigned_return_btn').hide();

// 			    					$("[id*='receipt_status_6']").prop("checked", true);
// 			    					var default_start_date = new Date();
// 			    					$("[id*='process-info-date6']").get(0).value = default_start_date.toISOString().substring(0, 10);

									var _newProxyId = data.PROXY_ID;
				    				var url = '${consignedProcess}';

			    					var newParams = {
			    							content: "return",
			    							KEY: "PROXY_ID",
			    							VALUE: _newProxyId
			    						};

				    					var query = "?content="+newParams.content+"&KEY="+newParams.KEY+"&"+newParams.KEY+"="+newParams.VALUE;
				    					window.location.href = url+query;
				    		}
				    	});
    			}
    		},
    		{
    			text: '취소'
    		}],
    		minWidth : 200,
    		title: "dangol365 ERP",
    	    content: "반품요청하시겠습니까?"
    	}).data("kendoConfirm").open();
    	//끝지점
    }

    function fnUpdateAdjust(){

		 var today = new Date().toISOString().substring(0, 10);

		 var price;
    	var priceProduce;
    	var priceReproduce;
    	var priceDelivery;
    	var priceQuick;
    	var releaseDt;


    	price =$('#original_price').text()*1;

    	if(document.getElementById("price-produce-select").style.display === "none")
    		priceProduce = $('#price-produce-input').val()*1;
		else
		 	priceProduce = $('#price-produce-select').val()*1;

		if(priceProduce == '')
			priceProduce = 0;

		if(document.getElementById("price-reproduce-select").style.display === "none")
			priceReproduce = $('#price-reproduce-input').val()*1;
		else
			priceReproduce = $('#price-reproduce-select').val()*1;

		if(priceReproduce == '')
			priceReproduce = 0;

		if(document.getElementById("price-delivery-select").style.display === "none")
			priceDelivery = $('#price-delivery-input').val()*1;
		else
			priceDelivery = $('#price-delivery-select').val()*1;

		if(priceDelivery == '')
			priceDelivery = 0;

		if(document.getElementById("price-quick-select").style.display === "none")
			priceQuick = $('#price-quick-input').val()*1;
		else
			priceQuick = $('#price-quick-select').val()*1;

		if(priceQuick == '')
			priceQuick = 0;


// 		 checkDt.get(0).value = default_start_date.toISOString().substring(0, 10);

		releaseDt = $('#release-dt1').val();

		if(releaseDt == '')
			releaseDt = today;



    	var params = {
    		PROXY_ID:  _proxyId,
    		ADJUSTMENT_TYPE: 1,
    		PRICE: price,
    		PRICE_PRODUCE: priceProduce,
    		PRICE_REPRODUCE: priceReproduce,
    		PRICE_DEILIVERY: priceDelivery,
    		PRICE_QUICK: priceQuick,
    		REGISTER_DT: releaseDt
    	}

   		var url = '${updateAdjust}';

   		$("<div></div>").kendoConfirm({
    		buttonLayout: "stretched",
    		actions: [{
    			text: '확인',
    			action: function(e){
    				//시작지점
				    	$.ajax({
				    		url : url,
				    		type : "POST",
				    		data : JSON.stringify(params),
				    		contentType: "application/json",
				    		async : false,
				    		success : function(data) {
				    				GochigoAlert("수정되었습니다.", false, "dangol365 ERP");

				    				$('#release-dt1').value = releaseDt;

				    				if($('#registerDt-history').val() == '')
				    					$('#registerDt-history').val(releaseDt);
				    				else
				    					$('#registerDt-history').val($('#registerDt-history').val()+'/'+releaseDt);

				    				updateTooltip($("[id*='release-dt" + 1 +"']"), 31);
				    		}
				    	});
    			}
    		},
    		{
    			text: '취소'
    		}],
    		minWidth : 200,
    		title: "dangol365 ERP",
    	    content: "수정하시겠습니까?"
    	}).data("kendoConfirm").open();
    	//끝지점

    }


    function fnUpdateOrder(){

    	var customerNmS = $('#CUSTOMER_NM_S').val();
    	var customerNmR = $('#CUSTOMER_NM_R').val();
    	var TelS = $('#TEL_S').val();
    	var TelR = $('#TEL_R').val();
    	var mobileS = $('#MOBILE_S').val();
    	var mobileR = $('#MOBILE_R').val();
    	var postalCd = $('#POSTAL_CD').val();
    	var address = $('#ADDRESS').val();
    	var addressDetail = $('#ADDRESS_DETAIL').val();

    	var couponManage = $('#coupon_mange').val();
    	var couponCustomer = $('#coupon_customer').val();

    	if(customerNmS == ''){
    		GochigoAlertCollback('고객명[1]은 필수 정보입니다.', false, "dangol365 ERP", "CUSTOMER_NM_S");
        	return;
    	}
    	if(TelS == '' && mobileS== ''){
    		GochigoAlertCollback('전화번호[1]과 휴대폰[1] 중 하나는 필수 정보입니다.', false, "dangol365 ERP", "MOBILE_S");
        	return;
    	}
    	if(customerNmR == ''){
         	GochigoAlertCollback('고객명[2]는 필수 정보입니다..', false, "dangol365 ERP", "CUSTOMER_NM_R");
        	return;
    	}
    	if(TelR == '' && mobileR== ''){
         	GochigoAlertCollback('전화번호[2]와 휴대폰[2] 중 하나는 필수 정보입니다.', false, "dangol365 ERP", "MOBILE_R");
        	return;
    	}
    	if(postalCd == ''){
         	GochigoAlertCollback('주소는 필수 정보입니다.', false, "dangol365 ERP", "searchBtn_postalCode");
        	return;
    	}
    	if(addressDetail == ''){
         	GochigoAlertCollback('상세 주소를 입력하세요.', false, "dangol365 ERP", "ADDRESS_DETAIL");
        	return;
    	}

//      	var listComponent = new Array();
//     	var inputs = $(".col-input-number");

// 		for(var i=0; i<inputs.length; i++) {
// 			var component = $(".col-input-number")[i];
// 			var cnt = component.value;
// 			var id = component.id;
// 			var componentId = id.substr(20);
// 			var vomponentCd = id.substr(16,3);

// 			var params = {
// 		    		COMPONENT_ID:componentId,
// 		    		COMPONENT_CD: vomponentCd,
// 		    		COMPONENT_CNT: cnt
// 			}

// 			listComponent.push(params);
// 		}


    	var params = {
    		PROXY_ID:  _proxyId,
    		RECEIPT_NO: $('#RECEIPT_NO').val(),
    		PC_TYPE: $('#PC_TYPE').val(),
    		GUARANTEE_DUE: $('#GUARANTEE_DUE').val(),
    		GUARANTEE_START: $('#datetimepicker_acceptance_start').val(),
    		GUARANTEE_END: $('#datetimepicker_acceptance_end').val(),

    		COMPANY_ID: $('#COMPANY_ID').val(),
    		SALE_ROOT: $('#SALE_ROOT').val(),
    		RELEASE_TYPE: $('input[name="RELEASE_TYPE"]:checked').val(),
    		DES: $('#DES').val(),
    		REQUEST: $('#REQUEST').val(),

    		CUSTOMER_NM_S: customerNmS,
    		CUSTOMER_NM_R: customerNmR,
    		TEL_S: TelS,
    		TEL_R: TelR,
    		MOBILE_S: mobileS,
    		MOBILE_R: mobileR,
    		POSTAL_CD: postalCd,
    		ADDRESS: address,
    		ADDRESS_DETAIL: addressDetail,

//     		DATA: listComponent
    	}

    	if(couponManage != ''){
    		params.COUPON_MANAGE = couponManage;
    	}
    	if(couponCustomer != ''){
    		params.COUPON_CUSTOMER = couponCustomer;
    	}

   		var url = '${updateReceipt}';

   		$("<div></div>").kendoConfirm({
    		buttonLayout: "stretched",
    		actions: [{
    			text: '확인',
    			action: function(e){
    				//시작지점
				    	$.ajax({
				    		url : url,
				    		type : "POST",
				    		data : JSON.stringify(params),
				    		contentType: "application/json",
				    		async : false,
				    		success : function(data) {
				    				GochigoAlert("수정되었습니다.", false, "dangol365 ERP");

				    				$('#coupon_mange').attr("readonly",true);
				    				$('#coupon_customer').attr("readonly",true);

				    				$('#coupon_mange').css("background","#ebebf5");
				    				$('#coupon_customer').css("background","#ebebf5");

				    		}
				    	});
    			}
    		},
    		{
    			text: '취소'
    		}],
    		minWidth : 200,
    		title: "dangol365 ERP",
    	    content: "수정하시겠습니까?"
    	}).data("kendoConfirm").open();
    	//끝지점

    }

      function changeGuaranteeTerm(value) {

          var default_period_month = value;
          var default_start_date = new Date();
          var default_end_date = new Date();
          default_end_date.setMonth(parseInt(default_end_date.getMonth()) + parseInt(default_period_month));

          $("#datetimepicker_acceptance_start").get(0).value = default_start_date.toISOString().substring(0, 10);
          $("#datetimepicker_acceptance_end").get(0).value = default_end_date.toISOString().substring(0, 10);
      }

      function changeGuaranteeDate() {
			var e = document.getElementById("GUARANTEE_TERM");
// 			var selectedOption = e.options[e.selectedIndex].value;
		}


		function fnSearchZipCode() {
			new daum.Postcode({
				oncomplete: function(data) {
					document.getElementById('POSTAL_CD').value = data.zonecode;
					document.getElementById('ADDRESS').value = data.address;
				}
			}).open();
		}

		function fnModifCoupon() {

			$('#couponEditBtn').hide();
			$('#couponSaveBtn').show();


			$('#coupon_mange').attr("readonly",false);
			$('#coupon_customer').attr("readonly",false);

			$('#coupon_mange').css("background","#FFFFFF");
			$('#coupon_customer').css("background","#FFFFFF");
		}

		function fnSaveCoupon() {

			$('#couponEditBtn').show();
			$('#couponSaveBtn').hide();


			$('#coupon_mange').attr("readonly",true);
			$('#coupon_customer').attr("readonly",true);

			$('#coupon_mange').css("background","#ebebf5");
			$('#coupon_customer').css("background","#ebebf5");


			var url = '${consignedUpdateDetail}';

			var params = {
		    		PROXY_ID:  _proxyId,
		    		COUPON_MANAGE: $('#coupon_mange').val(),
		    		COUPON_CUSTOMER: $('#coupon_customer').val()
		    	}

		    	$.ajax({
		    		url : url,
		    		type : "POST",
		    		data : JSON.stringify(params),
		    		contentType: "application/json",
		    		async : false,
		    		success : function(data) {

		    		}
		    	});
		}

		function fnModifSN() {

			$('#SNEditBtn').hide();
			$('#SNSaveBtn').show();


			$('#COA_TYPE_OLD').removeAttr("disabled");
			$('#COA_TYPE_NEW').removeAttr("disabled");

			$('#coaNo_old').attr("readonly",false);
			$('#coaNo_new').attr("readonly",false);
			$('#snNo_new').attr("readonly",false);

		}

		function fnSaveSN() {

			$('#SNEditBtn').show();
			$('#SNSaveBtn').hide();


			$('#COA_TYPE_OLD').attr("disabled","disabled");
			$('#COA_TYPE_NEW').attr("disabled","disabled");

			$('#coaNo_old').attr("readonly",true);
			$('#coaNo_new').attr("readonly",true);
			$('#snNo_new').attr("readonly",true);

			var url = '${consignedUpdateDetail}';

			var params = {
		    		PROXY_ID:  _proxyId,
		    		OLD_COA: $('#COA_TYPE_OLD').val(),
		    		NEW_COA: $('#COA_TYPE_NEW').val(),
		    		OLD_COA_SN: $('#coaNo_old').val(),
		    		NEW_COA_SN: $('#coaNo_new').val()

		    	}

			var isSame = $('#snNo_old').val() == $('#snNo_new').val();

			if(!isSame)
				params.SERIAL_NO = $('#snNo_new').val();

		    	$.ajax({
		    		url : url,
		    		type : "POST",
		    		data : JSON.stringify(params),
		    		contentType: "application/json",
		    		async : false,
		    		success : function(data) {
		    			if(!isSame)
		    				$('#snNo_old').val($('#snNo_new').val());

		    		}
		    	});
		}




		function fnDeliveryInvoice () {

			var url = '${consignedPopup}';

			var query = "?content=deliveryInvoice&KEY=PROXY_ID&PROXY_ID="+_proxyId;

			var width, height;
		    	width = "700";
		    	height = "540";


			var xPos  = (document.body.clientWidth /2) - (width / 2);
		    xPos += window.screenLeft;
		    var yPos  = (screen.availHeight / 2) - (height / 2);

		    window.open("<c:url value='"+url+query+"'/>", "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
		}

		function fnModifComponent() {

			var url = '${consignedPopup}';

			var query = "?content=component&KEY=PROXY_ID&PROXY_ID="+_proxyId+"&KEY1=RECEIPT&RECEIPT="+$('#RECEIPT_NO').val()+"&KEY2=COMPANY_ID&COMPANY_ID="+$('#COMPANY_ID').val();

			var width, height;

			width = "1600";
	    	height = "800";

			var xPos  = (document.body.clientWidth /2) - (width / 2);
		    xPos += window.screenLeft;
		    var yPos  = (screen.availHeight / 2) - (height / 2);

		    window.open("<c:url value='"+url+query+"'/>", "componentModif", "top="+yPos+", left="+xPos+", width="+width+", height="+height);

		}

		function toggleInputType(inputId) {

			var target_selectbox = document.getElementById(inputId+"-select");
			var target_input = document.getElementById(inputId+"-input");
			if(target_selectbox.style.display === "none") {
				target_selectbox.style.display = "block";
			} else {
				target_selectbox.style.display = "none";
			}
			if(target_input.style.display === "none") {
				target_input.style.display = "block";
			} else {
				target_input.style.display = "none";
			}

			fnComputeReleaseSum();
		}

		function fnCompareReleaseComponent() {

			var url = '${consignedPopup}';

			var query = "?content=releaseCompare&KEY=PROXY_ID&PROXY_ID="+_proxyId+"&KEY1=RECEIPT&RECEIPT="+$('#RECEIPT_NO').val()+"&KEY2=COMPANY_ID&COMPANY_ID="+$('#COMPANY_ID').val()+"&KEY3=COUNT_CHECK&COUNT_CHECK="+_countCheck;

			var width, height;

			width = "1600";
	    	height = "650";

			var xPos  = (document.body.clientWidth /2) - (width / 2);
		    xPos += window.screenLeft;
		    var yPos  = (screen.availHeight / 2) - (height / 2);

		    window.open("<c:url value='"+url+query+"'/>", "compareReleaseComponent", "top="+yPos+", left="+xPos+", width="+width+", height="+height);

		}

		function toggleInputType(inputId) {

			var target_selectbox = document.getElementById(inputId+"-select");
			var target_input = document.getElementById(inputId+"-input");
			if(target_selectbox.style.display === "none") {
				target_selectbox.style.display = "block";
			} else {
				target_selectbox.style.display = "none";
			}
			if(target_input.style.display === "none") {
				target_input.style.display = "block";
			} else {
				target_input.style.display = "none";
			}

			fnComputeReleaseSum();
		}


		function fnComputeReleaseSum()
		{
// 			release-sum

				var originalPrice;
		    	var priceProduce;
		    	var priceReproduce;
		    	var priceDelivery;
		    	var priceQuick;

		    	originalPrice = $('#original_price').text()*1;


		    	if(document.getElementById("price-produce-select").style.display === "none")
		    		priceProduce = $('#price-produce-input').val()*1;
				else
				 	priceProduce = $('#price-produce-select').val()*1;

				if(priceProduce == '')
					priceProduce = 0;

				if(document.getElementById("price-reproduce-select").style.display === "none")
					priceReproduce = $('#price-reproduce-input').val()*1;
				else
					priceReproduce = $('#price-reproduce-select').val()*1;

				if(priceReproduce == '')
					priceReproduce = 0;

				if(document.getElementById("price-delivery-select").style.display === "none")
					priceDelivery = $('#price-delivery-input').val()*1;
				else
					priceDelivery = $('#price-delivery-select').val()*1;

				if(priceDelivery == '')
					priceDelivery = 0;

				if(document.getElementById("price-quick-select").style.display === "none")
					priceQuick = $('#price-quick-input').val()*1;
				else
					priceQuick = $('#price-quick-select').val()*1;

				if(priceQuick == '')
					priceQuick = 0;

				var sum =originalPrice +  priceProduce + priceReproduce + priceDelivery + priceQuick ;
				sum += '';
				$('#release-sum').text(sum);
				$('#release-sum').val('￦'+sum.replace(/\B(?=(\d{3})+(?!\d))/g, ","));

		}



		function fnGoReceiptList(){
			 var newUrl = '/layout.do?xn=consigned_All_LAYOUT';
			 window.location.href = newUrl;
		}

		function fnNewReceipt(){
			var newUrl = '/layoutCustom.do?content=receipt';
			 window.location.href = newUrl;
		}

	</script>

</head>

<body>

	<div id="content" data-role="splitter" class="k-widget k-splitter content">

		<div class="header_title">
			<span class="pagetitle"><span class="header-title30"></span> 생산대행 - 처리 </span>
		</div>

		<div id="consigned_receipt_btns" class="grid_btns_short" style="width: 100%">

			<button id="btnNewReceipt" onclick="fnNewReceipt()" class="k-button" style="float: left; width: 40px; background-color: slategray; margin-top:5px;margin-left:20px; padding: 3px 7px 3px 7px; font-size: 12px;">\
				<span class="k-icon k-i-track-changes" style="float: right; font-size: 18px; color: white;"></span>
			</button>
			<button id="btnGoReceiptList"  onclick="fnGoReceiptList()" class="k-button" style="float: left; width: 40px; background-color: slategray; margin-top:5px;margin-left:10px; padding: 3px 7px 3px 7px; font-size: 12px;">
				<span class="k-icon k-i-table" style="float: right; font-size: 18px; color: white;"></span>
			</button>

			<button id="consigned_return_btn" type="button" onclick="fnReturnOrder()" class="k-button" style="float: right; display:none;">반품 요청</button>
			<button id="consigned_receipt_cancel_btn" type="button" onclick="fnUpdateOrder()" class="k-button" style="float: right;">정보 수정</button>
			<button id="consigned_Joborder_printBtn" type="button" onclick="fnPrintJobOrder()" class="k-button" style="float: right;">작업지시서 출력</button>
			<input type="input" style="display:none;" id="PROXY_ID" name="ETC">
		</div>

		<div style="padding: 0px;">

			<fieldset class="fieldSet" style="text-align: center;">

				<form id="frm_consigned_receipt_data" method="post" enctype="multipart/form-data" data-role="validator" novalidate="novalidate">

					<%-- 접수 정보 --%>
					<div class="info">

						<div class="sub-header-title">
							<span class="pagetitle"><span class="header-title30"></span> 접수 정보 </span>
						</div>

						<table align = right id="tbl_consigned_receipt_info_data" class="table_default">

							<tbody>

								<tr>
									<td class="col-title">접수번호</td>
									<td class="col-content-25"><input type="input" class="view k-textbox col-input" id="RECEIPT_NO" name="RECEIPT_NO" style="height: 25px;" disabled></td>
									<td class="col-title">제품유형</td>
									<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="COMPONEN_NM" name="COMPONEN_NM">--%>
                                        <select id="PC_TYPE" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 92%; height: 22px; display: inline-block; margin-right: 3px; background: #ebebf5;">
                                            <option value="0">0</option>
                                        </select>
                                    </td>
								</tr>

								<tr>
									<td class="col-title">접수일자</td>
									<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="RECEIPT_DT" name="RECEIPT_DT">--%>
                                        <input id="datetimepicker_acceptance_date" title="datetimepicker" style="width:100%; height: 24px; display: inline-block; margin-right: 3px;" readonly="readonly"/>
                                    </td>
									<td class="col-title">보증기간</td>
									<td class="col-content-25" style="vertical-align: middle; padding: 0px;">
										<select id="GUARANTEE_DUE" class="k-dropdown-wrap k-state-default k-state-hover"
                                                data-role="dropdownlist" style="width: 25%; height: 24px; display: inline-block; margin-right: 3px; background: #ebebf5;"
                                                onchange="changeGuaranteeTerm(value)">
											<option value="0">0</option>
										</select>
										<input id="datetimepicker_acceptance_start" title="datetimepicker" style="width:30%; height: 24px; display: inline-block; margin-right: 3px; padding-bottom: 2px" />
										<span style="margin-right: 3px;"> ~ </span>
										<input id="datetimepicker_acceptance_end" title="datetimepicker" style="width:30%; height: 24px; display: inline-block; padding-bottom: 2px" />

									</td>
								</tr>

								<tr>
									<td class="col-title">판매처</td>
									<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="SALE_COMPANY" name="SALE_COMPANY">--%>
                                        <select id="COMPANY_ID" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 92%; height: 24px; display: inline-block; margin-right: 3px; background: #ebebf5;" disabled="disabled">
                                            <option value="0">0</option>
                                        </select>
                                    </td>
									<td class="col-title">판매경로</td>
									<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="SALE_ROOT" name="SALE_ROOT" value="3">--%>
                                        <select id="SALE_ROOT" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 92%; height: 24px; display: inline-block; margin-right: 3px; background: #ebebf5;">
                                            <option value="0">0</option>
                                        </select>
                                    </td>
								</tr>

								<tr>
									<td class="col-title">출고유형</td>
									<td class="col-content-20" style="height: 24px;">
										<input type="radio" name="RELEASE_TYPE" value="1" checked/>택배
										<input type="radio" name="RELEASE_TYPE" value="2" />방문수령
										<input type="radio" name="RELEASE_TYPE" value="3" />화물
									</td>
									<td class="col-title">참고사항</td>
									<td class="col-content-20" ><input type="input" id = "REQUEST" class="view k-textbox col-input" style="width: 100%; height: 24px;" name="REQUEST"></td>

								</tr>
								<tr>
									<td class="col-title">요청사항</td>
									<td class="col-content-25" ><input type="input" id = "DES" class="view k-textbox col-input" style="width: 226.5%; height: 24px;" name="DES"></td>
								</tr>

							</tbody>
						</table>
					</div>

					<%-- 고객 정보 --%>
					<div class="info">

						<div class="sub-header-title">
							<span class="pagetitle"><span class="header-title30"></span> 고객 정보 </span>
                            <div style="display: inline-block; float: right;">
                                <span style="margin-right: 15px"><input type="checkbox" id="chCopyUserInfo" > 수령인 정보 동일 </span>
                            </div>
						</div>

						<table id="tbl_consigned_receipt_customer_data" class="table_default">

							<tbody>

								<tr>
									<td class="col-title">고객명[1]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox col-input" id="CUSTOMER_NM_S" name="CUSTOMER_NM_S" style="height: 24px;"></td>
									<td class="col-title">고객명[2]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox col-input" id="CUSTOMER_NM_R" name="CUSTOMER_NM_R" style="height: 24px;"></td>
								</tr>

								<tr>
									<td class="col-title">전화번호[1]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="TEL_S" name="TEL_S" style="width:100%; height: 24px;" ></td>
									<td class="col-title">전화번호[2]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="TEL_R" name="TEL_R" style="width:100%; height: 24px;"></td>
								</tr>

								<tr>
									<td class="col-title">휴대폰[1]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="MOBILE_S" name="MOBILE_S" style="width:100%; height: 23px;"></td>
									<td class="col-title">휴대폰[2]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="MOBILE_R" name="MOBILE_R" style="width:100%; height: 23px;"></td>
								</tr>

								<tr>
									<td class="col-title" rowspan=2>주소</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="POSTAL_CD" name="POSTAL_CD" style="width:100%; " disabled></td>
									<td colspan="2" style="text-align: left;"><button id = "find_postal_code" onclick="fnSearchZipCode()" onsubmit="false" type="button" class="k-button" tabindex="1">우편번호 찾기</button></td>
								</tr>

								<tr>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="ADDRESS" name="ADDRESS" style="width:100%; height: 24px;" disabled></td>
									<td colspan="2" style="width:50%;"><input type="input" class="view k-textbox" id="ADDRESS_DETAIL" name="ADDRESS_DETAIL" style="width:100%; height: 24px;"></td>
								</tr>

							</tbody>
						</table>
					</div>
				</form>

			</fieldset>


			<fieldset class="fieldSet">

			<div class="info" style="width: 35.3%">

				<div class="sub-header-title">
					<div style="display: inline-block; width: 48.6%; text-align: center; border-right: solid 2px white">
						<span class="pagetitle"><span class="header-title30"></span> 물류 정보 </span>
						<button id = "delivery_invoidce" onclick="fnDeliveryInvoice()" class="k-button" style="float: right; width: 30px; height: 20px; background-color: slategray; margin:3px 7px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;">
									<span class="k-icon k-i-pencil" style="float: right; font-size: 15px; color: white;"></span>
						</button>
					</div>
					<span></span>
					<div style="display: inline-block;  width: 48%; text-align: center">
						<span class="pagetitle">
							<span class="header-title30"></span> 쿠폰 정보
								<button id="couponEditBtn" onclick="fnModifCoupon()" class="k-button" style=" float: right; width: 30px; height: 20px; background-color: slategray; margin:3px 0px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;">
									<span  class="k-icon k-i-pencil" style="float: right; font-size: 15px; color: white;"></span>
								</button>

								<button id="couponSaveBtn" onclick="fnSaveCoupon()" class="k-button" style=" display:none;float: right; width: 30px; height: 20px; background-color: slategray; margin:3px 0px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;">
									<span class="k-icon k-i-save" style="float: right; font-size: 15px; color: white;"></span>
								</button>
						</span>
					</div>
				</div>

				<table align = right id="tbl_consigned_distribution_info_data" class="table_default">

					<colgroup>
						<col width="25%">
						<col width="25%">
						<col width="25%">
						<col width="25%">
					</colgroup>

					<thead class="col-header-title">
						<td>택배사</td>
						<td>송장번호</td>
						<td>관리번호</td>
						<td>고객번호</td>
					</thead>

					<tbody>

						<tr>
							<td>
								<input id="delivery_type" type="text" class="view k-textbox col-input" readonly="readonly" style="background: #ebebf5; text-align:center;">
							</td>
							<td>
								<input id="delivery_invoice" type="text" class="view k-textbox col-input" readonly="readonly" style="background: #ebebf5; text-align:center;">
							</td>
							<td>
								<input id="coupon_mange" type="text" class="view k-textbox col-input" readonly="readonly" style="background: #ebebf5; text-align:center;">
							</td>
							<td>
								<input id="coupon_customer" type="text" class="view k-textbox col-input"  readonly="readonly" style="background: #ebebf5; text-align:center;">
							</td>
						</tr>

					</tbody>

				</table>

			</div>

<!-- 			<div class="info" style="width: 58%;"> -->
<!-- 				<div class="sub-header-title"> -->
<!-- 					<span class="pagetitle"><span class="header-title30"></span> 진행 정보 </span> -->
<!-- 				</div> -->

<!-- 				<table align = right id="tbl_consigned_process_info_data" class="table_default"> -->

<!-- 					<thead class="col-header-title"> -->
<!-- 						<td> 접수 <input type="checkbox" id="receipt_status_1" onclick='fnChangeReceiptStatus(1);'> </td> -->
<!-- 						<td> 처리중 <input type="checkbox" id="receipt_status_2" onclick='fnChangeReceiptStatus(2);'> </td> -->
<!-- 						<td> 보류 <input type="checkbox" id="receipt_status_3" onclick='fnChangeReceiptStatus(3);'> </td> -->
<!-- 						<td> 취소 <input type="checkbox" id="receipt_status_4" onclick='fnChangeReceiptStatus(4);'> </td> -->
<!-- 						<td> 출고완료 <input type="checkbox" id=receipt_status_5" onclick='fnChangeReceiptStatus(5);'> </td> -->
<!-- 						<td> 반품요청 <input type="checkbox" id="receipt_status_6" onclick='fnChangeReceiptStatus(6);'> </td> -->
<!-- 						<td> 반품입고 <input type="checkbox" id="receipt_status_7" onclick='fnChangeReceiptStatus(7);'> </td> -->
<!-- 						<td> 교환출고 <input type="checkbox" id="receipt_status_8" onclick='fnChangeReceiptStatus(8);'> </td> -->
<!-- 						<td> 반품완료 <input type="checkbox" id="receipt_status_9" onclick='fnChangeReceiptStatus(9);'> </td> -->
<!-- 					</thead> -->

<!-- 					<tbody> -->
<!-- 						<tr> -->
<!-- 							<td><input id="process-info-date1" title="datetimepicker" style="width:100%; height: 25px; display: inline-block;" readonly="readonly"/></td> -->
<!-- 							<td><input id="process-info-date2" title="datetimepicker" style="width:100%; height: 25px; display: inline-block;" readonly="readonly"/></td> -->
<!-- 							<td><input id="process-info-date3" title="datetimepicker" style="width:100%; height: 25px; display: inline-block;" readonly="readonly"/></td> -->
<!-- 							<td><input id="process-info-date4" title="datetimepicker" style="width:100%; height: 25px; display: inline-block;" readonly="readonly"/></td> -->
<!-- 							<td><input id="process-info-date5" title="datetimepicker" style="width:100%; height: 25px; display: inline-block;" readonly="readonly"/></td> -->
<!-- 							<td><input id="process-info-date6" title="datetimepicker" style="width:100%; height: 25px; display: inline-block;" readonly="readonly"/></td> -->
<!-- 							<td><input id="process-info-date7" title="datetimepicker" style="width:100%; height: 25px; display: inline-block;" readonly="readonly"/></td> -->
<!-- 							<td><input id="process-info-date8" title="datetimepicker" style="width:100%; height: 25px; display: inline-block;" readonly="readonly"/></td> -->
<!-- 							<td><input id="process-info-date9" title="datetimepicker" style="width:100%; height: 25px; display: inline-block;" readonly="readonly"/></td> -->
<!-- 						</tr> -->
<!-- 					</tbody> -->

<!-- 				</table> -->

<!-- 			</div> -->

			<div id="processInfo" class="info" style="width: 31%;" >
				<div class="sub-header-title">
					<span class="pagetitle"><span class="header-title30"></span> 진행 정보 </span>
				</div>

				<table align = right id="tbl_consigned_process_info_data1" class="table_default">

					<thead class="col-header-title">
						<td> 접수 <input type="checkbox" id="receipt_status_0" onclick='fnChangeReceiptStatus(0);' disabled> </td>
						<td> 처리중 <input type="checkbox" id="receipt_status_1" onclick='fnChangeReceiptStatus(1);'> </td>
						<td> 보류 <input type="checkbox" id="receipt_status_2" onclick='fnChangeReceiptStatus(2);'> </td>
						<td> 취소 <input type="checkbox" id="receipt_status_3" onclick='fnChangeReceiptStatus(3);'> </td>
						<td> 출고완료 <input type="checkbox" id="receipt_status_4" onclick='fnChangeReceiptStatus(4);'> </td>

					</thead>

					<tbody>
						<tr>
							<td><input id="process-info-date0" title="datetimepicker" style="width:100%; font-size: 13px; height: 22px; display: inline-block; padding: 0px 0px 1px 0px; " readonly="readonly"/></td>
							<td><input id="process-info-date1" title="datetimepicker" style="width:100%; font-size: 13px; height: 22px; display: inline-block; padding: 0px 0px 1px 0px;" readonly="readonly"/></td>
							<td><input id="process-info-date2" title="datetimepicker" style="width:100%; font-size: 13px; height: 22px; display: inline-block; padding: 0px 0px 1px 0px;" readonly="readonly"/></td>
							<td><input id="process-info-date3" title="datetimepicker" style="width:100%; font-size: 13px; height: 22px; display: inline-block; padding: 0px 0px 1px 0px;" readonly="readonly"/></td>
							<td><input id="process-info-date4" title="datetimepicker" style="width:100%; font-size: 13px; height: 22px; display: inline-block; padding: 0px 0px 1px 0px;" readonly="readonly"/></td>
						</tr>
					</tbody>

				</table>

			</div>

				<div id="returnInfo" class="info" style="width: 31%;;" >
				<div id="return_header" class="sub-header-title">
					<span class="pagetitle"><span class="header-title30" ></span> 반품 정보 </span>
				</div>

				<table align = right id="tbl_consigned_return_info_data" class="table_default">

					<thead class="col-header-title">
						<td> 반품요청 <input type="checkbox" id="receipt_status_5" onclick='fnChangeReceiptStatus(5);' disabled > </td>
						<td> 반품입고 <input type="checkbox" id="receipt_status_6" onclick='fnChangeReceiptStatus(6);' disabled > </td>
						<td> 교환출고 <input type="checkbox" id="receipt_status_7" onclick='fnChangeReceiptStatus(7);' disabled> </td>
						<td> 반품취소 <input type="checkbox" id="receipt_status_8" onclick='fnChangeReceiptStatus(8);' disabled > </td>
						<td> 반품완료 <input type="checkbox" id="receipt_status_9" onclick='fnChangeReceiptStatus(9);' disabled > </td>
					</thead>

					<tbody>
						<tr>
							<td><input id="process-info-date5" title="datetimepicker" style="width:100%; font-size: 13px; height: 22px; display: inline-block; padding: 0px 0px 1px 0px;" readonly="readonly"/></td>
							<td><input id="process-info-date6" title="datetimepicker" style="width:100%; font-size: 13px; height: 22px; display: inline-block; padding: 0px 0px 1px 0px;" readonly="readonly"/></td>
							<td><input id="process-info-date7" title="datetimepicker" style="width:100%; font-size: 13px; height: 22px; display: inline-block; padding: 0px 0px 1px 0px;" readonly="readonly"/></td>
							<td><input id="process-info-date8" title="datetimepicker" style="width:100%; font-size: 13px; height: 22px; display: inline-block; padding: 0px 0px 1px 0px;" readonly="readonly"/></td>
							<td><input id="process-info-date9" title="datetimepicker" style="width:100%; font-size: 13px; height: 22px; display: inline-block; padding: 0px 0px 1px 0px;" readonly="readonly"/></td>
						</tr>
					</tbody>

				</table>

			</div>

		</fieldset>

		<fieldset class="fieldSet">
		<div class="infosingle">
		<table align = right id="tbl_consigned_product_data" class="stripe table_default">

				<colgroup>
					<col width="8.9%">
						<col width="9%">
						<col width="15%">
						<col width="20%">
						<col width="15%">
						<col width="17%">
						<col width="15%">
					</colgroup>

					<thead class="col-header-title">
						<td> 윈도우 라이센스 </td>
						<td> COA 선택</td>
						<td> 제조사  </td>
						<td> 모델 </td>
						<td> <label id="serialId">제품 S/N</label></td>
						<td> CPU 사양 </td>
						<td>
							<span class="header-title30"></span> COA NO
								<button id="SNEditBtn" onclick="fnModifSN()" class="k-button" style=" float: right; width: 28px; height: 18px; background-color: slategray; margin:2px 2px 0px 0px ; padding: 0px 5px 0px 5px; font-size: 8px;">
									<span  class="k-icon k-i-pencil" style="float: right; font-size: 15px; color: white;"></span>
								</button>

								<button id="SNSaveBtn" onclick="fnSaveSN()" class="k-button" style="display:none;float: right; width: 28px; height: 18px; background-color: slategray; margin:2px 2px 0px 0px ; padding: 0px 5px 0px 5px; font-size: 8px;">
									<span class="k-icon k-i-save" style="float: right; font-size: 15px; color: white;"></span>
								</button>
						</td>

					</thead>

					<tbody>
						<tr>
							<td>OLD</td>
							<td><select id="COA_TYPE_OLD"  disabled="disabled" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="text-align-last:center; width: 83%; height: 20px; display: inline-block; padding-left: 0px; background: #FFFFFF;">
										<option value="1">WIN 7</option>
										<option value="2">WIN 8</option>
									</select></td>
							<td><input type="input" class="view k-textbox col-input" style="width: 100%; height: 24px;" id="manufature_old" readonly="readonly" ></td>
							<td><input type="input" class="view k-textbox col-input" style="width: 100%; height: 24px;" id="modelNm_old" readonly="readonly" ></td>

							<td><input type="input" class="view k-textbox col-input" style="width: 100%; height: 24px;" id="snNo_old" readonly="readonly" ></td>
							<td><input type="input" class="view k-textbox col-input" style="width: 100%; height: 24px;" id="cpuInfo_old" readonly="readonly" ></td>
							<td><input type="input" class="view k-textbox col-input" style="width: 100%; height: 24px;" id="coaNo_old" readonly="readonly" ></td>
						</tr>
						<tr>
							<td>NEW</td>
							<td><select id="COA_TYPE_NEW"   disabled="disabled" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="text-align-last:center; width: 83%; height: 20px; display: inline-block; padding-left: 0px; background: #E6E6E6;">
										<option value="3">WIN 10</option>
									</select></td></td>
							<td><input type="input" class="view k-textbox col-input" style="width: 100%; height: 24px; background: #E6E6E6;" id="manufature_new" readonly="readonly" ></td>
							<td><input type="input" class="view k-textbox col-input" style="width: 100%; height: 24px; background: #E6E6E6;" id="modelNm_new" readonly="readonly" ></td>

							<td><input type="input" class="view k-textbox col-input" style="width: 100%; height: 24px; background: #E6E6E6;" id="snNo_new" readonly="readonly" ></td>
							<td><input type="input" class="view k-textbox col-input" style="width: 100%; height: 24px; background: #E6E6E6;" id="cpuInfo_new" readonly="readonly" ></td>
							<td><input type="input" class="view k-textbox col-input" style="width: 100%; height: 24px; background: #E6E6E6;" id="coaNo_new" readonly="readonly" ></td>
						</tr>
					</tbody>

				</table>
			</div>
			</fieldset>


			<fieldset class="fieldSet">

			<%-- 제품 정보 --%>
			<div class="info">

				<div class="sub-header-title" style="width: 100%; height: 35px; vertical-align: middle;">
					<span class="pagetitle" style="vertical-align: middle;">
						<span class="header-title30" style="vertical-align: middle;"> 제품 정보 </span>

							<button id = "modifComponent" onclick="fnModifComponent()" class="k-button" style="float: right; width: 30px; height: 25px; background-color: slategray; margin:3px 5px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;">
								<span class="k-icon k-i-track-changes-enable" style="float: right; font-size: 15px; color: white;"></span>
							</button>

							<button id="compareReleaseComponent" onclick="fnCompareReleaseComponent()" class="k-button" style="float: right; width: 30px; height: 25px; background-color: slategray; margin:3px 5px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;">
								<span class="k-icon k-i-mirror" style="float: right; font-size: 15px; color: white;"></span>
							</button>

							<button id="componentContract" onclick="fnComponentContract()" class="k-button" style="float: right; width: 30px; height: 25px; background-color: slategray; margin:3px 5px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;">
								<span class="k-icon k-i-invert-colors" style="float: right; font-size: 15px; color: white;"></span>
							</button>

							<button id="componentExtract" onclick="fnComponentExtract()" class="k-button" style="float: right; width: 30px; height: 25px; background-color: slategray; margin:3px 5px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;">
								<span class="k-icon k-i-minus-outline" style="float: right; font-size: 15px; color: white;"></span>
							</button>

							<button id="componentCopy" onclick="fnComponentCopy()" class="k-button" style="float: right; width: 30px; height: 25px; background-color: slategray; margin:3px 5px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;">
								<span class="k-icon k-i-plus-outline" style="float: right; font-size: 15px; color: white;"></span>
							</button>

<!-- 							<button onclick="fnInsertReleaseInventory()" class="k-button" style="float: right; width: 30px; height: 20px; background-color: slategray; margin:3px 5px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;"> -->
<!-- 								<span class="k-icon k-i-plus-circle" style="float: right; font-size: 15px; color: white;"></span> -->
<!-- 							</button> -->
					</span>
					</div>

				<table id="tbl_consigned_receipt_product_data" class="stripe table_default">

					<colgroup>
					<col width="4%">
						<col width="8%">
						<col width="64%">
<%-- 						<col width="15%"> --%>
<%-- 						<col width="10%"> --%>
<%-- 						<col width="10%"> --%>
						<col width="10%">
						<col width="14%">
					</colgroup>

					<thead>
						<tr>
						<td class="col-header-title"><input type="checkbox" id="checkAll" onclick='fnChangeCheckAll();'></td>
							<td class="col-header-title">품목명</td>
							<td class="col-header-title">부품명</td>
<!-- 							<td class="col-header-title">유형</td> -->
<!-- 							<td class="col-header-title">수량</td> -->
							<td class="col-header-title">할당여부</td>
							<td class="col-header-title">금액</td>
<!-- 							<td class="col-header-title">총 금액</td> -->
						</tr>
					</thead>
				</table>

				<div class="scrollable-div">

					<table  id="tbl_consigned_component_data" class="stripe table_scroll">

						<colgroup>
						<col width="4%">
						<col width="8%">
						<col width="64%">
<%-- 						<col width="15%"> --%>
<%-- 						<col width="10%"> --%>
						<col width="10%">
<%-- 						<col width="9.9%"> --%>
						<col width="12%">
						</colgroup>

						<tbody class="consigned_items">
						</tbody>

					</table>

				</div>


				<div style="vertical-align: middle; height: 32px; padding: 0px; background-color: lightgray; margin: 0px 0px 1px 0px;">

					<table class="table_default">

						<colgroup>
							<col width="76%">
<%-- 							<col width="15%"> --%>
<%-- 							<col width="10%"> --%>
							<col width="10%">
							<col width="14%">
						</colgroup>

						<tbody>
							<tr class="col-header-title">
								<td ><label id="numOfComponent">TOTAL: 0 EA</label></td>
<!-- 								<td ><label id="numOfInventory">합계: 0 EA</label></td> -->
								<td ><label id="numOfRelease">합계: 0 EA</label></td>
								<td ><label id="totalPrice">합계: 0 </label></td>
<!-- 								<td > -->
<!-- 									<input type="radio" name="SELLING_TYPE" value="0" />매입 -->
<!-- 									<input type="radio" name="SELLING_TYPE" value="1" />위탁 -->
<!-- 								</td> -->
<!-- 								<td colspan="1"> -->
<!-- 									<button class="k-button searched-item" style="width: 35px; background-color: slategray; margin: 1px;"> -->
<!-- 										<span class="k-icon k-i-print" style="font-size: 15px; color: white;"></span> -->
<!-- 									</button> -->
<!-- 								</td> -->

							</tr>
						</tbody>

					</table>
				</div>
			</div>

			<div id="detail_info" class="info" style="background-color: lightgray; display: inline-block;">

				<div class="sub-header-title" style="height: 35px; vertical-align: middle;">
					<span class="pagetitle" style="vertical-align: middle;">
						<span class="header_title30" style="vertical-align: middle;"></span> 정산 스펙
					</span>
					<button id="consigned_update_adjust" type="button" onclick="fnUpdateAdjust()" class="k-button" style="float: right;  margin: 5px 5px 0px 0px; height: 25px; font-size: 12px;">저장</button>
				</div>

				<%-- Table 1 --%>
				<div class="table-group">
					<table id="tbl_consigned_receipt_detail_data1" class="table-inner stripe">

						<colgroup>
							<col width="8%">
							<col width="16%">
							<col width="16%">
							<col width="16%">
							<col width="16%">
							<col width="16%">
							<col width="10%">
						</colgroup>

<!-- 						<div style="float: right; margin-bottom: 1px; margin-right: 2px"> -->
<!-- 							<button class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1" style="font-size: 12px; padding: 2px 6px">등록</button> -->
<!-- 						</div> -->

						<tbody>

							<tr>
								<td rowspan="4" class="col-title-center"> 출고 정산 </td>
								<td class="col-title-center" style="height: 24px;"> 원가 </td>
								<td colspan="2" class="col-title-center"> 생산 </td>
								<td colspan="2" class="col-title-center"> 물류 </td>
								<td rowspan="2" class="col-title-center"> 합계 </td>
							</tr>

							<tr>
								<td class="col-title-center" style="height: 24px;"> 제품 정보 </td>
								<td class="col-title-center"> 기본
<!-- 								 	<span id ="price-produce" class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('price-produce')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> -->
								 </td>
								<td class="col-title-center"> 재생산
<!-- 									<span id = "price-reproduce" class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('price-reproduce')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> -->
								</td>
								<td class="col-title-center"> 택배
<!-- 									<span id = "price-delivery" class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('price-delivery')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> -->
								 </td>
								<td class="col-title-center"> 퀵배송
<!-- 								 	<span id = "price-quick" class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('price-quick')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> -->
								 </td>
							</tr>

							<tr>
								<td class="input-col"> <input type="input" id="original_price" class="view k-textbox table-inner-col-input"  onChange = "original_price_change()" style="text-align:center;" value = "0"></td> <%-- 원가 > 제품정보 --%>
								<td class="input-col"> <%-- 생산 > 기본 --%>
									<select id="price-produce-select" onchange="fnComputeReleaseSum()" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="display: none; width: 81%; height: 22px;  margin-right: 3px; background: #ebebf5;">
										<option value="0">0</option>
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="price-produce-input" type="number" onchange="fnComputeReleaseSum()" class="view k-textbox table-inner-col-input"  style="text-align:center;"  value="0">
								</td>
								<td class="input-col"> <%-- 생산 > 재생산 --%>
									<select id="price-reproduce-select" onchange="fnComputeReleaseSum()" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="display: none; width: 81%; height: 22px; margin-right: 3px; background: #ebebf5;">
										<option value="0">0</option>
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="price-reproduce-input" type="number" onchange="fnComputeReleaseSum()" class="view k-textbox table-inner-col-input"  style="text-align:center;"  value="0">
								</td>
								<td class="input-col"> <%-- 물류 > 택배 --%>
									<select id="price-delivery-select" onchange="fnComputeReleaseSum()" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="display: none; width: 81%; height: 22px; margin-right: 3px; background: #ebebf5;">
										<option value="0">0</option>
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="price-delivery-input" type="number" onchange="fnComputeReleaseSum()" class="view k-textbox table-inner-col-input"  style="text-align:center;"  value="0">
								</td>
								<td class="input-col"> <%-- 물류 > 퀵배송 --%>
									<select id="price-quick-select" onchange="fnComputeReleaseSum()" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="display: none; width: 81%; height: 22px; margin-right: 3px; background: #ebebf5;">
										<option value="0">0</option>
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="price-quick-input" type="number" onchange="fnComputeReleaseSum()" class="view k-textbox table-inner-col-input"  style="text-align:center;"  value="0">
								</td>
								<td class="input-col"> <input type="input" id="release-sum"class="view k-textbox table-inner-col-input" disabled style="text-align:center;"> </td> <%-- 합계 --%>
							</tr>

							<tr>
								<td class="col-title-center"> 등록일자 </td>
								<td colspan="2"><input id="release-dt1" title="datetimepicker" style="width:100%; font-size: 13px; height: 23px; display: inline-block;" /></td>
								<td colspan="3" class="input-col"> <input type="text" id = "registerDt-history" class="view k-textbox table-inner-col-input line-break"  disabled> </td>
							</tr>

						</tbody>

					</table>
				</div>

				<%-- Table 2 --%>
				<div class="table-group" style="display:none;">
					<table id="tbl_consigned_receipt_detail_data2" class="table-inner stripe">

						<colgroup>
							<col width="8%">
							<col width="16%">
							<col width="16%">
							<col width="16%">
							<col width="16%">
							<col width="16%">
							<col width="10%">
						</colgroup>

<!-- 						<div style="float: right; margin-bottom: 1px; margin-right: 2px"> -->
<!-- 							<button class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1" style="font-size: 12px; padding: 2px 6px">등록</button> -->
<!-- 						</div> -->

						<tbody>

							<tr>
								<td rowspan="4" class="col-title-center"> 추가 정산 <br> <span style="font-size: 12px;">[반품 or 기타]</span> </td>
								<td class="col-title-center"> 원가 </td>
								<td colspan="2" class="col-title-center"> 생산 </td>
								<td colspan="2" class="col-title-center"> 물류 </td>
								<td rowspan="2" class="col-title-center"> 합계 </td>
							</tr>

							<tr>
								<td class="col-title-center"> 제품 정보 </td>
								<td class="col-title-center"> 기본 <span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('basic-2')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> </td>
								<td class="col-title-center"> 재생산 <span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('reproduction-2')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> </td>
								<td class="col-title-center"> 택배 <span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('parcel-2')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> </td>
								<td class="col-title-center"> 퀵배송 <span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('quick-2')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> </td>
							</tr>

							<tr>
								<td class="input-col"> <input type="input" class="view k-textbox table-inner-col-input" disabled> </td> <%-- 원가 > 제품정보 --%>
								<td class="input-col"> <%-- 생산 > 기본 --%>
									<select id="detail-input-select-basic2" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 27px; display: inline-block; margin-right: 3px; background: #ebebf5;">
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="detail-input-number-basic2" type="number" class="view k-textbox table-inner-col-input" style="display: none;" value="0">
								</td>
								<td class="input-col"> <%-- 생산 > 재생산 --%>
									<select id="detail-input-select-reproduction2" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 27px; display: inline-block; margin-right: 3px; background: #ebebf5;">
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="detail-input-number-reproduction2" type="number" class="view k-textbox table-inner-col-input" style="display: none;" value="0">
								</td>
								<td class="input-col"> <%-- 물류 > 택배 --%>
									<select id="detail-input-select-parcel2" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 27px; display: inline-block; margin-right: 3px; background: #ebebf5;">
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="detail-input-number-parcel2" type="number" class="view k-textbox table-inner-col-input" style="display: none;" value="0">
								</td>
								<td class="input-col"> <%-- 물류 > 퀵배송 --%>
									<select id="detail-input-select-quick2" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 27px; display: inline-block; margin-right: 3px; background: #ebebf5;">
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="detail-input-number-quick2" type="number" class="view k-textbox table-inner-col-input" style="display: none;" value="0">
								</td>
								<td class="input-col"> <input type="input" class="view k-textbox table-inner-col-input" disabled> </td> <%-- 합계 --%>
							</tr>

							<tr>
								<td class="col-title-center"> 등록일자 </td>
								<td colspan="2"><input id="release-dt2" title="datetimepicker" style="width:100%; font-size: 11px; display: inline-block;"/></td>
								<td colspan="3" class="input-col"> <input type="input" class="view k-textbox table-inner-col-input" disabled> </td>
							</tr>

						</tbody>

					</table>
				</div>

				<%-- Table 3 --%>
				<div class="table-group" style="display:none;">
					<table id="tbl_consigned_receipt_detail_data3" class="table-inner stripe">

						<div style="float: left; margin: 1px; vertical-align: middle; font-size: 11px">
							출고 정산 환급 <input type="checkbox">
							추가 정산 환급 <input type="checkbox">
							출고+추가 정산 환급 <input type="checkbox">
							선택 환급 <input type="checkbox">
						</div>

<!-- 						<div style="float: right; margin-bottom: 1px; margin-right: 2px"> -->
<!-- 							<button class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1" style="font-size: 12px; padding: 2px 6px">등록</button> -->
<!-- 						</div> -->

						<colgroup>
							<col width="8%">
							<col width="16%">
							<col width="16%">
							<col width="16%">
							<col width="16%">
							<col width="16%">
							<col width="10%">
						</colgroup>

						<tbody>

							<tr>
								<td rowspan="4" class="col-title-center"> 환급 정산 </td>
								<td class="col-title-center"> 원가 </td>
								<td colspan="2" class="col-title-center"> 생산 </td>
								<td colspan="2" class="col-title-center"> 물류 </td>
								<td rowspan="2" class="col-title-center"> 합계 </td>
							</tr>

							<tr>
								<td class="col-title-center"> 제품 정보 </td>
								<td class="col-title-center"> 기본 <span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('basic-3')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> </td>
								<td class="col-title-center"> 재생산 <span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('reproduction-3')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> </td>
								<td class="col-title-center"> 택배 <span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('parcel-3')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> </td>
								<td class="col-title-center"> 퀵배송 <span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('quick-3')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> </td>
							</tr>

							<tr>
								<td class="input-col"> <input type="input" class="view k-textbox table-inner-col-input" disabled> </td> <%-- 원가 > 제품정보 --%>
								<td class="input-col"> <%-- 생산 > 기본 --%>
									<select id="detail-input-select-basic3" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 27px; display: inline-block; margin-right: 3px; background: #ebebf5;">
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="detail-input-number-basic3" type="number" class="view k-textbox table-inner-col-input" style="display: none;" value="0">
								</td>
								<td class="input-col"> <%-- 생산 > 재생산 --%>
									<select id="detail-input-select-reproduction3" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 27px; display: inline-block; margin-right: 3px; background: #ebebf5;">
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="detail-input-number-reproduction3" type="number" class="view k-textbox table-inner-col-input" style="display: none;" value="0">
								</td>
								<td class="input-col"> <%-- 물류 > 택배 --%>
									<select id="detail-input-select-parcel3" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 27px; display: inline-block; margin-right: 3px; background: #ebebf5;">
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="detail-input-number-parcel3" type="number" class="view k-textbox table-inner-col-input" style="display: none;" value="0">
								</td>
								<td class="input-col"> <%-- 물류 > 퀵배송 --%>
									<select id="detail-input-select-quick3" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 27px; display: inline-block; margin-right: 3px; background: #ebebf5;">
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="detail-input-number-quick3" type="number" class="view k-textbox table-inner-col-input" style="display: none;" value="0">
								</td>
								<td class="input-col"> <input type="input" class="view k-textbox table-inner-col-input" disabled> </td> <%-- 합계 --%>
							</tr>

							<tr>
								<td class="col-title-center"> 등록일자 </td>
								<td colspan="2"><input id="release-dt3" title="datetimepicker" style="width:100%; font-size: 11px; display: inline-block;"/></td>
								<td colspan="3" class="input-col"> <input type="input" class="view k-textbox table-inner-col-input" disabled> </td>
							</tr>

						</tbody>

					</table>
				</div>

			</div>


			<div id="related_receipt_no_info" class="info" style="background-color: lightgray; display:none;">

				<div class="sub-header-title" style="height: 35px; vertical-align: middle;">
					<span class="pagetitle" style="vertical-align: middle;"><span class="header_title30" style="vertical-align: middle;"></span> 관련 접수번호 </span>
				</div>

				<div class="table-group">

					<table id="tbl_consigned_related_receipt_no" class="table-inner stripe">

						<thead>
							<tr>
								<td class="col-title-center" style="height: 24px;"> 접수번호 </td>
								<td class="col-title-center"> 접수일자 </td>
								<td class="col-title-center"> 고객명 </td>
								<td class="col-title-center"> 판매처 </td>
								<td class="col-title-center"> 진행상태 </td>
								<td class="col-title-center"> 제품 정보 </td>
								<td class="col-title-center"> 완료일자 </td>
							</tr>
						</thead>

						<tbody class="related_consigned_items">
						</tbody>

					</table>

			</div>

			</div>
		</fieldset>

	</div>

</div>

</body>

