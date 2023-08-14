<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="warehousingExamineUpdate"					value="/produce/warehousingExamineUpdate.json" />


<script src="/codebase/gochigo.kendo.ui.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.15.5/xlsx.full.min.js"></script>

<style>

</style>
<script>

$(document).ready(function() {

	console.log("load [produceFile.jsp]");

 	$('#${sid}_printBtn').remove();
 	$('#${sid}_gridbox').off('dblclick');


 	setTimeout(function() {
 		var infCond = '<input type="file" name="file" id="fileUpload" placeholder="파일 업로드" onchange="changeFile()" />';
            // '<button id="upload_admin_produce_file" onclick="fnUpdateInfo()" class="k-button" data-role="button" role="button" aria-disabled="false" tabindex="1">파일 업로드</button>';


	 	<%--$('#${sid}_view-btns').prepend(infCond);--%>
        $('#${sid}_btns').append(infCond);

	 	$('.k-button').css('float','right');
        fuChangeDivWidth();
 	}, 500);

});

function fuChangeDivWidth(){
// 	console.log("${sid}");
    var Cwidth = $('#${sid}_header_title').width();
    $('#${sid}_btns').css({'width':Cwidth-20+'px'});
}

function fnClose(){
	console.log("load [fnClose.js]");

	if(typeof(opener) == "undefined" || opener == null) {
		history.back();
	} else {
		window.close();
	}
}

function fnUpdateInfo() {
    // 	여기에 입력
    alert("TEST");
}

function changeFile(file) {

    let input = event.target;
    let reader = new FileReader();
    reader.onload = function () {
        let data = reader.result;
        let workBook = XLSX.read(data, { type: 'binary' });
        workBook.SheetNames.forEach(function (sheetName) {
            console.log('SheetName: ' + sheetName);
            let rows = XLSX.utils.sheet_to_json(workBook.Sheets[sheetName]);
            // console.log(JSON.stringify(rows));
            console.log(rows.K);
            console.log(rows.V);
        })
    };

    reader.readAsBinaryString(input.files[0]);

}

</script>
