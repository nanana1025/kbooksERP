<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>


<c:url var="getConsignedInfo"					value="/consigned/getConsignedInfo.json" />
<c:url var="getCodeListCustom"				value="/common/getCodeListCustom.json" />
<c:url var="getLicenceInfo"						value="/consigned/getLicenceInfo.json"/>



<head>

	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	<title>DANGOL365 ERP | 주문서</title>

 	<link rel="stylesheet" type="text/css" href="/codebase/css/custom_style.css"/>
	<script src="/codebase/gochigo.kendo.ui.js"></script>
<!-- 	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> -->
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<!-- 	<link href="https://fonts.googleapis.com/css?family=Material+Icons|Material+Icons+Outlined|Material+Icons+Two+Tone|Material+Icons+Round|Material+Icons+Sharp" rel="stylesheet"> -->
	<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="/js/jquery-barcode.js"></script>

<style>
		.col-title-centerC {
			padding: 0px;
			text-align: center;
			background: lightgray;
			height:27px;
		}

		.col-title-leftC {
			padding: 0px 0px 0px 10px;
			text-align: left;
			background: lightgray;
			height:27px;
		}
</style>

	<style>
		body {
			margin: 0;
			padding: 0;
		}

		* {
			box-sizing: border-box;
			-moz-box-sizing: border-box;
		}

		.page {
			padding: 1.0cm; /* 페이지 여백 */
			width: 21cm;
			min-height: 29.7cm;
			margin: 0 auto;
		}

		.subpage {
			height: 257mm;
			margin: 0 auto;
		}

		@page {
			size: A4;
			margin: 0;
		}

		@media print {

			html, body {
				width: 210mm;
				height: 297mm;
			}

			.page {
				margin: 0;
				border: initial;
				width: initial;
				min-height: initial;
				box-shadow: initial;
				background: initial;
				page-break-after: always;
			}
		}

		.title {
			margin-bottom: 5px;
			vertical-align: middle;
		}

		.table-wrapper {
			margin-bottom: 12px;
		}

		table {
			width: 100%;
			text-align: right;
			border: 1px solid black;
			padding: 0px;
			margin: 0px;
		}

		td {
			height: 25px;
		}

		.col-title {
			width: 10%;
			padding: 0px 0px 0px 6px;
			text-align: left;
			background: lightgray;
		}

		input:disabled {
			background-color: #f9f9f9;
		}

	</style>

	<script type="text/javascript">

		var _proxyId;
		var _receipt;

		$(document).ready(function() {

			console.log("Consigned_orderSheet.jsp");

			var key = getParameterByName('KEY');
			_proxyId = getParameterByName(key);

			$("input[name='RELEASE_TYPE']").attr('disabled',true);
			fnInitData();
			fnInitConsignedData();
			fnInitConsignedLicence();
			getRecentDate();

			$("#bcTarget").barcode(_receipt, "code128",{barWidth:1, barHeight:20,showHRI:false,});

		});

		function getRecentDate(){
		    var dt = new Date();

		    var recentYear = dt.getFullYear();
		    var recentMonth = dt.getMonth() + 1;
		    var recentDay = dt.getDate();

		    $('#year').text(recentYear+"년");
		    $('#month').text(recentMonth+"월");
		    $('#day').text(recentDay+"일");
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

//		      			var listModelCd = data.TN_MODEL_LIST;
//		      			for(var i=0; i<listModelCd.length; i++)
//		      				$("#MODEL_CD").append('<option value="' + listModelCd[i].V+ '">' + listModelCd[i].K+ '</option>');

		     			var listCompanyId = data.TN_COMPANY_MST;
		     			for(var i=0; i<listCompanyId.length; i++)
		     				$("#COMPANY_ID").append('<option value="' + listCompanyId[i].V+ '">' + listCompanyId[i].K+ '</option>');
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

 	    				_userId = data.USER_ID;
 	    				_userName = data.USER_NAME;


 	    				$('#PROXY_ID').val(data.PROXY_ID);
	    				$('#RECEIPT_NO').val(data.RECEIPT);
	    				$('#PC_TYPE').val(data.PC_TYPE);
	    				$('#RECEIPT_DT').val(data.RECEIPT_DT);
	    				$('#SALE_ROOT').val(data.SALE_ROOT);
	    				$("input:radio[name='RELEASE_TYPE']:radio[value='"+data.RELEASE_TYPE+"']").prop('checked', true);
	    				$('#COMPANY_ID').val(data.COMPANY_ID);
	    				$('#DES').val(data.DES);
	    				$('#REQUEST').val(data.REQUEST);

	    				$('#GUARANTEE_DUE').val(data.GUARANTEE_DUE);
	    				$('#ACCEPTANCE_START').val(data.GUARANTEE_START);
	    				$('#ACCEPTANCE_END').val(data.GUARANTEE_END);

	    				$('#CUSTOMER_NM_S').val(data.CUSTOMER_NM_S);
	    				$('#CUSTOMER_NM_R').val(data.CUSTOMER_NM_R);
	    				$('#TEL_S').val(data.TEL_S);
	    				$('#TEL_R').val(data.TEL_R);
	    				$('#MOBILE_S').val(data.MOBILE_S);
	    				$('#MOBILE_R').val(data.MOBILE_R);
	    				$('#POSTAL_CD').val(data.POSTAL_CD);
	    				$('#ADDRESS').val(data.ADDRESS);
	    				$('#ADDRESS_DETAIL').val(data.ADDRESS_DETAIL);


	    				_receipt = data.RECEIPT;
	    				$('#order-sheet-no').text("접수번호: "+data.RECEIPT);

	    				$('#coupon_mange').val(data.COUPON_MANAGE);
 			    		$('#coupon_customer').val(data.COUPON_CUSTOMER);

 			    		var coaTypeOld = 'Win7';
 			    		var coaTypeNew = 'Win7';
 			    		if(data.OLD_COA == '2')
 			    			coaTypeOld = 'Win8';
 			    		else if(data.OLD_COA == '3')
 			    			coaTypeOld = 'Win10';

 			    		if(data.NEW_COA == '2')
 			    			coaTypeNew = 'Win8';
 			    		else if(data.NEW_COA == '3')
 			    			coaTypeNew = 'Win10';

 			    		$('#COA_TYPE_OLD').val(coaTypeOld);
 			    		$('#COA_TYPE_NEW').val(coaTypeNew);
 			    		$('#coaNo_old').val(data.OLD_COA_SN);
 			    		$('#coaNo_new').val(data.NEW_COA_SN);

// 	    				for(var i = 0; i < 5; i++){
// 		    				var checkBox = $("[id*='receipt_status_" + i +"']");

// 		    				if(i == data.RELEASE_STATE)
// 		    					checkBox.prop("checked", true);
// 		    				else
// 		    					checkBox.prop("checked", false);
// 	    				}


// 	    				if(data.RECEIPT_DT != null){
// 	    					$("[id*='process-info-date0']").val(data.RECEIPT_DT);
// // 	    					$("[id*='receipt_status_0']").prop("checked", true);
// 	    				}
// // 	    				else
// // 	    					$("[id*='receipt_status_0']").prop("checked", false);

// 	    				if(data.PROCESS_DT != null){
// 	    					$("[id*='process-info-date1']").val(data.PROCESS_DT);
// // 	    					$("[id*='receipt_status_1']").prop("checked", true);
// 	    				}
// // 	    				else
// // 	    					$("[id*='receipt_status_1']").prop("checked", false);

// 	    				if(data.POSTPONE_DT != null){
// 	    					$("[id*='process-info-date2']").val(data.POSTPONE_DT);
// // 	    					$("[id*='receipt_status_2']").prop("checked", true);
// 	    				}
// // 	    				else
// // 	    					$("[id*='receipt_status_2']").prop("checked", false);

// 	    				if(data.CANCEL_DT != null){
// 	    					$("[id*='process-info-date3']").val(data.CANCEL_DT);
// // 	    					$("[id*='receipt_status_3']").prop("checked", true);
// 	    				}
// // 	    				else
// // 	    					$("[id*='receipt_status_3']").prop("checked", false);

// 	    				if(data.RELEASE_DT != null){
// 	    					$("[id*='process-info-date4']").val(data.RELEASE_DT);
// // 	    					$("[id*='receipt_status_4']").prop("checked", true);
// 	    				}
// // 	    				else
// // 	    					$("[id*='receipt_status_4']").prop("checked", false);

// 	    				$('#coupon_mange').val(data.COUPON_MANAGE);
// // 	    				$('#coupon_customer').val(data.COUPON_CUSTOMER);

// 	    				var returnYn = data.RETURN_YN * 1;
// 	    				//if(returnYn == 1){

// // 	    					$('#processInfo').css("width", "31.4%");
// // 	    					$('#returnInfo').show();
// // 	    					$('#return_header').show();
// // 	    					$('#tbl_consigned_return_info_data').show();
// // 	    					$('#consigned_return_btn').hide();

// 							if(data.RELEASE_STATE == 4){
// 								if(data.RETURN_REQUEST_DT == null)
// 									$('#consigned_return_btn').show();
// 								else
// 									$('#consigned_return_btn').hide();

// 							}

// 		    				if(data.RETURN_REQUEST_DT != null){
// 		    					$("[id*='process-info-date5']").val(data.RETURN_REQUEST_DT);
// 		    					$("[id*='receipt_status_5']").prop("checked", true);
// 		    					$('#consigned_return_btn').hide();
// 		    				}
// 		    				else
// 		    					$("[id*='receipt_status_5']").prop("checked", false);

// 		    				if(data.RETURN_IN_DT != null){
// 		    					$("[id*='process-info-date6']").val(data.RETURN_IN_DT);
// 		    					$("[id*='receipt_status_6']").prop("checked", true);
// 		    				}
// 		    				else
// 		    					$("[id*='receipt_status_6']").prop("checked", false);

// 		    				if(data.EXCHANGE_DT != null){
// 		    					$("[id*='process-info-date7']").val(data.EXCHANGE_DT);
// 		    					$("[id*='receipt_status_7']").prop("checked", true);
// 		    				}
// 		    				else
// 		    					$("[id*='receipt_status_7']").prop("checked", false);

// 		    				if(data.RETURN_CANCEL_DT != null){
// 		    					$("[id*='process-info-date8']").val(data.RETURN_CANCEL_DT);
// 		    					$("[id*='receipt_status_8']").prop("checked", true);
// 		    				}
// 		    				else
// 		    					$("[id*='receipt_status_8']").prop("checked", false);


// 		    				if(data.RETURN_COMPLETE_DT != null){
// 		    					$("[id*='process-info-date9']").val(data.RETURN_COMPLETE_DT);
// 		    					$("[id*='receipt_status_9']").prop("checked", true);
// 		    				}
// 		    				else
// 		    					$("[id*='receipt_status_9']").prop("checked", false);
// 	    				//}

		    				var listInvoice = data.INVOICE;

		    				console.log("listInvoice = "+listInvoice);

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

		function fnInitConsignedLicence(){

			console.log("CompanyList.fnInitConsignedLicence() Load");

			var url = '${getLicenceInfo}';
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

						var mbd = data.MBD;
						var cpu = data.CPU;

						if(mbd != null){
							$('#manufature_old').val(mbd.MANUFACTURE_NM);
		    				$('#manufature_new').val(mbd.MANUFACTURE_NM);

		    				$('#modelNm_old').val(mbd.MBD_MODEL_NM+"/"+mbd.PRODUCT_NAME);
		    				$('#modelNm_new').val(mbd.MBD_MODEL_NM+"/"+mbd.PRODUCT_NAME);

		    				$('#snNo_old').val(mbd.MBD_SN+"/"+mbd.SYSTEM_SN);
		    				$('#snNo_new').val(mbd.MBD_SN+"/"+mbd.SYSTEM_SN);
						}

						if(cpu != null){

							$('#cpuInfo_old').val(cpu.MODEL_NM);
		    				$('#cpuInfo_new').val(cpu.MODEL_NM);

						}
	    			}
	    		}
	    	});

		}

		function setConsignedComponent(DATA){
			var consigned_items = DATA;
			var totalCnt = 0;
// 			var totalReleaseCnt = 0;

			_componentInfo = [];
			_componentCnt = consigned_items.length;

			$(".consigned_items").empty();

			if(consigned_items.length > 0) {

				for(var i=0; i<consigned_items.length; i++) {

					_componentInfo[i] = consigned_items[i];

// 					var componentId = consigned_items[i].COMPONENT_ID;
					var componentCd = consigned_items[i].COMPONENT_CD;

					var color;
					var fontColor;

					if(i%2 == 1) color = "#E6E6E6";
					else color = "#FFFFFF"

					var componentCnt = consigned_items[i].COMPONENT_CNT;
// 					var releaseCnt = consigned_items[i].RELEASE_CNT;


					totalCnt += (componentCnt *1) ;
// 					totalReleaseCnt += (releaseCnt *1) ;
					var consignedNm = "";
					var consignedType = consigned_items[i].CONSIGNED_TYPE;

					if(consignedType == 2)
					{
						fontColor = 'RED';
						consignedNm = "자사재고";
					}
					else
						fontColor = 'BLACK';


					var item = '<tr>';

					item +='<td  class="col-title-centerC" style="color:'+fontColor+'; background-color:'+color+';">'+(i+1)+'</td>';
					item +='<td  class="col-title-leftC" style="color:'+fontColor+'; background-color:'+color+';">'+componentCd+'</td>';
					item +='<td  class="col-title-leftC" style="color:'+fontColor+'; background-color:'+color+';">'+consigned_items[i].DETAIL_DATA+'</td>';
					item +='<td  class="col-title-leftC" style="color:'+fontColor+'; background-color:'+color+';">'+consignedNm+'</td>';
// 					item +='<td  class="col-title-centerC" style="color:'+fontColor+'; background-color:'+color+';">'+componentCnt+'</td>';

					item += '</tr>';
					$(".consigned_items").append(item);
				}

			}

			$("#numOfComponent").text("TOTAL: "+consigned_items.length+" EA");
// 			$("#numOfInventory").text("합계: "+totalCnt+" EA");

// 			var height = 28*consigned_items.length;
// 			$("#table_consigned_component").css("height", height+"px");


		}

		function jsprint(){
			window.print();
		}

		function getParameterByName(name) {
		    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
		            results = regex.exec(location.search);
		    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
		}

	</script>

