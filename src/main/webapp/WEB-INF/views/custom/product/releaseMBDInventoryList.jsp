<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="productPrint"				value="/product/productPrint.json"/>
<c:url var="consignedPopup"					value="/CustomP.do"/>
<c:url var="dataList"					value="/customDataList.json" />

    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [warehousingInventoryList.js]");

	$('#${sid}_insertBtn').remove();
	$('#${sid}_deleteBtn').remove();

	$('#${sid}_gridbox').off('dblclick');


// 	$('.warehousing_product_inventory_list_gridbox.k-floatwrap').remove();
});

function fnMBDInventoryAdd(){

	var url = '${consignedPopup}';


	var query = "?content=MBDProduct";

	var width, height;

	width = "500";
	height = "540";

	var xPos  = (document.body.clientWidth /2) - (width / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (height / 2);

    window.open("<c:url value='"+url+query+"'/>", "MBDProductPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);

}

function fnGetMBDProductList(_listMBDInventory){

var url = '${dataList}';

var qStr = '&BARCODE=' + _listMBDInventory.toString();

fnObj('LIST_${sid}').reloadGridCustom(qStr);

}
</script>
