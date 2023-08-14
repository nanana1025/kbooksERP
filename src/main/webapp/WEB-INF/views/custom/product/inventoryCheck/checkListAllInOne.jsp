<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:url var="getInventoryCheckInfo"					value="/inventoryCheck/getInventoryCheckInfo.json" />
<c:url var="AllInOneCheckForWeb"							value="/inventoryCheck/AllInOneCheckForWeb.json" />
<c:url var="printAllInOneCheckForWeb"					value="/print/printAllInOneCheckForWeb.json" />

<html>
	<title>일체형pc 검수</title>
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
	</style>
	<script>

	var _BCASE = [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768] ;
	var _NAME = ["액정","CAM","USB","사운드","LAN_WIRELESS","LAN_WIRED","ODD","아답터","BIOS","OS"] ;
	var _CASENAME = ["파손","스크래치","찍힘","눌림","변색"] ;
	var _inventoryId = "";
	var _table = "";
	var _params;
	var _type = 3;
	var _sid = "";
	var _warehousingId = -1;
	var _isPrint = false;
	var _isSaveSuccess = false;
	var _isPrintSuccess = false;

	$(document).ready(function() {
		_inventoryId = "${inventory_id}";
		_table = "${table}";
		_sid = "${sid}";

		if(_sid ==  'checkallinone_list'){
    		var openerGrid = opener.$('#'+_sid+'_gridbox').data('kendoGrid');
    		var openerSelItem = openerGrid.dataItem(openerGrid.select());
    		_warehousingId = openerSelItem.warehousing_id;
		}

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

	function fnGetCheckInfo(inventoryId, table){

		console.log("inventoryId() Load");

		var url = '${getInventoryCheckInfo}';

		var params = {
				INVENTORY_ID : inventoryId,
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
		var hdd = 0;

		if(data.EXIST && data.SUCCESS){
			CASEVARIABLE[0] = data.CASE_DESTROYED * 1; //caseDestroyed
			CASEVARIABLE[1] = data.CASE_SCRATCH * 1;	//caseScratch
			CASEVARIABLE[2] = data.CASE_STABBED * 1; //caseStabbed
			CASEVARIABLE[3] = data.CASE_PRESSED * 1; //casePressed
			CASEVARIABLE[4] = data.CASE_DISCOLORED * 1; //caseDiscolored
			VARIABLE[0] = data.DISPLAY * 1; //display
			VARIABLE[1] = data.CAM * 1; //cam
			VARIABLE[2] = data.USB * 1; //usb
			VARIABLE[3] = data.SOUND * 1; //sound
			VARIABLE[4] = data.LAN_WIRELESS * 1; //lanWireless
			VARIABLE[5] = data.LAN_WIRED * 1; //lanWired
			hdd = data.HDD * 1; // hdd
			VARIABLE[6] = data.ODD * 1;	//odd
			VARIABLE[7] = data.ADAPTER * 1;	//adapter
			VARIABLE[8] = data.BIOS * 1;	//bios
			VARIABLE[9] = data.OS * 1;	//os
		}else{
			CASEVARIABLE[0] = 0; //caseDestroyed
			CASEVARIABLE[1] = 0;	//caseScratch
			CASEVARIABLE[2] = 0; //caseStabbed
			CASEVARIABLE[3] = 0; //casePressed
			CASEVARIABLE[4] = 0; //caseDiscolored
			VARIABLE[0] = 0; //display
			VARIABLE[1] = 0; //cam
			VARIABLE[2] = 0; //usb
			VARIABLE[3] = 0; //sound
			VARIABLE[4] = 0; //lanWireless
			VARIABLE[5] = 0; //lanWired
			hdd = 0; // hdd
			VARIABLE[6] = 0;	//odd
			VARIABLE[7] = 0;	//adapter
			VARIABLE[8] = 0;	//bios
			VARIABLE[9] = 0;	//os
		}

        for(var i = 0 ; i < _CASENAME.length; i++) {
            for(var j = 0 ; j < 3; j++){

                var id = "input:checkbox[name='"+_CASENAME[i]+j+"']";

                if((CASEVARIABLE[i] & _BCASE[j]) == _BCASE[j]) {

                    $(id).prop("checked", true);

                    if( !$(".step1").hasClass("changed") ) {
                        $(".step1").addClass("changed");
                    }
                }
            }
        }

        for(var i = 0 ; i < _NAME.length; i++) {

            var id = "input:radio[name='"+_NAME[i]+"']:radio[value="+VARIABLE[i]+"]";
            $(id).prop('checked', true);

            if( VARIABLE[i] != 0 ) {

                if( i < 6 ) {
                    var step = ".step" + (i + 2);
                } else {
                    var step = ".step" + (i + 3);
                }

                if( !$(step).hasClass("changed") ) {
                    $(step).addClass("changed");
                }
            }
        }

        for(var i = 0 ; i < 5; i++) {
            var id = "input:checkbox[name='HDD"+i+"']";
            if((hdd & _BCASE[i]) == _BCASE[i]) {

                $(id).prop("checked", true);

                if( !$(".step8").hasClass("changed") ) {
                    $(".step8").addClass("changed");
                }
            }
        }

	}

    function fnSaveCheckInfo() {

    	var url = '${AllInOneCheckForWeb}';
		var CASEVALUE= new Array();
		var CASE_HINGE = 0;
		var VALUE = new Array();
		var HDD = 0;

		for(var i = 0 ; i < _CASENAME.length; i++){
			CASEVALUE[i] = 0;
			for(var j = 0 ; j < 3; j++){
				var id = "input:checkbox[name='"+_CASENAME[i]+j+"']";

				if($(id).is(":checked") == true) {
					CASEVALUE[i] += _BCASE[j];
				}
			}
		}

		for(var i = 0 ; i < _NAME.length; i++){
			VALUE[i] = 0;
			var id = "input:radio[name='"+_NAME[i]+"']:checked";
			VALUE[i] = $(id).val();
		}

		for(var i = 0 ; i < 5; i++){
			var id = "input:checkbox[name='HDD"+i+"']";
			if($(id).is(":checked") == true) {
				HDD += _BCASE[i];
			}
		}

		_params = {
        	INVENTORY_ID: _inventoryId,
        	TYPE: _type,
            CASE_DESTROYED: CASEVALUE[0],
            CASE_SCRATCH : CASEVALUE[1],
            CASE_STABBED: CASEVALUE[2],
            CASE_PRESSED : CASEVALUE[3],
            CASE_DISCOLORED : CASEVALUE[4],
            DISPLAY : VALUE[0],
            CAM : VALUE[1],
            USB : VALUE[2],
            SOUND : VALUE[3],
            LAN_WIRELESS : VALUE[4],
            LAN_WIRED : VALUE[5],
            HDD : HDD,
            ODD : VALUE[6],
            ADAPTER : VALUE[7],
            BIOS : VALUE[8],
            OS : VALUE[9]
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
			        	if(_sid ==  'checkallinone_list'){
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

    	var url = '${printAllInOneCheckForWeb}';

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
					GochigoAlert("검수 결과 정상 저장 + "+ data.MSG);
				}
				else{
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

                        if(_sid ==  'checkallinone_list'){
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

    // HDD 변경 시 표시
    function checkHddChanged() {

        var hddFlag = false;

        for(var i = 0 ; i < 5; i++){
            var id = "input:checkbox[name='HDD"+i+"']";
            if($(id).is(":checked") == true) {
                hddFlag = true;
            }
        }

        if( hddFlag ) {
            if( !$(".step8").hasClass("changed") ) {
                $(".step8").addClass("changed");
            }
        } else {
            if( $(".step8").hasClass("changed") ) {
                $(".step8").removeClass("changed");
            }
        }

    }

    // Radio 버튼 변경 시 표시
    function checkRadioChanged(step, name) {

        var radioFlag = false;

        var id = "input:radio[name='"+name+"']:checked"

        if( $(id).val() != 0 ) {
            radioFlag = true;
        }

        if( radioFlag ) {
            if( !$(step).hasClass("changed") ) {
                $(step).addClass("changed");
            }
        } else {
            if( $(step).hasClass("changed") ) {
                $(step).removeClass("changed");
            }
        }

    }

</script>

<body>
<H2 style = 'margin-left: 30px; margin-top: 20px;'> 일체형PC 검수</H2>
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
        <td class="tg-yjjc" rowspan="12">일체형PC</td>
        <td class="tg-buh4 step1">1단계</td>
        <td class="tg-buh4 step1">케이스</td>
        <td class="tg-buh4" onclick="checkCaseChanged()">
        	<table >
        	<tr>
	        	<td class="tg-buh4 tg-shlee">
		        	<form>파손:
	                <input type="checkbox" name="파손0" value="1" /> 전면
	                <input type="checkbox" name="파손1" value="2" />후면
	                <input type="checkbox" name="파손2" value="4" /> 받침
	            	</form>
	        	</td>
	        	<td class="tg-buh4  tg-shlee">
	        	<form>스크래치:
	                <input type="checkbox" name="스크래치0" value="1" /> 전면
	                <input type="checkbox" name="스크래치1" value="2" /> 후면
	                <input type="checkbox" name="스크래치2" value="4" /> 받침
	            	</form>
	        	</td>
        	</tr>

        	<tr>
        		<td class="tg-buh4  tg-shlee">
	        		<form>찍힘:
		                <input type="checkbox" name="찍힘0" value="1" /> 전면
		                <input type="checkbox" name="찍힘1" value="2" /> 후면
		                <input type="checkbox" name="찍힘2" value="4" /> 받침
		            </form>
	        	</td>
	        	<td class="tg-buh4  tg-shlee">
        			<form>눌&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;림:
		                <input type="checkbox" name="눌림0" value="1" /> 전면
		                <input type="checkbox" name="눌림1" value="2" /> 후면
		                <input type="checkbox" name="눌림2" value="4" /> 받침
		            </form>
	        	</td>
        	</tr>

        	<tr>
        		<td class="tg-buh4  tg-shlee">
	        		  <form>변색:
		                <input type="checkbox" name="변색0" value="1" /> 전면
		                <input type="checkbox" name="변색1" value="2" /> 후면
		                <input type="checkbox" name="변색2" value="4" /> 받침
		            </form>
	        	</td >
	        	<td class="tg-buh4  tg-shlee">
	        	</td>
        	</tr>
        	</table>

        </td>
    </tr>
    <tr>
        <td class="tg-0lax step2">2단계</td>
        <td class="tg-0lax step2">액정</td>
        <td class="tg-0lax" onclick="checkRadioChanged('.step2', '액정')">
            <form>
                <input type="radio" name="액정" value="0" /> 해당없음
                <input type="radio" name="액정" value="1" /> 인식 안 됨
                <input type="radio" name="액정" value="2" /> 파손
                <input type="radio" name="액정" value="3" /> 스크래치
                <input type="radio" name="액정" value="4" /> 흰멍
                <input type="radio" name="액정" value="5" /> 빚샘
                <input type="radio" name="액정" value="6" /> 화면 줄
                <input type="radio" name="액정" value="7" /> 터치스크린 인식
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-buh4 step3">3단계</td>
        <td class="tg-buh4 step3">CAM</td>
        <td class="tg-buh4" onclick="checkRadioChanged('.step3', 'CAM')">
            <form>
                <input type="radio" name="CAM" value="0" />해당없음
                <input type="radio" name="CAM" value="1" />인식 안 됨
                <input type="radio" name="CAM" value="2" />없음
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-0lax step4">4단계</td>
        <td class="tg-0lax step4">USB</td>
        <td class="tg-0lax" onclick="checkRadioChanged('.step4', 'USB')">
            <form>
                <input type="radio" name="USB" value="0" />해당없음
                <input type="radio" name="USB" value="1" />인식 안 됨
                <input type="radio" name="USB" value="2" />파손
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-buh4 step5">5단계</td>
        <td class="tg-buh4 step5">사운드</td>
        <td class="tg-buh4" onclick="checkRadioChanged('.step5', '사운드')">
            <form>
                <input type="radio" name="사운드" value="0" />해당없음
                <input type="radio" name="사운드" value="1" />인식 안 됨
<!--                 <input type="radio" name="사운드" value="2" />파손 -->
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-0lax step6">6단계</td>
        <td class="tg-0lax step6">LAN[무선]</td>
        <td class="tg-0lax" onclick="checkRadioChanged('.step6', 'LAN_WIRELESS')">
            <form>
                <input type="radio" name="LAN_WIRELESS" value="0" />해당없음
                <input type="radio" name="LAN_WIRELESS" value="1" />인식 안 됨
                <input type="radio" name="LAN_WIRELESS" value="2" />없음
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-buh4 step7">7단계</td>
        <td class="tg-buh4 step7">LAN[유선]</td>
        <td class="tg-buh4" onclick="checkRadioChanged('.step7', 'LAN_WIRED')">
            <form>
                <input type="radio" name="LAN_WIRED" value="0" />해당없음
                <input type="radio" name="LAN_WIRED" value="1" />인식 안 됨
                <input type="radio" name="LAN_WIRED" value="2" />파손
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-0lax step8">8단계</td>
        <td class="tg-0lax step8">HDD</td>
        <td class="tg-0lax" onclick="checkHddChanged()">
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
        <td class="tg-buh4 step9">9단계</td>
        <td class="tg-buh4 step9">ODD</td>
        <td class="tg-buh4" onclick="checkRadioChanged('.step9', 'ODD')">
            <form>
                <input type="radio" name="ODD" value="0" />해당없음
                <input type="radio" name="ODD" value="1" />인식 안 됨
                <input type="radio" name="ODD" value="2" />ODD 없음
                <input type="radio" name="ODD" value="3" />ODD 파손
                <input type="radio" name="ODD" value="4" />베젤 없음
                <input type="radio" name="ODD" value="5" />베젤 파손
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-0lax step10">10단계</td>
        <td class="tg-0lax step10">아답터</td>
        <td class="tg-0lax" onclick="checkRadioChanged('.step10', '아답터')">
            <form>
                <input type="radio" name="아답터" value="0" />해당없음
                <input type="radio" name="아답터" value="1" />인식 안 됨
                <input type="radio" name="아답터" value="2" />없음
                <input type="radio" name="아답터" value="3" />단선
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-buh4 step11">11단계</td>
        <td class="tg-buh4 step11">BIOS</td>
        <td class="tg-buh4" onclick="checkRadioChanged('.step11', 'BIOS')">
            <form>
                <input type="radio" name="BIOS" value="0" />해당없음
                <input type="radio" name="BIOS" value="1" />CMOS P/W
                <input type="radio" name="BIOS" value="2" />CMOS 접근 안 됨
            </form>
        </td>
    </tr>
    <tr>
        <td class="tg-0lax step12">12단계</td>
        <td class="tg-0lax step12">윈도우</td>
        <td class="tg-0lax" onclick="checkRadioChanged('.step12', 'OS')">
            <form>
                <input type="radio" name="OS" value="0" />해당없음
                <input type="radio" name="OS" value="1" />전원 안 켜짐
                <input type="radio" name="OS" value="2" />부팅 안 됨
                <input type="radio" name="OS" value="3" />재부팅 현상
                <input type="radio" name="OS" value="4" />사용중 멈춤
                <input type="radio" name="OS" value="5" />화면 깨짐
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

