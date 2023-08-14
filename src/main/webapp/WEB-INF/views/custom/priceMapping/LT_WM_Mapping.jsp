<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="updateCustomMappingConfirm"					value="/priceMapping/updateCustomMappingConfirm.json" />
<c:url var="customDataListPrice"								value="/customDataListPrice.json" />
<c:url var="dataList"													value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [worldmemoryMatching.js]");

	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

	var infCondConfirmBtn = '<button id="${sid}_searchbtn" type="button" onclick="fnSearch()" class="k-button" style="float: left;">검색</button>';

// 	$('#${sid}_btns').prepend(infCondConfirmBtn);

	var infCondConfirm = '<label>확정여부 &nbsp;&nbsp;&nbsp;</label><input id="confirm_cd" style = "width: 100px;"/>';

	$('#${sid}_btns').prepend(infCondConfirm);

	var confirmValueArray = ["ALL", "Y", "N"];
	var confirmTextArray = ["전체",
								"확정",
								"미확정"];

	var dataArray = new Array();

	for(var i = 0; i<confirmValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = confirmTextArray[i];
		datainfo.value =  confirmValueArray[i];
		dataArray.push(datainfo);
	}

	$("#confirm_cd").kendoDropDownList({
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
//     	$('#admin_produce_warehousing_examine_list_component_intertBtn').css('float','left');

 		$('#${sid}_searchbtn').css('float','left');
//     	 $('#admin_produce_warehousing_examine_list_print_btn').css('float','left');
//     	 $('#print_port').css('float','left');
 	}, 500);

});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}



function fnPriceConfirm() {

	console.log("${sid}.fnPriceConfirm() Load");

	var url = '${updateCustomMappingConfirm}';

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

					var listCustomPartId = [];
					var listWMId = [];
					var listPartKey = [];
					 rows.each(function (index, row) {
						 var gridData = grid.dataItem(this);
						 var worldmemoryId= gridData.worldmemory_id;
						 if(worldmemoryId != null && worldmemoryId > 0){
							 listCustomPartId.push(gridData.custom_part_id);
							 listWMId.push(worldmemoryId);
							 listPartKey.push(gridData.part_key);
						 }
					 });

					var params = {
							WORLDMEMORY_ID : listWMId.toString(),
							PART_KEY : listPartKey.toString(),
							LT_CUSTOM_PART_ID : listCustomPartId.toString(),
							PRICE_REF : "MAPPING_CONFORM_YN",
							MAPPING_CONFORM_YN : 'Y'
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

					}

					//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "<h3>선택한 부품의 가격 매칭 정보를 확정하시겠습니까?</h3><br><b><font color=blue>* 매칭을 확정하면 선택한 부품의 가격이 'WM현재가격'으로 저장됩니다.<br>* 매칭되지 않은 부품은 확정되지 않습니다. </font>"
	}).data("kendoConfirm").open();
	//끝지점
}

function fnPriceConfirmReturn() {

	console.log("${sid}.fnPriceConfirmReturn() Load");

	var url = '${updateCustomMappingConfirm}';

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

				var listCustomPartId = [];
					var listWMId = [];
					var listPartKey = [];
					 rows.each(function (index, row) {
						 var gridData = grid.dataItem(this);
						 var worldmemoryId= gridData.worldmemory_id;
						 listCustomPartId.push(gridData.custom_part_id);
						 listWMId.push(worldmemoryId);
						 listPartKey.push(gridData.part_key);

					 });

					var params = {
							WORLDMEMORY_ID : listWMId.toString(),
							PART_KEY : listPartKey.toString(),
							LT_CUSTOM_PART_ID : listCustomPartId.toString(),
							PRICE_REF : "MAPPING_CONFORM_YN",
							MAPPING_CONFORM_YN : 'N'
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

					}

					//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택한 부품의 가격 매칭 정보를 미확정으로 수정하시겠습니까?<br><b><font color=blue> 매칭을 미확정하면 선택한 부품의 가격이 '0'으로 초기화 됩니다. </font>"
	}).data("kendoConfirm").open();
	//끝지점
}


function fnDropBoxonChange(page, pageSize){

	console.log("${sid}.fnDropBoxonChange() Load");

	var url = '${dataList}';
	var check = $('#confirm_cd').val();
	var cobjectid = "MAPPING_CONFORM_YN"
	var qStr = "";

   	if(check == "ALL"){
	}else{
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + check;
	}

    if(page > 0 && pageSize > 0){
    	 qStr += '&CustomPage=' + page;
    	 qStr += '&CustomPageSize=' + pageSize;
    }

    fnObj('LIST_${sid}').reloadGridCustomPrice(qStr);

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

</script>
