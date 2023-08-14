<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="componentInventoryCheck"				value="/inventoryCheck/componentInventoryCheck.do"/>
<c:url var="warehousingExamineDelete"					value="/produce/warehousingExamineDelete.json" />
<c:url var="print"													value="/print/print.json"/>
<c:url var="getUserId"											value="/user/getUserId.json"/>


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [warehousingExameList.js]");

	$('#${sid}_printBtn').remove();
	$('#${sid}_deleteBtn').remove();

	var infCondGetComponent = '<button id="${sid}_GetComponentBtn" type="button" onclick="fnGetComponent()" class="k-button">부품 추가</button>';
	var infCondComponent = '<button id="${sid}_customInsertBtn" type="button" onclick="fnComponentInsert()" class="k-button" style="float: right;" >신규부품생성</button>';
	var infCondCompanyComponent = '<button id="${sid}_customCompanyInsertBtn" type="button" onclick="fnCompanyComponentInsert()" class="k-button" style="float: right;" >업체목록에추가하기</button>';
	var infCondInsertComponent = '<input id="component_cd" style = "width: 150px;float: left;"/>';

	var infcondComponentAll = infCondInsertComponent + infCondGetComponent + infCondComponent + infCondCompanyComponent;

	var infCond = '<button id="${sid}_delete_btn" type="button" onclick="fnDeleteWarehousingExamine()" class="k-button" style="float: right;">삭제</button>';
    var infCondCheck = '<button id="${sid}_check_btn" type="button" onclick="fnInventoryCheck()" class="k-button" style="float: right;">검수</button>';

	$('#${sid}_btns').prepend(infcondComponentAll);
	$('#${sid}_btns').prepend(infCond);

	var infCondPrint = '<button id="${sid}_print_btn" type="button" onclick="fnPrint()" class="k-button" style="float: left;">프린트</button>';
// 	var infCond5001 = '<button id="${sid}_print5001_btn" type="button" onclick="fnPrint5001()" class="k-button" style="float: right;">프린트[5001]</button>';
	var infCondPrintPort = '<label id="print_port_label" style = "float: left;">프린터 포트 &nbsp;&nbsp;&nbsp;</label><input id="print_port" style = "width: 70px; float: left;"/>';

	var infcondPrintAll = infCondPrintPort + infCondPrint;
	$('#${sid}_btns').prepend(infcondPrintAll);
    $('#${sid}_btns').prepend(infCondCheck);
// 	$('#${sid}_btns').prepend(infCondPrint);

// 	$('#${sid}_insertBtn').css('float','right');
// 	$('#${sid}_component_intertBtn').css('float','left');

	var componentValueArray = ["CPU", "MBD", "MEM", "VGA", "STG", "MON",  "CAS", "POW", "ADP", "KEY", "MOU", "FAN", "CAB", "BAT", "PKG", "AIR", "LIC", "PER"];
	var componentTextArray = [
								"CPU",
								"MAINBOARD",
								"MEMORY",
								"VGA",
								"STORAGE",
								"MONITOR",
								"CASE",
								"POWER",
								"ADAPTOR",
								"KEYBORAD",
								"MOUSE",
								"FAN",
								"CABLE",
								"BATTERY",
								"박스",
								"AIR",
								"LICENCE",
								"주변기기"];

	var dataArray = new Array();

	for(var i = 0; i<componentValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = componentTextArray[i];
		datainfo.value =  componentValueArray[i];
		dataArray.push(datainfo);
	}

	$("#component_cd").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"CPU",
        height: 210
      });

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

	window.onload = fuChangeDivWidth;
    window.onresize = fuChangeDivWidth;

//     fuChangeDivWidth();

     setTimeout(function() {
//     	$('#${sid}_component_intertBtn').css('float','left');

		$('#${sid}_deleteBtn').css('float','right');
		$('#${sid}_delete_btn').css('float','right');
// 		$('#${sid}_customInsertBtn').css('float','left');

//     	 $('#print_port_label').css('float','right');
		$('#${sid}_GetComponentBtn').css('float','left');
		$('#${sid}_customInsertBtn').css('float','left');
		$('#${sid}_customCompanyInsertBtn').css('float','left');
    	 $('#${sid}_print_btn').css('float','left');
//     	 $('#print_port').css('float','left');
 	}, 500);

});

function fuChangeDivWidth(){
// 	console.log("${sid}");
    var Cwidth = $('#${sid}_header_title').width();
    $('#${sid}_btns').css({'width':Cwidth-20+'px'});
}

function prohibit(){
	console.log("${sid}.prohibit() Load");

	var pGrid = $('#admin_produce_warehousing_all_list_gridbox').data('kendoGrid');
	var pSelItem = pGrid.dataItem(pGrid.select());
	if(!pSelItem) {GochigoAlert('선택된 항목이 없습니다.'); return false;}

	if(pSelItem.warehousing_state == 'C'){
		GochigoAlert('검수 완료된 입고에는 부품을 추가 및 삭제할 수 없습니다.');
		return false;
	}else if(pSelItem.warehousing_state == 'F'){
		GochigoAlert('완료된 입고에는 부품을 추가 및 삭제할 수 없습니다.');
		return false;
	}

	return true;
}

