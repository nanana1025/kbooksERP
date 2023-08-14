<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="insertInventoryCopy"					value="/compInven/insertInventoryCopy.json" />
<c:url var="printCore"						value="/print/printCore.json"/>

<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

// var _CPUNAME = ["제조사","모델명","상세스펙","코드명","소켓","코어수"] ;
var _componentCd = getParameterByName('componentCd');
var _releaseId = getParameterByName('releaseId');
var _releases = getParameterByName('releases');
var _openerSid = getParameterByName('pid');
var _stock = getParameterByName('stock');


$(document).ready(function() {

	console.log("load [producePart.jsp]");



 	setTimeout(function() {
 		$('#saveBtn_${sid}').remove();

//  		var index = 0;
// 		$('#tbl_admin_produce_RELEASES_examine_list tr').each(function(){
// 			var tr = $(this);
// 			var td = tr.children();
// 			if(index >2  && index <9 )
// 				td.eq(0).text(_CPUNAME[index-3]);
// 			index++;
// 		});




		$('.k-i-windows').attr("onclick", 'fnSelectComponent();');

	 	var infCond = '<button id="insert_admin_create_component" onclick="fnComponentInsert()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';
	 	var infCondPrint= '<button id="insert_admin_create_print_component" onclick="fnComponentInsertPrint()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장&프린트</button>';
// 	 	var infCondPrint5001 = '<button id="insert_admin_create_print5001_component" onclick="fnComponentInsertPrint5001()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장&프린트(5001)</button>';
		var infCondPrintPort = '<label>프린터 포트 &nbsp;&nbsp;&nbsp;</label><input id="print_port" style = "width: 70px;"/>';

	 	$('#${sid}_view-btns').prepend(infCond);
		$('#${sid}_view-btns').prepend(infCondPrint);
	 	$('#${sid}_view-btns').prepend(infCondPrintPort);


//  		var openerGrid = opener.$('#admin_produce_RELEASES_all_list_gridbox').data('kendoGrid');
// 		var openerSelItem = openerGrid.dataItem(openerGrid.select());

		if(_releaseId == "") {
				GochigoAlert("출고번호를 가져올수 없습니다. 다시 시도해 주세요.", true, "dangol365 ERP");
			}


// 		console.log("componentCd = "+ _componentCd);
		console.log("_openerSid = "+_openerSid);
// 		console.log("_RELEASESId = "+_RELEASESId);
// 		console.log("_RELEASES = "+_RELEASES);

		$('.pagetitle').context.title = _componentCd;
		$(".pagetitle").html("<span class='k-icon k-i-copy'></span>"+_componentCd);
		$('#PART_NAME').val("부품을 선택하세요.");
// 		var componentCd = getParameterByName('componentCd');
		$('#RELEASE_ID').val(_releaseId);
		$('#RELEASES').val(_releases);
		$('#COMPONENT_CD').val(_componentCd);
// 	    $('#COMPONENT_CD').siblings('.k-formatted-value').val('CPU');
// 		$('#COMPONENT_CD').val($('.header_title').text().trim());
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

function fnSelectComponent(){

		fnWindowOpen_LTComponent("/layoutNewList.do?xn=consignedSelect_LT_"+_componentCd+"_LAYOUT","component_id","UW");
}


function fnComponentInsert() {

	var componentCd = $('.header_title').text().trim();
	var params;

	if("${sessionScope.userInfo.user_id}" == ""){
		GochigoAlert('세션 정보가 만료되었습니다. 로그아웃 후 다시 로그인해 주세요.');
		return;
	}

	if($('#RELEASE_ID').val() ==''){
		GochigoAlert('출고번호가 입력되지 않았습니다. 창을 닫고 다시 시도해 주세요.');
		return;
	}

	if($('#LT_CUSTOM_PART_ID').val() ==''){
		GochigoAlert('부품번호가 입력되지 않았습니다. 부품을 선택해주세요');
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

	params = {
			COMPONENT_CD : $('#COMPONENT_CD').val(),
			LT_CUSTOM_PART_ID : $('#LT_CUSTOM_PART_ID').val(),
 			MODEL_NM : $('#PART_NAME').val(),
			RELEASE_ID : $('#RELEASE_ID').val(),
			PART_CNT : $('#CNT').val(),
			REPRESENTATIVE_TYPE: 'O',
	        USER_ID: "${sessionScope.userInfo.user_id}",
	        LOCATION : $('#LOCATION').val()
	    };

	if( _componentCd == 'MON')
		params.MODEL_ID = $('#PART_NAME').val();
	else if( _componentCd == 'MBD')
		params.MBD_MODEL_NM = $('#PART_NAME').val();
	else if( _componentCd == 'MEM')
		params.BANDWIDTH = $('#PART_NAME').val();

	if(_stock == 'Y')
		params.STOCK = 'Y';



	 var url = '${insertInventoryCopy}';

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

	var componentCd = $('.header_title').text().trim();
	var params;

	if("${sessionScope.userInfo.user_id}" == ""){
		GochigoAlert('세션 정보가 만료되었습니다. 로그아웃 후 다시 로그인해 주세요.');
		return;
	}

	if($('#RELEASE_ID').val() ==''){
		GochigoAlert('출고번호가 입력되지 않았습니다. 창을 닫고 다시 시도해 주세요.');
		return;
	}

	if($('#LT_CUSTOM_PART_ID').val() ==''){
		GochigoAlert('부품번호가 입력되지 않았습니다. 부품을 선택해주세요');
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

	params = {
			COMPONENT_CD : $('#COMPONENT_CD').val(),
			LT_CUSTOM_PART_ID : $('#LT_CUSTOM_PART_ID').val(),
 			MODEL_NM : $('#PART_NAME').val(),
			RELEASE_ID : $('#RELEASE_ID').val(),
			PART_CNT : $('#CNT').val(),
			REPRESENTATIVE_TYPE: 'O',
 	        USER_ID: "${sessionScope.userInfo.user_id}",
	        LOCATION : $('#LOCATION').val()
	    };

	if( _componentCd == 'MON')
		params.MODEL_ID = $('#PART_NAME').val();
	else if( _componentCd == 'MBD')
		params.MBD_MODEL_NM = $('#PART_NAME').val();
	else if( _componentCd == 'MEM')
		params.BANDWIDTH = $('#PART_NAME').val();

	if(_stock == 'Y')
		params.STOCK = 'Y';

	var printPort = $('#print_port').val();
	var RELEASES = $('#RELEASES').val();

    var url = '${insertInventoryCopy}';
    var printUrl = '${printCore}';

    var isCreate = false;
    var msg = "";
    var listBarcode;
    var listInventory;
    var printParams;
    var componentId = -1;

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
			            	 listInventory = data.INVENTORY_ID;
			            	 params.COMPONENT_ID = data.COMPONENT_ID;
// 			            	 msg = data.MSG;
			            	//fnClose();
			            }
			            else{
// 			            	msg = data.MSG;
			                //fnClose();
			            }
			        }
			    });

// 			console.log(listBarcode);
// 			console.log(listBarcode[0]);
// 			console.log(listBarcode[1]);

		    if(isCreate){
				    printParams = {
							PORT: printPort,
							USER_ID: params.USER_ID,
							BARCODE: listBarcode.toString(),
							INVENTORY_ID: listInventory.toString(),
							COMPONENT_ID: params.COMPONENT_ID,
							COMPONENT_CD: params.COMPONENT_CD,
							REPRESENTATIVE_TYPE: 'O',
							RELEASES: RELEASES
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
		    	}

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
