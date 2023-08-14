/*************************************************************************
	함수명: fnFillExcludeData
	설  명: DATA(CRUD) INSERT 창에서 제외처리되는 조회성 데이터를 조회해와서 자동으로 채워주는 함수
	인  자: key(데이터의 키, 여러개일 경우',' 구분자로 연결)
		 	value(키에 해당하는 값, 여러개일 경우',' 구분자로 연결)
	리  턴: 없음
	사용예:
	fnFillExcludeData('code_cls', $('code_cls').val());
***************************************************************************/
function fnFillExcludeData(key, value) {
	$.ajax({
        url : "/dataFill.json",
        data : { key: key, value : value },
        success : function(data, status) {
            console.log(data);
        },
        error: function(req, stat, error) {
        	if(req.responseJSON.message){
                GochigoAlert(req.responseJSON.message);
        	} else {
                GochigoAlert(req.responseText);
        	}

        }
    });
}