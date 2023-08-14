<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="getComponentInfo"					value="/compInven/getComponentInfo.json" />
<c:url var="getCodeListCustom"					value="/common/getCodeListCustom.json" />
<c:url var="companyDelete"					value="/user/companyDelete.json" />
<c:url var="companyInsert"					value="/user/companyInsert.json" />
<c:url var="createReceipt"					value="/consigned/createReceipt.json"/>
<c:url var="updateReceipt"					value="/consigned/updateReceipt.json"/>
<c:url var="dataList"					value="/customDataList.json" />

<head>

	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	<title>DANGOL365 ERP | 노트북 가격</title>

 	<link rel="stylesheet" type="text/css" href="/codebase/css/custom_style.css"/>
	<script src="/codebase/gochigo.kendo.ui.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>



	<style>

		.k-grid-header .k-grid-header-wrap th.k-header {
			text-align: center;
			vertical-align: middle;
		}

		.k-grid-toolbar {
			padding: 5px;
		}

		.k-grid-toolbar a {
			background-color: #535b6a;
		}

		.editBtnContainer {
			text-align: center;
		}

		.updateCancelContainer {
			text-align: center;
			display: none;
		}

	</style>

	<script type="text/x-kendo-template" id="edit-template">

		<div class="editBtnContainer">
			<span class='k-icon k-i-pencil custom-edit'></span>
		</div>

		<div class="updateCancelContainer">
			<span class='k-icon k-i-check custom-update' style="margin-right: 5px"></span>
			<span class='k-icon k-i-cancel custom-cancle'></span>
		</div>

	</script>

	<script type="text/javascript">

		$(document).ready(function() {

			console.log("priceNTB_custom.jsp");

			// 데이터 컬럼
			// category1
			// category2
			// category3
			// category4
			// category_value
			// readers_tech_customer_price_sl
			// readers_tech_customer_price_etc
			// readers_tech_danawa_price_sl
			// readers_tech_danawa_price_etc
			// readers_tech_dealer_price_sl
			// readers_tech_dealer_price_etc

			// 데이터
			var data = [
				{
					key: 100000,
					index: 0,
					category1: "Core2 Duo",
					category2: "Core2 Duo",
					category3: "Merom",
					category4: "",
					category_value: "팬티엄_듀얼코어",
					readers_tech_customer_price_sl: 10000,
					readers_tech_customer_price_etc: 10000,
					readers_tech_danawa_price_sl: 10000,
					readers_tech_danawa_price_etc: 10000,
					readers_tech_dealer_price_sl: 25000,
					readers_tech_dealer_price_etc: 23000
				},
				{
					key: 100001,
					index: 1,
					category1: "Pentium",
					category2: "네할렘",
					category3: "Arrandale",
					category4: "1세대",
					category_value: "팬티엄_1세대",
					readers_tech_customer_price_sl: 16000,
					readers_tech_customer_price_etc: 10000,
					readers_tech_danawa_price_sl: 16000,
					readers_tech_danawa_price_etc: 10000,
					readers_tech_dealer_price_sl: 25000,
					readers_tech_dealer_price_etc: 23000
				},
				{
					key: 100002,
					index: 2,
					category1: "Core i3",
					category2: "샌드브릿지",
					category3: "Sandy Bridge",
					category4: "2세대",
					category_value: "Intel i3 1세대",
					readers_tech_customer_price_sl: 16000,
					readers_tech_customer_price_etc: 10000,
					readers_tech_danawa_price_sl: 16000,
					readers_tech_danawa_price_etc: 10000,
					readers_tech_dealer_price_sl: 25000,
					readers_tech_dealer_price_etc: 23000
				},
				{
					key: 100003,
					index: 3,
					category1: "Core i5",
					category2: "아이비브릿지",
					category3: "Ivy Bridge",
					category4: "3세대",
					category_value: "Intel i5 3세대",
					readers_tech_customer_price_sl: 16000,
					readers_tech_customer_price_etc: 10000,
					readers_tech_danawa_price_sl: 16000,
					readers_tech_danawa_price_etc: 10000,
					readers_tech_dealer_price_sl: 25000,
					readers_tech_dealer_price_etc: 23000
				}
			];

			// 데이터 그리드 시작
			$("#notebook-grid").kendoGrid({
				dataSource: {
					data: data,
					schema: {
						model: {
							id: "key",
							fields: {
								key: {type: "number"},
								index: {type: "number"},
								category1: {type: "string"},
								category2: {type: "string"},
								category3: {type: "string"},
								category4: {type: "string"},
								category_value: {type: "string"},
								readers_tech_customer_price_sl: {type: "number"},
								readers_tech_customer_price_etc: {type: "number"},
								readers_tech_danawa_price_sl: {type: "number"},
								readers_tech_danawa_price_etc: {type: "number"},
								readers_tech_dealer_price_sl: {type: "number"},
								readers_tech_dealer_price_etc: {type: "number"}
							}
						}
					},
					sort: [
						{ field: "index", dir: "asc" }
					]
				},
				selectable: "single",
				editable: "inline",
				columns: [
					{
						title: "구분",
						columns: [
							{
								field: "category1",
								title: "구분",
							},
							{
								field: "category2",
								title: "코드명"
							},
							{
								field: "category3",
								title: "제품명"
							},
							{
								field: "category4",
								title: "세대"
							}
						]
					},
					{
						field: "category_value",
						title: "구분값"
					},
					{
						title: "리더스텍 소비자 매입가",
						columns: [
							{
								field: "readers_tech_customer_price_sl",
								title: "Samsumng/LG"
							},
							{
								field: "readers_tech_customer_price_etc",
								title: "기타"
							}
						]
					},
					{
						title: "리더스텍 다나와 매입가",
						columns: [
							{
								field: "readers_tech_danawa_price_sl",
								title: "Samsumng/LG"
							},
							{
								field: "readers_tech_danawa_price_etc",
								title: "기타"
							}
						]
					},
					{
						title: "리더스텍 딜러 매입가",
						columns: [
							{
								field: "readers_tech_dealer_price_sl",
								title: "Samsumng/LG"
							},
							{
								field: "readers_tech_dealer_price_etc",
								title: "기타"
							}
						]
					},
					{
						title: "수정",
						width: "4%",
						template: kendo.template($("#edit-template").html())
					}
				], // 컬럼 정의 종료
				toolbar: [
					{
						name: "button-add",
						text: "<span class='k-icon k-i-add'></span> 추가"
					},
					{
						name: "button-remove",
						text: "<span class='k-icon k-i-minus'></span> 삭제"
					},
					{
						name: "button-up",
						text: "<span class='k-icon k-i-arrow-60-up'></span> UP"
					},
					{
						name: "button-down",
						text: "<span class='k-icon k-i-arrow-60-down'></span> DOWN"
					}
				],
				save:function(e){
					updateTempRecords();
				},
				cancel:function(e){
					if(tempSavedRecords != null){
						$('#grid').data('kendoGrid').dataSource.data(tempSavedRecords);
					}
					else{
						$('#grid').data('kendoGrid').dataSource.cancelChanges();
					}
				},
				remove:function(e){
					$('#grid').data('kendoGrid').dataSource.remove(e.model)
					updateTempRecords();
				}
			}); // 데이터 그리드 종료

			// Toolbar 버튼에 함수 추가
			$(".k-grid-button-add").click(clickAddButton);
			$(".k-grid-button-remove").click(clickRemoveButton);
			$(".k-grid-button-up").click(clickUpButton);
			$(".k-grid-button-down").click(clickDownButton);

			// 편집
			$("#notebook-grid").on("click", ".custom-edit", function(e) {

				e.preventDefault();

				var row = $(this).closest("tr");
				$("#notebook-grid").data("kendoGrid").editRow(row);

				row.find(".editBtnContainer").toggle();
				row.find(".updateCancelContainer").toggle();

			});

			$("#notebook-grid").on("click", ".custom-update", function (e) {

				e.preventDefault();

				var grid = $("#notebook-grid").data("kendoGrid");
				grid.saveChanges();
				grid.dataSource.sync();

				var row = $(this).closest("tr");
				row.find(".editBtnContainer").toggle();
				row.find(".updateCancelContainer").toggle();

				console.log(grid.dataSource.data());

				// 데이터베이스 수정


			});

			$("#notebook-grid").on("click", ".custom-cancle", function (e) {

				e.preventDefault();

				var grid = $("#notebook-grid").data("kendoGrid");
				var dataSource = grid.dataSource;
				dataSource.cancelChanges();

				var row = $(this).closest("tr");
				row.find(".editBtnContainer").toggle();
				row.find(".updateCancelContainer").toggle();

			});

		});

	</script>

	<script>

		function clickAddButton() {

			var grid = $("#notebook-grid").data("kendoGrid");

			// 선택된 항목 탐색
			var selectedRow = grid.select();
			var selectedItem = grid.dataItem(selectedRow);

			if( selectedItem == null ) { // 선택된 항목이 없는 경우 > 첫번쨰에 추가

				var dataSource = grid.dataSource;
				var insertIndex = dataSource.data().length;

				dataSource.insert(0, {});
				var newRow = grid.tbody.children().first();
				grid.editRow(newRow);

				console.log(newRow);

				newRow.find(".editBtnContainer").toggle();
				newRow.find(".updateCancelContainer").toggle();

			}
			else { // 선택된 항목이 있을 경우 > 해당 항목 뒤에 추가

				var dataSource = grid.dataSource;
				var insertIndex = selectedItem.index + 1;

				dataSource.insert(insertIndex, {index: insertIndex});
				var newRow = grid.tbody.children().get(insertIndex);
				console.log(newRow);
				grid.editRow(newRow);

				var createdRow = $(".k-grid-edit-row");
				console.log(createdRow);

				createdRow.find(".editBtnContainer").toggle();
				createdRow.find(".updateCancelContainer").toggle();

				// console.log(dataSource.data());

			}

		}

		function clickRemoveButton() {

			var grid = $("#notebook-grid").data("kendoGrid");
			var selectedRow = grid.select();
			var removeRow = grid.dataItem(selectedRow);

			if( removeRow == null ) {
				kendo.alert("선택된 항목이 없습니다.");
				return;
			}

			kendo.confirm("선택된 항목을 삭제하시겠습니까?")
				.done(function() {

					grid.dataSource.remove(removeRow);
					grid.dataSource.sync();

					// 데이터베이스 삭제
					console.log(removeRow.key);

				})
				.fail(function() {
				})

		}

		function clickUpButton() {

			var grid = $("#notebook-grid").data("kendoGrid");
			var dataSource = grid.dataSource;

			var selectedRow = grid.select();
			var selectedItem = grid.dataItem(selectedRow);

			// 선택된 항목이 없는 경우 종료
			if( selectedItem == null ) {
				kendo.alert("선택된 항목이 없습니다.");
				return;
			}

			// 선택된 항목이 0번째일 경우 종료
			if( selectedItem.index == 0 ) {
				return;
			}

			var prevRow = selectedRow.prev("tr");
			var prevItem = grid.dataItem(prevRow);

			prevItem.index = prevItem.index + 1;
			selectedItem.index = selectedItem.index - 1;

			dataSource.sync();

		}

		function clickDownButton() {

			var grid = $("#notebook-grid").data("kendoGrid");
			var dataSource = grid.dataSource;

			var selectedRow = grid.select();
			var selectedItem = grid.dataItem(selectedRow);

			// 선택된 항목이 없는 경우 종료
			if( selectedItem == null ) {
				kendo.alert("선택된 항목이 없습니다.");
				return;
			}

			// 선택된 항목이 0번째일 경우 종료
			if( selectedItem.index == (dataSource.data().length-1) ) {
				return;
			}

			var nextRow = selectedRow.next("tr");
			var nextItem = grid.dataItem(nextRow);

			nextItem.index = nextItem.index - 1;
			selectedItem.index = selectedItem.index + 1;

			dataSource.sync();

		}

	</script>

</head>

<body>

	<div id="content" data-role="splitter" class="k-widget k-splitter content">

		<div class="header_title">
			<span class="pagetitle header-title30"> 노트북 가격 </span>
		</div>

		<div style="margin: 5px 5px 600px 5px;">
			<div id="notebook-grid">
			</div>
		</div>

	</div>

</body>
