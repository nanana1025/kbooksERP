<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"			uri="http://java.sun.com/jsp/jstl/core"%>


<%-- <c:url var="getConsignedComponentInfo"					value="/consigned/getConsignedComponentInfo.json" /> --%>
<%-- <c:url var="getCodeListCustom"					value="/common/getCodeListCustom.json" /> --%>
<%-- <c:url var="companyDelete"					value="/user/companyDelete.json" /> --%>
<%-- <c:url var="companyInsert"					value="/user/companyInsert.json" /> --%>
<%-- <c:url var="createReceipt"					value="/consigned/createReceipt.json"/> --%>
<%-- <c:url var="updateReceipt"					value="/consigned/updateReceipt.json"/> --%>
<%-- <c:url var="dataList"					value="/customDataList.json" /> --%>


<head>

	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  	<title>DANGOL365 ERP | 재고번호 업로드</title>

 	<link rel="stylesheet" type="text/css" href="/codebase/css/custom_style.css"/>
	<script src="/codebase/gochigo.kendo.ui.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css?family=Material+Icons|Material+Icons+Outlined|Material+Icons+Two+Tone|Material+Icons+Round|Material+Icons+Sharp" rel="stylesheet">

	<%-- 엑셀 처리 관련 라이브러리 --%>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.7.7/xlsx.core.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/xls/0.7.4-a/xls.core.min.js"></script>


	<style>

		body {
			margin: 0;
			padding: 0;
			overflow-x: hidden;
			overflow-y: hidden;
		}

		.header_title {
			padding-left: 30px;
		}

		.main {
			padding: 20px;
		}

		.input-file-wrapper {
			text-align: center;
		}

		input {
			display: block;
			margin-bottom: 10px;
		}

		label {
			padding: 30px;
			width: 90%;
			display: inline-block;
			border: 2px dashed #21a366;
			border-radius: 3px;
			background-color: white;
		}

		label:hover {
			background: rgba(230, 242, 229, 0.7);
			cursor: pointer;
		}

		label.is-dragover {
			background: rgba(230, 242, 229, 0.7);
		}

		#result {
			margin-top: 10px;
		}

		.file-info-wrapper {
			margin-top: 30px;
			padding: 10px;
			width: 80%;
		}

		.no-selected-data {
			color: red;
			margin: 30px;
		}

		.file-info-table-wrapper {
			text-align: center;
			width: 100%;
			margin: 30px;
		}

		.file-info-table {
			width: 100%;
		}

		table {
			width: 90%;
			border: 1px solid black;
		}

		thead {
			background-color: lightgray;
			font-size: 14px;
		}

		td {
			padding: 3px;
		}

        th {
            background-color: gray;
            font-style: normal;
            font-weight: normal;
            color: white;
            padding: 5px;
        }

    </style>

	<script type="text/javascript">

		var fileData = "";
		var applyCheckFlag_File = false;
		var applyCheckFlag_Header = false;
		var fileColumnSet;

		$(document).ready(function() {

// 			console.log("orderSheet.jsp");
// 			console.log("파일_업로드_임시.jsp");

			// 라벨 드래그 이벤트
            $('label').on('drag dragstart dragend dragover dragenter dragleave drop', function(event) {
                event.preventDefault();
                event.stopPropagation();
            })
			.on('dragover dragenter', function() {
				$(this).addClass('is-dragover');
			})
			.on('dragleave dragend drop', function() {
				$(this).removeClass('is-dragover');
			})
			.on('drop', function(event) {
				// No idea if this is the right way to do things
				$('input[type=file]').prop('files', event.originalEvent.dataTransfer.files);
				$('input[type=file]').trigger('change');
			});

            $('input[type=file]').on('change', function(event) {

                // $('#result span').text(event.target.files[0].name);

				// 테이블 초기화
				$(".input-file-list").children("tr").remove();

				$(".no-selected-data").hide();
				$(".file-info-table-wrapper").show();

                for(var i=0; i<event.target.files.length; i++) {

                	var row = "<tr>" +
								"<td>" + (i+1) + "</td>" +
								"<td>" + event.target.files[i].name + "</td>" +
								"<td>" + "확장자" + "</td>" +
								"<td>" + event.target.files[i].size + "</td>" +
								"<td>" + "<i class='k-icon k-i-eye' onclick='ExportToTable()'></i>" + "</td>" +
							"</tr>"

					$(".input-file-list").append(row);
				}

            });
            // 라벨 드래그 이벤트 끝

			// 파일 컬럼 초기화
			fileColumnSet = new Array();
//  			fileColumnSet = opener.fnGetColumnList();

		});

	</script>


	<script>
		function ExportToTable() {

			// var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.xlsx|.xls)$/;
			var regex = /(.xlsx|.xls)$/;

			/*Checks whether the file is a valid excel file*/
			if (regex.test($("#excel-file").val().toLowerCase())) {

				// 테이블 초기화
				$("#excel-table").find("tbody").remove();

				var xlsxflag = false; /* Flag for checking whether excel is .xls format or .xlsx format */

				if ($("#excel-file").val().toLowerCase().indexOf(".xlsx") > 0) {
					xlsxflag = true;
				}

				/*Checks whether the browser supports HTML5*/
				if (typeof (FileReader) != "undefined") {

					var reader = new FileReader();

					reader.onload = function (e) {

						var data = e.target.result;

						/*Converts the excel data in to object*/
						if (xlsxflag) {
							var workbook = XLSX.read(data, { type: 'binary' });
						}
						else {
							var workbook = XLS.read(data, { type: 'binary' });
						}

						/*Gets all the sheetnames of excel in to a variable*/
						var sheet_name_list = workbook.SheetNames;

						var cnt = 0; /*This is used for restricting the script to consider only first sheet of excel*/
						sheet_name_list.forEach(function (y) { /*Iterate through all sheets*/

							/*Convert the cell value to Json*/
							if (xlsxflag) {
								var exceljson = XLSX.utils.sheet_to_json(workbook.Sheets[y]);
							}
							else {
								var exceljson = XLS.utils.sheet_to_row_object_array(workbook.Sheets[y]);
							}
							if (exceljson.length > 0 && cnt == 0) {
								BindTable(exceljson, '#excel-table');
								cnt++;
							}
						});
						$('#excel-table').show();
						$(".view-table").show();
					}
					if (xlsxflag) {/*If excel file is .xlsx extension than creates a Array Buffer from excel*/
						reader.readAsArrayBuffer($("#excel-file")[0].files[0]);
					}
					else {
						reader.readAsBinaryString($("#excel-file")[0].files[0]);
					}
				}
				else {
					alert("Sorry! Your browser does not support HTML5!");
				}
			}
			else {
				alert("Please upload a valid Excel file!");
			}

		}

		function BindTable(jsondata, tableid) {/*Function used to convert the JSON array to Html Table*/

			var columns = BindTableHeader(jsondata, tableid); /*Gets all the column headings of Excel*/

			// 헤더 체크
			applyCheckFlag_Header = true;

// 			if(columns.length == fileColumnSet.length) {

// 				for(var i=0; i<fileColumnSet.length; i++) {

// 					var fileColumn = columns[0].replace(/\s+/g, "");
// 					var defaultColumn = fileColumnSet[0].replace(/\s+/g, "");

// 					if( !(fileColumn == defaultColumn) ) {
// 						GochigoAlert("파일의 형식이 잘못되었습니다. 컬럼명을 확인해주세요.");
// 						applyCheckFlag_Header = false;
// 						break;
// 					}
// 				}

// 			} else {
// 				GochigoAlert("파일의 형식이 잘못되었습니다. 컬럼 수를 확인해주세요.");
// 				applyCheckFlag_Header = false;
// 			}

			for (var i = 0; i < jsondata.length; i++) {
				var row$ = $('<tr/>');
				for (var colIndex = 0; colIndex < columns.length; colIndex++) {
					var cellValue = jsondata[i][columns[colIndex]];
					if (cellValue == null)
						cellValue = "";
					row$.append($('<td/>').html(cellValue));
				}
				$(tableid).append(row$);
			}
		}

		function BindTableHeader(jsondata, tableid) {/*Function used to get all column names from JSON and bind the html table header*/

			var columnSet = [];
			var headerTr$ = $('<tr/>');
			for (var i = 0; i < jsondata.length; i++) {
				var rowHash = jsondata[i];

				for (var key in rowHash) {
					if (rowHash.hasOwnProperty(key)) {
						if ($.inArray(key, columnSet) == -1) {/*Adding each unique column names to a variable array*/
							columnSet.push(key);
							headerTr$.append($('<th/>').html(key));
						}
					}
				}
			}

			$(tableid).append(headerTr$);

			return columnSet;
		}
	</script>

	<script>
		function fnClose() {
			window.close();
		}

		function fnFileUpload() {

			// 바코드 저장
			console.log("적용");

			// var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.xlsx|.xls)$/;
			var regex = /(.xlsx|.xls)$/;

			/*Checks whether the file is a valid excel file*/
			if (regex.test($("#excel-file").val().toLowerCase())) {

				var xlsxflag = false; /* Flag for checking whether excel is .xls format or .xlsx format */

				if ($("#excel-file").val().toLowerCase().indexOf(".xlsx") > 0) {
					xlsxflag = true;
				}

				/*Checks whether the browser supports HTML5*/
				if (typeof (FileReader) != "undefined") {

					var reader = new FileReader();

					reader.onload = function (e) {

						var data = e.target.result;

						/*Converts the excel data in to object*/
						if (xlsxflag) {
							var workbook = XLSX.read(data, { type: 'binary' });
						}
						else {
							var workbook = XLS.read(data, { type: 'binary' });
						}

						/*Gets all the sheetnames of excel in to a variable*/
						var sheet_name_list = workbook.SheetNames;

						var cnt = 0; /*This is used for restricting the script to consider only first sheet of excel*/
						sheet_name_list.forEach(function (y) { /*Iterate through all sheets*/

							/*Convert the cell value to Json*/
// 							if (xlsxflag) {
								var exceljson = XLSX.utils.sheet_to_json(workbook.Sheets[y]);

								if(applyCheckFlag_Header) {
									opener.fnAddInventoryFromFile(exceljson);

								}

// 							}
// 							else {
// 								var exceljson = XLS.utils.sheet_to_row_object_array(workbook.Sheets[y]);

// 								if(opener.fnAddFileUpdate(exceljson)) {
// 									opener.fnFileUpdate(exceljson);
// 								}

// 							}

							if (exceljson.length > 0 && cnt == 0) {
								exceljson.toString()
								// BindTable(exceljson, '#excel-table');
								cnt++;
							}

						});
						$('#excel-table').show();
						$(".view-table").show();
					}

					if (xlsxflag) {/*If excel file is .xlsx extension than creates a Array Buffer from excel*/
						reader.readAsArrayBuffer($("#excel-file")[0].files[0]);
					}
					else {
						reader.readAsBinaryString($("#excel-file")[0].files[0]);

					}
					applyCheckFlag_File = true;
				}
				else {
					alert("Sorry! Your browser does not support HTML5!");
				}
			}
			else {
				alert("Please upload a valid Excel file!");
			}

			if(applyCheckFlag_File && applyCheckFlag_Header) {
				window.close();
			}
		}
	</script>

