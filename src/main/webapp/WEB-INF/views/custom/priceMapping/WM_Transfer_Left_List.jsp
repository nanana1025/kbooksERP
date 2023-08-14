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

	console.log("load [WM_Transfer_Left_List.js]");

	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

// 	var infCondConfirmBtn = '<button id="${sid}_searchbtn" type="button" onclick="fnSearch()" class="k-button" style="float: left;">검색</button>';

// 	$('#${sid}_btns').prepend(infCondConfirmBtn);


	var infCondDate = '&nbsp;&nbsp;&nbsp;<label>날짜선택 &nbsp;&nbsp;&nbsp;</label><input id="datetimepicker_startL" title="datetimepicker" style="width: 120px;" /> ~ <input id="datetimepicker_endL" title="datetimepicker" style="width: 120px;" />';
	$('#${sid}_btns').prepend(infCondDate);

	$("#datetimepicker_startL").kendoDatePicker({
        change: fnDropBoxonChange
      });
	$("#datetimepicker_endL").kendoDatePicker({
        change: fnDropBoxonChange
    });



	var infCondMappingYN = ' &nbsp;&nbsp;&nbsp;<label>매핑여부 &nbsp;&nbsp;&nbsp;</label><input id="mapping_YNL" style = "width: 100px;"/>';
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

	$("#mapping_YNL").kendoDropDownList({
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


function fnDropBoxonChange(page, pageSize){

	console.log("${sid}.fnDropBoxonChange() Load");

	var url = '${dataList}';

	var check = $('#mapping_YNL').val();
	var cobjectid = "MAPPING_YN";

	var qStr = "";

   	if(check == "ALL"){

	}else{
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + check;
	}

   	var dateStartCheck = $('#datetimepicker_startL').val();
   	var dateEndCheck = $('#datetimepicker_endL').val();

   	if(dateStartCheck != '')
   		qStr += '&dateStart=' + dateStartCheck;

	if(dateEndCheck != '')
    qStr += '&dateEnd=' + dateEndCheck;



    fnObj('LIST_${sid}').reloadGridCustomPrice(qStr);
}


</script>
