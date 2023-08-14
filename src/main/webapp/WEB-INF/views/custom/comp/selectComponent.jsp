<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="compDelete"				value="/compInven/compDelete.json" />
<c:url var="pawdInit"					value="/user/userPawdInit.json" />
<c:url var="dataList"					value="/customDataList.json" />


    <script src="/codebase/gochigo.kendo.ui.js"></script>

<style>

</style>
<script>

var _componentCd = getParameterByName('componentCd');

$(document).ready(function() {

	console.log("load [selectComponent.js]");
//  	$('.basicBtn').remove();
 	$('#${sid}_gridbox').off('dblclick');

	setTimeout(function() {
		$('#selectBtn').removeAttr("onclick");
		$('#selectBtn').attr("onclick", "fnCustomSelect();");
	},1000);

});


function fnCustomSelect(){

	console.log("Function fnCustomSelect()");

	var grid = $('#${sid}_gridbox').data('kendoGrid');
	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.');
	return;}

	var componentData = new Array();
	var componentShowData = new Array();
	componentData[0] =  selItem.component_id;
	componentData[1] =  selItem.component;

	if(_componentCd == 'CPU'){
// 		var _CPUNAME = ["제조사","모델명","상세스펙","코드명","소켓","코어수"] ;

		componentData[2] =  selItem.manufacture_nm;
		componentData[3] =  selItem.model_nm;
		componentData[4] =  selItem.spec_nm;
		componentData[5] =  selItem.code_nm;
		componentData[6] =  selItem.socket_nm;
		componentData[7] =  selItem.core_cnt;

		componentShowData[0] = selItem.manufacture_nm;
		componentShowData[1] = selItem.model_nm;
		componentShowData[2] = selItem.spec_nm;
	}else if(_componentCd == 'MBD'){
		componentShowData[0] = selItem.manufacture_nm;
		componentShowData[1] = selItem.mbd_model_nm;
		componentShowData[2] = selItem.product_name;
	}else if(_componentCd == 'MEM'){
		componentShowData[0] = selItem.manufacture_nm;
		componentShowData[1] = selItem.model_nm;
		componentShowData[2] = selItem.bandwidth;
		componentShowData[3] = selItem.capacity;
		opener.$('#COL4').val(componentShowData[3]);
	}else if(_componentCd == 'VGA'){
		componentShowData[0] = selItem.manufacture_nm;
		componentShowData[1] = selItem.model_nm;
		componentShowData[2] = selItem.capacity;
	}else if(_componentCd == 'STG'){
		componentShowData[0] = selItem.manufacture_nm;
		componentShowData[1] = selItem.model_nm;
		componentShowData[2] = selItem.capacity;
		opener.$('#STG_TYPE').val(selItem.stg_type);
	}else if(_componentCd == 'MON'){
		componentShowData[0] = selItem.manufacture_nm;
		componentShowData[1] = selItem.model_nm;
		componentShowData[2] = selItem.size;
	}

	opener.$('#COMPONENT_ID').val(componentData[0]);
	opener.$('#COMPONENT').val(componentData[1]);

	opener.$('#COL1').val(componentShowData[0]);
	opener.$('#COL2').val(componentShowData[1]);
	opener.$('#COL3').val(componentShowData[2]);



 	self.close();
}

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
