<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="getConsignedReleaseInventory"					value="/consigned/getConsignedReleaseInventory.json" />
<c:url var="addConsignedReleaseInventory"					value="/consigned/addConsignedReleaseInventory.json" />
<c:url var="deleteConsignedReleaseInventory"					value="/consigned/deleteConsignedReleaseInventory.json" />
<c:url var="updateComponent"										value="/consigned/updateComponent.json"/>
<c:url var="updateConsignedInventoryType"					value="/consigned/updateConsignedInventoryType.json"/>

<c:url var="dataList"					value="/customDataList.json" />




<head>
	 <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	 <title>DANGOL365 ERP | 생산대행</title>

 	<link rel="stylesheet" type="text/css" href="/codebase/css/custom_style.css"/>

	<script src="/codebase/gochigo.kendo.ui.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>


<style>
	.k-icon {cursor: pointer;}
</style>

	<script type="text/javascript">

		var _proxyId;
		var _componentId;
		var _consignedType;
		var _companyId;
		var _isChange = false;

		var _listInventory = new Array();

		$(document).ready(function() {

			console.log("consigned_componentModif.jsp");

			totalProductCount = 0;

			var key = getParameterByName('KEY');
			_proxyId = getParameterByName(key);

			var key1 = getParameterByName('KEY1');
			_componentId = getParameterByName(key1);

			var key2 = getParameterByName('KEY2');
			_consignedType = getParameterByName(key2);

			var key3 = getParameterByName('KEY3');
			_companyId = getParameterByName(key3);



			fnInitConsignedReleaseInventory();

		});


    function fnInitConsignedReleaseInventory() {
		console.log("fnInitConsignedReleaseInventory() Load");

		var url = '${getConsignedReleaseInventory}';
		var params = {
    			PROXY_ID: _proxyId,
    			COMPONENT_ID: _componentId,
    			CONSIGNED_TYPE: _consignedType
    	};

		$.ajax({
    		url : url,
    		type : "POST",
    		data : params,
    		async : false,
    		success : function(data) {

    			if(data.SUCCESS){

					var consigned_items = data.DATA;
					$(".consigned_items").empty();
					if(consigned_items.length > 0) {

						for(var i=0; i<consigned_items.length; i++) {

							var inventoryId = consigned_items[i].INVENTORY_ID;
							var barcode = consigned_items[i].BARCODE;
							var consignedType = consigned_items[i].CONSIGNED_TYPE * 1;

							if(_listInventory.indexOf(inventoryId) < 0){
								_listInventory.push(inventoryId);
							}

							var consignedCheck = "unchecked";
							var ltCheck = "unchecked";

							if(consignedType == 1)
								consignedCheck = "checked";
							else
								 ltCheck = "checked";


							var color;

							if(i%2 == 1) color = "#E6E6E6";
							else color = "#FFFFFF"


							var item = '<tr>';

							item +='<td style="display:none;">'+inventoryId+'</td>';
							item +='<td style="display:none;">'+barcode+'</td>';

							item +='<td  class="col-title-center" style="background-color:'+color+';">'+(i+1)+'</td>';
							item +='<td  id = "inventory-'+inventoryId+'-'+barcode+'" class="col-title-left" style="background-color:'+color+';">'+barcode+'</td>';

							item +='<td ><input type="checkbox" onclick="fnChangeReceiptStatus(1, '+inventoryId+');" id="checkConsignedomponent_'+inventoryId+'"' +consignedCheck+'></td>';
							item +='<td ><input type="checkbox" onclick="fnChangeReceiptStatus(2, '+inventoryId+');" id="checkComponent_'+inventoryId+'" ' +ltCheck+'></td>';

							item += '</tr>';
							$(".consigned_items").append(item);
						}

					}

					$("#numOfInventory").text("합계: "+consigned_items.length+" EA");

    			}
    		}
    	});
	}

    function fnChangeReceiptStatus(type, inventory)
    {
    	if(type == 1){
	    	var consignedCheckBox = $("[id*='checkConsignedomponent_" + inventory +"']");
	    	var LTCheckBox = $("[id*='checkComponent_" + inventory +"']");

			var checked = consignedCheckBox.is(":checked");

			if(checked)
				LTCheckBox.prop("checked", false);
			else
				LTCheckBox.prop("checked", true);

    	}else if(type == 2){
	    	var consignedCheckBox = $("[id*='checkConsignedomponent_" + inventory +"']");
	    	var LTCheckBox = $("[id*='checkComponent_" + inventory +"']");

			var checked = LTCheckBox.is(":checked");

			if(checked)
				consignedCheckBox.prop("checked", false);
			else
				consignedCheckBox.prop("checked", true);

    	}

    }



	function fnClose(){

		self.opener = self;
		window.close();
	}

    function fnUpdate(){


    	var listConsignedType = new Array();

    	for(var i = 0 ; i <_listInventory.length; i++){

    		var inventoryId = _listInventory[i];
    		var consignedType = 1;

    		var consignedCheckBox = $("[id*='checkConsignedomponent_" + inventoryId +"']");
    		var checked = consignedCheckBox.is(":checked");

    		if(checked)
    			consignedType = 1;
    		else
    			consignedType = 2;

    		var params = {
					PROXY_ID: _proxyId,
					INVENTORY_ID: inventoryId,
					CONSIGNED_TYPE: consignedType
	    	};


    		listConsignedType.push(params);

    	}

    	var url = '${updateConsignedInventoryType}';


    	var params = {
				PROXY_ID: _proxyId,
				CONSIGNED_DATA: listConsignedType
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
				    		data : JSON.stringify(params),
				    		contentType: "application/json",
				    		async : false,
				    		success : function(data) {

				    			if(data.SUCCESS){
				    				GochigoAlert("수정되었습니다", false, "dangol365 ERP");
				    				opener.fnInitConsignedReleaseData();
				    			}
				    		}
				    	});
    			}
    		},
    		{
    			text: '닫기'
    		}],
    		minWidth : 200,
    		title: "dangol365 ERP",
    	    content: "부품 타입을 수정하시겠습니까?"
    	}).data("kendoConfirm").open();
    	//끝지점

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

	<div id="content" data-role="splitter" class="k-widget k-splitter content">

		<div class="header_title">
			<span class="pagetitle"><span class="header-title30"></span> 생산대행 - 출고 부품 타입 수정</span>
		</div>

		<div id="consigned_receipt_btns" class="grid_btns" style="width: 100%">
			<button id="consigned_invnetory_close_btn" type="button" onclick="fnClose()" class="k-button" style="float: right;">닫기</button>
			<button id="consigned_inventory_save_btn" type="button" onclick="fnUpdate()" class="k-button" style="float: right;">수정</button>
		</div>

		<div style="text-align: center">

<!-- 			<fieldset class="fieldSet"> -->

			<%-- 제품 정보 --%>
			<div >

				<table id="tbl_consigned_release_data" class="stripe table_default">

					<colgroup>
						<col width="5%">
						<col width="20%">
						<col width="10%">
						<col width="12%">
					</colgroup>

					<thead>
						<tr>
							<td class="col-header-title">No</td>
							<td class="col-header-title">관리번호</td>
							<td class="col-header-title" >생산대행 재고</td>
							<td class="col-header-title" style="color:#F5A9A9;">리더스텍 재고</td>
						</tr>
					</thead>
				</table>

				<div class="scrollable-div">

					<table  id="tbl_consigned_inventory_data" class="stripe table_scroll">

						<colgroup>
						<col width="5%">
						<col width="20%">
						<col width="10%">
						<col width="10%">
						</colgroup>

						<tbody class="consigned_items">
						</tbody>

					</table>

				</div>
			</div>

	</div>

</div>

</body>

