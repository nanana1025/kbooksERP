<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="releaseInventoryUpdate"					value="/release/releaseInventoryUpdate.json" />
<c:url var="releaseReturnInventory"					value="/release/releaseReturnInventory.json" />
<c:url var="print"													value="/print/print.json"/>

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [releaseSalePart.js]");

	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

	var infCondDelete = '<button id="release_part_list_delete_btn" type="button" onclick="fnReleaseReturnInventory()" class="k-button" style="float: left;">재고반환</button>';
// 	var infCondComponent = '<button id="admin_produce_warehousing_examine_list_customInsertBtn" type="button" onclick="fnComponentInsert()" class="k-button" style="float: left;">부품생성</button>';

	var infCondComponent = '<button id="${sid}_customInsertBtn" type="button" onclick="fnComponentInsert()" class="k-button" style="float: left;" >신규부품생성</button>';
	var infCondGetComponent = '<button id="${sid}_GetComponentBtn" type="button" onclick="fnGetComponent()" class="k-button" style="float: left;">부품 추가</button>';

	var infCondInsertComponent = '<input id="component_cd" style = "width: 150px;float: left;"/>';

	var infcondComponentAll = infCondDelete+infCondInsertComponent + infCondComponent + infCondGetComponent;
	$('#${sid}_btns').prepend(infcondComponentAll);


	var infCondPrint = '<button id="release_part_list_print_btn" type="button" onclick="fnPrint()" class="k-button" style="float: left;">프린트</button>';
	var infCondPrintPort = '<label id="print_port_label" style = "float: left;">프린터 포트 &nbsp;&nbsp;&nbsp;</label><input id="print_port" style = "width: 70px; float: left;"/>';

	var infcondPrintAll = infCondPrintPort + infCondPrint;
	$('#${sid}_btns').prepend(infcondPrintAll);

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

	setTimeout(function() {

		$('#release_part_list_delete_btn').css('float','right');
		$('#release_part_list_print_btn').css('float','left');

// 	 	$('.k-button').css('float','right');
 	}, 500);


});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_header_title').width()-20;
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}

function prohibit(){
	console.log("${sid}.prohibit() Load");

	var pGrid = $('#release_all_list_gridbox').data('kendoGrid');
	var pSelItem = pGrid.dataItem(pGrid.select());
	if(!pSelItem) {GochigoAlert('선택된 항목이 없습니다.'); return false;}

	if(pSelItem.release_state == 'R'){
		GochigoAlert('출고완료된 출고에는 재고를 추가할 수 없습니다.');
		return false;
	}

	return true;
}


