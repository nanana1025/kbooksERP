<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<%-- <c:url var="compDelete"				value="/compInven/compDelete.json" /> --%>
<%-- <c:url var="pawdInit"					value="/user/userPawdInit.json" /> --%>
<%-- <c:url var="dataList"					value="/customDataList.json" /> --%>

<c:url var="insertModelCompopnent"					value="/consigned/insertModelCompopnent.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>

<style>

</style>
<script>

var _companyid = getParameterByName('COMPANY_ID');
var _modellistid = getParameterByName('MODEL_LIST_ID');
var _openerSid = getParameterByName('pid');

$(document).ready(function() {

	console.log("load [consignedSelectComponent.js]");
	$('.basicBtn').remove();
	$('#${sid}_gridbox').off('dblclick');

	setTimeout(function() {
		$('#selectBtn').removeAttr("onclick");
		$('#selectBtn').attr("onclick", "fnCustomSelect();");
	},1000);

});


function fnCustomSelect(){
	console.log("${sid}.fnDeleteWarehousingExamine() Load");

	var url = '${insertModelCompopnent}';

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var rows = grid.select();
	if(rows.length < 1) {GochigoAlert('선택된 항목이 없습니다.'); return;}

// 	if("${sessionScope.userInfo.user_id}" == ""){
// 		GochigoAlert('세션 정보가 만료되었습니다. 로그아웃 후 다시 로그인해 주세요.');
// 		return;
// 	}

	 var isCreate = false;
	    var msg = "";

	    $("<div></div>").kendoConfirm({
			buttonLayout: "stretched",
			actions: [{
				text: '확인',
				action: function(e){
					//시작지점

					var listComponentId = [];
					 rows.each(function (index, row) {
						 var gridData = grid.dataItem(this);
						 listComponentId.push(gridData.component_id);
						 });

					 params = {
								MODEL_LIST_ID : _modellistid,
								COMPONENT_ID : listComponentId.toString(),
// 						        USER_ID: "${sessionScope.userInfo.user_id}",
						    };

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

			    if(isCreate)
			    	opener.fnObj('LIST_'+_openerSid).reloadGrid();
			    	GochigoAlert(msg, true, "dangol365ERP");

			  //끝지점
				}
			},
			{
				text: '닫기'
			}],
			minWidth : 200,
			title: fnGetSystemName(),
		    content: "선택하신 부품을 현재 모델에 추가하시겠습니까?"
		}).data("kendoConfirm").open();
		//끝지점
}

// function fnCustomSelect(){

// 	console.log("Function fnCustomSelect()");

// 	var grid = $('#${sid}_gridbox').data('kendoGrid');
// 	var selItem = grid.dataItem(grid.select());
// 	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.');
// 	return;}


// 	var manufacture_nm = selItem.manufacture_nm == null? "": selItem.manufacture_nm;
// 	var model_nm= selItem.model_nm == null? "": selItem.model_nm;
// 	var spec_nm= selItem.spec_nm == null? "": selItem.spec_nm;
// 	var col1= selItem.col1 == null? "": selItem.col1;
// 	var col2= selItem.col2 == null? "": selItem.col2;

// 	var modelNm = manufacture_nm+"/"+model_nm+"/"+spec_nm+"/"+col1+"/"+col2;

// 		var params = {
// 				MODEL_NM: modelNm,
// 				COMPONENT_ID : selItem.component_id,
// 				COMPONENT_CD : selItem.component_cd
// 			};

// // 		var _CPUNAME = ["제조사","모델명","상세스펙","코드명","소켓","코어수"] ;
// 		opener.$('#MODEL_NM').val(params.MODEL_NM);
// 		opener.$('#COMPONENT_ID').val(params.COMPONENT_ID);
// 		opener.$('#COMPONENT_CD').val(params.COMPONENT_CD);

// // 	}


// //  	console.log(params.OTHER_PURCHASE_PART_ID);
// //  	console.log(params.PART_KEY);
// //  	console.log(params.PART_NAME);


// 	self.close();
// }


function fnCancel(){
	self.close();
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
            results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}


</script>
