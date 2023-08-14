<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<script>
/**
 * crated by janghs
 */

$(document).ready(function() {
	console.log("load [userData.js]");
});

function userInsert(){
	var queryString = "";
	if('${pid}') {
		queryString += '&pid=${pid}';
	}

	var input = $('#frm_${sid} input[id]:not(.exclude)');
	if(input.length > 0){
		for(var i = 0; i < input.length; i++){
			queryString += "&"+input[i].id+"="+encodeURI(fnEscapeStr(input[i].value));
		}
	}
	var input = $('#frm_${sid} input:checked([type="checkbox"]):not(.exclude)');
	if(input.length > 0){
		for(var i = 0; i < input.length; i++){
			queryString += "&"+input[i].id+"="+encodeURI(fnEscapeStr(input[i].value));
		}
	}
	var select = $('#frm_${sid} select:not(.exclude)');
	if(select.length > 0){
		for(var i = 0; i < select.length; i++){
			queryString += "&"+select[i].id+"="+encodeURI(fnEscapeStr(select[i].value));
		}
	}
	var input = $('#frm_${sid} input:not([id])[name]:checked:not(.exclude)'); //라디오버튼
	if(input.length > 0){
		for(var i = 0; i < input.length; i++){
			queryString += "&"+input[i].name+"="+encodeURI(fnEscapeStr(input[i].value));;
		}
	}
    var textarea = $('#frm_${sid} textarea:not(.exclude)');
    if(textarea.length > 0){
        for(var i=0; i<textarea.length; i++){
            queryString += "&"+textarea[i].name+"="+encodeURI(fnEscapeStr(textarea[i].value));;
        }
    }
    
	$.ajax({
		url : "<c:url value='/admin/userInsert.json'/>"+"?xn=${xn}"+queryString,
		success : function(data) {
			fnObj('CRUD_${sid}').postInsertFunc(data);
		}
	});
}

function userUpdate(){
	var saveData = {};
	var input = $('#frm_${sid} input[id]:not(.exclude)');
	if(input.length > 0){
		for(var i=0; i<input.length; i++){
			var id = input[i].id;
			var value = $('#frm_${sid}').find('#' + id).val();
			saveData[id] = encodeURI(fnEscapeStr(value));
		}
	}

    var textarea = $('#frm_${sid} textarea:not(.exclude)');
    if(textarea.length > 0){
        for(var i=0; i<textarea.length; i++){
        	saveData[textarea[i].name] = encodeURI(fnEscapeStr(textarea[i].value));
        }
    }

	var select = $('#frm_${sid} select:not(.exclude)');
	if(select.length > 0){
		for(var i=0; i<select.length; i++){
        	saveData[select[i].id] = encodeURI(fnEscapeStr(select[i].value));
		}
	}
	var input = $('#frm_${sid} input:not([id])[name]:checked:not(.exclude)'); //라디오버튼
	if(input.length > 0){
		for(var i=0; i<input.length; i++){
        	saveData[input[i].name] = encodeURI(fnEscapeStr(input[i].value));
		}
	}
	saveData['xn'] = '${xn}';
	
	$.ajax({
		url : "<c:url value='/admin/userUpdate.json'/>",
		type : "POST",
		data : saveData,
		success : function(data) {
			fnObj('CRUD_${sid}').postUpdateFunc(data);
		}
	});
}

</script>