<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="updateCustomUseYN"								value="/priceMapping/updateCustomUseYN.json" />
<c:url var="customDataListPrice"								value="/customDataListPrice.json" />
<c:url var="dataList"													value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>


<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [WM_Transfer_Right_List.js]");


	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

// 	var infCondConfirmBtn = '<button id="${sid}_searchbtn" type="button" onclick="fnSearch()" class="k-button" style="float: left;">검색</button>';

// 	$('#${sid}_btns').prepend(infCondConfirmBtn);


	var infCondDate = '&nbsp;&nbsp;&nbsp;<label>날짜선택 &nbsp;&nbsp;&nbsp;</label><input id="datetimepicker_startR" title="datetimepicker" style="width: 120px;" /> ~ <input id="datetimepicker_endR" title="datetimepicker" style="width: 120px;" />';
	$('#${sid}_btns').prepend(infCondDate);

	$("#datetimepicker_startR").kendoDatePicker({
        change: fnDropBoxonChange
      });
	$("#datetimepicker_endR").kendoDatePicker({
        change: fnDropBoxonChange
    });



	var infCondMappingYN = ' &nbsp;&nbsp;&nbsp;<label>매핑여부 &nbsp;&nbsp;&nbsp;</label><input id="mapping_YNR" style = "width: 100px;"/>';
	$('#${sid}_btns').prepend(infCondMappingYN);

	var mappingYNValueArray = ["ALL", "Y", "N"];
	var mappingYNTextArray = ["전체",
								"Y",
								"N"];

	var dataArray = new Array();

	for(var i = 0; i<mappingYNValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = mappingYNTextArray[i];
		datainfo.value =  mappingYNValueArray[i];
		dataArray.push(datainfo);
	}

	$("#mapping_YNR").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"all",
        height: 100,
        change: fnDropBoxonChange
      });

	window.onload = fuChangeDivWidth;
    window.onresize = fuChangeDivWidth;

     fuChangeDivWidth();
     $('.k-button').css('float','right');


     setTimeout(function() {

    	 $('#${sid}_searchbtn').css('float','left');

 	}, 500);

});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}


function fnPartUseY() {

	console.log("${sid}.fnPartUseY() Load");

	var url = '${updateCustomUseYN}';

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();

	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var isSuccess = false;

	var tGrid = $("#${sid}_gridbox");
  	var tGridData = tGrid.data("kendoGrid").dataSource;
	var page = tGridData.page();

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

					var listOtherPurchasePartId = [];
					 rows.each(function (index, row) {
						 var gridData = grid.dataItem(this);
						 listOtherPurchasePartId.push(gridData.other_purchase_part_id);
					 });

					var params = {
							OTHER_PURCHASE_PART_ID : listOtherPurchasePartId.toString(),
							USE_YN : 1
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

						 var check = $('#confirm_cd').val();

						 if(check == 'ALL')
					    		fnObj('LIST_${sid}').reloadGrid();
						 else{
							 	console.log("page = "+page) ;
				                fnDropBoxonChange(page, 20);
						 }

						 $('#${sid}_useYbtn').hide();
						 $('#${sid}_useNbtn').show();

					}

					//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "<h3>선택한 부품 사용으로 처리하시겠습니까?</h3>"
	}).data("kendoConfirm").open();
	//끝지점
}

function fnPartUseN() {

	console.log("${sid}.fnPriceConfirmReturn() Load");

	var url = '${updateCustomUseYN}';

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();

	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var isSuccess = false;

	var tGrid = $("#${sid}_gridbox");
  	var tGridData = tGrid.data("kendoGrid").dataSource;
	var page = tGridData.page();

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

					var listOtherPurchasePartId = [];
					 rows.each(function (index, row) {
						 var gridData = grid.dataItem(this);
						 listOtherPurchasePartId.push(gridData.other_purchase_part_id);
					 });

					var params = {
							OTHER_PURCHASE_PART_ID : listOtherPurchasePartId.toString(),
							USE_YN : 0
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

						 var check = $('#confirm_cd').val();

						 if(check == 'ALL')
					    		fnObj('LIST_${sid}').reloadGrid();
						 else{
							 	console.log("page = "+page) ;
				                fnDropBoxonChange(page, 20);
						 }

						 $('#${sid}_useYbtn').show();
						 $('#${sid}_useNbtn').hide();

					}

					//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "<h3>선택한 부품을 미사용으로 처리하시겠습니까?</h3><br><b><font color=blue> 푸붐을 미사용으로 처리하면 매핑된 부품은 모두 해제됩니다. </font>"
	}).data("kendoConfirm").open();
	//끝지점
}


function fnMappingTransfer(){
	console.log("${sid}.fnMappingTransfer(Right) Load");

	var width = 800;
	var height = 450;

	var gridR = $('#${sid}_gridbox').data('kendoGrid');
	var rowsR = gridR.select();



	var gridL = $('#pricemapping_wm_wm_left_list_gridbox').data('kendoGrid');
	var rowsL = gridL.select();

	if(rowsR.length < 1 && rowsL.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}
	else if(rowsR.length < 1) {GochigoAlert('오른쪽 화면에 선택된 항목이 없습니다.'); return;}
	else if(rowsL.length < 1) {GochigoAlert('왼쪽 화면에 선택된 항목이 없습니다.'); return;}

	var xn = "priceMapping_WM_WM_DATA";

	var pid = 'pricemapping_wm_wm_list';
    var oidL = 'W_IDL';
    var oidR = 'W_IDR';
    var queryString = "";

    var selItemL = gridL.dataItem(gridL.select());
    var pStrL = selItemL.other_purchase_part_id;

    var selItemR = gridR.dataItem(gridR.select());
    var pStrR = selItemR.other_purchase_part_id;

    queryString += '&pid=${pid}';
    queryString += '&objectid=' + oidL+","+oidR;
    queryString += '&cobjectval=' + pStrL+","+pStrR;
    queryString += '&' + oidL + '=' + pStrL;
    queryString += '&' + oidR + '=' + pStrR;



	queryString += '&height=' + height;

    var xPos  = (document.body.clientWidth /2) - (800 / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (600 / 2);

//    window.open("<c:url value='/dataView.do'/>"+"?xn="+xn+"&sid="+pid+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

	fnWindowOpen("/layoutNewW.do?xn=priceMapping_WM_Transfer_LAYOUT"+queryString,null, "L");

}

function fnCompareWarehousingData() {

	console.log("${sid}.fnCompareWarehousingData() Load");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(selItem.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
	        WARRHOUSING_ID : selItem.warehousing_id
	    };

	var url = "&cobjectid=warehousing_id&cobjectval="+params.WARRHOUSING_ID;

	fnWindowOpen("/layoutNewW.do?xn=Produce_warehousing_PartCompare_LAYOUT"+url,null, "L");

}


function fnDropBoxonChange(page, pageSize){

	console.log("${sid}.fnDropBoxonChange() Load");

	var url = '${dataList}';

	var check = $('#mapping_YNR').val();
	var cobjectid = "MAPPING_YN";

	var qStr = "";

   	if(check == "ALL"){

	}else{
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + check;
	}

   	var dateStartCheck = $('#datetimepicker_startR').val();
   	var dateEndCheck = $('#datetimepicker_endR').val();

   	if(dateStartCheck != '')
   		qStr += '&dateStart=' + dateStartCheck;

	if(dateEndCheck != '')
    qStr += '&dateEnd=' + dateEndCheck;



    fnObj('LIST_${sid}').reloadGridCustomPrice(qStr);
}


function fnWindowOpen(url, callbackName, size) {
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
