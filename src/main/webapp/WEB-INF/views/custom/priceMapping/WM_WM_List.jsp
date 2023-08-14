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

	console.log("load [WM_LT_List.js]");

	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

// 	var infCondConfirmBtn = '<button id="${sid}_searchbtn" type="button" onclick="fnSearch()" class="k-button" style="float: left;">검색</button>';

// 	$('#${sid}_btns').prepend(infCondConfirmBtn);


	var infCondDate = '&nbsp;&nbsp;&nbsp;<label>날짜선택 &nbsp;&nbsp;&nbsp;</label><input id="datetimepicker_start" title="datetimepicker" style="width: 120px;" /> ~ <input id="datetimepicker_end" title="datetimepicker" style="width: 120px;" />';
	$('#${sid}_btns').prepend(infCondDate);

	$("#datetimepicker_start").kendoDatePicker({
        change: fnDropBoxonChange
      });
	$("#datetimepicker_end").kendoDatePicker({
        change: fnDropBoxonChange
    });



	var infCondMappingYN = ' &nbsp;&nbsp;&nbsp;<label>매핑여부 &nbsp;&nbsp;&nbsp;</label><input id="mapping_YN" style = "width: 100px;"/>';
	$('#${sid}_btns').prepend(infCondMappingYN);

	var mappingYNValueArray = ["ALL", "Y", "N"];
	var mappingYNTextArray = ["전체",
								"확정",
								"미확정"];

	var dataArray = new Array();

	for(var i = 0; i<mappingYNValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = mappingYNTextArray[i];
		datainfo.value =  mappingYNValueArray[i];
		dataArray.push(datainfo);
	}

	$("#mapping_YN").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"all",
        height: 100,
        change: fnDropBoxonChange
      });

	var infCondUseYN = '<label>사용여부 &nbsp;&nbsp;&nbsp;</label><input id="use_YN" style = "width: 100px;"/>';
	$('#${sid}_btns').prepend(infCondUseYN);

	var useYNValueArray = ["ALL", "Y", "N"];
	var useYNTextArray = ["전체",
								"사용",
								"미사용"];

	var dataArray = new Array();

	for(var i = 0; i<useYNValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = useYNTextArray[i];
		datainfo.value =  useYNValueArray[i];
		dataArray.push(datainfo);
	}

	$("#use_YN").kendoDropDownList({
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

 		$('#${sid}_gridbox').click(function(){
    		changeState();
		});

 		changeState();

 	}, 500);

});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}

function changeState(){
	console.log("${sid}.changeState() Load");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());

	if(selItem.use_yn == 'Y'){
		$('#${sid}_useYbtn').hide();
		$('#${sid}_useNbtn').show();
	} else {
		$('#${sid}_useYbtn').show();
		$('#${sid}_useNbtn').hide();
	}
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
	console.log("${sid}.fnMappingTransfer() Load");

	var width = 800;
	var height = 450;

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var xn = "priceMapping_WM_WM_DATA";

	var pid = 'pricemapping_wm_wm_list';
	var ptype = '${param.ctype}';
    var oid = 'OTHER_PURCHASE_PART_ID';
    var queryString = "";

    console.log("11111111 "+ptype);
    if(pid && ptype == 'LIST'){
        var selItem = grid.dataItem(grid.select());
        var pStr = selItem.other_purchase_part_id;

        queryString += '&pid=${pid}';
        queryString += '&objectid=' + oid;
        queryString += '&' + oid + '=' + pStr;

    }

	queryString += '&height=' + height;

    var xPos  = (document.body.clientWidth /2) - (800 / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (600 / 2);

   window.open("<c:url value='/dataView.do'/>"+"?xn="+xn+"&sid="+pid+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

}


function fnDropBoxonChange(page, pageSize){

	console.log("${sid}.fnDropBoxonChange() Load");

	var url = '${dataList}';

	var check = $('#mapping_YN').val();
	var cobjectid = "MAPPING_YN";
	var check1 = $('#use_YN').val();
	var cobjectid1 = "USE_YN";

	var qStr = "";

   	if(check == "ALL"){
   		if(check1 == "ALL"){
   		}else{
   			qStr += '&cobjectid=' + cobjectid1;
   		    qStr += '&cobjectval=' + check1;
   		}
	}else{

		if(check1 == "ALL"){
			qStr += '&cobjectid=' + cobjectid;
		    qStr += '&cobjectval=' + check;
   		}else{
   			qStr += '&cobjectid=' + cobjectid+','+cobjectid1;
   		    qStr += '&cobjectval=' + check+','+check1;
   		}
	}

   	var dateStartCheck = $('#datetimepicker_start').val();
   	var dateEndCheck = $('#datetimepicker_end').val();

   	if(dateStartCheck != '')
   		qStr += '&dateStart=' + dateStartCheck;

	if(dateEndCheck != '')
    qStr += '&dateEnd=' + dateEndCheck;



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
