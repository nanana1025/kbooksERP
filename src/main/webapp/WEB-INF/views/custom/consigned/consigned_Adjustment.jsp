<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<c:url var="getCodeListCustom"					value="/common/getCodeListCustom.json" />
<c:url var="getConsignedAdjustMent"					value="/consigned/getConsignedAdjustMent.json" />
<c:url var="getConsignedReleaseInventory"					value="/consigned/getConsignedReleaseInventory.json" />
<c:url var="addConsignedReleaseInventory"					value="/consigned/addConsignedReleaseInventory.json" />
<c:url var="deleteConsignedReleaseInventory"					value="/consigned/deleteConsignedReleaseInventory.json" />
<c:url var="updateComponent"					value="/consigned/updateComponent.json"/>
<c:url var="dataList"					value="/customDataList.json" />




<head>
	 <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	 <title>DANGOL365 ERP | 생산대행</title>

 	<link rel="stylesheet" type="text/css" href="/codebase/css/custom_style.css"/>

	<script src="/codebase/gochigo.kendo.ui.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

	<style>

		.split-div {
			background-color: white;
			width: 95%;
			margin: auto;
			padding: 5px 20px 5px 20px;
		}

		.search-info-div {
			display: inline-block;
			margin-left: 10px;
			margin-right: 80px;
		}

		.search-title-div {
			display: inline-block;
			margin-left: 10px;

		}

		table {
			border-collapse: collapse;
			width: 100%;
		}

		table td {
			text-align: center;
			border: 1px solid black;
			padding: 5px;
		}

		.table-header-common {
			background-color: lightgray;
			font-weight: bold;
		}

		.table-header-common-sub {
			background-color: #ebebeb;
			font-weight: bold;
		}

		.table-header-release {
			background-color: rgba(205, 232, 186, 0.60);
			font-weight: bold;
		}

		.table-header-add {
			background-color: rgba(255, 230, 153, 0.60);
			font-weight: bold;
		}

		.table-header-return {
			background-color: rgba(193, 220, 243, 0.60);
			font-weight: bold;
		}

		.scrollable-div {
			overflow-y: scroll;
			height: 358px;
		}

	</style>

	<script type="text/javascript">

		$(document).ready(function() {

			console.log("consigned_componentModif.jsp");
			console.log("전체 정산");

			$("#datetimepicker_acceptance_date_start").kendoDatePicker({
				format: "yyyy-MM-dd",
				value: new Date()
			});

			$("#datetimepicker_acceptance_date_end").kendoDatePicker({
				format: "yyyy-MM-dd",
				value: new Date()
			});

			var default_start_date = new Date();
			default_start_date.setMonth(parseInt(default_start_date.getMonth()) - parseInt(3));
			 $("#datetimepicker_acceptance_date_start").get(0).value = default_start_date.toISOString().substring(0, 10);


			 fnInitData();

		});

		function fnInitData() {

			console.log("CompanyList.fnCompanyInsert() Load");

			var url = '${getCodeListCustom}';

			var isSuccess = false;

			var listCode = [];
			listCode.push("CD0902");

			var listCustom = [];
			listCustom.push("TN_COMPANY_MST");

			var listCustomKey = [];
			listCustomKey.push("COMPANY_NM");
			listCustomKey.push("COMPANY_ID");

			var listCustomContition = [];
			listCustomContition.push("COMPANY_TYPE = 'C'");

			var listCustomOrder = [];
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

		 			var listProxyState= data.CD0902;
		 			for(var i=0; i<listProxyState.length; i++){
		 				if((listProxyState[i].V*1) == 4 || (listProxyState[i].V*1) == 7 || (listProxyState[i].V*1) == 9)
		 					$("#PROXY_STATE").append('<option value="' + listProxyState[i].V+ '">' + listProxyState[i].K+ '</option>');
		 			}

		 			var listCompanyId = data.TN_COMPANY_MST;
		 			for(var i=0; i<listCompanyId.length; i++)
		 				$("#COMPANY_ID").append('<option value="' + listCompanyId[i].V+ '">' + listCompanyId[i].K+ '</option>');

				}
			});


		}

		function setComma(data){

			if(data == null)
				return '0';

			var value = data+"";
			var  commaData = value.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			return commaData;
		}

		function fnConsignedData() {

			console.log("CompanyList.fnConsignedData() Load");

			var acceptanceStartDt = $('#datetimepicker_acceptance_date_start').val()+" 00:00:00";
		   	var acceptanceEndDt = $('#datetimepicker_acceptance_date_end').val()+" 23:59:59";


			var COMPANY_ID = $('#COMPANY_ID').val();
			var PROXY_STATE = $('#PROXY_STATE').val();

			if(PROXY_STATE == 0)
				PROXY_STATE = '4,7,9'

			var params = {
					RECEIPT_START_DT: acceptanceStartDt,
					RECEIPT_END_DT: acceptanceEndDt,
					COMPANY_ID: COMPANY_ID,
					PROXY_STATE: PROXY_STATE
			};

			var url = '${getConsignedAdjustMent}';


			$.ajax({
				url : url,
				type : "POST",
				data : JSON.stringify(params),
	    		contentType: "application/json",
				async : false,
				success : function(data) {

					$(".consigned_AdjustMent_Items").empty();

					if(data.SUCCESS){

						var price = data.TOTAL;

						var releaseCnt = [];
						var releasePrice = [];
						var releaseCntSum = 0;
						var releasePriceSum = 0;

						var releasePriceTotal = price.RELEASE_PRICE_TOTAL * 1;
						var releasePriceTotalSum = 0;

						releaseCnt[0] = price.RELEASE_CNT_PRODUCE * 1;
						releaseCnt[1] = price.RELEASE_CNT_REPRODUCE * 1;
						releaseCnt[2] = price.RELEASE_CNT_DEILIVERY * 1;
						releaseCnt[3] = price.RELEASE_CNT_QUICK * 1;

						releasePrice[0] = price.RELEASE_PRICE_PRODUCE * 1;
						releasePrice[1] = price.RELEASE_PRICE_REPRODUCE * 1;
						releasePrice[2] = price.RELEASE_PRICE_DEILIVERY * 1;
						releasePrice[3] = price.RELEASE_PRICE_QUICK * 1;


						$('#adjustment-release-cnt-total').text(setComma(price.RELEASE_CNT_TOTAL));
	    				$('#adjustment-release-price-total').text(setComma(releasePriceTotal));

	    				for(var i = 0; i < 4; i++){
	    					$('#adjustment-release-cnt-'+(i+1)).text(setComma(releaseCnt[i]));
	    					$('#adjustment-release-price-'+(i+1)).text(setComma(releasePrice[i]));
	    					releaseCntSum += releaseCnt[i];
	    					releasePriceSum += releasePrice[i];
	    				}

	    				releasePriceTotalSum = releasePriceTotal + releasePriceSum;
	    				$('#adjustment-release-cnt-sum').text(setComma(releaseCntSum));
	    				$('#adjustment-release-price-sum').text(setComma(releasePriceTotalSum));

	    				var returnCnt = [];
						var returnPrice = [];
						var returnCntSum = 0;
						var returnPriceSum = 0;

						var returnPriceTotal = price.RETURN_PRICE_TOTAL * 1;
						var returnPriceTotalSum = 0;

						returnCnt[0] = price.RETURN_CNT_PRODUCE * 1;
						returnCnt[1] = price.RETURN_CNT_REPRODUCE * 1;
						returnCnt[2] = price.RETURN_CNT_DEILIVERY * 1;
						returnCnt[3] = price.RETURN_CNT_QUICK * 1;

						returnPrice[0] = price.RETURN_PRICE_PRODUCE * 1;
						returnPrice[1] = price.RETURN_PRICE_REPRODUCE * 1;
						returnPrice[2] = price.RETURN_PRICE_DEILIVERY * 1;
						returnPrice[3] = price.RETURN_PRICE_QUICK * 1;

						$('#adjustment-return-cnt-total').text(setComma(price.RETURN_CNT_TOTAL));
	    				$('#adjustment-return-price-total').text(setComma(returnPriceTotal));

	    				for(var i = 0; i < 4; i++){
	    					$('#adjustment-return-cnt-'+(i+1)).text(setComma(returnCnt[i]));
	    					$('#adjustment-return-price-'+(i+1)).text(setComma(returnPrice[i]));
	    					returnCntSum += returnCnt[i];
	    					returnPriceSum += returnPrice[i];
	    				}

	    				returnPriceTotalSum = returnPriceTotal + returnPriceSum;
	    				$('#adjustment-return-cnt-sum').text(setComma(returnCntSum));
	    				$('#adjustment-return-price-sum').text(setComma(returnPriceTotalSum));


	    				$('#adjustment-cnt-sum').text(setComma(releaseCntSum+returnCntSum));
	    				$('#adjustment-price-sum').text(setComma(releasePriceTotalSum-returnPriceTotalSum));


	    				setConsignedAdjustment(data.DATA);

					}else{

						$('#adjustment-release-cnt-total').text(0);
						$('#adjustment-release-price-total').text(0);

						for(var i = 0; i < 4; i++){
	    					$('#adjustment-release-cnt-'+(i+1)).text(0);
	    					$('#adjustment-release-price-'+(i+1)).text(0);

	    				}

	    				$('#adjustment-release-cnt-sum').text(0);
	    				$('#adjustment-release-price-sum').text(0);



	    				$('#adjustment-return-cnt-total').text(0);
	    				$('#adjustment-return-price-total').text(0);

	    				for(var i = 0; i < 4; i++){
	    					$('#adjustment-return-cnt-'+(i+1)).text(0);
	    					$('#adjustment-return-price-'+(i+1)).text(0);
	    				}

	    				$('#adjustment-return-cnt-sum').text(0);
	    				$('#adjustment-return-price-sum').text(0);



	    				$('#adjustment-cnt-sum').text(0);
	    				$('#adjustment-price-sum').text(0);

					}
				}

			});
		}


		function setConsignedAdjustment(DATA){



			var consigned_items = DATA;

			if(consigned_items.length > 0) {
				for(var i=0; i<consigned_items.length; i++) {

					var price =  consigned_items[i]

					var companyNm = price.COMPANY_NM;
					var releaseCnt = [];
					var releasePrice = [];
					var releaseCntSum = 0;
					var releasePriceSum = 0;

					var releasePriceTotal = price.RELEASE_PRICE_TOTAL * 1;
					var releasePriceTotalSum = 0;

					releaseCnt[0] = price.RELEASE_CNT_PRODUCE * 1;
					releaseCnt[1] = price.RELEASE_CNT_REPRODUCE * 1;
					releaseCnt[2] = price.RELEASE_CNT_DEILIVERY * 1;
					releaseCnt[3] = price.RELEASE_CNT_QUICK * 1;

					releasePrice[0] = price.RELEASE_PRICE_PRODUCE * 1;
					releasePrice[1] = price.RELEASE_PRICE_REPRODUCE * 1;
					releasePrice[2] = price.RELEASE_PRICE_DEILIVERY * 1;
					releasePrice[3] = price.RELEASE_PRICE_QUICK * 1;

					var returnCnt = [];
					var returnPrice = [];
					var returnCntSum = 0;
					var returnPriceSum = 0;

					var returnPriceTotal = price.RETURN_PRICE_TOTAL * 1;
					var returnPriceTotalSum = 0;

					returnCnt[0] = price.RETURN_CNT_PRODUCE * 1;
					returnCnt[1] = price.RETURN_CNT_REPRODUCE * 1;
					returnCnt[2] = price.RETURN_CNT_DEILIVERY * 1;
					returnCnt[3] = price.RETURN_CNT_QUICK * 1;

					returnPrice[0] = price.RETURN_PRICE_PRODUCE * 1;
					returnPrice[1] = price.RETURN_PRICE_REPRODUCE * 1;
					returnPrice[2] = price.RETURN_PRICE_DEILIVERY * 1;
					returnPrice[3] = price.RETURN_PRICE_QUICK * 1;


					var item = '<tr>';
					item +='<td rowspan="2" class="table-header-common">'+ companyNm +'</td>';
					item +='<td class="table-header-common-sub"> 건 </td>';

					item +='<td>'+setComma(price.RELEASE_CNT_TOTAL)+'</td>';
					for(var i = 0; i < 4; i++){
						item +='<td>'+setComma(releaseCnt[i])+'</td>';
						releaseCntSum += releaseCnt[i];
					}
					item +='<td>'+setComma(releaseCntSum)+'</td>';


					item +='<td>'+setComma(price.RETURN_CNT_TOTAL)+'</td>';
					for(var i = 0; i < 4; i++){
						item +='<td>'+setComma(returnCnt[i])+'</td>';
						returnCntSum += returnCnt[i];
					}
					item +='<td>'+setComma(returnCntSum)+'</td>';

					item +='<td>'+setComma(releaseCntSum+returnCntSum)+'</td>';
					item +='</tr>';



					item +='<tr>';
					item +='<td class="table-header-common-sub"> 금액 </td>';

					item +='<td>'+setComma(releasePriceTotal)+'</td>';
					for(var i = 0; i < 4; i++){
						item +='<td>'+setComma(releasePrice[i])+'</td>';
						releasePriceSum += releasePrice[i];
					}

					releasePriceTotalSum = releasePriceTotal + releasePriceSum;

					item +='<td>'+setComma(releasePriceTotalSum)+'</td>';



					item +='<td>'+setComma(returnPriceTotal)+'</td>';
					for(var i = 0; i < 4; i++){
						item +='<td>'+setComma(returnPrice[i])+'</td>';
						returnPriceSum += returnPrice[i];
					}
					returnPriceTotalSum = returnPriceTotal + returnPriceSum;
					item +='<td>'+setComma(returnPriceTotalSum)+'</td>';

					item +='<td>'+setComma(releasePriceTotalSum-returnPriceTotalSum)+'</td>';
					item +='</tr>';

					$(".consigned_AdjustMent_Items").append(item);
				}

			}
		}















	</script>


