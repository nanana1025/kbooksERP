<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="getCodeListCustom"					value="/common/getCodeListCustom.json" />
<c:url var="dataList"					value="/customDataList.json" />
<c:url var="consignedProcess"					value="layoutCustom.do" />
<c:url var="consignedPopup"					value="/CustomP.do"/>


    <script src="/codebase/gochigo.kendo.ui.js"></script>

<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [consignedAll.js]");
	// $('.basicBtn').remove();
	 $('#${sid}_deleteBtn').remove();
	 $('#${sid}_insertBtn').remove();
	 $('#${sid}_gridbox').off('dblclick');




	var infCondDate ='<button id="btnNewReceipt" onclick="fnNewReceipt()" class="k-button" style="float: left; width: 40px; background-color: slategray; margin-top:40px;margin-left:10px; padding: 3px 7px 3px 7px; font-size: 12px;">\
		<span class="k-icon k-i-track-changes" style="float: right; font-size: 18px; color: white;"></span>\
		</button>\
		<div style="border: 0px solid gold; float: left; width: 72%;">\
	<table align="right" id="tbl_consigned_receipt_customer_data">\
		<tbody>\
	<tr style="" class="">\
		<td style="text-align:right;">접수일자</td>\
		<td><input id="datetimepicker_acceptance_start" title="datetimepicker" style="width:100%;" /></td>\
		<td style="text-align:right;">~</td>\
		<td><input id="datetimepicker_acceptance_end" title="datetimepicker"style="width:100%;" /></td>\
		<td style="text-align:right;">접수번호</td>\
		<td><input type="input" class="view k-textbox" id="RECEIPT" name="RECEIPT" style="width:100%;" ></td>\
		<td style="text-align:right;">제품유형</td>\
		<td width = 120><select id="PC_TYPE" class="k-dropdown-wrap k-state-default k-state-hover"  style="width:78%;" data-role="dropdownlist"><option value="0">선택</option></select></td>\
		<td style="text-align:right;">고객명</td>\
		<td><input type="input" class="view k-textbox" id="CUSTOMER_NM" name="CUSTOMER_NM" style="width:100%;" ></td>\
		<td style="text-align:right;">관리번호</td>\
		<td><input type="input" class="view k-textbox" id="BARCODE" name="BARCODE" style="width:100%;"></td>\
	</tr><tr style="" class="">\
		<td style="text-align:right;">완료일자</td>\
		<td><input id="datetimepicker_complete_start" title="datetimepicker" style="width:100%;" /></td>\
		<td style="text-align:right;">~</td>\
		<td><input id="datetimepicker_complete_end" title="datetimepicker" style="width:100%;" /></td>\
		<td style="text-align:right;">판매처</td>\
		<td><select id="COMPANY_ID" class="k-dropdown-wrap k-state-default k-state-hover"  style="width:78%;" data-role="dropdownlist"><option value="0">선택</option></td>\
		<td style="text-align:right;">모델명</td>\
		<td><select id="MODEL_CD" class="k-dropdown-wrap k-state-default k-state-hover"  style="width:78%;" data-role="dropdownlist"><option value="0">선택</option></td>\
		<td style="text-align:right;">진행상태</td>\
		<td><select id="PROXY_STATE" class="k-dropdown-wrap k-state-default k-state-hover"  style="width:78%;" data-role="dropdownlist"><option value="-1">선택</option></select></td>\
		<td style="text-align:right;">고객번호</td>\
		<td><input type="input" class="view k-textbox" id="CUSTOMER_NO" name="CUSTOMER_NO" style="width:100%;"></td>\
	</tr></tbody>\
</table>\
</div>\
	<div style="border: 0px solid gold; float: left; width: 15%;">\
			<button id="consigned_search" onclick="fnConsignedData()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1" style="margin-top: 35px; margin-left: 20px;">검색</button>\
</div>';

	$('#consigned_all_list_Joborder_printBtn').css('float', 'right');
	$('#consigned_all_list_Joborder_printBtn').css('margin-top', '35px');
    $('#consigned_all_list_printBtn').css('margin-top', '35px');
    $('#consigned_all_list_printBtn').css('float', 'right');
    $('#consigned_all_list_printBtn').text("리스트 출력")

	$('#${sid}_btns').prepend(infCondDate);
//     $('#${sid}_btns').prepend(infCondDate);
	fnInitData();


	$("#datetimepicker_acceptance_start").kendoDatePicker({
//      change: fnDropBoxonChange
   });
	$("#datetimepicker_acceptance_end").kendoDatePicker({
//      change: fnDropBoxonChange
 });

	$("#datetimepicker_complete_start").kendoDatePicker({
//      change: fnDropBoxonChange
   });
	$("#datetimepicker_complete_end").kendoDatePicker({
//      change: fnDropBoxonChange
 });

	setTooltipOnIcon($("[id*='btnNewReceipt"), "접수");

    fuChangeDivWidth();

