<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<c:url var="getConsignedInfo"					value="/consigned/getConsignedInfo.json" />
<c:url var="getConsignedParentInfo"					value="/consigned/getConsignedParentInfo.json" />
<c:url var="getConsignedAdjustInfo"					value="/consigned/getConsignedAdjustInfo.json" />
<c:url var="getConsignedComponentFullInfo"					value="/consigned/getConsignedComponentFullInfo.json" />
<c:url var="getRelatedConsignedInfoForPreRelease"					value="/consigned/getRelatedConsignedInfoForPreRelease.json" />
<c:url var="updateReceiptStatus"			value="/consigned/updateReceiptStatus.json" />
<c:url var="preRelease"					value="/consigned/preRelease.json" />
<c:url var="ExchangeReleaseOlyComplete"					value="/consigned/ExchangeReleaseOlyComplete.json" />
<c:url var="getCodeListCustom"				value="/common/getCodeListCustom.json" />
<c:url var="companyDelete"					value="/user/companyDelete.json" />
<c:url var="companyInsert"						value="/user/companyInsert.json" />
<c:url var="getConsignedDateList"			value="/consigned/getConsignedDateList.json" />
<c:url var="updateProxyComponent"						value="/consigned/updateProxyComponent.json"/>
<c:url var="updateProxyComponentUnit"						value="/consigned/updateProxyComponentUnit.json"/>
<c:url var="createReceipt"						value="/consigned/createReceipt.json"/>
<c:url var="updateReceipt"						value="/consigned/updateReceipt.json"/>
<c:url var="updateAdjust"						value="/consigned/updateAdjust.json"/>
<c:url var="executeQuery"						value="/common/executeQuery.json"/>
<c:url var="getLicenceInfo"						value="/consigned/getLicenceInfo.json"/>

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
			top: 0px;
		}
		.k-i-calendar {
			top: -3px;
		}
		.col-input {
			height: 24px;
		}
		.table-group {
			margin: 3px 3px 5px 3px;
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
 		var _pProxyId;
 		var _rProxyId;

 		var _companyId = -1;

 		var _proxyState;

 		var _userId = "${sessionScope.userInfo.user_id}";
 		var _userNm = "${sessionScope.userInfo.user_nm}";
 		var _userType = "U";

 		var _stateDateData = new Array();

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
				var selector = $("[id*='process-info-date" + j +"']");
// 				console.log(selector);
				selector.kendoDatePicker({
					format: "yyyy-MM-dd",
// 					change: changeGuaranteeDate()
				});
			}

			for(var k=1; k<4; k++) {
				var selector = $("[id*='detail-register-date" + k +"']");
// 				console.log(selector);
				selector.kendoDatePicker({
					format: "yyyy-MM-dd",
// 					change: changeGuaranteeDate()
				});
			}

			$("#chCopyUserInfo").change(function(){
		      fnCopyUserInfo();
		    });

			for(var k=1; k<10; k++) {
				var selector = $("[id*='release-dt" + k +"']");
// 				console.log(selector);
				selector.kendoDatePicker({
					format: "yyyy-MM-dd",
// 					change: changeGuaranteeDate()
				});
			}

			$("input:radio[name=REFUNDTYPE]").click(function(){

			    var value = $("input:radio[name=REFUNDTYPE]:checked").val();

			    fnSetRefundState();

			});

			var key = getParameterByName('KEY');
			_proxyId = getParameterByName(key);

			fnInitConsignedData();
			fnInitConsignedParentData();
			fnInitConsignedLicence();
			fnInitConsignedAdjust();
			fnInitConsignedDateTooltip();

			if(_rProxyId> 0){
				$('#related_receipt_no_info').show();
				fnInitRelatedConsignedData();
			}


			$("input[name='RELEASE_TYPE']").attr('disabled',true);

			if(_proxyState != 6 )
				lockComponent();

			setTooltipOnIcon($("[id*='btnNewReceipt"), "접수");
			setTooltipOnIcon($("[id*='btnGoReceiptList"), "전체리스트");
			setTooltipOnIcon($("[id*='returnCheckComponent"), "반품처리");
		});


		function lockComponent(){

			$('#returnCheckComponent').attr("disabled","disabled");

			if(_proxyState != 7 ){
				$('#refund_price').attr("readonly",true);
				$('#refund-price-produce-select').attr("disabled","disabled");
				$('#refund-price-produce-input').attr("readonly",true);
				$('#refund-price-reproduce-select').attr("disabled","disabled");
				$('#refund-price-reproduce-input').attr("readonly",true);
				$('#refund-price-delivery-select').attr("disabled","disabled");
				$('#refund-price-delivery-input').attr("readonly",true);
				$('#refund-price-quick-select').attr("disabled","disabled");
				$('#refund-price-quick-input').attr("readonly",true);
				$('#adjust_refund-btn').attr("disabled","disabled");

				$("input[name = 'REFUNDTYPE']").attr('disabled',true);
			}
		}

		function unLockComponent(){

			$('#returnCheckComponent').removeAttr("disabled");

			$('#refund_price').attr("readonly",true);
			$('#refund-price-produce-select').removeAttr("disabled");
			$('#refund-price-produce-input').attr("readonly",false);
			$('#refund-price-reproduce-select').removeAttr("disabled");
			$('#refund-price-reproduce-input').attr("readonly",false);
			$('#refund-price-delivery-select').removeAttr("disabled");
			$('#refund-price-delivery-input').attr("readonly",false);
			$('#refund-price-quick-select').removeAttr("disabled");
			$('#refund-price-quick-input').attr("readonly",false);
			$('#adjust_refund-btn').removeAttr("disabled");

			$("input[name = 'REFUNDTYPE']").removeAttr("disabled");
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
// 				if(_proxyState == 7){
// 					checkBox.prop("checked", false);
// 					GochigoAlert("교환출고된 접수는 변경할 수 없습니다.",false,"dangol365erp");
// 					return;
// 				}

// 				if(_proxyState == 9){
// 					checkBox.prop("checked", false);
// 					GochigoAlert("반품완료된 접수는 변경할 수 없습니다.",false,"dangol365erp");
// 					return;
// 				}
// 			}

			var url = '${updateReceiptStatus}';
			var checkState;

			if(checked){
				checkState = 1;
				if(index == 7)
					msg = "생산 대행 상태를 '교환출고'로 변경하시겠습니까? <br>('교환출고'로 변경하면 새로운 접수번호로 진행됩니다.)";
				else
					msg = "생산 대행 상태를 '"+_RECEIPT_STATUS_NAME[index]+"'로 변경하시겠습니까?";
			}
			else{
				checkState = 0;

					msg = "'"+_RECEIPT_STATUS_NAME[index]+"'상태를 해제하시겠습니까?";
			}

			var params = {
					PROXY_ID: _proxyId,
					P_PROXY_ID: _pProxyId,
					CHECKED: checkState,
					PROXY_STATE: index,
					KEY: _RECEIPT_STATUS[index],
					KEY_NUM: index
	    	};

			if(index == 7){

				if(_rProxyId < 0){
					$("<div></div>").kendoConfirm({
			    		buttonLayout: "stretched",
			    		actions: [{
			    			text: '선출고',
			    			action: function(e){
			    				//시작지점

									url = '${preRelease}';

							    	$.ajax({
							    		url : url,
							    		type : "POST",
							    		data : params,
							    		async : false,
							    		success : function(data) {

					    					 var newUrl = '/layout.do?xn=consigned_All_LAYOUT';
					    					 GochigoAlertLocationHref("처리되었습니다. 전체 페이지로 이동합니다.", false, "dangol365 ERP", newUrl);

							    		}
							    	});
			    			}
			    		},
			    		{
			    			text: '교환출고',
			    			action: function(e){
			    				//시작지점

			    				console.log("_proxyState = "+_proxyState);
			    				if(_proxyState != 6){
									GochigoAlert("교환출고는 반품입고 상태에서만 처리 가능합니다.", false, "dangol365 ERP");
									if(checked)
					    				checkBox.prop("checked", false);
					    			else
					    				checkBox.prop("checked", true);
									return;
			    				}

			    				params.NEW_RECEIPT = 1;

						    	$.ajax({
						    		url : url,
						    		type : "POST",
						    		data : params,
						    		async : false,
						    		success : function(data) {

						    			for(var i = 5; i < 10; i++){
						    				var checkBox = $("[id*='receipt_status_" + i +"']");

						    				if(i == index)
						    					checkBox.prop("checked", true);
						    				else
						    					checkBox.prop("checked", false);
					    				}

					    				var checkDt = $("[id*='process-info-date" + index +"']");

				    					 var default_start_date = new Date();
				    					 checkDt.get(0).value = default_start_date.toISOString().substring(0, 10);

				    					 var newUrl = '/layout.do?xn=consigned_All_LAYOUT';
				    					 GochigoAlertLocationHref("처리되었습니다. 전체 페이지로 이동합니다.", false, "dangol365 ERP", newUrl);
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
			    		minWidth : 250,
			    		title: "dangol365 ERP",
			    	    content: "출고 유형을 선택하세요."
			    	}).data("kendoConfirm").open();
			    	//끝지점

				}
				else{

						$("<div></div>").kendoConfirm({
				    		buttonLayout: "stretched",
				    		actions: [{
				    			text: '교환출고완료',
				    			action: function(e){
				    				//시작지점

				    				if(_proxyState != 6){
										GochigoAlert("교환출고완료는 반품입고 상태에서만 처리 가능합니다.", false, "dangol365 ERP");
										if(checked)
						    				checkBox.prop("checked", false);
						    			else
						    				checkBox.prop("checked", true);
										return;
				    				}

				    				url = '${ExchangeReleaseOlyComplete}';

								    	$.ajax({
								    		url : url,
								    		type : "POST",
								    		data : params,
								    		async : false,
								    		success : function(data) {

								    			for(var i = 5; i < 10; i++){
								    				var checkBox = $("[id*='receipt_status_" + i +"']");

								    				if(i == index)
								    					checkBox.prop("checked", true);
								    				else
								    					checkBox.prop("checked", false);
							    				}

							    				var checkDt = $("[id*='process-info-date" + index +"']");

						    					 var default_start_date = new Date();
						    					 checkDt.get(0).value = default_start_date.toISOString().substring(0, 10);

						    					 _proxyState == 7
								    			lockComponent();

						    					 GochigoAlert("처리되었습니다.", false, "dangol365 ERP");

								    		}
								    	});
				    			}
				    		},
				    		{
				    			text: '교환출고',
				    			action: function(e){
				    				//시작지점

				    				if(_proxyState != 6){
										GochigoAlert("교환출고는 반품입고 상태에서만 처리 가능합니다.", false, "dangol365 ERP");
										if(checked)
						    				checkBox.prop("checked", false);
						    			else
						    				checkBox.prop("checked", true);
										return;
				    				}

				    				params.NEW_RECEIPT = 1;

							    	$.ajax({
							    		url : url,
							    		type : "POST",
							    		data : params,
							    		async : false,
							    		success : function(data) {

							    			for(var i = 5; i < 10; i++){
							    				var checkBox = $("[id*='receipt_status_" + i +"']");

							    				if(i == index)
							    					checkBox.prop("checked", true);
							    				else
							    					checkBox.prop("checked", false);
						    				}

						    				var checkDt = $("[id*='process-info-date" + index +"']");

					    					 var default_start_date = new Date();
					    					 checkDt.get(0).value = default_start_date.toISOString().substring(0, 10);

					    					 var newUrl = '/layout.do?xn=consigned_All_LAYOUT';
					    					 GochigoAlertLocationHref("처리되었습니다. 전체 페이지로 이동합니다.", false, "dangol365 ERP", newUrl);
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
				    	    content: "선출고 이력이 있습니다. 출고 유형을 선택해 주세요.<br>('교환출고'를 선택하면 새로운 접수번호로 진행됩니다.)"
				    	}).data("kendoConfirm").open();
				    	//끝지점
				}
			}
			else{

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
						    				GochigoAlert("처리되었습니다.", false, "dangol365 ERP");

						    				for(var i = 5; i < 10; i++){
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

						    				_proxyState = index;

						    				fnInitConsignedComponent();

						    				if(_proxyState == 6)
						    					unLockComponent();
						    				else
						    					lockComponent();
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
		}


		function fnInitConsignedDateTooltip(){
			console.log("consigned.fnInitConsignedDateTooltip() Load");

			var url = '${getConsignedDateList}';

			var params = {
	    			P_PROXY_ID: _pProxyId,
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

	    				_stateDateData[5] = data.RETURN_REQUEST_DT_LIST;
	    				_stateDateData[6] = data.RETURN_IN_DT_LIST;
	    				_stateDateData[7] = data.EXCHANGE_DT_LIST;
	    				_stateDateData[8] = data.RETURN_CANCEL_DT_LIST;
	    				_stateDateData[9] = data.RETURN_COMPLETE_DT_LIST;


						setTooltip($("[id*='process-info-date" + 0 +"']"), data.RECEIPT_DT_LIST, 0);
						setTooltip($("[id*='process-info-date" + 1 +"']"), data.PROCESS_DT_LIST, 1);
						setTooltip($("[id*='process-info-date" + 2 +"']"), data.POSTPONE_DT_LIST, 2);
						setTooltip($("[id*='process-info-date" + 3 +"']"), data.CANCEL_DT_LIST, 3);
						setTooltip($("[id*='process-info-date" + 4 +"']"), data.RELEASE_DT_LIST, 4);
						setTooltip($("[id*='process-info-date" + 5 +"']"), data.RETURN_REQUEST_DT_LIST, 5);
						setTooltip($("[id*='process-info-date" + 6 +"']"), data.RETURN_IN_DT_LIST, 6);
						setTooltip($("[id*='process-info-date" + 7 +"']"), data.EXCHANGE_DT_LIST, 7);
						setTooltip($("[id*='process-info-date" + 8 +"']"), data.RETURN_CANCEL_DT_LIST, 8);
						setTooltip($("[id*='process-info-date" + 9 +"']"), data.RETURN_COMPLETE_DT_LIST, 9);


						for(var i = 0 ; i< 10; i++)
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

		function updateTooltip(variable,  index){

			_stateDateData[index] =  kendo.format("{0:yyyy-MM-dd}", new Date())+ ' / ' + _userId + '<br>'+_stateDateData[index]

			variable.kendoTooltip({
 				content: _stateDateData[index],
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

		function fnInitRelatedConsignedData(){

			console.log("CompanyList.fnInitRelatedConsignedData() Load");

			var url = '${getRelatedConsignedInfoForPreRelease}';

			var params = {
	    			PROXY_ID: _rProxyId,
	    	};

			$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : params,
	    		async : false,
	    		success : function(data) {

	    			if(data.SUCCESS){
 	    				setRelatedConsignedInfo(data);
	    			}
	    		}
	    	});
		}

		function setRelatedConsignedInfo(DATA){
			var consigned_items = DATA;
			$(".related_consigned_items").empty();

			var fontColor = 'BLUE';
			var color = "#FFFFFF"

			var item = '<tr>';

			item +='<td style="display:none;">'+DATA.PROXY_ID+'</td>';

			item +='<td  class="col-title-center" style="color:'+fontColor+'; background-color:'+color+'; height: 27px; cursor: pointer;" onClick = fnShowRelatedInfo('+DATA.PROXY_ID+','+DATA.PROXY_STATE+')>'+DATA.RECEIPT+'</td>';
			item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+DATA.RECEIPT_DTS+'</td>';
			item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+DATA.CUSTOMER_NM+'</td>';
			item +='<td  class="col-title-left" style="background-color:'+color+'; height: 27px;">'+DATA.COMPANY_NM+'</td>';
			item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+DATA.PROXY_STATE_NM+'</td>';
			item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+DATA.PC_TYPE_NM+'</td>';
			item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+DATA.COMPLETE_DTS+'</td>';

			item += '</tr>';
			$(".related_consigned_items").append(item);

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


		function fnReturnCheckComponent (){
			var url = '${consignedPopup}';

			var query = "?content=releaseReturnCheck&KEY=PROXY_ID&PROXY_ID="+_pProxyId+"&KEY1=RECEIPT&RECEIPT="+$('#RECEIPT_NO').val()+"&KEY2=COMPANY_ID&COMPANY_ID="+$('#COMPANY_ID').val();

			var width, height;

			width = "1600";
	    	height = "650";

			var xPos  = (document.body.clientWidth /2) - (width / 2);
		    xPos += window.screenLeft;
		    var yPos  = (screen.availHeight / 2) - (height / 2);

		    window.open("<c:url value='"+url+query+"'/>", "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
		}

		function fnInitConsignedLicence(){

			console.log("CompanyList.fnInitConsignedLicence() Load");

			var url = '${getLicenceInfo}';
			var params = {
	    			PROXY_ID: _pProxyId
	    	};

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

		    				$('#snNo_old').val(mbd.SERIAL_NO);
		    				$('#snNo_new').val(mbd.SERIAL_NO);
						}

						if(cpu != null){

							$('#cpuInfo_old').val(cpu.MODEL_NM);
		    				$('#cpuInfo_new').val(cpu.MODEL_NM);

						}
	    			}
	    		}
	    	});

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
 	    				_pProxyId = data.P_PROXY_ID * 1;
 	    				_rProxyId= data.R_PROXY_ID * 1;

 	    				_userId = data.USER_ID;
 	    				_userType = data.USER_TYPE;
 	    		 		_companyId = data.COMPANY_ID;
 	    		 		_typeId = data.PC_TYPE;

 	    				$('#PROXY_ID').val(data.PROXY_ID);
 	    				$('#P_PROXY_ID').val(data.P_PROXY_ID);
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

	    				for(var i = 0; i < 10; i++){
		    				var checkBox = $("[id*='receipt_status_" + i +"']");

		    				if(i == data.RELEASE_STATE || i == data.RETURN_STATE)
		    					checkBox.prop("checked", true);
		    				else
		    					checkBox.prop("checked", false);
	    				}

	    				$('#coupon_mange').val(data.COUPON_MANAGE);
	    				$('#coupon_customer').val(data.COUPON_CUSTOMER);
    					$('#consigned_return_btn').hide();

	    				if(data.RECEIPT_DT != null){
	    					$("[id*='process-info-date0']").val(data.RECEIPT_DT);

	    				}


	    				if(data.PROCESS_DT != null){
	    					$("[id*='process-info-date1']").val(data.PROCESS_DT);

	    				}

	    				if(data.POSTPONE_DT != null){
	    					$("[id*='process-info-date2']").val(data.POSTPONE_DT);

	    				}


	    				if(data.CANCEL_DT != null){
	    					$("[id*='process-info-date3']").val(data.CANCEL_DT);
	    				}


	    				if(data.RELEASE_DT != null){
	    					$("[id*='process-info-date4']").val(data.RELEASE_DT);

	    				}

	    				if(data.RETURN_REQUEST_DT != null){
	    					$("[id*='process-info-date5']").val(data.RETURN_REQUEST_DT);

	    				}

	    				if(data.RETURN_IN_DT != null){
	    					$("[id*='process-info-date6']").val(data.RETURN_IN_DT);

	    				}


	    				if(data.EXCHANGE_DT != null){
	    					$("[id*='process-info-date7']").val(data.EXCHANGE_DT);

	    				}


	    				if(data.RETURN_CANCEL_DT != null){
	    					$("[id*='process-info-date8']").val(data.RETURN_CANCEL_DT);

	    				}



	    				if(data.RETURN_COMPLETE_DT != null){
	    					$("[id*='process-info-date9']").val(data.RETURN_COMPLETE_DT);

	    				}

	    				fnInitConsignedComponent();

	    			}
	    		}
	    	});
		}

		function fnInitConsignedComponent() {
			console.log("CompanyList.fnInitConsignedComponent() Load");

			var url = '${getConsignedComponentFullInfo}';

			var params = {
	    			PROXY_ID: _pProxyId,
	    			COMPANY_ID: _companyId
	    	};

			$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : params,
	    		async : false,
	    		success : function(data) {

	    			if(data.SUCCESS){

	    				setConsignedReturnComponent(data.DATA);

	    			}
	    		}
	    	});
		}


		function setConsignedReturnComponent(DATA){


			var consigned_items = DATA;
			var totalCnt = 0;
			var totalReturnCnt = 0;
			var totalReleasePrice = 0;
			var totalReleaseTotalCnt = 0;
			var totalReturnPrice = 0;
			var totalTotalPrice = 0;

			$(".consigned_items").empty();

			if(consigned_items.length > 0) {
				for(var i=0; i<consigned_items.length; i++) {

					var componentId = consigned_items[i].COMPONENT_ID;
					var componentCd = consigned_items[i].COMPONENT_CD;

					var color;
					var fontColor;
					var colorReturn = "#F5F6CE";

					if(i%2 == 1) color = "#E6E6E6";
					else color = "#FFFFFF"

					var componentCnt = consigned_items[i].COMPONENT_CNT;
					var componentReturnCnt = consigned_items[i].RETURN_ALL_CNT;
					var returnYn = componentReturnCnt == 1? 'O':'X';

					var price = consigned_items[i].PROXY_PRICE;
					if(price == '' || price == null) price = 0;

					var releasePrice = price * (componentCnt);
					totalReleasePrice += releasePrice;
					releasePrice += "";

					var returnPrice = price * (componentReturnCnt);
					totalReturnPrice += returnPrice;
					returnPrice += "";

					var totalPrice = price * (componentCnt-componentReturnCnt);
					totalTotalPrice += totalPrice;
					totalPrice += "";

					price += "";
					var releaseCnt = consigned_items[i].RELEASE_YN;
					totalReleaseTotalCnt += (releaseCnt*1);
					var releaseYn = releaseCnt == 1? 'O':'X';


					totalCnt += (componentCnt *1) ;
					totalReturnCnt += (componentReturnCnt *1) ;

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


					item +='<td  class="col-title-left" style="color:'+fontColor+';  background-color:'+color+';">'+componentCd+'</td>';
					item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+';">'+consigned_items[i].DETAIL_DATA+'</td>';

					item +='<td><input id="componentId-cnt-'+componentId+'-'+consignedType+'" type="text" class="view k-textbox col-input-number" value="'+releaseYn+'" style="color:'+fontColor+'; background-color:'+color+';"  readonly="readonly"></td>';
					item +='<td><input id="componentId-cnt-'+componentId+'-'+consignedType+'" type="text" class="view k-textbox col-input-number" value="'+returnYn+'" style="color:'+fontColor+'; background-color:'+colorReturn+';"  readonly="readonly"></td>';
// 					item +='<td><input id="componentId-return-cnt-'+proxyPartId+'" type="number" onchange="setReturnCnt('+proxyPartId+','+componentId+',this.value,'+consignedType+')" class="view k-textbox col-input-number-return" value="'+componentReturnCnt+'" min="0" max="'+componentCnt+'" style="color:'+fontColor+'; background-color:'+colorReturn+'; "></td>';
// 					item +='<td><input id="componentId-return-cnt-'+componentCd+'-'+componentId+'-'+consignedType+'" type="number" onchange="setReturnCnt('+componentId+',this.value,'+consignedType+')" class="view k-textbox col-input-number-return" value="'+componentReturnCnt+'" min="0" max="'+componentCnt+'" style="color:'+fontColor+'; background-color:'+colorReturn+'; "></td>';
// 						item +='<td><input id="price_'+componentId+'-'+consignedType+'" type="text" class="view k-textbox col-input-number-price" value="'+price.replace(/\B(?=(\d{3})+(?!\d))/g, ",")+'" style="padding-right:5px;color:'+fontColor+';  background-color:'+color+';" readonly="readonly"></td>';
						item +='<td><input id="release_price_'+componentId+'-'+consignedType+'" type="text" class="view k-textbox col-input-number-releasePrice" value="'+releasePrice.replace(/\B(?=(\d{3})+(?!\d))/g, ",")+'" style="padding-right:5px; color:'+fontColor+'; background-color:'+color+';" readonly="readonly"></td>';
						item +='<td><input id="return_price_'+componentId+'-'+consignedType+'" type="text" class="view k-textbox col-input-number-returnPrice" value="'+returnPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ",")+'" style="padding-right:5px; color:'+fontColor+'; background-color:'+color+';" readonly="readonly"></td>';
						item +='<td><input id="total_price_'+componentId+'-'+consignedType+'" type="text" class="view k-textbox col-input-number-totalPrice" value="'+totalPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ",")+'" style="padding-right:5px; color:'+fontColor+'; background-color:'+color+';" readonly="readonly"></td>';

					item +='<td style="display:none;">' + componentId + '</td>';
					item += '</tr>';
					$(".consigned_items").append(item);
				}

			}
			$("#numOfComponent").text("TOTAL: "+consigned_items.length+" EA");
			$("#numOfInventory").text(totalReleaseTotalCnt+" EA");
			$("#numOfReturn").text(totalReturnCnt+" EA");
			totalReleasePrice += '';
			$("#release_price").text('￦'+totalReleasePrice.replace(/\B(?=(\d{3})+(?!\d))/g, ","));

			totalReturnPrice += '';
			$("#return_price").text('￦'+totalReturnPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
			$("#return_price").val(totalReturnPrice);

			totalTotalPrice += '';
			$("#total_price").text('￦'+totalTotalPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ","));

//				computeTotalPrice();
//		 		computeTotalReturnPrice();
		}



		function fnInitConsignedParentData() {
			console.log("CompanyList.fnInitConsignedParentData() Load");

			var url = '${getConsignedParentInfo}';
			var params = {
	    			PROXY_ID: _pProxyId
	    	};

			$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : params,
	    		async : false,
	    		success : function(data) {

	    			if(data.SUCCESS){

	    				$('#coupon_mange').val(data.COUPON_MANAGE);
 			    		$('#coupon_customer').val(data.COUPON_CUSTOMER);

 			    		$('#COA_TYPE_OLD').val(data.OLD_COA);
 			    		$('#COA_TYPE_NEW').val(data.NEW_COA);
 			    		$('#coaNo_old').val(data.OLD_COA_SN);
 			    		$('#coaNo_new').val(data.NEW_COA_SN);

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

	    			}
	    		}
	    	});
		}

		function fnInitConsignedAdjust() {
			console.log("CompanyList.fnInitConsignedAdjust() Load");

//  			var arrTypeName =['','additional-','refund-'];
// 			var arrDtName =['register','additional','refund'];
// 			var arrTypeName2 =['release','additional','refund'];

			var arrTypeName =['','refund-'];
			var arrDtName =['register','refund'];
			var arrTypeName2 =['release','refund'];
			var arrAdjustType =[1,3];
			var arrAdjustDate =[1,3];


			var url = '${getConsignedAdjustInfo}';

			var params = {
	    			PROXY_ID: _pProxyId,
	    			COMPANY_ID: _companyId,
	    			ADJUSTMENT_TYPE: 1,
	    			TYPE_ID: _typeId
	    	};



			for(var i = 0 ; i < arrTypeName.length; i++){

				if(i == 0)
					params.PROXY_ID = _pProxyId;
				else
					params.PROXY_ID = _proxyId;

				params.ADJUSTMENT_TYPE =arrAdjustType[i];
				var typeName = arrTypeName[i];


				$.ajax({
		    		url : url,
		    		type : "POST",
		    		data : params,
		    		async : false,
		    		success : function(data) {

		    			_stateDateData[30+i+1] = "";
		    			if(data.SUCCESS){

		    				if(i == 0){
		    					var price = data.PRICE;
		    					$('#original_price').text(price);
		    					price += '';
		    					$('#original_price').val('￦'+price.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
		    				}

// 		    				if(i == 1){
// 		    					console.log("data.PRICE = "+data.PRICE);
// 		    					var price = data.PRICE;
// 		    					$('#additional_price').val(price);

// 		    				}
		    				if(i == 1){
		    					var price = data.PRICE;
// 		    					$('#refund_price').text(price);
// 		    					price += '';
// 		    					$('#refund_price').val('￦'+price.replace(/\B(?=(\d{3})+(?!\d))/g, ","));

								$('#refund_price').val(price);

		    					$("input:radio[name='REFUNDTYPE']:radio[value='"+data.REFUND_TYPE+"']").prop('checked', true); // 선택하기
		    				}

		    				$('#'+typeName+'price-produce-input').val(data.PRICE_PRODUCE);
// 		    				document.getElementById(typeName+"price-produce-select").style.display = "none";
// 		    				document.getElementById(typeName+"price-produce-input").style.display = "block";

		    				$('#'+typeName+'price-reproduce-input').val(data.PRICE_REPRODUCE);
// 		    				document.getElementById(typeName+"price-reproduce-select").style.display = "none";
// 		    				document.getElementById(typeName+"price-reproduce-input").style.display = "block";

		    				$('#'+typeName+'price-delivery-input').val(data.PRICE_DEILIVERY);
// 		    				document.getElementById(typeName+"price-delivery-select").style.display = "none";
// 		    				document.getElementById(typeName+"price-delivery-input").style.display = "block";

		    				$('#'+typeName+'price-quick-input').val(data.PRICE_QUICK);
// 		    				document.getElementById(typeName+"price-quick-select").style.display = "none";
// 		    				document.getElementById(typeName+"price-quick-input").style.display = "block";

		    				$('#release-dt'+(arrAdjustDate[i])).val(data.REGISTER_DT);

		    				$('#'+arrDtName[arrAdjustDate[i]]+'Dt-history').val(data.REGISTER_HISTORY);


		    				var sum = (data.PRICE_PRODUCE*1) + (data.PRICE_REPRODUCE*1) + (data.PRICE_DEILIVERY*1) + (data.PRICE_QUICK*1);
							sum+='';
		    				$('#'+arrTypeName2[i]+'-sum').val('￦'+sum.replace(/\B(?=(\d{3})+(?!\d))/g, ","));

		    				_stateDateData[30+i+1] = data.REGISTER_DT_LIST;
// 		    				if(i == 0)
		    					setTooltip($("[id*='release-dt" + arrAdjustType[i] +"']"), data.REGISTER_DT_LIST, 30+i+1);
// 		    				else if(i == 1)
// 		    					setTooltip($("[id*='release-dt" + 1 +"']"), data.REGISTER_DT_LIST);
// 		    				else if(i == 2)
// 		    					setTooltip($("[id*='release-dt" + 1 +"']"), data.REGISTER_DT_LIST);

		    					if(_stateDateData[30+i+1] == null)
									_stateDateData[30+i+1] = "";

		    			}
		    			else{

		    				if(data.DEFAULT && arrAdjustType[i] == 3){
		    					console.log("11111");

		    					$('#'+typeName+'price-produce-input').val(data.PRICE_PRODUCE);

			    				$('#'+typeName+'price-reproduce-input').val(data.PRICE_REPRODUCE);

			    				$('#'+typeName+'price-delivery-input').val(data.PRICE_DEILIVERY);

			    				$('#'+typeName+'price-quick-input').val(data.PRICE_QUICK);

		    				}
		    			}

		    		}
		    	});
			}

			fnComputeReleaseSum();
// 			fnComputeSum('additional');
			fnComputeSum('refund');
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


		    	priceProduce = $('#price-produce-input').val()*1;
				if(priceProduce == '')
					priceProduce = 0;

				priceReproduce = $('#price-reproduce-input').val()*1;
				if(priceReproduce == '')
					priceReproduce = 0;

				priceDelivery = $('#price-delivery-input').val()*1;
				if(priceDelivery == '')
					priceDelivery = 0;

				priceQuick = $('#price-quick-input').val()*1;
				if(priceQuick == '')
					priceQuick = 0;

				var sum =originalPrice +  priceProduce + priceReproduce + priceDelivery + priceQuick ;
				sum += '';
				$('#release-sum').val('￦'+sum.replace(/\B(?=(\d{3})+(?!\d))/g, ","));

		}

		function setReturnCnt(proxyPartId, componentId, x, consignedType) {
			numberWithCommas(componentId, x, consignedType);
			fnUpdateComponentUnit(proxyPartId, componentId, x, consignedType);

// 			var refuntType = $("input:radio[name=REFUNDTYPE]:checked").val();

// 			if(refuntType == 2){
// 				$('#refund_price').val($('#additional_price').val());
// 	    		$('#refund_price').text($('#additional_price').text());
// 			}
// 			else 	if(refuntType == 3){
// 				var price = ($('#original_price').text()*1) + ($('#additional_price').text()*1);
// 				$('#refund_price').text(price);
// 				price += '';
// 				price = '￦'+price.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
// 				$('#refund_price').val(price);

// 			}
		}

		function setAdditionalPrice(x) {


			console.log("x = "+x);
			var refuntType = $("input:radio[name=REFUNDTYPE]:checked").val();

			if(refuntType == 2){

// 				$('#refund_price').text(x);
// 				var price = x+"";
// 				price = '￦'+price.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				$('#refund_price').val(x);

			}
			else 	if(refuntType == 3){
				var price = ($('#original_price').text()*1) + (x*1);
// 				$('#refund_price').text(price);
// 				price += '';
// 				price = '￦'+price.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				$('#refund_price').val(price);

			}

// 			fnComputeSum('additional');
		}

	function numberWithCommas(componentId, x, consignedType) {

		var orderCnt = $('#componentId-cnt-'+componentId+'-'+consignedType).val()*1;
		var returnCnt = x*1;


		var id = $('#price_'+componentId+'-'+consignedType);
		var price = parseInt(id.val().replace(/,/g,"")) * (orderCnt-returnCnt);

		var returnPrice = parseInt(id.val().replace(/,/g,"")) * (returnCnt);


		price += "";
		returnPrice += "";
		var returnPriceId = $('#return_price_'+componentId+'-'+consignedType);
		var toatalPriceId = $('#total_price_'+componentId+'-'+consignedType);

		returnPriceId.val(returnPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); // 정규식을 이용해서 3자리 마다 , 추가
		toatalPriceId.val(price.replace(/\B(?=(\d{3})+(?!\d))/g, ",")); // 정규식을 이용해서 3자리 마다 , 추가

		computeCnt();
 		computeTotalPrice();
 		computeTotalReturnPrice();
	}

	function computeCnt(){
		var totalCnt = 0;
		var inputs = $(".col-input-number-return");
		for(var i=0; i<inputs.length; i++) {
			var component = $(".col-input-number-return")[i];
			var cnt = component.value * 1;
			totalCnt += cnt;
		}

		$("#numOfReturn").text(totalCnt+" EA");
	}

	function computeTotalPrice(){

		var totalPrice= 0;

		var inputs = $(".col-input-number-totalPrice");
		for(var i=0; i<inputs.length; i++) {
			var cntVar = $(".col-input-number-totalPrice")[i];

			var price = parseInt(cntVar.value.replace(/,/g,"")) * 1;

// 			console.log("price = "+i+ " "+price);

			totalPrice += price;
		}


 		$("#total_price").val(totalPrice);

 		totalPrice += "";

 		$("#total_price").text('￦'+totalPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ","));
	}

	function computeTotalReturnPrice(){

		var returnPrice= 0;

		var inputs = $(".col-input-number-returnPrice");
		for(var i=0; i<inputs.length; i++) {
			var cntVar = $(".col-input-number-returnPrice")[i];

			var price = parseInt(cntVar.value.replace(/,/g,"")) * 1;

			returnPrice += price;
		}


 		$("#return_price").val(returnPrice);

 		returnPrice += "";

 		$("#return_price").text('￦'+returnPrice.replace(/\B(?=(\d{3})+(?!\d))/g, ","));


 		//fnSetRefundState();

 		var refuntType = $("input:radio[name=REFUNDTYPE]:checked").val();

 		if(refuntType == 3){
			var price = ($('#return_price').val()*1);
			$('#refund_price').val(price);
		}

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

    function fnUpdateComponentUnit(proxyPartId,componentId, returnCnt, consignedType){

    	var params = {
    			PROXY_PART_ID: proxyPartId,
    			RETURN_CNT: returnCnt,
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

    function fnUpdateAdjust(type, typeName){


		var today = new Date().toISOString().substring(0, 10);

		var price;
	   	var priceProduce;
	   	var priceReproduce;
	   	var priceDelivery;
	   	var priceQuick;
	   	var releaseDt;

	   	var index = 1;

	   	if(typeName.includes('additional') || typeName.includes('refund')  ){
	    	price =$('#'+typeName+'_price').val()*1;
	    	index = 2;
	   	}
	   	else
	   	 	price =$('#'+typeName+'_price').text()*1;

	   	if(document.getElementById(typeName+"-price-produce-select").style.display === "none")
       		priceProduce = $('#'+typeName+'-price-produce-input').val()*1;
		else
		 	priceProduce = $('#'+typeName+'-price-produce-select').val()*1;

		if(priceProduce == '')
			priceProduce = 0;

		if(document.getElementById(typeName+"-price-reproduce-select").style.display === "none")
			priceReproduce = $('#'+typeName+'-price-reproduce-input').val()*1;
		else
			priceReproduce = $('#'+typeName+'-price-reproduce-select').val()*1;

		if(priceReproduce == '')
			priceReproduce = 0;

		if(document.getElementById(typeName+"-price-delivery-select").style.display === "none")
			priceDelivery =$('#'+typeName+'-price-delivery-input').val()*1;
		else
			priceDelivery = $('#'+typeName+'-price-delivery-select').val()*1;

		if(priceDelivery == '')
			priceDelivery = 0;

		if(document.getElementById(typeName+"-price-quick-select").style.display === "none")
			priceQuick =$('#'+typeName+'-price-quick-input').val()*1;
		else
			priceQuick = $('#'+typeName+'-price-quick-select').val()*1;

		if(priceQuick == '')
			priceQuick = 0;


//		 checkDt.get(0).value = default_start_date.toISOString().substring(0, 10);

		releaseDt = $('#release-dt'+type).val();

		if(releaseDt == '')
			releaseDt = today;



   	var params = {
   		PROXY_ID:  _proxyId,
   		ADJUSTMENT_TYPE: type,
   		PRICE: price,
   		PRICE_PRODUCE: priceProduce,
   		PRICE_REPRODUCE: priceReproduce,
   		PRICE_DEILIVERY: priceDelivery,
   		PRICE_QUICK: priceQuick,
   		REGISTER_DT: releaseDt
   	}

    if(typeName.includes('refund')){

    	params.REFUND_TYPE = $("input:radio[name=REFUNDTYPE]:checked").val()*1;
    	index = 3;
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
				    				GochigoAlert("수정되었습니다.", true, "dangol365 ERP");

				    				$('#release-dt'+type).value = releaseDt;

			    			 		if($('#'+typeName+'Dt-history').val() == '')
				    					$('#'+typeName+'Dt-history').val(releaseDt);
				    				else
				    					$('#'+typeName+'Dt-history').val($('#'+typeName+'Dt-history').val()+'/'+releaseDt);

			    			 		updateTooltip($("[id*='release-dt" + index +"']"), 30+index);
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

    	var listComponent = new Array();
    	var inputs = $(".col-input-number");

		for(var i=0; i<inputs.length; i++) {
			var component = $(".col-input-number")[i];
			var cnt = component.value;
			var id = component.id;
			var componentId = id.substr(20);
			var vomponentCd = id.substr(16,3);

			var params = {
		    		COMPONENT_ID:componentId,
		    		COMPONENT_CD: vomponentCd,
		    		COMPONENT_CNT: cnt
			}

			listComponent.push(params);
		}


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

    		DATA: listComponent
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
				    				GochigoAlert("수정되었습니다.", true, "dangol365 ERP");

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
			$('#coupon_mange').attr("readonly",false);
			$('#coupon_customer').attr("readonly",false);

			$('#coupon_mange').css("background","#FFFFFF");
			$('#coupon_customer').css("background","#FFFFFF");
		}

		function fnModifComponent() {

			var url = '${consignedPopup}';

			var query = "?content=component&KEY=PROXY_ID&PROXY_ID="+_proxyId+"&KEY1=RECEIPT&RECEIPT="+$('#RECEIPT_NO').val();

			var width, height;

			width = "1600";
	    	height = "800";

			var xPos  = (document.body.clientWidth /2) - (width / 2);
		    xPos += window.screenLeft;
		    var yPos  = (screen.availHeight / 2) - (height / 2);

		    window.open("<c:url value='"+url+query+"'/>", "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);

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

// 		if(inputId.includes('additional'))
// 			fnComputeSum('additional');
// 		else
			if(inputId.includes('refund'))
			fnComputeSum('refund');


		}

		function fnComputeSum(typeName)
		{
				var price;
		    	var priceProduce;
		    	var priceReproduce;
		    	var priceDelivery;
		    	var priceQuick;

		    	price = $('#'+typeName+'_price').val()*1;
		    	console.log("price = "+price);

		    	if(document.getElementById(typeName+"-price-produce-select").style.display === "none")
		       		priceProduce = $('#'+typeName+'-price-produce-input').val()*1;
	    		else
	    		 	priceProduce = $('#'+typeName+'-price-produce-select').val()*1;

	    		if(priceProduce == '')
	    			priceProduce = 0;

	    		if(document.getElementById(typeName+"-price-reproduce-select").style.display === "none")
	    			priceReproduce = $('#'+typeName+'-price-reproduce-input').val()*1;
	    		else
	    			priceReproduce = $('#'+typeName+'-price-reproduce-select').val()*1;

	    		if(priceReproduce == '')
	    			priceReproduce = 0;

	    		if(document.getElementById(typeName+"-price-delivery-select").style.display === "none")
	    			priceDelivery =$('#'+typeName+'-price-delivery-input').val()*1;
	    		else
	    			priceDelivery = $('#'+typeName+'-price-delivery-select').val()*1;

	    		if(priceDelivery == '')
	    			priceDelivery = 0;

	    		if(document.getElementById(typeName+"-price-quick-select").style.display === "none")
	    			priceQuick =$('#'+typeName+'-price-quick-input').val()*1;
	    		else
	    			priceQuick = $('#'+typeName+'-price-quick-select').val()*1;

	    		if(priceQuick == '')
	    			priceQuick = 0;

				var sum = priceProduce + priceReproduce + priceDelivery + priceQuick + price;
				sum += '';
				$('#'+typeName+'-sum').text(sum);

				$('#'+typeName+'-sum').val('￦'+sum.replace(/\B(?=(\d{3})+(?!\d))/g, ","));

				if(typeName == 'additional'){
					var refuntType = $("input:radio[name=REFUNDTYPE]:checked").val();

					if(refuntType == 2 || refuntType == 3)
						fnSetRefundState();

				}
		}

		function fnSetRefundState()
		{
			var refuntType = $("input:radio[name=REFUNDTYPE]:checked").val();

			var arrTypeName = [];
			var price = 0;

			console.log("refuntType = "+refuntType);

			if(refuntType == 0){

				$('#refund_price').attr("readonly",true);
				$('#release-dt3').attr("readonly",true);

				document.getElementById("refund-price-produce-select").style.display = "block";
				document.getElementById("refund-price-produce-input").style.display = "none";
				$('#refund-price-produce-select').val(0);

				document.getElementById("refund-price-reproduce-select").style.display = "block";
				document.getElementById("refund-price-reproduce-input").style.display = "none";
				$('#refund-price-reproduce-select').val(0);

	    		document.getElementById("refund-price-delivery-select").style.display = "block";
	    		document.getElementById("refund-price-delivery-input").style.display = "none";
	    		$('#refund-price-delivery-select').val(0);

	    		document.getElementById("refund-price-quick-select").style.display = "block";
	    		document.getElementById("refund-price-quick-input").style.display = "none";
	    		$('#refund-price-quick-select').val(0);
	    		$('#refund-sum').val('￦0');

	    		$('#refund_price').val(0);
// 	    		$('#refund_price').text('0');

	    		return;

			}
			else 	if(refuntType == 1){
				arrTypeName[0] = '';

				$('#refund_price').val($('#original_price').text());
// 	    		$('#refund_price').text($('#original_price').text());
			}
			else if(refuntType == 2){
				arrTypeName[0] = 'additional-';

// 				var price = $('#additional_price').val()+"";
// 				price = '￦'+price.replace(/\B(?=(\d{3})+(?!\d))/g, ",");

				$('#refund_price').val($('#additional_price').val());
 //	    		$('#refund_price').text($('#additional_price').val());
			}
			else 	if(refuntType == 3){
// 				arrTypeName[0] = '';
// 				arrTypeName[1] = 'additional-';

// 				var price = ($('#original_price').text()*1) + ($('#return_price').val()*1);
				var price = ($('#return_price').val()*1);
				$('#refund_price').val(price);
// 				price += '';
// 				price = '￦'+price.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
// 				$('#refund_price').val(price);

			}
			else 	if(refuntType == 4){
				$('#refund_price').attr("readonly",false);

// 				$('#refund-price-produce-input').attr("readonly",false);
// 				$('#refund-price-reproduce-input').attr("readonly",false);
// 				$('#refund-price-delivery-input').attr("readonly",false);
// 				$('#refund-price-quick-input').attr("readonly",false);

				return;
			}

			var priceProduceTotal = 0;
	    	var priceReproduceTotal = 0;
	    	var priceDeliveryTotal = 0;
	    	var priceQuickTotal = 0;

			var priceProduce;
	    	var priceReproduce;
	    	var priceDelivery;
	    	var priceQuick;

			for(var i = 0; i< arrTypeName.length; i++){

				var typeName = arrTypeName[i];

				if(document.getElementById(typeName+"price-produce-select").style.display === "none")
		       		priceProduce = $('#'+typeName+'price-produce-input').val()*1;
	    		else
	    		 	priceProduce = $('#'+typeName+'price-produce-select').val()*1;

	    		if(priceProduce == '')
	    			priceProduce = 0;

	    		if(document.getElementById(typeName+"price-reproduce-select").style.display === "none")
	    			priceReproduce = $('#'+typeName+'price-reproduce-input').val()*1;
	    		else
	    			priceReproduce = $('#'+typeName+'price-reproduce-select').val()*1;

	    		if(priceReproduce == '')
	    			priceReproduce = 0;

	    		if(document.getElementById(typeName+"price-delivery-select").style.display === "none")
	    			priceDelivery =$('#'+typeName+'price-delivery-input').val()*1;
	    		else
	    			priceDelivery = $('#'+typeName+'price-delivery-select').val()*1;

	    		if(priceDelivery == '')
	    			priceDelivery = 0;

	    		if(document.getElementById(typeName+"price-quick-select").style.display === "none")
	    			priceQuick =$('#'+typeName+'price-quick-input').val()*1;
	    		else
	    			priceQuick = $('#'+typeName+'price-quick-select').val()*1;

	    		if(priceQuick == '')
	    			priceQuick = 0;

	    		priceProduceTotal +=priceProduce;
	    		priceReproduceTotal +=priceReproduce;
	    		priceDeliveryTotal +=priceDelivery;
	    		priceQuickTotal +=priceQuick;

			}

			document.getElementById("refund-price-produce-select").style.display = "none";
			document.getElementById("refund-price-produce-input").style.display = "block";
			$('#refund-price-produce-input').val(priceProduceTotal);

			document.getElementById("refund-price-reproduce-select").style.display = "none";
			document.getElementById("refund-price-reproduce-input").style.display = "block";
			$('#refund-price-reproduce-input').val(priceReproduceTotal);

    		document.getElementById("refund-price-delivery-select").style.display = "none";
    		document.getElementById("refund-price-delivery-input").style.display = "block";
    		$('#refund-price-delivery-input').val(priceDeliveryTotal);

    		document.getElementById("refund-price-quick-select").style.display = "none";
    		document.getElementById("refund-price-quick-input").style.display = "block";
    		$('#refund-price-quick-input').val(priceQuickTotal);

    		var refuncPrice = $('#refund_price').val()*1;
    		var sum = refuncPrice + priceProduceTotal + priceReproduceTotal +  + priceDeliveryTotal + priceQuickTotal;
//     		$('#refund-sum').text(sum);
    		sum += '';
    		$('#refund-sum').val('￦'+sum.replace(/\B(?=(\d{3})+(?!\d))/g, ","));

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
			<span class="pagetitle"><span class="header-title30"></span> 생산대행 - 반품 </span>
		</div>

		<div id="consigned_return_btns" class="grid_btns_short" style="width: 100%; ">
		<button id="btnNewReceipt" onclick="fnNewReceipt()" class="k-button" style="float: left; width: 40px; background-color: slategray; margin-top:5px;margin-left:20px; padding: 3px 7px 3px 7px; font-size: 12px;">\
				<span class="k-icon k-i-track-changes" style="float: right; font-size: 18px; color: white;"></span>
			</button>
			<button id="btnGoReceiptList" onclick="fnGoReceiptList()" class="k-button" style="float: left; width: 40px; background-color: slategray; margin-top:5px;margin-left:10px; padding: 3px 7px 3px 7px; font-size: 12px;">
				<span class="k-icon k-i-table" style="float: right; font-size: 18px; color: white;"></span>
			</button>

			<button id="consigned_return_btn" type="button" onclick="fnReturnOrder()" class="k-button" style="float: right; display:none;" >반품 요청</button>
			<button id="consigned_receipt_cancel_btn" type="button" onclick="fnUpdateOrder()" class="k-button" style="float: right; display:none;">정보 수정</button>
			<input type="input" style="display:none;" id="PROXY_ID" name="ETC">
			<input type="input" style="display:none;" id="P_PROXY_ID" name="ETC">
		</div>

		<div style="padding: 0px;">

			<fieldset class="fieldSet" style="text-align: center;">

				<form id="frm_consigned_return_data" method="post" enctype="multipart/form-data" data-role="validator" novalidate="novalidate">

					<%-- 접수 정보 --%>
					<div class="info">

						<div class="sub-header-title"><span class="pagetitle"><span class="header-title30"></span> 접수 정보 </span></div>

						<table align = right id="tbl_consigned_receipt_info_data" class="table_default">

							<tbody>

								<tr>
									<td class="col-title">접수번호</td>
									<td class="col-content-25"><input type="input" class="view k-textbox col-input" id="RECEIPT_NO" name="RECEIPT_NO" style="height: 24px;" disabled></td>
									<td class="col-title">제품유형</td>
									<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="COMPONEN_NM" name="COMPONEN_NM">--%>
                                        <select id="PC_TYPE" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 92%; height: 22px; display: inline-block; margin-right: 3px; background: #ebebf5;" disabled>
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
                                                data-role="dropdownlist" style="width: 25%; height: 22px; display: inline-block; margin-right: 3px; background: #ebebf5;"
                                                onchange="changeGuaranteeTerm(value)" disabled>
											<option value="0">0</option>
										</select>
										<input id="datetimepicker_acceptance_start" title="datetimepicker" style="width:30%; height: 23px; display: inline-block; margin-right: 3px; padding-bottom: 2px"  readonly="readonly"/>
										<span style="margin-right: 3px;"> ~ </span>
										<input id="datetimepicker_acceptance_end" title="datetimepicker" style="width:30%; height: 23px; display: inline-block; padding-bottom: 2px" readonly="readonly" />

									</td>
								</tr>

								<tr>
									<td class="col-title">판매처</td>
									<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="SALE_COMPANY" name="SALE_COMPANY">--%>
                                        <select id="COMPANY_ID" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 92%; height: 22px; display: inline-block; margin-right: 3px; background: #ebebf5;" disabled="disabled">
                                            <option value="0">0</option>
                                        </select>
                                    </td>
									<td class="col-title">판매경로</td>
									<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="SALE_ROOT" name="SALE_ROOT" value="3">--%>
                                        <select id="SALE_ROOT" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 92%; height: 22px; display: inline-block; margin-right: 3px; background: #ebebf5;" disabled>
                                            <option value="0">0</option>
                                        </select>
                                    </td>
								</tr>

								<tr>
									<td class="col-title" style="height: 24px;">출고유형</td>
									<td class="col-content-20">
										<input type="radio" name="RELEASE_TYPE" value="1" checked disabled/>택배
										<input type="radio" name="RELEASE_TYPE" value="2" disabled/>방문수령
										<input type="radio" name="RELEASE_TYPE" value="3"  disabled/>화물
									</td>
									<td class="col-title">참고사항</td>
									<td class="col-content-20" ><input type="input" id = "REQUEST" class="view k-textbox col-input" style="width: 100%; height: 24px;" name="REQUEST" readonly="readonly"></td>


								</tr>
								<tr>
									<td class="col-title">요청사항</td>
									<td class="col-content-25" ><input type="input" id = "DES" class="view k-textbox col-input" style="width: 226.5%; height: 24px;" name="DES" readonly="readonly"></td>

								</tr>

							</tbody>
						</table>
					</div>

					<%-- 고객 정보 --%>
					<div class="info">

						<div class="sub-header-title">
							<span class="pagetitle"><span class="header-title30"></span> 고객 정보 </span>
                            <div style="display: inline-block; float: right;">
<!--                                 <span style="margin-right: 15px"><input type="checkbox" id="chCopyUserInfo"> 수령인 정보 동일 </span> -->
                            </div>
						</div>

						<table id="tbl_consigned_receipt_customer_data" class="table_default">

							<tbody>

								<tr>
									<td class="col-title">고객명[1]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox col-input" id="CUSTOMER_NM_S" name="CUSTOMER_NM_S" style="height: 24px;" readonly="readonly"></td>
									<td class="col-title">고객명[2]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox col-input" id="CUSTOMER_NM_R" name="CUSTOMER_NM_R" style="height: 24px;" readonly="readonly"></td>
								</tr>

								<tr>
									<td class="col-title">전화번호[1]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="TEL_S" name="TEL_S" style="width:100%; height: 24px;" readonly="readonly"></td>
									<td class="col-title">전화번호[2]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="TEL_R" name="TEL_R" style="width:100%; height: 24px;" readonly="readonly"></td>
								</tr>

								<tr>
									<td class="col-title">휴대폰[1]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="MOBILE_S" name="MOBILE_S" style="width:100%; height: 23px;" readonly="readonly"></td>
									<td class="col-title">휴대폰[2]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="MOBILE_R" name="MOBILE_R" style="width:100%; height: 23px;" readonly="readonly"></td>
								</tr>

								<tr>
									<td class="col-title" rowspan=2>주소</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="POSTAL_CD" name="POSTAL_CD" style="width:100%; " disabled></td>
									<td colspan="2" style="text-align: left;"><button onclick="fnSearchZipCode()" onsubmit="false" type="button" class="k-button" tabindex="1" disabled>우편번호 찾기</button></td>
								</tr>

								<tr>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="ADDRESS" name="ADDRESS" style="width:100%; height: 24px;" disabled></td>
									<td colspan="2" style="width:50%;"><input type="input" class="view k-textbox" id="ADDRESS_DETAIL" name="ADDRESS_DETAIL" style="width:100%; height: 24px;" readonly="readonly"></td>
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
					</div>
					<span></span>
					<div style="display: inline-block;  width: 48%; text-align: center">
						<span class="pagetitle">
							<span class="header-title30"></span> 쿠폰 정보
<!-- 								<button onclick="fnModifCoupon()" class="k-button" style="float: right; width: 40px; background-color: slategray; margin-top:5px; padding: 3px 7px 3px 7px; font-size: 12px;"> -->
<!-- 									<span class="k-icon k-i-pencil" style="float: right; font-size: 18px; color: white;"></span> -->
<!-- 								</button> -->
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
								<input id="delivery_type" type="text" class="view k-textbox col-input" readonly="readonly" style="background: #ebebf5; text-align:center;'">
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

			<div id="processInfo" class="info" style="width: 31%;" >
				<div class="sub-header-title">
					<span class="pagetitle"><span class="header-title30"></span> 진행 정보 </span>
				</div>

				<table align = right id="tbl_consigned_process_info_data1" class="table_default">

					<thead class="col-header-title">
						<td> 접수 <input type="checkbox" id="receipt_status_0" onclick='fnChangeReceiptStatus(0);' disabled> </td>
						<td> 처리중 <input type="checkbox" id="receipt_status_1" onclick='fnChangeReceiptStatus(1);' disabled> </td>
						<td> 보류 <input type="checkbox" id="receipt_status_2" onclick='fnChangeReceiptStatus(2);' disabled> </td>
						<td> 취소 <input type="checkbox" id="receipt_status_3" onclick='fnChangeReceiptStatus(3);' disabled> </td>
						<td> 출고완료 <input type="checkbox" id="receipt_status_4" onclick='fnChangeReceiptStatus(4);' disabled> </td>

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

				<div id="returnInfo" class="info" style="width: 31%;" >
				<div id="return_header" class="sub-header-title">
					<span class="pagetitle"><span class="header-title30" ></span> 반품 정보 </span>
				</div>

				<table align = right id="tbl_consigned_return_info_data" class="table_default">

					<thead class="col-header-title">
						<td> 반품요청 <input type="checkbox" id="receipt_status_5" onclick='fnChangeReceiptStatus(5);' > </td>
						<td> 반품입고 <input type="checkbox" id="receipt_status_6" onclick='fnChangeReceiptStatus(6);'> </td>
						<td> 교환출고 <input type="checkbox" id="receipt_status_7" onclick='fnChangeReceiptStatus(7);'> </td>
						<td> 반품취소 <input type="checkbox" id="receipt_status_8" onclick='fnChangeReceiptStatus(8);' > </td>
						<td> 반품완료 <input type="checkbox" id="receipt_status_9" onclick='fnChangeReceiptStatus(9);' > </td>
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
						<td> 제품 S/N </td>
						<td> CPU 사양 </td>
						<td>
							<span class="header-title30"></span> COA NO
<!-- 								<button id="SNEditBtn" onclick="fnModifSN()" class="k-button" style=" float: right; width: 28px; height: 18px; background-color: slategray; margin:2px 2px 0px 0px ; padding: 0px 5px 0px 5px; font-size: 8px;"> -->
<!-- 									<span  class="k-icon k-i-pencil" style="float: right; font-size: 15px; color: white;"></span> -->
<!-- 								</button> -->

<!-- 								<button id="SNSaveBtn" onclick="fnSaveSN()" class="k-button" style="display:none;float: right; width: 28px; height: 18px; background-color: slategray; margin:2px 2px 0px 0px ; padding: 0px 5px 0px 5px; font-size: 8px;"> -->
<!-- 									<span class="k-icon k-i-save" style="float: right; font-size: 15px; color: white;"></span> -->
<!-- 								</button> -->
							</span>
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

				<div class="sub-header-title" style="width: 100%; height: 30px; vertical-align: middle;">
					<span class="pagetitle">
						<span class="header-title30" style="vertical-align: middle;"> 제품 정보 </span>
<!-- 						<button id="consigned_return_component_btn" type="button" onclick="fnUpdateComponent()" class="k-button" style="float: right; font-size: 13px;margin-right:5px;margin-top:3px;">정보 수정</button> -->
<!-- 							<button onclick="fnModifComponent()" class="k-button" style="float: right; width: 40px; background-color: slategray; margin-top:5px;margin-right:12px; padding: 3px 7px 3px 7px; font-size: 12px;"> -->
<!-- 								<span class="k-icon k-i-track-changes-enable" style="float: right; font-size: 18px; color: white;"></span> -->
<!-- 							</button> -->
<!-- 									<button class="k-button searched-item" style="float: right; width: 30px; height: 25px; background-color: slategray; margin:3px 5px 0px 0px ; font-size: 10px;"> -->
<!-- 										<span class="k-icon k-i-print" style="font-size: 16px; color: white;"></span> -->
<!-- 									</button> -->
									<button id="returnCheckComponent" onclick="fnReturnCheckComponent()" class="k-button" style="float: right; width: 30px; height: 25px; background-color: slategray; margin:3px 5px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;">
										<span class="k-icon k-i-mirror" style="float: right; font-size: 15px; color: white;"></span>
									</button>
					</span>
				</div>

				<table id="tbl_consigned_receipt_product_data" class="stripe table_default">

					<colgroup>
						<col width="6%">
						<col width="46%">
<%-- 						<col width="7%"> --%>
						<col width="9%">
						<col width="9%">
<%-- 						<col width="9%"> --%>
						<col width="9%">
						<col width="9%">
						<col width="12%">
					</colgroup>

					<thead>
						<tr>
							<td class="col-header-title">품목명</td>
							<td class="col-header-title">부품명</td>
							<td class="col-header-title">출고여부</td>
							<td class="col-header-title">반품여부</td>
<!-- 							<td class="col-header-title">불량수량</td> -->
<!-- 							<td class="col-header-title">금액</td> -->
							<td class="col-header-title">출고 금액</td>
							<td class="col-header-title">반품 금액</td>
							<td class="col-header-title">총 금액</td>
						</tr>
					</thead>
				</table>

				<div class="scrollable-div-return">

					<table class="stripe table_scroll">

						<colgroup>
						<col width="6%">
						<col width="46%">
<%-- 						<col width="7%"> --%>
						<col width="9%">
						<col width="9%">
<%-- 						<col width="9%"> --%>
						<col width="9%">
						<col width="9%">
						<col width="10%">
						</colgroup>

						<tbody class="consigned_items">
						</tbody>

					</table>

				</div>


				<div style="vertical-align: middle; height: 30px; padding: 0px; background-color: lightgray; margin: 0px 0px 2px 0px;">

					<table class="table_default">

						<colgroup>
							<col width="52.3%">
<%-- 							<col width="7%"> --%>
							<col width="8.7%">
							<col width="9%">
<%-- 							<col width="9%"> --%>
							<col width="9%">
							<col width="9%">
							<col width="12%">
						</colgroup>

						<tbody>
							<tr class="col-header-title">
								<td ><label id="numOfComponent">TOTAL: 0 EA</label></td>
								<td ><label id="numOfInventory">0 EA</label></td>
								<td ><label id="numOfReturn">0 EA</label></td>
<!-- 								<td ><label id="numOfFault">0 EA</label></td> -->
<!-- 								<td ></td> -->
								<td ><label id="release_price">￦0</label></td>
								<td ><label id="return_price">￦0</label></td>
								<td ><label id="total_price">￦0</label></td>

<!-- 								<td colspan="1"> -->
<!-- 									<button class="k-button searched-item" style="width: 40px; background-color: slategray; margin: 1px;"> -->
<!-- 										<span class="k-icon k-i-print" style="font-size: 16px; color: white;"></span> -->
<!-- 									</button> -->
<!-- 								</td> -->

							</tr>
						</tbody>

					</table>
				</div>
			</div>

			<div id="detail_info" class="info" style="background-color: lightgray">

				<div class="sub-header-title" style="height: 25px; vertical-align: middle;">
					<span class="pagetitle" style="vertical-align: middle;">
						<span class="header_title30" style="vertical-align: middle;"> </span> 정산 스펙
					</span>
				</div>

				<%-- Table 1 --%>
				<div class="table-group">
					<table id="tbl_consigned_receipt_detail_data1" class="table-inner">

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
								<td class="col-title-center" style="height: 21px;"> 원가 </td>
								<td colspan="2" class="col-title-center"> 생산 </td>
								<td colspan="2" class="col-title-center"> 물류 </td>
								<td rowspan="2" class="col-title-center"> 합계 </td>
							</tr>

							<tr>
								<td class="col-title-center" style="height: 21px;"> 제품 정보 </td>
								<td class="col-title-center"> 기본 </td>
								<td class="col-title-center"> 재생산 </td>
								<td class="col-title-center"> 택배 </td>
								<td class="col-title-center"> 퀵배송 </td>
							</tr>

							<tr>
								<td class="input-col"> <input type="input" id="original_price"class="view k-textbox table-inner-col-input" disabled style="text-align:center;height: 23px;" value = "0"></td> <%-- 원가 > 제품정보 --%>
								<td class="input-col"> <%-- 생산 > 기본 --%>
								<select id="price-produce-select" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 23px; display:none; margin-right: 3px; background: #ebebf5;">
									</select>
									<input id="price-produce-input" type="text" class="view k-textbox table-inner-col-input" style="display:  inline-block; height: 23px; text-align:center;" value="0" disabled>
								</td>
								<td class="input-col"> <%-- 생산 > 재생산 --%>
								<select id="price-reproduce-select" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 23px; display: none; margin-right: 3px; background: #ebebf5;">
									</select>
									<input id="price-reproduce-input" type="text" class="view k-textbox table-inner-col-input" style="display: inline-block; height: 23px; text-align:center;" value="0" disabled>
								</td>
								<td class="input-col"> <%-- 물류 > 택배 --%>
								<select id="price-delivery-select"  class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 23px; display: none; margin-right: 3px; background: #ebebf5;">
									</select>
									<input id="price-delivery-input" type="text" class="view k-textbox table-inner-col-input" style="display: inline-block; height: 23px; text-align:center;" value="0" disabled>
								</td>
								<td class="input-col"> <%-- 물류 > 퀵배송 --%>
								<select id="price-quick-select"  class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 23px; display: none; margin-right: 3px; background: #ebebf5;">
									</select>
									<input id="price-quick-input" type="text" class="view k-textbox table-inner-col-input" style="display: inline-block; height: 23px; text-align:center;" value="0" disabled>
								</td>
								<td class="input-col"> <input type="input" id="release-sum"class="view k-textbox table-inner-col-input" disabled style="text-align:center; height: 23px;"> </td> <%-- 합계 --%>
							</tr>

							<tr>
								<td class="col-title-center"> 등록일자 </td>
								<td colspan="2"><input id="release-dt1" title="datetimepicker" style="width:100%; font-size: 13px; height: 22px; display: inline-block;" readonly="readonly"/></td>
								<td colspan="3" class="input-col"> <input type="text" id = "registerDt-history" class="view k-textbox table-inner-col-input line-break"  style="height: 23px;" disabled> </td>
							</tr>

						</tbody>

					</table>
				</div>

<%-- 				Table 2 --%>
<!-- 				<div class="table-group"> -->
<!-- 					<table id="tbl_consigned_receipt_detail_data2" class="table-inner"> -->

<%-- 						<colgroup> --%>
<%-- 							<col width="8%"> --%>
<%-- 							<col width="16%"> --%>
<%-- 							<col width="16%"> --%>
<%-- 							<col width="16%"> --%>
<%-- 							<col width="16%"> --%>
<%-- 							<col width="16%"> --%>
<%-- 							<col width="10%"> --%>
<%-- 						</colgroup> --%>

<!-- 						<tbody> -->

<!-- 							<tr> -->
<!-- 								<td rowspan="4" class="col-title-center"> 추가 정산 <br> <span style="font-size: 12px;">[반품 or 기타]</span> </td> -->
<!-- 								<td class="col-title-center" style="height: 21px;"> 원가 </td> -->
<!-- 								<td colspan="2" class="col-title-center"> 생산 </td> -->
<!-- 								<td colspan="2" class="col-title-center"> 물류 </td> -->
<!-- 								<td rowspan="2" class="col-title-center"> -->
<!-- 									<span class="header-title30"></span> 합계 -->
<!-- 									<button id="adjust-additional-btn" onclick="fnUpdateAdjust(2, 'additional')" class="k-button" style="float: right; width: 28px; height: 22px; background-color: slategray; margin:2px 2px 0px 0px ; padding: 0px 5px 0px 5px; font-size: 10px;"> -->
<!-- 										<span class="k-icon k-i-save" style="float: right; font-size: 15px; color: white;"></span> -->
<!-- 									</button> -->
<!-- 								</td> -->
<!-- 							</tr> -->

<!-- 							<tr> -->
<!-- 								<td class="col-title-center"> 제품 정보 </td> -->
<!-- 								<td class="col-title-center"> 기본 <span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('additional-price-produce')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> </td> -->
<!-- 								<td class="col-title-center"> 재생산 <span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('additional-price-reproduce')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> </td> -->
<!-- 								<td class="col-title-center"> 택배 <span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('additional-price-delivery')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> </td> -->
<!-- 								<td class="col-title-center"> 퀵배송 <span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('additional-price-quick')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span> </td> -->
<!-- 							</tr> -->

<!-- 							<tr> -->
<%-- 								<td class="input-col"> <input type="number" id="additional_price" onchange="setAdditionalPrice(this.value)" value=0 class="view k-textbox table-inner-col-input"  min="0" style="text-align:center; height: 25px;"> </td> 원가 > 제품정보 --%>
<%-- 								<td class="input-col"> 생산 > 기본 --%>
<!-- 									<select id="additional-price-produce-select" onchange="fnComputeSum('additional')" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 22px; margin-right: 3px; background: #ebebf5;"> -->
<!-- 										<option value="0">0</option> -->
<!-- 										<option value="2000">2000</option> -->
<!-- 										<option value="4000">4000</option> -->
<!-- 										<option value="6000">6000</option> -->
<!-- 									</select> -->
<!-- 									<input id="additional-price-produce-input" type="number" onchange="fnComputeSum('additional')" class="view k-textbox table-inner-col-input" style="display: none; height: 25px;" value="0"> -->
<!-- 								</td> -->
<%-- 								<td class="input-col"> 생산 > 재생산 --%>
<!-- 									<select id="additional-price-reproduce-select" onchange="fnComputeSum('additional')" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 22px;  3px; background: #ebebf5;"> -->
<!-- 										<option value="0">0</option> -->
<!-- 										<option value="2000">2000</option> -->
<!-- 										<option value="4000">4000</option> -->
<!-- 										<option value="6000">6000</option> -->
<!-- 									</select> -->
<!-- 									<input id="additional-price-reproduce-input" type="number" onchange="fnComputeSum('additional')" class="view k-textbox table-inner-col-input" style="display: none; height: 25px;" value="0"> -->
<!-- 								</td> -->
<%-- 								<td class="input-col"> 물류 > 택배 --%>
<!-- 									<select id="additional-price-delivery-select" onchange="fnComputeSum('additional')" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 22px;  margin-right: 3px; background: #ebebf5;"> -->
<!-- 										<option value="0">0</option> -->
<!-- 										<option value="2000">2000</option> -->
<!-- 										<option value="4000">4000</option> -->
<!-- 										<option value="6000">6000</option> -->
<!-- 									</select> -->
<!-- 									<input id="additional-price-delivery-input" type="number" onchange="fnComputeSum('additional')" class="view k-textbox table-inner-col-input" style="display: none; height: 25px;" value="0"> -->
<!-- 								</td> -->
<%-- 								<td class="input-col"> 물류 > 퀵배송 --%>
<!-- 									<select id="additional-price-quick-select" onchange="fnComputeSum('additional')" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 81%; height: 22px;  margin-right: 3px; background: #ebebf5;"> -->
<!-- 										<option value="0">0</option> -->
<!-- 										<option value="2000">2000</option> -->
<!-- 										<option value="4000">4000</option> -->
<!-- 										<option value="6000">6000</option> -->
<!-- 									</select> -->
<!-- 									<input id="additional-price-quick-input" type="number" onchange="fnComputeSum('additional')" class="view k-textbox table-inner-col-input" style="display: none; height: 25px;" value="0"> -->
<!-- 								</td> -->
<%-- 								<td class="input-col"> <input type="input" id="additional-sum"class="view k-textbox table-inner-col-input" disabled style="text-align:center; height: 25px;"> </td> 합계 --%>
<!-- 							</tr> -->

<!-- 							<tr> -->
<!-- 								<td class="col-title-center"> 등록일자 </td> -->
<!-- 								<td colspan="2"><input  id="release-dt2" title="datetimepicker" style="width:100%; font-size: 13px; display: inline-block; height: 22px;" /></td> -->
<!-- 								<td colspan="3" class="input-col"> <input type="text" id = "additionalDt-history" class="view k-textbox table-inner-col-input line-break"  style="height: 23px;" disabled> </td> -->
<!-- 							</tr> -->

<!-- 						</tbody> -->

<!-- 					</table> -->
<!-- 				</div> -->

				<%-- Table 3 --%>
				<div class="table-group">
					<table id="tbl_consigned_receipt_detail_data3" class="table-inner stripe">

						<div style="float: left; vertical-align: middle; font-size: 11px; margin: 2px 0px 1px 0px;">
						 	<input type="radio" name="REFUNDTYPE" value="0" checked />없음
							<input type="radio" name="REFUNDTYPE" value="1" />출고 정산 환급
<!-- 							<input type="radio" name="REFUNDTYPE" value="2" />추가 정산 환급 -->
							<input type="radio" name="REFUNDTYPE" value="3" />반품 정산 환급
							<input type="radio" name="REFUNDTYPE" value="4" />선택 환급
						</div>


						<button id="adjust_refund-btn" onclick="fnUpdateAdjust(3, 'refund')" class="k-button" style="float: right; width: 28px; height: 25px; background-color: slategray; margin:1px 2px 2px 0px ; padding: 0px 5px 0px 5px; font-size: 10px;">
							<span class="k-icon k-i-save" style="float: right; font-size: 15px; color: white;"></span>
						</button>



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
								<td class="col-title-center" style="height: 21px;"> 원가 </td>
								<td colspan="2" class="col-title-center"> 생산 </td>
								<td colspan="2" class="col-title-center"> 물류 </td>
								<td rowspan="2" class="col-title-center"> 합계 </td>
							</tr>

							<tr>
								<td class="col-title-center" style="height: 21px;"> 제품 정보 </td>
								<td class="col-title-center"> 기본
<!-- 									<span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('refund-price-produce')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span>  -->
								</td>
								<td class="col-title-center"> 재생산
<!-- 									<span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('refund-price-reproduce')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span>  -->
								</td>
								<td class="col-title-center"> 택배
<!-- 									<span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('refund-price-delivery')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span>  -->
								</td>
								<td class="col-title-center"> 퀵배송
<!-- 									<span class="k-icon k-i-pencil input-change-button" onclick="toggleInputType('refund-price-quick')" style="float: right; font-size: 13px; margin: 4px 5px 0px 0px; padding: 0px;"></span>  -->
								</td>
							</tr>

							<tr>
								<td class="input-col"> <input type="number" id="refund_price" onchange="fnComputeSum('refund')" class="view k-textbox table-inner-col-input" style="text-align:center; height: 26px;"  min="0" value = "0" ></td> <%-- 원가 > 제품정보 --%>
								<td class="input-col"> <%-- 생산 > 기본 --%>
									<select id="refund-price-produce-select" onchange="fnComputeSum('refund')" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="display: none; width: 81%; height: 23px; margin-right: 3px; background: #ebebf5;" >
										<option value="0">0</option>
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="refund-price-produce-input" type="number" onchange="fnComputeSum('refund')" class="view k-textbox table-inner-col-input" style="height: 26px; text-align:center;" value="0">
								</td>
								<td class="input-col"> <%-- 생산 > 재생산 --%>
									<select id="refund-price-reproduce-select" onchange="fnComputeSum('refund')" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="display: none; width: 81%; height: 23px; margin-right: 3px; background: #ebebf5;">
										<option value="0">0</option>
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="refund-price-reproduce-input" type="number" onchange="fnComputeSum('refund')" class="view k-textbox table-inner-col-input" style=" height: 26px; text-align:center;" value="0">
								</td>
								<td class="input-col"> <%-- 물류 > 택배 --%>
									<select id="refund-price-delivery-select" onchange="fnComputeSum('refund')" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="display: none; width: 81%; height: 23px;  margin-right: 3px; background: #ebebf5;">
										<option value="0">0</option>
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="refund-price-delivery-input" type="number" onchange="fnComputeSum('refund')" class="view k-textbox table-inner-col-input" style="height: 26px; text-align:center;" value="0" >
								</td>
								<td class="input-col"> <%-- 물류 > 퀵배송 --%>
									<select id="refund-price-quick-select" onchange="fnComputeSum('refund')" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="display: none; width: 81%; height: 23px;  margin-right: 3px; background: #ebebf5;">
										<option value="0">0</option>
										<option value="2000">2000</option>
										<option value="4000">4000</option>
										<option value="6000">6000</option>
									</select>
									<input id="refund-price-quick-input" type="number" onchange="fnComputeSum('refund')" class="view k-textbox table-inner-col-input" style="height: 26px; text-align:center;" value="0" >
								</td>
								<td class="input-col"> <input type="input" id="refund-sum"class="view k-textbox table-inner-col-input" disabled style="text-align:center; height: 26px;"> </td> <%-- 합계 --%>
							</tr>

							<tr>
								<td class="col-title-center"> 등록일자 </td>
								<td colspan="2"><input id="release-dt3" title="datetimepicker" style="width:100%; font-size: 13px; display: inline-block; height: 22px;"/></td>
								<td colspan="3" class="input-col"> <input type="text" id = "refundDt-history" class="view k-textbox table-inner-col-input line-break"  style="height: 23px;" disabled> </td>
							</tr>

						</tbody>

					</table>
				</div>

			</div>

			<div id="related_receipt_no_info" class="info" style="background-color: lightgray; display:none;">

<!-- 				<div class="sub-header-title" style="height: 35px; vertical-align: middle;"> -->
<!-- 					<span class="pagetitle" style="vertical-align: middle;"><span class="header_title30" style="vertical-align: middle;"></span> 선출고 접수번호 </span> -->
<!-- 				</div> -->

				<div class="table-group">

					<table id="tbl_consigned_related_receipt_no" class="table-inner stripe">

						<thead>
							<tr>
								<td class="col-title-center" style="height: 24px;"> (선출고)접수번호 </td>
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

