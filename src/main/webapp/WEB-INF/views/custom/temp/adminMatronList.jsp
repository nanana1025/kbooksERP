<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="sendMail"					value="/charging/chargingUserEmailReceiveCheck.json" />
<c:url var="dataList"					value="/customDataList.json" />

<style>
</style>
<script>
$(document).ready(function() {

	console.log("load [adminMatronList.js]");
	$('.basicBtn').remove();

	var infCond = '<label>&nbsp;&nbsp;&nbsp;병원정보매핑상태&nbsp;&nbsp;&nbsp;</label><input id="matron_null_check" />';
	$('#admin_matron_list_btns').append(infCond);

	$('.k-button').css('float','right');

	var dataArray = new Array();

	var datainfo = new Object();
	datainfo.text = "전체";
	datainfo.value =  "ALL";
	dataArray.push(datainfo);

	var datainfo = new Object();
	datainfo.text = " 정상";
	datainfo.value = "NOT NULL";

	dataArray.push(datainfo);

	var datainfo = new Object();
	datainfo.text = "오류";
	datainfo.value = "NULL";

	dataArray.push(datainfo);

	$("#matron_null_check").kendoDropDownList({
        dataTextField: "text",
        dataValueField: "value",
        dataSource: dataArray,
        value:"ALL",
        height: 100,
        change: fnDropBoxonChange
      });

	$('#admin_matron_list_mail_btn').hide();

	setTimeout(function() {
		$('#admin_matron_list_gridbox').click(function(){
			var grid = $('#admin_matron_list_gridbox').data('kendoGrid');
			var selItem = grid.dataItem(grid.select());

			if(selItem.hospital_nm == null || selItem.ward_no == null)
				$('#admin_matron_list_mail_btn').show();
			else
				$('#admin_matron_list_mail_btn').hide();
		});

	}, 1000);

	window.onload = fuChangeDivWidth;
    window.onresize = fuChangeDivWidth;

    fuChangeDivWidth();

});

function fuChangeDivWidth(){
    var Cwidth = $('#admin_matron_list_header_title').width();
    $('#admin_matron_list_btns').css({'width':Cwidth-10+'px'});
}

function fnSendMail() {

	console.log("admin_matron_list.fnSendMail() Load");

	var url = '${sendMail}';
	var grid = $('#admin_matron_list_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	var userNm = selItem.user_nm;
	var userId = selItem.user_id;
	var email = selItem.login_id;
	var proc = false;


	$.ajax({
		url : url,
		type : "POST",
		data : { USER_ID: userId },
		async : false,
		success : function(data) {
			if(data.success){
				proc = true;
			}
		}
	});

	if(!proc){
		alert("EMAIL 수신동의를 하지 않은 회원입니다.");
		return;
	}

	var width = 800;
	var height = 465;
	var xPos  = (document.body.clientWidth * 0.5) - (width * 0.5);
	xPos += window.screenLeft;
	var yPos  = (screen.availHeight * 0.5) - (height * 0.5);

	var params = "?USER_ID="+userId+"&USER_NM="+encodeURI(userNm)+"&EMAIL="+email;

	window.open("/charging/premiumuserSendMailP.do" + params, "premiumuserSendMailP", "top="+yPos+", left="+xPos+", width="+ width +", height="+ height +", scrollbars=1");
}


function fnDropBoxonChange(){

	console.log("admin_matron_list.fnDropBoxonChange() Load");

	var url = '${dataList}';
	var check = $('#matron_null_check').val();
	var condition = "ALL";

	if(check == "ALL"){
		$('#admin_matron_list_mail_btn').hide();
	}else if(check == "NOT NULL"){
		condition = "false";
		$('#admin_matron_list_mail_btn').hide();
	}else{
		condition = "true";
		$('#admin_matron_list_mail_btn').show();
	}

	var qStr = '&condition=' + condition;

	var dataSource = {
              transport: {
                  read: {
                       url: "<c:url value='"+url+"'/>"+"?xn=admin_matron_list"+"&"+qStr,
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
	var grid = $("#admin_matron_list_gridbox").data("kendoGrid");
    	grid.setDataSource(dataSource);


}
</script>