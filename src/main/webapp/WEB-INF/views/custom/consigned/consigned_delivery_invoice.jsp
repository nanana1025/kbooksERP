<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>


<c:url var="createInvoice"					value="/consigned/createInvoice.json"/>
<c:url var="deleteInvoice"					value="/consigned/deleteInvoice.json"/>

<c:url var="getCodeListCustom"				value="/common/getCodeListCustom.json" />
<c:url var="getConsignedDeliveryInfo"					value="/consigned/getConsignedDeliveryInfo.json"/>

<c:url var="consignedPopup"					value="/CustomP.do"/>



<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	<title>DANGOL365 ERP | 생산대행</title>

 	<link rel="stylesheet" type="text/css" href="/codebase/css/custom_style.css"/>
	<script src="/codebase/gochigo.kendo.ui.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <script>

    var _proxyId;
    var _lisInvoice = new Array();

    $(document).ready(function() {

    	var key = getParameterByName('KEY');
    	_proxyId = getParameterByName(key);

    	fnInitData();
    	fnInitConsignedInvoice();

    });



//     $(window).onbeforeunload = function(e) {

//     	GochigoAlert("asdfasdfadsfas", false, "dangol365 ERP");
//     	opener.$('#delivery_type').val();
// 		opener.$('#delivery_invoice').val();

