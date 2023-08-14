<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>


<c:url var="getConsignedComponentInfo"					value="/consigned/getConsignedComponentInfo.json" />
<c:url var="getCodeListCustom"					value="/common/getCodeListCustom.json" />
<c:url var="companyDelete"					value="/user/companyDelete.json" />
<c:url var="companyInsert"					value="/user/companyInsert.json" />
<c:url var="createReceipt"					value="/consigned/createReceipt.json"/>
<c:url var="updateReceipt"					value="/consigned/updateReceipt.json"/>
<c:url var="getModelList"					value="/consigned/getModelList.json"/>
<c:url var="getModelListComponent"					value="/consigned/getModelListComponent.json"/>

<c:url var="dataList"					value="/customDataList.json" />
<c:url var="consignedPopup"					value="/CustomP.do"/>




<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	<title>DANGOL365 ERP | 창고이동</title>

 	<link rel="stylesheet" type="text/css" href="/codebase/css/custom_style.css"/>
	<script src="/codebase/gochigo.kendo.ui.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

	<style>

		.content_div {
			font-size: 16px;
		}

		.title_box {
			border: gray 1px solid;
			border-radius: 2px;
		}

		.title_box .title {
			position: relative;
			top: -0.9em;
			margin-left: 1em;
			display: inline;
			font-size: 18px;
			background-color: #f5f5f5;
			padding: 5px 10px 5px 10px;
		}

		.title_box .function {
			position: relative;
			top: -1.2em;
			margin-right: 1em;
			display: inline;
			font-size: 16px;
			background-color: #f5f5f5;
			padding: 5px 10px 5px 10px;
			float: right;
		}

		.title_box .function .icon {
			color: #0a6885;
			position: relative;
			top: 0.2em;
			margin-right: 1px;
		}

		.title_box .content {
			padding: 0px 20px 10px 10px;
		}

		.title_box .title .icon {
			/*font-weight: bold;*/
			color: #0e9dc8;
			position: relative;
			top: 0.2em;
		}

		.icon_title_blue {
			font-size: 8px;
			color: #0e9dc8;
		}

		.icon_title_red {
			font-size: 8px;
			color: #ff3030;
		}

		.icon-flipped {
			transform: scaleX(-1);
			-moz-transform: scaleX(-1);
			-webkit-transform: scaleX(-1);
			-ms-transform: scaleX(-1);
		}

		.search_table {
			font-size: 16px;
			border-collapse: collapse;
			width: 100%;
		}

		.search_table td {
			padding: 5px;
		}

		.search_table input {
			height: 20px;
			width: 80%;
		}

		.search_table button {
			position: relative;
			top: 0.3em;
			height: 22px;
			width: 80%;
		}

		.movement-table {
			width: 100%;
			border-collapse: collapse;
			margin-top: 10px;
			margin-bottom: 10px;
		}

		.movement-table td {
			padding: 4px;
		}

		.scrollable-wrapper {
			text-align: center;
			padding: 0px;
			margin-left: 1px;
			margin-bottom: 3px;
			width: 99.5%;
			/*background-color: white;*/
		}

		.scrollable-wrapper table {
			margin: 0px;
			width: 100%;
			background-color: white;
			border-collapse: collapse;
		}

		.scrollable-wrapper td {
			border: lightgray solid 1px;
		}

		.scrollable {
			margin: 0px;
			padding: 0px;
			overflow-y: overlay;
		}

		::-webkit-scrollbar-track {
			margin: 0px;
		}

		.table_scroll {
			margin: 0px;
			padding: 0px;
			background-color: white;
			border-collapse: collapse;
			border: lightgray solid 1px;
			border-radius: 2px;
			font-size: 14px;
		}

		.header-table td {
			text-align: center;
			background-color: white;
		}

		.table_scroll td {
			border: lightgray solid 1px;
		}

	</style>

	<script type="text/javascript">

		$(document).ready(function () {

			$("#datetimepicker_date_start").kendoDatePicker({
				format: "yyyy-MM-dd",
				value: new Date()
			});

			$("#datetimepicker_date_end").kendoDatePicker({
				format: "yyyy-MM-dd",
				value: new Date()
			});

		});

	</script>