</head>

<body>

	<div id="content" data-role="splitter" class="k-widget k-splitter content">


		<div class="header_title">
			<span class="pagetitle"><span class="header-title30"></span> 생산대행 - 전체 정산</span>
		</div>

		<div>

			<%-- 검색 정보 시작 --%>
			<div class="split-div">

				<span style="font-size: 16px;">
					<i class="k-icon k-i-info" style="font-size: 18px; color: #2c7dc7;"></i>
					검색 정보
				</span>

				<br>

				<div style="margin-top: 25px; vertical-align: middle; background-color: #f1f1f1; padding: 8px;">

					<div class="search-info-div">

						<span style="margin-right: 10px;">
							<i class="k-icon k-i-calendar" style="margin-right: 2px;"></i> 접수일자
						</span>
						<input id="datetimepicker_acceptance_date_start" title="datetimepicker" style="width: 130px; height: 25px; display: inline-block;"/>
						&nbsp; ~ &nbsp;
						<input id="datetimepicker_acceptance_date_end" title="datetimepicker" style="width: 130px; height: 25px; display: inline-block;"/>

					</div>

<!-- 					<div class="search-info-div"> -->

<!-- 						<span style="margin-right: 10px;"> -->
<!-- 							<i class="k-icon k-i-calendar" style="margin-right: 2px;"></i> 등록일자 -->
<!-- 						</span> -->

