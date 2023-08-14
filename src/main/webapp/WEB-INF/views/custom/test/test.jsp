<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="loginCheck"					value="/member/loginCheckFromExternalSystem.json" />
<c:url var="checkComp"					value="/compInven/checkComponent.json"/>
<c:url var="httpTest"					value="/price/httpTest.json"/>
<c:url var="getPrice"					value="/price/getPrice.json"/>
<c:url var="getPriceInfo"					value="/price/getPriceInfo.json"/>
<c:url var="checkInven"					value="/compInven/checkInventory.json"/>
<c:url var="insertComp"					value="/compInven/insertComponent.json"/>
<c:url var="insertInven"				value="/compInven/insertInventory.json"/>
<c:url var="insertProduct"				value="/compInven/insertProduct.json"/>
<c:url var="print"						value="/print/print.json"/>
<c:url var="printProduct"						value="/print/printProduct.json"/>
<c:url var="GetWarehousingFromAsworld"						value="/compInven/GetWarehousingFromAsworld.json"/>
<c:url var="WarehousingExamineComplete"						value="/produce/WarehousingExamineComplete.json"/>

<c:url var="getCodeList"						value="/common/getCodeList.json"/>
<c:url var="priceMatching"						value="/priceMatching/priceMatching.json"/>
<c:url var="priceMatchingCPUAll"						value="/priceMatching/priceMatchingCPUAll.json"/>
<c:url var="priceMatchingComponent"						value="/priceMatching/priceMatchingComponent.json"/>

<c:url var="NtbCheck"						value="/inventoryCheck/NtbCheck.json"/>
<c:url var="printNtbCheck"						value="/print/printNtbCheck.json"/>
<c:url var="printAllInOneCheck"						value="/print/printAllInOneCheck.json"/>
<c:url var="printInventoryCheck"						value="/print/printInventoryCheck.json"/>
<c:url var="PriceTest"										value="/test/priceTest.json"/>
<c:url var="stgCheck"										value="/test/stgCheck.json"/>


<c:url var="TEST"						value="/print/Test.json"/>

<c:url var="gochigo"						value="/test/gochigo.json"/>
<c:url var="worldmemory"						value="/test/worldmemory.json"/>
<c:url var="worldmemory_price"						value="/test/worldmemory_price.json"/>
<c:url var="worldmemory_match"						value="/test/worldmemory_match.json"/>
<c:url var="tn_price"						value="/test/tn_price.json"/>

<c:url var="InvenUpdate"				value="/print1/InvenUpdate.json"/>
<c:url var="CompUpdate"					value="/print1/CompUpdate.json"/>

<c:url var="createReceipt"					value="/consigned/createReceipt.json"/>
<c:url var="createInvoice"					value="/consigned/createInvoice.json"/>



    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [test.js]");



	$('.basicBtn').remove();

	$('.k-grid-add').remove();

	setTimeout(function(){
		//$('.k-grid-delete').remove();
	},200);
});

function fnSiteMeshTest(){

	console.log("admin_test_list.fnTemp() Load");

 	var url = '/layoutCustom.do';

	var params = {
			USER_ID: "shlee"
	};


	window.location.href = '/layoutCustom.do';

// 	$.ajax({
// 		url : url,
// 		type : "POST",
// 		data : JSON.stringify(params),
// 		contentType: "application/json",
// 		async : false,
// 		success : function(data) {
// 			if(data.SUCCESS){
// 				GochigoAlert(data.MSG);
// 			}
// 			else
// 				GochigoAlert(data.MSG);
// 		}
// 	});
}

function fnHttpTest(){

	console.log("admin_test_list.fnHttpTest() Load");

 	var url = '${httpTest}';

	var params = {
			USER_ID: "shlee"
	};

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
			else
				GochigoAlert(data.MSG);
		}
	});
}

function fnTemp(){

	console.log("admin_test_list.fnTemp() Load");

 	var url = '${PriceTest}';

	var params = {
			USER_ID: "shlee"
	};

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
			else
				GochigoAlert(data.MSG);
		}
	});
}

function fnDownload()
{
	var url = "/test.zip";
	var browserName = undefined;
	var userAgent = navigator.userAgent;

	switch (true)
	{
		case /Trident|MSIE/.test(userAgent): browserName = 'ie';
			break;
		case /Edge/.test(userAgent): browserName = 'edge';
			break;
		case /Chrome/.test(userAgent): browserName = 'chrome';
			break;
		case /Safari/.test(userAgent): browserName = 'safari';
			break;
		case /Firefox/.test(userAgent): browserName = 'firefox';
			break;
		case /Opera/.test(userAgent): browserName = 'opera';
			break;
		default: browserName = 'unknown';
	}

	//ie 브라우저 및 EDGE 브라우저

	if (browserName == 'ie' || browserName == 'edge') {
		//ie11
		var _window = window.open(url, "_blank");
 		_window.document.close();
 		_window.document.execCommand('SaveAs', true, "file.hwp" || url)
 		_window.close();
		}
	else {
		//chrome
		var filename = url.substring(url.lastIndexOf("/") + 1).split("?")[0];
		var xhr = new XMLHttpRequest(); xhr.responseType = 'blob';
		xhr.onload = function () {
			var a = document.createElement('a');
			a.href = window.URL.createObjectURL(xhr.response);
			// xhr.response is a blob
			a.download = filename;
			// Set the file name.
			a.style.display = 'none';
			document.body.appendChild(a);
			a.click(); delete a;
		};

		xhr.open('GET', url);
		xhr.send();
	}
}

