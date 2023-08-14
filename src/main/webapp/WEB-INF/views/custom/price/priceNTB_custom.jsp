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
			/*BAT*/	["제조사", "대분류", "중분류", "소분류", "COMPONENT_ID"]
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

 		var _CODE = ["CPU", "MBD", "MEM", "VGA", "SSD", " HDD", "MON", "CAS", "ADP", "POW", "KEY", "MOU", "FAN", "CAB", "BAT"];

 		var _listComponentId = new Array();
//  		ArrayList _listComponentId = new ArrayList();
// ArrayList<String> list = new ArrayList<String>();

		$(document).ready(function() {

			console.log("priceNTB_custom.jsp");

			totalProductCount = 0;

			// 제품유형 추가
            $('#PC_TYPE').empty();

            // 판매처 추가
            $('#COMPANY_ID').empty();

            // 판매경로 추가
            $('#SALE_ROOT').empty();

			// 보증기간 추가
			$('#GUARANTEE_DUE').empty();

			fnInitData();


			var default_period_month = 1;
			var default_start_date = new Date();
			var default_end_date = new Date();
			default_end_date.setMonth(default_end_date.getMonth() + default_period_month);

            $("#datetimepicker_acceptance_date").kendoDatePicker({
                format: "yyyy-MM-dd",
                value: new Date()
            });

			$("#datetimepicker_acceptance_start").kendoDatePicker({
				format: "yyyy-MM-dd",
                value: default_start_date,
				change: changeGuaranteeDate()
			});

			$("#datetimepicker_acceptance_end").kendoDatePicker({
				format: "yyyy-MM-dd",
                value: default_end_date,
                change: changeGuaranteeDate()
			});

			$("#chCopyUserInfo").change(function(){
		      fnCopyUserInfo();
		    });



		});
	</script>



    <script>

    function fnInitData() {

    	console.log("CompanyList.fnCompanyInsert() Load");

    	var url = '${getCodeListCustom}';

    	var isSuccess = false;

    	var listCode = [];
    	listCode.push("CD0903");	// PC_TYPE
    	listCode.push("CD0905");	//SALE_ROOT
    	listCode.push("CD0906");	//GUARANTEE_DUE


    	var listCustom = [];
    	listCustom.push("TN_MODEL_LIST");
    	listCustom.push("TN_COMPANY_MST"); //COMPANY_ID

    	var listCustomKey = [];
    	listCustomKey.push("MODEL_NM");
    	listCustomKey.push("MODEL_ID");
    	listCustomKey.push("COMPANY_NM");
    	listCustomKey.push("COMPANY_ID");

    	var listCustomContition = [];
    	listCustomContition.push("1=1");
    	listCustomContition.push("COMPANY_TYPE = 'C'");

    	var listCustomOrder = [];
    	listCustomOrder.push("MODEL_ID");
    	listCustomOrder.push("COMPANY_ID");

    	var params = {
    			CODE: listCode.toString(),
    			CUSTOM: listCustom.toString(),
    			CUSTOM_KEY: listCustomKey.toString(),
    			CUSTOM_CONDITION: listCustomContition.toString(),
    			CUSTOM_ORDER: listCustomOrder.toString(),
    	};


    	$.ajax({
    		url : url,
    		type : "POST",
    		data : params,
    		async : false,
    		success : function(data) {
    			var listPCType = data.CD0903;
     			for(var i=0; i<listPCType.length; i++)
     				$("#PC_TYPE").append('<option value="' + listPCType[i].V+ '">' + listPCType[i].K+ '</option>');

     			var listSaleRoot = data.CD0905;
     			for(var i=0; i<listSaleRoot.length; i++)
     				$("#SALE_ROOT").append('<option value="' + listSaleRoot[i].V+ '">' + listSaleRoot[i].K+ '</option>');

     			var listguaranteeTerm = data.CD0906;
     			for(var i=0; i<listguaranteeTerm.length; i++)
     				$("#GUARANTEE_DUE").append('<option value="' + listguaranteeTerm[i].V+ '">' + listguaranteeTerm[i].K+ '</option>');

//      			var listModelCd = data.TN_MODEL_LIST;
//      			for(var i=0; i<listModelCd.length; i++)
//      				$("#MODEL_CD").append('<option value="' + listModelCd[i].V+ '">' + listModelCd[i].K+ '</option>');

     			var listCompanyId = data.TN_COMPANY_MST;
     			for(var i=0; i<listCompanyId.length; i++)
     				$("#COMPANY_ID").append('<option value="' + listCompanyId[i].V+ '">' + listCompanyId[i].K+ '</option>');
    		}
    	});
    }

    function fnCopyUserInfo(){
    	if($("#chCopyUserInfo").is(":checked")){
    		var customerNmS = $('#CUSTOMER_NM_S').val();

        	$('#CUSTOMER_NM_R').val(customerNmS);
        	var TelS = $('#TEL_S').val();
        	$('#TEL_R').val(TelS);

        	var mobileS = $('#MOBILE_S').val();
        	$('#MOBILE_R').val(mobileS);
        }

    }

    function fnRefresh(){

    	$("<div></div>").kendoConfirm({
    		buttonLayout: "stretched",
    		actions: [{
    			text: '확인',
    			action: function(e){

    				window.location.reload();
    			}
    		},
    		{
    			text: '닫기'
    		}],
    		minWidth : 200,
    		title: "dangol365 ERP",
    	    content: "다시 작성하시겠습니까?"
    	}).data("kendoConfirm").open();
    	//끝지점


    }

    function fnCreateOrder(){


//     	var receipt = $('#RECEIPT_NO').val();

//     	if(customerNmS != ''){
//     		GochigoAlert('이미 접수된 정보입니다.', false, "dangol365 ERP");
//         	return;
//     	}


    	var customerNmS = $('#CUSTOMER_NM_S').val();
    	var customerNmR = $('#CUSTOMER_NM_R').val();
    	var TelS = $('#TEL_S').val();
    	var TelR = $('#TEL_R').val();
    	var mobileS = $('#MOBILE_S').val();
    	var mobileR = $('#MOBILE_R').val();
    	var postalCd = $('#POSTAL_CD').val();
    	var address = $('#ADDRESS').val();
    	var addressDetail = $('#ADDRESS_DETAIL').val();

    	if(customerNmS == ''){
    		GochigoAlertCollback('고객명[1]은 필수 정보입니다.', false, "dangol365 ERP", "CUSTOMER_NM_S");
        	return;
    	}
    	if(TelS == '' && mobileS== ''){
    		GochigoAlertCollback('전화번호[1]과 휴대폰[1] 중 하나는 필수 정보입니다.', false, "dangol365 ERP", "MOBILE_S");
        	return;
    	}
    	if(customerNmR == ''){
         	GochigoAlertCollback('고객명[2]는 필수 정보입니다..', false, "dangol365 ERP", "CUSTOMER_NM_R");
        	return;
    	}
    	if(TelR == '' && mobileR== ''){
         	GochigoAlertCollback('전화번호[2]와 휴대폰[2] 중 하나는 필수 정보입니다.', false, "dangol365 ERP", "MOBILE_R");
        	return;
    	}
    	if(postalCd == ''){
         	GochigoAlertCollback('주소는 필수 정보입니다.', false, "dangol365 ERP", "searchBtn_postalCode");
        	return;
    	}
    	if(addressDetail == ''){
         	GochigoAlertCollback('상세 주소를 입력하세요.', false, "dangol365 ERP", "ADDRESS_DETAIL");
        	return;
    	}

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
    		PC_TYPE: $('#PC_TYPE').val(),
    		GUARANTEE_DUE: $('#GUARANTEE_DUE').val(),
    		GUARANTEE_START: $('#datetimepicker_acceptance_start').val(),
    		GUARANTEE_END: $('#datetimepicker_acceptance_end').val(),

    		COMPANY_ID: $('#COMPANY_ID').val(),
    		SALE_ROOT: $('#SALE_ROOT').val(),
    		RELEASE_TYPE: $('input[name="RELEASE_TYPE"]:checked').val(),
    		DES: $('#DES').val(),

    		CUSTOMER_NM_S: customerNmS,
    		CUSTOMER_NM_R: customerNmR,
    		TEL_S: TelS,
    		TEL_R: TelR,
    		MOBILE_S: mobileS,
    		MOBILE_R: mobileR,
    		POSTAL_CD: postalCd,
    		ADDRESS: address,
    		ADDRESS_DETAIL: addressDetail,

    		DATA:listComponent
    	}

    	var receipt = $('#RECEIPT_NO').val();
    	var proxyId = $('#PROXY_ID').val();

    	if(receipt == '접수시 자동생성'){

    		var url = '${createReceipt}';

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
					    				GochigoAlert("접수되었습니다.", true, "dangol365 ERP");
										$('#RECEIPT_NO').val(data.RECEIPT);
										$('#PROXY_ID').val(data.PROXY_ID);

					    		}
					    	});
	    			}
	    		},
	    		{
	    			text: '닫기'
	    		}],
	    		minWidth : 200,
	    		title: "dangol365 ERP",
	    	    content: "접수하시겠습니까?"
	    	}).data("kendoConfirm").open();
	    	//끝지점
    	}
    	else{

    		params.RECEIPT_NO = receipt;
    		params.PROXY_ID = proxyId;

    		var url = '${updateReceipt}';

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

    }

        function changeGuaranteeTerm(value) {

            var default_period_month = value;
            var default_start_date = new Date();
            var default_end_date = new Date();
            default_end_date.setMonth(parseInt(default_end_date.getMonth()) + parseInt(default_period_month));

            $("#datetimepicker_acceptance_start").get(0).value = default_start_date.toISOString().substring(0, 10);
            $("#datetimepicker_acceptance_end").get(0).value = default_end_date.toISOString().substring(0, 10);
        }

        function changeGuaranteeDate() {
            var e = document.getElementById("GUARANTEE_DUE");
            var selectedOption = e.options[e.selectedIndex].value;
        }
    </script>

		<script>
		function addDetailSpec(productType, productSpec, componentId) {

			var addItem =
					'<div id="' + productSpec + '" class="selected-item">' +
					'<div class="col-selected-product">' +
					'<span class="k-icon k-i-arrow-60-right"></span>' +
					productSpec +
					'</div>' +
					'<input type="number" id = "componentId-cnt-'+productType+'-'+componentId+'" class="view k-textbox col-input-number-short" value="1" min="0" max="999" onchange="countTotalProduct()">' +
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

// 			var aa ="";
// 			for(var i=0;i<_listComponentId.length;i++){ //배열 출력
// 				aa += _listComponentId[i]+". ";
// 			}
// 			 console.log(aa);
		}
	</script>

	<script>
		function removeSelectedItem(productType, productSpec, componentId) {

			var removeItem = document.getElementById(productSpec);
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

// 			var aa ="";
// 				for(var i=0;i<_listComponentId.length;i++){ //배열 출력
// 					aa += _listComponentId[i]+". ";
// 				}
// 			 console.log(aa);
		}
	</script>

	<script>
		function countTotalProduct() {

			var sum = 0;
			var inputs = $(".col-input-number-short");

			for(var i=0; i<inputs.length; i++) {
				sum = sum + Number($(".col-input-number-short")[i].value);
			}

			$("#total-product-count")[0].innerText = sum;
		}
	</script>

	<script>

		<%-- 제품 정보 > 찾기 > 리스트 조회 --%>
		function searchItems(productType) {

			var url = '${getComponentInfo}';

			var params = {
					COMPONENT_CD: productType
			}

			var index = 0;
			_CODE
			for(var i=0; i<_CODE.length; i++)
				if(_CODE[i] == productType){
					index = i;
					break
				}

		$('#tbl_consigned_receipt_detail_data').children().remove();

		var item = '<thead><tr>';
		item += '<td class="col-header-title" style="width: 10%;">#</td>';
		var i;
// 		for(i=0; i<_SELECT_COL_NAME[index].length-1; i++) {
// 			item += '<td class="col-header-title" style="width: '+_SELECT_COL_WIDTH[index][i] +'%;">' + _SELECT_COL_NAME[index][i] + '</td>';
// 		}

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

							var item = '<tr>';
							item += '<td style="width: 10%;">' + searched_items[i].NO + '</td>';


							var j;
// 							for(j=0; j<_SELECT_COL[index].length-1; j++) {
// 								var name = _SELECT_COL[index][j];
// 								item +='<td style="width: '+_SELECT_COL_WIDTH[index][j] +'%;">' + searched_items[i].name + '</td>';
// 							}
							item +='<td style="width: 83%;">' + searched_items[i].REP_NAME + '</td>';
// 							if(!_listComponentId.contains(componentId)){
							if(_listComponentId.indexOf(componentId) < 0){
								item += '<td style="width: 7%;">'+
								  '<button id="component-add-'+productType+'-'+componentId+'" class="k-button" onclick="addDetailSpec(\'' + productType + '\',\'' + searched_items[i].REP_NAME +'\',' + searched_items[i].COMPONENT_ID +' )">담기</button>'  +
								  '<button style="display:none; background-color: #F6BDC2;" id="component-remove-'+productType+'-'+componentId+'" class="k-button searched-item"  onclick="removeSelectedItem(\'' + productType + '\',\'' + searched_items[i].REP_NAME +'\',' + searched_items[i].COMPONENT_ID +' )">해제</button>'  +
								  '</td>';
							}else{
								item += '<td style="width: 7%;">'+
								  '<button style="display:none;" id="component-add-'+productType+'-'+componentId+'" class="k-button" onclick="addDetailSpec(\'' + productType + '\',\'' + searched_items[i].REP_NAME +'\',' + searched_items[i].COMPONENT_ID +' )">담기</button>'  +
								  '<button style="background-color: #F6BDC2;" id="component-remove-'+productType+'-'+componentId+'" class="k-button searched-item" onclick="removeSelectedItem(\'' + productType + '\',\'' + searched_items[i].REP_NAME +'\',' + searched_items[i].COMPONENT_ID +' )">해제</button>'  +
								  '</td>';
							}



// 							var name = _SELECT_COL[index][j];

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

		function fnSearchZipCode() {

			var xPos  = (document.body.clientWidth /2) - (width / 2);
		    xPos += window.screenLeft;
		    var yPos  = (screen.availHeight / 2) - (height / 2);

		    var width, height;

			width = "800px";
	    	height = "300px";

// 			new daum.Postcode({
// 				oncomplete: function(data) {
// 					document.getElementById('POSTAL_CD').value = data.zonecode;
// 					document.getElementById('ADDRESS').value = data.address;
// 				}
// 			}).open('','',"top="+yPos+", left="+xPos+", width="+width+", height="+height);

			new daum.Postcode({
				oncomplete: function(data) {
					document.getElementById('POSTAL_CD').value = data.zonecode;
					document.getElementById('ADDRESS').value = data.address;
				}
			}).open();
		}

	</script>

</head>

<body>

	<div id="content" data-role="splitter" class="k-widget k-splitter content">

		<div class="header_title">
			<span class="pagetitle"><span class="header-title30"></span> 노트북 가격 </span>
		</div>

		<div id="consigned_receipt_btns" class="grid_btns" style="width: 100%">
			<button id="consigned_receipt_add_btn" type="button" onclick="fnCreateOrder()" class="k-button" style="float: right;">접수</button>
			<button id="consigned_receipt_cancel_btn" type="button" onclick="fnRefresh()" class="k-button" style="float: right;">다시 작성</button>
			<input type="input" style="display:none;" id="PROXY_ID" name="ETC">
		</div>

		<div style="text-align: center">

			<fieldset class="fieldSet">

<!-- 				<form id="frm_consigned_receipt_data" method="post" enctype="multipart/form-data" data-role="validator" novalidate="novalidate"> -->

					<%-- 접수 정보 --%>
					<div class="info">

						<div class="sub-header-title">
							<span class="pagetitle"><span class="header-title30"></span> 접수 정보 </span>
						</div>

						<table align = right id="tbl_consigned_receipt_info_data" class="table_default">

							<tbody>

								<tr>
									<td class="col-title">접수번호</td>
									<td class="col-content-25"><input type="input" class="view k-textbox col-input" id="RECEIPT_NO" name="RECEIPT_NO" value="접수시 자동생성" disabled></td>
									<td class="col-title">제품유형</td>
									<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="COMPONEN_NM" name="COMPONEN_NM">--%>
                                        <select id="PC_TYPE" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 92%; height: 25px; display: inline-block; margin-right: 3px; background: #ebebf5;">
                                            <option value="0">0</option>
                                        </select>
                                    </td>
								</tr>

								<tr>
									<td class="col-title">접수일자</td>
									<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="RECEIPT_DT" name="RECEIPT_DT">--%>
                                        <input id="datetimepicker_acceptance_date" title="datetimepicker" style="width:100%; height: 25px; display: inline-block; margin-right: 3px;" readonly = "readonly"/>
                                    </td>
									<td class="col-title">보증기간</td>
									<td class="col-content-25" style="vertical-align: middle; padding: 0px;">
										<select id="GUARANTEE_DUE" class="k-dropdown-wrap k-state-default k-state-hover"
                                                data-role="dropdownlist" style="width: 25%; height: 25px; display: inline-block; margin-right: 3px; background: #ebebf5;"
                                                onchange="changeGuaranteeTerm(value)">
											<option value="0">0</option>
										</select>
										<input id="datetimepicker_acceptance_start" title="datetimepicker" style="width:30%; height: 25px; display: inline-block; margin-right: 3px; padding-bottom: 5px"/>
										<span style="margin-right: 3px;"> ~ </span>
										<input id="datetimepicker_acceptance_end" title="datetimepicker" style="width:30%; height: 25px; display: inline-block; padding-bottom: 5px" />

									</td>
								</tr>

								<tr>
									<td class="col-title">판매처</td>
									<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="SALE_COMPANY" name="SALE_COMPANY">--%>
                                        <select id="COMPANY_ID" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 92%; height: 25px; display: inline-block; margin-right: 3px; background: #ebebf5;">
                                            <option value="0">0</option>
                                        </select>
                                    </td>
									<td class="col-title">판매경로</td>
									<td class="col-content-25">
<%--                                        <input type="input" class="view k-textbox col-input" id="SALE_ROOT" name="SALE_ROOT" value="3">--%>
                                        <select id="SALE_ROOT" class="k-dropdown-wrap k-state-default k-state-hover" data-role="dropdownlist" style="width: 92%; height: 25px; display: inline-block; margin-right: 3px; background: #ebebf5;">
                                            <option value="0">0</option>
                                        </select>
                                    </td>
								</tr>

								<tr>
									<td class="col-title">출고유형</td>
									<td class="col-content-25">
										<input type="radio" name="RELEASE_TYPE" value="1" checked/>택배
										<input type="radio" name="RELEASE_TYPE" value="2" />방문수령
										<input type="radio" name="RELEASE_TYPE" value="3" />화물
									</td>

								</tr>
								<tr>
									<td class="col-title">요청사항</td>
									<td class="col-content-25" style="height: 37px;"><input type="input" class="view k-textbox col-input" style="width: 226%; height: 30px;"id="DES" name="ETC"></td>
								</tr>

							</tbody>
						</table>
					</div>

					<%-- 고객 정보 --%>
					<div class="info">

						<div class="sub-header-title">
							<span class="pagetitle"><span class="header-title30"></span> 고객 정보 </span>
                            <div style="display: inline-block; float: right;">
                                <span style="margin-right: 15px"><input type="checkbox" id="chCopyUserInfo"> 수령인 정보 동일 </span>
                            </div>
						</div>

						<table id="tbl_consigned_receipt_customer_data" class="table_default">

							<tbody>

								<tr>
									<td class="col-title">고객명[1]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox col-input" id="CUSTOMER_NM_S" name="CUSTOMER_NM_S"></td>
									<td class="col-title">고객명[2]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox col-input" id="CUSTOMER_NM_R" name="CUSTOMER_NM_R"></td>
								</tr>

								<tr>
									<td class="col-title">전화번호[1]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="TEL_S" name="TEL_S" style="width:100%;"></td>
									<td class="col-title">전화번호[2]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="TEL_R" name="TEL_R" style="width:100%;"></td>
								</tr>

								<tr>
									<td class="col-title">휴대폰[1]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="MOBILE_S" name="MOBILE_S" style="width:100%;"></td>
									<td class="col-title">휴대폰[2]</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="MOBILE_R" name="MOBILE_R" style="width:100%;"></td>
								</tr>

								<tr>
									<td class="col-title" rowspan=2>주소</td>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="POSTAL_CD" name="POSTAL_CD" style="width:100%;" disabled></td>
									<td colspan="2" style="text-align: left;"><button onclick="fnSearchZipCode()" onsubmit="false" type="button" class="k-button" tabindex="1">우편번호 찾기</button></td>
								</tr>

								<tr>
									<td class="col-content-25"><input type="input" class="view k-textbox" id="ADDRESS" name="ADDRESS" style="width:100%;" disabled></td>
									<td colspan="2" style="width:50%;"><input type="input" class="view k-textbox" id="ADDRESS_DETAIL" name="ADDRESS_DETAIL" style="width:100%;"></td>
								</tr>

							</tbody>
						</table>
					</div>
<!-- 				</form> -->

			</fieldset>

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

				<div class="scrollable-div-long">

					<table class="stripe table_scroll">

						<tbody>

						<tr>
							<td class="col-title-20">모델</td>

							<td id="selected-list-MODEL">
								<div id="selected-list-model-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td style="width: 10%">
								<button id="searchBtn_model" onclick="searchItems('MODEL')" class="k-button col-search-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
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
							<td class="col-title-20">무선랜카드</td>

							<td id="selected-list-WIRELESSLAN">
								<div id="selected-list-wirelesslan-no-data" class="col-selected-product"> 선택된 항목 없음 </div>
							</td>

							<td>
								<button id="searchBtn_wirelesslan" onclick="searchItems('WIRELESSLAN')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
							</td>
						</tr>

						<tr>
							<td class="col-title-20">OS</td>

							<td id="selected-list-OS">
								<div id="selected-list-os-no-data" class="col-selected-product"> 선택된 항목 없음 </div>

							</td>

							<td>
								<button id="searchBtn_os" onclick="searchItems('OS')" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">찾기</button>
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

				<div class="scrollable-div-long">

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