<!-- 						<input id="datetimepicker_registration_date_start" title="datetimepicker" style="width: 130px; height: 25px; display: inline-block;"/> -->
<!-- 						&nbsp; ~ &nbsp; -->
<!-- 						<input id="datetimepicker_registration_date_end" title="datetimepicker" style="width: 130px; height: 25px; display: inline-block;"/> -->

<!-- 					</div> -->

					<div class="search-title-div">

						<span style="margin-right: 10px;">
							<i class="k-icon k-i-calendar" style="margin-right: 2px;"></i> 주문처
                        </span>
					</div>

					<div class="search-info-div">
					<select id="COMPANY_ID" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 100%; height: 25px; display: inline-block; margin-right: 3px; background: #ebebf5;">
                                            <option value="0">선택</option>
                        </select>
					</div>

					<div class="search-title-div">

						<span style="margin-right: 10px;">
							<i class="k-icon k-i-calendar" style="margin-right: 2px;"></i> 정산유형
						</span>
					</div>

					<div class="search-info-div">
					<select id="PROXY_STATE" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 100%; height: 25px; display: inline-block; margin-right: 3px; background: #ebebf5;">
                                            <option value="0">선택</option>
                        </select>
					</div>

					<div style="display: inline-block; float: right; margin-right: 15px;">
						<button class="k-button" onclick="fnConsignedData()"> 검색 </button>
					</div>

				</div>
			</div>
			<%-- 검색 정보 끝 --%>


			<%-- 전체 정산 시작 --%>
			<div class="split-div">

				<span style="font-size: 16px; vertical-align: middle;">
					<i class="k-icon k-i-info" style="font-size: 18px; color: #2c7dc7;"></i>
					전체 정산 정보
				</span>

				<table style="margin-top: 10px;">

					<colgroup>
						<col width="4%"> <%-- 1 --%>
						<col width="5%"> <%-- 2 --%>
						<col width="7%"> <%-- 3 --%>
						<col width="7%"> <%-- 4 --%>
						<col width="7%"> <%-- 5 --%>
						<col width="7%"> <%-- 6 --%>
						<col width="7%"> <%-- 13 --%>
						<col width="7%"> <%-- 14 --%>
						<col width="7%"> <%-- 15 --%>
						<col width="7%"> <%-- 16 --%>
						<col width="7%"> <%-- 17 --%>
						<col width="7%"> <%-- 18 --%>
						<col width="7%"> <%-- 19 --%>
						<col width="7%"> <%-- 20 --%>
						<col width="9%"><%-- 21--%>
					</colgroup>

					<tbody>

					<tr>
						<td rowspan="5" class="table-header-common"> Total </td>
						<td rowspan="3" class="table-header-common"> 구분 </td>
						<td colspan="6" class="table-header-release"> 출고 정산 </td>
						<td colspan="6" class="table-header-return"> 환급 정산 </td>
						<td rowspan="3" class="table-header-common"> 정산비 합계 <br> [1-2] </td>
					</tr>

					<tr class="table-header">

						<td rowspan="2" class="table-header-release"> 접수건 </td>
						<td colspan="2" class="table-header-release"> 생산비 </td>
						<td colspan="2" class="table-header-release"> 물류 </td>
						<td rowspan="2" class="table-header-release"> 소계[1] </td>

						<td rowspan="2" class="table-header-return"> 환불건 </td>
						<td colspan="2" class="table-header-return"> 생산비 </td>
						<td colspan="2" class="table-header-return"> 물류 </td>
						<td rowspan="2" class="table-header-return"> 소계[2] </td>
					</tr>

					<tr class="table-header">

						<td class="table-header-release"> 기본 </td>
						<td class="table-header-release"> 재생산 </td>
						<td class="table-header-release"> 택배 </td>
						<td class="table-header-release"> 기타 </td>

						<td class="table-header-return"> 기본 </td>
						<td class="table-header-return"> 재생산 </td>
						<td class="table-header-return"> 택배 </td>
						<td class="table-header-return"> 기타 </td>

					</tr>

					<tr>
						<td class="table-header-common-sub"> 건 </td>

						<td><label id='adjustment-release-cnt-total'> 0</label> </td>
						<td><label id='adjustment-release-cnt-1'> 0</label></td>
						<td><label id='adjustment-release-cnt-2'> 0</label></td>
						<td><label id='adjustment-release-cnt-3'> 0</label></td>
						<td><label id='adjustment-release-cnt-4'> 0</label></td>
						<td><label id='adjustment-release-cnt-sum'> 0</label></td>

						<td><label id='adjustment-return-cnt-total'> 0</label> </td>
						<td><label id='adjustment-return-cnt-1'> 0</label></td>
						<td><label id='adjustment-return-cnt-2'> 0</label></td>
						<td><label id='adjustment-return-cnt-3'> 0</label></td>
						<td><label id='adjustment-return-cnt-4'> 0</label></td>
						<td><label id='adjustment-return-cnt-sum'> 0</label></td>

						<td> <label id='adjustment-cnt-sum'> 0</label> </td>
					</tr>

					<tr>
						<td class="table-header-common-sub"> 금액 </td>

						<td><label id='adjustment-release-price-total'> 0</label> </td>
						<td><label id='adjustment-release-price-1'> 0</label></td>
						<td><label id='adjustment-release-price-2'> 0</label></td>
						<td><label id='adjustment-release-price-3'> 0</label></td>
						<td><label id='adjustment-release-price-4'> 0</label></td>
						<td><label id='adjustment-release-price-sum'> 0</label></td>

						<td><label id='adjustment-return-price-total'> 0</label> </td>
						<td><label id='adjustment-return-price-1'> 0</label></td>
						<td><label id='adjustment-return-price-2'> 0</label></td>
						<td><label id='adjustment-return-price-3'> 0</label></td>
						<td><label id='adjustment-return-price-4'> 0</label></td>
						<td><label id='adjustment-return-price-sum'> 0</label></td>

						<td> <label id='adjustment-price-sum'> 0</label> </td>
					</tr>

					</tbody>

				</table>

			</div>
			<%-- 전체 정산 끝 --%>


			<%-- 주문처 정산 시작 --%>
			<div class="split-div">

				<span style="font-size: 16px; vertical-align: middle;">
					<i class="k-icon k-i-info" style="font-size: 18px; color: #2c7dc7;"></i>
					주문처 정산

				</span>

				<table style="margin-top: 10px;">

					<colgroup>
						<col width="4%"> <%-- 1 --%>
						<col width="5%"> <%-- 2 --%>
						<col width="7%"> <%-- 3 --%>
						<col width="7%"> <%-- 4 --%>
						<col width="7%"> <%-- 5 --%>
						<col width="7%"> <%-- 6 --%>
						<col width="7%"> <%-- 13 --%>
						<col width="7%"> <%-- 14 --%>
						<col width="7%"> <%-- 15 --%>
						<col width="7%"> <%-- 16 --%>
						<col width="7%"> <%-- 17 --%>
						<col width="7%"> <%-- 18 --%>
						<col width="7%"> <%-- 19 --%>
						<col width="7%"> <%-- 20 --%>
						<col width="9%"><%-- 21--%>
