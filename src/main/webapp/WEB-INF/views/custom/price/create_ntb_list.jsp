<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="insertNTBList"					value="/price/insertNTBList.json" />
<c:url var="printCore"						value="/print/printCore.json"/>

<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

var _displaySeq = getParameterByName('DISPLAY_SEQ');

$(document).ready(function() {

	console.log("load [create_ntb_list.jsp]");


	$('#saveBtn_ntb_price').remove();
 	setTimeout(function() {
 		$('#saveBtn_ntb_price').remove();

//  		var index = 0;
// 		$('#tbl_${sid} tr').each(function(){
// 			var tr = $(this);
// 			var td = tr.children();
// 			if(index >2  && index <9 )
// 				td.eq(0).text(_CPUNAME[index-3]);
// 			index++;
		});

	 	var infCond = '<button id="insert_ntb_list" onclick="fnComponentInsert()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">저장</button>';

	 	$('#ntb_price_view-btns').prepend(infCond);

		$('#DISPLAY_SEQ').val(_displaySeq);

	 	setTimeout(function() {
	 		$('#DISPLAY_SEQ').val(_displaySeq);
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


function fnComponentInsert() {

// 	var componentCd = $('.header_title').text().trim();
	var params;

// 	if("${sessionScope.userInfo.user_id}" == ""){
// 		GochigoAlert('세션 정보가 만료되었습니다. 로그아웃 후 다시 로그인해 주세요.');
// 		return;
// 	}

// 	if($('#WAREHOUSING').val() ==''){
// 		GochigoAlert('입고번호가 입력되지 않았습니다. 창을 닫고 다시 시도해 주세요.');
// 		return;
// 	}

// 	if($('#WAREHOUSING').val().length != 10){
// 		GochigoAlert('올바르지 않은 입고번호 입니다.');
// 		return;
// 	}

// 	if($('#COMPONENT_ID').val() ==''){
// 		GochigoAlert('부품번호가 입력되지 않았습니다. 부품을 선택해주세요');
// 		return;
// 	}

// 	if($('#COMPANY_ID').val() ==''){
// 		GochigoAlert('업체정보가 입력되지 않았습니다. 화면을 닫고 다시 시도해 주세요.');
// 		return;
// 	}

// 	if($('#LOCATION').val() ==''){
// 		GochigoAlert('재고위치를 선택해 주세요.');
// 		return;
// 	}

// 	var cnt = $('#CNT').val() * 1;

// 	if(!$.isNumeric(cnt)){
// 		GochigoAlert('생성개수에 숫자만 입력해주세요.');
// 		return;
// 	}
// 	if(cnt < 1){
// 		GochigoAlert('생성개수는 1이상 입력해 주세요.');
// 		return;
// 	}

	params = {
			NTB_CATEGORY : $('#NTB_CATEGORY').val(),
			NTB_CODE : $('#NTB_CODE').val(),
			NTB_NAME : $('#NTB_NAME').val(),
			NTB_GENERATION : $('#NTB_GENERATION').val(),
			NTB_NICKNAME : $('#NTB_NICKNAME').val(),
			LT_PURCHASE_PRICE_MAJOR : $('#LT_PURCHASE_PRICE_MAJOR').val(),
			LT_PURCHASE_PRICE_ETC : $('#LT_PURCHASE_PRICE_ETC').val(),
			LT_DANAWA_PRICE_MAJOR : $('#LT_DANAWA_PRICE_MAJOR').val(),
			LT_DANAWA_PRICE_ETC : $('#LT_DANAWA_PRICE_ETC').val(),
			LT_DEALER_PRICE_MAJOR : $('#LT_DEALER_PRICE_MAJOR').val(),
			LT_DEALER_PRICE_ETC : $('#LT_DEALER_PRICE_ETC').val(),
			DISPLAY_SEQ : $('#DISPLAY_SEQ').val(),

	    };


// 	console.log("params = "+params);
	 var url = '${insertNTBList}';

	    var isCreate = false;
	    var msg = "";

	    $("<div></div>").kendoConfirm({
			buttonLayout: "stretched",
			actions: [{
				text: '추가',
				action: function(e){
					//시작지점

			    $.ajax({
			        url : url,
			        type : "POST",
			        data : JSON.stringify(params),
					contentType: "application/json",
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
			    	opener.window.location.reload();

			  //끝지점
				}
			},
			{
				text: '취소'
			}],
			minWidth : 200,
			title: fnGetSystemName(),
		    content: "노트북 리스트를 추가하시겠습니까?"
		}).data("kendoConfirm").open();
		//끝지점
}


function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}


</script>
