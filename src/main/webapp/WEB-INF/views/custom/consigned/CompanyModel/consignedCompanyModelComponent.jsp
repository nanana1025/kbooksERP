<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="consignedModelComponentDelete"					value="/consigned/consignedModelComponentDelete.json" />
<c:url var="updateModelPartType"					value="/consigned/updateModelPartType.json" />
<c:url var="consignedPopup"							value="/CustomP.do"/>


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>


var _companyId;
$(document).ready(function() {

	console.log("load [consignedCompanyModel.js]");
	// $('.basicBtn').remove();
	 $('.basicBtn').remove();

	 var infLTCondComponent = '<button id="consigned_company_component_customInsertBtn" type="button" onclick="fnLTComponentInsert()" class="k-button" style="float: right;">부품추가</button>';
	 var infCondComponent = '<button id="consigned_company_component_customDeletetBtn" type="button" onclick="fnComponentDelete()" class="k-button" style="float: right;" >삭제</button>';
// 	var infCondInsertComponent = '<input id="component_cd" style = "width: 150px;float: right;"/>';
// 	var infcondComponentAll = infCondComponent+infLTCondComponent+infCondInsertComponent;
	var infcondComponentAll = infCondComponent+infLTCondComponent;
	$('#${sid}_btns').prepend(infcondComponentAll);

// 	var componentValueArray = ["CPU", "MBD", "MEM", "VGA", "STG", "MON",  "CAS", "POW", "ADP", "KEY", "MOU", "FAN", "CAB", "BAT"];
// 	var componentTextArray = [
// 								"CPU",
// 								"MAINBOARD",
// 								"MEMORY",
// 								"VGA",
// 								"STORAGE",
// 								"MONITOR",
// 								"CASE",
// 								"POWER",
// 								"ADAPTOR",
// 								"KEYBORAD",
// 								"MOUSE",
// 								"FAN",
// 								"CABLE",
// 								"BATTERY"];

	var componentValueArray = ["CPU", "MBD", "MEM", "VGA", "STG", "MON"];
	var componentTextArray = [
								"CPU",
								"MAINBOARD",
								"MEMORY",
								"VGA",
								"STORAGE",
								"MONITOR"];

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


	window.onload = fuChangeDivWidth;
    window.onresize = fuChangeDivWidth;

     fuChangeDivWidth();

     setTimeout(function() {
//   	$('.basicBtn').css('float','right');

	}, 500);

});

function fuChangeDivWidth(){
// 	console.log("${sid}");
    var Cwidth = $('#${sid}_header_title').width();
    $('#${sid}_btns').css({'width':Cwidth-20+'px'});
}

function fnUpdateType(type){

	console.log("${sid}.fnUpdateType() Load");

	var url = '${updateModelPartType}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var pGrid = $('#consigned_model_list_gridbox').data('kendoGrid');
	var pSelItem = pGrid.dataItem(pGrid.select());
	if(pSelItem == null) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
	        CONSIGNED_TYPE : type,
	        MODEL_LIST_ID: pSelItem.model_list_id
	    };
	var contents  = '';

	if(type == 1)
		contents  = '선택하신 부품을 생산대행재고로 변경하시겠습니까?';
	else
		contents  = '선택하신 부품을 자사재고로 변경하시겠습니까?';


	var isSuccess = false;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){

				//시작지점
				var grid = $('#${sid}_gridbox').data('kendoGrid');
				var rows = grid.select();

				var listComponentId= [];
					rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 listComponentId.push(gridData.component_id);
				 });

				params.LIST_COMPONENT_ID = listComponentId.toString();

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
 			    		fnObj('LIST_${sid}').reloadGrid();
				}

				//끝지점
			}
		},
		{
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: contents
	}).data("kendoConfirm").open();
	//끝지점



}


function fnLTComponentInsert() {

	console.log("consignedCompanyModel.fnModelInsert() Load");

	var grid = $('#consigned_model_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	params={
			COMPANY_ID: selItem.company_id,
			MODEL_NM: " "
	};


// 	var componentCd = $('#component_cd').val();

// 	if(componentCd == null){
// 		GochigoAlert('오류가 발생했습니다. 다시 생성해 주세요.');
// 		return;
// 	}

	var width = 800;
	var height = 350;
	var xn = '';

// 	if(componentCd == 'CPU' || componentCd == 'MBD' || componentCd == 'VGA' || componentCd == 'MEM' || componentCd == 'STG' || componentCd == 'MON'){
// 		xn = "createLTComponent_DATA";
// 		width = 800;
// 		height = 320;
// 	}
// 	else
		xn = "createConsigned_Model_Component_DATA";

	var pid = '${sid}';
	var ptype = '${ptype}';
    var queryString = "";
    _companyId = selItem.company_id;
//     queryString += '&componentCd=' + componentCd;
    queryString += '&pid=${sid}';
    queryString += '&COMPANY_ID=' + _companyId;
    queryString += '&MODEL_LIST_ID=' + selItem.model_list_id;

   fnWindowOpen_LTComponent("/layoutNewList.do?xn=consignedSelect_Component_LAYOUT"+queryString,"component_id","W");

}


function fnComponentDelete() {

	console.log("consignedCompanyModel.fnModelDelete() Load");

	var url = '${consignedModelComponentDelete}';
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
			text: '삭제',
			action: function(e){
				//시작지점

						params = {
								MODEL_PART_ID: selItem.model_part_id,
								MODEL_LIST_ID: selItem.model_list_id,
								COMPONENT_ID: selItem.component_id
						};

						$.ajax({
							url : url,
							type : "POST",
							data : params,
							async : false,
							success : function(data) {
								GochigoAlert(data.MSG, true, "dangol365 ERP");

								if(data.SUCCESS)
									fnObj('LIST_${sid}').reloadGrid();
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
	    content: "선택하신 부품을 삭제 하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

function fnWindowOpen_LTComponent(url, callbackName, size) {
    var width, height;
    if(size == "S"){
    	width = "820";
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
    window.open("<c:url value='"+url+"'/>"+"&callbackName="+callbackName+"&CUSTOMKEY=COMPANY_ID&CUSTOMVALUE="+_companyId, "selectConsignedComponent", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
}

</script>
