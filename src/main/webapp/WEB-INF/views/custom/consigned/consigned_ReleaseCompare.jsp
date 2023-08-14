<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<c:url var="getConsignedInfo"					value="/consigned/getConsignedInfo.json" />
<c:url var="companyDelete"					value="/user/companyDelete.json" />
<c:url var="companyInsert"						value="/user/companyInsert.json" />
<c:url var="getConsignedReleaseComponentList"			value="/consigned/getConsignedReleaseComponentList.json" />
<c:url var="setCountCheck"					value="/consigned/setCountCheck.json" />
<c:url var="getCountCheck"					value="/consigned/getCountCheck.json" />

<c:url var="getSelectedReleaseComponent"						value="/consigned/getSelectedReleaseComponent.json" />
<c:url var="SelectReleaseComponent"					value="/consigned/SelectReleaseComponent.json" />
<c:url var="deleteSelectedReleaseComponent"				value="/consigned/deleteSelectedReleaseComponent.json"/>

<c:url var="saveConsignedWarehousing"				value="/consigned/saveConsignedWarehousing.json"/>
<c:url var="asignConsignedReleaseInventory"				value="/consigned/asignConsignedReleaseInventory.json"/>
<c:url var="asignConsignedReleaseInventoryMBD"				value="/consigned/asignConsignedReleaseInventoryMBD.json"/>

<c:url var="getInventoryReleaseCnt"				value="/consigned/getInventoryReleaseCnt.json"/>

<c:url var="executeQuery"						value="/common/executeQuery.json"/>
<c:url var="consignedProcess"				value="layoutCustom.do" />
<c:url var="consignedPopup"					value="/CustomP.do"/>


<c:url var="dataList"					value="/customDataList.json" />


<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	<title>DANGOL365 ERP | 출고 부품 확인</title>

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

			var key3 = getParameterByName('KEY3');
			_countCheck = getParameterByName(key3);



			fnInitConsignedData();

			setTableRowClickEvent();
			setReleaseTableRowClickEvent();

// 			getCountCheck();

			fnInitSelectedConponent();

			setTooltipOnIcon($("[id*='btnInsertInventory"), "부품 추가");
			setTooltipOnIcon($("[id*='btnExtractReleaseInventory"), "부품 삭제");
// 			setTooltipOnIcon($("[id*='btnInsertInventoryChangeType"), "부품타입변경");

		});


		function setTooltipOnIcon(variable, context){

			var tooltipText = context;

			variable.kendoTooltip({
 				content: tooltipText,
				callout: false
			});
		}


// 		function getCountCheck(){

// 			var url = '${getCountCheck}';
// 			var params = {
// 					PROXY_ID: _proxyId
// 	    	};

// 			$.ajax({
// 	    		url : url,
// 	    		type : "POST",
// 	    		data : params,
// 	    		async : false,
// 	    		success : function(data) {

// 	    			if(data.SUCCESS){
// 	    				_countCheck = data.COUNT_CHECK*1;

// 	    				if(_countCheck == 0){
// 	    					$("[id*='checkReleaseR").prop("checked", true);
// 	    					$("[id*='checkReleaseL").prop("checked", false);
// 	    				}else if(_countCheck == 1){
// 	    					$("[id*='checkReleaseL").prop("checked", true);
// 	    					$("[id*='checkReleaseR").prop("checked", false);
// 	    				}else{
// 	    					$("[id*='checkReleaseL").prop("checked", true);
// 	    					$("[id*='checkReleaseR").prop("checked", true);
// 	    				}
// 	    			}

