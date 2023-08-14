<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="productPrint"				value="/product/productPrint.json"/>
<c:url var="productInventoryCheck"				value="/inventoryCheck/productInventoryCheck.do"/>

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [releaseProductList.js]");

	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

	$('#${sid}_gridbox').off('dblclick');

	var infCondPrintPort = '<label>프린터 포트 &nbsp;&nbsp;&nbsp;</label><input id="print_port" style = "width: 70px;"/>';

	$('#${sid}_btns').prepend(infCondPrintPort);

// 	var infCond = '<button id="admin_produce_warehousing_examine_list_delete_btn" type="button" onclick="fnDeleteWarehousingExamine()" class="k-button" style="float: right;">삭제</button>';

// 	$('#admin_produce_warehousing_examine_list_btns').prepend(infCond);

// 	var infCond5000 = '<button id="admin_produce_warehousing_examine_list_print5000_btn" type="button" onclick="fnPrint5000()" class="k-button" style="float: right;">프린트[5000]</button>';
// 	var infCond5001 = '<button id="admin_produce_warehousing_examine_list_print5001_btn" type="button" onclick="fnPrint5001()" class="k-button" style="float: right;">프린트[5001]</button>';

// 	$('#admin_produce_warehousing_examine_list_btns').prepend(infCond5000);
// 	$('#admin_produce_warehousing_examine_list_btns').prepend(infCond5001);

// 	$('#admin_produce_warehousing_examine_list_insertBtn').css('float','right');


// 	$('#${sid}_component_intertBtn').css('float','left');

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

	var dataArray = new Array();

	for(var i = 0; i<printPortValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = printPortTextArray[i];
		datainfo.value =  printPortValueArray[i];
		dataArray.push(datainfo);
	}

	$("#print_port").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"5000",
        height: 155
      });

// 	window.onload = fuChangeDivWidth;
//     window.onresize = fuChangeDivWidth;

//     fuChangeDivWidth();

     setTimeout(function() {
//     	$('#admin_produce_warehousing_examine_list_component_intertBtn').css('float','left');

 	}, 500);

});

function fuChangeDivWidth(){
// 	console.log("${sid}");
//     var Cwidth = $('#admin_produce_warehousing_examine_list_header_title').width();
//     $('#${sid}_btns').css({'width':Cwidth-20+'px'});
}


function fnProductPrint() {
	console.log("${sid}.fnProductPrint() Load");

	var url = '${productPrint}';

	var srid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = srid.dataItem(srid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return false;}

	var printPort = $('#print_port').val();

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				var params = {
						INVENTORY_ID : selItem.inventory_id,
				        BARCODE :  selItem.barcode,
				        COMPONENT_CD :  selItem.component_cd,
				        RELEASES :  selItem.releases,
				        PORT: printPort,
				        REPRESENTATIVE_TYPE:"O"

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
							isPRefresh = data.PREFRESH;
// 							fnObj('LIST_${sid}').reloadGridCustom(queryCustom);
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
			text: '취소'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택한 제품을 '"+ printPort + "' 프린터로 출력하시겠습니까? "
	}).data("kendoConfirm").open();
	//끝지점
}


function fnProductCheck(){
	console.log("${sid}.fnProductCheck() Load");

	var url = '${productInventoryCheck}';

	var srid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = srid.dataItem(srid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return false;}

	var params = "INVENTORY_ID="+selItem.p_inventory_id;

	fnCheckWindowOpen(url, params, "L");

}

function fnCheckWindowOpen(url, params, size) {
    var width, height;
    if(size == "S"){
    	width = "800";
    	height = "600";
    } else if(size == "M") {
    	width = "1024";
    	height = "768";
    } else if(size == "L") {
    	width = "1000";
    	height = "800";
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
    window.open("<c:url value='"+url+"'/>?"+params, "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
}


</script>
