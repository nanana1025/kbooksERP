<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="dataList"					value="/customDataList.json" />
<c:url var="createOrder"					value="/order/createOrder.json" />
<c:url var="cancelOrder"					value="/order/cancelOrder.json" />
<c:url var="returnOrder"					value="/order/returnOrder.json" />
<c:url var="estimateOrder"					value="/order/estimateOrder.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [orderCustomer.js]");
 	$('#admin_sale_order_customer_list_deleteBtn').remove();
 	$('#admin_sale_order_customer_list_printBtn').remove();
 	$('#admin_sale_order_customer_list_insertBtn').remove();
 	$('#admin_sale_order_customer_list_back_btn').hide();
//  	$('#admin_sale_order_customer_list_estimate_btn').hide();

	var infCond = '<label>주문상태 &nbsp;&nbsp;&nbsp;</label><input id="order_state" style = "width: 150px;"/>';

	$('#${sid}_btns').prepend(infCond);

	$('.k-button').css('float','right');


	var stateCodeValueArray = ["ALL","O","E","D","C","R","B"];
	var stateContentTextArray = ["전체",
								"주문",
								"견적",
								"확정",
								"취소",
								"출고",
								"반품"];

	var dataArray = new Array();

	for(var i = 0; i<stateCodeValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = stateContentTextArray[i];
		datainfo.value =  stateCodeValueArray[i];
		dataArray.push(datainfo);
	}

	$("#order_state").kendoDropDownList({
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

    setTimeout(function() {

    	$('#admin_sale_order_customer_list_gridbox').click(function(){
    		changeState();
		});

    	changeState();
	}, 500);


});

function changeState(){
	var grid = $('#admin_sale_order_customer_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());

	if(selItem.order_state =='R'){
		$('#admin_sale_order_customer_list_back_btn').show();
	} else {
		$('#admin_sale_order_customer_list_back_btn').hide();
	}

	if(selItem.order_state =='O'){
		$('#admin_sale_order_customer_list_estimate_btn').show();
	} else {
		$('#admin_sale_order_customer_list_estimate_btn').hide();
	}

	if(selItem.order_state =='C'){
		$('#admin_sale_order_customer_list_cancel_btn').hide();
	} else {
		$('#admin_sale_order_customer_list_cancel_btn').show();
	}
}

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_header_title').width()-20;
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}

function fnCreateOrder() {

	console.log("admin_sale_order_customer_list.fnCreateOrder() Load");

	var url = '${createOrder}';

	$.ajax({
		url : url,
		type : "POST",
		async : false,
		success : function(data) {
			if(data.SUCCESS){
				GochigoAlert(data.MSG);
// 				$('#${sid}_estimate_btn').show();
// 				$('#${sid}_cancel_btn').show();
// 				$('#${sid}_back_btn').hide();

				fnObj('LIST_admin_sale_order_customer_list').reloadGrid();
			}
			else{
				GochigoAlert(data.MSG);
			}
		}
	});
}

function fnCancelOrder() {

	console.log("admin_sale_order_customer_list.fnCreateOrder() Load");

	var url = '${cancelOrder}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.orser_state == 'C'){
		GochigoAlert('이미 취소된 주문입니다.');
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
				        ORDER_ID : selItem.order_id,
				        ORDER_STATE : 'C'
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

							fnObj('LIST_admin_sale_order_customer_list').reloadGrid();
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
	    content: "선택하신 주문을 취소하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점

}

function fnReturnOrder() {

	console.log("admin_sale_order_customer_list.fnReturnOrder() Load");

	var url = '${returnOrder}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.orser_state == 'B'){
		GochigoAlert('이미 반품된 주문입니다.');
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
				        ORDER_ID : selItem.order_id,
				        ORDER_STATE : 'B'
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
							fnObj('LIST_admin_sale_order_customer_list').reloadGrid();
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
	    content: "선택하신 주문을 반품하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점

}

function fnEstimateOrder() {

	console.log("admin_sale_order_customer_list.fnEstimateOrder() Load");

	var url = '${estimateOrder}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.orser_state == 'E'){
		GochigoAlert('이미 견적 요청된 주문입니다.');
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
				        ORDER_ID : selItem.order_id,
				        ORDER_STATE : 'E'
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
							fnObj('LIST_admin_sale_order_customer_list').reloadGrid();

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
	    content: "선택하신 주문을 견적 요청하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점

}

function fnDropBoxonChange(){

	console.log("orderCustomer.fnDropBoxonChange() Load");

	var url = '${dataList}';
	var check = $('#order_state').val();
	var cobjectid = "ORDER_STATE"
	var qStr = "";

	if(check != "ALL"){
		cobjectval = check;
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + cobjectval;
	}

	if(check =='R'){
		$('#admin_sale_order_customer_list_back_btn').show();
	} else {
		$('#admin_sale_order_customer_list_back_btn').hide();
	}

	if(check =='O'){
		$('#admin_sale_order_customer_list_estimate_btn').show();
	} else {
		$('#admin_sale_order_customer_list_estimate_btn').hide();
	}

	if(check =='C'){
		$('#admin_sale_order_customer_list_cancel_btn').hide();
	} else {
		$('#admin_sale_order_customer_list_cancel_btn').show();
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

</script>
