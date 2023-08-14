<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="createWarehousing"										value="/produce/createWarehousing.json" />
<c:url var="deleteWarehousing"										value="/produce/deleteWarehousing.json" />
<c:url var="dataList"														value="/customDataList.json" />
<c:url var="printOne"													value="/print/printOne.json"/>
<c:url var="WarehousingExamineComplete"						value="/produce/WarehousingExamineComplete.json"/>
<c:url var="WarehousingExamineCompleteCancel"						value="/produce/WarehousingExamineCompleteCancel.json"/>

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [warehousingAllList.js]");
	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

	$('#${sid}_gridbox').off('dblclick');

	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
 		fnCompareWarehousingData();
    });




	var infCond = '<label>입고상태 &nbsp;&nbsp;&nbsp;</label><input id="warehousing_state" style = "width: 150px;"/>';
	var infCondPrintBarcode = '<button id="${sid}_PrintBarcode" type="button" onclick="fnPrintBarcode()" class="k-button" style = "float: right;">입고번호출력</button>';
	var infCondPrintPort = '<input id="print_port_top" style = "width: 70px; float: right;"/>';
	$('.k-button').css('float','right');

	$('#${sid}_btns').prepend(infCond);
	$('#${sid}_btns').prepend(infCondPrintBarcode);
	$('#${sid}_btns').prepend(infCondPrintPort);



	var stateCodeValueArray = ["ALL","E","W","C", "F"];
	var stateContentTextArray = ["전체",
								"입고",
								"입고 대기",
								"검수완료",
								"완료"];

	var dataArray = new Array();

	for(var i = 0; i<stateCodeValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = stateContentTextArray[i];
		datainfo.value =  stateCodeValueArray[i];
		dataArray.push(datainfo);
	}


	$("#warehousing_state").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"ALL",
        height: 130,
        change: fnDropBoxonChange
      });

	var dataArray1 = new Array();
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

	for(var i = 0; i<printPortValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = printPortTextArray[i];
		datainfo.value =  printPortValueArray[i];
		dataArray1.push(datainfo);
	}

	$("#print_port_top").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray1,
        value:"5000",
        height: 155
      });

	window.onload = fuChangeDivWidth;
    window.onresize = fuChangeDivWidth;

    fuChangeDivWidth();

    fnDropBoxonChange();

    setTimeout(function() {
    	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
//     		fnReleaseInventory();
        });

    	$('#${sid}_gridbox').click(function(){
    		changeState();
		});

    	changeState();

	}, 1000);


});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}

function fnPrintBarcode()
{
	console.log("${sid}.fnPrintBarcode() Load");
	var userId = "${sessionScope.userInfo.user_id}";

	 if(userId == ""){
			GochigoAlert('세션이 만료되었습니다. 다시 로그인 후 시도해 주세요.');
			return false;
	}

	var url = '${printOne}';
	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var printPort = $('#print_port_top').val();

	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

					var params = {
							WAREHOUSING : selItem.warehousing,
							CONTENTS :selItem.spec_nm,
							USER_ID: userId,
							PORT: printPort,
							REPRESENTATIVE_TYPE:"W"
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
	    content: "입고번호를 출력하시겠습니까(PORT:"+printPort+")?"
	}).data("kendoConfirm").open();
	//끝지점
}
function changeState(){
	console.log("${sid}.changeState() Load");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());

// 	console.log("selItem.warehousing_state = "+selItem.warehousing_state);
// 	console.log("${sid}_examine_complete_btn = ");

	if(selItem.warehousing_state =='C'){
		$('#${sid}_examine_complete_btn').hide();
		$('#${sid}_examine_complete_cancel_btn').show();
	} else {
		$('#${sid}_examine_complete_btn').show();
		$('#${sid}_examine_complete_cancel_btn').hide();
	}

}


function fnExportToExcel() {

	console.log("${sid}.fnExportToExcel() Load");

	var url = "/layout.do?xn=Produce_Warehousing_Export_LAYOUT";
	$(location).attr('href',url);


// 	fnWindowOpen("/layoutNewW.do?xn=Produce_warehousing_Export_LAYOUT",null, "F");

}

function fnExamineComplete() {

	console.log("${sid}.fnExamineComplete() Load");

	var url = '${WarehousingExamineComplete}';

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.warehousing_state == "C"){
		GochigoAlert('이미 검수완료 처리되었습니다.'); return;
	}

	params = {
			WAREHOUSING: selItem.warehousing,
		};

	var isSuccess = false;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점
				$.ajax({
					url : url,
					type : "POST",
					async : false,
					data : JSON.stringify(params),
					contentType: "application/json",
					success : function(data) {
						if(data.SUCCESS){
							isSuccess = true;
							GochigoAlert(data.MSG);
						}
						else{
							GochigoAlert(data.MSG);
						}
					}
				});

				if(isSuccess)
				{
					fnObj('LIST_${sid}').reloadGrid();
					$('#${sid}_examine_complete_btn').hide();
					$('#${sid}_examine_complete_cancel_btn').show();
				}

				//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "확인을 누르시면 검수완료 처리됩니다."
	}).data("kendoConfirm").open();
	//끝지점

}