</head>

<body>

	<div class="page"> <%-- Page 시작 --%>
		<div class="subpage"> <%-- SubPage 시작 --%>


			<div>
			<button class="k-button searched-item" onclick="javascript:jsprint();" style="width: 32px; background-color: slategray; margin: 1px; float: right;">
					<span class="k-icon k-i-print" style="font-size: 15px; color: white;"></span>
			</button>
			</div>

			<%-- 문서 번호 시작 --%>
			<div id="bcTarget" style="float: right; padding-right:40px; margin-top:0px;">123</div>

			<span id="order-sheet-no" style="float: right; padding-right:20px;">

					문서번호 : 접수번호 - 01
			</span>



			<%-- 문서 번호 끝 --%>

			<%-- 접수 정보 시작 --%>
			<div class="title">
<%--				<i class="k-icon k-i-info" style="color: steelblue"></i>--%>
				<i class="material-icons" style="font-size: 20px; color: #DA391D; vertical-align: middle;">assignment</i>
				접수 정보

			</div>


			<div class="table-wrapper"> <%--	접수 정보 테이블 시작 --%>
				<table id="tbl_consigned_receipt_info_data">

					<tbody>

					<tr>
						<td class="col-title">접수번호</td>
						<td class="col-content-25"><input type="input" class="view k-textbox col-input" id="RECEIPT_NO" name="RECEIPT_NO" value="접수시 자동생성" disabled></td>
						<td class="col-title">제품유형</td>
						<td class="col-content-25">
                           <select id="PC_TYPE" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 100%; height: 22px; display: inline-block; margin-right: 3px; background: #ebebf5;" disabled>
                               <option value="0">0</option>
                           </select>
                       </td>
					</tr>

					<tr>
						<td class="col-title">접수일자</td>
						<td class="col-content-25"><input type="input" class="view k-textbox col-input" id="RECEIPT_DT" name="RECEIPT_DT" value="접수시 자동생성" disabled></td>
						<td class="col-title">보증기간</td>
						<td class="col-content-25" >
										<select id="GUARANTEE_DUE"
                                                data-role="dropdownlist" style="width: 28%; height: 24px; display: inline-block; margin-right: 3px; background: #ebebf5;"
                                                onchange="changeGuaranteeTerm(value)" disabled>
											<option value="0">0</option>
										</select>
										<input id="ACCEPTANCE_START" style="width:31%; height: 24px; display: inline-block; margin-right: 3px; padding-bottom: 2px" disabled/>
										<span style="margin-right: 3px;"> ~ </span>
										<input id="ACCEPTANCE_END"  style="width:31%; height: 24px; display: inline-block; padding-bottom: 2px" disabled />

									</td>
					</tr>

					<tr>
						<td class="col-title">판매처</td>
						<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="SALE_COMPANY" name="SALE_COMPANY">--%>
                                        <select id="COMPANY_ID" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 100%; height: 22px; display: inline-block; margin-right: 3px; background: #ebebf5;" disabled="disabled">
                                            <option value="0">0</option>
                                        </select>
                                    </td>
						<td class="col-title">판매경로</td>
						<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="SALE_ROOT" name="SALE_ROOT" value="3">--%>
                                        <select id="SALE_ROOT" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 100%; height: 22px; display: inline-block; margin-right: 3px; background: #ebebf5;" disabled>
                                            <option value="0">0</option>
                                        </select>
                                    </td>
					</tr>

					<tr>
						<td class="col-title">출고유형</td>
						<td class="col-content-25">
							<input type="radio" name="RELEASE_TYPE" value="1" checked disabled/>택배
							<input type="radio" name="RELEASE_TYPE" value="2" disabled />방문수령
							<input type="radio" name="RELEASE_TYPE" value="3"  disabled/>화물
						</td>
						<td class="col-title">참고사항</td>
						<td class="col-content-25"><input type="input" class="view k-textbox col-input" style="width: 100%; height: 24px;"id="REQUEST" name="REQUEST" readonly="readonly"></td>

					</tr>
					<tr>

						<td class="col-title">요청사항</td>
						<td class="col-content-25"><input type="input" class="view k-textbox col-input" style="width: 226%; height: 24px;"id="DES" name="ETC" readonly="readonly"></td>

					</tr>

					</tbody>
				</table>
			</div> <%--	접수 정보 테이블 끝 --%>
			<%-- 접수 정보 끝 --%>


			<%-- 고객 정보 시작 --%>
			<div class="title">
