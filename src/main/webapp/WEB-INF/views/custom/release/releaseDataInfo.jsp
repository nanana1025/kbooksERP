<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="createBox"					value="/release/createBox.json" />
<c:url var="updateReleaseInfo"					value="/release/updateReleaseInfo.json" />

<script src="/codebase/gochigo.kendo.ui.js"></script>
<style>

</style>
<script>

$(document).ready(function() {
	console.log("load [releaseDataInfo.jsp]");

    $('#saveBtn_${sid}').remove();

 	setTimeout(function() {
        var infCond1 = '<button id="insert_box" onclick="fnCreateBox()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">박스생성</button>';
	 	var infCond2 = '<button id="update_release_sale_order_data" onclick="fnUpdateReleaseInfo()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">수정</button>';

	 	$('#${sid}_view-btns').prepend(infCond2);
	 	$('#${sid}_view-btns').prepend(infCond1);
	 	$('#RELEASE_DT').attr("readonly","readonly");
 	}, 500);
});

function fnClose(){
	console.log("load [fnClose.js]");

	if(typeof(opener) == "undefined" || opener == null) {
		history.back();
	} else {
		window.close();
	}
}

function fnCreateBox(){
	console.log("${sid}.fnCreateBox() Load");

	var boxId = $('#BOX_ID').val(); // COMPONENT_ID

	if(boxId != ""){
		GochigoAlert('선택하신 출고에는 박스 정보가 존재합니다.');
		return;
	}

	var params = {
			MENU_CATEGORY : "RELEASE",
	        TABLE_NAME : "TN_RELEASE",
	        PK : "RELEASE_ID",
	        PK_VALUE:$('#RELEASE_ID').val()
	    };


	var url = '${createBox}';
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
				data : params,
				async : false,
				success : function(data) {
					if(data.SUCCESS){
						GochigoAlert(data.MSG);
		// 				$('#${sid}_estimate_btn').show();
		 				$('#BOX_ID').val(data.BOX_ID);
		 				$('#BOX').val(data.BOX);
						isSuccess = true;

					}
					else{
						GochigoAlert(data.MSG);
					}
				}
			});

			if(isSuccess)
				fnObj('LIST_release_all_list').reloadGrid();

			//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "선택하신 출고에 박스를 생성하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

function fnUpdateReleaseInfo() {
	console.log("${sid}.fnUpdateReleaseInfo() Load");

	// key
    var RELEASE_ID = $('#RELEASE_ID').val(); // RELEASE_ID
    var RELEASE_DT = $('#RELEASE_DT').val(); // RELEASE_DT
    var CUSTOMER_NM = $('#CUSTOMER_NM').val(); // 거래처
    var RELEASE_STATE = $('#RELEASE_STATE').val(); // RELEASE_TYPE
    var RELEASE_TYPE = $('#RELEASE_TYPE').val(); // RELEASE_TYPE

    if(RELEASE_DT == "선택 또는 출고시 자동 입력")
    	RELEASE_DT = "";

	var url = '${updateReleaseInfo}';
	var isSuccess = false;

	var params = {
 		RELEASE_ID : RELEASE_ID,
 		RELEASE_DT : RELEASE_DT,
 		CUSTOMER_NM : CUSTOMER_NM,
 		RELEASE_STATE : RELEASE_STATE,
 		RELEASE_TYPE : RELEASE_TYPE
	};
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
					data : params,
					async : false,
					success : function(data) {
						if(data.SUCCESS) {
							//setWarehousing(params);
							GochigoAlert(data.MSG);
							isSuccess = true;

						    //fnObj('LIST_${sid}').reloadGrid();

						} else {
							GochigoAlert(data.MSG);
						}
					}
				});

				if(isSuccess)
					fnObj('LIST_release_all_list').reloadGrid();

	//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "출고정보를 수정하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}


</script>
