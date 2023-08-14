<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="releaseInventory"					value="/order/releaseInventory.json" />
<c:url var="dataList"					value="/customDataList.json" />
<c:url var="createRelease"					value="/release/createRelease.json" />



<c:url var="cancelRelease"					value="/release/cancelRelease.json" />
<c:url var="returnRelease"					value="/release/returnRelease.json" />
<c:url var="release"					value="/release/release.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [releaseAllList.js]");

 	$('#${sid}_deleteBtn').remove();
 	$('#${sid}_printBtn').remove();
 	$('#${sid}_insertBtn').remove();

 	$('#${sid}_gridbox').off('dblclick');

 	var infCond = '<label>출고상태 &nbsp;&nbsp;&nbsp;</label><input id="release_state" style = "width: 150px;"/>';

	$('#${sid}_btns').prepend(infCond);

	$('.k-button').css('float','right');


	var stateCodeValueArray = ["ALL","W","R","C","B"];
	var stateContentTextArray = ["전체",
								"출고대기",
								"출고",
								"취소",
								"반품"];

	var dataArray = new Array();

	for(var i = 0; i<stateCodeValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = stateContentTextArray[i];
		datainfo.value =  stateCodeValueArray[i];
		dataArray.push(datainfo);
	}

	$("#release_state").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"ALL",
        height: 180,
        change: fnDropBoxonChange
      });

	window.onload = fuChangeDivWidth;
    window.onresize = fuChangeDivWidth;

    fuChangeDivWidth();

// 	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
//  		fnReleaseInventoryAllList();
//     });

    setTimeout(function() {
//     	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
//     		fnReleaseInventoryAllList();
//         });

    	$('#${sid}_gridbox').click(function(){
    		changeState();
		});

    	changeState();

	}, 500);


});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_header_title').width()-20;
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}

function fnReleaseInventoryAllList() {

	console.log("${sid}.fnReleaseInventoryAllList() Load");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(selItem.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var params = {
			ORDER_ID : selItem.order_id
	    };

	var url = "&cobjectid=order_id&cobjectval="+params.ORDER_ID;

	fnWindowOpen("/layoutNewW.do?xn=sale_Order_PartCompare_LAYOUT"+url,"component_id", "UW");

}

function changeState(){
	console.log("${sid}.changeState() Load");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());

	if(selItem.release_state =='R'){
		$('#${sid}_back_btn').show();
	} else {
		$('#${sid}_back_btn').hide();
	}

	if(selItem.release_state =='C'){
		$('#${sid}_cancel_btn').hide();
		$('#${sid}_back_btn').hide();
	} else {
		$('#${sid}_cancel_btn').show();
	}

	if(selItem.release_state =='W'){
		$('#${sid}_release_btn').show();
	} else {
		$('#${sid}_release_btn').hide();
	}
}

function fnCreateRelease() {

	console.log("${sid}.fnCreateRelease() Load");

	var url = '${createRelease}';

	$.ajax({
		url : url,
		type : "POST",
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				GochigoAlert(data.MSG);
// 				$('#${sid}_estimate_btn').show();
				fnObj('LIST_${sid}').reloadGrid();
			}
			else{
				GochigoAlert(data.MSG);
			}
		}
	});
}

function fnCancelRelease() {

	console.log("${sid}.fnCancelRelease() Load");

	var url = '${cancelRelease}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.release_state == 'C'){
		GochigoAlert('이미 취소된 출고입니다.');
		return;
	}

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				var params = {
						RELEASE_ID : selItem.release_id,
				        ORDER_ID : selItem.order_id,
				        RELEASE_STATE : 'C'

				    };

				$.ajax({
					url : url,
					type : "POST",
					data : params,
					async : false,
					success : function(data) {
						if(data.SUCCESS){
							GochigoAlert(data.MSG);

							$('#${sid}_back_btn').hide();
							$('#${sid}_estimate_btn').hide();
							$('#${sid}_cancel_btn').hide();
							$('#${sid}_release_btn').hide();

							fnObj('LIST_${sid}').reloadGrid();
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
	    content: "선택하신 출고를 취소하시겠습니까? 확인을 누르시면 출고된 재고는 모두 재고목록에 반환됩니다."
	}).data("kendoConfirm").open();
	//끝지점

}

function fnReturnRelease() {

	console.log("${sid}.fnReturnRelease() Load");

	var url = '${returnRelease}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.release_state == 'B'){
		GochigoAlert('이미 반품된 출고입니다.');
		return;
	}

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				var params = {
						 RELEASE_ID :selItem.release_id,
						 ORDER_ID :selItem.order_id,
					     RELEASE_STATE : 'B'
				    };

				$.ajax({
					url : url,
					type : "POST",
					data : params,
					async : false,
					success : function(data) {
						if(data.SUCCESS){
							GochigoAlert(data.MSG);
							$('#${sid}_back_btn').hide();
							$('#${sid}_estimate_btn').hide();
							$('#${sid}_cancel_btn').show();
							$('#${sid}_release_btn').show();
							fnObj('LIST_${sid}').reloadGrid();
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
	    content: "선택하신 출고를 반품하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점

}

function fnRelease() {

	console.log("${sid}.fnRelease() Load");

	var url = '${release}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.release_state == 'R'){
		GochigoAlert('이미 출고된 주문입니다.');
		return;
	}

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				var params = {
				        RELEASE_ID :selItem.release_id,
				        ORDER_ID :selItem.order_id,
				        RELEASE_STATE : 'R'
				    };

				$.ajax({
					url : url,
					type : "POST",
					data : params,
					async : false,
					success : function(data) {
						if(data.SUCCESS){
							GochigoAlert(data.MSG);
							$('#${sid}_back_btn').show();
							$('#${sid}_estimate_btn').hide();
							$('#${sid}_cancel_btn').show();
							$('#${sid}_release_btn').hide();
							fnObj('LIST_${sid}').reloadGrid();

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
	    content: "출고처리하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점

}


function fnDropBoxonChange(){

	console.log("orderCustomer.fnDropBoxonChange() Load");

	var url = '${dataList}';
	var check = $('#release_state').val();
	var cobjectid = "RELEASE_STATE"
	var qStr = "";

	if(check != "ALL"){
		cobjectval = check;
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + cobjectval;
	}

	if(check =='R'){
		$('#${sid}_back_btn').show();
	} else {
		$('#${sid}_back_btn').hide();
	}

	if(check =='O'){
		$('#${sid}_estimate_btn').show();
	} else {
		$('#${sid}_estimate_btn').hide();
	}

	if(check =='C'){
		$('#${sid}_cancel_btn').hide();
	} else {
		$('#${sid}_cancel_btn').show();
	}

	if(check =='E' || check =='B'){
		$('#${sid}_release_btn').show();
	} else {
		$('#${sid}_release_btn').hide();
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

    console.log(width);
    console.log(height);


	var xPos  = (document.body.clientWidth /2) - (width / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (height / 2);
    window.open("<c:url value='"+url+"'/>"+"&callbackName="+callbackName, "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
}

</script>
