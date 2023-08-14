<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="productPrint"								value="/product/productPrint.json"/>
<c:url var="printNtbCheckForWeb"					value="/print/printNtbCheckForWeb.json" />
<c:url var="productInventoryCheck"				value="/inventoryCheck/productInventoryCheck.do"/>
<c:url var="componentInventoryCheck"				value="/inventoryCheck/componentInventoryCheck.do"/>
<c:url var="getInventoryCheckInfo"					value="/inventoryCheck/getInventoryCheckInfo.json" />
<c:url var="deleteProduct"				value="/product/deleteProduct.json"/>

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

var _type = 2;
var _checkType = 1;
$(document).ready(function() {

	console.log("load [checkList.js]");

	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

	$('#${sid}_gridbox').off('dblclick');

	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
		fnComponentCheck();
    });

// 	setTimeout(function() {
		var infCond = '<button id="insert_admin_produce_create_component" onclick="fnProductPrint()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">제품정보 프린트</button>';
	 	var infCondPrint= '<button id="insert_admin_produce_create_print_component" onclick="fnPrintCheckInfo()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">검수결과 프린트</button>';
		var infCondPrintPort = '<label>프린터 포트 &nbsp;&nbsp;&nbsp;</label><input id="print_port" style = "width: 70px;"/>';

		$('#${sid}_btns').prepend(infCond);
		$('#${sid}_btns').prepend(infCondPrint);
	 	$('#${sid}_btns').prepend(infCondPrintPort);

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

// 	}, 1000);


});

function fuChangeDivWidth(){
// 	console.log("${sid}");
//     var Cwidth = $('#admin_produce_warehousing_examine_list_header_title').width();
//     $('#${sid}_btns').css({'width':Cwidth-20+'px'});
}


function fnProductPrint() {
	console.log("${sid}.fnProductPrint() Load");

	var url = '${productPrint}';

	var pGrid = $('#checkntb_warehousing_list_gridbox').data('kendoGrid');
	var pSelItem = pGrid.dataItem(pGrid.select());
	if(!pSelItem) {GochigoAlert('선택된 항목이 없습니다.'); return false;}

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return false;}

	var printPort = $('#print_port').val();

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				var params = {
						INVENTORY_ID : selItem.inventory_id,
				        BARCODE :  selItem.barcode,
				        COMPONENT_CD :  'MBD',
				        WAREHOUSING :  pSelItem.warehousing,
				        PORT: printPort,
				        REPRESENTATIVE_TYPE:"C"
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
							isPRefresh = data.PREFRESH;
// 							fnObj('LIST_${sid}').reloadGridCustom(queryCustom);
						}
						else{
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
	    content: "선택한 제품정보를 '"+ printPort + "' 프린터로 출력하시겠습니까? "
	}).data("kendoConfirm").open();
	//끝지점
}

function fnPrintCheckInfo(){

	var urlCheck = '${getInventoryCheckInfo}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return false;}

	var paramsPrint = {
			INVENTORY_ID : selItem.inventory_id,
			CHECK_TYPE: _checkType,
			TABLE_NM : "TN_CHECK_NTB"
		};

	var params;

	$.ajax({
		url : urlCheck,
		type : "GET",
		data : paramsPrint,
//			contentType: "application/json",
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				if(data.EXIST){
					params = data;
				}
				else{
					GochigoAlert(data.MSG+" 검수 결과를 등록하세요.");
					return;
				}
			}
			else{
				GochigoAlert(data.MSG);
				return;
			}
		}
	});

	var printPort = $('#print_port').val();
	var url = '${printNtbCheckForWeb}';

	params.PORT  = printPort;
	params.CHECK_TYPE = _checkType;
	params.INVENTORY_ID  = selItem.inventory_id;
	params.TYPE =  _type;

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
								_isPrintSuccess = true;
								GochigoAlert(data.MSG);
							}
							else{
								_isPrintSuccess = false;
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
	    content: "선택한 제품의 검수 결과를 '"+ printPort + "' 프린터로 출력하시겠습니까? "
	}).data("kendoConfirm").open();
	//끝지점
}

function fnComponentCheck(){
	console.log("${sid}.fnComponentCheck() Load");

	var url = '${componentInventoryCheck}';

	var pGrid = $('#componentCheck_warehousing_list_gridbox').data('kendoGrid');
	var pSelItem = pGrid.dataItem(pGrid.select());
	if(!pSelItem) {GochigoAlert('선택된 항목이 없습니다.'); return false;}

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return false;}

	var sid = "${sid}";
	var componentCd = selItem.component_cd;
	var params = "INVENTORY_ID="+selItem.inventory_id+"&COMPONENT_CD="+componentCd+"&CHECK_TYPE="+_checkType+"&RELOAD=Y&sid="+sid;

	fnCheckWindowOpen(url, params, componentCd);

}


function fnCustomDelete() {

	console.log("${sid}.fnCustomDelete() Load");

	var url = '${deleteProduct}';

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


	var isSuccess = false;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				params = {
					WAREHOUSING_ID: selItem.warehousing_id,
					INVENTORY_ID: selItem.inventory_id
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
					    	fnObj('LIST_${pid}').reloadGrid();
						}

					//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "<h3>선택한 제품을 <font color=red>재고 목록&제품목록</font>에서 삭제하시겠습니까?</h3><br><b><font color=blue> 제품관련 부품 모두 삭제됩니다.</font>"
	}).data("kendoConfirm").open();
	//끝지점
}

function fnCheckWindowOpen(url, params, size) {
    var width, height;
    if(size == "MON") {
    	width = "950";
    	height = "520";
    } else if(size == "CAS") {
    	width = "800";
    	height = "400";
    }else if(size == "MBD") {
    	width = "1000";
    	height = "500";
    }else if(size == "VGA") {
    	width = "850";
    	height = "380";
    }else if(size == "STG") {
    	width = "920";
    	height = "330";
    }
    else if(size == "ODD") {
    	width = "750";
    	height = "320";
    }else {
    	width = "700";
    	height = "330"
    }

	var xPos  = (document.body.clientWidth /2) - (width / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (height / 2);
    window.open("<c:url value='"+url+"'/>?"+params, "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
}


</script>
