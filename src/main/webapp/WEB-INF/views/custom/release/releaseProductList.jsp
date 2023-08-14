<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="releaseInventoryUpdate"					value="/release/releaseInventoryUpdate.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [releaseProductList.js]");

	$('#${sid}_deleteBtn').remove();
// 	$('#${sid}_printBtn').remove();
	$('#${sid}_insertBtn').remove();

	$('#${sid}_gridbox').off('dblclick');

	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
		fnUpdatePrice();
    });


});


function fnUpdatePrice() {

	console.log("${sid}.fnUpdatePrice() Load");



	var grid = $('#release_all_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {
		GochigoAlert('선택된 출고가 없습니다.');
		return;
	}

	if(selItem.release_state == 'R'){

		GochigoAlert('출고완료된 출고는 수정할 수 업습니다.');
		return;
	}

	if(selItem.release_state == 'D'){

		GochigoAlert('취소된 출고는 수정할 수 업습니다.');
		return;
	}

	var width = 800;
	var height = 450;

	var xn = "release_Product_DATA";

	var pid = 'release_product_list';
	var ptype = '${ptype}';
	var grid = $('#'+pid+'_gridbox').data('kendoGrid');
    var oid = 'INVENTORY_ID';
    var queryString = "";

    if(pid && ptype == 'LIST'){

    	 queryString += '&pid=${pid}';
         queryString += '&objectid=' + oid;

        var objArr = oid.split(",");
        var selItem = grid.dataItem(grid.select());
        if(selItem){

            var pStr = new Array();
            for(var i = 0; i < objArr.length; i++){
            	pStr = selItem.get(objArr[i].toLowerCase());
                queryString += '&'+objArr[i]+'=' + pStr;
            }

        }
    }

    var xPos  = (document.body.clientWidth /2) - (800 / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (600 / 2);
   window.open("<c:url value='/dataView.do'/>"+"?xn="+xn+"&sid="+pid+encodeURI(queryString), "dataEdit", "top="+yPos+", left="+xPos+", width="+width+", height="+height+", scrollbars=1");

}

</script>
