<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:url var="getInventoryCheckInfo"					value="/inventoryCheck/getInventoryCheckInfo.json" />
<c:url var="NtbCheckForWeb"							value="/inventoryCheck/NtbCheckForWeb.json" />
<c:url var="printNtbCheck2ndEditionForWeb"					value="/print/printNtbCheck2ndEditionForWeb.json" />

<html>
	<title>노트북 검수</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<meta charset="utf-8"/>

	<link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/fonts/NotoSansKR/stylesheets/NotoSansKR-Hestia.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
	<link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

    <script src="/js/jquery-1.12.4.js"></script>
	<script src="/codebase/kendo/kendo.all.min.js"></script>
	<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
	<script src="/codebase/kendo/messages/kendo.messages.ko-KR.min.js"></script>
	<script src="/codebase/kendo/jszip.min.js"></script>
    <script src="/codebase/common.js"></script>
    <script src="/codebase/default.js"></script>
    <script src="/codebase/gochigo.kendo.common.js"></script>
    <script src="/codebase/gochigo.kendo.util.js"></script>
    <script src="/codebase/gochigo.kendo.ui.js"></script>

	<style type="text/css">
	    .tg  {margin: 30px; border-collapse:collapse;border-color:#ccc;border-spacing:0;}
	    .tg td{background-color:#fff;border-color:#ccc;border-style:solid;border-width:1px;color:#333;
	        font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 10px;word-break:normal;}
	    .tg th{background-color:#f0f0f0;border-color:#ccc;border-style:solid;border-width:1px;color:#333;
	        font-family:Arial, sans-serif;font-size:14px;font-weight:normal;overflow:hidden;padding:15px 15px;word-break:normal;}
	    .tg .tg-cly1{text-align:left;vertical-align:middle}
	    .tg .tg-buh4{background-color:#f9f9f9;text-align:left;vertical-align:middle}
	    .tg .tg-0lax{text-align:left;vertical-align:top}
	    .tg .tg-yjjc{background-color:#f9f9f9;text-align:left;vertical-align:middle}
	    .tg .tg-shlee{
						    border-top-width: 0px;
						    border-bottom-width: 0px;
						    border-right-width: 0px;
						    border-left-width: 0px;
						    padding-top: 0px;
						    padding-right: 25px;
						    padding-left: 0px;
						    padding-bottom: 0px;
						}
		.tg .tg-shlee1{
						    border-top-width: 0px;
						    border-bottom-width: 0px;
						    border-right-width: 0px;
						    border-left-width: 0px;
						    padding-top: 20px;
						    padding-right: 0px;
						    padding-left: 0px;
						    padding-bottom: 0px;
						}
        .changed {
            background-color: #ff9797 !important;
        }
        .col-input {
			width: 100%;
		}
	</style>
	<script>

	var _BCASE = [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768] ;
	var _NAME = ["액정","USB","마우스패드","키보드","배터리","CAM","ODD","HDD","LAN_WIRELESS","LAN_WIRED","BIOS","OS","검수불가"] ;
	var _CODE = ["DISPLAY","USB","MOUSEPAD","KEYBOARD","BATTERY","CAM","ODD","HDD","LAN_WIRELESS","LAN_WIRED","BIOS","OS","TEST_CHECK"] ;
	var _CHECK_CNT = [9, 2, 3, 5, 5, 3, 6, 5, 2, 2, 2, 1, 4];
	var _CASENAME = ["파손","스크래치","찍힘","눌림","변색"] ;
	var _inventoryId = "";
	var _checkType = 1;
	var _table = "";
	var _params;
	var _type = 2;
	var _sid = "";
	var _warehousingId = -1;
	var _isPrint = false;
	var _isSaveSuccess = false;
	var _isPrintSuccess = false;

	$(document).ready(function() {
		_inventoryId = "${inventory_id}";
		_table = "${table}";
		_sid = "${sid}";

   		_warehousingId = getParameterByName("WAREHOUSING_ID");
   		_sid= getParameterByName("sid");

   		_checkType = getParameterByName("CHECK_TYPE");

		fnGetCheckInfo(_inventoryId, _table);

		var infCondPrintPort = '<label>프린터 포트 &nbsp;&nbsp;&nbsp;</label><input id="print_port" style = "width: 70px;"/>';

		$('#save').prepend(infCondPrintPort);

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


	});

	 function getParameterByName(name) {
			name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
			var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
					results = regex.exec(location.search);
			return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
		}

	function fnGetCheckInfo(inventoryId, table){

		console.log("inventoryId() Load");

		var url = '${getInventoryCheckInfo}';

		var params = {
				INVENTORY_ID : inventoryId,
				CHECK_TYPE: _checkType,
				TABLE_NM : table
			};

		$.ajax({
			url : url,
			type : "GET",
			data : params,
// 			contentType: "application/json",
			async : false,
			success : function(data) {
				if(data.SUCCESS){
					if(data.EXIST){
						dataInitialize(data);
					}
					else{
						dataInitialize(data);
						GochigoAlert(data.MSG+" 현재 화면에서 검수 결과를 등록하세요.");
					}
				}
				else{
					GochigoAlert(data.MSG);
					dataInitialize(data);
				}
			}
		});
	}

	function dataInitialize(data)
	{
		var VARIABLE = new Array();
		var CASEVARIABLE = new Array();
		var caseHinge = 0;
		var cooler = 0;
		var caseDestroyDescription = "";
		var batteryRemain = "";

		if(data.EXIST && data.SUCCESS){
			CASEVARIABLE[0] = data.CASE_DESTROYED * 1; //caseDestroyed
			CASEVARIABLE[1] = data.CASE_SCRATCH * 1;	//caseScratch
			CASEVARIABLE[2] = data.CASE_STABBED * 1; //caseStabbed
			CASEVARIABLE[3] = data.CASE_PRESSED * 1; //casePressed
			CASEVARIABLE[4] = data.CASE_DISCOLORED * 1; //caseDiscolored
			caseHinge = data.CASE_HINGE * 1;
			cooler = data.COOLER * 1;
			caseDestroyDescription = data.CASE_DES;
			batteryRemain = data.BATTERY_REMAIN;
			VARIABLE[0] = data.DISPLAY * 1; //display
			VARIABLE[1] = data.USB * 1; //usb
			VARIABLE[2] = data.MOUSEPAD * 1; //mousePad
			VARIABLE[3] = data.KEYBOARD * 1; //keyboard
			VARIABLE[4] = data.BATTERY * 1; //battery
			VARIABLE[5] = data.CAM * 1; //cam
			VARIABLE[6] = data.ODD * 1;	//odd
			VARIABLE[7] = data.HDD * 1; // hdd
			VARIABLE[8] = data.LAN_WIRELESS * 1; //lanWireless
			VARIABLE[9] = data.LAN_WIRED * 1; //lanWired
			VARIABLE[10] = data.BIOS * 1;	//bios
			VARIABLE[11] = data.OS * 1;	//os
			VARIABLE[12] = data.TEST_CHECK * 1;	//check
		}else{
			CASEVARIABLE[0] = 0; //caseDestroyed
			CASEVARIABLE[1] = 0;	//caseScratch
			CASEVARIABLE[2] = 0; //caseStabbed
			CASEVARIABLE[3] = 0; //casePressed
			CASEVARIABLE[4] = 0; //caseDiscolored
			caseHinge = 0;
			cooler = 0;
			caseDestroyDescription = "";
			batteryRemain = "";
			VARIABLE[0] = 0; //display
			VARIABLE[1] = 0; //usb
			VARIABLE[2] = 0; //mousePad
			VARIABLE[3] = 0; //keyboard
			VARIABLE[4] = 0; //battery
			VARIABLE[5] = 0; //cam
			VARIABLE[6] = 0;	//odd
			VARIABLE[7] = 0; // hdd
			VARIABLE[8] = 0; //lanWireless
			VARIABLE[9] = 0; //lanWired
			VARIABLE[10] = 0;	//bios
			VARIABLE[11] = 0;	//os
			VARIABLE[12] = 0;	//check
		}

        for(var i = 0 ; i < _CASENAME.length; i++){
            for(var j = 0 ; j < 4; j++){

                var id = "input:checkbox[name='"+_CASENAME[i]+j+"']";

                if((CASEVARIABLE[i] & _BCASE[j]) == _BCASE[j]) {

                    $(id).prop("checked", true);

                    if( !$(".step1").hasClass("changed") ) {
                        $(".step1").addClass("changed");
                    }
                }
            }
        }

        if(caseHinge == 1){
            var id = "input:checkbox[name='힌지파손']";
            $(id).prop("checked", true);
            if( !$(".step1").hasClass("changed") ) {
                $(".step1").addClass("changed");
            }
        }

        if(cooler == 1){
            var id = "input:checkbox[name='쿨러불량']";
            $(id).prop("checked", true);
            if( !$(".step1").hasClass("changed") ) {
                $(".step1").addClass("changed");
            }
        }

        $('#caseDestroyDescription').val(caseDestroyDescription);


        for(var k = 0 ; k < 13; k++) {
	        for(var i = 0 ; i < _CHECK_CNT[k]; i++) {
	            var id = "input:checkbox[name='"+_CODE[k]+i+"']";
	            if((VARIABLE[k] & _BCASE[i]) == _BCASE[i]) {
	                $(id).prop("checked", true);

	                if( !$(".step"+(k+2)).hasClass("changed") ) {
	                    $(".step"+(k+2)).addClass("changed");
	                }
	            }
	        }
        }

        if((VARIABLE[4] & _BCASE[4]) == _BCASE[4])
        	$('#batteryRemain').val(batteryRemain);
	}

    function fnSaveCheckInfo() {

    	var url = '${NtbCheckForWeb}';
		var CASEVALUE= new Array();
		var CASE_HINGE = 0;
		var COOLER = 0;
		var caseDestroyDescription = "";
		var batteryRemain = "";
		var VALUE = new Array();

		for(var i = 0 ; i < _CASENAME.length; i++){
			CASEVALUE[i] = 0;
			for(var j = 0 ; j < 4; j++){
				var id = "input:checkbox[name='"+_CASENAME[i]+j+"']";

				if($(id).is(":checked") == true) {
					CASEVALUE[i] += _BCASE[j];
				}
			}
		}

		var id = "input:checkbox[name='힌지파손']";
		if($(id).is(":checked") == true) {
			CASE_HINGE = 1;
		}

		var id = "input:checkbox[name='쿨러불량']";
		if($(id).is(":checked") == true) {
			COOLER = 1;
		}

		caseDestroyDescription = $('#caseDestroyDescription').val();

		for(var i = 0 ; i < _CODE.length; i++){
			VALUE[i] = 0;
			for(var j = 0 ; j < _CHECK_CNT[i]; j++){
				 var id = "input:checkbox[name='"+_CODE[i]+j+"']";
				 if(i == 4)
					 {
					 console.log(" 111 = "+_CODE[i]+j);
					 console.log(" check = "+$(id).is(":checked"));
					 }
				 if($(id).is(":checked") == true) {
					 VALUE[i] += _BCASE[j];
					}
			}
		}

		console.log("VALUE[4] = "+VALUE[4]);
		  if((VALUE[4] & _BCASE[4]) == _BCASE[4])
			  batteryRemain = $('#batteryRemain').val();

		_params = {
        	INVENTORY_ID: _inventoryId,
        	TYPE: _type,
        	CHECK_TYPE: _checkType,
            CASE_DESTROYED: CASEVALUE[0],
            CASE_SCRATCH : CASEVALUE[1],
            CASE_STABBED: CASEVALUE[2],
            CASE_PRESSED : CASEVALUE[3],
            CASE_DISCOLORED : CASEVALUE[4],
            CASE_HINGE : CASE_HINGE,
            COOLER : COOLER,
            CASE_DES : caseDestroyDescription,
            BATTERY_REMAIN : batteryRemain,
            DISPLAY : VALUE[0],
            USB : VALUE[1],
            MOUSEPAD : VALUE[2],
            KEYBOARD : VALUE[3],
            BATTERY : VALUE[4],
            CAM : VALUE[5],
            ODD : VALUE[6],
            HDD : VALUE[7],
            LAN_WIRELESS : VALUE[8],
            LAN_WIRED : VALUE[9],
            BIOS : VALUE[10],
            OS : VALUE[11],
            TEST_CHECK : VALUE[12]
        };

		if(!_isPrint){
			$("<div></div>").kendoConfirm({
	    		buttonLayout: "stretched",
	    		actions: [{
	    			text: '확인',
	    			action: function(e){
	    				//시작지점

			        $.ajax({
			            url : url,
			            type : "POST",
			            data : JSON.stringify(_params),
			            contentType: "application/json",
			            async : false,
			            success : function(data) {
			                if(data.SUCCESS) {
			                	_isSaveSuccess = true;
			                    	GochigoAlert(data.MSG);
			                } else {
			                	_isSaveSuccess = false;
			                    GochigoAlert(data.MSG);
			                }
			            }
			        });


			        if(_isSaveSuccess){
			        	if(_sid ==  'checkntb_list' || _sid ==  'checkntb2nd_list'){
			        		var queryCustom = "cobjectid=warehousing_id&cobjectval="+_warehousingId;
			        		opener.fnObj('LIST_'+_sid).reloadGridCustom(queryCustom);
			        	}
			        }


			      //끝지점
	    			}
	    		},
	    		{
	    			text: '취소'
	    		}],
	    		minWidth : 200,
	    		title: fnGetSystemName(),
	    	    content: "검수 결과를 저장하시겠습니까? "
	    	}).data("kendoConfirm").open();
	    	//끝지점
		}else{
			$.ajax({
	            url : url,
	            type : "POST",
	            data : JSON.stringify(_params),
	            contentType: "application/json",
	            async : false,
	            success : function(data) {
	                if(data.SUCCESS) {
	                	_isSaveSuccess = true;
	                } else {
	                	_isSaveSuccess = false;
	                    GochigoAlert(data.MSG);
	                }
	            }
	        });
		}

    }

    function fnPrintCheckInfo(){

    	var url = '${printNtbCheck2ndEditionForWeb}';

    	var printPort = $('#print_port').val();

		_params.PORT = printPort;

		$.ajax({
			url : url,
			type : "POST",
			data : JSON.stringify(_params),
			contentType: "application/json",
			async : false,
			success : function(data) {
				if(data.SUCCESS){
					_isPrintSuccess = true;
					GochigoAlert("검수 결과 정상 저장 + "+ data.MSG);
				}
				else{
					_isPrintSuccess = false;
					GochigoAlert("검수 결과 정상 저장 + "+ data.MSG);
				}
			}
		});

    }

    function fnSaveAndPrintCheckInfo() {

    	var printPort = $('#print_port').val();

    	$("<div></div>").kendoConfirm({
    		buttonLayout: "stretched",
    		actions: [{
    			text: '확인',
    			action: function(e){
    				//시작지점
                    _isPrint = true;
                    fnSaveCheckInfo();
                    _isPrint = false;

                    if(_isSaveSuccess){
                        fnPrintCheckInfo();

                            if(_sid ==  'checkntb_list' || _sid ==  'checkntb2nd_list' ){
                                var queryCustom = "cobjectid=warehousing_id&cobjectval="+_warehousingId;
                                opener.fnObj('LIST_'+_sid).reloadGridCustom(queryCustom);
                            }
                    }

                     //끝지점
    			}
    		},
    		{
    			text: '취소'
    		}],
    		minWidth : 200,
    		title: fnGetSystemName(),
    	    content: "검수 결과를 저장하고 출력하시겠습니까? 프린터 포트: "+printPort
    	}).data("kendoConfirm").open();
    	//끝지점

    }

    function fnClose() {
    	self.opener = self;
    	window.close();
    }

    // 케이스 변경 시 표시
    function checkCaseChanged() {

	    var caseFlag = false;

        for(var i = 0 ; i < _CASENAME.length; i++) {
            for(var j = 0 ; j < 4; j++){
               var id = "input:checkbox[name='"+_CASENAME[i]+j+"']";
                    if($(id).is(":checked") == true) {
                        caseFlag = true;
                    }
            }
        }

        if( !caseFlag ) {
            var id = "input:checkbox[name='힌지파손']";
            if($(id).is(":checked") == true) {
                caseFlag = true;
            }
        }

        if( caseFlag ) {
            if( !$(".step1").hasClass("changed") ) {
                $(".step1").addClass("changed");
            }
        } else {
            if( $(".step1").hasClass("changed") ) {
                $(".step1").removeClass("changed");
            }
        }

    }

    // 변경 시 표시
    function checkChanged(name, num, cnt) {

        var flag = false;

        for(var i = 0 ; i < cnt; i++){
            var id = "input:checkbox[name='"+name+i+"']";
            if($(id).is(":checked") == true) {
            	flag = true;
            }
        }

        if( flag ) {
            if( !$(".step"+num).hasClass("changed") ) {
                $(".step"+num).addClass("changed");
            }
        } else {
            if( $(".step"+num).hasClass("changed") ) {
                $(".step"+num).removeClass("changed");
            }
        }

    }

</script>

<body>
<H2 style = 'margin-left: 30px; margin-top: 20px;'> 노트북 검수</H2>
<table class="tg">
    <thead>
    <tr>
        <th class="tg-0lax"><b>제품코드</th>
        <th class="tg-0lax"><b>단계</th>
        <th class="tg-cly1"><b>항목</th>
        <th class="tg-0lax"><b>세부항목</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td class="tg-yjjc" rowspan="15">NTB</td>
        <td class="tg-buh4 step1">1단계</td>
        <td class="tg-buh4 step1">케이스</td>
        <td class="tg-buh4" onclick="checkCaseChanged()">
        	<table >
        	<tr>
	        	<td class="tg-buh4 tg-shlee">
		        	<form>파손:
	                <input type="checkbox" name="파손0" value="1" /> 1
	                <input type="checkbox" name="파손1" value="2" /> 2
	                <input type="checkbox" name="파손2" value="4" /> 3
	                <input type="checkbox" name="파손3" value="8" /> 4
	            	</form>
	        	</td>
	        	<td class="tg-buh4 tg-shlee">
	        	<form>스크래치:
	                <input type="checkbox" name="스크래치0" value="1" /> 1
	                <input type="checkbox" name="스크래치1" value="2" /> 2
	                <input type="checkbox" name="스크래치2" value="4" /> 3
	                <input type="checkbox" name="스크래치3" value="8" /> 4
	            	</form>
	        	</td>
        	</tr>

        	<tr>
        		<td class="tg-buh4  tg-shlee">
	        		<form>찍힘:
		                <input type="checkbox" name="찍힘0" value="1" /> 1
		                <input type="checkbox" name="찍힘1" value="2" /> 2
		                <input type="checkbox" name="찍힘2" value="4" /> 3
		                <input type="checkbox" name="찍힘3" value="8" /> 4
		            </form>
	        	</td>
	        	<td class="tg-buh4  tg-shlee">
        			<form>눌&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;림:
		                <input type="checkbox" name="눌림0" value="1" /> 1
		                <input type="checkbox" name="눌림1" value="2" /> 2
		                <input type="checkbox" name="눌림2" value="4" /> 3
		                <input type="checkbox" name="눌림3" value="8" /> 4
		            </form>
	        	</td>
        	</tr>

        	<tr>
        		<td class="tg-buh4  tg-shlee">
	        		  <form>변색:
		                <input type="checkbox" name="변색0" value="1" /> 1
		                <input type="checkbox" name="변색1" value="2" /> 2
		                <input type="checkbox" name="변색2" value="4" /> 3
		                <input type="checkbox" name="변색3" value="8" /> 4
		            </form>
	        	</td >
	        	<td class="tg-buh4  tg-shlee">
		        	 <form>
	                	힌지파손<input type="checkbox" name="힌지파손" value="1" />&nbsp;&nbsp;&nbsp;
	                	쿨러불량<input type="checkbox" name="쿨러불량" value="1" />
	            	</form>
	        	</td>
        	</tr>
        	</table>

        </td>
    </tr>
    <tr>
        <td class="tg-0lax step2">2단계</td>
        <td class="tg-0lax step2">액정</td>
        <td class="tg-0lax" onclick="checkChanged('DISPLAY',2,9)">
            <form>
                <input type="checkbox" name="DISPLAY0" value="1" />인식안됨
                <input type="checkbox" name="DISPLAY1" value="2" />파손
                <input type="checkbox" name="DISPLAY2" value="4" />스크래치
                <input type="checkbox" name="DISPLAY3" value="8" />흰멍
                <input type="checkbox" name="DISPLAY4" value="16" />빛샘 <br><br>
                <input type="checkbox" name="DISPLAY5" value="32" />화면줄
                <input type="checkbox" name="DISPLAY8" value="256" />키보드자국
                <input type="checkbox" name="DISPLAY6" value="64" />액정속 이물질
                <input type="checkbox" name="DISPLAY7" value="128" />터치스크린 인식

            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-buh4 step3">3단계</td>
        <td class="tg-buh4 step3">USB</td>
       <td class="tg-0lax" onclick="checkChanged('USB',3,2)">
            <form>
                <input type="checkbox" name="USB0" value="1" />인식 안 됨
                <input type="checkbox" name="USB1" value="2" />파손
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-0lax step4">4단계</td>
        <td class="tg-0lax step4">마우스패드</td>
        <td class="tg-0lax" onclick="checkChanged('MOUSEPAD',4,3)">
            <form>
                <input type="checkbox" name="MOUSEPAD0" value="1" />인식 안 됨
                <input type="checkbox" name="MOUSEPAD1" value="2" />스크래치
                <input type="checkbox" name="MOUSEPAD2" value="4" />좌우 버튼 인식 안 됨
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-buh4 step5">5단계</td>
        <td class="tg-buh4 step5">키보드</td>
        <td class="tg-0lax" onclick="checkChanged('KEYBOARD',5,5)">
            <form>
                <input type="checkbox" name="KEYBOARD0" value="1" />인식 안 됨
                <input type="checkbox" name="KEYBOARD1" value="2" />자판없음
                <input type="checkbox" name="KEYBOARD2" value="4" />자판빠짐 1개
                <input type="checkbox" name="KEYBOARD3" value="8" />자판빠짐 2개
                <input type="checkbox" name="KEYBOARD4" value="16" />자판빠짐 3개 이상
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-buh4 step6">6단계</td>
        <td class="tg-buh4 step6">배터리</td>
        <td class="tg-0lax" onclick="checkChanged('BATTERY',6,5)">
            <form>
                <input type="checkbox" name="BATTERY0" value="1" />배터리없음
                <input type="checkbox" name="BATTERY1" value="2" />충전 안 됨
                <input type="checkbox" name="BATTERY2" value="4" />노화
                <input type="checkbox" name="BATTERY3" value="8" />파손
                <input type="checkbox" name="BATTERY4" value="16" />정상
                 <input type="text" id="batteryRemain" />%
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-0lax step7">7단계</td>
        <td class="tg-0lax step7">CAM</td>
         <td class="tg-0lax" onclick="checkChanged('CAM',7,3)">
            <form>
                <input type="checkbox" name="CAM0" value="1" />인식 안 됨
                <input type="checkbox" name="CAM1" value="2" />파손
                <input type="checkbox" name="CAM2" value="4" />없음
            </form>
        </td>
    </tr>
	<tr>
        <td class="tg-buh4 step8">8단계</td>
        <td class="tg-buh4 step8">ODD</td>
       <td class="tg-0lax" onclick="checkChanged('ODD',8,6)">
            <form>
                <input type="checkbox" name="ODD0" value="1" />인식 안 됨
                <input type="checkbox" name="ODD1" value="2" />ODD 없음
                <input type="checkbox" name="ODD2" value="4" />ODD 파손
                <input type="checkbox" name="ODD3" value="8" />베젤 없음
                <input type="checkbox" name="ODD4" value="16" />베젤 파손
                <input type="checkbox" name="ODD5" value="32" />멀티부스트
            </form>
        </td>
    </tr>
     <tr>
        <td class="tg-0lax step9">9단계</td>
        <td class="tg-0lax step9">HDD</td>
       <td class="tg-0lax" onclick="checkChanged('HDD',9,5)">
            <form>
                <input type="checkbox" name="HDD0" value="1" />인식 안 됨
                <input type="checkbox" name="HDD1" value="2" />가이드 없음
                <input type="checkbox" name="HDD2" value="4" />가이드 파손
                <input type="checkbox" name="HDD3" value="8" />젠더 없음
                <input type="checkbox" name="HDD4" value="16" />젠더 파손
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-0lax step10">10단계</td>
        <td class="tg-0lax step10">LAN[무선]</td>
        <td class="tg-0lax" onclick="checkChanged('LAN_WIRELESS',10,2)">
            <form>
                <input type="checkbox" name="LAN_WIRELESS0" value="1" />인식 안 됨
                <input type="checkbox" name="LAN_WIRELESS1" value="2" />없음
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-buh4 step11">11단계</td>
        <td class="tg-buh4 step11">LAN[유선]</td>
         <td class="tg-0lax" onclick="checkChanged('LAN_WIRED',11,2)">
            <form>
                <input type="checkbox" name="LAN_WIRED0" value="1" />인식 안 됨
                <input type="checkbox" name="LAN_WIRED1" value="2" />파손
            </form>
        </td>
    </tr>
   <tr>
        <td class="tg-buh4 step12">12단계</td>
        <td class="tg-buh4 step12">BIOS</td>
        <td class="tg-0lax" onclick="checkChanged('BIOS',12,2)">
            <form>
                <input type="checkbox" name="BIOS0" value="1" />CMOS P/W
                <input type="checkbox" name="BIOS1" value="2" />CMOS 접근 안 됨
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-0lax step13">13단계</td>
        <td class="tg-0lax step13">윈도우</td>
      	<td class="tg-0lax" onclick="checkChanged('OS',13,1)">
            <form>
                <input type="checkbox" name="OS0" value="1" />윈도우 진입불가
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-0lax step14">14단계</td>
        <td class="tg-0lax step14">검수불가</td>
        <td class="tg-0lax" onclick="checkChanged('TEST_CHECK',14,4)">
            <form>
                <input type="checkbox" name="TEST_CHECK0" value="1" />전원 안켜짐
                <input type="checkbox" name="TEST_CHECK1" value="2" />사용중 멈춤
                <input type="checkbox" name="TEST_CHECK2" value="4" />화면 안나옴
                <input type="checkbox" name="TEST_CHECK3" value="8" />액정파손
            </form>
        </td>
     </tr>

 	<tr>
        <td class="tg-cly1 step15" colspan = "2" >기타</td>
        <td class="tg-cly1">
        	 <form>
               	<input type="text" id="caseDestroyDescription" style="width:100%" />
           	</form>
       	</td>

    </tr>

    <tr align="right">
    	<td  colspan='4' class="tg-shlee1">
    		<div id = "save">
	    		<button id = "saveAndPrintBtn" onclick="fnSaveAndPrintCheckInfo()" class="k-button">저장&프린트</button>
	    		<button onclick="fnSaveCheckInfo()" class="k-button">저장</button>
	    		<button onclick="fnClose()" class="k-button">닫기</button>
    		</div>
    	</td>
    </tr>
    </tbody>
</table>


</body>

</html>