function fninsertInvoice()
{
	console.log("admin_test_list.fninsertInvoice() Load");


	var url = '${createInvoice}';


	var params1 = {
			INVOICE: "1234567890",
			DELIVERY_COMPANY: "1",
		};
	var params2 = {
			INVOICE: "ABCDEGHIJKL",
			DELIVERY_COMPANY: "2",
		};
	var params3 = {
			INVOICE: "가나다라마바사아",
			DELIVERY_COMPANY: "3",
		};


	var data = [];

	data.push(params1);
	data.push(params2);
	data.push(params3);

	var params = {
		PROXY_ID: 3,
		INVOICE: data

	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS, 송장 생성 성공");
				console.log(data);
		}
	});
}

function fninsertConsigned()
{
	console.log("admin_test_list.fninsertConsigned() Load");




	var url = '${createReceipt}';


	var params1 = {
			COMPONENT_ID:21,
			COMPONENT_CNT: 1,
			COMPONENT_CD: "CPU",
		};
	var params2 = {
			COMPONENT_ID:46,
			COMPONENT_CNT: 2,
			COMPONENT_CD: "MBD",
		};
	var params3 = {
			COMPONENT_ID:92,
			COMPONENT_CNT: 3,
			COMPONENT_CD: "MEM",
		};
	var params4 = {
			COMPONENT_ID:148,
			COMPONENT_CNT: 4,
			COMPONENT_CD: "STG",
		};
	var params5 = {
			COMPONENT_ID:188,
			COMPONENT_CNT: 5,
			COMPONENT_CD: "VGA",
		};

	var data = [];

	data.push(params1);
	data.push(params2);
	data.push(params3);
	data.push(params4);
	data.push(params5);




	var params = {
		MODEL_CD:"1",
		PC_TYPE: "2",
		GUARANTEE_DUE: 24,
		GUARANTEE_START: "2020-08-01",
		GUARANTEE_END: "2022-07-31",
		COMPANY_ID: 2,
		SALE_ROOT: "2",
		RELEASE_TYPE: "2",
		DES: "테스트",

		CUSTOMER_NM_S: "이상훈",
		TEL_S: "010-3651-3691",
		MOBILE_S: "010-3651-3691",

		CUSTOMER_NM_R: "김영국",
		TEL_R: "010-1234-5678",
		MOBILE_R: "010-1234-5678",
		POSTAL_CD: "12345",
		ADDRESS: "서울시 구로구 지하이시티 1214",

		DATA: data

	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS, 접수번호: "+data.RECEIPT);
				console.log(data);
		}
	});
}

function fnPrintNTBCheck()
{
	console.log("admin_test_list.fnPrintNTBCheck() Load");

	var url = '${printNtbCheck}';
	var params = {
		MBD:"LT2002000028",
		USER_ID: "shlee",
		PORT: "5001",
		CASE_DESTROYED: 0,
		CASE_SCRATCH: 1,
		CASE_STABBED: 2,
		CASE_PRESSED: 4,
		CASE_DISCOLORED: 15,
		CASE_HINGE: 1,
		DISPLAY: 2,
		BATTERY: 1,
		MOUSEPAD: 2,
		KEYBOARD: 2,
		CAM: 1,
		USB: 1,
		LAN_WIRELESS: 0,
		LAN_WIRED: 1,
		HDD: 7,
		ODD: 3,
		ADAPTER: 2,
		BIOS: 1,
		OS: 3
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS");
				console.log(data);
		}
	});
}

function fnPrintAllInOneCheck()
{
	console.log("admin_test_list.fnPrintAllInOneCheck() Load");

	var url = '${printAllInOneCheck}';
	var params = {
		MBD:"LT2002000028",
		USER_ID: "shlee",
		PORT: "5001",
		CASE_DESTROYED: 0,
		CASE_SCRATCH: 1,
		CASE_STABBED: 2,
		CASE_PRESSED: 4,
		CASE_DISCOLORED: 15,
		CASE_HINGE: 1,
		DISPLAY: 2,
		CAM: 1,
		USB: 1,
		SOUND: 1,
		LAN_WIRELESS: 0,
		LAN_WIRED: 1,
		HDD: 7,
		ODD: 3,
		ADAPTER: 2,
		BIOS: 1,
		OS: 3
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS");
				console.log(data);
		}
	});
}


function fnPrintMonCheck()
{
	console.log("admin_test_list.fnPrintMonCheck() Load");

	var url = '${printInventoryCheck}';
	var params = {
		BARCODE:"LT2002000028",
		USER_ID: "shlee",
		PORT: "5001",
		COMPONENT_CD:"MON",
		CASE_DESTROYED: 0,
		CASE_SCRATCH: 1,
		CASE_STABBED: 2,
		CASE_PRESSED: 4,
		CASE_DISCOLORED: 15,
		DISPLAY: 2,
		CPORT: 1,
		ADAPTER: 2
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
			GochigoAlert(data.MSG);
				console.log(data);
		}
	});
}

