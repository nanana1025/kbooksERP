<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${param.mode!='layout'}">
<!DOCTYPE html>
<html>
<title>${title}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta charset="utf-8"/>

    <link rel="stylesheet" type="text/css" href="/codebase/css/examples-offline.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
    <link rel="stylesheet" type="text/css" href="/codebase/style.css"/>

    <script src="/js/jquery-3.3.1.js"></script>
    <script src="/codebase/kendo/kendo.all.min.js"></script>
    <script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
</c:if>
<body class="k-content">
<div class="header_title">
    <span class="pagetitle"><span class="k-icon k-i-grid-layout"></span> 권한 별 사용자 설정</span>
</div>
<div style="padding:20px 10px 20px 20px;">
    <label for="authList">사용자 권한 : </label>
    <input id="authList">

    <div style="float:right; text-align: center; padding:20px 0px 0px 20px">
        <button id="saveBtn">저장</button>
        <button id="backBtn">취소</button>
    </div>
</div>

<div id="gridHml" class="k-content" style="width:100%; margin-top: 10px;">
    <div class="header_title">
        <span class="pagetitle"><span class="k-icon k-i-list-unordered k-i-list-bulleted"></span> 사용자목록</span>
    </div>
    <div id="userList" class="body-content"></div>
</div>
</body>
    <script>

    function loadList() {
        $('#userList').kendoGrid({
            dataSource: {
                transport: {
                    read: {
                        url: "<c:url value='/dataList.json'/>"+"?xn=admin_users",
                        dataType: "json"
                    }
                },
                error : function(e) {
                    GochigoAlert(e.xhr.responseJSON.message);
                },
                schema: {
                    data: 'gridData',
                    total: 'total',
                    model:{
                        id:"user_id"
                    }
                },
                pageSize: 20,
                serverPaging: true,
                serverSorting : true
            },
            change: onChange,
            sortable: true,
            scrollable: true,
            persistSelection: true,
            columns:  [
                { selectable: true, width: "25px"},
                {"field":"user_id"		,"width":"0%" ,"attributes":{"style":"text-align:center;"},"title":""		 ,"headerAttributes":{"style":"text-align:center;"} ,"hidden":true},
                {"field":"login_id"		,"width":"15%","attributes":{"style":"text-align:center;"},"title":"사용자ID","headerAttributes":{"style":"text-align:center;"}},
                {"field":"user_nm"		,"width":"15%","attributes":{"style":"text-align:center;"},"title":"사용자명","headerAttributes":{"style":"text-align:center;"}},
                {"field":"job_rank_nm"	,"width":"10%","attributes":{"style":"text-align:center;"},"title":"직급"	 ,"headerAttributes":{"style":"text-align:center;"}},
                {"field":"buyer_nm"		,"width":"15%","attributes":{"style":"text-align:center;"},"title":"회사명"	 ,"headerAttributes":{"style":"text-align:center;"}},
                {"field":"phone_no"		,"width":"10%","attributes":{"style":"text-align:center;"},"title":"전화번호","headerAttributes":{"style":"text-align:center;"}},
                {"field":"auth_nm"		,"width":"10%","attributes":{"style":"text-align:center;"},"title":"권한"	 ,"headerAttributes":{"style":"text-align:center;"}},
                {"field":"state_nm"		,"width":"15%","attributes":{"style":"text-align:center;"},"title":"상태"	 ,"headerAttributes":{"style":"text-align:center;"}},
                {"field":"auth_id"		,"width":"2%" ,"title":"","hidden":true}
            ],
            pageable: {
                input: true,
                numeric: false
            },
            dataBound : function(e) {
                var grid = this;
                var rows = grid.items();
                $(rows).each(function(e) {
                    var row = this;
                    var dataItem = grid.dataItem(row);
                    if(dataItem.auth_id == $("#authList").val()) {
                        grid.select(row);
                    }
                });
            }
        });
    }

    function onChange(arg) {
        $('#userList').data("kendoGrid").selectedKeyNames();
    }

    function onClickSaveBtn() {
        var _auth = $("#authList").val();
        var _users = $('#userList').data("kendoGrid").selectedKeyNames().join(",");

        if(!_auth) {
            GochigoAlert('사용자 권한이 선택되지 않았습니다.');
            $("#authList").focus();
            return;
        }

        var grid = $('#userList').data("kendoGrid");
        var data = grid.dataSource.data();

        $(data).each(function(i,o) {
            var row = $('#userList').data("kendoGrid").dataSource.get(o);
            var _userArr = _users.split(",");

            //체크된것
            if($.inArray(o.user_id.toString(), _userArr)> -1) {
                if(o.auth_id != _auth) {
                    //업데이트 대상(권한 변경)
                    console.log('권한 변경대상' + o.user_nm);
                    updateAuthProc(o.user_id ,_auth);
                }
            } else {
                //체크 안된것 중
                if(o.auth_id == _auth) {
                    //업데이트 대상(권한 해제)
                    console.log('권한 해제 대상' + o.user_nm);
                    updateAuthProc(o.user_id ,'');
                }
            }
        });
        GochigoAlert('저장되었습니다.');
        $("#userList").data("kendoGrid").dataSource.read();
    }

    function updateAuthProc(userId, authId) {
        $.ajax({
            url : "/admin/updateUserAuth.json",
            async : false,
            data : {
                userId : userId,
                authId : authId
            },
            success : function(data) {
                if(data != 'success') {
                    GochigoAlert('error !!');
                }
            }
        });
    }

    function onChangeSelect() {
//         var treeView = $("#deptTree").data("kendoTreeView");

        var qStr ='';
//         var selectedtreenode = treeView.select();
//         var selItem = treeView.dataItem(selectedtreenode);
//         if (selItem.dept_id) {
//             qStr += '&cobjectid=dept_id';
//             qStr += '&cobjectval=' + selItem.dept_id;
//             selDeptId = selItem.dept_id;
//         }

        var grid = $("#userList").data("kendoGrid");
        grid._selectedIds = {};
        grid.clearSelection();

        $("#userList").data("kendoGrid").dataSource.transport.options.read.url = "<c:url value='/admin/dataList.json'/>"+"?xn=admin_users"+qStr;
        $("#userList").data("kendoGrid").dataSource.read();
    }

    function resizeGrid() {
        var gridHml = $("#gridHml");
        var gridElement = $("#userList"),
            dataArea = gridElement.find(".k-grid-content").first(),
            otherElements = gridElement.children().not(".k-grid-content"),
            otherElementsHeight = 0;
        otherElements.each(function() {
            otherElementsHeight += Math.ceil($(this).outerHeight());
        });

        var gridHmlHeight = gridHml.height();
        var winHeight = $(window).height() - 35;
        var gridContentOffset =  $("#userList .k-grid-header").offset().top;//그리드 헤더까지 상단 offset

        var contentHeight = winHeight - Math.ceil(gridContentOffset) - Math.ceil(otherElementsHeight); //그리드 데이터 영역 높이 계산
        dataArea.height(contentHeight );
    }

    $(window).resize(function() {
        resizeGrid();
    });

    $(document).ready(function() {
        loadList();
        resizeGrid();
        $("#saveBtn").kendoButton({icon:"edit"});
        $("#saveBtn").click(function(e) {
            onClickSaveBtn();
        });
        $("#backBtn").kendoButton({icon:"close"});
        $("#backBtn").click(function(e) {
            location.href = "/admin/layout.do?xn=MAIN_LAYOUT";
        });

        $("#authList").kendoDropDownList({
            dataTextField : "AUTH_NM",
            dataValueField : "AUTH_ID",
            dataSource : ${authList},
            change : onChangeSelect
        });

    });
    </script>
</html>