function fnCompanyComponentInsert()
{
	console.log("${sid}.fnCompanyComponentInsert() Load");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var listComponentId = [];
	rows.each(function (index, row) {
		 var gridData = grid.dataItem(this);
		 listComponentId.push(gridData.component_id);
	});

	fnWindowOpen("/layoutNewList.do?xn=selectCompanyList_LAYOUT&KEY=COMPONENT_ID&VALUE="+listComponentId.toString(),"component_id","S");

}

function fnGetComponent() {
	console.log("${sid}.fnGetComponent() Load");

	var url = '${dataList}';
	var componentCd = $('#component_cd').val();

	if(componentCd == null){
		GochigoAlert('오류가 발생했습니다. 다시 생성해 주세요.');
		return;
	}

	if(!prohibit())
			return;

	var width = 800;
	var height = 610;
	var xn = '';

	if(componentCd == 'CPU' || componentCd == 'MBD' || componentCd == 'VGA' || componentCd == 'MEM' || componentCd == 'STG' || componentCd == 'MON'){
		xn = "selectCore_Component_"+componentCd+"_DATA";
		width = 800;
		height = 570;
	}
	else
		xn = "select"+componentCd+"_DATA";

	var pid = '${pid}';
	var ptype = '${ptype}';
	var grid = $('#'+pid+'_gridbox').data('kendoGrid');
    var oid = '${objectId}';
    var queryString = "";

    if(pid && ptype == 'LIST'){
        var objArr = oid.split(",");
        var selItem = grid.dataItem(grid.select());
        if(selItem){
            var qParam = new Array();
            for(var i = 0; i < objArr.length; i++){
                qParam.push(selItem.get(objArr[i]));
            }

            var pStr = qParam.join(","); //value 구분자

            queryString += '&pid=${pid}';
            queryString += '&pobjectid=' + oid;
            queryString += '&pobjval=' + pStr;
        }
    }

    queryString += '&componentCd=' + componentCd;
    queryString += '&pid=${sid}';
    queryString += '&warehousing=' + selItem.warehousing;
    queryString += '&warehousingId=' + selItem.warehousing_id;
    queryString += '&stock=Y';
    queryString += '&representative_type=W';
    queryString += '&company_id=' + selItem.company_id;

//     if(componentCd == "CAS"){
// 		height = 450;
// 		 queryString += '&height=' + height;
// 	}

	queryString += '&height=' + height;

    var xPos  = (document.body.clientWidth /2) - (800 / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (600 / 2);
   window.open("<c:url value='/dataEdit.do'/>"+"?xn="+xn+"&sid=${sid}"+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

}

function fnComponentInsert() {
	console.log("${sid}.fnComponentInsert() Load");

	var url = '${dataList}';
	var componentCd = $('#component_cd').val();

	if(componentCd == null){
		GochigoAlert('오류가 발생했습니다. 다시 생성해 주세요.');
		return;
	}

	if(!prohibit())
			return;

	var width = 800;
	var height = 600;
	var xn = '';

	if(componentCd == 'CPU' || componentCd == 'MBD' || componentCd == 'VGA' || componentCd == 'MEM' || componentCd == 'STG' || componentCd == 'MON'){
		xn = "createCore_Component_"+componentCd+"_DATA";
		width = 800;
		height = 550;
	}
	else
		xn = "create"+componentCd+"_DATA";

	var pid = '${pid}';
	var ptype = '${ptype}';
	var grid = $('#'+pid+'_gridbox').data('kendoGrid');
    var oid = '${objectId}';
    var queryString = "";

    if(pid && ptype == 'LIST'){
        var objArr = oid.split(",");
        var selItem = grid.dataItem(grid.select());
        if(selItem){
            var qParam = new Array();
            for(var i = 0; i < objArr.length; i++){
                qParam.push(selItem.get(objArr[i]));
            }

            var pStr = qParam.join(","); //value 구분자

            queryString += '&pid=${pid}';
            queryString += '&pobjectid=' + oid;
            queryString += '&pobjval=' + pStr;
        }
    }

    queryString += '&componentCd=' + componentCd;
    queryString += '&pid=${sid}';
    queryString += '&warehousing=' + selItem.warehousing;
    queryString += '&warehousingId=' + selItem.warehousing_id;
    queryString += '&stock=N';
    queryString += '&representative_type=W';
    queryString += '&company_id=' + selItem.company_id;


	queryString += '&height=' + height;

    var xPos  = (document.body.clientWidth /2) - (800 / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (600 / 2);
   window.open("<c:url value='/dataEdit.do'/>"+"?xn="+xn+"&sid=${sid}"+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

}

function fnDeleteWarehousingExamine() {

	console.log("${sid}.fnDeleteWarehousingExamine() Load");



	var url = '${warehousingExamineDelete}';

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var isConsigned = false;
	rows.each(function (index, row) {
		 	var gridData = grid.dataItem(this);

		 	if(gridData.inventory_type == 'C'){
 				GochigoAlert('생산대행 부품은 [생산-생산대행-업체별 부품재고]에서 삭제 가능합니다.');
 				isConsigned = true;
			}
		 });

	if(isConsigned)
		return;

	if(!prohibit())
		return;

	var isSuccess = false;

	if(!isConsigned){

		//시작지점
		$("<div></div>").kendoConfirm({
			buttonLayout: "stretched",
			actions: [{
				text: '확인',
				action: function(e){
					//시작지점

					var listInventoeyId = [];
					var warehousingId = -1;
					 rows.each(function (index, row) {
						 var gridData = grid.dataItem(this);
						 listInventoeyId.push(gridData.inventory_id);
						 warehousingId = gridData.warehousing_id;
						 });

						var params = {
								WAREHOUSING_ID : warehousingId,
								INVENTORY_ID : listInventoeyId.toString()
							};

						$.ajax({
							url : url,
							type : "POST",
							data : params,
							async : false,
							success : function(data) {
								if(data.SUCCESS){
									GochigoAlert(data.MSG);
									isSuccess = true;

								}
								else{
									GochigoAlert(data.MSG);
								}
							}
						});

						 if(isSuccess){
	//  				    		fnObj('LIST_${sid}').reloadGrid();
						    	fnObj('LIST_admin_produce_warehousing_all_list').reloadGrid();
							}

						//끝지점
				}
			},
			{
				text: '닫기'
			}],
			minWidth : 200,
			title: fnGetSystemName(),
		    content: "<h3>선택한 재고를 <font color=red>재고 목록</font>에서 삭제하시겠습니까?</h3><br><b><font color=blue> [제품(MBD) 재고를 삭제하는 경우 제품 목록도 삭제됩니다.</font>"
		}).data("kendoConfirm").open();
		//끝지점
	}
}

function fnPrint(){

	console.log("${sid}.fnPrint() Load");

	var userId = "${sessionScope.userInfo.user_id}";

	 if(userId == ""){
			GochigoAlert('세션이 만료되었습니다. 다시 로그인 후 시도해 주세요.');
			return false;
	}


	var url = '${print}';
	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var printPort = $('#print_port').val();

	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				var listBarcode= [];
				var warehousing = '';
				 rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 warehousing = gridData.warehousing;
					 listBarcode.push(gridData.barcode);
					 });

					var params = {
							WAREHOUSING : warehousing,
							BARCODE : listBarcode.toString(),
							USER_ID: userId,
							PORT: printPort,
							REPRESENTATIVE_TYPE: "W"
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

	//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "바코드를 출력하시겠습니까(PORT:"+printPort+")?"
	}).data("kendoConfirm").open();
	//끝지점
}

function fnInventoryCheck(){
	console.log("${sid}.fnInventoryCheck() Load");

	var url = '${componentInventoryCheck}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 재고가 없습니다.'); return;}
	else if(rows.length > 1) {GochigoAlert('하나의 재고만 선택해 주세요.'); return;}

	var inventoryId = '';
	var componentCd = '';
	 rows.each(function (index, row) {
		 var gridData = grid.dataItem(this);
		 inventoryId = gridData.inventory_id;
		 componentCd = gridData.component_cd;
		 });

	var params = "INVENTORY_ID="+inventoryId+"&COMPONENT_CD="+componentCd+"&CHECK_TYPE=1&RELOAD=Y&sid=${sid}";
