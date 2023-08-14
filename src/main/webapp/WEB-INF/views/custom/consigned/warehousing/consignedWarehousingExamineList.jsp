<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="componentInventoryCheck"
	value="/inventoryCheck/componentInventoryCheck.do" />
<c:url var="consignedComponentBulkDelete"
	value="/consigned/consignedComponentBulkDelete.json" />
<c:url var="print" value="/print/print.json" />
<c:url var="getUserId" value="/user/getUserId.json" />


<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>
</style>
<script>

$(document).ready(function() {

	console.log("load [consignedWarehousingExameList.js]");

	$('#consigned_warehousing_examine_list_printBtn').remove();
	$('#consigned_warehousing_examine_list_deleteBtn').remove();
	$('#consigned_warehousing_examine_list_insertBtn').remove();

	$('#${sid}_gridbox').off('dblclick');

	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
		fnConsignedCompanyInventoryList();
    });

	var infLTCondComponent = '<button id="consigned_warehousing_examine_list_customInsertBtn" type="button" onclick="fnGetComponent()" class="k-button" style="float: left;">부품추가</button>';
	var infCondComponent = '<button id="consigned_produce_component_customInsertBtn" type="button" onclick="fnComponentInsert()" class="k-button" style="float: right;" >신규부품생성</button>';
	var infCondComponentUpdateBulk = '<button id="${sid}_customComponentUpateBulkBtn" type="button" onclick="fnComponentUpdateBulk()" class="k-button" style="float: right;" >정보 일괄수정</button>';
	var infCondComponentDelete = '<button id="${sid}_customComponentDeleteBtn" type="button" onclick="fnComponentDelete()" class="k-button" style="float: right;" >삭제</button>';
	var infCondInsertComponent = '<input id="component_cd" style = "width: 150px;float: left;"/>';

	var infcondComponentAll = infCondInsertComponent + infLTCondComponent + infCondComponentDelete+ infCondComponentUpdateBulk+infCondComponent;

	var infCond = '<button id="consigned_warehousing_examine_list_delete_btn" type="button" onclick="fnDeleteWarehousingExamine()" class="k-button" style="float: right;">삭제</button>';
    var infCondCheck = '<button id="consigned_warehousing_examine_list_check_btn" type="button" onclick="fnInventoryCheck()" class="k-button" style="float: right;">검수</button>';

	$('#${sid}_btns').prepend(infcondComponentAll);
// 	$('#consigned_warehousing_examine_list_btns').prepend(infCond);

	var infCondPrint = '<button id="consigned_warehousing_examine_list_print_btn" type="button" onclick="fnPrint()" class="k-button" style="float: left;">프린트</button>';
// 	var infCond5001 = '<button id="consigned_warehousing_examine_list_print5001_btn" type="button" onclick="fnPrint5001()" class="k-button" style="float: right;">프린트[5001]</button>';
	var infCondPrintPort = '<label id="print_port_label" style = "float: left;">프린터 포트 &nbsp;&nbsp;&nbsp;</label><input id="print_port" style = "width: 70px; float: left;"/>';

	var infcondPrintAll = infCondPrintPort + infCondPrint;
	$('#consigned_warehousing_examine_list_btns').prepend(infcondPrintAll);
//     $('#consigned_warehousing_examine_list_btns').prepend(infCondCheck);
// 	$('#consigned_warehousing_examine_list_btns').prepend(infCondPrint);

// 	$('#consigned_warehousing_examine_list_insertBtn').css('float','right');
// 	$('#consigned_warehousing_examine_list_component_intertBtn').css('float','left');

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
//     	$('#consigned_warehousing_examine_list_component_intertBtn').css('float','left');

		$('#consigned_warehousing_examine_list_deleteBtn').css('float','right');
		$('#consigned_warehousing_examine_list_delete_btn').css('float','right');
// 		$('#consigned_warehousing_examine_list_customInsertBtn').css('float','left');

//     	 $('#print_port_label').css('float','right');
// 	$('#${sid}_customComponentUpateBulkBtn').css('float','left');
		$('#consigned_warehousing_examine_list_customInsertBtn').css('float','left');
    	 $('#consigned_warehousing_examine_list_print_btn').css('float','left');
//     	 $('#print_port').css('float','left');
 	}, 500);

});

function fuChangeDivWidth(){
// 	console.log("${sid}");
    var Cwidth = $('#consigned_warehousing_examine_list_header_title').width();
    $('#${sid}_btns').css({'width':Cwidth-20+'px'});
}