//     fnDropBoxonChange();

});

function setTooltipOnIcon(variable, context){

	var tooltipText = context;

	variable.kendoTooltip({
			content: tooltipText,
		callout: false
	});
}

function fnNewReceipt(){
	var newUrl = '/layoutCustom.do?content=receipt';
	 window.location.href = newUrl;
}

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}


function fnInitData() {

	console.log("CompanyList.fnCompanyInsert() Load");

	var url = '${getCodeListCustom}';

	var isSuccess = false;

	var listCode = [];
	listCode.push("CD0902");
	listCode.push("CD0903");

	var listCustom = [];
	listCustom.push("TN_MODEL_LIST");
	listCustom.push("TN_COMPANY_MST");

	var listCustomKey = [];
	listCustomKey.push("MODEL_NM");
	listCustomKey.push("MODEL_LIST_ID");
	listCustomKey.push("COMPANY_NM");
	listCustomKey.push("COMPANY_ID");

	var listCustomContition = [];
	listCustomContition.push("1=1");
	listCustomContition.push("COMPANY_TYPE = 'C'");

	var listCustomOrder = [];
	listCustomOrder.push("MODEL_LIST_ID");
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

 			var listProxyState= data.CD0902;
 			for(var i=0; i<listProxyState.length; i++)
 				$("#PROXY_STATE").append('<option value="' + listProxyState[i].V+ '">' + listProxyState[i].K+ '</option>');

 			var listModelCd = data.TN_MODEL_LIST;
 			for(var i=0; i<listModelCd.length; i++)
 				$("#MODEL_CD").append('<option value="' + listModelCd[i].V+ '">' + listModelCd[i].K+ '</option>');

 			var listCompanyId = data.TN_COMPANY_MST;
 			for(var i=0; i<listCompanyId.length; i++)
 				$("#COMPANY_ID").append('<option value="' + listCompanyId[i].V+ '">' + listCompanyId[i].K+ '</option>');

		}
	});


}


function fnConsignedData() {

	console.log("CompanyList.fnConsignedData() Load");

	var acceptanceStartDt = $('#datetimepicker_acceptance_start').val() ;
   	var acceptanceEndDt = $('#datetimepicker_acceptance_end').val();

   	var completeStartDt = $('#datetimepicker_complete_start').val();
   	var completeEndDt = $('#datetimepicker_complete_end').val();

	var RECEIPT = $('#RECEIPT').val();
	var PC_TYPE = $('#PC_TYPE').val();
	var CUSTOMER_NM = $('#CUSTOMER_NM').val();
	var BARCODE = $('#BARCODE').val();
	var COMPANY_ID = $('#COMPANY_ID').val();
	var MODEL_ID = $('#MODEL_CD').val();
	var PROXY_STATE = $('#PROXY_STATE').val();
	var CUSTOMER_NO = $('#CUSTOMER_NO').val();


	var params = {};
	var query = "";

	if(acceptanceStartDt != ''){
		params.RECEIPT_DT_S = acceptanceStartDt;
		query += 'RECEIPT_DT_S='+acceptanceStartDt+ " 00:00:00";
	}
	if(acceptanceEndDt != ''){
		params.RECEIPT_DT_E = acceptanceEndDt;
		query += '&RECEIPT_DT_E='+acceptanceEndDt+ " 23:59:59";
	}
	if(completeStartDt != ''){
		params.COMPLETE_DT_S = completeStartDt;
		query += '&COMPLETE_DT_S='+completeStartDt+ " 00:00:00";
	}
	if(completeEndDt != ''){
		params.COMPLETE_DT_E = completeEndDt;
		query += '&COMPLETE_DT_E='+completeEndDt+ " 23:59:59";
	}
	if(RECEIPT != ''){
		params.RECEIPT = RECEIPT;
		query += '&RECEIPT='+RECEIPT;
	}
	if(PC_TYPE != 0){
		params.PC_TYPE = PC_TYPE;
		query += '&PC_TYPE='+PC_TYPE;
	}
	if(CUSTOMER_NM != ''){
		params.CUSTOMER_NM = CUSTOMER_NM;
		query += '&CUSTOMER_NM='+CUSTOMER_NM;
	}
	if(COMPANY_ID != 0){
		params.COMPANY_ID = COMPANY_ID;
		query += '&COMPANY_ID='+COMPANY_ID;
	}
	if(MODEL_ID != 0){
		params.MODEL_ID = MODEL_ID;
		query += '&MODEL_ID='+MODEL_ID;
	}
	if(PROXY_STATE >= 0){
		params.PROXY_STATE = PROXY_STATE;
		query += '&PROXY_STATE='+PROXY_STATE;
	}
	if(CUSTOMER_NO != ''){
		params.CUSTOMER_NO = CUSTOMER_NO;
		query += '&CUSTOMER_NO='+CUSTOMER_NO;
	}



	fnObj('LIST_${sid}').reloadGridCustomConsigned(query);

}