function fnPrintInvnetoryCheck()
{
	console.log("admin_test_list.fnPrintInvnetoryCheck() Load");

	var url = '${printInventoryCheck}';
	var params = {
			BARCODE:"LT2002000028",
			USER_ID: "shlee",
			PORT: "5001",
			COMPONENT_CD:"MBD",
			FAULT: 16383

	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
			GochigoAlert(data.MSG);
				console.log(data);
		}
	});
}

function fnNTBCheck()
{
	console.log("admin_test_list.fnNTBCheck() Load");

	var url = '${NtbCheck}';
	var params = {
		BARCODE:"LT2002000028",
		USER_ID: "shlee",
		TYPE: "2",
		CASE_DESTROYED: 0,
		CASE_SCRATCH: 1,
		CASE_STABBED: 2,
		CASE_PRESSED: 4,
		CASE_DISCOLORED: 15,
		CASE_HINGE: 1,
		DISPLAY: 2,
		BATTERY: 1,
		MOUSEPAD: 4,
		KEYBOARD: 2,
		CAM: 3,
		USB: 1,
		LAN_WIRELESS: 0,
		LAN_WIRED: 1,
		HDD: 2,
		ODD: 3,
		ADAPTER: 4,
		BIOS: 1,
		OS: 3
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
			GochigoAlert(data.MSG);
				console.log(data);
		}
	});
}

function fnPriceMatching( )
{
	console.log("admin_test_list.priceMatching() Load");

	var url = '${priceMatching}';
	var params = {
		COMPONENT_ID:18,
		COMPONENT_CD: "CPU",
		USER_ID: "shlee"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS");
				console.log(data);
		}
	});
}

function fnPriceMatchingCPUAll( )
{
	console.log("admin_test_list.fnPriceMatchingCPUAll() Load");

	var url = '${priceMatchingCPUAll}';
	var params = {
		COMPONENT_CD: "CPU",
		USER_ID: "shlee"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS");
				console.log(data);
		}
	});
}

function fnPriceMatchingMEM( )
{
	console.log("admin_test_list.fnPriceMatchingMEM() Load");

	var url = '${priceMatchingComponent}';
	var params = {
		COMPONENT_CD: "MEM",
		USER_ID: "shlee"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS");
				console.log(data);
		}
	});
}
function fnPriceMatchingMBD( )
{
	console.log("admin_test_list.fnPriceMatchingMEM() Load");

	var url = '${priceMatchingComponent}';
	var params = {
		COMPONENT_CD: "MBD",
		USER_ID: "shlee"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS");
				console.log(data);
		}
	});
}
function fnPriceMatchingVGA( )
{
	console.log("admin_test_list.fnPriceMatchingMEM() Load");

	var url = '${priceMatchingComponent}';
	var params = {
		COMPONENT_CD: "VGA",
		USER_ID: "shlee"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS");
				console.log(data);
		}
	});
}
function fnPriceMatchingSTG( )
{
	console.log("admin_test_list.fnPriceMatchingMEM() Load");

	var url = '${priceMatchingComponent}';
	var params = {
		COMPONENT_CD: "STG",
		USER_ID: "shlee"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS");
				console.log(data);
		}
	});
}
function fnPriceMatchingMON( )
{
	console.log("admin_test_list.fnPriceMatchingMEM() Load");

	var url = '${priceMatchingComponent}';
	var params = {
		COMPONENT_CD: "MON",
		USER_ID: "shlee"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS");
				console.log(data);
		}
	});
}

function fnCheckSTG()
{
	console.log("admin_test_list.fnCheckSTG() Load");

	var url = '${stgCheck}';
	var params = {
		USER_ID: "shlee"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS");
				console.log(data);
		}
	});
}


function fngetCodeList( )
{
	console.log("admin_test_list.fngetCodeList() Load");

	var url = '${getCodeList}';
	var params = {
		CODE : "CD0104"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
				GochigoAlert("SUCCESS");
				console.log(data);
		}
	});
}


function fnWarehousingExamileComplete( )
{
	console.log("admin_test_list.fnWarehousingExamileComplete() Load");

	var url = '${WarehousingExamineComplete}';
	var params = {
		WAREHOUSING : "U200418009",
		USER_ID : "shlee",
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
			if(data.SUCCESS)
				GochigoAlert(data.MSG);
			else
				GochigoAlert(data.MSG);
		}
	});
}


function fnCopyWarehousingFromAsworld(){

	console.log("admin_test_list.fnCopyWarehousingFromAsworld() Load");

	var url = '${GetWarehousingFromAsworld}';
	var params = {
		WAREHOUSING : "U200418009",
		USER_ID : "shlee",
		LOCATION : "LT",
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
			if(data.SUCCESS)
				GochigoAlert(data.MSG);
			else
				GochigoAlert(data.MSG);
		}
	});


	}


function TEST() {

	console.log("admin_test_list.TEST() Load");

	var url = '${TEST}';
	var params = {
		USER_ID : "test",
		PASSWD: "test123"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS)
				GochigoAlert(data.MSG);
			else
				GochigoAlert(data.MSG);
		}
	});
}

function GOCHIGO() {

	console.log("admin_test_list.GOCHIGO() Load");

	var url = '${gochigo}';
	var params = {
		USER_ID : "test",
		PASSWD: "test123"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS)
				GochigoAlert(data.MSG);
			else
				GochigoAlert(data.MSG);
		}
	});
}

