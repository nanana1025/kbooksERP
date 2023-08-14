<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="consignedPopup"					value="/CustomP.do"/>
<c:url var="dataList"					value="/customDataList.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

var _checkType = 1;

$(document).ready(function() {

	console.log("load [checkList.js]");

	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

	$('#${sid}_gridbox').off('dblclick');

// 	$("#${sid}_gridbox").on("dblclick", "tr.k-state-selected", function() {
// 		fnComponentCheck();
//     });

});

function fuChangeDivWidth(){
// 	console.log("${sid}");
//     var Cwidth = $('#admin_produce_warehousing_examine_list_header_title').width();
//     $('#${sid}_btns').css({'width':Cwidth-20+'px'});
}

function fnSearchInventoryCheck(){

	var url = '${consignedPopup}';


	var query = "?content=MBDProduct";

	var width, height;

	width = "500";
	height = "540";

	var xPos  = (document.body.clientWidth /2) - (width / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (height / 2);

    window.open("<c:url value='"+url+query+"'/>", "MBDCheckPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);

}

function fnGetMBDProductList(_listMBDInventory){

	var url = '${dataList}';

	var qStr = '&CHECK_TYPE='+_checkType+'&BARCODE=' + _listMBDInventory.toString();

	fnObj('LIST_${sid}').reloadGridCustom(qStr);

}



</script>