<%--				<i class="k-icon k-i-info" style="color: steelblue"></i>--%>
				<i class="material-icons" style="font-size: 20px; color: #DA391D; vertical-align: middle;">account_box</i>
				고객 정보
			</div>

			<div class="table-wrapper"> <%-- 고객 정보 테이블 시작 --%>

				<table id="tbl_consigned_receipt_customer_data">

					<tbody>

					<tr>
						<td class="col-title">고객명[1]</td>
						<td class="col-content-25">
							<input type="input" class="view k-textbox col-input" id="CUSTOMER_NM_S" name="CUSTOMER_NM_S" disabled>
						</td>
						<td class="col-title">고객명[2]</td>
						<td class="col-content-25">
							<input type="input" class="view k-textbox col-input" id="CUSTOMER_NM_R" name="CUSTOMER_NM_R" disabled>
						</td>
					</tr>

					<tr>
						<td class="col-title">전화번호[1]</td>
						<td class="col-content-25">
							<input type="input" class="view k-textbox col-input" id="TEL_S" name="TEL_S" disabled>
						</td>
						<td class="col-title">전화번호[2]</td>
						<td class="col-content-25">
							<input type="input" class="view k-textbox col-input" id="TEL_R" name="TEL_R" disabled>
						</td>
					</tr>

					<tr>
						<td class="col-title">휴대폰[1]</td>
						<td class="col-content-25">
							<input type="input" class="view k-textbox col-input" id="MOBILE_S" name="MOBILE_S" disabled>
						</td>
						<td class="col-title">휴대폰[2]</td>
						<td class="col-content-25">
							<input type="input" class="view k-textbox col-input" id="MOBILE_R" name="MOBILE_R" disabled>
						</td>
					</tr>

					<tr>
						<td class="col-title" rowspan=2>주소</td>
						<td class="col-content-25"><input type="input" class="view k-textbox" id="POSTAL_CD" name="POSTAL_CD" style="width:100%;" disabled></td>
						<td colspan="2" style="text-align: left; margin: 0px;"></td>
					</tr>

					<tr>
						<td class="col-content-25"><input type="input" class="view k-textbox" id="ADDRESS" name="ADDRESS" style="width:100%;" disabled></td>
						<td colspan="2" style="width:50%;"><input type="input" class="view k-textbox" id="ADDRESS_DETAIL" name="ADDRESS_DETAIL" style="width:100%;" disabled></td>
					</tr>

					</tbody>
				</table>

			</div> <%-- 고객 정보 테이블 끝 --%>
			<%-- 고객 정보 끝 --%>


			<div style="display:none;">
				<%-- 물류 정보 시작 --%>
				<div style="width: 49%; float: left; margin-bottom: 10px">

					<div class="title">