function WORLDMEMORY() {

	console.log("admin_test_list.WORLDMEMORY() Load");

	var url = '${worldmemory}';
	var params = {
		USER_ID : "test",
		PASSWD: "test123"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS)
				GochigoAlert(data.MSG);
			else
				GochigoAlert(data.MSG);
		}
	});
}

function WORLDMEMORY_PRICE() {

	console.log("admin_test_list.WORLDMEMORY_PRICE() Load");

	var url = '${worldmemory_price}';
	var params = {
		USER_ID : "test",
		PASSWD: "test123"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS)
				GochigoAlert(data.MSG);
			else
				GochigoAlert(data.MSG);
		}
	});
}

function WORLDMEMORY_MATCH() {

	console.log("admin_test_list.WORLDMEMORY_MATCH() Load");

	var url = '${worldmemory_match}';
	var params = {
		USER_ID : "test",
		PASSWD: "test123"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS)
				GochigoAlert(data.MSG);
			else
				GochigoAlert(data.MSG);
		}
	});
}

function INSERT_TN_PRICE() {

	console.log("admin_test_list.INSERT_TN_PRICE() Load");

	var url = '${tn_price}';
	var params = {
		USER_ID : "test",
		PASSWD: "test123"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS)
				GochigoAlert(data.MSG);
			else
				GochigoAlert(data.MSG);
		}
	});
}



function fnloginCheckFromExternalSystem() {

	console.log("admin_test_list.fnloginCheckFromExternalSystem() Load");

	var url = '${loginCheck}';
	var params = {
		USER_ID : "test",
		PASSWD: "test123"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
			if(data.SUCCESS)
				GochigoAlert(data.MSG);
			else
				GochigoAlert(data.MSG);
		}
	});
}




