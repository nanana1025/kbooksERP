<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="getReleaseCandidates"									value="/consigned/getReleaseCandidates.json" />
<c:url var="getSelectedReleaseComponent"						value="/consigned/getSelectedReleaseComponent.json" />

<c:url var="addSelectedReleaseComponent"					value="/consigned/addSelectedReleaseComponent.json" />
<c:url var="deleteSelectedReleaseComponent"				value="/consigned/deleteSelectedReleaseComponent.json"/>
<c:url var="updateSelectedReleaseComponent"				value="/consigned/updateSelectedReleaseComponent.json"/>




<head>
	 <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	 <title>DANGOL365 ERP | 출고 부품 선택</title>

 	<link rel="stylesheet" type="text/css" href="/codebase/css/custom_style.css"/>

	<script src="/codebase/gochigo.kendo.ui.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

	<script type="text/javascript">


	var _SELECT_COL =  [
		/*CPU*/	["MANUFACTURE_NM",  "MODEL_NM",  "SPEC_NM", "COMPONENT_ID"],
		/*MBD*/	["MBD_MODEL_NM", "PRODUCT_NAME", "NB_NM", "SB_NM", "MEM_TYPE", "COMPONENT_ID" ],
		/*MEM*/	["MANUFACTURE_NM", "MODULE_NM",  "CAPACITY", "BANDWIDTH", "COMPONENT_ID"],
		/*VGA*/	["MANUFACTURE_NM", "MODEL_NM", "CAPACITY", "COMPONENT_ID"],
		/*STG*/	["STG_TYPE", "CAPACITY", "SPEED", "COMPONENT_ID"],
		/*STG*/	["STG_TYPE", "CAPACITY", "SPEED", "COMPONENT_ID"],
		/*MON*/	["MODEL_NM", "SIZE", "RESOLUTION", "COMPONENT_ID"],
		/*CAS*/	["MANUFACTURE_NM", "CASE_CAT", "CASE_TYPE", "COMPONENT_ID"],
		/*ADP*/	["MANUFACTURE_NM", "ADP_CAT", "OUTPUT_AMPERE", "OUTPUT_WATT", "COMPONENT_ID"],
		/*POW*/	["POW_CAT", "POW_TYPE", "POW_CLASS", "COMPONENT_ID"],
		/*KEY*/	["MANUFACTURE_NM", "KEY_CAT", "KEY_TYPE", "KEY_CLASS", "COMPONENT_ID"],
 		/*MOU*/	["MANUFACTURE_NM", "MOU_CAT", "MOU_TYPE", "COMPONENT_ID"]
		/*FAN*/	["MANUFACTURE_NM", "FAN_CAT", "FAN_TYPE", "COMPONENT_ID"],
		/*CAB*/	["MANUFACTURE_NM", "CAB_CAT", "CAB_TYPE", "CAB_CLASS", "COMPONENT_ID"],
		/*BAT*/	["MANUFACTURE_NM", "BAT_CAT", "OUTPUT_AMPERE", "OUTPUT_WATT", "COMPONENT_ID"]
		];

 		var _SELECT_COL_NAME =  [
			/*CPU*/	["제조사",  "모델명",  "스펙", "COMPONENT_ID" ],
			/*MBD*/	["모델1", "모델2", "NB NAME", "SB NAME", "COMPONENT_ID"],
			/*MEM*/	["제조사", "모델명",  "용량", "대역폭", "메모리타입", "COMPONENT_ID"],
			/*VGA*/	["제조사", "모델명", "용량", "COMPONENT_ID"],
			/*STG*/	["타입", "용량", "속도", "COMPONENT_ID"],
			/*STG*/	["타입", "용량", "속도", "COMPONENT_ID"],
			/*MON*/	["모델명", "사이즈", "해상도", "COMPONENT_ID"],
			/*CAS*/	["제조사", "대분류","중분류", "COMPONENT_ID"],
			/*ADP*/	["제조사", "대분류", "중분류", "소분류", "COMPONENT_ID"],
			/*POW*/	["대분류", "중분류", "소분류", "COMPONENT_ID"],
			/*KEY*/	["제조사", "대분류", "중분류", "소분류", "COMPONENT_ID"],
			/*MOU*/	["제조사", "대분류", "중분류", "COMPONENT_ID"],
			/*FAN*/	["제조사", "대분류", "중분류", "COMPONENT_ID"],
			/*CAB*/	["제조사", "대분류", "중분류", "소분류", "COMPONENT_ID"],
			/*BAT*/	["제조사", "대분류", "중분류", "소분류", "COMPONENT_ID"],
			/*AIR*/		["제조사", "대분류", "중분류", "소분류", "COMPONENT_ID"],
			/*PKG*/	["제조사", "대분류", "중분류", "소분류", "COMPONENT_ID"]
 			];

 			var _SELECT_COL_WIDTH =  [
 				/*CPU*/	[20,  25,  35],
 				/*MBD*/	[20, 20, 20, 20],
 				/*MEM*/	[16,16,16,16,16],
 				/*VGA*/	[20, 35, 25,],
 				/*STG*/	[20, 30,30],
 				/*STG*/	[20, 30,30],
 				/*MON*/	[28, 26,26],
 				/*CAS*/	[28, 26,26],
 				/*ADP*/	[20, 20, 20, 20],
 				/*POW*/	[28, 26,26],
 				/*KEY*/	[20, 20, 20, 20],
 				/*MOU*/	[28, 26,26],
 				/*FAN*/	[28, 26,26],
 				/*CAB*/	[20, 20, 20, 20],
 				/*BAT*/	[20, 20, 20, 20],
 	 			];

 		var _CODE = ["CPU", "MBD", "MEM", "VGA", "SSD", " HDD", "MON", "CAS", "ADP", "POW", "KEY", "MOU", "FAN", "CAB", "BAT", "AIR", "PKG"];

 		var _listComponentId = new Array();

 		var _proxyId = -1;

		$(document).ready(function() {

			console.log("consigned_componentModif.jsp");

			totalProductCount = 0;

			var key = getParameterByName('KEY');
			_proxyId = getParameterByName(key);


			fnInitReleaseCandidates();
			fnInitConsignedConponent();

		});
	</script>



    <script>

    function getParameterByName(name) {
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
				results = regex.exec(location.search);
		return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	}

    function fnInitConsignedConponent() {
		console.log("CompanyList.fnInitConsignedData() Load");

		var url = '${getSelectedReleaseComponent}';
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

					var consigned_items = data.DATA;

					$('#selected-list-model-no-data').val(data.MODEL_NM);
			 		$('#selected-list-model-no-data').text(data.MODEL_NM);

					if(consigned_items.length > 0) {
	    				for(var i=0; i<consigned_items.length; i++) {

							var component = consigned_items[i].COMPONENT;
							var componentId = consigned_items[i].COMPONENT_ID;
							var componentCd = consigned_items[i].COMPONENT_CD;
							var componentCnt = consigned_items[i].COMPONENT_CNT;
							var maxValue = consigned_items[i].MAX_VALUE;
							var modelNm = consigned_items[i].MODEL_NAME;

							addDetailSpecInit(component, componentCd, modelNm, componentId, componentCnt, maxValue)
	    				}
					}

    			}
    		}
    	});
	}



	function fnClose(){
		self.opener = self;
		window.close();
	}


		function addDetailSpecInit(component, productType, productSpec, componentId, componentCnt, maxValue) {
			var addComponent =
			'<div id="' + productSpec + '_component">' + component +'</div>';

			var addRowTarget = $("[id*='selected-component-" + productType);
			addRowTarget.append(addComponent);

			var addItem =
					'<div id="' + productSpec + '" class="selected-item">' +
					'<div class="col-selected-product">' +
					'<span class="k-icon k-i-arrow-60-right"></span>' +
					productSpec +
					'</div>' +
					'<input type="number" id = "componentId-cnt-'+productType+'-'+componentId+'" class="view k-textbox col-input-number-short" value="'+componentCnt+'" min="0" max="'+maxValue+'" onchange="fnUpdateComponent(' + _proxyId+','+ componentId +',this.value )">' +
					'<input type="text" class="view k-textbox" value="'+componentId+'" style="display:none;">' +
					'<span class="k-icon k-i-close col-icon" onclick="removeSelectedItem(\'' + productType + '\',\'' + productSpec + '\',' + componentId +' )"><span>' +
					'</div>';

			var selectorNoData = $("[id*='selected-list-" + productType.toLowerCase() + "-no-data']");
			selectorNoData.hide();

			var addRowTarget = $("[id*='selected-list-" + productType);
			addRowTarget.append(addItem);

			countTotalProduct();

			if(_listComponentId.indexOf(componentId) < 0){
				_listComponentId.push(componentId);
				$("#component-add-"+productType+"-"+componentId).hide();
				$("#component-remove-"+productType+"-"+componentId).show();
			}
		}

		function addDetailSpec(component, productType, productSpec, componentId, componentCnt) {
			var addComponent =
			'<div id="' + productSpec + '_component">' + component +'</div>';

			var addRowTarget = $("[id*='selected-component-" + productType);
			addRowTarget.append(addComponent);

			var addItem =
					'<div id="' + productSpec + '" class="selected-item">' +
					'<div class="col-selected-product">' +
					'<span class="k-icon k-i-arrow-60-right"></span>' +
					productSpec +
					'</div>' +
					'<input type="number" id = "componentId-cnt-'+productType+'-'+componentId+'" class="view k-textbox col-input-number-short" value="'+componentCnt+'" min="0" max="'+componentCnt+'" onchange="fnUpdateComponent(' + _proxyId+','+ componentId +',this.value )">' +
					'<input type="text" class="view k-textbox" value="'+componentId+'" style="display:none;">' +
					'<span class="k-icon k-i-close col-icon" onclick="removeSelectedItem(\'' + productType + '\',\'' + productSpec + '\',' + componentId +' )"><span>' +
					'</div>';

			var selectorNoData = $("[id*='selected-list-" + productType.toLowerCase() + "-no-data']");
			selectorNoData.hide();

			var addRowTarget = $("[id*='selected-list-" + productType);
			addRowTarget.append(addItem);

			countTotalProduct();

			if(_listComponentId.indexOf(componentId) < 0){
				_listComponentId.push(componentId);
				$("#component-add-"+productType+"-"+componentId).hide();
				$("#component-remove-"+productType+"-"+componentId).show();
			}

			fnAddComponent(_proxyId, componentId, componentCnt);

		}

		function fnAddComponent(proxyId, componentId, componentCnt){

			var params = {
					PROXY_ID: proxyId,
		    		COMPONENT_ID: componentId,
		    		COMPONENT_CNT: componentCnt,
		    		MAX_VALUE: componentCnt
			}

	   		var url = '${addSelectedReleaseComponent}';

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

		function removeSelectedItem(productType, productSpec, componentId) {

			console.log("productSpec = "+productSpec);
			var removeItem = document.getElementById(productSpec);
			removeItem.remove();
			var removeComponent = document.getElementById(productSpec+"_component");
			removeComponent.remove();

			// 선택된 데이터가 있는지 체크
			var selector = "selected-list-" + productType;
			var selectedTd = document.getElementById(selector);

			if(selectedTd.childElementCount <= 1) {
				var selectorNoData = $("[id*='selected-list-" + productType.toLowerCase() + "-no-data']");
				selectorNoData.show();

				var selectorNoData1 = $("[id*='selected-component-" + productType.toLowerCase() +"']");
				selectorNoData1.show();

			}

			countTotalProduct();

			var index = _listComponentId.indexOf(componentId);

			if(index > -1){
				_listComponentId.splice(index, 1);
				$("#component-add-"+productType+"-"+componentId).show();
				$("#component-remove-"+productType+"-"+componentId).hide();
			}

			fndeleteComponent(_proxyId, componentId);

		}

		function fndeleteComponent(proxyId, componentId){

			var params = {
					PROXY_ID: proxyId,
		    		COMPONENT_ID: componentId

			}

	   		var url = '${deleteSelectedReleaseComponent}';

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

		function fnUpdateComponent(proxyId, componentId, componentCnt) {


			var params = {
					PROXY_ID: proxyId,
		    		COMPONENT_ID: componentId,
		    		COMPONENT_CNT: componentCnt
			}

	   		var url = '${updateSelectedReleaseComponent}';

	    	$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : JSON.stringify(params),
	    		contentType: "application/json",
	    		async : false,
	    		success : function(data) {

	    		}
	    	});

			countTotalProduct();
		}

		function countTotalProduct() {

			var sum = 0;
			var inputs = $(".col-input-number-short");

			for(var i=0; i<inputs.length; i++) {
				sum = sum + Number($(".col-input-number-short")[i].value);
			}

			$("#total-product-count")[0].innerText = sum;
		}


		<%-- 제품 정보 > 찾기 > 리스트 조회 --%>
		function fnInitReleaseCandidates() {

			var url = '${getReleaseCandidates}';

			var params = {
					PROXY_ID: _proxyId
			}


		$('#tbl_consigned_release_candidates').children().remove();

		var item = '<thead><tr>';
		item += '<td class="col-header-title1" style="width: 10%;">#</td>';
		var i;
		item += '<td class="col-header-title1" style="width: 80%;"> 모델명</td>';

		item += '<td class="col-header-title1" style="width: 10%;">추가</td>';
		item += '<td class="col-header-title" style="display:none;">COMPONENT_ID</td>';
		item += '<td class="col-header-title" style="display:none;">COMPONENT</td>';
		item += '<td class="col-header-title" style="display:none;">COMPONENT_TYPE</td>';
		item += '<td class="col-header-title" style="display:none;">CNT</td>';
		item += '<tr>	</thead>';

		$("#tbl_consigned_release_candidates").append(item);


		$('.searched_items').children().remove();

			$.ajax({
				url : url,
				type : "POST",
				data : params,
				async : false,
				success : function(data) {

					var searched_items = data.DATA;

					if(searched_items.length > 0) {

						for(var i=0; i<searched_items.length; i++) {

							var componentId = searched_items[i].COMPONENT_ID;
							var productType = searched_items[i].COMPONENT_CD;
							var component = searched_items[i].COMPONENT;
							var cnt = searched_items[i].CNT*1;

							var item = '<tr>';
							item += '<td style="width: 10%;">' + (i+1) + '</td>';


							var j;
							item +='<td style="width: 83%;">' + searched_items[i].MODEL_NAME + '</td>';
							if(_listComponentId.indexOf(componentId) < 0){
								item += '<td style="width: 7%;">'+
								  '<button id="component-add-'+productType+'-'+componentId+'" class="k-button" onclick="addDetailSpec(\'' + component+'\',\''+productType + '\',\'' + searched_items[i].MODEL_NAME +'\',' + componentId +',' + cnt+' )">담기</button>'  +
								  '<button style="display:none; background-color: #F6BDC2;" id="component-remove-'+productType+'-'+componentId+'" class="k-button searched-item"  onclick="removeSelectedItem(\'' + productType + '\',\'' + searched_items[i].MODEL_NAME +'\',' + componentId +' )">해제</button>'  +
								  '</td>';
							}else{
								item += '<td style="width: 7%;">'+
								  '<button style="display:none;" id="component-add-'+productType+'-'+componentId+'" class="k-button" onclick="addDetailSpec(\'' + component+'\',\''+productType + '\',\'' + searched_items[i].MODEL_NAME +'\',' + componentId +',' + cnt+')">담기</button>'  +
								  '<button style="background-color: #F6BDC2;" id="component-remove-'+productType+'-'+componentId+'" class="k-button searched-item" onclick="removeSelectedItem(\'' + productType + '\',\'' + searched_items[i].MODEL_NAME +'\',' + componentId +' )">해제</button>'  +
								  '</td>';
							}

							item +='<td style="display:none;">' + componentId + '</td>';
							item +='<td style="display:none;">' + component + '</td>';
							item +='<td style="display:none;">' + productType + '</td>';
							item +='<td style="display:none;">' + cnt + '</td>';

							item += '</tr>';
							$(".searched_items").append(item);
						}

						$(".no-data").hide()

						} else {
						$('.searched_items').children().remove();
						$(".no-data").show();
					}
				}
			});

		}


	</script>

