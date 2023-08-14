<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>${title}</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta charset="utf-8"/>

<link rel="stylesheet" type="text/css" href="/codebase/kendo/css/kendo.common.min.css"/>
<link rel="stylesheet" type="text/css" href="/codebase/css/kendo.custom.css"/>
<link rel="stylesheet" type="text/css" href="/codebase/style.css"/>
<style>
	.k-spreadsheet-action-bar {
		display: none !important;
	}
</style>
<script src="/js/jquery-1.12.4.js"></script>
<script src="/codebase/kendo/kendo.all.min.js"></script>
<script src="/codebase/kendo/cultures/kendo.culture.ko-KR.min.js"></script>
<script src="/codebase/common.js"></script>
</head>
<body>
	<div id="spreadsheet" style="width: 100%;"></div>
	<script>
		$("#spreadsheet").kendoSpreadsheet({
			change: function(e) {
				var range = e.range;
	            var topLeft = range.topLeft();
	
	            if (topLeft.row >= 0 || topLeft.col > 0) {
					var value = range.value();
					if(value === 'D') {
						range.color('#5375fd').background('#ffdfdf').bold(true);			
					} else if(value === 'E') {
						range.color('#ff5c26').background('#ffdfdf');
					} else if(value === 'N') {
						range.color('#525252').background('#ffdfdf');
					} else if(value === 'O') {
						range.color('#66cc66').background('#ffdfdf');
					}
				}          
			},
		    columns: 5,
		    rows: 10,
		    sheetsbar: false,
		    toolbar: false,
		    excel: {
		        proxyURL: "https://demos.telerik.com/kendo-ui/service/export"
		    },
		    sheets: [{
		        columns: [{
		            width: 100
		        },{
		            width: 100
		        }],
		        rows: [{
					cells:makeData('박초롱')
		        }, 
		        {
					cells: makeData('홍설희')
		        }, 
		        {
		        	cells: makeData('이영미')
		        }]
		    }]
		});
		
		function makeData(name) {
			var cells = [];
			var nameCell = { 
				value: name, bold: true 
        	};
			var cell = { 
        		value: 'E',
				background: "white",
				color: '#ff5c26',
				validation: {
					dataType: "list",
					showButton: true,
					comparerType: "list",
					from: '"D,E,N,O"',
					allowNulls: true,
					type: "reject"
				}
			};
			
			cells.push(nameCell);
			for(var i = 0; i < 10; i++) {
				cells.push(cell);
			}
			
			return cells;
		}
		
		function setColor(value) {
			var color = '';
			switch (value) {
			case 'E':
				color = '#ff5c26';
				break;
			case 'O':
				color = '#66cc66';
				break;
			case 'N':
				color = '#525252';
				break;
			case 'D':
				color = '#5375fd';
				break;
			default:
				break;
			}
			
			return color;
		} 
	</script>
</body>
</html>