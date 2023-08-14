<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>


<c:url var="getNTBPriceRatio"					value="/price/getNTBPriceRatio.json"/>
<c:url var="createNTBPriceRatio"				value="/price/createNTBPriceRatio.json" />



<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	<title>DANGOL365 ERP | 노트북 가격 비율</title>

	<link rel="stylesheet" type="text/css" href="/codebase/css/custom_style.css"/>

    <script>

    $(document).ready(function() {

    	fnInitNtbPriceRatio();

    });


    function fnClose(){
    	console.log("fnClose()");

		window.close();
	}

    function fnSave(){
    	// 저장 버튼 클릭 시 실행됩니다.
    }



    function fnInitNtbPriceRatio() {
		console.log("CompanyList.fnInitNtbPriceRatio() Load");

		var url = '${getNTBPriceRatio}';

		var params = {
				KEY: 1
			};

		$.ajax({
    		url : url,
    		type : "POST",
    		data : params,
    		async : false,
    		success : function(data) {

    			if(data.SUCCESS){

    				getPriceRatio(data.DATA);
    			}
    		}
    	});
	}




    function getPriceRatio(DATA){
		var price_ratio = DATA;

		if(price_ratio.length > 0) {

			$(".ntb_price_ratio_data").empty();

			for(var i=0; i<price_ratio.length; i++) {

				var cpuRatio = price_ratio[i].CPU;
				var mbdRatio = price_ratio[i].MBD;
				var lceRatio = price_ratio[i].LCD;
				var userNm = price_ratio[i].USER_NM;
				var createDt = price_ratio[i].CREATE_DT;


				var color;

				if(i%2 == 1) color = "#E6E6E6";
				else color = "#FFFFFF"


				var item = '<tr>';
				item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+(i+1)+'</td>';
				item +='<td  class="col-title-right" style="background-color:'+color+'; height: 27px;">'+cpuRatio+'%</td>';
				item +='<td  class="col-title-right" style="background-color:'+color+'; height: 27px;">'+mbdRatio+'%</td>';
				item +='<td  class="col-title-right" style="background-color:'+color+'; height: 27px;">'+lceRatio+'%</td>';
				item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+userNm+'</td>';
				item +='<td  class="col-title-center" style="background-color:'+color+'; height: 27px;">'+createDt+'</td>';

				item += '</tr>';
				$(".ntb_price_ratio_data").append(item);
			}

		}
	}

	function fnAdd(){
		// 추가 버튼 클릭 시 실행됩니다.
		var cpuRatio = $("#price_ratio_cpu").val();
		var mbdRatio = $("#price_ratio_mbd").val();
		var lceRatio = $("#price_ratio_lcd").val();

		cpuRatio = cpuRatio.replaceAll("%","");
		mbdRatio = mbdRatio.replaceAll("%","");
		lceRatio = lceRatio.replaceAll("%","");

		if(cpuRatio == "" || mbdRatio == "" || lceRatio == ""){
			GochigoAlert("가격 비율을 입력하세요.", false, "dangol365 ERP");
			return;
			}


		var url = '${createNTBPriceRatio}';

		var params = {
				CPU: cpuRatio,
				MBD: mbdRatio,
				LCD: lceRatio
    	};

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

			    			GochigoAlert("가격 비율이 변경되었습니다.", false, "dangol365 ERP");
			    			fnInitNtbPriceRatio();
			    		}
			    	});
    			}
    		},
    		{
    			text: '취소'
    		}],
    		minWidth : 200,
    		title: "dangol365 ERP",
    	    content: "가격 비율을 변경하시겠습니까?"
    	}).data("kendoConfirm").open();
    	//끝지점
	}

    </script>

</head>

<body onunload="Close_Event();">

	<div id="content" data-role="splitter" class="k-widget k-splitter content">

		<div class="header_title">
			<span class="pagetitle"><span class="header-title30"></span> 노트북 가격 비율 </span>
		</div>

		<div id="ntb-price_ratio_btns" class="grid_btns" style="width: 100%">
			<button id="ntb-price_ratio_close_btn" type="button" onclick="fnClose()" class="k-button" style="float: right;">닫기</button>
<!-- 			<button id="ntb-price_ratio_add_btn" type="button" onclick="fnAdd()" class="k-button" style="float: right;">비율 변경</button> -->

		</div>

    <fieldset class="fieldSet">

		<div >

			CPU : <input id="price_ratio_cpu" placeholder="0.0%" style="width:15%; height: 25px; display: inline-block" />
			MBD: <input id="price_ratio_mbd" placeholder="0.0%" style="width:15%; height: 25px; display: inline-block" />
			LCD: <input id="price_ratio_lcd" placeholder="0.0%" style="width:15%; height: 25px; display: inline-block" />
			<button id="ntb-price_ratio_add_btn" type="button" onclick="fnAdd()" class="k-button" style="float: right; margin-right:32px;">비율 변경</button>


		</div>

		<div class="info" style="width: 90%; float: none; display: inline-block">

			<table id="tbl_ntb-price-ratio" class="table_default">

				<colgroup>
				 	<col width="7%">
                    <col width="20%">
                    <col width="20%">
                    <col width="20%">
                    <col width="13%">
                    <col width="20%">
				</colgroup>

				<thead>
				<tr>
					<td class="col-header-title">No</td>
					<td class="col-header-title">CPU</td>
					<td class="col-header-title">MBD</td>
					<td class="col-header-title">LCD</td>
                    <td class="col-header-title">생성자</td>
                    <td class="col-header-title">생성일자</td>
				</tr>
				</thead>
			</table>

			<div class="scrollable-div">
				<table id="tbl_ntb-price-ratio_data" class="stripe table_scroll">
					<colgroup>
						<col width="7%">
	                    <col width="20%">
	                    <col width="20%">
	                    <col width="20%">
	                    <col width="13%">
	                    <col width="18%">
					</colgroup>
					<tbody class="ntb_price_ratio_data">
						</tbody>
				</table>
			</div>
		</div>
	</fieldset>

	</div>

</body>

