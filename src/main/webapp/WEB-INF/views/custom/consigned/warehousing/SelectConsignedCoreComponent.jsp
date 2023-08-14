<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="insertInventory"					value="/compInven/insertInventory.json" />
<c:url var="print"									value="/print/print.json"/>

<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

 var _componentCd = getParameterByName('componentCd');
 var _warehousingId = getParameterByName('warehousingId');
 var _warehousing = getParameterByName('warehousing');
 var _openerSid = getParameterByName('pid');
 var _representative_type = getParameterByName('representative_type');
 var _stock = getParameterByName('stock');

$(document).ready(function() {

	console.log("load [SelectConsignedCoreComponent.jsp]");

  	setTimeout(function() {
 		$('#saveBtn_${sid}').remove();

		$('.k-i-windows').attr("onclick", 'fnWindowOpen_LTComponent("/layoutSelectP.do?xn=Comp'+_componentCd+'_All_LAYOUT","component_id","UW");');

	 	var infCond = '<button id="insert_admin_produce_create_component" onclick="fnComponentInsert()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';
	 	var infCondPrint= '<button id="insert_admin_produce_create_print_component" onclick="fnComponentInsertPrint()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장&프린트</button>';
// 	 	var infCondPrint5001 = '<button id="insert_admin_produce_create_print5001_component" onclick="fnComponentInsertPrint5001()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장&프린트(5001)</button>';
		var infCondPrintPort = '<label>프린터 포트 &nbsp;&nbsp;&nbsp;</label><input id="print_port" style = "width: 70px;"/>';

	 	$('#${sid}_view-btns').prepend(infCond);
		$('#${sid}_view-btns').prepend(infCondPrint);
	 	$('#${sid}_view-btns').prepend(infCondPrintPort);


	 	if(_warehousingId == "") {
			GochigoAlert("입고번호를 가져올수 없습니다. 다시 시도해 주세요.", true, "dangol365 ERP");
		}

		$('#WAREHOUSING_ID').val(_warehousingId);
		$('#WAREHOUSING').val(_warehousing);
		$('#COMPONENT_CD').val(_componentCd);

		$('#CNT').removeAttr("readonly");

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

	console.log("load [fnComponentInsert.js]");

	var params;

// 	if("${sessionScope.userInfo.user_id}" == ""){
// 		GochigoAlert('세션 정보가 만료되었습니다. 로그아웃 후 다시 로그인해 주세요.');
// 		return;
// 	}

	if($('#WAREHOUSING').val() ==''){
		GochigoAlert('입고번호가 입력되지 않았습니다. 창을 닫고 다시 시도해 주세요.');
		return;
	}

	if($('#WAREHOUSING').val().length != 10){
		GochigoAlert('올바르지 않은 입고번호 입니다.');
		return;
	}

	if($('#COMPONENT_ID').val() ==''){
		GochigoAlert('부품번호가 입력되지 않았습니다. 부품을 선택해주세요');
		return;
	}

	if($('#LOCATION').val() ==''){
		GochigoAlert('재고위치를 선택해 주세요.');
		return;
	}

	if($('#USE_RANGE').val() ==''){
		GochigoAlert('사용위치를 선택해 주세요.');
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

	var initPrice = $('#INIT_PRICE').val() * 1;

	if(!$.isNumeric(initPrice)){
		GochigoAlert('입고금액에 숫자만 입력해주세요.');
		return;
	}
	if(initPrice < 0){
		GochigoAlert('입고금액은 0이상 입력해 주세요.');
		return;
	}

	var releasePrice = $('#RELEASE_PRICE').val() * 1;

	if(!$.isNumeric(releasePrice)){
		GochigoAlert('출고금액에 숫자만 입력해주세요.');
		return;
	}
	if(releasePrice < 0){
		GochigoAlert('출고금액은 0이상 입력해 주세요.');
		return;
	}

	params = {
			REPRESENTATIVE_TYPE: _representative_type,
			COMPONENT_CD : $('#COMPONENT_CD').val(),
			COMPONENT_ID : $('#COMPONENT_ID').val(),
			WAREHOUSING : $('#WAREHOUSING').val(),
			WAREHOUSING_ID: $('#WAREHOUSING_ID').val(),
			LOCATION : $('#LOCATION').val(),
			USE_RANGE : $('#USE_RANGE').val(),
			INIT_PRICE : $('#INIT_PRICE').val(),
			RELEASE_PRICE : $('#RELEASE_PRICE').val(),
			PART_CNT : $('#CNT').val(),
// 			CREATE_TYPE : "consigned",
			BULK_YN: "Y",
			CREATE_YN: "N",
//  	        USER_ID: "${sessionScope.userInfo.user_id}"
			USER_ID: 'shlee'
	    };

	if($('#RELEASE_COMPANY_ID').val() !='')
		params.RELEASE_COMPANY_ID = $('#RELEASE_COMPANY_ID').val();

	var url = '${insertInventory}';

    var isCreate = false;
    var msg = "";

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

	console.log("load [fnComponentInsert.js]");

	var params;

	if("${sessionScope.userInfo.user_id}" == ""){
		GochigoAlert('세션 정보가 만료되었습니다. 로그아웃 후 다시 로그인해 주세요.');
		return;
	}

	if($('#WAREHOUSING').val() ==''){
		GochigoAlert('입고번호가 입력되지 않았습니다. 창을 닫고 다시 시도해 주세요.');
		return;
	}

	if($('#WAREHOUSING').val().length != 10){
		GochigoAlert('올바르지 않은 입고번호 입니다.');
		return;
	}

	if($('#COMPONENT_ID').val() ==''){
		GochigoAlert('부품번호가 입력되지 않았습니다. 부품을 선택해주세요');
		return;
	}

	if($('#LOCATION').val() ==''){
		GochigoAlert('재고위치를 선택해 주세요.');
		return;
	}

	if($('#USE_RANGE').val() ==''){
		GochigoAlert('사용위치를 선택해 주세요.');
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

	var initPrice = $('#INIT_PRICE').val() * 1;

	if(!$.isNumeric(initPrice)){
		GochigoAlert('입고금액에 숫자만 입력해주세요.');
		return;
	}
	if(initPrice < 0){
		GochigoAlert('입고금액은 0이상 입력해 주세요.');
		return;
	}

	var releasePrice = $('#RELEASE_PRICE').val() * 1;

	if(!$.isNumeric(releasePrice)){
		GochigoAlert('출고금액에 숫자만 입력해주세요.');
		return;
	}
	if(releasePrice < 0){
		GochigoAlert('출고금액은 0이상 입력해 주세요.');
		return;
	}

	params = {
			COMPONENT_CD : $('#COMPONENT_CD').val(),
			WAREHOUSING : $('#WAREHOUSING').val(),
			WAREHOUSING_ID: $('#WAREHOUSING_ID').val(),
			MANUFACTURE_NM : $('#COL1').val(),
			MODEL_NM : $('#COL2').val(),
			LOCATION : $('#LOCATION').val(),
			USE_RANGE : $('#USE_RANGE').val(),
			INIT_PRICE : $('#INIT_PRICE').val(),
			RELEASE_PRICE : $('#RELEASE_PRICE').val(),
			PART_CNT : $('#CNT').val(),
// 			CREATE_TYPE : "consigned",
			BULK_YN: "Y",
 	        USER_ID: "${sessionScope.userInfo.user_id}"
// 			USER_ID: 'shlee'
	    };

	if($('#RELEASE_COMPANY_ID').val() !='')
		params.RELEASE_COMPANY_ID = $('#RELEASE_COMPANY_ID').val();

	if(_componentCd == 'CPU'){
		params.SPEC_NM = $('#COL3').val();
	}else if(_componentCd == 'MBD'){
		params.NB_NM = $('#COL2').val();
		params.SB_NM = $('#COL3').val();
		params.SYSTEM_VERSION = $('#COL2').val();
		params.MBD_MODEL_NM = $('#COL3').val();
	}else if(_componentCd == 'MEM'){
		params.CAPACITY = ($('#COL3').val()*1024)+"MBytes";
		params.MODULE_NM = $('#COL2').val();
		params.BANDWIDTH = $('#COL2').val();
	}else if(_componentCd == 'STG'){
		params.CAPACITY = $('#COL3').val();
	}else if(_componentCd == 'VGA'){
		params.CAPACITY = $('#COL3').val();
	}else if(_componentCd == 'MON'){
		params.SIZE = $('#COL3').val();
		params.MODEL_ID = $('#COL2').val();
	}

	if(_stock == 'Y')
		params.STOCK = 'Y';

	var printPort = $('#print_port').val();
	var warehousing = $('#WAREHOUSING').val();

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

			$.ajax({
		        url : url,
		        type : "POST",
		        data : JSON.stringify(params),
				contentType: "application/json",
		        async : false,
		        success : function(data) {
		            if(data.SUCCESS){
		            	isCreate = true;
		            	 listBarcode = data.BARCODE;
		            }
		        }
		    });

		    printParams = {
					PORT: printPort,
					USER_ID: "${sessionScope.userInfo.user_id}",
// 					USER_ID: 'shlee',
					BARCODE: listBarcode.toString(),
					WAREHOUSING: warehousing
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

function fnWindowOpen_LTComponent(url, callbackName, size) {
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
    console.log("111111111111111111");

	var xPos  = (document.body.clientWidth /2) - (width / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (height / 2);
    window.open("<c:url value='"+url+"'/>"+"&componentCd="+_componentCd+"&callbackName="+callbackName, "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}


</script>