</head>

<body>

	<div id="content" data-role="splitter" class="k-widget k-splitter content" style="background-color: #f5f5f5">

		<div class="header_title">
			<span class="pagetitle"><span class="header-title30"></span> 창고이동 - 창고이동리스트 </span>
		</div>

		<%-- 검색 박스 --%>
		<div class="content_div" style="margin: 30px 30px 20px 30px;">
			<div class="title_box">
				<div class="title">
					<i class="icon material-icons">find_in_page</i> 검색
				</div>
				<div class="content">

					<table class="search_table">
						<tr>
							<td> <span class="icon_title_blue material-icons">lens</span> 등록번호 </td> <td> <input type="text"> </td>
							<td> <span class="icon_title_blue material-icons">lens</span> 출고창고 </td> <td> <input type="text"> </td>
							<td> <span class="icon_title_blue material-icons">lens</span> 적재위치 </td> <td> <input type="text"> </td>
							<td> <span class="icon_title_blue material-icons">lens</span> 관리번호 </td> <td> <input type="text"> </td>
						</tr>
						<tr>
							<td> <span class="icon_title_blue material-icons">lens</span> 기간 </td>
							<td colspan="2">
								<input id="datetimepicker_date_start" title="datetimepicker" style="width: 150px; height: 25px; display: inline-block;"/>
								<span style="position: relative; top: 0.2em;">&nbsp;~</span>  &nbsp;
								<input id="datetimepicker_date_end" title="datetimepicker" style="width: 150px; height: 25px; display: inline-block;"/>
							</td>
							<td>
								<button><span class="material-icons" style="font-size: 15px; color: #0e9dc8; position: relative; top: 0.2em; font-weight: bold">search</span>&nbsp;검색</button>
							</td>
							<td colspan="4">
							</td>
						</tr>
					</table>


				</div>
			</div>
		</div>

		<div class="content_div" style="margin: 0px 0px 10px 30px;">

			<div class="title_box" style="width: 39%; float: left;">

				<div class="title">
					<span class="icon material-icons">assignment</span> 부품 정보
				</div>

				<div class="content">

					<table style="width: 100%; margin-bottom: 15px;">
						<tr>
							<td style="width: 15%;"> &nbsp;<span class="icon_title_blue material-icons">lens</span>&nbsp;등록번호 </td>
							<td style="width: 55%;"> <input value="G231065464564" style="width: 97%;"> </td>
							<td style="width: 30%;"> <button style="width: 100%;">초기화</button> </td>
						</tr>
					</table>

					<table class="movement-table" style="margin-bottom: 15px;">

                        <colgroup>
							<col width="15%">
							<col width="15%">
							<col width="70%">
						</colgroup>

						<tr>
							<td rowspan="2" style="text-align: center; font-weight: bold; font-size: 16px;">출고</td>
							<td>&nbsp;<span class="icon_title_blue material-icons">lens</span>&nbsp; 출고창고</td>
							<td>
                                <select style="width: 100%;">
                                </select>
                            </td>
						</tr>
						<tr>
							<td>&nbsp;<span class="icon_title_blue material-icons">lens</span>&nbsp; 출고창고</td>
							<td>
                                <select style="width: 100%;">
                                </select>
                            </td>
						</tr>
						<tr>
							<td rowspan="2" style="text-align: center; font-weight: bold; font-size: 16px;">입고</td>
							<td>&nbsp;<span class="icon_title_red material-icons">lens</span>&nbsp; 출고창고</td>
							<td>
                                <select style="width: 100%;">
                                </select>
                            </td>
						</tr>
						<tr>
							<td>&nbsp;<span class="icon_title_red material-icons">lens</span>&nbsp; 출고창고</td>
							<td>
                                <select style="width: 100%;">
                                </select>
                            </td>
						</tr>
					</table>

					<table style="width: 100%; margin-bottom: 30px;">
						<tr>
							<td style="width: 15%;"> &nbsp;<span class="icon_title_blue material-icons">lens</span>&nbsp;관리번호 </td>
							<td style="width: 55%;"> <input value="G231065464564" style="width: 97%;"> </td>
							<td style="width: 30%;"> <button style="width: 100%;">입력</button> </td>
						</tr>
					</table>

				</div>

				<div class="title_box" style="margin: 3px; margin-bottom: 5px;">
					<div class="title">
						<span class="icon material-icons">source</span> 현황
					</div>
					<div class="function">
						<span class="icon icon_title_blue material-icons" style="font-size: 20px;">add_shopping_cart</span><span style="margin-right: 7px;">보관</span>
						<span class="icon icon_title_blue material-icons icon-flipped" style="font-size: 20px;">reply</span><span style="margin-right: 7px;">출고</span>
						<span class="icon icon_title_blue material-icons icon-flipped" style="font-size: 20px;">delete_forever</span><span style="margin-right: 7px;">선택삭제</span>
						<span class="icon icon_title_blue material-icons" style="font-size: 18px;">library_add_check</span><span style="margin-right: 7px;">전체선택</span>
					</div>
					<div>
						<div class="scrollable-wrapper">
							<div>
								<table class="header-table">
									<colgroup>
										<col width="5.0%">
										<col width="40.0%">
										<col width="20.0%">
										<col width="20.0%">
										<col width="15.0%">
									</colgroup>

									<thead>
										<tr>
											<td> </td>
											<td>관리번호</td>
											<td>품목명</td>
											<td>적재위치</td>
											<td>선택</td>
										</tr>
									</thead>
								</table>
							</div>
							<div class="scrollable" style="height: 242px;">
								<table class="stripe" style="margin: 0px; padding: 0px;">
									<colgroup>
										<col width="5%">
										<col width="40%">
										<col width="20%">
										<col width="20%">
										<col width="15%">
									</colgroup>

									<tbody>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
										<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									</tbody>
								</table>
							</div>

							<div>
								<table class="header-table">
									<colgroup>
										<col width="5%">
										<col width="40%">
										<col width="20%">
										<col width="20%">
										<col width="15%">
									</colgroup>

									<thead>
									<tr>
										<td> </td>
										<td> </td>
										<td> </td>
										<td> 합계: </td>
										<td> 0 </td>
									</tr>
									</thead>
								</table>
							</div>
						</div>
					</div>
				</div>

			</div>

			<div class="content_div" style="width: 58.5%; float: right; margin: 0px 30px 19px 0px;">

				<div class="title_box">
					<div class="title">
						<span class="icon material-icons">assignment</span> 보관 현황
					</div>
					<div class="function">
						<span class="icon icon_title_blue material-icons icon-flipped" style="font-size: 20px;">reply</span><span style="margin-right: 7px;">출고</span>
						<span class="icon icon_title_blue material-icons icon-flipped" style="font-size: 20px;">delete_forever</span><span style="margin-right: 7px;">삭제</span>
						<span class="icon icon_title_blue material-icons" style="font-size: 18px;">edit</span><span>수정</span>
					</div>
					<div>
						<div class="scrollable-wrapper" style="margin-left: 3px; margin-bottom: 5px;">
							<div>
								<table class="header-table">
									<colgroup>
										<col width="5%">
										<col width="40%">
										<col width="20%">
										<col width="20%">
										<col width="15%">
									</colgroup>

									<thead>
									<tr>
										<td> </td>
										<td>관리번호</td>
										<td>품목명</td>
										<td>적재위치</td>
										<td>선택</td>
									</tr>
									</thead>
								</table>
							</div>
							<div class="scrollable" style="height: 568px;">
								<table class="stripe">
									<colgroup>
										<col width="5%">
										<col width="40%">
										<col width="20%">
										<col width="20%">
										<col width="15%">
									</colgroup>

									<tbody>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									<tr><td>1</td><td>1</td><td>1</td><td>1</td><td>1</td></tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
					</div>
				</div>

			</div>

			<br style="clear:both;"/>

		</div>

	</div>

</div>

</body>