<%--						<i class="k-icon k-i-info" style="color: steelblue"></i>--%>
						<i class="material-icons" style="font-size: 20px; color: #DA391D; vertical-align: middle;">local_shipping</i>
						물류 정보
					</div>

					<div class="table-wrapper"> <%-- 물류 정보 테이블 시작 --%>

						<table align = right id="tbl_consigned_distribution_info_data" class="table_default">

							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>

							<thead class="col-header-title">
								<td>택배사</td>
								<td>송장번호</td>
							</thead>

							<tbody>

							<tr>
								<td>
									<input type="text" id = "delivery_type" class="view k-textbox col-input" disabled>
								</td>
								<td>
									<input type="text" id = "delivery_invoice" class="view k-textbox col-input" disabled>
								</td>
							</tr>

							</tbody>

						</table>

					</div> <%-- 물류 정보 테이블 끝 --%>
				</div> <%-- 물류 정보 끝 --%>

				<%-- 쿠폰 정보 시작 --%>
				<div style="width: 49%; float: right; margin-bottom: 10px">

					<div class="title">
<%--						<i class="k-icon k-i-info" style="color: steelblue"></i>--%>
						<i class="material-icons" style="font-size: 20px; color: #DA391D; vertical-align: middle;">loyalty</i>
						쿠폰 정보
					</div>

					<div class="table-wrapper"> <%-- 쿠폰 정보 테이블 시작 --%>

						<table align = right id="tbl_consigned_distribution_info_data" class="table_default">

							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>

							<thead class="col-header-title">
								<td>관리번호</td>
								<td>고객번호</td>
							</thead>

							<tbody>

							<tr>
								<td>
									<input id="coupon_mange" type="text" class="view k-textbox col-input" readonly="readonly" disabled>
								</td>
								<td>
									<input id="coupon_customer" type="text" class="view k-textbox col-input"  readonly="readonly" disabled>
								</td>
							</tr>

							</tbody>

						</table>

					</div> <%-- 쿠폰 정보 테이블 끝 --%>

				</div> <%-- 쿠폰 정보 끝 --%>

					<div style="float: none; clear: both;"></div>

			</div>


			<%-- 윈도우 라이선스 시작 --%>
			<div style="display:none;">
			<div class="title" >
