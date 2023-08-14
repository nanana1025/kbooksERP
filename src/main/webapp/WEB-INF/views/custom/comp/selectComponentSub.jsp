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

	console.log("load [selectComponentsub.js]");
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
	componentData[2] =  selItem.manufacture_nm;
	componentData[3] =  selItem.model_nm;

	if(_componentCd == 'CAS'){

		opener.$('#CASE_CAT').val(selItem.case_cat);
// 	    const case_cat = opener.$('#CASE_CAT option:selected').text();
// 	    opener.$('#CASE_CAT').siblings()[0].children[0].textContent = case_cat;

	    opener.$('#CASE_TYPE').val(selItem.case_type);
// 	    const case_type = opener.$('#CASE_TYPE option:selected').text();
// 	    opener.$('#CASE_TYPE').siblings()[0].children[0].textContent = case_type;

	}else if(_componentCd == 'ADP'){
		opener.$('#ADP_CAT').val(selItem.adp_cat);
// 	    const adp_cat = opener.$('#CASE_CAT option:selected').text();
// 	    opener.$('#ADP_CAT').siblings()[0].children[0].textContent = adp_cat;

	    opener.$('#OUTPUT_WATT').val(selItem.output_watt);
		opener.$('#OUTPUT_AMPERE').val(selItem.output_ampere);


	}else if(_componentCd == 'AIR'){
		opener.$('#TYPE').val(selItem.type);
// 	    const type = opener.$('#TYPE option:selected').text();
// 	    opener.$('#TYPE').siblings()[0].children[0].textContent = type;

	    opener.$('#CATEGORY').val(selItem.category);
// 	    const category = opener.$('#CATEGORY option:selected').text();
// 	    opener.$('#CATEGORY').siblings()[0].children[0].textContent = category;

	    opener.$('#SIZE').val(selItem.size);
// 	    const size = opener.$('#SIZE option:selected').text();
// 	    opener.$('#SIZE').siblings()[0].children[0].textContent = size;
	}
	else if(_componentCd == 'BAT'){
		opener.$('#BAT_CAT').val(selItem.bat_cat);
// 	    const bat_cat = opener.$('#BAT_CAT option:selected').text();
// 	    opener.$('#BAT_CAT').siblings()[0].children[0].textContent = bat_cat;

	    opener.$('#OUTPUT_WATT').val(selItem.output_watt);
		opener.$('#OUTPUT_AMPERE').val(selItem.output_ampere);

	}else if(_componentCd == 'CAB'){

		opener.$('#CAB_CAT').val(selItem.cab_cat);
// 	    const cab_cat = opener.$('#CAB_CAT option:selected').text();
// 	    opener.$('#CAB_CAT').siblings()[0].children[0].textContent = cab_cat;

	    opener.$('#CAB_TYPE').val(selItem.cab_type);
// 	    const cab_type = opener.$('#CAB_TYPE option:selected').text();
// 	    opener.$('#CAB_TYPE').siblings()[0].children[0].textContent = cab_type;

	    opener.$('#CAB_CLASS').val(selItem.cab_class);
// 	    const cab_class = opener.$('#CAB_CLASS option:selected').text();
// 	    opener.$('#CAB_CLASS').siblings()[0].children[0].textContent = cab_class;

	}else if(_componentCd == 'FAN'){
		opener.$('#FAN_CAT').val(selItem.fan_cat);
// 	    const fan_cat = opener.$('#FAN_CAT option:selected').text();
// 	    opener.$('#FAN_CAT').siblings()[0].children[0].textContent = fan_cat;

	    opener.$('#FAN_TYPE').val(selItem.fan_type);
// 	    const fan_type = opener.$('#FAN_TYPE option:selected').text();
// 	    opener.$('#FAN_TYPE').siblings()[0].children[0].textContent = fan_type;

	}else if(_componentCd == 'KEY'){

		opener.$('#KEY_CAT').val(selItem.key_cat);
// 	    const key_cat = opener.$('#KEY_CAT option:selected').text();
// 	    opener.$('#KEY_CAT').siblings()[0].children[0].textContent = key_cat;

	    opener.$('#KEY_TYPE').val(selItem.key_type);
// 	    const key_type = opener.$('#KEY_TYPE option:selected').text();
// 	    opener.$('#KEY_TYPE').siblings()[0].children[0].textContent = key_type;

	    opener.$('#KEY_CLASS').val(selItem.key_class);
// 	    const key_class = opener.$('#KEY_CLASS option:selected').text();
// 	    opener.$('#KEY_CLASS').siblings()[0].children[0].textContent = key_class;

	}else if(_componentCd == 'MOU'){

		opener.$('#MOU_CAT').val(selItem.mou_cat);
// 	    const mou_cat = opener.$('#MOU_CAT option:selected').text();
// 	    opener.$('#MOU_CAT').siblings()[0].children[0].textContent = mou_cat;

	    opener.$('#MOU_TYPE').val(selItem.mou_type);
// 	    const mou_type = opener.$('#MOU_TYPE option:selected').text();
// 	    opener.$('#MOU_TYPE').siblings()[0].children[0].textContent = mou_type;

	}else if(_componentCd == 'PKG'){

		opener.$('#PACKAGE_TYPE').val(selItem.package_type);
// 	    const package_type = opener.$('#PACKAGE_TYPE option:selected').text();
// 	    opener.$('#PACKAGE_TYPE').siblings()[0].children[0].textContent = package_type;

	    opener.$('#CATEGORY').val(selItem.category);
// 	    const category = opener.$('#CATEGORY option:selected').text();
// 	    opener.$('#CATEGORY').siblings()[0].children[0].textContent = category;

	    opener.$('#SIZE').val(selItem.size);
// 	    const size = opener.$('#SIZE option:selected').text();
// 	    opener.$('#SIZE').siblings()[0].children[0].textContent = size;

	}else if(_componentCd == 'POW'){

		opener.$('#POW_CAT').val(selItem.pow_cat);
// 	    const pow_cat = opener.$('#POW_CAT option:selected').text();
// 	    opener.$('#POW_CAT').siblings()[0].children[0].textContent = pow_cat;

	    opener.$('#POW_TYPE').val(selItem.pow_type);
// 	    const pow_type = opener.$('#POW_TYPE option:selected').text();
// 	    opener.$('#POW_TYPE').siblings()[0].children[0].textContent = pow_type;

	    opener.$('#POW_CLASS').val(selItem.pow_class);
// 	    const pow_class = opener.$('#POW_CLASS option:selected').text();
// 	    opener.$('#POW_CLASS').siblings()[0].children[0].textContent = pow_class;

	}else if(_componentCd == 'LIC' || _componentCd == 'PER'){

		opener.$('#TYPE').val(selItem.type);
		opener.$('#ETC').val(selItem.etc);
	}

	opener.$('#COMPONENT_ID').val(componentData[0]);
	opener.$('#COMPONENT').val(componentData[1]);
	opener.$('#MANUFACTURE_NM').val(componentData[2]);
	opener.$('#MODEL_NM').val(componentData[3]);




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
