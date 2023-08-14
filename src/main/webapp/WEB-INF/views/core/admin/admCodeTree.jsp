<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

 <script src="/codebase/gochigo.kendo.ui.js"></script>

<script>
/**
 * created by janghs
 */
$(document).ready(function() {
	checkLoadPageJsFile();
	addCustomBtns();
	setTimeout(function(){$(".kendoBtn").kendoButton();}, 300);
	setTimeout(function(){$("#invoice_file").kendoUpload();}, 300);
});

function checkLoadPageJsFile() {
	console.log('Load Complete File [adminCodeTree.js]');
}

function addCustomBtns() {
	var sid = "admin_code_tree";

    var btns = "<button class='kendoBtn' id='" + sid + "_divInsert' style='float: right;'>코드등록</button>";
    $(".treeHeader").append(btns);
    //팝업 위치 계산
    var nWidth = "572"; //너비
    var nHeight = "330"; //높이
    var curX = window.screenLeft;
    var curY = window.screenTop;
    var curWidth = document.body.clientWidth;
    var curHeight = document.body.clientHeight;

    var nLeft = curX + (curWidth / 2) - (nWidth / 2);
    var nTop = curY + (curHeight / 2) - (nHeight / 2);
    var strOption = "";
    strOption += "left=" + nLeft + ",";
    strOption += "top=" + nTop + ",";
    strOption += "width=" + nWidth + ",";
    strOption += "height=" + nHeight;

    $("#" + sid + "_divInsert").click(function() {
        window.open("/admin/codeClsInsert.do", "_blank", strOption);
    });

	var btns = "<button class='kendoBtn' id='" + sid + "_divUpdate' style='float: right;'>코드수정</button>";
	$(".treeHeader").append(btns);
	$("#"+sid+"_divUpdate").click(function() {
		var selItem = fnObj('TREE_admin_code_tree')._selItem;
		if(!selItem){
			GochigoAlert("코드를 선택하십시오.");
			return;
		}
		//팝업 위치 계산
		var nWidth = "572"; //너비
		var nHeight = "330"; //높이
		var curX = window.screenLeft;
		var curY = window.screenTop;
		var curWidth = document.body.clientWidth;
		var curHeight = document.body.clientHeight;

		var nLeft = curX + (curWidth / 2) - (nWidth / 2);
		var nTop = curY + (curHeight / 2) - (nHeight / 2);
		var strOption = "";
		strOption += "left=" + nLeft + ",";
		strOption += "top=" + nTop + ",";
		strOption += "width=" + nWidth + ",";
		strOption += "height=" + nHeight;
		window.open("/admin/codeClsUpdate.do?CODE_CLS=" + selItem.code_cls, "_blank", strOption);
	});

    var btns = "<button class='kendoBtn' id='" + sid + "_divDelete' style='float: right;'>코드삭제</button>";
    $(".treeHeader").append(btns);
    $("#" + sid + "_divDelete").click(function() {
        GochigoConfirm("코드분류와 하위 코드 내용이 전부 삭제됩니다. 삭제하시겠습니까?");
    });
}

function afterConfirm() {
	var selItem = fnObj('TREE_admin_code_tree')._selItem;
    $.ajax({
        url : '/admin/codeClsDelete.json',
        data : {
            CODE_CLS : selItem.code_cls,
        },
        dataType: 'json',
        success : function(data) {
            fnObj('TREE_admin_code_tree').fnReloadTree();
            fnObj('LIST_admin_code_list').reloadGrid();
        }
    });
}

</script>