// 	var params = {
//         	INVENTORY_ID: inventoryId,
//             COMPONENT_CD: componentCd
// 	}

	fnCheckWindowOpen(url, params, componentCd);

}

function fnCheckWindowOpen(url, params, size) {
    var width, height;
    if(size == "MON") {
    	width = "950";
    	height = "500";
    } else if(size == "CAS") {
    	width = "800";
    	height = "350";
    }else if(size == "MBD") {
    	width = "1000";
    	height = "450";
    }else if(size == "VGA") {
    	width = "850";
    	height = "330";
    }else if(size == "STG") {
    	width = "920";
    	height = "270";
    }
    else if(size == "ODD") {
    	width = "750";
    	height = "270";
    }else {
    	width = "700";
    	height = "270"
    }

	var xPos  = (document.body.clientWidth /2) - (width / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (height / 2);
    window.open("<c:url value='"+url+"'/>?"+params, "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
}

function fnWindowOpen(url, callbackName, size) {
    var width, height;
    if(size == "SS"){
    	width = "400";
    	height = "500";
    } else if(size == "S"){
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
    } else {
    	width = "800";
    	height = "600"
    }
	var xPos  = (document.body.clientWidth /2) - (width / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (height / 2);
    window.open("<c:url value='"+url+"'/>"+"&callbackName="+callbackName, "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
}

</script>