<%-- 						<col width="2%">21 --%>
					</colgroup>

					<tbody>

						<tr>
							<td rowspan="5" class="table-header-common"> Total </td>
							<td rowspan="3" class="table-header-common"> 구분 </td>
							<td colspan="6" class="table-header-release"> 출고 정산 </td>
							<td colspan="6" class="table-header-return"> 환급 정산 </td>
							<td rowspan="3" class="table-header-common"> 정산비 합계 <br> [1-2] </td>
<!-- 							<td rowspan="3" class="table-header-empty">&nbsp;&nbsp;</td> -->
						</tr>

						<tr class="table-header">

							<td rowspan="2" class="table-header-release"> 접수건 </td>
							<td colspan="2" class="table-header-release"> 생산비 </td>
							<td colspan="2" class="table-header-release"> 물류 </td>
							<td rowspan="2" class="table-header-release"> 소계[1] </td>

							<td rowspan="2" class="table-header-return"> 환불건 </td>
							<td colspan="2" class="table-header-return"> 생산비 </td>
							<td colspan="2" class="table-header-return"> 물류 </td>
							<td rowspan="2" class="table-header-return"> 소계[2] </td>
						</tr>

						<tr class="table-header">

							<td class="table-header-release"> 기본 </td>
							<td class="table-header-release"> 재생산 </td>
							<td class="table-header-release"> 택배 </td>
							<td class="table-header-release"> 기타 </td>

							<td class="table-header-return"> 기본 </td>
							<td class="table-header-return"> 재생산 </td>
							<td class="table-header-return"> 택배 </td>
							<td class="table-header-return"> 기타 </td>

						</tr>

					</tbody>

				</table>

				<div class="scrollable-div">

					<table style="margin-top: -1px;" class="stripe">

						<colgroup>
								<col width="4.05%"> <%-- 1 --%>
						<col width="5.1%"> <%-- 2 --%>
						<col width="7.05%"> <%-- 3 --%>
						<col width="7.05%"> <%-- 4 --%>
						<col width="7.05%"> <%-- 5 --%>
						<col width="7.05%"> <%-- 6 --%>
						<col width="7.05%"> <%-- 13 --%>
						<col width="7%"> <%-- 14 --%>
						<col width="7%"> <%-- 15 --%>
						<col width="7%"> <%-- 16 --%>
						<col width="7%"> <%-- 17 --%>
						<col width="7%"> <%-- 18 --%>
						<col width="7%"> <%-- 19 --%>
						<col width="7%"> <%-- 20 --%>
						<col width="6%"><%-- 21--%>
						</colgroup>

						<tbody class="consigned_AdjustMent_Items">
						</tbody>