function prohibit(){
	console.log("${sid}.prohibit() Load");

	var pGrid = $('#consigned_warehousing_all_list_gridbox').data('kendoGrid');
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

function fnComponentUpdateBulk(){

	console.log("${sid}.fnComponentUpdateBulk() Load");

	if(!prohibit())
			return;

	var width = 800;
	var height = 450;

	var xn = "consigned_Examine_DATA";

	console.log( '${ptype}');
	var pid = 'consigned_warehousing_examine_list';
	var ptype = '${ptype}';
	var grid = $('#'+pid+'_gridbox').data('kendoGrid');
    var oid = 'WAREHOUSING_ID,INVENTORY_ID';
    var queryString = "";

    if(pid && ptype == 'LIST'){

    	 queryString += '&pid=${pid}';
         queryString += '&objectid=' + oid;

        var objArr = oid.split(",");
        var selItem = grid.dataItem(grid.select());
        if(selItem){

            var pStr = new Array();
            for(var i = 0; i < objArr.length; i++){
            	pStr = selItem.get(objArr[i].toLowerCase());
                queryString += '&'+objArr[i]+'=' + pStr;
            }

        }

        queryString += '&INVENTORY_TYPE=C';

    }

    var xPos  = (document.body.clientWidth /2) - (800 / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (600 / 2);
   window.open("<c:url value='/dataView.do'/>"+"?xn="+xn+"&sid="+pid+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

}

function fnConsignedCompanyInventoryList(){

	console.log("${sid}.fnConsignedCompanyInventoryList() Load");

	var pGrid = $('#consigned_warehousing_all_list_gridbox').data('kendoGrid');
	var pSelItem = pGrid.dataItem(pGrid.select());
	if(pSelItem.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(selItem.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
			WAREHOUSING_ID : pSelItem.warehousing_id,
			COMPANY_ID : pSelItem.company_id,
	        COMPONENT_ID : selItem.component_id,
	    };


	var url = "&pid=${sid}&CUSTOMKEY=WAREHOUSING_ID,COMPONENT_ID,INVENTORY_TYPE&CUSTOMVALUE="+params.WAREHOUSING_ID+","+params.COMPONENT_ID+",C";
	fnWindowOpen("/layoutNewList.do?xn=representative_Component_LAYOUT"+url,"component_id", "M");

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
    queryString += '&representative_type=C';
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
    queryString += '&representative_type=C';
    queryString += '&company_id=' + selItem.company_id;


	queryString += '&height=' + height;

    var xPos  = (document.body.clientWidth /2) - (800 / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (600 / 2);
   window.open("<c:url value='/dataEdit.do'/>"+"?xn="+xn+"&sid=${sid}"+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

}


function fnComponentDelete() {

	console.log("${sid}.fnComponentDelete() Load");



	var url = '${consignedComponentBulkDelete}';

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}
	if(rows.length > 1) {GochigoAlert('하나의 품목만 선택하세요.'); return;}

	var isSuccess = false;

		//시작지점
		$("<div></div>").kendoConfirm({
			buttonLayout: "stretched",
			actions: [{
				text: '확인',
				action: function(e){
					//시작지점

					var componentId = -1;
					var warehousingId = -1;
					var componentCd = "";;
					 rows.each(function (index, row) {
						 var gridData = grid.dataItem(this);
						 componentId = gridData.component_id;
						 warehousingId = gridData.warehousing_id;
						 componentCd = gridData.component_cd;
						 });

						var params = {
								WAREHOUSING_ID : warehousingId,
								COMPONENT_ID : componentId,
								COMPONENT_CD: componentCd,
								INVENTORY_TYPE : "C"
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
						    	fnObj('LIST_consigned_warehousing_all_list').reloadGrid();
							}

						//끝지점
				}
			},
			{
				text: '닫기'
			}],
			minWidth : 200,
			title: fnGetSystemName(),
		    content: "<h3>선택한 재고를 <font color=red>생산대행 부품 목록</font>에서 삭제하시겠습니까?</h3>"
		}).data("kendoConfirm").open();
		//끝지점

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
	var grid = $('#consigned_warehousing_examine_list_gridbox').data('kendoGrid');
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
							REPRESENTATIVE_TYPE: "C"
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

	var grid = $('#consigned_warehousing_examine_list_gridbox').data('kendoGrid');
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

	var params = "INVENTORY_ID="+inventoryId+"&COMPONENT_CD="+componentCd;
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
    if(size == "S"){
    	width = "850";
    	height = "600";
    } else if(size == "M") {
    	width = "1000";
    	height = "600";
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