<%--				<i class="k-icon k-i-info" style="color: steelblue"></i>--%>
				<i class="material-icons" style="font-size: 20px; color: #DA391D; vertical-align: middle;">fact_check</i>
				윈도우 라이선스
			</div>

			<div class="table-wrapper"> <%-- 윈도우 라이선스 테이블 시작 --%>

				<table id="tbl_consigned_distribution_info_data" class="table_default" style="text-align: left;">

					<thead class="col-header-title">
						<td>윈도우 라이선스</td>
						<td>COA 선택</td>
						<td>제조사</td>
						<td>모델</td>
						<td>제품 S/N</td>
						<td>CPU 사양</td>
						<td>COA NO</td>
					</thead>

					<tbody>
						<tr>
							<td class="col-title" style="width: 15%">
								OLD
							</td>
							<td><input type="text" id="COA_TYPE_OLD" class="view k-textbox col-input" disabled></td>
							<td><input type="text" id="manufature_old" class="view k-textbox col-input" disabled></td>
							<td><input type="text" id="modelNm_old" class="view k-textbox col-input" disabled></td>
							<td><input type="text" id="snNo_old" class="view k-textbox col-input" disabled></td>
							<td><input type="text" id="cpuInfo_old" class="view k-textbox col-input" disabled></td>
							<td><input type="text" id="coaNo_old" class="view k-textbox col-input" disabled></td>
						</tr>
						<tr>
							<td class="col-title" style="width: auto">
								NEW
							</td>
							<td><input type="text" id="COA_TYPE_NEW" class="view k-textbox col-input" disabled></td>
							<td><input type="text" id="manufature_new" class="view k-textbox col-input" disabled></td>
							<td><input type="text" id="modelNm_new" class="view k-textbox col-input" disabled></td>
							<td><input type="text" id="snNo_new" class="view k-textbox col-input" disabled></td>
							<td><input type="text" id="cpuInfo_new" class="view k-textbox col-input" disabled></td>
							<td><input type="text" id="coaNo_new" class="view k-textbox col-input" disabled></td>
						</tr>
					</tbody>

				</table> <%-- 윈도우 라이선스 테이블 끝 --%>

			</div>
			</div>
			<%-- 윈도우 라이선스 끝 --%>

			<div style="float: none; clear: both;"></div>

			<%-- 제품 정보 시작 --%>
			<div class="title">