<!-- 						<tbody> -->

<!-- 							<tr> -->
<!-- 								<td rowspan="2" class="table-header-common"> CDM </td> -->
<!-- 								<td class="table-header-common-sub"> EA </td> -->

<!-- 								<td> 1 </td> -->
<!-- 								<td> 2 </td> -->
<!-- 								<td> 3 </td> -->
<!-- 								<td> 4 </td> -->
<!-- 								<td> 5 </td> -->
<!-- 								<td> 6 </td> -->


<!-- 								<td> 1 </td> -->
<!-- 								<td> 2 </td> -->
<!-- 								<td> 3 </td> -->
<!-- 								<td> 4 </td> -->
<!-- 								<td> 5 </td> -->
<!-- 								<td> 6 </td> -->

<!-- 								<td rowspan="2"> sum </td> -->
<!-- 							</tr> -->

<!-- 							<tr> -->
<!-- 								<td class="table-header-common-sub"> 금액 </td> -->

<!-- 								<td> 1 </td> -->
<!-- 								<td> 2 </td> -->
<!-- 								<td> 3 </td> -->
<!-- 								<td> 4 </td> -->
<!-- 								<td> 5 </td> -->
<!-- 								<td> 6 </td> -->


<!-- 								<td> 1 </td> -->
<!-- 								<td> 2 </td> -->
<!-- 								<td> 3 </td> -->
<!-- 								<td> 4 </td> -->
<!-- 								<td> 5 </td> -->
<!-- 								<td> 6 </td> -->
<!-- 							</tr> -->



						</tbody>

					</table>

				</div>

			</div>
			<%-- 주문처 정산 끝 --%>

		</div>

	</div>

</body>

