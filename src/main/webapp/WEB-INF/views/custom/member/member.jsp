<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="deltProc"					value="/user/userDeltProc.json" />
<c:url var="pawdInit"					value="/user/userPawdInit.json" />
<c:url var="dataList"					value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [adminMemberList.js]");
	$('.basicBtn').remove();
	//$('#admin_nurse_list_gridbox').off('dblclick');

	var infCond = '<label>사용자상태 &nbsp;&nbsp;&nbsp;</label><input id="member_state_check" style = "width: 280px;"/>';

	$('#admin_member_list_btns').prepend(infCond);

	$('.k-button').css('float','right');

	var stateCodeValueArray = ["ALL","A","S","L","D"];
	var stateContentTextArray = ["전체",
								"정상적인 로그인이 가능한 상태",
								"관리자 승인대기 상태",
								"비밀번호 오류로 사용자 잠김 상태",
								"관리자가 사용자를 삭제한 상태"];

	var dataArray = new Array();

	for(var i = 0; i<stateCodeValueArray.length; i++){
		var datainfo = new Object();
		datainfo.text = stateContentTextArray[i];
		datainfo.value =  stateCodeValueArray[i];
		dataArray.push(datainfo);
	}

	$("#member_state_check").kendoDropDownList({
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
    var Cwidth = $('#admin_member_list_searchDiv').width();
    $('#admin_member_list_btns').css({'width':Cwidth+'px'});
}


function fnPswdInit() {

	console.log("admin_member_list.fnPswdInit() Load");

	var url = '${pawdInit}';

	var grid = $('#admin_member_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

				// 	if (!confirm('비밀번호를 \'test123\'으로 초기화하시겠습니까?'))
				// 		return;

					var params = {
						USER_ID : selItem.user_id,
						EMAIL: selItem.email
					};

					$.ajax({
						url : url,
						type : "POST",
						data : params,
						async : false,
						success : function(data) {
							if(data.success)
								GochigoAlert('비밀번호가 \'test123\'으로 초기화되었습니다.');
							else
								GochigoAlert('오류가 발생했습니다. 관리자에게 문의하세요.');
						}
					});

	//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "비밀번호를 \'test123\'으로 초기화하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점

}


function fnMemberDel() {

	console.log("admin_member_list.fnMemberDel() Load");

	var url = '${deltProc}';
	var params = "";
	var msg = "";
	var grid = $('#admin_member_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}

	var userStateCd = selItem.state_cd;
	var userTypeCd = selItem.user_type_cd;
	var matronCnt = Number(selItem.matron_cnt);

	if(userStateCd == 'D'){
		GochigoAlert('이미 회원탈퇴한 회원입니다.');
		return;
	}

	if(userTypeCd == 'M'){
		GochigoAlert('관리자는 삭제할 수 없습니다.');
		return;
	}

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

						params = {
							USER_ID: selItem.user_id,
							LOGIN_ID: selItem.login_id,
							USER_TYPE_CD: selItem.user_type_cd,
							STATE_CD: selItem.state_cd,
							APPROVE_YN : selItem.approve_yn,
							MATRON_ID : selItem.matron_id
						};


						$.ajax({
							url : url,
							type : "POST",
							data : params,
							async : false,
							success : function(data) {
								if(data.success){
									GochigoAlert(data.MSG);
									fnDropBoxonChange();
								}
								else
									GochigoAlert(data.MSG);
							}
						});

						fnDropBoxonChange();

	//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "정말 삭제하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}


function fnDropBoxonChange(){

	console.log("admin_member_list.fnDropBoxonChange() Load");

	var url = '${dataList}';
	var check = $('#member_state_check').val();
	var cobjectid = "STATE_CD"
	var qStr = "";

	if(check == "ALL"){
	    qStr += '&cnobjectid=' + cobjectid;
	    qStr += '&cnobjectval=D';
	}else if(check == "D"){
		cobjectval = check;
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + cobjectval;
	}else{
		cobjectval = check;
		qStr += '&cobjectid=' + cobjectid;
	    qStr += '&cobjectval=' + cobjectval;

	    qStr += '&cnobjectid=' + cobjectid;
	    qStr += '&cnobjectval=D';
	}

	var dataSource = {
           transport: {
               read: {
            	   url: "<c:url value='"+url+"'/>"+"?xn=admin_member_list"+"&"+qStr,
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
	var grid = $("#admin_member_list_gridbox").data("kendoGrid");
 	grid.setDataSource(dataSource);


}

</script>