</head>

<body>

	<div>


		<div class="header_title">파일 업로드</div>

		<div class="grid_btns" style="width: 100%; margin: 10px;">
			<button id="consigned_receipt_close_btn" type="button" onclick="fnClose()" class="k-button" style="float: right;">닫기</button>
			<button id="consigned_receipt_file_upload_btn" type="button" onclick="fnFileUpload()" class="k-button" style="float: right;">적용</button>
		</div>

		<div class="main">

			<div class="input-file-wrapper">

				<input type="file" id="excel-file" name="excel-file" style="display: none;"><br>

				<label for="excel-file">
					<i class="k-icon k-i-file-excel" style="font-size: 50px; color: #21a366; margin: 10px;"></i>
					<br>
					<span style="font-size: 16px; margin-bottom: 10px; color: darkgrey">
						<strong>파일 선택</strong> 또는 여기로 드래그하세요.
					</span>
				</label>

			</div>


            <div class="file-info-wrapper">

                <span style="font-size: 16px; margin-bottom: 20px;">
					<i class="k-icon k-i-info"></i> 선택된 파일 정보
				</span>

				<div class="no-selected-data">
					선택된 파일이 없습니다.
				</div>

            </div>

			<div style="text-align: center;">

				<div class="file-info-table-wrapper" style="display: none;">

					<table class="stripe">

						<colgroup>
							<col width="10%">
							<col width="40%">
							<col width="15%">
							<col width="20%">
							<col width="15%">
						</colgroup>

						<thead>
						<tr>
							<td>  # </td>
							<td> 파일명</td>
							<td> 확장자</td>
							<td> 파일크기(Byte) </td>
							<td> 데이터 보기 </td>
						</tr>
						</thead>

						<tbody class="input-file-list">
						</tbody>

					</table>

				</div>

				<div class="view-table" style="text-align: left; margin-left: 30px; display: none;">

					<span style="font-size: 14px; margin-bottom: 20px;">
						<i class="k-icon k-i-table"></i> 데이터 미리보기
					</span>

					<div class="scrollable-div" style="width: 93%; height: 300px;">
						<table id="excel-table" class="stripe" style="width: 93%; margin-top: 10px;">
						</table>
					</div>

				</div>

			</div>

		</div>

	</div>

</body>
