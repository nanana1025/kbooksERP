<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<c:url var="getConsignedComponentReleaseReturnInfo"					value="/consigned/getConsignedComponentReleaseReturnInfo.json" />
<c:url var="getConsignedReleaseComponentList"			value="/consigned/getConsignedReleaseComponentList.json" />
<c:url var="updateReleaseReturn"					value="/consigned/updateReleaseReturn.json" />

<c:url var="getReturnCnt"				value="/consigned/getReturnCnt.json"/>


<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	<title>DANGOL365 ERP | 반품 부품 체크</title>

 	<link rel="stylesheet" type="text/css" href="/codebase/css/custom_style.css"/>
	<script src="/codebase/gochigo.kendo.ui.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

	<script type="text/javascript">


 		var _listComponentId = new Array();

 		var _listSelectedComponentId = new Array();

 		var _proxyId = -1;
 		var _receipt = "";
 		var _companyId = -1;
 		var _proxyPartId = -1;

 		var _proxyState;

 		var _userId;
 		var _userName;

 		var _stateDateData = new Array();

 		var _componentInfo;
 		var _componentReleaseInfo;
 		var _componentCnt = 0;
 		var _componentReleaseCnt = 0;

 		var _selectedRow = null;
 		var _selectedReleaseRow = null;

 		var _countCheck = null;

		$(document).ready(function() {

			console.log("consigned_receipt.jsp");

			totalProductCount = 0;

			var key = getParameterByName('KEY');
			_proxyId = getParameterByName(key);

			var key1 = getParameterByName('KEY1');
			_receipt = getParameterByName(key1);

			var key2 = getParameterByName('KEY2');
			_companyId = getParameterByName(key2);

			fnInitConsignedData();

			setTableRowClickEvent();

		});


		function setTooltipOnIcon(variable, context){

			var tooltipText = context;

			variable.kendoTooltip({
 				content: tooltipText,
				callout: false
			});
		}

		function setTableRowClickEvent() {
			$("#tbl_consigned_component_data tr").click(function() {

				_selectedRow = $(this).children();
				var rowIdx = _selectedRow.closest("tr").prevAll().length;
				_proxyPartId = _selectedRow.eq(0).text();

				for(var i = 0; i < _componentCnt; i++) {

					var checkBox = $("[id*='checkComponent_" + i +"']");

					if(i == rowIdx)
						checkBox.prop("checked", true);
					else
						checkBox.prop("checked", false);
				}

				fnInitConsignedReleaseData();
			});
		}


		 function getParameterByName(name) {
				name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
				var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
						results = regex.exec(location.search);
				return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
			}


		function fnInitConsignedData() {
			console.log("CompanyList.fnInitConsignedData() Load");

			var url = '${getConsignedComponentReleaseReturnInfo}';
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

 	    				_userId = data.USER_ID;
 	    				_userName = data.USER_NAME;

		    			setConsignedComponent(data.DATA);
	    			}
	    		}
	    	});
		}

		function fnInitConsignedReleaseData() {
			console.log("CompanyList.fnInitConsignedReleaseData() Load");

			var url = '${getConsignedReleaseComponentList}';
			var params = {
	    			PROXY_PART_ID: _proxyPartId
	    	};

			$(".consigned_release_items").empty();

			$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : params,
	    		async : false,
	    		success : function(data) {

	    			if(data.SUCCESS){

		    			setConsignedReleaseComponent(data.DATA);
	    			}
	    		}
	    	});
		}


		function fnAsignWarehousing(proxyPartId, consignedType, componentCd){
			console.log("CompanyList.fnAsignWarehousing() Load");

			var url = '${asignConsignedReleaseInventory}';

			var params = {
					PROXY_PART_ID: proxyPartId,
					COMPANY_ID: _companyId,
					CONSIGNED_TYPE: consignedType,
					COMPONENT_CD: componentCd
	    	};


			//시작지점
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
								if(data.SUCCESS){
									GochigoAlert(data.MSG);
								}
								else{
									GochigoAlert(data.MSG);
								}

								fnInitConsignedReleaseData();
								setConsignedInventoryCnt();
							}
						});
						//끝지점
					}
				},
				{
					text: '취소'
				}],
				minWidth : 200,
				title: fnGetSystemName(),
			    content: "출고 부품을 할당하시겠습니까?(기존 할당된 부품은 초기화됩니다.)"
			}).data("kendoConfirm").open();
		}


	function setConsignedComponent(DATA){
		var consigned_items = DATA;
		var totalReleaseCnt = 0;
		var totalReturnAllCnt = 0;
		var totalReturnGoodCnt = 0;
		var totalReturnFaultCnt = 0;


		_componentInfo = [];
		_componentCnt = consigned_items.length;

		if(consigned_items.length > 0) {

			$(".consigned_items").empty();

			for(var i=0; i<consigned_items.length; i++) {

				_componentInfo[i] = consigned_items[i];

				var componentId = consigned_items[i].COMPONENT_ID;
				var componentCd = consigned_items[i].COMPONENT_CD;

				var color;

				var fontColor;

				if(i%2 == 1) color = "#E6E6E6";
				else color = "#FFFFFF"

				var releaseCnt = consigned_items[i].RELEASE_CNT;
				var returnAllCnt = consigned_items[i].RETURN_ALL_CNT;

				var releaseYn = releaseCnt == 1? 'O':'X';
				var returnYn = returnAllCnt == 1? 'O':'X';

				var returnGoodCnt = consigned_items[i].RETURN_GOOD_CNT;
				var returnFaultCnt = consigned_items[i].RETURN_FAULT_CNT;

				totalReleaseCnt += (releaseCnt *1) ;
				totalReturnAllCnt += (returnAllCnt *1) ;
				totalReturnGoodCnt += (returnGoodCnt *1) ;
				totalReturnFaultCnt += (returnFaultCnt *1) ;


				var consignedType = consigned_items[i].CONSIGNED_TYPE;

				var proxyPartId = consigned_items[i].PROXY_PART_ID;

				if(consignedType == 2)
					fontColor = 'RED';
				else
					fontColor = 'BLACK';

				var checkId = "checkSelectReleaseComponentL_"+consigned_items[i].COMPONENT_ID+"_"+consignedType;

// 				var btnAsign = '<button id="inventory_asign_btn" type="button" onclick="fnAsignWarehousing('+proxyPartId+','+consignedType+',\''+componentCd+'\')" class="k-button">부품할당</button>';

				var item = '<tr>';
				item +='<td style="display:none;">'+proxyPartId+'</td>';
				item +='<td style="display:none;">'+componentId+'</td>';
				item +='<td style="display:none;">'+consignedType+'</td>';


				item +='<td ><input type="checkbox" id="checkComponent_'+i+'" unchecked></td>';
				item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+';">'+componentCd+'</td>';
				item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+'; background-color:'+color+';">'+consigned_items[i].COMPONENT+'</td>';
				item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+';">'+consigned_items[i].DETAIL_DATA+'</td>';
				item +='<td  style="color:'+fontColor+'; background-color:'+color+';" align="center">'+releaseYn+'</td>';
				item +='<td  style="color:'+fontColor+'; background-color:'+color+';" align="center"><label for="return_All_cnt_'+proxyPartId+'">'+returnYn+'</label></td>';
				item +='<td  style="color:'+fontColor+'; background-color:'+color+';" align="center"><label for="return_good_cnt_'+proxyPartId+'">'+returnGoodCnt+'</label></td>';
				item +='<td  style="color:'+fontColor+'; background-color:'+color+';" align="center"><label for="return_fault_cnt_'+proxyPartId+'">'+returnFaultCnt+'</label></td>';
// 				item +='<td>' + btnSearch + btnSave + btnAsign +'</td>';
				item += '</tr>';
				$(".consigned_items").append(item);
			}

		}

		$("#numOfComponent").text("TOTAL: "+consigned_items.length+" EA");
		$("#numOfInventory").text("합계: "+totalReleaseCnt+" EA");
		$("#numOfReturnAllInventory").text("합계: "+totalReturnAllCnt+" EA");
		$("#numOfReturnGoolInventory").text("합계: "+totalReturnGoodCnt+" EA");
		$("#numOfReturnFaultInventory").text("합계: "+totalReturnFaultCnt+" EA");

	}

	function setConsignedReleaseComponent(DATA){
		var consigned_release_items = DATA;
		var totalCnt = 0;

		_componentReleaseInfo = [];
		_componentReleaseCnt = consigned_release_items.length;

		if(consigned_release_items.length > 0) {

			$(".consigned_release_items").empty();

			for(var i=0; i<consigned_release_items.length; i++) {

				_componentReleaseInfo[i] = consigned_release_items[i];

				var componentId = consigned_release_items[i].COMPONENT_ID;
				var componentCd = consigned_release_items[i].COMPONENT_CD;

				var proxyReleasePartId = consigned_release_items[i].PROXY_RELEASE_PART_ID;
				var inventoryId = consigned_release_items[i].INVENTORY_ID;

				var color;

				var fontColor = 'BLACK';

				if(i%2 == 1) color = "#E6E6E6";
				else color = "#FFFFFF"

				var componentCnt = consigned_release_items[i].COMPONENT_CNT;

				totalCnt += (componentCnt *1) ;

				var returnType = consigned_release_items[i].RETURN_TYPE * 1;

				var btnColor =['#C5C4C3;','#C5C4C3;','#C5C4C3;'];
				var btnSelectedColor =['#00CF06;','#55B4FF;','#FF3547;'];

				btnColor[returnType] = btnSelectedColor[returnType];


				var btnReturn0 = '<button id="ReturnBtn0" type="button" style="background-color:'+btnColor[0]+'" onclick="fnReleaseReturn('+proxyReleasePartId+',0, '+returnType+','+inventoryId+')" class="k-button">취소</button>';
				var btnReturn1 = '<button id="ReturnBtn1" type="button" style="background-color:'+btnColor[1]+'" onclick="fnReleaseReturn('+proxyReleasePartId+',1, '+returnType+','+inventoryId+')" class="k-button">정상</button>';
				var btnReturn2 = '<button id="ReturnBtn2" type="button" style="background-color:'+btnColor[2]+'" onclick="fnReleaseReturn('+proxyReleasePartId+',2, '+returnType+','+inventoryId+')" class="k-button">불량</button>';

				var item = '<tr>';

				item +='<td style="display:none;">'+proxyReleasePartId+'</td>';
				item +='<td style="display:none;">'+consigned_release_items[i].PROXY_PART_ID+'</td>';
				item +='<td style="display:none;">'+consigned_release_items[i].COMPONENT_ID+'</td>';
				item +='<td style="display:none;">'+inventoryId+'</td>';

				item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+'; background-color:'+color+'; text-align:center;">'+consigned_release_items[i].WAREHOUSING+'</td>';
				item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+'; background-color:'+color+'; text-align:center;">'+consigned_release_items[i].BARCODE+'</td>';
 				item +='<td>' + btnReturn0 + btnReturn1 + btnReturn2 +'</td>';
				item += '</tr>';
				$(".consigned_release_items").append(item);
			}

		}

		$("#numOfReleaseComponent").text("TOTAL: "+consigned_release_items.length+" EA");
// 		$("#numOfReleaseInventory").text("합계: "+totalCnt+" EA");

	}

	function fnReleaseReturn(proxyReleasePartId, type, returnType, inventoryId){

		if(type == returnType)
			return;

		var url = '${updateReleaseReturn}';

		var params = {
				PROXY_RELEASE_PART_ID: proxyReleasePartId,
				INVENTORY_ID: inventoryId,
				RETURN_TYPE: type
    	};

		if(type == 0){
			params.INVENTORY_STATE = 'R';
			params.LOCK_YN = 'N';
			params.INVENTORY_CAT = 'G';
		}else if(type == 1){
			params.INVENTORY_STATE = 'E';
			params.LOCK_YN = 'Y';
			params.INVENTORY_CAT = 'G';
		} else if(type == 2){
			params.INVENTORY_STATE = 'E';
			params.LOCK_YN = 'Y';
			params.INVENTORY_CAT = 'F';
		}

		$.ajax({
			url : url,
			type : "POST",
			data : params,
			async : false,
			success : function(data) {
				if(data.SUCCESS){
					fnInitConsignedReleaseData();
					setConsignedReleaseReturnCnt();
				}else
					GochigoAlert(data.MSG, false, "dangol365 ERP");
			}
		});
	}

	function setConsignedReleaseReturnCnt(){

		var url = '${getReturnCnt}';

		var params = {
				PROXY_ID: _proxyId
    	};

		var totalReturnAllCnt = 0;
		var totalReturnGoodCnt = 0;
		var totalReturnFaultCnt = 0;

		$.ajax({
			url : url,
			type : "POST",
			data : params,
			async : false,
			success : function(data) {
				if(data.SUCCESS){
					var returnCnt_items = data.DATA;
					for(var i=0; i<returnCnt_items.length; i++) {

						var proxyPartId = returnCnt_items[i].PROXY_PART_ID;
						var returnAllCnt = returnCnt_items[i].RETURN_ALL_CNT;
						var returnGoodCnt = returnCnt_items[i].RETURN_GOOD_CNT;
						var returnFaultCnt = returnCnt_items[i].RETURN_FAULT_CNT;

						totalReturnAllCnt += (returnAllCnt *1) ;
						totalReturnGoodCnt += (returnGoodCnt *1) ;
						totalReturnFaultCnt += (returnFaultCnt *1) ;

						$("label[for='return_All_cnt_"+proxyPartId+"']").text(returnAllCnt);
						$("label[for='return_good_cnt_"+proxyPartId+"']").text(returnGoodCnt);
						$("label[for='return_fault_cnt_"+proxyPartId+"']").text(returnFaultCnt);
					}

					$("#numOfReturnAllInventory").text("합계: "+totalReturnAllCnt+" EA");
					$("#numOfReturnGoolInventory").text("합계: "+totalReturnGoodCnt+" EA");
					$("#numOfReturnFaultInventory").text("합계: "+totalReturnFaultCnt+" EA");
				}
				else{
					GochigoAlert(data.MSG);
				}
			}
		});
	}


	function fnClose(){

		opener.fnInitConsignedComponent();

		self.opener = self;
		window.close();
	}

	 function fnWindowOpen_LTComponent(url, callbackName, popupName, size) {
		    var width, height;
		    if(size == "S"){
		    	width = "800";
		    	height = "600";
		    } else if(size == "M") {
		    	width = "1024";
		    	height = "768";
		    } else if(size == "L") {
		    	width = "1280";
		    	height = "900";
		    }else if(size == "F") {
		    	width = $( window ).width()*0.95;
		    	height = $( window ).height()*0.95;
		    }else if(size == "W") {
		    	width = "1280";
		    	height = "600";
		    }else if(size == "UW") {
		    	width = "1600";
		    	height = "800";
		    } else {
		    	width = "800";
		    	height = "600"
		    }

			var xPos  = (document.body.clientWidth /2) - (width / 2);
		    xPos += window.screenLeft;
		    var yPos  = (screen.availHeight / 2) - (height / 2);
		    window.open("<c:url value='"+url+"'/>&callbackName="+callbackName, popupName, "top="+yPos+", left="+xPos+", width="+width+", height="+height);
		}




	</script>

