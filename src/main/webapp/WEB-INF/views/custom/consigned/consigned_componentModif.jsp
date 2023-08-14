<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="getConsignedComponentInfo"					value="/consigned/getConsignedComponentInfo.json" />
<c:url var="getComponentInfo"					value="/compInven/getComponentInfo.json" />
<c:url var="getConsignedPartComponentInfo"					value="/consigned/getConsignedPartComponentInfo.json" />
<c:url var="insertConsignedComponent"					value="/consigned/insertConsignedComponent.json"/>
<c:url var="deleteConsignedComponent"					value="/consigned/deleteConsignedComponent.json"/>
<c:url var="updateProxyComponentUnitDetail"						value="/consigned/updateProxyComponentUnitDetail.json"/>
<c:url var="updateComponent"					value="/consigned/updateComponent.json"/>
<c:url var="dataList"					value="/customDataList.json" />



<head>
	 <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	 <title>DANGOL365 ERP | 생산대행</title>

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
 		var _receipt = "";
 		var _companyId = -1;

		$(document).ready(function() {

			console.log("consigned_componentModif.jsp");

			totalProductCount = 0;

			var key = getParameterByName('KEY');
			_proxyId = getParameterByName(key);

			var key1 = getParameterByName('KEY1');
			_receipt = getParameterByName(key1);

			var key2 = getParameterByName('KEY2');
			_companyId = getParameterByName(key2);


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

		var url = '${getConsignedPartComponentInfo}';
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

							var componentId = consigned_items[i].COMPONENT_ID;
							var componentCd = consigned_items[i].COMPONENT_CD;
							var componentCnt = consigned_items[i].COMPONENT_CNT;
							var componentData = consigned_items[i].DETAIL_DATA;
							var consignedType = consigned_items[i].CONSIGNED_TYPE;

							if(consignedType == 1)
								addDetailSpecInit(componentCd, componentData, componentId, componentCnt)
	    				}
					}

    			}
    		}
    	});
	}



	function fnClose(){
		opener.fnInitConsignedLicence();
		opener.fnInitConsignedComponent();
		self.opener = self;
		window.close();
	}

    function fnUpdateComponent(){


    	var listComponent = new Array();
    	var inputs = $(".col-input-number-short");

		for(var i=0; i<inputs.length; i++) {
			var component = $(".col-input-number-short")[i];
			var cnt = component.value;
			var id = component.id;
			var componentId = id.substr(20);
			var vomponentCd = id.substr(16,3);

			var params = {
		    		COMPONENT_ID:componentId,
		    		COMPONENT_CD: vomponentCd,
		    		COMPONENT_CNT: cnt,
		    		DISPLAY_SEQ: i

			}

			listComponent.push(params);
		}


    	var params = {
    			PROXY_ID: _proxyId,
    			RECEIPT_NO: _receipt,
    			DATA:listComponent
    	}

   		var url = '${updateComponent}';

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
				    				opener.fnInitConsignedComponent();
				    				GochigoAlert("수정되었습니다.", true, "dangol365 ERP");

				    		}
				    	});
    			}
    		},
    		{
    			text: '닫기'
    		}],
    		minWidth : 200,
    		title: "dangol365 ERP",
    	    content: "수정하시겠습니까?"
    	}).data("kendoConfirm").open();
    	//끝지점

    }


		function addDetailSpecInit(productType, productSpec, componentId, componentCnt) {

  					var addItem =
  						'<div id="' + productType + '_'+componentId+'" class="selected-item">' +
  						'<div class="col-selected-product">' +
  						'<span class="k-icon k-i-arrow-60-right"></span>' +
  						productSpec +
  						'</div>' +
  						'<input type="number" id = "componentId-cnt-'+productType+'-'+componentId+'" class="view k-textbox col-input-number-short" value="'+componentCnt+'" min="0" max="999" onchange="fnUpdateComponentUnit('+componentId+',this.value)">' +
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

		function addDetailSpec(productType, productSpec, componentId, componentCnt) {

	    	var params = {
	    			PROXY_ID: _proxyId,
	    			COMPONENT_ID: componentId,
	    			RECEIPT: _receipt,
	    			COMPONENT_CD: productType
	    	}

	   		var url = '${insertConsignedComponent}';

	    	$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : params,
	    		async : false,
	    		success : function(data) {
	    				if(data.SUCCESS){
	    					var addItem =
	    						'<div id="' + productType + '_'+componentId+'" class="selected-item">' +
	    						'<div class="col-selected-product">' +
	    						'<span class="k-icon k-i-arrow-60-right"></span>' +
	    						productSpec +
	    						'</div>' +
	    						'<input type="number" id = "componentId-cnt-'+productType+'-'+componentId+'" class="view k-textbox col-input-number-short" value="'+componentCnt+'" min="0" max="999" onchange="fnUpdateComponentUnit('+componentId+',this.value)">' +
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
	    		}
	    	});
		}

		function removeSelectedItem(productType, productSpec, componentId) {

			var params = {
	    			PROXY_ID: _proxyId,
	    			COMPONENT_ID: componentId
	    	}

	   		var url = '${deleteConsignedComponent}';

	    	$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : params,
	    		async : false,
	    		success : function(data) {
    				if(data.SUCCESS){
						var removeItem = document.getElementById(productType+'_'+componentId);
						removeItem.remove();

						// 선택된 데이터가 있는지 체크
						var selector = "selected-list-" + productType;
						var selectedTd = document.getElementById(selector);

						if(selectedTd.childElementCount <= 1) {
							var selectorNoData = $("[id*='selected-list-" + productType.toLowerCase() + "-no-data']");
							selectorNoData.show();
						}

						countTotalProduct();

						var index = _listComponentId.indexOf(componentId);

						if(index > -1){
							_listComponentId.splice(index, 1)
							$("#component-add-"+productType+"-"+componentId).show();
							$("#component-remove-"+productType+"-"+componentId).hide();
						}
    				}
	    		}
	    	});
		}

		function fnUpdateComponentUnit(componentId, componentCnt){

	    	var params = {
	    			PROXY_ID: _proxyId,
	    			COMPONENT_ID: componentId,
	    			COMPONENT_CNT: componentCnt,
	    	}

	   		var url = '${updateProxyComponentUnitDetail}';

	    	$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : JSON.stringify(params),
	    		contentType: "application/json",
	    		async : false,
	    		success : function(data) {
	    			countTotalProduct();
				}
	    	});

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
		function searchItems(productType) {

			var url = '${getConsignedComponentInfo}';

			var params = {
					COMPONENT_CD: productType,
					COMPANY_ID: _companyId
			}

			var index = 0;

			for(var i=0; i<_CODE.length; i++)
				if(_CODE[i] == productType){
					index = i;
					break
				}

		$('#tbl_consigned_receipt_detail_data').children().remove();

		var item = '<thead><tr>';
		item += '<td class="col-header-title" style="width: 10%;">#</td>';
		var i;
		item += '<td class="col-header-title" style="width: 80%;"> 스펙</td>';

		item += '<td class="col-header-title" style="width: 10%;">기능</td>';
		item += '<td class="col-header-title" style="display:none;">' + _SELECT_COL_NAME[index][i] + '</td>';
		item += '<tr>	</thead>';

		$("#tbl_consigned_receipt_detail_data").append(item);


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
							var proxyPartId = searched_items[i].PROXY_PART_ID;

							var item = '<tr>';
							item += '<td style="width: 10%;">' + searched_items[i].NO + '</td>';


							var j;
							item +='<td style="width: 83%;">' + searched_items[i].REP_NAME + '</td>';
							if(_listComponentId.indexOf(componentId) < 0){
								item += '<td style="width: 7%;">'+
								  '<button id="component-add-'+productType+'-'+componentId+'" class="k-button" onclick="addDetailSpec(\'' + productType + '\',\'' + searched_items[i].REP_NAME +'\',' + searched_items[i].COMPONENT_ID +', 1)">담기</button>'  +
								  '<button style="display:none; background-color: #F6BDC2;" id="component-remove-'+productType+'-'+componentId+'" class="k-button searched-item"  onclick="removeSelectedItem(\'' + productType + '\',\'' + searched_items[i].REP_NAME +'\',' + searched_items[i].COMPONENT_ID +' )">해제</button>'  +
								  '</td>';
							}else{
								item += '<td style="width: 7%;">'+
								  '<button style="display:none;" id="component-add-'+productType+'-'+componentId+'" class="k-button" onclick="addDetailSpec(\'' + productType + '\',\'' + searched_items[i].REP_NAME +'\',' + searched_items[i].COMPONENT_ID +' , 1)">담기</button>'  +
								  '<button style="background-color: #F6BDC2;" id="component-remove-'+productType+'-'+componentId+'" class="k-button searched-item" onclick="removeSelectedItem(\'' + productType + '\',\'' + searched_items[i].REP_NAME +'\',' + searched_items[i].COMPONENT_ID +' )">해제</button>'  +
								  '</td>';
							}

							item +='<td style="display:none;">' + componentId + '</td>';
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
			<span class="pagetitle"><span class="header-title30"></span> 생산대행 - 주문 부품 수정 </span>
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
					<span class="pagetitle"><span class="header-title30"></span> 제품 정보 </span>
				</div>

				<table id="tbl_consigned_receipt_product_data" class="stripe table_default">
					<thead>
					<colgroup>
						<col width="15%">
						<col width="73%">
						<col width="12%">
					</colgroup>
					<tr>
						<td class="col-header-title">품목명</td>
						<td class="col-header-title">부품명</td>
						<td class="col-header-title">부품 상세</td>
					</tr>
					</thead>
				</table>

				<div class="scrollable-div-long2">

					<table class="stripe table_scroll">

						<tbody>

						<tr>
							<td class="col-title-20">모델</td>

							<td id="selected-list-MODEL">
								<div id="selected-list-model-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td style="width: 10%">
								<button id="searchBtn_model" onclick="searchItems('MODEL')" class="k-button col-search-button" data-role="button" role="button" aria-disabled="false" tabindex="1" disabled>찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">본체 or 케이스</td>

							<td id="selected-list-CAS">
								<div id="selected-list-cas-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_case" onclick="searchItems('CAS')" class="k-button col-search-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">CPU</td>

							<td id="selected-list-CPU">
								<div id="selected-list-cpu-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_cpu" onclick="searchItems('CPU')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">메인보드</td>

							<td id="selected-list-MBD">
								<div id="selected-list-mbd-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_mbd" onclick="searchItems('MBD')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">메모리</td>

							<td id="selected-list-MEM">
								<div id="selected-list-mem-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_mem" onclick="searchItems('MEM')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">SSD</td>

							<td id="selected-list-SSD">
								<div id="selected-list-ssd-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_ssd" onclick="searchItems('SSD')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">HDD</td>

							<td id="selected-list-HDD">
								<div id="selected-list-hdd-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_hdd" onclick="searchItems('HDD')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">VGA</td>

							<td id="selected-list-VGA">
								<div id="selected-list-vga-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_vga" onclick="searchItems('VGA')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">파워</td>

							<td id="selected-list-POW">
								<div id="selected-list-pow-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_pow" onclick="searchItems('POW')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">키보드</td>

							<td id="selected-list-KEY">
								<div id="selected-list-key-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_key" onclick="searchItems('KEY')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">마우스</td>

							<td id="selected-list-MOU">
								<div id="selected-list-mou-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_mou" onclick="searchItems('MOU')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">케이블</td>

							<td id="selected-list-CAB">
								<div id="selected-list-cab-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_cab" onclick="searchItems('CAB')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">기타 주변기기</td>

							<td id="selected-list-PER">
								<div id="selected-list-per-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_per" onclick="searchItems('PER')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">라이센스</td>

							<td id="selected-list-LIC">
								<div id="selected-list-lic-no-data" class="col-selected-product"> 선택된 항목 없음 </div>

							</td>

							<td>
								<button id="searchBtn_lic" onclick="searchItems('LIC')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">모니터</td>

							<td id="selected-list-MON">
								<div id="selected-list-mon-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_mnt" onclick="searchItems('MON')" class="k-button col-search-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">AIR</td>

							<td id="selected-list-AIR">
								<div id="selected-list-air-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_air" onclick="searchItems('AIR')" class="k-button col-search-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">BOX</td>

							<td id="selected-list-PKG">
								<div id="selected-list-pkg-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_box" onclick="searchItems('PKG')" class="k-button col-search-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
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

				<div class="sub-header-title">
					<span class="pagetitle"><span class="header_title30"></span> 상세 스펙 </span>
				</div>

				<table id="tbl_consigned_receipt_detail_data" class="stripe table_default">

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

