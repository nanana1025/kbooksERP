<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="insertInventory"					value="/compInven/insertInventory.json" />
<c:url var="print"						value="/print/print.json"/>

<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

var _componentCd = getParameterByName('componentCd');
var _releaseId = getParameterByName('releaseId');
var _releases = getParameterByName('releases');
var _openerSid = getParameterByName('pid');
var _stock = getParameterByName('stock');
var _type = getParameterByName('type');

$(document).ready(function() {

	console.log("load [produceCreateComponent.jsp]");

 	setTimeout(function() {
 		$('#saveBtn_${sid}').remove();

	 	var infCond = '<button id="insert_admin_create_release_component" onclick="fnComponentInsert()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';
	 	var infCondPrint= '<button id="insert_admin_create_print_release_component" onclick="fnComponentInsertPrint()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장&프린트</button>';
// 	 	var infCondPrint5001 = '<button id="insert_admin_create_print5001_component" onclick="fnComponentInsertPrint5001()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장&프린트(5001)</button>';
		var infCondPrintPort = '<label>프린터 포트 &nbsp;&nbsp;&nbsp;</label><input id="print_port" style = "width: 70px;"/>';

	 	$('#${sid}_view-btns').prepend(infCond);
		$('#${sid}_view-btns').prepend(infCondPrint);
	 	$('#${sid}_view-btns').prepend(infCondPrintPort);

		if(_type != 1){
		 	if(_releaseId == "") {
				GochigoAlert("출고번호를 가져올수 없습니다. 다시 시도해 주세요.", true, "dangol365 ERP");
			}
		}

		$('#RELEASE_ID').val(_releaseId);
		$('#RELEASES').val(_releases);
		$('#COMPONENT_CD').val($('.header_title').text().trim());
// 		$('#COMPONENT_CD').val("${sessionScope.userInfo.user_id}");

		$('#CNT').removeAttr("readonly");
		$('#CNT').val('1');
// 		$('#CNT').attr("aria-valuenow", "1");
// 		$('.k-formatted-value').attr("aria-valuenow", "1");
// 		$('.k-formatted-value').attr("title", "1");

		var printPortValueArray = ["5000", "5001", "5002", "5003", "5004", "5005", "5006", "5007", "5008", "5009"];
		var printPortTextArray = ["5000",
									"5001",
									"5002",
									"5003",
									"5004",
									"5005",
									"5006",
									"5007",
									"5008",
									"5009"];

		var dataArray = new Array();

		for(var i = 0; i<printPortValueArray.length; i++){
			var datainfo = new Object();
			datainfo.text = printPortTextArray[i];
			datainfo.value =  printPortValueArray[i];
			dataArray.push(datainfo);
		}

		$("#print_port").kendoDropDownList({
	        dataTextField: "text",
	        dataValueField: "value",
	        dataSource: dataArray,
	        value:"5000",
	        height: 155
	      });

 	}, 500);

 	setTimeout(function() {
 		$('#CNT').removeAttr("readonly");
		$('#CNT').val('1');
 	}, 1000);


});

function fnClose(){
	console.log("load [fnClose.js]");

	if(typeof(opener) == "undefined" || opener == null) {
		history.back();
	} else {
		window.close();
	}
}