function fnExamineCompleteCancel() {

	console.log("${sid}.fnExamineCompleteCancel() Load");

	var url = '${WarehousingExamineCompleteCancel}';

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


	 if(selItem.warehousing_state != "C"){
		GochigoAlert(' 검수완료상태가 아닙니다.'); return;
	}

	params = {
			WAREHOUSING: selItem.warehousing,
		};

	var isSuccess = false;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점
				$.ajax({
					url : url,
					type : "POST",
					async : false,
					data : JSON.stringify(params),
					contentType: "application/json",
					success : function(data) {
						if(data.SUCCESS){
							isSuccess = true;
							GochigoAlert(data.MSG);
						}
						else{
							GochigoAlert(data.MSG);
						}
					}
				});

				if(isSuccess)
				{
					fnObj('LIST_${sid}').reloadGrid();
					$('#${sid}_examine_complete_btn').show();
					$('#${sid}_examine_complete_cancel_btn').hide();
				}

				//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "확인을 누르시면 입고 상태로 처리됩니다."
	}).data("kendoConfirm").open();
	//끝지점

}

function fnCreateWarehousing() {

	console.log("${sid}.fnCreateWarehousing() Load");

	var url = '${createWarehousing}';

	var params = {
			WAREHOUSING_TYPE: 1
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				GochigoAlert(data.MSG);
			}
			else{
				GochigoAlert(data.MSG);
			}
		}
	});

	fnObj('LIST_${sid}').reloadGrid();


}


function fnDeleteWarehousing() {

	console.log("${sid}.fnDeleteWarehousing() Load");

	var url = '${deleteWarehousing}';

	var params = "";
	var msg = "";
	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var warehousingId = selItem.state_cd;
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
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "정말 삭제하시겠습니까?"
	}).data("kendoConfirm").open();

	if(isSuccess)
		fnObj('LIST_${sid}').reloadGrid();
	//끝지점
}

function fnDropBoxonChange(){

	console.log("${sid}.fnDropBoxonChange() Load");

	var url = '${dataList}';
	var check = $('#warehousing_state').val();
	var cobjectid = "WAREHOUSING_STATE"
	var qStr = "";

	if(check == "ALL"){
	    qStr += '&cnobjectid=' + cobjectid;
	    qStr += '&cnobjectval=D';
	}else if(check == "D"){
		cobjectval = check;
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + cobjectval;
	}else{
		cobjectval = check;
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + cobjectval;

	    qStr += '&cnobjectid=' + cobjectid;
	    qStr += '&cnobjectval=D';
	}

	var dataSource = {
           transport: {
               read: {
            	   url: "<c:url value='"+url+"'/>"+"?xn=${sid}"+"&"+qStr,
                    dataType: "json"
               },
               parameterMap: function (data, type) {
               	if(data.filter){
                 	  //필터 시 날짜 변환
                 	  var filters = data.filter.filters;
                 	  $.each(filters, function(idx, filter){
                        	if(filter.value && typeof filter.value.getFullYear === "function"){
                        		var year = filter.value.getFullYear();
                        		var month = filter.value.getMonth()+1;
                        		if(month < 10){ month = "0"+month; }
                        		var date = filter.value.getDate();
                        		if(date < 10){ date = "0"+date; }
                        		var valStr = year+"-"+month+"-"+date;
                        		filter.value = valStr;
                        	}
                 	  });
                   	}
                 return data;
               }
           },
           error : function(e) {
           	console.log(e);
           },
           schema: {
               data: 'gridData',
               total: 'total',
               model:{
                    id:"${grididcol}",
                   fields: JSON.parse('${fields}')
               }
           },
           pageSize: 20,
           serverPaging: true,
           serverSorting : true,
           serverFiltering: true
       };
	var grid = $("#${sid}_gridbox").data("kendoGrid");
 	grid.setDataSource(dataSource);
}

function fnCompareWarehousingData() {

	console.log("${sid}.fnCompareWarehousingData() Load");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(selItem.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
			WAREHOUSING_ID : selItem.warehousing_id
	    };

	var url = "&pid=${sid}&cobjectid=warehousing_id&cobjectval="+params.WAREHOUSING_ID;

	fnWindowOpen("/layoutNewW.do?xn=Produce_warehousing_PartCompare_LAYOUT"+url,null, "L");

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