function fncheckComponent() {

	console.log("admin_test_list.fncheckComponent() Load");

	var url = '${checkComp}';

	var params_CPU = {
			COMPONENT_CD: "CPU",
			MANUFACTURE_NM: "INTEL",
			MODEL_NM: "Intel Core i9 9600KF",
			SPEC_NM: "Intel(R) Core(TM) i9-9600KF CPU @ 3.70GHz",
			CODE_NM: "COFFEE LAKE",
			SOCKET_NM: "Socket 1151 V2",
			CORE_CNT: 6,
			THREAD_CNT: 6,
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_MBD = {
			COMPONENT_CD: "MBD",
			MANUFACTURE_NM: "ASUSTeK COMPUTER INC.",
			MODEL_NM: "H97-PRO",
			NB_NM: "Intel Haswell rev. 06",
			SB_NM: "Intel H97 rev. 00",
			SKU_NM: "All",
			FAMILY_NM: "",
			MEM_TYPE: "DDR3",
			MAX_MEM: 4,
			NO_OF_DIMM: "",
			SERIAL_NO: "150443475602679",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_MEM = {
			COMPONENT_CD: "MEM",
			MANUFACTURE_NM: "Galaxy Microsystems Ltd.",
			MODEL_NM: "ASDFASDF",
			MODULE_NM: "UDIMM",
			CAPACITY: "4096MBytes",
			BANDWIDTH: "DDR4-2132",
			VOLTAGE: "1.20 Volts",
			MEM_TYPE: "",
			MANUFACTURE_DT: "Week 27/Year 14",
			SERIAL_NO: "3892B950",
			LOCATION: "A",
			USER_ID: "shlee"
	};

	var params_VGA = {
			COMPONENT_CD: "VGA",
			TECH_NM: "NVIDIA",
			MANUFACTURE_NM: "PC Partner",
			MODEL_NM: "Radeon (TM) RX 470 Graphics",
			CODE_NM: "",
			CODE_FAMILY_NM: "",
			REVISION: "",
			CAPACITY: "4096 MBytes",
			MEM_TYPE: "GDDR5",
			BANDWIDTH: "",
			VENDOR_NM: "",
			SERIAL_NO: "",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_MON = {
			COMPONENT_CD: "MON",
			MANUFACTURE_NM: "123",
			MODEL_NM: "DELL P2311H",
			MODEL_ID: "DEL4067",
			SIZE: "23.1 inches",
			RESOLUTION: "1920 x 1080 @ 60 Hz",
			MANUFACTURED_DT: "Week 9, Year 2011",
			SERIAL_NO: "YTYKF12N1W3S",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_STG = {
			COMPONENT_CD: "STG",
			MANUFACTURE_NM: "WD",
			MODEL_NM: "WDC WD10EZEX-22BN5A0",
			STG_TYPE: "Fixed",
			CAPACITY: "931.5 GB",
			BUS_TYPE: "SATA",
			BANDWIDTH: "",
			SPEED: "7200 RPM",
			FEATURE: "SMART",
			REVISION: "",
			SERIAL_NO: "     WD-WCC3F7SET8HX", //TRIM 처리해야함
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_ADP = {
			COMPONENT_CD: "ADP",
			MANUFACTURE_NM: "TOP POWER",
			OUTPUT_AMPERE: 100,
			OUTPUT_WATT: 100,
			OUTPUT_TYPE: 200,
			CLASS_NM: "BRONZE",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_POW = {
			COMPONENT_CD: "POW",
			MANUFACTURE_NM: "TOP POWER",
			POW_TYPE: 100,
			OUTPUT_WATT: 100,
			CLASS_NM: "BRONZE",
			LOCATION: "LT",
			USER_ID: "shlee"
	};
	var params_CAS = {
			COMPONENT_CD: "CAS",
			MANUFACTURE_NM: "VOLTRON",
			CASE_TYPE: "BIG",
			LOCATION: "LT",
			USER_ID: "shlee"
	};


	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params_MEM),
		contentType: "application/json",
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				GochigoAlert(data.MSG);
				console.log(data.BARCODE);
				console.log(data.COMPONENT_ID);
				console.log(data.SPEC_NM);
				console.log(data.MODEL_NM);
			}
			else
				GochigoAlert(data.MSG);
		}
	});
}

function fncheckInven() {

	console.log("admin_test_list.fncheckInven() Load");

	var url = '${checkInven}';

	var params_CPU = {
			COMPONENT_CD: "CPU",
			MANUFACTURE_NM: "INTEL",
			MODEL_NM: "Intel Core i9 9600KF",
			SPEC_NM: "Intel(R) Core(TM) i9-9600KF CPU @ 3.70GHz",
			CODE_NM: "COFFEE LAKE",
			SOCKET_NM: "Socket 1151 V2",
			CORE_CNT: 6,
			THREAD_CNT: 6,
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_MBD = {
			COMPONENT_CD: "MBD",
			MANUFACTURE_NM: "ASUSTeK COMPUTER INC.",
			MODEL_NM: "H97-PRO",
			NB_NM: "Intel Haswell rev. 06",
			SB_NM: "Intel H97 rev. 00",
			SKU_NM: "All",
			FAMILY_NM: "",
			MEM_TYPE: "DDR3",
			MAX_MEM: 4,
			NO_OF_DIMM: "",
			SERIAL_NO: "150443475602679",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_MEM = {
			COMPONENT_CD: "MEM",
			MANUFACTURE_NM: "Samsung",
			MODEL_NM: "M378B1G73DB0-CK0 ",
			MODULE_NM: "",
			CAPACITY: "8192MBytes",
			BANDWIDTH: "PC3-12800",
			VOLTAGE: "1.50 Volts",
			MEM_TYPE: "",
			MANUFACTURE_DT: "Week 27/Year 14",
			SERIAL_NO: "3892B950",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_VGA = {
			COMPONENT_CD: "VGA",
			TECH_NM: "NVIDIA",
			MANUFACTURE_NM: "PC Partner",
			MODEL_NM: "Radeon (TM) RX 470 Graphics",
			CODE_NM: "",
			CODE_FAMILY_NM: "",
			REVISION: "",
			CAPACITY: "4096 MBytes",
			MEM_TYPE: "GDDR5",
			BANDWIDTH: "",
			VENDOR_NM: "",
			SERIAL_NO: "",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_MON = {
			COMPONENT_CD: "MON",
			MANUFACTURE_NM: "123",
			MODEL_NM: "DELL P2311H",
			MODEL_ID: "DEL4067",
			SIZE: "23.1 inches",
			RESOLUTION: "1920 x 1080 @ 60 Hz",
			MANUFACTURED_DT: "Week 9, Year 2011",
			SERIAL_NO: "YTYKF12N1W3S",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_STG = {
			COMPONENT_CD: "STG",
			MANUFACTURE_NM: "WD",
			MODEL_NM: "WDC WD10EZEX-22BN5A0",
			STG_TYPE: "Fixed",
			CAPACITY: "931.5 GB",
			BUS_TYPE: "SATA",
			BANDWIDTH: "",
			SPEED: "7200 RPM",
			FEATURE: "SMART",
			REVISION: "",
			SERIAL_NO: "     WD-WCC3F7SET8HX", //TRIM 처리해야함
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_ADP = {
			COMPONENT_CD: "ADP",
			MANUFACTURE_NM: "TOP POWER",
			OUTPUT_AMPERE: 100,
			OUTPUT_WATT: 100,
			OUTPUT_TYPE: 200,
			CLASS_NM: "BRONZE",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_POW = {
			COMPONENT_CD: "POW",
			MANUFACTURE_NM: "TOP POWER",
			POW_TYPE: 100,
			OUTPUT_WATT: 100,
			CLASS_NM: "BRONZE",
			LOCATION: "LT",
			USER_ID: "shlee"
	};
	var params_CAS = {
			COMPONENT_CD: "CAS",
			MANUFACTURE_NM: "VOLTRON",
			CASE_TYPE: "BIG",
			LOCATION: "LT",
			USER_ID: "shlee"
	};


	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params_CPU),
		contentType: "application/json",
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				GochigoAlert(data.MSG);
				console.log(data.BARCODE);
				console.log(data.COMPONENT_ID);
				console.log(data.SPEC_NM);
				console.log(data.MODEL_NM);
			}
			else
				GochigoAlert(data.MSG);
		}
	});
}

function fninsertComponent(){

	console.log("admin_test_list.fninsertComponent() Load");

	var url = '${insertComp}';

	var params_CPU = {
			COMPONENT_CD: "CPU",
			MANUFACTURE_NM: "INTEL",
			MODEL_NM: "Intel Core i9 9600KFSSSSSS",
			SPEC_NM: "Intel(R) Core(TM) i9-9600KFSSSSSS CPU @ 3.70GHz",
			CODE_NM: "COFFEE LAKE",
			SOCKET_NM: "Socket 1151 V2",
			CORE_CNT: 6,
			THREAD_CNT: 6,
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_MBD = {
			COMPONENT_CD: "MBD",
			MANUFACTURE_NM: "ASUSTeK COMPUTER INC111.",
			MODEL_NM: "M32CD_A_F_K20CD_K31CDA111",
			NB_NM: "Intel Skylake rev. 07",
			SB_NM: "Intel H81 rev. C1",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_MEM = {
			COMPONENT_CD: "MEM",
			MANUFACTURE_NM: "Galaxy Microsystems Ltd.",
			MODEL_NM: "ASDFASDF1",
			MODULE_NM: "UDIMM",
			CAPACITY: "4096MBytes",
			BANDWIDTH: "DDR4-2132",
			VOLTAGE: "1.20 Volts",
			MEM_TYPE: "",
			MANUFACTURE_DT: "Week 27/Year 14",
			SERIAL_NO: "3892B950",
			LOCATION: "A",
			USER_ID: "shlee"
	};


	var params_VGA = {
			COMPONENT_CD: "VGA",
			TECH_NM: "NVIDIA",
			MANUFACTURE_NM: "GIGABYTE",
			MODEL_NM: "NVIDIA GeForece RTX 2060",
			CODE_NM: "",
			CODE_FAMILY_NM: "",
			REVISION: "",
			CAPACITY: "6144 MBytes",
			MEM_TYPE: "GDDR5",
			BANDWIDTH: "",
			VENDOR_NM: "",
			SERIAL_NO: "",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_MON = {
			COMPONENT_CD: "MON",
			MANUFACTURE_NM: "SAMSUNG",
			MODEL_NM: "S27B24001",
			MODEL_ID: "SAM08EBB1",
			SIZE: "27.1 inches",
			RESOLUTION: "1920 x 1080 @ 60 Hz",
			MANUFACTURED_DT: "Week 9, Year 2011",
			SERIAL_NO: "YTYKF12N1W3SS",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_STG = {
			COMPONENT_CD: "STG",
			MANUFACTURE_NM: "WD",
			MODEL_NM: "WDC WD10EZEX-22BN5A0_SHLEE1",
			STG_TYPE: "Fixed",
			CAPACITY: "931.5 GB",
			BUS_TYPE: "SATA",
			BANDWIDTH: "",
			SPEED: "7200 RPM",
			FEATURE: "SMART",
			REVISION: "",
			PC_TYPE: 2,
			SERIAL_NO: "     WD-WCC3F7SET8HX", //TRIM 처리해야함
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_ADP = {
			COMPONENT_CD: "ADP",
			MANUFACTURE_NM: "TOP POWER_TEST",
			OUTPUT_AMPERE: 100,
			OUTPUT_WATT: 100,
			OUTPUT_TYPE: 200,
			CLASS_NM: "BRONZE",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_POW = {
			COMPONENT_CD: "POW",
			MANUFACTURE_NM: "TOP POWER",
			POW_TYPE: 500,
			OUTPUT_WATT: 500,
			CLASS_NM: "BRONZE",
			LOCATION: "LT",
			USER_ID: "shlee"
	};
	var params_CAS = {
			COMPONENT_CD: "CAS",
			MANUFACTURE_NM: "VOLTRON_TEST",
			CASE_TYPE: "BIG",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params_STG),
		contentType: "application/json",
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				GochigoAlert(data.MSG);
				console.log(data.COMPONENT_ID);
			}
			else
				GochigoAlert(data.MSG);
		}
	});
}

function fnGetPrice(){

	console.log("admin_test_list.fninsertComponent() Load");

	var url = '${getPrice}';

	var params = {
			SIGN_KEY : "TEST_SIGN_123",
			DATA_ID: 1,
			COMPONENT_CD: "CPU",
			MANUFACTURE_NM: "INTEL",
			MODEL_NM: "Intel Core i9 9600KF",
			SPEC_NM: "Intel(R) Core(TM) i9-9600KF CPU @ 3.70GHz",
			CODE_NM: "COFFEE LAKE",
			SOCKET_NM: "Socket 1151 V2",
			CORE_CNT: 6,
			THREAD_CNT: 6,
			LOCATION: "LT",
			USER_ID: "gochigo",
// 			IDX: 1,
			TYPE: "PC"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params),
		contentType: "application/json",
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				GochigoAlert(data.MSG);
// 				GochigoAlert(data.PRICE);
			}
			else
				GochigoAlert(data.MSG);
		}
	});
}

function fnGetPriceInfo(){

	console.log("admin_test_list.fninsertComponent() Load");

	var url = '${getPriceInfo}';

	var params_MEM1 = {
			DATA_ID:54,
			COMPONENT_CD: "MEM",
			MANUFACTURE_NM: "Galaxy Microsystems Ltd.11111111",
			MODEL_NM: "ASDFASDF11111",
			MODULE_NM: "UDIMM1111111",
			CAPACITY: "4096MBytes",
			BANDWIDTH: "DDR4-2132",
			VOLTAGE: "1.20 Volts",
			MEM_TYPE: "",
			MANUFACTURE_DT: "Week 27/Year 14",
			SERIAL_NO: "3892B950",
			LOCATION: "A",
			USER_ID: "shlee",

	};

	var params_MEM2 = {
			DATA_ID:14,
			COMPONENT_CD: "MEM",
			MANUFACTURE_NM: "Galaxy Microsystems Ltd.2222222",
			MODEL_NM: "ASDFASD22222222",
			MODULE_NM: "SO-DIMM",
			CAPACITY: "4096MBytes",
			BANDWIDTH: "DDR4-2132",
			VOLTAGE: "1.20 Volts",
			MEM_TYPE: "",
			MANUFACTURE_DT: "Week 27/Year 14",
			SERIAL_NO: "3892B950",
			LOCATION: "A",
			USER_ID: "shlee",

	};

	var params_CPU = {
			DATA_ID: 54,
			COMPONENT_CD: "CPU",
			MANUFACTURE_NM: "INTEL",
			MODEL_NM: "Intel Core i9 9600KF",
			SPEC_NM: "Intel(R) Core(TM) i9-9600KF CPU @ 3.70GHz",
			CODE_NM: "COFFEE LAKE",
			SOCKET_NM: "Socket 1151 V2",
			CORE_CNT: 6,
			THREAD_CNT: 6,
			LOCATION: "LT",
			USER_ID: "shlee",
	};

	var params_MBD = {
			DATA_ID:87,
			COMPONENT_CD: "MBD",
			MANUFACTURE_NM: "",
			MODEL_NM: "H81MDV3",
			NB_NM: "Intel Haswell rev. 06",
			SB_NM: "Intel H81 rev. C2",
			SKU_NM: "None",
			FAMILY_NM: "",
			MEM_TYPE: "DDR3",
			MAX_MEM: 4,
			NO_OF_DIMM: "",
			SERIAL_NO: "150443475602679",
			LOCATION: "LT",
			USER_ID: "shlee"
	};


	var params_VGA = {
			COMPONENT_CD: "VGA",
			TECH_NM: "NVIDIA",
			MANUFACTURE_NM: "PC Partner",
			MODEL_NM: "Radeon (TM) RX 470 Graphics_TEST",
			CODE_NM: "",
			CODE_FAMILY_NM: "",
			REVISION: "",
			CAPACITY: "4096 MBytes",
			MEM_TYPE: "GDDR5",
			BANDWIDTH: "",
			VENDOR_NM: "",
			SERIAL_NO: "",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_MON = {
			COMPONENT_CD: "MON",
			MANUFACTURE_NM: "123",
			MODEL_NM: "DELL P2311H",
			MODEL_ID: "DEL4067_TEST",
			SIZE: "23.1 inches",
			RESOLUTION: "1920 x 1080 @ 60 Hz",
			MANUFACTURED_DT: "Week 9, Year 2011",
			SERIAL_NO: "YTYKF12N1W3S",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_STG = {
			COMPONENT_CD: "STG",
			MANUFACTURE_NM: "WD",
			MODEL_NM: "WDC WD10EZEX-22BN5A0_TEST",
			STG_TYPE: "Fixed",
			CAPACITY: "931.5 GB",
			BUS_TYPE: "SATA",
			BANDWIDTH: "",
			SPEED: "7200 RPM",
			FEATURE: "SMART",
			REVISION: "",
			SERIAL_NO: "     WD-WCC3F7SET8HX", //TRIM 처리해야함
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_ADP = {
			COMPONENT_CD: "ADP",
			MANUFACTURE_NM: "TOP POWER_TEST",
			OUTPUT_AMPERE: 100,
			OUTPUT_WATT: 100,
			OUTPUT_TYPE: 200,
			CLASS_NM: "BRONZE",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_POW = {
			COMPONENT_CD: "POW",
			MANUFACTURE_NM: "TOP POWER",
			POW_TYPE: 500,
			OUTPUT_WATT: 500,
			CLASS_NM: "BRONZE",
			LOCATION: "LT",
			USER_ID: "shlee"
	};
	var params_CAS = {
			COMPONENT_CD: "CAS",
			MANUFACTURE_NM: "VOLTRON_TEST",
			CASE_TYPE: "BIG",
			LOCATION: "LT",
			USER_ID: "shlee"
	};


	var params_MEM = {
			MEM1: params_MEM1,
			MEM2: params_MEM2
	}


	var params = {
			SIGN_KEY: "TEST_SIGN_123",
			CPU: params_CPU,
			MBD: params_MBD,
			USER_ID: "gochigo",
// 			IDX: 3,
			TYPE: "PC"

	}

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
			else
				GochigoAlert(data.MSG);
		}
	});
}

function fninsertInventory(){

	console.log("admin_test_list.fninsertInventory() Load");

	var url = '${insertInven}';

	var params_CPU = {
			WAREHOUSING : "B200803001",
			COMPONENT_ID: 1027,
			COMPONENT_CD: "CPU",
			MANUFACTURE_NM: "INTEL",
			MODEL_NM: "인텔 코어i5 커피레이크-R 9600K(F) [3.7G]",
			SPEC_NM: "1",
			CODE_NM: "Coffee Lake",
			SOCKET_NM: "Socket 1151 LGA",
			CORE_CNT: 6,
			THREAD_CNT: 6,
			LOCATION: "A",
			USER_ID: "shlee"
	};

	var params_MBD = {
			WAREHOUSING : "B200803001",
			COMPONENT_ID: 69,
			COMPONENT_CD: "MBD",
			MANUFACTURE_NM: "",
			MODEL_NM: "RC420/RC520/RC720",
			NB_NM: "Intel Sandy Bridge rev. 09",
			SB_NM: "Intel HM65 rev. B2",
			SKU_NM: "System SKUNumber",
			FAMILY_NM: "",
			MEM_TYPE: "DDR3",
			MAX_MEM: 4,
			NO_OF_DIMM: "",
			SERIAL_NO: "150443475602654",
			LOCATION: "A",
			USER_ID: "shlee"
	};

	var params_MEM = {
			COMPONENT_CD: "MEM",
			MANUFACTURE_NM: "Samsung",
			MODEL_NM: "M378B1G73DB0-CK0 ",
			MODULE_NM: "",
			CAPACITY: "8192MBytes",
			BANDWIDTH: "PC3-12800",
			VOLTAGE: "1.50 Volts",
			MEM_TYPE: "",
			MANUFACTURE_DT: "Week 27/Year 14",
			SERIAL_NO: "3892B950",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_VGA = {
			COMPONENT_CD: "VGA",
			TECH_NM: "NVIDIA",
			MANUFACTURE_NM: "PC Partner",
			MODEL_NM: "Radeon (TM) RX 470 Graphics",
			CODE_NM: "",
			CODE_FAMILY_NM: "",
			REVISION: "",
			CAPACITY: "4096 MBytes",
			MEM_TYPE: "GDDR5",
			BANDWIDTH: "",
			VENDOR_NM: "",
			SERIAL_NO: "",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_MON = {
			COMPONENT_CD: "MON",
			MANUFACTURE_NM: "123",
			MODEL_NM: "DELL P2311H",
			MODEL_ID: "DEL4067",
			SIZE: "23.1 inches",
			RESOLUTION: "1920 x 1080 @ 60 Hz",
			MANUFACTURED_DT: "Week 9, Year 2011",
			SERIAL_NO: "YTYKF12N1W3S",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_STG = {
			COMPONENT_CD: "STG",
			MANUFACTURE_NM: "WD",
			MODEL_NM: "WDC WD10EZEX-22BN5A0",
			STG_TYPE: "Fixed",
			CAPACITY: "931.5 GB",
			BUS_TYPE: "SATA",
			BANDWIDTH: "",
			SPEED: "7200 RPM",
			FEATURE: "SMART",
			REVISION: "",
			SERIAL_NO: "     WD-WCC3F7SET8HX", //TRIM 처리해야함
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_ADP = {
			COMPONENT_CD: "ADP",
			MANUFACTURE_NM: "TOP POWER",
			OUTPUT_AMPERE: 100,
			OUTPUT_WATT: 100,
			OUTPUT_TYPE: 200,
			CLASS_NM: "BRONZE",
			LOCATION: "LT",
			USER_ID: "shlee"
	};

	var params_POW = {
			COMPONENT_CD: "POW",
			MANUFACTURE_NM: "TOP POWER",
			POW_TYPE: 100,
			OUTPUT_WATT: 100,
			CLASS_NM: "BRONZE",
			LOCATION: "LT"
	};
	var params_CAS = {
			COMPONENT_CD: "CAS",
			MANUFACTURE_NM: "VOLTRON",
			CASE_TYPE: "BIG",
			LOCATION: "LT",
			USER_ID: "shlee"
	};


	$.ajax({
		url : url,
		type : "POST",
		data : JSON.stringify(params_MBD),
		contentType: "application/json",
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				GochigoAlert(data.MSG);
				console.log(data.COMPONENT_ID);
			}
			else
				GochigoAlert(data.MSG);
		}
	});
}




function fninsertProduct(){

	console.log("admin_test_list.fninsertProduct() Load");

	var url = '${insertProduct}';

	var partList = ['5', '17', '33','57', '22', '32','4', '16'];
	var params = {
			USER_ID: "shlee",
			INVENTORY_ID: 30,
			C_INVENTORY_ID: JSON.stringify(partList),
			LOCATION: "LT"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				GochigoAlert(data.MSG);
				console.log(data.COMPONENT_ID);
			}
			else
				GochigoAlert(data.MSG);
		}
	});
}

function fnPrint(){

	console.log("admin_test_list.fnPrint() Load");

	var url = '${print}';


	var params = {
			PORT: "5001",
			USER_ID: "shlee",
			BARCODE: "LT2002000015",
			WAREHOUSING: "U200417001"
	};

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
			else
				GochigoAlert(data.MSG);
		}
	});
}

function fnPrintProduct(){

	console.log("admin_test_list.printProduct() Load");

	var url = '${printProduct}';


	var params = {
			PORT: "5001",
			USER_ID: "shlee",
 			WAREHOUSING:"B200427001",
			CPU: "LT2002000016",
			MEM: "LT2004000082",
			MBD: "LT2002000026"
	};

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
			else
				GochigoAlert(data.MSG);
		}
	});
}

function fnInvenDBUpdate(){

	console.log("admin_test_list.fnInvenDBUpdate() Load");

	var url = '${InvenUpdate}';


	var params = {
			USER_ID: "shlee",
			BARCODE: "CP15091912290085"
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				GochigoAlert(data.MSG);
				console.log(data.COMPONENT_ID);
			}
			else
				GochigoAlert(data.MSG);
		}
	});
}



function fnCompDBUpdate(){

	console.log("admin_test_list.fnCompDBUpdate() Load");

	var url = '${CompUpdate}';


	var params = {
			USER_ID: "shlee",
			BARCODE_ID: "1"
	};

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
			else
				GochigoAlert(data.MSG);
		}
	});
}

</script>
