<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

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

			$("#datetimepicker_registration_date_start").kendoDatePicker({
				format: "yyyy-MM-dd",
				value: new Date()
			});

			$("#datetimepicker_registration_date_end").kendoDatePicker({
				format: "yyyy-MM-dd",
				value: new Date()
			});

		});

	</script>

	<style>

		.split-div {
			background-color: white;
			width: 95%;
			margin: auto;
			padding: 20px 20px 20px 20px;
		}

		.search-info-div {
			display: inline-block;
			margin-left: 10px;
			margin-right: 80px;
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
			height: 300px;
		}

	</style>

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

					<div class="search-info-div">

						<span style="margin-right: 10px;">
							<i class="k-icon k-i-calendar" style="margin-right: 2px;"></i> 등록일자
						</span>

						<input id="datetimepicker_registration_date_start" title="datetimepicker" style="width: 130px; height: 25px; display: inline-block;"/>
						&nbsp; ~ &nbsp;
						<input id="datetimepicker_registration_date_end" title="datetimepicker" style="width: 130px; height: 25px; display: inline-block;"/>

					</div>

					<div class="search-info-div">

						<span style="margin-right: 10px;">
							<i class="k-icon k-i-calendar" style="margin-right: 2px;"></i> 주문처
						</span>

						<input type="text" style="width: 130px; height: 22px;">

					</div>

					<div class="search-info-div">

						<span style="margin-right: 10px;">
							<i class="k-icon k-i-calendar" style="margin-right: 2px;"></i> 정산유형
						</span>

						<input type="text" style="width: 130px; height: 22px;">

					</div>

					<div style="display: inline-block; float: right; margin-right: 15px;">
						<button class="k-button"> 검색 </button>
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
						<col width="4.7%"> <%-- 1 --%>
						<col width="4.7%"> <%-- 2 --%>
						<col width="4.7%"> <%-- 3 --%>
						<col width="4.7%"> <%-- 4 --%>
						<col width="4.7%"> <%-- 5 --%>
						<col width="4.7%"> <%-- 6 --%>
						<col width="4.7%"> <%-- 7 --%>
						<col width="4.7%"> <%-- 8 --%>
						<col width="4.7%"> <%-- 9 --%>
						<col width="4.7%"> <%-- 10 --%>
						<col width="4.7%"> <%-- 11 --%>
						<col width="4.7%"> <%-- 12 --%>
						<col width="4.7%"> <%-- 13 --%>
						<col width="4.7%"> <%-- 14 --%>
						<col width="4.7%"> <%-- 15 --%>
						<col width="4.7%"> <%-- 16 --%>
						<col width="4.7%"> <%-- 17 --%>
						<col width="4.7%"> <%-- 18 --%>
						<col width="4.7%"> <%-- 19 --%>
						<col width="4.7%"> <%-- 20 --%>
						<%-- <col width="10%"> --> <%-- 21 --%>
					</colgroup>

					<tbody>

					<tr>
						<td rowspan="5" class="table-header-common"> Total </td>
						<td rowspan="3" class="table-header-common"> 구분 </td>
						<td colspan="6" class="table-header-release"> 출고 정산 </td>
						<td colspan="6" class="table-header-add"> 추가 정산 </td>
						<td colspan="6" class="table-header-return"> 환급 정산 </td>
						<td rowspan="3" class="table-header-common"> 정산비 합계 <br> [1+2-3] </td>
					</tr>

					<tr class="table-header">

						<td rowspan="2" class="table-header-release"> 접수건 </td>
						<td colspan="2" class="table-header-release"> 생산비 </td>
						<td colspan="2" class="table-header-release"> 물류 </td>
						<td rowspan="2" class="table-header-release"> 소계[1] </td>

						<td rowspan="2" class="table-header-add"> 제품가 </td>
						<td colspan="2" class="table-header-add"> 생산비 </td>
						<td colspan="2" class="table-header-add"> 물류 </td>
						<td rowspan="2" class="table-header-add"> 소계[2] </td>

						<td rowspan="2" class="table-header-return"> 제품가 </td>
						<td colspan="2" class="table-header-return"> 생산비 </td>
						<td colspan="2" class="table-header-return"> 물류 </td>
						<td rowspan="2" class="table-header-return"> 소계[3] </td>
					</tr>

					<tr class="table-header">

						<td class="table-header-release"> 기본 </td>
						<td class="table-header-release"> 재생산 </td>
						<td class="table-header-release"> 택배 </td>
						<td class="table-header-release"> 기타 </td>

						<td class="table-header-add"> 기본 </td>
						<td class="table-header-add"> 재생산 </td>
						<td class="table-header-add"> 택배 </td>
						<td class="table-header-add"> 기타 </td>

						<td class="table-header-return"> 기본 </td>
						<td class="table-header-return"> 재생산 </td>
						<td class="table-header-return"> 택배 </td>
						<td class="table-header-return"> 기타 </td>

					</tr>

					<tr>
						<td class="table-header-common-sub"> 건 </td>

						<td> 1 </td>
						<td> 2 </td>
						<td> 3 </td>
						<td> 4 </td>
						<td> 5 </td>
						<td> 6 </td>

						<td> 1 </td>
						<td> 2 </td>
						<td> 3 </td>
						<td> 4 </td>
						<td> 5 </td>
						<td> 6 </td>

						<td> 1 </td>
						<td> 2 </td>
						<td> 3 </td>
						<td> 4 </td>
						<td> 5 </td>
						<td> 6 </td>

						<td rowspan="2"> sum </td>
					</tr>

					<tr>
						<td class="table-header-common-sub"> 금액 </td>

						<td> 1 </td>
						<td> 2 </td>
						<td> 3 </td>
						<td> 4 </td>
						<td> 5 </td>
						<td> 6 </td>

						<td> 1 </td>
						<td> 2 </td>
						<td> 3 </td>
						<td> 4 </td>
						<td> 5 </td>
						<td> 6 </td>

						<td> 1 </td>
						<td> 2 </td>
						<td> 3 </td>
						<td> 4 </td>
						<td> 5 </td>
						<td> 6 </td>
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
						<col width="4.7%"> <%-- 1 --%>
						<col width="4.7%"> <%-- 2 --%>
						<col width="4.7%"> <%-- 3 --%>
						<col width="4.7%"> <%-- 4 --%>
						<col width="4.7%"> <%-- 5 --%>
						<col width="4.7%"> <%-- 6 --%>
						<col width="4.7%"> <%-- 7 --%>
						<col width="4.7%"> <%-- 8 --%>
						<col width="4.7%"> <%-- 9 --%>
						<col width="4.7%"> <%-- 10 --%>
						<col width="4.7%"> <%-- 11 --%>
						<col width="4.7%"> <%-- 12 --%>
						<col width="4.7%"> <%-- 13 --%>
						<col width="4.7%"> <%-- 14 --%>
						<col width="4.7%"> <%-- 15 --%>
						<col width="4.7%"> <%-- 16 --%>
						<col width="4.7%"> <%-- 17 --%>
						<col width="4.7%"> <%-- 18 --%>
						<col width="4.7%"> <%-- 19 --%>
						<col width="4.7%"> <%-- 20 --%>
						<%-- <col width="4.7%"> --%> <%-- 21 --%>
					</colgroup>

					<tbody>

						<tr>
							<td rowspan="3" class="table-header-common"> 주문처 </td>
							<td rowspan="3" class="table-header-common"> 구분 </td>
							<td colspan="6" class="table-header-release"> 출고 정산 </td>
							<td colspan="6" class="table-header-add"> 추가 정산 </td>
							<td colspan="6" class="table-header-return"> 환급 정산 </td>
							<td rowspan="3" class="table-header-common"> 정산비 합계 <br> [1+2-3] </td>
						</tr>

						<tr class="table-header">

							<td rowspan="2" class="table-header-release"> 제품가 </td>
							<td colspan="2" class="table-header-release"> 생산비 </td>
							<td colspan="2" class="table-header-release"> 물류 </td>
							<td rowspan="2" class="table-header-release"> 소계[1] </td>

							<td rowspan="2" class="table-header-add"> 제품가 </td>
							<td colspan="2" class="table-header-add"> 생산비 </td>
							<td colspan="2" class="table-header-add"> 물류 </td>
							<td rowspan="2" class="table-header-add"> 소계[2] </td>

							<td rowspan="2" class="table-header-return"> 제품가 </td>
							<td colspan="2" class="table-header-return"> 생산비 </td>
							<td colspan="2" class="table-header-return"> 물류 </td>
							<td rowspan="2" class="table-header-return"> 소계[3] </td>
						</tr>

						<tr class="table-header">

							<td class="table-header-release"> 기본 </td>
							<td class="table-header-release"> 재생산 </td>
							<td class="table-header-release"> 택배 </td>
							<td class="table-header-release"> 기타 </td>

							<td class="table-header-add"> 기본 </td>
							<td class="table-header-add"> 재생산 </td>
							<td class="table-header-add"> 택배 </td>
							<td class="table-header-add"> 기타 </td>

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
							<col width="4.75%"> <%-- 1 --%>
							<col width="4.75%"> <%-- 2 --%>
							<col width="4.75%"> <%-- 3 --%>
							<col width="4.75%"> <%-- 4 --%>
							<col width="4.75%"> <%-- 5 --%>
							<col width="4.75%"> <%-- 6 --%>
							<col width="4.75%"> <%-- 7 --%>
							<col width="4.75%"> <%-- 8 --%>
							<col width="4.75%"> <%-- 9 --%>
							<col width="4.75%"> <%-- 10 --%>
							<col width="4.75%"> <%-- 11 --%>
							<col width="4.75%"> <%-- 12 --%>
							<col width="4.75%"> <%-- 13 --%>
							<col width="4.75%"> <%-- 14 --%>
							<col width="4.75%"> <%-- 15 --%>
							<col width="4.75%"> <%-- 16 --%>
							<col width="4.75%"> <%-- 17 --%>
							<col width="4.75%"> <%-- 18 --%>
							<col width="4.75%"> <%-- 19 --%>
							<col width="4.75%"> <%-- 20 --%>
							<%-- <col width="10%"> --> <%-- 21 --%>
						</colgroup>

						<tbody>

							<tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr>

							<tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr><tr>
								<td rowspan="2" class="table-header-common"> CDM </td>
								<td class="table-header-common-sub"> EA </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td rowspan="2"> sum </td>
							</tr>

							<tr>
								<td class="table-header-common-sub"> 금액 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>

								<td> 1 </td>
								<td> 2 </td>
								<td> 3 </td>
								<td> 4 </td>
								<td> 5 </td>
								<td> 6 </td>
							</tr>





						</tbody>

					</table>

				</div>

			</div>
			<%-- 주문처 정산 끝 --%>

		</div>

	</div>

</body>

