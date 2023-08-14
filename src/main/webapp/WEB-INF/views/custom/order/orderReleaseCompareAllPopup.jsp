<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="dataList"							value="/customDataList.json" />
<c:url var="releaseReturnInventory"					value="/order/releaseReturnInventory.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [orderReleaseComparePopup]");
 	$('#${sid}_printBtn').remove();
 	$('#${sid}_insertBtn').remove();
 	$('#${sid}_deleteBtn').remove();

//  	$('#closeBtn').remove();
//  	$('#selectBtn').remove();

	if('${sid}' == 'sale_order_partcompare_customer'){
		var  infCond = '<button id="produce_order_closeBtn" class="header_title_btn k-button" data-role="button" role="button" onclick="fnClose()" aria-disabled="false" tabindex="0" style="float: right;">닫기</button>';

	}else{
		var  infCond = '<button id="produce_order_closeBtn" class="header_title_btn k-button" data-role="button" role="button" onclick="fnClose()" aria-disabled="false" tabindex="0" style="float: right;">닫기</button>';
// 		var  infCond = '<button id="produce_order_releaseReturnBtn" class="header_title_btn k-button" data-role="button" role="button" onclick="fnReleaseReturnInventory()" aria-disabled="false" tabindex="0" style="float: right;">재고 반환</button>';

	}

	$('#${sid}_header_title').prepend(infCond);



	$('#${sid}_gridbox').off('dblclick');

    fnGridInit();
    fuChangeDivWidth();
});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_header_title').width()-20;
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}

function fnClose(){
	self.close();
}


function fnGridInit(){

	console.log("${sid}.fnGridInit() Load");

	var openerGrid = opener.$('#sale_order_all_list_gridbox').data('kendoGrid');
	var openerSelItem = openerGrid.dataItem(openerGrid.select());
	if(!openerSelItem) {
		GochigoAlert('부모의 선택된 항목이 없습니다.');
		self.close();
	}


	var url = '${dataList}';
	var check = $('#warehousing_state').val();
	var cobjectid = "ORDER_ID";
	var cobjectval = openerSelItem.order_id;
	var qStr = "";
	var sid = '${sid}';
	var listNm = "";

	if('${sid}' == 'sale_order_partcompare_customer')
		listNm ='sale_Order_PartCompare_Customer_LIST';
	else
		listNm ='sale_Order_PartCompare_Release_LIST';

	console.log("${sid} : "+listNm);

    qStr += '&cobjectid=' + cobjectid;
    qStr += '&cobjectval=' + cobjectval;


	var dataSource = {
           transport: {
               read: {
            	   url: "<c:url value='"+url+"'/>"+"?xn="+listNm+"&"+qStr,
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

function fnReleaseReturnInventory() {

	console.log("sale_order_partcompare_release.fnReleaseReturnInventory() Load");

	var url = '${releaseReturnInventory}';

	var grid = $('#sale_order_partcompare_release_gridbox').data('kendoGrid');
	var rows = grid.select();

	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var pGrid = opener.$('#sale_order_partcompare_release_gridbox').data('kendoGrid');
	var selItem = pGrid.dataItem(pGrid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	if(selItem.order_state == 'R' || selItem.order_state == 'RW'){
		GochigoAlert('출고단계인 주문은 변경할 수 없습니다.');
		return;
	}
// 	else if(selItem.order_state == 'C'){
// 		GochigoAlert('취소된 주문은 변경할 수 없습니다.');
// 		return;
// 	}else if(selItem.order_state == 'O'){
// 		GochigoAlert('주문(견적 대기)중인 주문은 변경할 수 없습니다.');
// 		return;
// 	}

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
				var componentId = '';
				var orderId = '';
				 rows.each(function (index, row) {
					 var gridData = grid.dataItem(this);
					 componentId = gridData.component_id;
					 orderId = gridData.order_id;
					 listInventoryId.push(gridData.inventory_id);
					 });

				 queryCustom = "cobjectid=order_id,component_id&cobjectval="+orderId+','+componentId;

				var params = {
				        ORDER_ID :orderId,
				        INVENTORY_ID : listInventoryId.toString(),
				        COMPONENT_ID :componentId
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
				    	fnObj('LIST_sale_order_partcompare_customer').reloadGridCustom(queryCustom);
				    	fnObj('LIST_sale_order_partcompare_release').reloadGridCustom(queryCustom);

				    	opener.fnObj('LIST_sale_order_all_list').reloadGrid();
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
