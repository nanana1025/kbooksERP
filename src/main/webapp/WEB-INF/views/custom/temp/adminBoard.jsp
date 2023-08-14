<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<style>
.sc_board_03 table {width:100%;}
.sc_board_03 table tbody{}
.sc_board_03 table tbody tr{}
.sc_board_03 table tbody tr td{border-bottom: 1px solid #e4e4e4;}
.sc_board_03 table tbody tr td.sc_board_03_title{height: 70px; text-align: left; padding-left: 15px;}
.sc_board_03 table tbody tr td.sc_board_03_info{height: 60px; text-align: left; padding-left: 15px;}
.sc_board_03 table tbody tr td.sc_board_03_info span{padding-right: 50px;}
.sc_board_03 table tbody tr td.sc_board_03_info span img{padding: 0 5px;}
.sc_board_03 table tbody tr td.sc_board_03_desc{text-align: left; padding: 50px 0;}
.sc_board_03 table tbody tr td.sc_board_03_feed{background: #f6f6f6;}
.sc_board_03 table tbody tr td.sc_board_03_feed ul{}
.sc_board_03 table tbody tr td.sc_board_03_feed ul li:first-child{border-top: 0;}
.sc_board_03 table tbody tr td.sc_board_03_feed ul li{border-top: 1px solid #e4e4e4; padding: 10px 0px 10px 0px; width:100%;}
.sc_board_03 table tbody tr td.sc_board_03_feed ul li .feed_info{display: inline-block; padding-bottom: 10px;}
.sc_board_03 table tbody tr td.sc_board_03_feed ul li .feed_info span{padding: 0 40px 0 10px;}
.sc_board_03 table tbody tr td.sc_board_03_feed ul li .feed_info span img{padding: 0 5px;}
.sc_board_03 table tbody tr td.sc_board_03_feed ul li .feed_btn{display: inline-block; float: right; margin-right:25px;}
.sc_board_03 table tbody tr td.sc_board_03_feed ul li .feed_btn a {margin-left: 10px;}
.sc_board_03 table tbody tr td.sc_board_03_feed ul li .feed_btn a:hover {margin-left: 10px; color: #31c1ca;}
.sc_board_03 table tbody tr td.sc_board_03_feed ul li .feed_about p{padding-left: 40px;}
/* 추가 */
.sc_board_03 table tbody tr td.sc_board_03_feed ul li .feed_about_key p{padding-left: 40px;}
.sc_board_03 table tbody tr td.sc_board_03_feed ul li .feed_about_key p img{vertical-align: middle; margin-right: 5px;}
.sc_board_03 table tbody tr td.sc_board_03_feed ul li .feed_about_key p span{color: #888888;}
.feed_about{ min-width: 600px; }

.input_btn_wr input[type=submit]{width: 75px; height: 50px; margin-left: 15px; position: relative; top: -50px;}
.h110p {height: 50px !important;}
</style>
<script>
/**
 * crated by janghs
 */

$(document).ready(function() {
	console.log("load [adminFreeboard.js]");
	addReplyTable();
	console.log('${sessionScope}');

	setTimeout(function(){
		if(location.pathname.indexOf("dataView") > -1){
			if('${sid}'.indexOf('freeboard') > -1 || '${sid}'.indexOf('qna') > -1){
				$('.k-textbox').prop('readonly', 'readonly');
				$('.k-textbox').css('background-color', '#f6f6f6');
			}
		}
		if('${sid}'.indexOf('freeboard') > -1){
			$('#category_cd').val('A');
			$('#priority_cd').val('B');
		} else if('${sid}'.indexOf('qna') > -1){
			$('#category_cd').val('D');
			$('#priority_cd').val('B');
		} else if('${sid}'.indexOf('faq') > -1){
			$('#category_cd').val('B');
			$('#priority_cd').val('B');
		} else if('${sid}'.indexOf('notice') > -1){
			$('#category_cd').val('C');
			$('#priority_cd').val('A');
		}
		$('#reply_cnt').val('0');
		$('#read_cnt').val('0');
		$('#is_secret').val('N');

		$('#nickname').prop('disabled', 'disabled');
		$('#nickname').val('${sessionScope.userInfo.user_nm}');
	},1000);

});

function addReplyTable(){
	var url = '/board/boardReplyListData.json';
	var params = {
		BBS_ID: '${bbs_id}'
	};

	$.ajax({
		url : url,
		type : "POST",
		data : params,
		async : false,
		success : function(replyList) {
			if(replyList) {
				var table = '';
				table += '<div class="sc_board_03"><table><tbody>';
				$.each(replyList, function(index, reply) {
					table += '<tr class="tr-reply-list">'
					+ '<input type="hidden" name="REPLY_ID" value="' + reply.reply_id + '" "${reply.REPLY_ID}" />'
					+ '<td class="sc_board_03_feed">'
					+ '<ul>'
					+ '<li>'
					+ '<div class="feed_info">'
				    + '<img src="/codebase/imgs/feed_arrow.jpg">'
				    + '<span>'
					+ '<img src="/codebase/imgs/square_dot.jpg">작성자: '
					+ reply.nickname
					+ '</span>'
				    + '<span>'
					+ '<img src="/codebase/imgs/square_dot.jpg">작성일: '
					+ reply.insert_dt
					+ '</span>';
					if(reply.is_secret == 'Y'){
					    table += '<span>'
						+ '<img src="/codebase/imgs/key.png" align="absmiddle">'
						+ '</span>';
					}
					table += '</div>'
					+ '<div class="feed_btn">'
					+ '<a class="btn_01" style="cursor: pointer;" onclick="fnDelReply(this);">삭제</a>'
					+ '</div>'
					+ '<div class="feed_about">'
					+ '<div name="REPLY_CONTENT" style="white-space: pre;">'
					+ reply.content + '</div>'
					+ '</div>'
					+ '</li>'
					+ '</ul>'
					+ '</td>'
					+ '</tr>';
				});
				if('${sessionScope.userInfo}' && '${bbs_id}'){
					table += '<tr id="reply-tr">'
		        		+ '<td class="sc_board_03_feed">'
		        		+ '<ul>'
		        		+ '		<li>'
		        		+ '			<div class="feed_info">'
		        		+ '				<img src="/codebase/imgs/feed_arrow.jpg">'
		        		+ '				<span>'
		        		+ '					<img src="/codebase/imgs/square_dot.jpg">'
		        		+ '					작성자: ${sessionScope.userInfo.user_nm}'
		        		+ '				</span>'
		        		+ '				<div style="display: inline-block;">'
		        		+ '					<input type="checkbox" id="IS_SECRET" name="IS_SECRET" class="in_chk" value="N" onclick="fnIsSecretVal(this);">'
		        		+ '					<span class="font12 mgl-10px" style="vertical-align:text-top;">비밀댓글</span>'
		        		+ '				</div>'
		        		+ '			</div>'
		        		+ '			<div class="feed_about mgt15 input_btn_wr left_flex bor0 pad0">'
		        		+ '				<textarea id="INSERT_REPLY_CONTENT" name="INSERT_REPLY_CONTENT" rows="8" cols="80" class="w960p" style="resize: none;margin-left: 15px;"></textarea>'
		        		+ '				<input type="submit" id="btn-insert-reply" name="btn-insert-reply" class="k-button btn_02 h110p" value="등록" onclick="fnInsertReply();" style="cursor: pointer;">'
		        		+ '			</div>'
		        		+ '		</li>'
		        		+ '	</ul>'
		        		+ '</td>'
		        		+ '</tr>';
				}
				table += '</tbody></table></div>';
				$('.content').append(table);
			}
		}
	});

}

function fnIsSecretVal(elem) {
	if($(elem).is(':checked'))
		$(elem).val('Y');
	else
		$(elem).val('N');
}

function fnUpdateReplyList() {
	fnDelReplyList();
	addReplyTable();
}

function fnDelReplyList() {
	$('.sc_board_03').remove();
}

function fnDelReply(elem) {
	if (!confirm('정말 삭제하시겠습니까?'))
		return;

	var url = '/board/boardReplyDelete.json';
	var replyId = $(elem).closest('tr').children('input[name="REPLY_ID"]').val();
	var params = {
		BBS_ID : '${bbs_id}',
		REPLY_ID : replyId
	};

	$.post(url, params, function(rJson) {
		if (rJson.msg)
			alert(rJson.msg);

		if (rJson.success)
			fnUpdateReplyList();
	});
}

function fnValidate() {
	var content = $('#INSERT_REPLY_CONTENT').val();

	if (!content) {
		alert('댓글을 입력해 주세요.');
		return false;
	}

	if (content.length > 250) {
		alert('댓글은 250자 이하로 입력 가능합니다.');
		return false;
	}

	return true;
}

function fnInsertReply() {
	if (!fnValidate())
		return;

	var url = '/board/boardReplyInsert.json';
	var params = {
		BBS_ID : '${bbs_id}',
		USER_ID : '${sessionScope.userInfo.user_id}',
		IS_SECRET: $('#IS_SECRET').val(),
		CONTENT : $('#INSERT_REPLY_CONTENT').val()
	};

	$.post(url, params, function(rJson) {
		if (rJson.msg)
			alert(rJson.msg);

		if (rJson.success) {
			fnUpdateReplyList();
			$('#INSERT_REPLY_CONTENT').val('');
		} else {
			if(rJson.validateResult) {
				var validateResult = rJson.validateResult;
				var keys = Object.keys(validateResult);
				$.each(keys, function(index, key) {
					var notification = $("#notification").data("kendoNotification");
	                notification.show({
	                    message: validateResult[key]
	                }, "error");
				});
			}
		}
	});
}

</script>
<span id="notification" style="display: none;"></span>