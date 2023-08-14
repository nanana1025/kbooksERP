<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="approvalCancel"		value="/user/nurseApprovalCancel.json" />
<c:url var="approvalYN"				value="/user/userNurseApprovalYN.json" />
<c:url var="nurseDel"					value="/user/userNurseDel.json" />
<c:url var="dataList"					value="/customDataList.json" />

<style>
</style>
<script>

$(document).ready(function() {

	console.log("load [adminNurse.js]");

	$('.basicBtn').remove();
	//$('#admin_nurse_list_gridbox').off('dblclick');

	/*var infCond = '<input id="nurse_delete_check" />';
	$('#admin_nurse_list_btns').append(infCond);

	var dataArray = new Array();

	var datainfo = new Object();
	datainfo.text = "ALL";
	datainfo.value =  "ALL";
	dataArray.push(datainfo);

	var datainfo = new Object();
	datainfo.text = " DELETE";
	datainfo.value = "DELETE";

	dataArray.push(datainfo);

	var datainfo = new Object();
	datainfo.text = "WORK";
	datainfo.value = "WORK";

	dataArray.push(datainfo);

	$("#nurse_delete_check").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"WORK",
        height: 100,
        change: fnDropBoxonChange
      });

	setTimeout(function() {

		fnDropBoxonChange();


		$('#admin_ward_list_gridbox').click(function(){
			fnDropBoxonChange();
		});

	}, 1000);*/

});

function fnNurseCancel() {

	console.log("admin_nurse_list.fnNurseCancel() Load");

	var url = '${approvalCancel}';
	var grid = $('#admin_nurse_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


	var userTypeCd = selItem.user_type_cd;

	if(userTypeCd == 'M'){
		GochigoAlert('수간호사는 본인은 승인해제할 수 없습니다.');
		return;
	}

	if(selItem.approve_dt == null) {
		alert('승인되지 않은 간호사는 승인해제할 수 없습니다.');
		return;
	}

	if (!confirm('정말 승인해제 하시겠습니까?'))
		return;

	var params = {
		NURSE_ID: selItem.nurse_id,
		USER_ID: selItem.user_id
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.success)
				GochigoAlert('승인해제 되었습니다.');
			else
				GochigoAlert('오류가 발생했습니다. 관리자에게 문의하세요.');
		}
	});

	fnObj('LIST_${sid}').reloadGrid();

	}

function fnNurseDel() {

	console.log("admin_nurse_list.fnNurseDel() Load");

	//var url = '${approvalYN}';
	var url = '${nurseDel}';

	var grid = $('#admin_nurse_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


	var userTypeCd = selItem.user_type_cd;

	if(userTypeCd == 'M'){
		GochigoAlert('수간호사는 [전체 사용자 목록]페이지에서 삭제 할수 있습니다.');
		return;
	}

	if (!confirm('정말 삭제하시겠습니까?'))
		return;

	var params = {
		NURSE_ID: selItem.nurse_id,
		USER_ID: selItem.user_id,
		APPROVE_DT: selItem.approve_dt,
		GROUP_ID: selItem.group_id,
		MATRON_ID: selItem.matron_id
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(data) {
			if(data.success)
				GochigoAlert('간호사가 삭제되었습니다.');
			else
				GochigoAlert('오류가 발생했습니다. 관리자에게 문의하세요.');
		}
	});

	fnObj('LIST_${sid}').reloadGrid();
}


function fnDropBoxonChange(){

	console.log("admin_nurse_list.fnDropBoxonChange() Load");

	var url = '${dataList}';
	var check = $('#nurse_delete_check').val();
	var condition = "ALL";

	var cobjectid = "MATRON_ID"
	var grid = $('#admin_ward_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	var cobjectval = selItem.matron_id;
	var qStr = "";

	if(check == "ALL"){
	}else if(check == "DELETE"){
		condition = "false";
	}else{
		condition = "true";
	}

	qStr += '&cobjectid=' + cobjectid;
    qStr += '&cobjectval=' + cobjectval;
	qStr += '&condition=' + condition;

	var dataSource = {
           transport: {
               read: {
            	   url: "<c:url value='"+url+"'/>"+"?xn=admin_nurse_list"+"&"+qStr,
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
	var grid = $("#admin_nurse_list_gridbox").data("kendoGrid");
 	grid.setDataSource(dataSource);


}

</script>