// 	    		}
// 	    	});
// 		}

		function fnChangeCountCheck(type){

			var value = -1;


			var checkBox = $("[id*='checkReleaseL']");
			var checkedL = checkBox.is(":checked");

			checkBox = $("[id*='checkReleaseR']");
			var checkedR = checkBox.is(":checked");

			checkBox = $("[id*='checkRelease"+type+"]");
			var checked = checkBox.is(":checked");


			if(checkedL && checkedR)
				value = 2;
			else if (!checkedL && !checkedR){

				if(type == 'R')
					value = 1;
				else if(type == 'L')
					value = 0;
			}else{

				if(checkedL && !checkedR)
					value = 1;
				else if (!checkedL && checkedR)
					value = 0;
			}

			if(value == -1)
				return;

			var url = '${setCountCheck}';

			var params = {
					PROXY_ID: _proxyId,
					COUNT_CHECK: value
	    	};

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

					    			GochigoAlert(data.MSG, false, "dangol365 ERP");

					    			if(data.SUCCESS){
					    				opener.setCountCheck(value);

					    				if(value == 0){
					    					$("[id*='checkReleaseR").prop("checked", true);
					    					$("[id*='checkReleaseL").prop("checked", false);
					    				}else if (value == 1){
					    					$("[id*='checkReleaseL").prop("checked", true);
					    					$("[id*='checkReleaseR").prop("checked", false);
					    				}

					    				_countCheck = value;

					    			}

					    		}
					    	});
	    			}
	    		},
	    		{
	    			text: '취소',

	    		}],
	    		minWidth : 200,
	    		title: "dangol365 ERP",
	    	    content: "생산대행 재고관리를 선택하신 타입으로 설정하시겠습니까?"
	    	}).data("kendoConfirm").open();
	    	//끝지점


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



		function setReleaseTableRowClickEvent() {
			$("#tbl_consigned_release_data tr").click(function() {

				_selectedReleaseRow = $(this).children();

				var rowIdx = _selectedReleaseRow.closest("tr").prevAll().length;

				for(var i = 0; i < _componentReleaseCnt; i++) {

					var checkBox = $("[id*='checkReleaseComponent_" + i +"']");

					if(i == rowIdx)
						checkBox.prop("checked", true);
					else
						checkBox.prop("checked", false);
				}
			});
		}

		 function getParameterByName(name) {
				name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
				var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
						results = regex.exec(location.search);
				return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
			}


		function fnInsertInventory(){

			if(_selectedRow == null){GochigoAlert("선택된 부품이 없습니다.", false, "dangol365 ERP"); return;}

			var proxyPartId = _selectedRow.eq(0).text();
			var componentId = _selectedRow.eq(1).text();
			var consignedType = _selectedRow.eq(2).text()*1;
			var params = "";
			if(consignedType ==1)
				params = "&PROXY_ID="+_proxyId+"&PROXY_PART_ID="+proxyPartId+"&COMPANY_ID="+_companyId+"&CUSTOMKEY=B.COMPONENT_ID,B.COMPANY_ID,INVENTORY_TYPE,USE_RANGE&CUSTOMVALUE="+componentId+","+_companyId+",C,1";
			else if(consignedType ==2)
				params = "&PROXY_ID="+_proxyId+"&PROXY_PART_ID="+proxyPartId+"&COMPANY_ID="+_companyId+"&CUSTOMKEY=B.COMPONENT_ID,INVENTORY_TYPE&CUSTOMVALUE="+componentId+",N";
			else{GochigoAlert("오류가 발생했습니다. 관리자에게 문의하세요.", false, "dangol365 ERP"); return;}

			fnWindowOpen_LTComponent("/layoutNewList.do?xn=inventory_List_LAYOUT"+params,"inventory_id","selectConsignedComponent","UW");

		}

		function fnExtractReleaseInventory(){

			if(_selectedReleaseRow == null){GochigoAlert("선택된 출고 예정 부품이 없습니다..", false, "dangol365 ERP"); return;}

			var url = '${deleteSelectedReleaseComponent}';

			var params = {
					PROXY_RELEASE_PART_ID: _selectedReleaseRow.eq(0).text(),
					PROXY_PART_ID: _selectedReleaseRow.eq(1).text(),
					COMPONENT_ID: _selectedReleaseRow.eq(2).text(),
					INVENTORY_ID: _selectedReleaseRow.eq(3).text()
			}

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

					    			GochigoAlert(data.MSG, false, "dangol365 ERP");

					    			if(data.SUCCESS){
					    				fnInitConsignedReleaseData();
										setConsignedInventoryCnt();
					    			}
					    		}
					    	});
	    			}
	    		},
	    		{
	    			text: '취소',

	    		}],
	    		minWidth : 200,
	    		title: "dangol365 ERP",
	    	    content: "선택하신 부품 삭제하시겠습니까?"
	    	}).data("kendoConfirm").open();
	    	//끝지점

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

		function fnSearchWarehousing(proxyPartId, consignedType){

			var params = "";

			if(consignedType ==1)
				params = "&PROXY_ID="+_proxyId+"&PROXY_PART_ID="+proxyPartId+"&COMPANY_ID="+_companyId+"&CUSTOMKEY=WAREHOUSING_TYPE,COMPANY_ID&CUSTOMVALUE=2,"+_companyId;
			else if(consignedType ==2)
				params = "&PROXY_ID="+_proxyId+"&PROXY_PART_ID="+proxyPartId+"&COMPANY_ID="+_companyId+"&CUSTOMKEY=WAREHOUSING_TYPE&CUSTOMVALUE=1";
			else{GochigoAlert("오류가 발생했습니다. 관리자에게 문의하세요.", false, "dangol365 ERP"); return;}

			fnWindowOpen_LTComponent("/layoutNewList.do?xn=warehousing_List_LAYOUT"+params,"component_id","selectConsignedComponent","UW");
		}

		function fnSaveWarehousing(proxyPartId){

			console.log("CompanyList.fnSaveWarehousing() Load");

			var url = '${saveConsignedWarehousing}';

			var warehousing = $('#warehousing_'+proxyPartId).val();

// 			if(warehousing == ''){
// 				GochigoAlert('입고번호를 입력하세요.'); return;
// 			}
			if(warehousing.length != 10 && warehousing.length > 0){
				GochigoAlert('입고번호를 확인하세요.'); return;
			}

			var params = {
					PROXY_PART_ID: proxyPartId,
	    			WAREHOUSING: warehousing
	    	};

			if(warehousing == ''){
				params.WAREHOUSING = -1;
			}


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
							data : JSON.stringify(params),
				    		contentType: "application/json",
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
					text: '닫기'
				}],
				minWidth : 200,
				title: fnGetSystemName(),
			    content: "입고번호를 저장하시겠습니까?"
			}).data("kendoConfirm").open();

		}

		function fnAsignWarehousing(proxyPartId, componentId, consignedType, componentCd){
			console.log("CompanyList.fnAsignWarehousing() Load");

			var url = '${asignConsignedReleaseInventory}';

			var params = {
					PROXY_PART_ID: proxyPartId,
					COMPANY_ID: _companyId,
					COMPONENT_ID: componentId,
					CONSIGNED_TYPE: consignedType,
					CONSIGNED_CD: componentCd
	    	};

			if(componentCd == 'MBD')
				url ='${asignConsignedReleaseInventoryMBD}';


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
							data : JSON.stringify(params),
				    		contentType: "application/json",
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
		var totalCnt = 0;
		var totalReleaseCnt = 0;

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

				var componentCnt = consigned_items[i].COMPONENT_CNT;
				var inventoryCnt = consigned_items[i].INVENTORY_CNT;
				var releaseCnt = consigned_items[i].RELEASE_CNT;
				var alsignYn = releaseCnt == 1? 'O':'X';

				totalCnt += (componentCnt *1) ;
				totalReleaseCnt += (releaseCnt *1) ;

				var consignedType = consigned_items[i].CONSIGNED_TYPE;

				var proxyPartId = consigned_items[i].PROXY_PART_ID;

				if(consignedType == 2)
					fontColor = 'RED';
				else
					fontColor = 'BLACK';

				var checkId = "checkSelectReleaseComponentL_"+consigned_items[i].COMPONENT_ID+"_"+consignedType;


				var btnSearch = '<button id="warehousing_search_btn" type="button" onclick="fnSearchWarehousing('+proxyPartId+','+consignedType+')" class="k-button">찾기</button>';
				var btnSave = '<button id="warehousing_save_btn" type="button" onclick="fnSaveWarehousing('+proxyPartId+')" class="k-button">저장</button>';
				var btnAsign = '<button id="inventory_asign_btn" type="button" onclick="fnAsignWarehousing('+proxyPartId+','+componentId+','+consignedType+',\''+componentCd+'\')" class="k-button">부품할당</button>';


				var item = '<tr>';
				item +='<td style="display:none;">'+proxyPartId+'</td>';
				item +='<td style="display:none;">'+componentId+'</td>';
				item +='<td style="display:none;">'+consignedType+'</td>';


				item +='<td ><input type="checkbox" id="checkComponent_'+i+'" unchecked></td>';
				item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+';">'+componentCd+'</td>';
				item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+'; background-color:'+color+';">'+consigned_items[i].COMPONENT+'</td>';
				item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+';">'+consigned_items[i].DETAIL_DATA+'</td>';
				item +='<td  style="color:'+fontColor+'; background-color:'+color+';" align="center"><label for="inventory_cnt_'+proxyPartId+'">'+inventoryCnt+'</label></td>';
// 				item +='<td  style="color:'+fontColor+'; background-color:'+color+';" align="center">'+componentCnt+'</td>';
				item +='<td  style="color:'+fontColor+'; background-color:'+color+';" align="center"><label for="release_cnt_'+proxyPartId+'">'+alsignYn+'</label></td>';
				item +='<td><input type="input" id = "warehousing_'+proxyPartId+'" class="view k-textbox col-input" style="width: 100%;" value="'+ consigned_items[i].WAREHOUSING +'"></td>';
				item +='<td>' + btnSearch + btnSave + btnAsign +'</td>';
				item += '</tr>';
				$(".consigned_items").append(item);
			}

		}

		$("#numOfComponent").text("TOTAL: "+consigned_items.length+" EA");
		$("#numOfInventory").text("합계: "+totalCnt+" EA");
		$("#numOfReleaseInventory").text("합계: "+totalReleaseCnt+" EA");

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

				var color;

				var fontColor;

				if(i%2 == 1) color = "#E6E6E6";
				else color = "#FFFFFF"

				var componentCnt = consigned_release_items[i].COMPONENT_CNT;

				totalCnt += (componentCnt *1) ;

				var consignedType = consigned_release_items[i].CONSIGNED_TYPE;

				if(consignedType == 2)
					fontColor = 'RED';
				else
					fontColor = 'BLACK';

				var checkId = "checkSelectReleaseComponentR_"+consigned_release_items[i].COMPONENT_ID+"_"+consigned_release_items[i].CONSIGNED_TYPE;


				var item = '<tr>';

				item +='<td style="display:none;">'+consigned_release_items[i].PROXY_RELEASE_PART_ID+'</td>';
				item +='<td style="display:none;">'+consigned_release_items[i].PROXY_PART_ID+'</td>';
				item +='<td style="display:none;">'+consigned_release_items[i].COMPONENT_ID+'</td>';
				item +='<td style="display:none;">'+consigned_release_items[i].INVENTORY_ID+'</td>';

				item +='<td ><input type="checkbox" id="checkReleaseComponent_'+i+'" unchecked></td>';
				item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+'; background-color:'+color+'; text-align:center;">'+consigned_release_items[i].WAREHOUSING+'</td>';
				item +='<td  class="col-title-left" style="color:'+fontColor+'; background-color:'+color+'; background-color:'+color+'; text-align:center;">'+consigned_release_items[i].BARCODE+'</td>';
				item += '</tr>';
				$(".consigned_release_items").append(item);
			}

		}

		$("#numOfReleaseComponent").text("TOTAL: "+consigned_release_items.length+" EA");
