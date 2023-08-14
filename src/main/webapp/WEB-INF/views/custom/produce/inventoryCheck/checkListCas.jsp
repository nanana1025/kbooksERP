<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<c:url var="getInventoryCheckInfo"					value="/inventoryCheck/getInventoryCheckInfo.json" />
<c:url var="CaseCheckForWeb"							value="/inventoryCheck/CaseCheckForWeb.json" />
<c:url var="printInventoryCheckForWeb"					value="/print/printInventoryCheckForWeb.json" />

<html>
	<title>케이스 검수</title>
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
	</style>
	<script>

	var _BCASE = [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768] ;
	var _CASENAME = ["파손","스크래치","찍힘","눌림","변색"] ;
	var _inventoryId = "";
	var _componentCd = "";
	var _table = "";
	var _params;
	var _isPrint = false;
	var _isSaveSuccess = false;
	var _checkType = 1;
	var _reload = "N";
	var _sid = "";

	$(document).ready(function() {
		_inventoryId = "${inventory_id}";
		_componentCd = "${component_cd}";
		_table = "${table}";
		_checkType = "${check_type}";
		_reload = "${reload}";
		_sid = "${sid}";

// 		console.log(_inventoryId);
//   		console.log(_table);

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
				TABLE_NM : table,
				CHECK_TYPE:_checkType
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
						GochigoAlert(data.MSG);
					}
				}
				else
					GochigoAlert(data.MSG);
			}
		});
	}

	function dataInitialize(data)
	{
		var CASEVARIABLE = new Array();

		CASEVARIABLE[0] = data.CASE_DESTROYED * 1; //caseDestroyed
		CASEVARIABLE[1] = data.CASE_SCRATCH * 1;	//caseScratch
		CASEVARIABLE[2] = data.CASE_STABBED * 1; //caseStabbed
		CASEVARIABLE[3] = data.CASE_PRESSED * 1; //casePressed
		CASEVARIABLE[4] = data.CASE_DISCOLORED * 1; //caseDiscolored


		for(var i = 0 ; i < _CASENAME.length; i++){
			for(var j = 0 ; j < 3; j++){
				var id = "input:checkbox[name='"+_CASENAME[i]+j+"']";
				if((CASEVARIABLE[i] & _BCASE[j]) == _BCASE[j])
					$(id).prop("checked", true);
			}
		}

		$('#description').val(data.DES);
	}

    function fnSaveCheckInfo() {

    	var url = '${CaseCheckForWeb}';
		var CASEVALUE= new Array();

		for(var i = 0 ; i < _CASENAME.length; i++){
			CASEVALUE[i] = 0;
			for(var j = 0 ; j < 3; j++){
				var id = "input:checkbox[name='"+_CASENAME[i]+j+"']";

				if($(id).is(":checked") == true) {
					CASEVALUE[i] += _BCASE[j];
				}
			}
		}

		var description = $('#description').val();

		_params = {
        	INVENTORY_ID: _inventoryId,
            CASE_DESTROYED: CASEVALUE[0],
            CASE_SCRATCH : CASEVALUE[1],
            CASE_STABBED: CASEVALUE[2],
            CASE_PRESSED : CASEVALUE[3],
            CASE_DISCOLORED : CASEVALUE[4],
            CHECK_TYPE:_checkType,
            DES:description,
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
			                	if(_reload == "Y"){
			                		opener.fnObj('LIST_'+_sid).reloadGrid();
			                	}
		                    	GochigoAlert(data.MSG);
			                } else {
			                    GochigoAlert(data.MSG);
			                }
			            }
			        });

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

    	var url = '${printInventoryCheckForWeb}';

    	var printPort = $('#print_port').val();

		_params.PORT = printPort;
		_params.COMPONENT_CD = _componentCd;

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

</script>

<body>
<H2 style = 'margin-left: 30px; margin-top: 20px;'> 케이스 검수</H2>
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
        <td class="tg-yjjc" rowspan="2">케이스</td>
        <td class="tg-buh4">1단계</td>
        <td class="tg-buh4">케이스</td>
        <td class="tg-buh4">
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
        <td class="tg-buh4" colspan = "2" >기타</td>
        <td class="tg-buh4 tg-shlee1">
        	 <form>
               	<input type="text" id="description" style="width:100%" />
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

