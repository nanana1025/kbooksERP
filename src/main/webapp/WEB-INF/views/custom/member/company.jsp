<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="companyDelete"					value="/user/companyDelete.json" />
<c:url var="companyInsert"					value="/user/companyInsert.json" />
<c:url var="dataList"					value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [CompanyList.js]");
	// $('.basicBtn').remove();
	 $('#company_list_deleteBtn').remove();
	 $('#company_list_insertBtn').remove();
	$('#${sid}_gridbox').off('dblclick');

	var infCond = '<label>사용유무 &nbsp;&nbsp;&nbsp;</label><input id="company_state_check" style = "width: 100px;"/>';

	$('#${sid}_btns').prepend(infCond);

	$('.k-button').css('float','right');

	var stateCodeValueArray = ["N","Y"];
	var stateContentTextArray = [
								"사용",
								"미사용"];

	var dataArray = new Array();

	for(var i = 0; i<stateCodeValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = stateContentTextArray[i];
		datainfo.value =  stateCodeValueArray[i];
		dataArray.push(datainfo);
	}

	$("#company_state_check").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"ALL",
        height: 130,
        change: fnDropBoxonChange
      });

	window.onload = fuChangeDivWidth;
    window.onresize = fuChangeDivWidth;

    fuChangeDivWidth();

    fnDropBoxonChange();

});

function fuChangeDivWidth(){
    var Cwidth = $('#${sid}_searchDiv').width();
    $('#${sid}_btns').css({'width':Cwidth+'px'});
}


function fnCompanyInsert() {

	console.log("CompanyList.fnCompanyInsert() Load");

	var url = '${companyInsert}';

	var isSuccess = false;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

					$.ajax({
						url : url,
						type : "POST",
						async : false,
						success : function(data) {
							if(data.success){
								GochigoAlert('업체 상세 정보를 입력하세요');
								isSuccess = true;
							}
							else
								GochigoAlert('오류가 발생했습니다. 관리자에게 문의하세요.');
						}
					});

					if(isSuccess)
						fnDropBoxonChange();

	//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "업체를 추가하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점

}


function fnCompanyDelete() {

	console.log("CompanyList.fnCompanyDelete() Load");

	var url = '${companyDelete}';
	var params = "";
	var msg = "";

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}


	var isSuccess = false;

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

						params = {
								COMPANY_ID: selItem.company_id
						};

						$.ajax({
							url : url,
							type : "POST",
							data : params,
							async : false,
							success : function(data) {
								if(data.success){
									GochigoAlert(data.MSG);
									isSuccess = true;
								}
								else
									GochigoAlert(data.MSG);
							}
						});

						if(isSuccess)
				                fnDropBoxonChange();

	//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택하신 업체를 미사용 처리하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}


function fnDropBoxonChange(){

	console.log("${sid}.fnDropBoxonChange() Load");

	var url = '${dataList}';

	var check = $('#company_state_check').val();
	var cobjectid = "DEL_YN";

	var qStr = "";

	qStr += '&cobjectid=' + cobjectid;
    qStr += '&cobjectval=' + check;


    fnObj('LIST_${sid}').reloadGridCustom(qStr);
}

</script>