function fnComponentInsert() {

	var componentCd = $('.header_title').text().trim();
	var params;

	if("${sessionScope.userInfo.user_id}" == ""){
		GochigoAlert('세션 정보가 만료되었습니다. 로그아웃 후 다시 로그인해 주세요.');
		return;
	}

	if($('#LOCATION').val() ==''){
		GochigoAlert('재고위치를 선택해 주세요.');
		return;
	}

	var cnt = $('#CNT').val() * 1;

	if(!$.isNumeric(cnt)){
		GochigoAlert('생성개수에 숫자만 입력해주세요.');
		return;
	}
	if(cnt < 1){
		GochigoAlert('생성개수는 1이상 입력해 주세요.');
		return;
	}

	if(componentCd == "CAS"){

		if($('#CASE_CAT').val() == ''){
			GochigoAlert('메인보드 타입을 선택해 주세요.');
			return;
		}
		if($('#CASE_TYPE').val() == ''){
			GochigoAlert('케이스타입을 선택해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				CASE_CAT : $('#CASE_CAT').val(),
				CASE_TYPE : $('#CASE_TYPE').val(),
				RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "POW"){

		if($('#POW_CAT').val() == ''){
			GochigoAlert('파워타입을 선택해 주세요.');
			return;
		}
		if($('#POW_TYPE').val() == ''){
			GochigoAlert('정격출력을 선택해 주세요.');
			return;
		}
		if($('#POW_CLASS').val() == ''){
			GochigoAlert('인증사항을 선택해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				POW_CAT : $('#POW_CAT').val(),
				POW_TYPE : $('#POW_TYPE').val(),
				POW_CLASS : $('#POW_CLASS').val(),
				RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "ADP"){

		if($('#ADP_CAT').val() == ''){
			GochigoAlert('어댑터 구분을 선택해 주세요.');
			return;
		}
		if($('#OUTPUT_WATT').val() == ''){
			GochigoAlert('출력전압을 입력해 주세요.');
			return;
		}
		if($('#OUTPUT_AMPERE').val() == ''){
			GochigoAlert('용량을 입력해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				ADP_CAT : $('#ADP_CAT').val(),
				OUTPUT_WATT : $('#OUTPUT_WATT').val(),
				OUTPUT_AMPERE : $('#OUTPUT_AMPERE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "KEY"){

		if($('#KEY_CAT').val() == ''){
			GochigoAlert('연결방식을 선택해 주세요.');
			return;
		}
		if($('#KEY_TYPE').val() == ''){
			GochigoAlert('연결포트를 선택해 주세요.');
			return;
		}
		if($('#KEY_CLASS').val() == ''){
			GochigoAlert('키보드 형태를 선택해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				KEY_CAT : $('#KEY_CAT').val(),
				KEY_TYPE : $('#KEY_TYPE').val(),
				KEY_CLASS : $('#KEY_CLASS').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "MOU"){

		if($('#MOU_CAT').val() == ''){
			GochigoAlert('연결방식을 선택해 주세요.');
			return;
		}
		if($('#MOU_TYPE').val() == ''){
			GochigoAlert('연결포트를 선택해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				MOU_CAT : $('#MOU_CAT').val(),
				MOU_TYPE : $('#MOU_TYPE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "FAN"){

		if($('#FAN_CAT').val() == ''){
			GochigoAlert('팬 구분을 선택해 주세요.');
			return;
		}
		if($('#FAN_TYPE').val() == ''){
			GochigoAlert('팬 타입을 선택해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				FAN_CAT : $('#FAN_CAT').val(),
				FAN_TYPE : $('#FAN_TYPE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "CAB"){

		if($('#CAB_CAT').val() == ''){
			GochigoAlert('케이블 대분류를 선택해 주세요.');
			return;
		}
		if($('#CAB_TYPE').val() == ''){
			GochigoAlert('케이블 중분류를 선택해 주세요.');
			return;
		}
		if($('#CAB_CLASS').val() == ''){
			GochigoAlert('케이블 소분류를 선택해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				CAB_CAT : $('#CAB_CAT').val(),
				CAB_TYPE : $('#CAB_TYPE').val(),
				CAB_CLASS : $('#CAB_CLASS').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "BAT"){

		if($('#BAT_CAT').val() == ''){
			GochigoAlert('배터리구분을 선택해 주세요.');
			return;
		}
		if($('#OUTPUT_WATT').val() == ''){
			GochigoAlert('전압을 입력해 주세요.');
			return;
		}
		if($('#OUTPUT_AMPERE').val() == ''){
			GochigoAlert('용량을 입력해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				BAT_CAT : $('#BAT_CAT').val(),
				OUTPUT_WATT : $('#OUTPUT_WATT').val(),
				OUTPUT_AMPERE : $('#OUTPUT_AMPERE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "PKG"){

		if($('#PACKAGE_TYPE').val() == ''){
			GochigoAlert('대분류를 선택 해주세요');
			return;
		}
		if($('#CATEGORY').val() == ''){
			GochigoAlert('중분류를 선택 해주세요');
			return;
		}
		if($('#SIZE').val() == ''){
			GochigoAlert('사이즈를 선택해 주세요.');
			return;
		}

		params = {
				LOCATION : $('#LOCATION').val(),
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				PACKAGE_TYPE : $('#PACKAGE_TYPE').val(),
				CATEGORY : $('#CATEGORY').val(),
				SIZE : $('#SIZE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "AIR"){

		if($('#TYPE').val() == ''){
			GochigoAlert('대분류를 선택 해주세요');
			return;
		}
		if($('#CATEGORY').val() == ''){
			GochigoAlert('중분류를 선택 해주세요');
			return;
		}
		if($('#SIZE').val() == ''){
			GochigoAlert('사이즈를 선택해 주세요.');
			return;
		}

		params = {
				LOCATION : $('#LOCATION').val(),
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				TYPE : $('#TYPE').val(),
				CATEGORY : $('#CATEGORY').val(),
				SIZE : $('#SIZE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}

	params.REPRESENTATIVE_TYPE = 'O';
    var url = '${insertInventory}';

    var isCreate = false;
    var msg = "";

    $("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

		    for(var i = 0; i < cnt ; i++){

			    $.ajax({
			        url : url,
			        type : "POST",
			        data : JSON.stringify(params),
					contentType: "application/json",
			        async : false,
			        success : function(data) {
			            if(data.SUCCESS){
			            	isCreate = true;
			            	msg = data.MSG;
			            	//fnClose();
			            }
			            else{
			            	msg = data.MSG;
			                //fnClose();
			            }
			        }
			    });
		    }

		    GochigoAlert(msg);

		    if(isCreate)
		    	opener.fnObj('LIST_'+_openerSid).reloadGrid();

		  //끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "확인을 누르면 재고가 생성됩니다."
	}).data("kendoConfirm").open();
	//끝지점

}

function fnComponentInsertPrint() {

	var componentCd = $('.header_title').text().trim();
	var params;

	if("${sessionScope.userInfo.user_id}" == ""){
		GochigoAlert('세션 정보가 만료되었습니다. 로그아웃 후 다시 로그인해 주세요.');
		return;
	}

	if($('#LOCATION').val() ==''){
		GochigoAlert('재고위치를 선택해 주세요.');
		return;
	}

	var cnt = $('#CNT').val() * 1;

	if(!$.isNumeric(cnt)){
		GochigoAlert('생성개수에 숫자만 입력해주세요.');
		return;
	}
	if(cnt < 1){
		GochigoAlert('생성개수는 1이상 입력해 주세요.');
		return;
	}

	if(componentCd == "CAS"){

		if($('#CASE_CAT').val() == ''){
			GochigoAlert('메인보드 타입을 선택해 주세요.');
			return;
		}
		if($('#CASE_TYPE').val() == ''){
			GochigoAlert('케이스타입을 선택해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				CASE_CAT : $('#CASE_CAT').val(),
				CASE_TYPE : $('#CASE_TYPE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "POW"){

		if($('#POW_CAT').val() == ''){
			GochigoAlert('파워타입을 선택해 주세요.');
			return;
		}
		if($('#POW_TYPE').val() == ''){
			GochigoAlert('정격출력을 선택해 주세요.');
			return;
		}
		if($('#POW_CLASS').val() == ''){
			GochigoAlert('인증사항을 선택해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				POW_CAT : $('#POW_CAT').val(),
				POW_TYPE : $('#POW_TYPE').val(),
				POW_CLASS : $('#POW_CLASS').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "ADP"){

		if($('#ADP_CAT').val() == ''){
			GochigoAlert('어댑터 구분을 선택해 주세요.');
			return;
		}
		if($('#OUTPUT_WATT').val() == ''){
			GochigoAlert('출력전압을 입력해 주세요.');
			return;
		}
		if($('#OUTPUT_AMPERE').val() == ''){
			GochigoAlert('용량을 입력해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				ADP_CAT : $('#ADP_CAT').val(),
				OUTPUT_WATT : $('#OUTPUT_WATT').val(),
				OUTPUT_AMPERE : $('#OUTPUT_AMPERE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "KEY"){

		if($('#KEY_CAT').val() == ''){
			GochigoAlert('연결방식을 선택해 주세요.');
			return;
		}
		if($('#KEY_TYPE').val() == ''){
			GochigoAlert('연결포트를 선택해 주세요.');
			return;
		}
		if($('#KEY_CLASS').val() == ''){
			GochigoAlert('키보드 형태를 선택해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				KEY_CAT : $('#KEY_CAT').val(),
				KEY_TYPE : $('#KEY_TYPE').val(),
				KEY_CLASS : $('#KEY_CLASS').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "MOU"){

		if($('#MOU_CAT').val() == ''){
			GochigoAlert('연결방식을 선택해 주세요.');
			return;
		}
		if($('#MOU_TYPE').val() == ''){
			GochigoAlert('연결포트를 선택해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				MOU_CAT : $('#MOU_CAT').val(),
				MOU_TYPE : $('#MOU_TYPE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "FAN"){

		if($('#FAN_CAT').val() == ''){
			GochigoAlert('팬 구분을 선택해 주세요.');
			return;
		}
		if($('#FAN_TYPE').val() == ''){
			GochigoAlert('팬 타입을 선택해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				FAN_CAT : $('#FAN_CAT').val(),
				FAN_TYPE : $('#FAN_TYPE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "CAB"){

		if($('#CAB_CAT').val() == ''){
			GochigoAlert('케이블 대분류를 선택해 주세요.');
			return;
		}
		if($('#CAB_TYPE').val() == ''){
			GochigoAlert('케이블 중분류를 선택해 주세요.');
			return;
		}
		if($('#CAB_CLASS').val() == ''){
			GochigoAlert('케이블 소분류를 선택해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				CAB_CAT : $('#CAB_CAT').val(),
				CAB_TYPE : $('#CAB_TYPE').val(),
				CAB_CLASS : $('#CAB_CLASS').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "BAT"){

		if($('#BAT_CAT').val() == ''){
			GochigoAlert('배터리구분을 선택해 주세요.');
			return;
		}
		if($('#OUTPUT_WATT').val() == ''){
			GochigoAlert('전압을 입력해 주세요.');
			return;
		}
		if($('#OUTPUT_AMPERE').val() == ''){
			GochigoAlert('용량을 입력해 주세요.');
			return;
		}

		params = {
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				LOCATION : $('#LOCATION').val(),
				BAT_CAT : $('#BAT_CAT').val(),
				OUTPUT_WATT : $('#OUTPUT_WATT').val(),
				OUTPUT_AMPERE : $('#OUTPUT_AMPERE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "PKG"){

		if($('#PACKAGE_TYPE').val() == ''){
			GochigoAlert('대분류를 선택 해주세요');
			return;
		}
		if($('#CATEGORY').val() == ''){
			GochigoAlert('중분류를 선택 해주세요');
			return;
		}
		if($('#SIZE').val() == ''){
			GochigoAlert('사이즈를 선택해 주세요.');
			return;
		}

		params = {
				LOCATION : $('#LOCATION').val(),
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				PACKAGE_TYPE : $('#PACKAGE_TYPE').val(),
				CATEGORY : $('#CATEGORY').val(),
				SIZE : $('#SIZE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASES : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}
	else if(componentCd == "AIR"){

		if($('#TYPE').val() == ''){
			GochigoAlert('대분류를 선택 해주세요');
			return;
		}
		if($('#CATEGORY').val() == ''){
			GochigoAlert('중분류를 선택 해주세요');
			return;
		}
		if($('#SIZE').val() == ''){
			GochigoAlert('사이즈를 선택해 주세요.');
			return;
		}

		params = {
				LOCATION : $('#LOCATION').val(),
				MANUFACTURE_NM : $('#MANUFACTURE_NM').val(),
				MODEL_NM: $('#MODEL_NM').val(),
				TYPE : $('#TYPE').val(),
				CATEGORY : $('#CATEGORY').val(),
				SIZE : $('#SIZE').val(),
		        RELEASE_ID : $('#RELEASE_ID').val(),
		        RELEASE : $('#RELEASES').val(),
		        COMPONENT_CD : $('#COMPONENT_CD').val(),
		        USER_ID: "${sessionScope.userInfo.user_id}"
		    };
	}

	params.REPRESENTATIVE_TYPE = 'O';

	var printPort = $('#print_port').val();
	var userId = "${sessionScope.userInfo.user_id}";
	var RELEASES = $('#RELEASES').val();

    var url = '${insertInventory}';
    var printUrl = '${print}';

    var isCreate = false;
    var msg = "";
    var listBarcode= [];
    var printParams;

    $("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

		    for(var i = 0; i < cnt ; i++){

			    $.ajax({
			        url : url,
			        type : "POST",
			        data : JSON.stringify(params),
					contentType: "application/json",
			        async : false,
			        success : function(data) {
			            if(data.SUCCESS){
			            	isCreate = true;
			            	 listBarcode.push(data.BARCODE);
// 			            	msg = data.MSG;
			            	//fnClose();
			            }
			            else{
// 			            	msg = data.MSG;
			                //fnClose();
			            }
			        }
			    });
		    }

		    printParams = {
					PORT: printPort,
					USER_ID: userId,
					BARCODE: listBarcode.toString(),
					RELEASES: RELEASES,
					REPRESENTATIVE_TYPE: 'O'
			};

			$.ajax({
				url : printUrl,
				type : "POST",
				data : JSON.stringify(printParams),
				contentType: "application/json",
				async : false,
				success : function(data) {

				}
			});

		    if(isCreate)
		    	GochigoAlert("재고가 추가되었고, 프린트가 완료되었습니다.");
		    else
		    	GochigoAlert("오류가 발생했습니다. 관리자에게 문의하세요.");

		    if(isCreate)
		    	opener.fnObj('LIST_'+_openerSid).reloadGrid();

		  //끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "확인을 누르면 재고가 생성되고 바코드가 프린트("+printPort+") 됩니다."
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