function fnPrintJobOrder(){

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.return_yn == 1){
		GochigoAlert('출고중인 경우만 출력가능합니다.'); return;
	}

	 var width, height;

	    var url = '${consignedPopup}';

		var query = "?content=consignedOrderSheet&KEY=PROXY_ID&PROXY_ID="+selItem.proxy_id;

		var width, height;

		width = "811";
 		height = "842";

		var xPos  = (document.body.clientWidth /2) - (width / 2);
	    xPos += window.screenLeft;
	    var yPos  = (screen.availHeight / 2) - (height / 2);

	    window.open("<c:url value='"+url+query+"'/>", "consignedJobOrderPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
}


function fnDropBoxonChange(){

	console.log("${sid}.fnDropBoxonChange() Load");

	var url = '${dataList}';

	var check = $('#company_state_check').val();
	var cobjectid = "DEL_YN";

	var qStr = "";

	qStr += '&cobjectid=' + cobjectid;
    qStr += '&cobjectval=' + check;


    fnObj('LIST_${sid}').reloadGridCustom(qStr);
}


function customfunction_RECEIPT(){

	var url = '${consignedProcess}';

	setTimeout(function() {
		var grid = $('#${sid}_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

		var proxyState = selItem.proxy_state * 1;
		var content;
		var query;
		if(proxyState < 5){ //반품
			params = {
					content: "process",
					KEY: "PROXY_ID",
					VALUE: selItem.proxy_id
				};
			query = "?content="+params.content+"&KEY="+params.KEY+"&"+params.KEY+"="+params.VALUE;
		}else{
			params = {
					content: "return",
					KEY: "PROXY_ID",
					VALUE: selItem.proxy_id,
					KEY1: "P_PROXY_ID",
					VALUE1: selItem.p_proxy_id
				};
			query = "?content="+params.content+"&KEY="+params.KEY+"&"+params.KEY+"="+params.VALUE+"&KEY1="+params.KEY1+"&"+params.KEY1+"="+params.VALUE1;
		}

		window.location.href = url+query;


	}, 10);

}

function customfunction_INVOICE(){
// 	console.log("되는건가요?!?!?!?");

	setTimeout(function() {
		var grid = $('#${sid}_gridbox').data('kendoGrid');
		var selItem = grid.dataItem(grid.select());
		if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


		if(selItem.invoice == ''){return;}
		var params = {
				content: "process",
				KEY: "PROXY_ID",
				VALUE: selItem.proxy_id
			};

		fnWindowOpenInvoice("/layoutNewList.do?xn=consigned_Invoice_LAYOUT&KEY="+params.KEY+"&VALUE="+params.VALUE,"component_id","S");

	}, 10);



}

function fnWindowOpenInvoice(url, callbackName, size) {
    var width, height;
    if(size == "S"){
    	width = "800";
    	height = "400";
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
    window.open("<c:url value='"+url+"'/>"+"&callbackName="+callbackName, "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
}


function fnCreateOrder(){


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
		GochigoAlertCollback('전화번호[1]과 전화번호[1] 중 하나는 필수 정보입니다.', false, "dangol365 ERP","MOBILE_S");
    	return;
	}
	if(customerNmR == ''){
     	GochigoAlertCollback('고객명[2]는 필수 정보입니다..', false, "dangol365 ERP","CUSTOMER_NM_R");
    	return;
	}
	if(TelR == '' && mobileR== ''){
     	GochigoAlertCollback('전화번호[2]와 전화번호[2] 중 하나는 필수 정보입니다.', false, "dangol365 ERP","MOBILE_R");
    	return;
	}
	if(postalCd == ''){
     	GochigoAlertCollback('주소는 필수 정보입니다.', false, "dangol365 ERP","searchBtn_postalCode");
    	return;
	}
	if(addressDetail == ''){
     	GochigoAlertCollback('상세 주소를 입력하세요.', false, "dangol365 ERP","ADDRESS_DETAIL");
    	return;
	}

	var params = {
		PC_TYPE: $('#PC_TYPE').val(),
		GUARANTEE_DUE: $('#GUARANTEE_DUE').val(),
		GUARANTEE_START: $('#datetimepicker_acceptance_start').val(),
		GUARANTEE_END: $('#datetimepicker_acceptance_end').val(),

		COMPANY_ID: $('#COMPANY_ID').val(),
		SALE_ROOT: $('#SALE_ROOT').val(),
		RELEASE_TYPE: $('#RELEASE_TYPE').val(),
		DES: $('#DES').val(),

		customerNmS: customerNmS,
		customerNmR: customerNmR,
		TelS: TelS,
		TelR: TelR,
		mobileS: mobileS,
		mobileR: mobileR,
		postalCd: postalCd,
		address: address,
		addressDetail: addressDetail
	}




}


































</script>
