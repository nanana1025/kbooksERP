<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="componentInventoryCheck"				value="/inventoryCheck/componentInventoryCheck.do"/>
<c:url var="warehousingExamineDelete"					value="/produce/warehousingExamineDelete.json" />
<c:url var="consignedComponentVisibleChange"					value="/consigned/consignedComponentVisibleChange.json" />
<c:url var="getUserId"											value="/user/getUserId.json"/>
<c:url var="dataList"														value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [produceConsignedComponent.js]");

	$('.basicBtn').remove();

// 	$('#${sid}_gridbox').attr("dblclick", 'fnWindowOpen_LTComponent("/layoutSelectP.do?xn=Comp'+_componentCd+'_All_LAYOUT","component_id","UW");');

// $('#${sid}_gridbox').attr("dblclick", 'fnConsignedCompanyInventoryList()');
$('#${sid}_gridbox').off('dblclick');
$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
	fnConsignedCompanyInventoryList();
});

	var infLTCondComponent = '<button id="consigned_produce_ltcomponent_customInsertBtn" type="button" onclick="fnLTComponentInsert()" class="k-button" style="float: right;">LT부품추가</button>';
	var infCondComponent = '<button id="consigned_produce_component_customInsertBtn" type="button" onclick="fnComponentInsert()" class="k-button" style="float: right; display:none;" >부품추가</button>';

	var infCondVisibleNComponent = '<button id="consigned_company_component_visibleN" type="button" onclick="fnComponentVisible(0)" class="k-button" style="float: right;" >숨기기</button>';
	var infCondVisibleYComponent = '<button id="consigned_company_component_visibleY" type="button" onclick="fnComponentVisible(1)" class="k-button" style="float: right; display:none;" >보이기</button>';
	var infCondReleaseComponent = '<button id="consigned_produce_component_customAddtBtn" type="button" onclick="fnComponentRelease()" class="k-button" style="float: right;display:none;" >출고재고생성</button>';

	var infCondInsertComponent = '<input id="component_cd" style = "width: 150px;float: right;"/>';

	var infCondVisible = '<input type="checkbox" id="chVisible" onclick="fnShowVisible()" style="float: right; margin: 8px 10px 0px 0px;"><label style="float: right; margin: 5px 5px 0px 0px;">전체보기</label>';


	var infcondComponentAll = infCondReleaseComponent + infCondVisibleNComponent + infCondVisibleYComponent + infCondComponent + infCondVisible;

	$('#${sid}_btns').prepend(infcondComponentAll);
// 	$('#consigned_component_part_list_btns').prepend(infCond);


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


	window.onload = fuChangeDivWidth;
    window.onresize = fuChangeDivWidth;

     fuChangeDivWidth();

     setTimeout(function() {

    	 $('#${sid}_gridbox').click(function(){
    		 changeState();
 		});

 	}, 500);

});

function fuChangeDivWidth(){
// 	console.log("${sid}");
    var Cwidth = $('#${sid}_header_title').width();
    $('#${sid}_btns').css({'width':Cwidth-20+'px'});
}

function changeState(){
	console.log("${sid}.changeState() Load");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());

	if(selItem.visible_yn == '1'){
		$('#consigned_company_component_visibleN').show();
		$('#consigned_company_component_visibleY').hide();
	} else {
		$('#consigned_company_component_visibleY').show();
		$('#consigned_company_component_visibleN').hide();
	}

}

function fnComponentVisible(visibleYn){

	console.log("${sid}.fnComponentVisible() Load");

	var url = '${consignedComponentVisibleChange}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var visible = selItem.visible_yn*1;

	var process = "";

	if(visibleYn == 1) process = "보임";
	else process = "숨김";

	if(visible == visibleYn){
		GochigoAlert('이미 '+process+' 처리된 부품입니다.');
		return;
	}

	var params = {
			CONSIGNED_ID : selItem.consigned_id,
			VISIBLE_YN : visibleYn
	    };

var isSuccess = false;

	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

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
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택한 부품을 "+process+" 처리하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}


function fnConsignedCompanyInventoryList(){

	console.log("${sid}.fnConsignedCompanyInventoryList() Load");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
	        COMPANY_ID : selItem.company_id,
	        COMPONENT_ID : selItem.component_id,
	    };


	var url = "&pid=${sid}&CUSTOMKEY=COMPANY_ID,COMPONENT_ID,INVENTORY_TYPE&CUSTOMVALUE="+params.COMPANY_ID+","+params.COMPONENT_ID+",C";
	fnWindowOpen("/layoutNewList.do?xn=company_Component_LAYOUT"+url,"component_id", "S");

}

