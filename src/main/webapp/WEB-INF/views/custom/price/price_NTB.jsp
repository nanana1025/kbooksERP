<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="getNTBList"					value="/price/getNTBList.json" />
<c:url var="getCodeListCustom"					value="/common/getCodeListCustom.json" />
<c:url var="companyDelete"					value="/user/companyDelete.json" />
<c:url var="companyInsert"					value="/user/companyInsert.json" />
<c:url var="createReceipt"					value="/consigned/createReceipt.json"/>
<c:url var="updateReceipt"					value="/consigned/updateReceipt.json"/>
<c:url var="dataList"					value="/customDataList.json" />
<c:url var="consignedPopup"					value="/CustomP.do"/>

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

		.k-grid-toolbar .k-grid-price-ratio {
		    float:right;
		   	margin-right: 5px;
		   	background-color: #DA391D;
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

			console.log("priceNTB.jsp");

			initNTBList();


			// Toolbar 버튼에 함수 추가
			$(".k-grid-button-add").click(clickAddButton);
			$(".k-grid-button-remove").click(clickRemoveButton);
			$(".k-grid-button-up").click(clickUpButton);
			$(".k-grid-button-down").click(clickDownButton);
			$(".k-grid-price-ratio").click(fnNTBPriceRatio);


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




	function initNTBList()
	{

		var url = '${getNTBList}';

		var params = {
    			ID: 1
    	};

		var NTBList;

		$.ajax({
    		url : url,
    		type : "POST",
    		data : params,
    		async : false,
    		success : function(data) {

    			NTBList = data.DATA;
    		}
		});




		// 데이터 그리드 시작
		$("#notebook-grid").kendoGrid({
			dataSource: {
				data: NTBList,
				schema: {
					model: {
						id: "key",
						fields: {
							NTB_LIST_ID: {type: "number"},
							DISPLAY_SEQ: {type: "number"},
							NTB_CATEGORY: {type: "string"},
							NTB_CODE: {type: "string"},
							NTB_NAME: {type: "string"},
							NTB_GENERATION: {type: "string"},
							NTB_NICKNAME: {type: "string"},
							LT_PURCHASE_PRICE_MAJOR: {type: "number"},
							LT_PURCHASE_PRICE_ETC: {type: "number"},
							LT_DANAWA_PRICE_MAJOR: {type: "number"},
							LT_DANAWA_PRICE_ETC: {type: "number"},
							LT_DEALER_PRICE_MAJOR: {type: "number"},
							LT_DEALER_PRICE_ETC: {type: "number"}
						}
					}
				},
				sort: [
					{ field: "DISPLAY_SEQ", dir: "asc" }
				]
			},
			selectable: "single",
			editable: "grid",
			resizable: true,
			columns: [
				{
					title: "구분",
					columns: [
						{
							field: "NTB_CATEGORY",
							title: "구분",
						},
						{
							field: "NTB_CODE",
							title: "코드명"
						},
						{
							field: "NTB_NAME",
							title: "제품명"
						},
						{
							field: "NTB_GENERATION",
							title: "세대"
						}
					]
				},
				{
					field: "NTB_NICKNAME",
					title: "구분값"
				},
				{
					title: "리더스텍 소비자 매입가",
					columns: [
						{
							field: "LT_PURCHASE_PRICE_MAJOR",
							title: "Samsumng/LG",
							format:"{0:n0}",
							attributes:{style:"text-align:right;"}
						},
						{
							field: "LT_PURCHASE_PRICE_ETC",
							title: "기타",
							format:"{0:n0}",
							attributes:{style:"text-align:right;"}
						}
					]
				},
				{
					title: "리더스텍 다나와 매입가",
					columns: [
						{
							field: "LT_DANAWA_PRICE_MAJOR",
							title: "Samsumng/LG",
							format:"{0:n0}",
							attributes:{style:"text-align:right;"}
						},
						{
							field: "LT_DANAWA_PRICE_ETC",
							title: "기타",
							format:"{0:n0}",
							attributes:{style:"text-align:right;"}
						}
					]
				},
				{
					title: "리더스텍 딜러 매입가",
					columns: [
						{
							field: "LT_DEALER_PRICE_MAJOR",
							title: "Samsumng/LG",
							format:"{0:n0}",
							attributes:{style:"text-align:right;"}
						},
						{
							field: "LT_DEALER_PRICE_ETC",
							title: "기타",
							format:"{0:n0}",
							attributes:{style:"text-align:right;"}
						}
					]
				},
// 				{
// 					title: "수정",
// 					width: "4%",
// 					template: kendo.template($("#edit-template").html())
// 				}
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
				},
				{
					name: "price-ratio",
					text: "<span class='k-icon k-i-percent'></span> 가격 비율"
				}
			],
// 			save:function(e){
// 				updateTempRecords();
// 			},
// 			cancel:function(e){
// 				if(tempSavedRecords != null){
// 					$('#grid').data('kendoGrid').dataSource.data(tempSavedRecords);
// 				}
// 				else{
// 					$('#grid').data('kendoGrid').dataSource.cancelChanges();
// 				}
// 			},
			remove:function(e){
				$('#grid').data('kendoGrid').dataSource.remove(e.model)
				updateTempRecords();
			}
		}); // 데이터 그리드 종료

		$("#notebook-grid tbody").on("dblclick", "td", function(e) {
			var grid = $("#notebook-grid").data("kendoGrid");
			var selectedRow = grid.select();
			var selItem = grid.dataItem(selectedRow);

 			console.log("selItem.NTB_LIST_ID = "+selItem.NTB_LIST_ID);

			fnNTBUpdate(selItem.NTB_LIST_ID);


	      });

	}

	</script>

	<script>

	function updateTempRecords() {

		console.log("updateTempRecords.jsp");

	}

		function clickAddButton() {

// 			var grid = $("#notebook-grid").data("kendoGrid");

// 			// 선택된 항목 탐색
// 			var selectedRow = grid.select();
// 			var selectedItem = grid.dataItem(selectedRow);

// 			if( selectedItem == null ) { // 선택된 항목이 없는 경우 > 첫번쨰에 추가

// 				var dataSource = grid.dataSource;
// 				var insertIndex = dataSource.data().length;

// 				dataSource.insert(0, {});
// 				var newRow = grid.tbody.children().first();
// 				grid.editRow(newRow);

// 				console.log(newRow);

// 				newRow.find(".editBtnContainer").toggle();
// 				newRow.find(".updateCancelContainer").toggle();

// 			}
// 			else { // 선택된 항목이 있을 경우 > 해당 항목 뒤에 추가

// 				var dataSource = grid.dataSource;
// 				var insertIndex = selectedItem.index + 1;

// 				dataSource.insert(insertIndex, {index: insertIndex});
// 				var newRow = grid.tbody.children().get(insertIndex);
// 				console.log(newRow);
// 				grid.editRow(newRow);

// 				var createdRow = $(".k-grid-edit-row");
// 				console.log(createdRow);

// 				createdRow.find(".editBtnContainer").toggle();
// 				createdRow.find(".updateCancelContainer").toggle();

// 				// console.log(dataSource.data());

// 			}



			var displaySeq = -1;
			var grid = $("#notebook-grid").data("kendoGrid");
			var selectedRow = grid.select();
			var selItem = grid.dataItem(selectedRow);

			if( selItem != null ) {
				displaySeq = selItem.DISPLAY_SEQ;
			}

			fnNTBInsert(displaySeq);

		}


		function fnNTBInsert(display_seq) {
			console.log("fnNTBInsert() Load");

			var xn = "create_NTB_DATA";
			var sid ="ntb_price";
			var width = 700;
			var height = 450;

		    var xPos  = (document.body.clientWidth /2) - (800 / 2);
		    xPos += window.screenLeft;
		    var yPos  = (screen.availHeight / 2) - (600 / 2);
		   window.open("<c:url value='/dataEdit.do'/>"+"?xn="+xn+"&sid="+sid+"&DISPLAY_SEQ="+display_seq, "NTB List", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

		}

		function fnNTBUpdate(NTBListId) {
			console.log("fnNTBUpdate() Load");

			var xn = "edit_NTB_DATA";
			var sid ="ntb_price";
			var width = 700;
			var height = 450;

		    var xPos  = (document.body.clientWidth /2) - (800 / 2);
		    xPos += window.screenLeft;
		    var yPos  = (screen.availHeight / 2) - (600 / 2);
		   window.open("<c:url value='/dataView.do'/>"+"?xn="+xn+"&sid="+sid+"&objectid=NTB_LIST_ID&NTB_LIST_ID="+NTBListId, "NTB List1", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

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

		function fnNTBPriceRatio(){

			var url = '${consignedPopup}';

			var query = "?content=ntbPriceRatio";

			var width, height;
		    	width = "800";
		    	height = "540";


			var xPos  = (document.body.clientWidth /2) - (width / 2);
		    xPos += window.screenLeft;
		    var yPos  = (screen.availHeight / 2) - (height / 2);

		    window.open("<c:url value='"+url+query+"'/>", "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);

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
