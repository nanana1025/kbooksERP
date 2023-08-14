<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="insertModelCompopnent"					value="/consigned/insertModelCompopnent.json" />
<%-- <c:url var="printCore"						value="/print/printCore.json"/> --%>

<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>


var _componentCd = getParameterByName('componentCd');
var _companyid = getParameterByName('COMPANY_ID');
var _modellistid = getParameterByName('MODEL_LIST_ID');
var _openerSid = getParameterByName('pid');


$(document).ready(function() {

	console.log("load [producePart.jsp]");

 	setTimeout(function() {
 		$('#saveBtn_${sid}').remove();

		$('.k-i-windows').attr("onclick", 'fnSelectComponent();');

	 	var infCond = '<button id="insert_admin_create_component" onclick="fnComponentInsert()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';

	 	$('#${sid}_view-btns').prepend(infCond);

		if(_companyid == "") {
			GochigoAlert("업체번호를 가져올수 없습니다. 다시 시도해 주세요.", true, "dangol365 ERP");
		}

		$('.pagetitle').context.title = _componentCd;
		$(".pagetitle").html("<span class='k-icon k-i-copy'></span>"+_componentCd);
		$('#PART_NAME').val("부품을 선택하세요.");
		$('#COMPANY_ID').val(_companyid);
		$('#MODEL_LIST_ID').val(_modellistid);
		$('#COMPONENT_CD').val(_componentCd);

		$('#CNT').removeAttr("readonly");
		$('#CNT').val('1');
	}, 500);

 	setTimeout(function() {
 		$('#CNT').removeAttr("readonly");
		$('#CNT').val('1');
 	}, 1000);


});


function fnClose(){
	console.log("load [fnClose.js]");

	if(typeof(opener) == "undefined" || opener == null) {
		history.back();
	} else {
		window.close();
	}
}

function fnSelectComponent(){

		fnWindowOpen_LTComponent("/layoutNewList.do?xn=consignedSelect_LT_"+_componentCd+"_LAYOUT","component_id","UW");
}


function fnComponentInsert() {

	var componentCd = $('.header_title').text().trim();
	var params;

	if("${sessionScope.userInfo.user_id}" == ""){
		GochigoAlert('세션 정보가 만료되었습니다. 로그아웃 후 다시 로그인해 주세요.');
		return;
	}

	if($('#COMPONENT_ID').val() ==''){
		GochigoAlert('부품번호가 입력되지 않았습니다. 부품을 선택해주세요');
		return;
	}

	var cnt = $('#CNT').val() * 1;

	if(!$.isNumeric(cnt)){
		GochigoAlert('생성개수에 숫자만 입력해주세요.');
		return;
	}
	if(cnt < 1){
		GochigoAlert('생성개수는 1이상 입력해 주세요.');
		return;
	}

	params = {
			COMPONENT_CD : $('#COMPONENT_CD').val(),
			MODEL_LIST_ID : $('#MODEL_LIST_ID').val(),
			COMPONENT_ID : $('#COMPONENT_ID').val(),
 			MODEL_NM : $('#PART_NAME').val(),
 			COMPONENT_CNT : $('#CNT').val(),
	        USER_ID: "${sessionScope.userInfo.user_id}",
	    };


	 var url = '${insertModelCompopnent}';

	    var isCreate = false;
	    var msg = "";

	    $("<div></div>").kendoConfirm({
			buttonLayout: "stretched",
			actions: [{
				text: '확인',
				action: function(e){
					//시작지점

			    $.ajax({
			        url : url,
			        type : "POST",
					data : params,
			        async : false,
			        success : function(data) {
			            if(data.SUCCESS){
			            	isCreate = true;
			            	msg = data.MSG;
			            	//fnClose();
			            }
			            else{
			            	msg = data.MSG;
			                //fnClose();
			            }
			        }
			    });

			    GochigoAlert(msg);

			    if(isCreate)
			    	opener.fnObj('LIST_'+_openerSid).reloadGrid();

			  //끝지점
				}
			},
			{
				text: '닫기'
			}],
			minWidth : 200,
			title: fnGetSystemName(),
		    content: "확인을 누르면 재고가 생성됩니다."
		}).data("kendoConfirm").open();
		//끝지점
}


function fnWindowOpen_LTComponent(url, callbackName, size) {
    var width, height;
    if(size == "S"){
    	width = "800";
    	height = "600";
    } else if(size == "M") {
    	width = "1024";
    	height = "768";
    } else if(size == "L") {
    	width = "1280";
    	height = "900";
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

	var xPos  = (document.body.clientWidth /2) - (width / 2);
    xPos += window.screenLeft;
    var yPos  = (screen.availHeight / 2) - (height / 2);
    window.open("<c:url value='"+url+"'/>"+"&componentCd="+_componentCd+"&callbackName="+callbackName, "linkPopup", "top="+yPos+", left="+xPos+", width="+width+", height="+height);
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}


</script>
