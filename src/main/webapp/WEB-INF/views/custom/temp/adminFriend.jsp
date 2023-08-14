<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>

<c:url var="friendDel"					value="/user/userFriendDel.json" />

<style>
</style>
<script>

$(document).ready(function() {

	console.log("load [adminFriend.js]");

	$('.basicBtn').remove();
	$('#admin_share_friend_list_gridbox').off('dblclick');
});

function fnFriendAd() {

	console.log("admin_share_frined_list.fnFriendAd() Load");
}

function fnFriendDel() {

	console.log("admin_share_frined_list.fnFriendDel() Load");

	var url = '${friendDel}';
	var grid = $('#admin_share_friend_list_gridbox').data('kendoGrid');

	var selItem = grid.dataItem(grid.select());
	if(!selItem) {GochigoAlert('선택된 항목이 없습니다.'); return;}
	console.log(selItem);

	//시작지점
	$("<div></div>").kendoConfirm({
		buttonLayout: "stretched",
		actions: [{
			text: '확인',
			action: function(e){
				//시작지점

// 	if (!confirm('정말 삭제하시겠습니까?'))
// 		return;

				var params = {
					DUTY_SHARE_ID: selItem.duty_share_id,
				};

				$.ajax({
					url : url,
					type : "POST",
					data : params,
					async : false,
					success : function(data) {
						if(data.success)
							GochigoAlert('삭제되었습니다.');
						else
							GochigoAlert('오류가 발생했습니다. 관리자에게 문의하세요.');
					}

				});

				fnObj('LIST_${sid}').reloadGrid();

				//끝지점
			}
		},
		{
			text: '닫기'
		}],
		minWidth : 200,
		title: fnGetSystemName(),
	    content: "정말 삭제하시겠습니까?"
	}).data("kendoConfirm").open();
	//끝지점
}

</script>