// 		$("#numOfReleaseInventory").text("합계: "+totalCnt+" EA");

		setReleaseTableRowClickEvent();

	}

	function setConsignedInventoryCnt(){

		var url = '${getInventoryReleaseCnt}';

		var totalReleaseCnt = 0;
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
					var inventoryCnt_items = data.DATA;
					for(var i=0; i<inventoryCnt_items.length; i++) {
						var proxyPartId = inventoryCnt_items[i].PROXY_PART_ID;
						var inventoryCnt = inventoryCnt_items[i].INVENTORY_CNT;
						var releaseCnt = inventoryCnt_items[i].RELEASE_CNT *1;
						var releaseYn = releaseCnt == 1?'O':'X';

						totalReleaseCnt += releaseCnt;

						$("label[for='inventory_cnt_"+proxyPartId+"']").text(inventoryCnt);
						$("label[for='release_cnt_"+proxyPartId+"']").text(releaseYn);
					}

					$("#numOfReleaseInventory").text("합계: "+totalReleaseCnt+" EA");
				}
				else{
					GochigoAlert(data.MSG);
				}
			}
		});
	}

	function fnUpdateComponentUnit(componentId, componentCnt, consignedType){

    	var params = {
    			PROXY_ID: _proxyId,
    			COMPONENT_ID: componentId,
    			COMPONENT_CNT: componentCnt,
    			CONSIGNED_TYPE: consignedType
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


	function numberWithCommas(componentId, x, consignedType) {
		fnUpdateComponentUnit(componentId, x, consignedType);


		computeCnt();

	}

	function computeCnt(){
		var totalCnt = 0;
		var inputs = $(".col-input-number");
		for(var i=0; i<inputs.length; i++) {
			var component = $(".col-input-number")[i];
			var cnt = component.value * 1;
			totalCnt += cnt;
		}

		$("#numOfInventory").text("합계: "+totalCnt+" EA");
	}

	function fnClose(){
		opener.fnInitConsignedLicence();
		opener.fnInitConsignedComponent();

		self.opener = self;
		window.close();
	}

	function fnSelectReleaseComponent(){

		var url = '${consignedPopup}';

		var query = "?content=selectReleaseComponent&KEY=PROXY_ID&PROXY_ID="+_proxyId;

		var width, height;

		width = "1600";
    	height = "800";

		var xPos  = (document.body.clientWidth /2) - (width / 2);
	    xPos += window.screenLeft;
	    var yPos  = (screen.availHeight / 2) - (height / 2);

	    window.open("<c:url value='"+url+query+"'/>", "SelectReleaseComponent", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
	}

	function fnCompareSelectReleaseComponent(checkId, position, componentId, consignedType, componentCnt){

		console.log("consigned_releaseCompare.fnCompareSelectReleaseComponent() Load");

		var checkBox = $("[id*='"+checkId+"']");

		if(consignedType == 2){
			checkBox.prop("checked", false);
			GochigoAlert("자사재고 품목은 출고품목으로 선택할 수 없습니다(자동 출고).", false, "dangol365 ERP");

		}

		var checked = checkBox.is(":checked");

		if(checked){
			var selectPostion = position == 'L'?0:1;
			var params = {
					PROXY_ID: _proxyId,
		    		COMPONENT_ID: componentId,
		    		COMPONENT_CNT: componentCnt,
		    		MAX_VALUE: componentCnt,
		    		SELECT_POSITION: selectPostion

			}

	   		var url = '${SelectReleaseComponent}';

			$.ajax({
	    		url : url,
	    		type : "POST",
	    		data : JSON.stringify(params),
	    		contentType: "application/json",
	    		async : false,
	    		success : function(data) {


	    			if(_listSelectedComponentId.indexOf(componentId) < 0){
	    				_listSelectedComponentId.push(componentId);
	    			}else{
	    				var otherCheckId = "";

						if(selectPostion == 0){
							otherCheckId = "checkSelectReleaseComponentR_"+componentId+"_1";
						}
						else{
							otherCheckId = "checkSelectReleaseComponentL_"+componentId+"_1";
						}
						var checkBox = $("[id*='"+otherCheckId+"']");
						checkBox.prop("checked", false);
	    			}
	    		}
	    	});


		}else{

			var selectPostion = position == 'L'?0:1;
			var params = {
					PROXY_ID: _proxyId,
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


	    			var index = _listSelectedComponentId.indexOf(componentId);

	    			if(index > -1){
	    				_listSelectedComponentId.splice(index, 1);
	    			}

	    		}
	    	});


		}


			console.log("box.checked = "+checked);

	}

	 function fnInitSelectedConponent() {
			console.log("consigned_releaseCompare.fnInitSelectedConponent() Load");

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

						if(consigned_items.length > 0) {
		    				for(var i=0; i<consigned_items.length; i++) {

								var componentId = consigned_items[i].COMPONENT_ID;
								var selectPosition = consigned_items[i].SELECT_POSITION * 1;

								_listSelectedComponentId.push(componentId);
								var checkId = "";
								if(selectPosition == 0)
									checkId = "checkSelectReleaseComponentL_"+componentId+"_1";
								else
									checkId = "checkSelectReleaseComponentR_"+componentId+"_1";

								var checkBox = $("[id*='"+checkId+"']");

								checkBox.prop("checked", true);

		    				}
						}

	    			}
	    		}
	    	});
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
			<span class="pagetitle"><span class="header-title30"></span> 생산대행 - 출고 부품 확인 </span>
		</div>

		<div id="consigned_receipt_btns" class="grid_btns_short" style="width: 100%">
			<button id="consigned_close_btn" type="button" onclick="fnClose()" class="k-button" style="float: right; margin:5px 5px 5px 5px;">닫기</button>