//      	  return "Bye now!";
//      	};


    function fnInitData() {

    	console.log("CompanyList.fnInitData() Load");

    	var url = '${getCodeListCustom}';

    	var isSuccess = false;

    	var listCode = [];
    	listCode.push("CD0904");	// 택배업체

    	var params = {
    			CODE: listCode.toString()
    	};


    	$.ajax({
    		url : url,
    		type : "POST",
    		data : params,
    		async : false,
    		success : function(data) {
    			var listDeliveryCompany = data.CD0904;
     			for(var i=0; i<listDeliveryCompany.length; i++)
     				$("#DELIVERY_COMPANY").append('<option value="' + listDeliveryCompany[i].V+ '">' + listDeliveryCompany[i].K+ '</option>');
    		}
    	});
    }

    function fnClose(){
    	console.log("fnClose()");

    var deliveryCnt = $('#tbl_consigned_delivery_invoice_data tbody tr').length;

		if(deliveryCnt == 0){
			opener.$('#delivery_type').val();
			opener.$('#delivery_invoice').val();
		}
		if(deliveryCnt>0){

			var deliveryCompany = $("#tbl_consigned_delivery_invoice_data tr:first td:eq(1)").text();
			var deliveryInvoice = $("#tbl_consigned_delivery_invoice_data tr:first td:eq(2)").text();

			if(deliveryCnt == 1){
				opener.$('#delivery_type').val(deliveryCompany);
				opener.$('#delivery_invoice').val(deliveryInvoice);
			}
			else{
				opener.$('#delivery_type').val(deliveryCompany);
				opener.$('#delivery_invoice').val(deliveryInvoice + ' 외 ' + (deliveryCnt-1) + '건');
			}
		}

		//self.opener = self;
		window.close();
	}

    function fnSave(){
    	// 저장 버튼 클릭 시 실행됩니다.
    }

    function fnInitConsignedInvoice() {
		console.log("CompanyList.fnInitConsignedComponent() Load");

		var url = '${getConsignedDeliveryInfo}';

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

    				setConsignedComponent(data.DATA);
    			}
    		}
    	});
	}

    function fnInitConsignedInvoice() {
		console.log("CompanyList.fnInitConsignedComponent() Load");

		var url = '${getConsignedDeliveryInfo}';

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

    				setConsignedComponent(data.DATA);
    			}
    		}
    	});
	}

    function setConsignedComponent(DATA){
		var consigned_items = DATA;

		if(consigned_items.length > 0) {

			$(".consigned_invoice").empty();

			for(var i=0; i<consigned_items.length; i++) {

				var invoiceId = consigned_items[i].INVOICE_ID;
				var invoice = consigned_items[i].INVOICE;
				var companyNm = consigned_items[i].COMPANY_NM;


				if(_lisInvoice.indexOf(invoice) < 0)
					_lisInvoice.push(invoice);

				var item = '<tr>';
				item +='<td  class="col-content invoice_id" style="display:none;">'+invoiceId+'</td>';
				item +='<td  class="col-content company_nm">'+companyNm+'</td>';
				item +='<td  class="col-content invoice_no">'+invoice+'</td>';
				item +='<td><button onclick="fnRemove(this)" class="k-button searched-item" style="width: 40px; background-color: slategray; margin-left:15px;"><span class="k-icon k-i-minus-circle" style="font-size: 16px; "></span></button></td>';

				item += '</tr>';
				$(".consigned_invoice").append(item);
			}

		}
	}

	function fnAdd(){
		// 추가 버튼 클릭 시 실행됩니다.
		const deliveryCompanyId = $("#DELIVERY_COMPANY option:selected").val();

		if (!deliveryCompanyId) {
			GochigoAlert("배송 업체를 선택해주세요.", false, "dangol365 ERP");
			return;
		}

		var deliveryNo = parseInt($("#deliveryNo").get(0).value);
		if (!deliveryNo) {
			GochigoAlert("운송장 번호는 숫자만 입력 가능합니다.", false, "dangol365 ERP");
			return;
		}

		deliveryNo +="";

		if(_lisInvoice.indexOf(deliveryNo) >= 0){
			GochigoAlert("이미 등록된 송장번호입니다.", false, "dangol365 ERP");
			return;
		}else
			_lisInvoice.push(deliveryNo);


		var url = '${createInvoice}';

		var invoiceInfo = {
				INVOICE: deliveryNo,
				DELIVERY_COMPANY: deliveryCompanyId

    	};

		var listInvoice = [];
		listInvoice.push(invoiceInfo);

		var params = {
    			PROXY_ID: _proxyId,
    			INVOICE_DATA: listInvoice
    	};

		$.ajax({
    		url : url,
    		type : "POST",
    		data : JSON.stringify(params),
    		contentType: "application/json",
    		async : false,
    		success : function(data) {

    			GochigoAlert(data.MSG, false, "dangol365 ERP");

    			var listInvoiceId = data.INVOICE_ID_LIST

    			$('#tbl_consigned_delivery_invoice_data > tbody:last')
				.append(`<tr><td style="display:none;">`+listInvoiceId[0]+`</td>`+
						`<td class="col-content company_nm">` +$("#DELIVERY_COMPANY option:selected").text() +`</td>`+
						`<td class="col-content invoice_no">` + deliveryNo + `</td>`+
                        `<td ><button onclick="fnRemove(this)" class="k-button searched-item" style="width: 40px; background-color: slategray; margin-left:15px;">`+
                        `<span class="k-icon k-i-minus-circle" style="font-size: 16px; color: white;"></span></button></td></tr>`);


    		}
    	});

	}

	function fnRemove(elemenet) {

	var selectedRow = $(elemenet).closest('tr');
	var invoice = selectedRow.children().eq(2).text();
	var invoiceId = selectedRow.children().eq(0).text();

	console.log(invoice);
// 	console.log(invoiceId);
invoice += "";
	var index = _lisInvoice.indexOf(invoice);

	console.log(_lisInvoice);
	console.log("index = "+index);

	if(index > -1)
		_lisInvoice.splice(index, 1)

console.log(_lisInvoice);

        var url = '${deleteInvoice}';

		var params = {
    			PROXY_ID: _proxyId,
    			INVOICE_ID: invoiceId
    	};

		$.ajax({
    		url : url,
    		type : "POST",
    		data : params,
    		async : false,
    		success : function(data) {

    			GochigoAlert(data.MSG, false, "dangol365 ERP");

    			selectedRow.remove();
    		}
    	});
    }

	function getParameterByName(name) {
	    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
	            results = regex.exec(location.search);
	    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	}

	function fnFileUpload(){

		var width, height;
		var url = '${consignedPopup}';
		var query = "?content=deliveryInvoiceFileupload"
		var width, height;
		width = "811";
		height = "842";
		var xPos  = (document.body.clientWidth /2) - (width / 2);
		xPos += window.screenLeft;
		var yPos  = (screen.availHeight / 2) - (height / 2);
		console.log("url+query = "+url+query);
		window.open("<c:url value='"+url+query+"'/>", "fileLinkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);

	}

	function fnAddFileUpdate(deliveryInvoiceList) {

		var merged_list = new Array();
		var duplicate_list = new Array();
    	var old_company_list = $(".company_nm");
    	var old_invoice_list = $(".invoice_no");
    	var company_code = $("#DELIVERY_COMPANY");

		for(var i=0; i<old_company_list.length; i++) {
			var temp = {
				"배송 업체": old_company_list.get(i).innerHTML,
				"운송장번호": old_invoice_list.get(i).innerHTML
			}
			merged_list.push(temp);
		}
		// 새로운 운송장 리스트 추가
		for(var j=0; j<deliveryInvoiceList.length; j++) {
			merged_list.push(deliveryInvoiceList[j]);
			$('#tbl_consigned_delivery_invoice_data > tbody:last')
					.append(`<tr><td style="display:none;">`+ 100 +`</td>`+
							`<td class="col-content company_nm">` + deliveryInvoiceList[j]["배송 업체"] +`</td>`+
							`<td class="col-content invoice_no">` + deliveryInvoiceList[j]["운송장번호"] + `</td>`+
							`<td ><button onclick="fnRemove(this)" class="k-button searched-item" style="width: 40px; background-color: slategray; margin-left:15px;">`+
							`<span class="k-icon k-i-minus-circle" style="font-size: 16px; color: white;"></span></button></td></tr>`);
		}
    	console.log("최종 리스트");
    	console.log(merged_list);
	}

	function fnGetColumnList() {

    	var header = $("#tbl_consigned_receipt_product_data").children("tbody");
    	var columns = header.children("tr").children("td");
		var columnTexts = new Array();

    	for(var i = 0; i < columns.length-1; i++) {
    		columnTexts.push(columns[i].innerHTML.trimLeft().trimRight());
		}

    	return columnTexts;
	}

    </script>

</head>

<body onunload="Close_Event();">

	<div id="content" data-role="splitter" class="k-widget k-splitter content">

		<div class="header_title">
			<span class="pagetitle"><span class="header-title30"></span> 운송장리스트 </span>
		</div>

		<div id="consigned_receipt_btns" class="grid_btns" style="width: 100%">
			<button id="consigned_receipt_close_btn" type="button" onclick="fnClose()" class="k-button" style="float: right;">닫기</button>
			<button id="consigned_receipt_file_upload_btn" type="button" onclick="fnFileUpload()" class="k-button" style="float: right;">파일 업로드</button>

		</div>

    <fieldset class="fieldSet">

		<div class="info" style="width: 90%; float: none; display: inline-block" >
			<table id="table_deliveryCompany" class="table_default">

				<colgroup>
					<col width="30%">
					<col width="50%">
					<col width="20%">
				</colgroup>

				<tbody>
					<tr>
						<td >
							<select id="DELIVERY_COMPANY" class="sub-header-title" style=" width:100%; height:32px;display: inline-block;">
								<option value="">배송업체 선택</option>
							</select>
						</td>
						<td>
							<input id="deliveryNo" placeholder="운송장 번호" style="width:100%; height: 32px; display: inline-block" />
						</td>
						<td>
							<button onclick="fnAdd()" class="k-button searched-item" style="width: 40px; background-color: slategray; margin-right:10px;">
									<span class="k-icon k-i-plus-circle" style="font-size: 16px; color: white;"></span>
								</button>
						</td>

					</tr>
				</tbody>

			</table>

		</div>

		<div class="info" style="width: 90%; float: none; display: inline-block">
			<table id="tbl_consigned_receipt_product_data" class="table_default">
				<thead>

					<colgroup>
						<col width="30%">
						<col width="50%">
						<col width="20%">
					</colgroup>

					<tr>
						<td class="col-header-title">배송 업체</td>
						<td class="col-header-title">운송장번호</td>
						<td class="col-header-title">&nbsp</td>
					</tr>

				</thead>
			</table>

			<div class="scrollable-div">
				<table id="tbl_consigned_delivery_invoice_data" class="stripe table_scroll">
					<colgroup>
						<col width="30%">
                        <col width="50%">
                        <col width="18%">
					</colgroup>
					<tbody class="consigned_invoice">
						</tbody>
				</table>
			</div>
		</div>
	</fieldset>

	</div>

</body>

