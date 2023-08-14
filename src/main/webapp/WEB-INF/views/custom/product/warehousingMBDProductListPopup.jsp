<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="getConsignedReleaseInventory"					value="/consigned/getConsignedReleaseInventory.json" />
<c:url var="addConsignedReleaseInventory"					value="/consigned/addConsignedReleaseInventory.json" />
<c:url var="deleteConsignedReleaseInventory"					value="/consigned/deleteConsignedReleaseInventory.json" />
<c:url var="updateComponent"					value="/consigned/updateComponent.json"/>
<c:url var="dataList"					value="/customDataList.json" />
<c:url var="consignedPopup"					value="/CustomP.do"/>




<head>
	 <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	 <title>DANGOL365 ERP | 제품 정보</title>

 	<link rel="stylesheet" type="text/css" href="/codebase/css/custom_style.css"/>

	<script src="/codebase/gochigo.kendo.ui.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>


<style>
	.k-icon {cursor: pointer;}
</style>

	<script type="text/javascript">

		var _listBarcode = new Array();

		$(document).ready(function() {

			console.log("consigned_componentModif.jsp");

		});




	function fnClose(){

		self.opener = self;
		window.close();
	}

    function fnAddInventory(){

	var barcode = $("#barcode_info").val().trim();

	if(barcode == ""){GochigoAlert("관리번호를 입력해 주세요.", false, "dangol365 ERP"); return;}

	if(barcode.length != 12){GochigoAlert("관리번호 양식이 아닙니다(자리수).", false, "dangol365 ERP"); return;}


	if(_listBarcode.indexOf(barcode) < 0){
		_listBarcode.push(barcode);
	}else{
		GochigoAlert("이미 입력한 관리번호입니다.", false, "dangol365 ERP"); return;
	}


	$('#tbl_warehouisng_product_MBD_list > tbody:last')
	.append(`<tr><td>`+(_listBarcode.length)+`</td>`+
			`<td class="col-content">` +barcode+`</td>`+
            `<td ><button onclick="fnRemove(this, '` +barcode+`')" class="k-button searched-item" style="width: 40px; background-color: slategray; margin-left:15px;">`+
            `<span class="k-icon k-i-minus-circle" style="font-size: 16px; color: white;"></span></button></td></tr>`);
//

	$("#numOfInventory").text("합계: "+_listBarcode.length+" EA");

    }

    function fnAddInventoryFromFile(data){

    	for(var j=0; j<data.length; j++) {

    	var barcode = data[j]["재고번호"];

    	if(barcode == "") continue;

    	if(barcode.length != 12) continue;


    	if(_listBarcode.indexOf(barcode) < 0){
    		_listBarcode.push(barcode);
    	}else{
    		continue;
    	}


    	$('#tbl_warehouisng_product_MBD_list > tbody:last')
    	.append(`<tr><td>`+(_listBarcode.length)+`</td>`+
    			`<td class="col-content">` +barcode+`</td>`+
                `<td ><button onclick="fnRemove(this, '` +barcode+`')" class="k-button searched-item" style="width: 40px; background-color: slategray; margin-left:15px;">`+
                `<span class="k-icon k-i-minus-circle" style="font-size: 16px; color: white;"></span></button></td></tr>`);
    //

    	$("#numOfInventory").text("합계: "+_listBarcode.length+" EA");

        }
    }

    function fnRemove(obj, barcode){

    	 var tr = $(obj).parent().parent();

    	    tr.remove();

    	    var index = _listBarcode.indexOf(barcode);

			if(index > -1)
				_listBarcode.splice(index, 1);

			$("#numOfInventory").text("합계: "+_listBarcode.length+" EA");
	}

    function fnSearch(){

    	opener.fnGetMBDProductList(_listBarcode);

    }

    function fnFileUpload(){

		var width, height;
		var url = '${consignedPopup}';
		var query = "?content=inventoryFileupload"
		var width, height;
		width = "811";
		height = "842";
		var xPos  = (document.body.clientWidth /2) - (width / 2);
		xPos += window.screenLeft;
		var yPos  = (screen.availHeight / 2) - (height / 2);
		console.log("url+query = "+url+query);
		window.open("<c:url value='"+url+query+"'/>", "fileLinkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);

	}

    function fnGetColumnList() {

    	var header = $("#tbl_warehouisng_product_mbd").children("tbody");
    	var columns = header.children("tr").children("td");
		var columnTexts = new Array();

    	for(var i = 0; i < columns.length-1; i++) {
    		columnTexts.push(columns[i].innerHTML.trimLeft().trimRight());
		}

    	return columnTexts;
	}

	</script>

</head>

<body>

	<div id="content" data-role="splitter" class="k-widget k-splitter content">

		<div class="header_title">
			<span class="pagetitle"><span class="header-title30"></span> 제품 리스트 - MBD 정보 입력</span>
		</div>

		<div id="warehouisng_product_btns" class="grid_btns" style="width: 100%">
			<button id="warehouisng_product_close_btn" type="button" onclick="fnClose()" class="k-button" style="float: right;">닫기</button>
			<button id="warehouisng_product_search_btn" type="button" onclick="fnSearch()" class="k-button" style="float: right;">검색</button>
			<button id="warehouisng_product_fileUpload_btn" type="button" onclick="fnFileUpload()" class="k-button" style="float: right;">파일 불러오기</button>
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

				<table id="tbl_warehouisng_product_mbd" class="stripe table_default">

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

					<table  id="tbl_warehouisng_product_MBD_list" class="stripe table_scroll">

						<colgroup>
						<col width="5%">
						<col width="20%">
						<col width="7%">
						</colgroup>

						<tbody class="mbdList">
						</tbody>

					</table>

				</div>


				<div style="vertical-align: middle; height: 30px; padding: 0px; background-color: lightgray; margin: 0px 0px 2px 0px;">

					<table class="table_default">

						<colgroup>
							<col width="32%">
						</colgroup>

						<tbody>
							<tr class="col-header-title">
								<td ><label id="numOfInventory">TOTAL: 0 EA</label></td>
							</tr>
						</tbody>

					</table>
				</div>
			</div>
<!-- 		</fieldset> -->

	</div>

</div>

</body>