<!-- 			<button id="consigned_component_list_btn" type="button" onclick="fnSelectReleaseComponent()" class="k-button" style="float: right; margin:5px 5px 5px 5px;">출고부품상세보기</button> -->
		</div>

		<div style="padding: 0px;">

			<fieldset class="fieldSet">

			<%-- 제품 정보 --%>
			<div class="info70">

				<div class="sub-header-title">
					<span class="pagetitle">


<!-- 						<input type="checkbox" id="checkReleaseL" onclick="fnChangeCountCheck('L')" style="float: left; margin:5px 3px 3px 3px ;"> -->
<!-- 						<span class="header-title30" style="float: left;">  출고체크 </span> -->

						<span class="header-title30">  접수 부품 정보 </span>

							<button id="btnInsertInventory" onclick="fnInsertInventory()" class="k-button" style="float: right; width: 30px; height: 20px; background-color: slategray; margin:3px 5px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;">
								<span class="k-icon k-i-plus-circle" style="float: right; font-size: 15px; color: white;"></span>
							</button>
					</span>
					</div>

				<table id="tbl_consigned_receipt_product_data" class="stripe table_default">

					<colgroup>
						<col width=4%">
						<col width="6%">
						<col width="9%">
						<col width="36%">
						<col width="6.5%">