</head>

<body>

	<div id="content" data-role="splitter" class="k-widget k-splitter content">

		<div class="header_title">
			<span class="pagetitle"><span class="header-title30"></span> 생산대행 - 출고 부품 선택 </span>
		</div>

		<div id="consigned_receipt_btns" class="grid_btns" style="width: 100%">
			<button id="consigned_receipt_close_btn" type="button" onclick="fnClose()" class="k-button" style="float: right;">닫기</button>
<!-- 			<button id="consigned_receipt_update_btn" type="button" onclick="fnUpdateComponent()" class="k-button" style="float: right;">수정</button> -->
			<input type="input" style="display:none;" id="PROXY_ID" name="ETC">
		</div>

		<div style="text-align: center">

			<fieldset class="fieldSet">

			<%-- 제품 정보 --%>
			<div class="info">

				<div class="sub-header-title">
					<span class="pagetitle"><span class="header-title30"></span> 출고 예정 부품 </span>
				</div>

				<table id="tbl_consigned_receipt_product_data" class="stripe table_default">
					<thead>
					<colgroup>
						<col width="15%">
						<col width="15%">
						<col width="71%">
					</colgroup>
					<tr>
						<td class="col-header-title">품목명</td>
						<td class="col-header-title">부품코드</td>
						<td class="col-header-title">모델명</td>
					</tr>
					</thead>
				</table>

				<div class="scrollable-div-long2">

					<table class="stripe table_scroll">

						<tbody>

						<tr>
							<td class="col-title-20">본체 or 케이스</td>
							<td id="selected-component-CAS" class="col-title-20-woColor">
								<div id="selected-component-cas" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-CAS">
								<div id="selected-list-cas-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">CPU</td>

							<td id="selected-component-CPU" class="col-title-20-woColor">
								<div id="selected-component-cpu" class="col-selected-product"> </div>
							</td>

							<td id="selected-list-CPU">
								<div id="selected-list-cpu-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">메인보드</td>

							<td id="selected-component-MBD" class="col-title-20-woColor">
								<div id="selected-component-mbd" class="col-selected-product">  </div>
							</td>

							<td id="selected-list-MBD">
								<div id="selected-list-mbd-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">메모리</td>

							<td id="selected-component-MEM" class="col-title-20-woColor">
								<div id="selected-component-mem" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-MEM">
								<div id="selected-list-mem-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">SSD</td>

							<td id="selected-component-SSD" class="col-title-20-woColor">
								<div id="selected-component-ssd" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-SSD">
								<div id="selected-list-ssd-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">HDD</td>
							<td id="selected-component-HDD" class="col-title-20-woColor">
								<div id="selected-component-hdd" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-HDD">
								<div id="selected-list-hdd-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">VGA</td>
							<td id="selected-component-VGA" class="col-title-20-woColor">
								<div id="selected-component-vga" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-VGA">
								<div id="selected-list-vga-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">파워</td>
							<td id="selected-component-POW" class="col-title-20-woColor">
								<div id="selected-component-pow" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-POW">
								<div id="selected-list-pow-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">키보드</td>
							<td id="selected-component-KEY" class="col-title-20-woColor">
								<div id="selected-component-key" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-KEY">
								<div id="selected-list-key-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">마우스</td>
							<td id="selected-component-MOU" class="col-title-20-woColor">
								<div id="selected-component-mou" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-MOU">
								<div id="selected-list-mou-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">무선랜카드</td>
							<td id="selected-component-WIRELESSLAN" class="col-title-20-woColor">
								<div id="selected-component-wirelesslan" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-WIRELESSLAN">
								<div id="selected-list-wirelesslan-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">OS</td>

							<td id="selected-component-OS" class="col-title-20-woColor">
								<div id="selected-component-os" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-OS">
								<div id="selected-list-os-no-data" class="col-selected-product"> 선택된 항목 없음 </div>

							</td>

						</tr>

						<tr>
							<td class="col-title-20">모니터</td>
							<td id="selected-component-MON" class="col-title-20-woColor">
								<div id="selected-component-mon" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-MON">
								<div id="selected-list-mon-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">AIR</td>
							<td id="selected-component-AIR" class="col-title-20-woColor">
								<div id="selected-component-air" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-AIR">
								<div id="selected-list-air-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						<tr>
							<td class="col-title-20">BOX</td>
							<td id="selected-component-PKG" class="col-title-20-woColor">
								<div id="selected-component-pkg" class="col-selected-product"> </div>
							</td>
							<td id="selected-list-PKG">
								<div id="selected-list-pkg-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

						</tr>

						</tbody>

					</table>

				</div>


				<div style="text-align: right; vertical-align: middle; height: 25px; padding: 3px; background-color: gray">
                        <span style="color: white; font-size: 16px; margin-right: 5px;">
                            * 총 수량: <span id="total-product-count"> 0 </span> EA
                        </span>
				</div>
			</div>

			<div id="detail_info" class="info">

				<div class="sub-header-title1">
					<span class="pagetitle"><span class="header_title30"></span> 접수/검수 부품 </span>
				</div>

				<table id="tbl_consigned_release_candidates" class="stripe table_default">

<!-- 					<thead> -->
<!-- 					<tr> -->
<!-- 						<td class="col-header-title" style="width: 10%;">#</td> -->
<!-- 						<td class="col-header-title" style="width: 25%;">제조사</td> -->
<!-- 						<td class="col-header-title" style="width: 50%;">상세 스펙</td> -->
<!-- 						<td class="col-header-title" style="width: 15%;">기능</td> -->
<!-- 					</tr> -->
<!-- 					</thead> -->

				</table>

				<div class="scrollable-div-long2">

					<table class="stripe table_scroll">
						<colgroup>
							<col width="10%" />
							<col width="25%" />
							<col width="50%" />
							<col width="15%" />
						</colgroup>
						<tbody class="searched_items">
						</tbody>
					</table>

					<div class="no-data"> 조회된 데이터가 없습니다. </div>

				</div>

			</div>
		</fieldset>

	</div>

</div>

</body>

