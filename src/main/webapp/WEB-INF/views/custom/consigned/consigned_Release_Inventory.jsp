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

							if(_listInventory.indexOf(inventoryId) < 0){
								_listInventory.push(inventoryId);
							}

							var color;

							if(i%2 == 1) color = "#E6E6E6";
							else color = "#FFFFFF"


							var item = '<tr>';

							item +='<td style="display:none;">'+inventoryId+'</td>';
							item +='<td style="display:none;">'+barcode+'</td>';

							item +='<td  class="col-title-center" style="background-color:'+color+';">'+(i+1)+'</td>';
							item +='<td  id = "inventory-'+inventoryId+'-'+barcode+'" class="col-title-left" style="background-color:'+color+';">'+barcode+'</td>';

							item += '<td><span class="k-icon k-i-close" onclick="removeSelectedItem('+inventoryId+')"><span></td>';

							item += '</tr>';
							$(".consigned_items").append(item);
						}

					}

					$("#numOfInventory").text("합계: "+consigned_items.length+" EA");

    			}
    		}
    	});
	}



	function fnClose(){

		if(_isChange)
			opener.fnInitConsignedReleaseData();

		self.opener = self;
		window.close();
	}

    function fnAddInventory(){

	var barcode = $("#barcode_info").val().trim();

	if(barcode == ""){GochigoAlert("관리번호를 입력해 주세요.", false, "dangol365 ERP"); return;}

	if(barcode.length != 12){GochigoAlert("관리번호 양식이 아닙니다(자리수).", false, "dangol365 ERP"); return;}

			var params = {
					BARCODE: barcode,
		    		PROXY_ID: _proxyId,
		    		CONSIGNED_TYPE: _consignedType,
		    		COMPONENT_ID:_componentId,
		    		COMPANY_ID:_companyId
			}


   		var url = '${addConsignedReleaseInventory}';

//    		$("<div></div>").kendoConfirm({
//     		buttonLayout: "stretched",
//     		actions: [{
//     			text: '확인',
//     			action: function(e){
//     				//시작지점
				    	$.ajax({
				    		url : url,
				    		type : "POST",
				    		data : params,
				    		async : false,
				    		success : function(data) {

				    			GochigoAlert(data.MSG, false, "dangol365 ERP");

				    			if(data.SUCCESS){
				    				fnInitConsignedReleaseInventory();
				    				_isChange = true;
				    			}
				    		}
				    	});
//     			}
//     		},
//     		{
//     			text: '닫기'
//     		}],
//     		minWidth : 200,
//     		title: "dangol365 ERP",
//     	    content: "수정하시겠습니까?"
//     	}).data("kendoConfirm").open();
//     	//끝지점

    }

    function fnAddInventoryExternal(barcode){

    	var params = {
    			BARCODE: barcode,
        		PROXY_ID: _proxyId,
        		CONSIGNED_TYPE: _consignedType,
        		COMPONENT_ID:_componentId,
        		COMPANY_ID:_companyId
    	}

       	var url = '${addConsignedReleaseInventory}';

    	$.ajax({
    		url : url,
    		type : "POST",
    		data : params,
    		async : false,
    		success : function(data) {

    			if(!data.SUCCESS){
    				GochigoAlert(data.MSG, false, "dangol365 ERP");
    			}

    			_isChange = true;
    		}
    	});


        }

    function fnComponentList(){

    	var url = "&CUSTOMKEY=COMPANY_ID,COMPONENT_ID,INVENTORY_STATE,INVENTORY_TYPE,LOCK_YN&CUSTOMVALUE="+_companyId+","+_componentId+",E,C,N";
    	fnWindowOpen("/layoutNewList.do?xn=consigned_Select_Part_LAYOUT"+url,"component_id", "S");
    }

    function fnLTComponentList(){

    	var url = "&CUSTOMKEY=COMPONENT_ID,INVENTORY_STATE,INVENTORY_TYPE,LOCK_YN&CUSTOMVALUE="+_componentId+",E,N,N";
    	fnWindowOpen("/layoutNewList.do?xn=LT_Select_Part_LAYOUT"+url,"component_id", "M");
    }

    function removeSelectedItem(inventoryId){

			var params = {
					PROXY_ID: _proxyId,
					INVENTORY_ID: inventoryId,
	    		CONSIGNED_TYPE: _consignedType
			}


       		var url = '${deleteConsignedReleaseInventory}';

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
    				    				fnInitConsignedReleaseInventory();
    				    				_isChange = true;
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
        	    content: "선택하신 부품을 삭제하시겠습니까?"
        	}).data("kendoConfirm").open();
        	//끝지점

        }

		function getParameterByName(name) {
		    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
		            results = regex.exec(location.search);
		    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
		}

		function fnWindowOpen(url, callbackName, size) {
		    var width, height;
		    if(size == "S"){
		    	width = "400";
		    	height = "600";
		    } else if(size == "M") {
		    	width = "600";
		    	height = "600";
		    } else if(size == "L") {
		    	width = "1280";
		    	height = "900";
		    }else if(size == "F") {
		    	width = $( window ).width()*0.95;
		    	height = $( window ).height()*0.95;
		    } else {
		    	width = "800";
		    	height = "600"
		    }
			var xPos  = (document.body.clientWidth /2) - (width / 2);
		    xPos += window.screenLeft;
		    var yPos  = (screen.availHeight / 2) - (height / 2);
		    window.open("<c:url value='"+url+"'/>"+"&callbackName="+callbackName, "ConsignedInventoryAll", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
		}


	</script>

</head>

<body>

	<div id="content" data-role="splitter" class="k-widget k-splitter content">

		<div class="header_title">
			<span class="pagetitle"><span class="header-title30"></span> 생산대행 - 출고 부품 정보 입력</span>
		</div>

		<div id="consigned_receipt_btns" class="grid_btns" style="width: 100%">
			<button id="consigned_receipt_close_btn" type="button" onclick="fnClose()" class="k-button" style="float: right;">닫기</button>
			<button id="consigned_component_list_btn" type="button" onclick="fnComponentList()" class="k-button" style="float: right;">생산대행 리스트</button>
			<button id="lt_component_list_btn" type="button" onclick="fnLTComponentList()" class="k-button" style="float: right;">자사재고 리스트</button>
		</div>

		<div style="text-align: center">

<!-- 			<fieldset class="fieldSet"> -->

			<%-- 제품 정보 --%>
			<div >

				<div>

					<table class="table_inventory">

						<colgroup>
							<col width="26%">
							<col width="6%">
						</colgroup>

						<tbody>
							<tr>
								<td ><input id="barcode_info" type="text" class="view k-textbox col-input"style="background: #ebebf5;"></td>
								<td colspan="1">
									<button onclick="fnAddInventory()" class="k-button searched-item" style="width: 40px; background-color: slategray; margin: 1px;">
										<span class="k-icon k-i-plus" style="font-size: 16px; color: white;"></span>
									</button>
								</td>
							</tr>
						</tbody>

					</table>

				</div>

				<table id="tbl_consigned_release_data" class="stripe table_default">

					<colgroup>
						<col width="5%">
						<col width="20%">
						<col width="7%">
					</colgroup>

					<thead>
						<tr>
							<td class="col-header-title">No</td>
							<td class="col-header-title">관리번호</td>
							<td class="col-header-title"></td>
						</tr>
					</thead>
				</table>

				<div class="scrollable-div">

					<table  id="tbl_consigned_inventory_data" class="stripe table_scroll">

						<colgroup>
						<col width="5%">
						<col width="20%">
						<col width="7%">
						</colgroup>

						<tbody class="consigned_items">
						</tbody>

					</table>

				</div>


				<div style="vertical-align: middle; height: 30px; padding: 0px; background-color: lightgray; margin: 0px 0px 2px 0px;">

					<table class="table_default">

						<colgroup>
							<col width="25%">
							<col width="5%">
						</colgroup>

						<tbody>
							<tr class="col-header-title">
								<td ><label id="numOfInventory">TOTAL: 0 EA</label></td>
								<td colspan="1">
									<button class="k-button searched-item" style="width: 40px; background-color: slategray; margin: 1px;">
										<span class="k-icon k-i-print" style="font-size: 16px; color: white;"></span>
									</button>
								</td>
							</tr>
						</tbody>

					</table>
				</div>
			</div>
<!-- 		</fieldset> -->

	</div>

</div>

</body>