<%-- 						<col width="6.5%"> --%>
						<col width="6.5%">
						<col width="12%">
						<col width="20%">
					</colgroup>

					<thead>
						<tr>
							<td class="col-header-title"></td>
							<td class="col-header-title">품목명</td>
							<td class="col-header-title">부품코드</td>
							<td class="col-header-title">부품명</td>
							<td class="col-header-title">재고수량</td>
<!-- 							<td class="col-header-title">접수수량</td> -->
							<td class="col-header-title">할당여부</td>
							<td class="col-header-title">입고번호</td>
							<td class="col-header-title"></td>
						</tr>
					</thead>
				</table>

				<div class="scrollable-div-long">

					<table  id="tbl_consigned_component_data" class="stripe table_scroll">

					<colgroup>
						<col width=4%">
						<col width="6%">
						<col width="9%">
						<col width="36%">
						<col width="6.5%">
<%-- 						<col width="6.5%"> --%>
						<col width="6.5%">
						<col width="12%">
						<col width="18%">

						</colgroup>

						<tbody class="consigned_items">
						</tbody>

					</table>

				</div>


				<div style="vertical-align: middle; height: 30px; padding: 0px; background-color: lightgray; margin: 0px 0px 2px 0px;">

					<table class="table_default">

						<colgroup>
							<col width="55.5%">
							<col width="6%">
							<col width="6.5%">
							<col width="32%">

						</colgroup>

						<tbody>
							<tr class="col-header-title">
								<td ><label id="numOfComponent">TOTAL: 0 EA</label></td>
								<td ></td>