function fnComponentInsert() {
	console.log("${sid}.fnComponentInsert() Load");

	var url = '${dataList}';
	var componentCd = $('#component_cd').val();

	if(componentCd == null){
		GochigoAlert('오류가 발생했습니다. 다시 생성해 주세요.');
		return;
	}

	var width = 800;
	var height = 450;
	var xn = '';

	if(componentCd == 'CPU' || componentCd == 'MBD' || componentCd == 'VGA' || componentCd == 'MEM' || componentCd == 'STG' || componentCd == 'MON'){
		xn = "createCore_Component_DATA";
		width = 800;
		height = 585;
	}
	else
		xn = "createConsigned_"+componentCd+"_DATA";

	var pid = '${pid}';
	var ptype = '${ptype}';
	var grid = $('#'+pid+'_gridbox').data('kendoGrid');
    var oid = '${objectId}';
    var queryString = "";

    if(pid && ptype == 'LIST'){
        var objArr = oid.split(",");
        var selItem = grid.dataItem(grid.select());
        if(selItem){
            var companyId = selItem.company_id;

            queryString += '&pid=${pid}';
            queryString += '&pobjectid=' + oid;
            queryString += '&pobjval=' + companyId;
        }
    }

    queryString += '&componentCd=' + componentCd;
    queryString += '&type=1';

//     if(componentCd == "CAS"){
// 		height = 450;
// 		 queryString += '&height=' + height;
// 	}

	queryString += '&height=' + height;

	console.log("queryString = "+queryString);

    var xPos  = (document.body.clientWidth /2) - (800 / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (600 / 2);
    window.open("<c:url value='/dataEdit.do'/>"+"?xn="+xn+"&sid=${sid}"+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

}

function fnLTComponentInsert() {
	console.log("${sid}.fnLTComponentInsert() Load");

	var url = '${dataList}';
	var componentCd = $('#component_cd').val();

	if(componentCd == null){
		GochigoAlert('오류가 발생했습니다. 다시 생성해 주세요.');
		return;
	}

	var width = 800;
	var height = 450;
	var xn = '';

	if(componentCd == 'CPU' || componentCd == 'MBD' || componentCd == 'VGA' || componentCd == 'MEM' || componentCd == 'STG' || componentCd == 'MON'){
		xn = "createCore_LTcomponent_DATA";
		width = 800;
		height = 400;
	}
	else
		xn = "createConsigned_"+componentCd+"_DATA";

	var pid = '${pid}';
	var ptype = '${ptype}';
	var grid = $('#'+pid+'_gridbox').data('kendoGrid');
    var oid = '${objectId}';
    var queryString = "";

    if(pid && ptype == 'LIST'){
        var objArr = oid.split(",");
        var selItem = grid.dataItem(grid.select());
        if(selItem){
            var companyId = selItem.company_id;

            queryString += '&pid=${pid}';
            queryString += '&pobjectid=' + oid;
            queryString += '&pobjval=' + companyId;
        }
    }

    queryString += '&componentCd=' + componentCd;
    queryString += '&type=1';
//     if(componentCd == "CAS"){
// 		height = 450;
// 		 queryString += '&height=' + height;
// 	}

	queryString += '&height=' + height;

	console.log("queryString = "+queryString);

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
	var grid = $('#admin_produce_warehousing_examine_list_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(!prohibit())
		return;

	var isSuccess = false;

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


function fnInventoryCheck(){
	console.log("${sid}.fnInventoryCheck() Load");

	var url = '${componentInventoryCheck}';

	var grid = $('#admin_produce_warehousing_examine_list_gridbox').data('kendoGrid');
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






function fnShowVisible(){
	console.log("${sid}.fnShowVisible() Load");

	var url = '${dataList}';

	var checkBox = $("[id*='chVisible']");
	var checked = checkBox.is(":checked");


	var grid = $('#consigned_component_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var qStr = "";





	$('#consigned_company_component_visibleN').hide();
	$('#consigned_company_component_visibleY').show();

    if(checked){
		qStr += '&cobjectid=COMPANY_ID';
		qStr += '&cobjectval=' + selItem.company_id;

		qStr += '&CUSTOMKEY=VISIBLE_YN';
        qStr += '&CUSTOMVALUE=2';
    }else{
    	qStr += '&cobjectid=COMPANY_ID';
        qStr += '&cobjectval=' + selItem.company_id;
    }

//     var qStr = '&BARCODE=' + _listMBDInventory.toString();

	fnObj('LIST_${sid}').reloadGridCustom(qStr);



// 	var dataSource = {
//            transport: {
//                read: {
//             	   url: "<c:url value='"+url+"'/>"+"?xn=${sid}"+"&"+qStr,
//                     dataType: "json"
//                },
//                parameterMap: function (data, type) {
//                	if(data.filter){
//                  	  //필터 시 날짜 변환
//                  	  var filters = data.filter.filters;
//                  	  $.each(filters, function(idx, filter){
//                         	if(filter.value && typeof filter.value.getFullYear === "function"){
//                         		var year = filter.value.getFullYear();
//                         		var month = filter.value.getMonth()+1;
//                         		if(month < 10){ month = "0"+month; }
//                         		var date = filter.value.getDate();
//                         		if(date < 10){ date = "0"+date; }
//                         		var valStr = year+"-"+month+"-"+date;
//                         		filter.value = valStr;
//                         	}
//                  	  });
//                    	}
//                  return data;
//                }
//            },
//            error : function(e) {
//            	console.log(e);
//            },
//            schema: {
//                data: 'gridData',
//                total: 'total',
//                model:{
//                     id:"${grididcol}",
//                    fields: JSON.parse('${fields}')
//                }
//            },
//            pageSize: 20,
//            serverPaging: true,
//            serverSorting : true,
//            serverFiltering: true
//        };
// 	var grid = $("#${sid}_gridbox").data("kendoGrid");
//  	grid.setDataSource(dataSource);
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
