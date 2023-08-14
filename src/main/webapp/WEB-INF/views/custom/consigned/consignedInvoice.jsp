<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="getCodeListCustom"					value="/common/getCodeListCustom.json" />
<c:url var="dataList"					value="/customDataList.json" />
<c:url var="consignedProcess"					value="layoutCustom.do" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

var _key = getParameterByName('KEY');
var _value = getParameterByName('VALUE');

$(document).ready(function() {

	console.log("load [consignedInvoice.js]");
	$('#consigned_invoice_list_deleteBtn').remove();
	$('#consigned_invoice_list_insertBtn').remove();



	 $('#${sid}_gridbox').off('dblclick');


// 	 ADMIN_CODE_LIST_PRINTBTN
	 setTimeout(function() {
// 		 var infCond = '<button id="consigned_invoice_list_printBtn" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">출력</button>';

// 		 $('#consigned_invoice_list_btns').prepend(infCond);

// 		 $('#closeBtn').remove();
// 		 $('#selectBtn').remove();

	 }, 500);


		fnConsignedInvoiceData();


});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}




function fnConsignedInvoiceData() {

	console.log("CompanyList.fnConsignedData() Load");

	var url = '${dataList}';



	var qStr = "";
	qStr += '&cobjectid=PROXY_ID';
    qStr += '&cobjectval=' + _value;



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


function customfunction_INVOICE() {
    setTimeout(function() {
        var grid = $('#${sid}_gridbox').data('kendoGrid');
        var selItem = grid.dataItem(grid.select());
        if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}
        if(selItem.invoice == ''){return;}
        var params = {
            content: "process",
            KEY: "PROXY_ID",
            VALUE: selItem.invoice,
            DELIVERY_COMPANY: selItem.delivery_company
        };
        console.log(params.DELIVERY_COMPANY);
        let url = '';
        if (params.DELIVERY_COMPANY === '1') { // CJ대한통운
            url = 'https://www.doortodoor.co.kr/parcel/doortodoor.do?fsp_action=PARC_ACT_002&fsp_cmd=retrieveInvNoACT&invc_no=' + params.VALUE;
        } else if (params.DELIVERY_COMPANY === '2') { // 한진택배
            url = 'http://www.doortodoor.co.kr/tracking/jsp/cmn/Tracking_new.jsp?QueryType=3&pTdNo=' + params.VALUE + '&pOrderNo=&pTelNo=&pFromDate=&pToDate=&pCustId=&pageno=1&rcv_cnt=10';
        } else if (params.DELIVERY_COMPANY === '3') { // 현대로지스틱스 (롯데택배)
            url = 'https://www.lotteglogis.com/home/reservation/tracking/linkView?InvNo=' + params.VALUE;
        } else if (params.DELIVERY_COMPANY === '4') { // 우체국
            url = 'https://service.epost.go.kr/trace.RetrieveDomRigiTraceList.comm?sid1=' + params.VALUE + '&displayHeader=N';
        } else if (params.DELIVERY_COMPANY === '5') { // 로젠택배
            url = 'https://www.ilogen.com/web/personal/trace/' + params.VALUE;
        }
        if (!url) {
            GochigoAlert('지원하지 않는 배송업체입니다. 배송업체를 다시 확인해주세요.');
            return;
        }
        window.open("<c:url value='"+url+"'/>");
    }, 10);
}


function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}


</script>