<!-- 								<td ><label id="numOfInventory">합계: 0 EA</label></td> -->
								<td ><label id="numOfReleaseInventory">합계: 0 EA</label></td>
								<td ></td>
							</tr>
						</tbody>

					</table>
				</div>
			</div>


			<%-- 제품 정보 --%>
			<div class="info30">

				<div class="sub-header-title1">
					<span class="pagetitle">

<!-- 					<input type="checkbox" id="checkReleaseR" onclick="fnChangeCountCheck('R')" style="float: left; margin:5px 3px 3px 3px ;"> -->
<!-- 						<span class="header-title30" style="float: left;">  출고체크 </span> -->

						<span class="header-title30">  출고 예정 부품 정보 </span>


							<button id="btnExtractReleaseInventory" onclick="fnExtractReleaseInventory()" class="k-button" style="float: right; width: 30px; height: 20px; background-color: slategray; margin:3px 5px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;">
								<span class="k-icon k-i-minus-circle" style="float: right; font-size: 15px; color: white;"></span>
							</button>

<!-- 							<button id="btnInsertInventoryChangeType" onclick="fnInsertInventoryChangeType()" class="k-button" style="float: right; width: 30px; height: 20px; background-color: slategray; margin:3px 5px 0px 0px ; padding: 0px 7px 0px 7px; font-size: 10px;"> -->
<!-- 								<span class="k-icon k-i-gear" style="float: right; font-size: 15px; color: white;"></span> -->
<!-- 							</button> -->
					</span>
					</div>

				<table id="tbl_consigned_release_data_header" class="stripe table_default">

					<colgroup>
						<col width= "10%">
						<col width= "45%">
						<col width= "45%">
					</colgroup>

					<thead>
						<tr>
							<td class="col-header-title1"></td>
							<td class="col-header-title1">입고번호</td>
							<td class="col-header-title1">재고번호</td>
						</tr>
					</thead>
				</table>

				<div class="scrollable-div-long">

					<table  id="tbl_consigned_release_data" class="stripe table_scroll">

						<colgroup>
							<col width="10%">
							<col width="45%">
							<col width="43%">

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

