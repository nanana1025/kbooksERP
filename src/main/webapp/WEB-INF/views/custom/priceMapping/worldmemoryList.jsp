<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="selectData"					value="/customSelectData.json" />
<c:url var="dataList"					value="/customDataList.json" />

<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="/js/gochigo.kendo.ui.js"></script>

<style>
</style>

<script>

$(document).ready(function() {

	console.log("load [worldmemoeyList.js]");

	//$('.basicBtn').remove();
	//$('#selectBtn').remove();
	$('#world_list_gridbox').off('dblclick');

	setTimeout(function() {
	$('#selectBtn').removeAttr("onclick");
	$('#selectBtn').attr("onclick", "fnCustomSelect();");

	// 부품 타입 필터 START
//     var compTypeCond = '<label>부품분류 &nbsp;&nbsp;&nbsp;</label><input id="component_type_check" style = "width: 150px;"/>';

//     //var compTypeCond = '<div id = "World_list_component_btn"style="text-align:left; margin-top:8px; width: 200px;"> <label>부품분류 &nbsp;&nbsp;&nbsp;</label><input id="component_type_check" style = "width: 100px;"/></div>';
//     $('#popup_btns').prepend(compTypeCond);

//     var compTypeCodeValueArray = ["ALL","CPU","MBD","MEM","VGA","STG","MON","CAS","ADP"];
//     var compTypeContentTextArray = [
//         "전체",
//         "CPU",
//         "MAINBOARD",
//         "MEMORY",
//         "VGA",
//         "STORAGE",
//         "MONITOR",
//         "CASE",
//         "ADAPTOR"
//     ];

//     var dataArray = new Array();

//     for(var i = 0; i<compTypeCodeValueArray.length; i++){
//         var datainfo = new Object();
//         datainfo.text = compTypeContentTextArray[i];
//         datainfo.value =  compTypeCodeValueArray[i];
//         dataArray.push(datainfo);
//     }

//     $("#component_type_check").kendoDropDownList({
//         dataTextField: "text",
//         dataValueField: "value",
//         dataSource: dataArray,
//         value:"ALL",
//         height: 130,
//         change: fnDropBoxonChange
//     });

//     window.onload = fuChangeDivWidth;
// 	window.onresize = fuChangeDivWidth;

// 	fuChangeDivWidth();

  	},1000);



  // 부품 타입 필터 END

//     setTimeout(function() {
// 		$('.basicBtn').remove();
// 		$('#selectBtn').remove();

// 		var infCond = '<button id="customSelectBtn" class="k-button" onclick="fnCustomSelect()" data-role="button" role="button" aria-disabled="false" tabindex="0">선택</button>';
// 		$('#popup_btns').prepend(infCond);
// 		//$('#popup_btns').css('text-align','right');
//         opener.$('#OTHER_PURCHASE_PART_ID').attr("class", "include");

//  		window.onload = fuChangeDivWidth;
//     	window.onresize = fuChangeDivWidth;

//    		fuChangeDivWidth();

// 	}, 1000);

});

function fuChangeDivWidth(){
	console.log("fuChangeDivWidth()");

    var Cwidth = $('#world_list_searchDiv').width();
    $('#world_list_btns').css({'width':Cwidth+'px'});

}

function fnCustomSelect(){

	console.log("Function fnCustomSelect()");

	//var url = '${selectCPU}';

// 	console.log("${sid}");
	var grid = $('#world_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.');
	return;}

	var params = {
			OTHER_PURCHASE_PART_ID : selItem.other_purchase_part_id,
			COMPONENT_CD : selItem.component_cd,
			PART_KEY : selItem.part_key,
			PART_NAME: selItem.part_name,
			PRICE: selItem.price,
			CREATE_DT: selItem.create_dt
		};

	opener.$('#OTHER_PURCHASE_PART_ID').val(params.OTHER_PURCHASE_PART_ID);
	opener.$('#WM_PART_KEY').val(params.PART_KEY);
	opener.$('#WM_PART_NAME').val(params.PART_NAME);
  	// opener.$('#COMPONENT_CD').val(params.COMPONENT_CD);
    // opener.$('#COMPONENT_CD').siblings('.k-formatted-value').val(params.COMPONENT_CD);
	opener.$('#PRICE').val(params.PRICE);
 	opener.$('#PRICE').siblings('.k-formatted-value').val(params.PRICE);


//  	console.log(params.OTHER_PURCHASE_PART_ID);
//  	console.log(params.PART_KEY);
//  	console.log(params.PART_NAME);


	self.close();
}


// function fnDropBoxonChange(){

//     // console.log("admin_component_list.fnDropBoxonChange() Load");

//     var url = '${dataList}';
//     var check = $('#component_type_check').val();
//     var cobjectid = "COMPONENT_CD"
//     var qStr = "";

//     if(check != "ALL"){
//         cobjectval = check;
//         qStr += '&cobjectid=' + cobjectid;
//         qStr += '&cobjectval=' + cobjectval;
//     }

//     var dataSource = {
//         transport: {
//             read: {
//                 url: "<c:url value='"+url+"'/>"+"?xn=WWorld_List"+"&"+qStr,
//                 dataType: "json"
//                 // admin_component_list > World_LIST > World_list
//             },
//             parameterMap: function (data, type) {
//                 if(data.filter){
//                     //필터 시 날짜 변환
//                     var filters = data.filter.filters;
//                     $.each(filters, function(idx, filter){
//                         if(filter.value && typeof filter.value.getFullYear === "function"){
//                             var year = filter.value.getFullYear();
//                             var month = filter.value.getMonth()+1;
//                             if(month < 10){ month = "0"+month; }
//                             var date = filter.value.getDate();
//                             if(date < 10){ date = "0"+date; }
//                             var valStr = year+"-"+month+"-"+date;
//                             filter.value = valStr;
//                         }
//                     });
//                 }
//                 return data;
//             }
//         },
//         error : function(e) {
//             console.log(e);
//         },
//         schema: {
//             data: 'gridData',
//             total: 'total',
//             model:{
//                 id:"${grididcol}",
//                 fields: JSON.parse('${fields}')
//             }
//         },
//         pageSize: 20,
//         serverPaging: true,
//         serverSorting : true,
//         serverFiltering: true
//     };

//     var grid = $("#world_list_gridbox").data("kendoGrid");
//     grid.setDataSource(dataSource);

// }

</script>