<%--				<i class="k-icon k-i-info" style="color: steelblue;"></i>--%>
				<i class="material-icons" style="font-size: 20px; color: #DA391D; vertical-align: middle;">shopping_cart</i>
				부품 정보
			</div>

<%--			<input type="text" style="width: 100%; height: 320px;">--%>
<!-- 			<textarea style="width: 100%; height: 320px; resize: none; padding: 10px;" disabled></textarea> -->





			<table id="tbl_consigned_receipt_product_data" class="stripe table_default">

					<colgroup>
					<col width="5%">
					<col width="6%">
					<col width="49%">
					<col width="8%">
<%-- 					<col width="5%"> --%>

					</colgroup>

					<thead>
						<tr>
						<td class="col-header-title">No</td>
							<td class="col-header-title">품목명</td>
							<td class="col-header-title">부품명</td>
							<td class="col-header-title">유형</td>
<!-- 							<td class="col-header-title">수량</td> -->
						</tr>
					</thead>
				</table>

<!-- 				<div id = "table_consigned_component" style="height: 300px;"> -->
					<div id = "table_consigned_component">

					<table  id="tbl_consigned_component_data" class="stripe">

						<colgroup>
						<col width="5%">
						<col width="6%">
						<col width="49%">
						<col width="8%">
<%-- 						<col width="5%"> --%>
						</colgroup>

						<tbody class="consigned_items">
						</tbody>

					</table>

				</div>


				<div style="vertical-align: middle; height: 32px; padding: 0px; background-color: lightgray; margin: 0px 0px 1px 0px;">

					<table class="table_default">

						<colgroup>
							<col width="74.5%">
<%-- 							<col width="15%"> --%>
<%-- 							<col width="13.5%"> --%>
						</colgroup>

						<tbody>
							<tr class="col-header-title">
								<td><label id="numOfComponent">TOTAL: 0 EA</label></td>
<!-- 								<td><label id="numOfInventory">합계: 0 EA</label></td> -->
							</tr>
						</tbody>

					</table>
				</div>



			<div style="margin: 20px 0px 0px 100px; text-align: left; font-size: 18px;">
				<span id = "year" style="margin-right: 10px;"> 2020 년</span>
				<span id = "month" style="margin-right: 10px;"> 9 월</span>
				<span id = "day" style="margin-right: 180px;"> 9 일</span>
				<span> 엔지니어 서명: </span>
			</div>

			<br><br>


			<div style="text-align: center;">
				<img src="/sys_img/logo.png" width="150px" style="float: left">
				<span style="float: right;">http://dangol365.com</span>
			</div>

		</div> <%-- SubPage 종료--%>
	</div> <%-- Page 종료--%>
</body>