</head>

<body>

	<div id="content" data-role="splitter" class="k-widget k-splitter content">

		<div class="header_title">
			<span class="pagetitle"><span class="header-title30"></span> 생산대행 - 출고 부품 반품 처리 </span>
		</div>

		<div id="consigned_receipt_btns" class="grid_btns_short" style="width: 100%">
			<button id="consigned_close_btn" type="button" onclick="fnClose()" class="k-button" style="float: right; margin:5px 5px 5px 5px;">닫기</button>
<!-- 			<button id="consigned_component_list_btn" type="button" onclick="fnSelectReleaseComponent()" class="k-button" style="float: right; margin:5px 5px 5px 5px;">출고부품상세보기</button> -->
		</div>

		<div style="padding: 0px;">

			<fieldset class="fieldSet">

			<%-- 제품 정보 --%>
			<div class="info60">

				<div class="sub-header-title">
					<span class="pagetitle">


						<span class="header-title30">  접수 부품 정보 </span>
					</span>
					</div>

				<table id="tbl_consigned_receipt_product_data" class="stripe table_default">

					<colgroup>
						<col width=4%">
						<col width="8%">
						<col width="8%">
						<col width="38%">
						<col width="10%">
						<col width="10%">
						<col width="10%">
						<col width="12%">
					</colgroup>

					<thead>
						<tr>
							<td class="col-header-title"></td>
							<td class="col-header-title">품목명</td>
							<td class="col-header-title">부품코드</td>
							<td class="col-header-title">부품명</td>
							<td class="col-header-title">출고여부</td>
							<td class="col-header-title">반품여부</td>
							<td class="col-header-title">정상품목수량</td>
							<td class="col-header-title">불량품목수량</td>

						</tr>
					</thead>
				</table>

				<div class="scrollable-div-long">

					<table  id="tbl_consigned_component_data" class="stripe table_scroll">

					<colgroup>
						<col width=4%">
						<col width="8%">
						<col width="8%">
						<col width="38%">
						<col width="10%">
						<col width="10%">
						<col width="10%">
						<col width="10%">

						</colgroup>

						<tbody class="consigned_items">
						</tbody>

					</table>

				</div>


				<div style="vertical-align: middle; height: 30px; padding: 0px; background-color: lightgray; margin: 0px 0px 2px 0px;">

					<table class="table_default">

						<colgroup>
							<col width="58%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
							<col width="12%">


						</colgroup>

						<tbody>
							<tr class="col-header-title">
								<td ><label id="numOfComponent">TOTAL: 0 EA</label></td>
								<td ><label id="numOfInventory">합계: 0 EA</label></td>
								<td ><label id="numOfReturnAllInventory">합계: 0 EA</label></td>
								<td ><label id="numOfReturnGoolInventory">합계: 0 EA</label></td>
								<td ><label id="numOfReturnFaultInventory">합계: 0 EA</label></td>
							</tr>
						</tbody>

					</table>
				</div>
			</div>


			<%-- 제품 정보 --%>
			<div class="info40">

				<div class="sub-header-title1">
					<span class="pagetitle">

						<span class="header-title30">  출고 예정 부품 정보 </span>
					</span>
					</div>

				<table id="tbl_consigned_release_data_header" class="stripe table_default">

					<colgroup>
						<col width= "30%">
						<col width= "30%">
						<col width= "40%">
					</colgroup>

					<thead>
						<tr>
							<td class="col-header-title1">입고번호</td>
							<td class="col-header-title1">재고번호</td>
							<td class="col-header-title1">반품</td>
						</tr>
					</thead>
				</table>

				<div class="scrollable-div-long">

					<table  id="tbl_consigned_release_data" class="stripe table_scroll">

						<colgroup>
						<col width= "30%">
						<col width= "30%">
						<col width= "36.5%">

						</colgroup>

						<tbody class="consigned_release_items">
						</tbody>

					</table>

				</div>


				<div style="vertical-align: middle; height: 30px; padding: 0px; background-color: lightgray; margin: 0px 0px 2px 0px;">

					<table class="table_default">

						<colgroup>
							<col width="100%">
						</colgroup>

						<tbody>
							<tr class="col-header-title1">
								<td ><label id="numOfReleaseComponent">TOTAL: 0 EA</label></td>
<!-- 								<td ><label id="numOfReleaseInventory">합계: 0 EA</label></td> -->
							</tr>
						</tbody>

					</table>
				</div>
			</div>
			</fieldset>

	</div>

</div>

</body>