function fnGetComponent() {
	console.log("${sid}.fnGetComponent() Load");

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
		xn = "selectCore_Release_Component_"+componentCd+"_DATA";
		width = 800;
		height = 570;
	}
	else
		xn = "select_Release"+componentCd+"_DATA";

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
    queryString += '&releases=' + selItem.releases;
    queryString += '&releaseId=' + selItem.release_id;
    queryString += '&stock=Y';
    queryString += '&representative_type=O';

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
		xn = "createCore_Release_Component_"+componentCd+"_DATA";
		width = 800;
		height = 550;
	}
	else
		xn = "create_Release"+componentCd+"_DATA";

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
    queryString += '&releases=' + selItem.releases;
    queryString += '&releaseId=' + selItem.release_id;
    queryString += '&stock=N';
    queryString += '&representative_type=O';


	queryString += '&height=' + height;

    var xPos  = (document.body.clientWidth /2) - (800 / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (600 / 2);
   window.open("<c:url value='/dataEdit.do'/>"+"?xn="+xn+"&sid=${sid}"+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

}


/*
function fnComponentInsert() {
	console.log("${sid}.fnComponentInsert() Load");

	var componentCd = $('#component_cd').val();

	if(componentCd == null){
		GochigoAlert('오류가 발생했습니다. 다시 생성해 주세요.');
		return;
	}

	if(!prohibit())
			return;

	var width = 800;
	var height = 450;
	var xn = '';

	if(componentCd == 'CPU' || componentCd == 'MBD' || componentCd == 'VGA' || componentCd == 'MEM' || componentCd == 'STG' || componentCd == 'MON'){
		xn = "createCore_Release_DATA";
		width = 800;
		height = 490;
	}
	else
		xn = "create"+componentCd+"_Release_DATA";

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
    queryString += '&releases=' + selItem.releases;
    queryString += '&releaseId=' + selItem.release_id;
    queryString += '&stock=Y';

	queryString += '&height=' + height;

    var xPos  = (document.body.clientWidth /2) - (800 / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (600 / 2);
   window.open("<c:url value='/dataEdit.do'/>"+"?xn="+xn+"&sid=${sid}"+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

}
*/
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
				var releases = '';
				 rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 releases = gridData.releases;
					 listBarcode.push(gridData.barcode);
					 });

					var params = {
							RELEASES : releases,
							BARCODE : listBarcode.toString(),
							USER_ID: userId,
							PORT: printPort,
							REPRESENTATIVE_TYPE: "O"
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

function fnInsertReleaseInventory() {
	console.log("${sid}.fnInsertReleaseInventory() Load");

	if(!prohibit())
			return;

	var width = 800;
	var height = 450;

	var xn = "release_Part_Insert_DATA";

	console.log( '${ptype}');
	var pid = 'release_all_list';
	var ptype = '${ptype}';
	var grid = $('#'+pid+'_gridbox').data('kendoGrid');
    var oid = 'RELEASE_ID';
    var queryString = "";

    if(pid && ptype == 'LIST'){
        var objArr = oid.split(",");
        var selItem = grid.dataItem(grid.select());
        if(selItem){
            var qParam = new Array();
            for(var i = 0; i < objArr.length; i++){
                qParam.push(selItem.get(objArr[i].toLowerCase()));
            }

            var pStr = qParam.join(","); //value 구분자

            queryString += '&pid=${pid}';
            queryString += '&objectid=' + oid;
            queryString += '&'+oid+'=' + pStr;
        }
    }


console.log(queryString);

    var xPos  = (document.body.clientWidth /2) - (800 / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (600 / 2);
   window.open("<c:url value='/dataView.do'/>"+"?xn="+xn+"&sid="+pid+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

}

function fnReleaseReturnInventory() {

	console.log("${sid}.fnReleaseReturnInventory() Load");

	var url = '${releaseReturnInventory}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();

	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var pGrid = $('#release_all_list_gridbox').data('kendoGrid');
	var selItem = pGrid.dataItem(pGrid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.release_state == 'R'){
		GochigoAlert('출고완료되어 변경할 수 없습니다.');
		return;
	}
	else if(selItem.release_state == 'C'){
		GochigoAlert('취소된 출고는 변경할 수 없습니다.');
		return;
	}

	var isSuccess = false;
	var queryCustom = "";

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				var listInventoryId = [];
				 rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 listInventoryId.push(gridData.inventory_id);
					 });

				 queryCustom = "cobjectid=release_id&cobjectval="+selItem.release_id;

				var params = {
				        RELEASE_ID :selItem.release_id,
				        INVENTORY_ID : listInventoryId.toString(),
				        ORDER_ID :selItem.order_id
				    };

				$.ajax({
					url : url,
					type : "POST",
					data : params,
					async : false,
					success : function(data) {
						if(data.SUCCESS){
							isSuccess = true;
							GochigoAlert(data.MSG);
// 							fnObj('LIST_${sid}').reloadGridCustom(queryCustom);
						}
						else{
							GochigoAlert(data.MSG);
						}
					}
				});

				 if(isSuccess){
// 				    	fnObj('LIST_sale_order_releasepart_list').reloadGridCustom(queryCustom);
// 				    	fnObj('LIST_sale_order_customerpart_list').reloadGridCustom(queryCustom);

				    	fnObj('LIST_release_all_list').reloadGrid();
						//fnClose();
					}
				//끝지점
			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택하신 재고를 재고 목록으로 반환하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
