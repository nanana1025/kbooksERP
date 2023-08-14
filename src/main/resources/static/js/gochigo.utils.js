document.write("<script type='text/javascript' src='/js/gochigo.kendo.ui.js'><"+"/script>");


// utils

/*
 * E-Mail 서식 확인
 */
function fnEMailCheck(str) {
	var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
    if(!exptext.test(str)){
        //이메일 형식이 알파벳+숫자@알파벳+숫자.알파벳+숫자 형식이 아닐경우
    	GochigoAlert("이메일 형식이 올바르지 않습니다.");
        return false;
    };

	if(str.trim() == ""){
		GochigoAlert("이메일 형식이 올바르지 않습니다.");
		return false;
	}
	return true;
}

/*
 * 비밀번호 규칙 체크
 */
function fnPasswordCheck(pw) {
	var minLength = 8;
	var maxLength = 16;

	// 비밀번호 규칙 체크 (길이)
	if (pw.length < minLength || pw.length > maxLength) {
		GochigoAlert("비밀번호는 "+minLength+" ~ "+maxLength+" 자리수 입니다.");
		return false;
	}

	// 비밀번호 규칙 체크 (조합)
	if (!fnInValidPasswordComplexity(pw)) {
		GochigoAlert("비밀번호는 영문(대문자/소문자), 숫자, 특수문자의 조합으로 입력해야 합니다.");
		return false;
	}

	// 연속성 체크
	if (!fnContinuityPassword(pw)){
		return false;
	}

	return true;
}

/*
 * 비밀번호에 영문, 숫자, 특수문자가 각각 1개씩 포함하는지 체크
 */
function fnInValidPasswordComplexity(w) {
	var pattern1 = /[0-9]/;
    var pattern2 = /[a-zA-Z]/;
    var pattern3 = /[~!@\#$%<>^&*]/;     // 원하는 특수문자 추가 제거

    if(!pattern1.test(w) || !pattern2.test(w) || !pattern3.test(w)){
    	// 숫자, 영문(대,소문자), 특수문자가 포함 안됨.
    	return false;
    }

	return true;
}

/*
 * 비밀번호 연속성 체크
 */
function fnContinuityPassword(pw){
	var pw_passed = true;  // 추후 벨리데이션 처리시에 해당 인자값 확인을 위해

	var SamePass_0 = 0; //동일문자 카운트
	var SamePass_1 = 0; //연속성(+) 카운드
    var SamePass_2 = 0; //연속성(-) 카운드

    for(var i=0 ; i<pw.length ; i++) {
    	var chr_pass_0;
        var chr_pass_1;
		var chr_pass_2;
		var chr_pass_3;

		if(i >= 3) {
			chr_pass_0 = pw.charCodeAt(i-3);
			chr_pass_1 = pw.charCodeAt(i-2);
			chr_pass_2 = pw.charCodeAt(i-1);
			chr_pass_3 = pw.charCodeAt(i);

			//동일문자 카운트
			if((chr_pass_0 == chr_pass_1) && (chr_pass_1 == chr_pass_2) && (chr_pass_2 == chr_pass_3)) {
				SamePass_0++;
			} else {
				SamePass_0 = 0;
			}

			//연속성(+) 카운드
			if(chr_pass_0 - chr_pass_1 == 1 && chr_pass_1 - chr_pass_2 == 1 && chr_pass_2 - chr_pass_3 == 1) {
				SamePass_1++;
			} else {
				SamePass_1 = 0;
			}

			//연속성(-) 카운드
			if(chr_pass_0 - chr_pass_1 == -1 && chr_pass_1 - chr_pass_2 == -1 && chr_pass_2 - chr_pass_3 == -1) {
				SamePass_2++;
			} else {
				SamePass_2 = 0;
			}
		}

		if(SamePass_0 > 0) {
			GochigoAlert("비밀번호는 동일문자를 4자 이상 연속 입력할 수 없습니다.");
			pw_passed = false;
		}

		if(SamePass_1 > 0 || SamePass_2 > 0 ) {
			console.log('samepass_1 : ' + SamePass_1);
			console.log('samepass_2 : ' + SamePass_2);
			GochigoAlert("비밀번호는 영문, 숫자는 4자 이상 연속 입력할 수 없습니다.");
			pw_passed = false;
		}

    	if(!pw_passed) {
            return false;
            break;
		}
    }

	return true;
}

/*
 * Character -> HTML Entities 변환
 */
function escapeHtml(unsafe) {
    return unsafe
	    .replace(/&/g, "&amp;")
	    .replace(/</g, "&lt;")
	    .replace(/>/g, "&gt;")
	    .replace(/"/g, "&quot;")
	    .replace(/#/g, "&#35;")
	    .replace(/'/g, "&#39;")
	    .replace(/[(]/g, "&#40;")
	    .replace(/[)]/g, "&#41;");
}

/*
 * HTML Entities -> Character 변환
 *  - xss 필터링 처리된 값을 javascript 에서 이용시 사용
 */
function unescapeHtml(safe) {
    return safe
		.replace(/&amp;/g, "&")
	    .replace(/&lt;/g, "<")
	    .replace(/&gt;/g, ">")
	    .replace(/&quot;/g, "\"")
	    .replace(/&#35;/g, "#")
	    .replace(/&#39;/g, "'")
    	.replace(/&#40;/g, "(")
    	.replace(/&#41;/g, ")");
}

/*
 * rgba색을 hax값으로 리턴
 */
function rgba2hex(r, g, b, a) {
	  var hex = (r | 1 << 8).toString(16).slice(1) +
	  (g | 1 << 8).toString(16).slice(1) +
	  (b | 1 << 8).toString(16).slice(1) ;

	  // multiply before convert to HEX
	  a = (a | 1 << 8).toString(16).slice(1)
	  hex = "#" + hex + a;

	  return hex;
}
function rgb2hex(rgb) {
	var rgbExp = /^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/;
	var rgbaExp = /^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+(?:\.\d+)?))?\)$/;
	if(rgb.indexOf('rgba') > -1){
		 rgb = rgb.match(rgbaExp);
	} else {
		 rgb = rgb.match(rgbExp);
	}
	 return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
}
var hexDigits = new Array("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f");
function hex(x) {
	return isNaN(x) ? "00" : hexDigits[(x - x % 16) / 16] + hexDigits[x % 16];
}
/*
 * number는 숫자, length는 길이
 * 사용예 : fnNumberPad(12, 5)
 * 결과 : "00012"
 */
function fnNumberPad(number, length){
	number = number + "";
	return number.length >= length ? number : new Array(length - number.length + 1).join("0") + number;
}

/*************************************************************************
함수명: fnSetCookie(name, value, date) - 쿠키명, 값, 만료일
설  명: 쿠키값을 설정한다.
사용예: fnSetCookie("startDateInput", "2018-05-30", 7)
***************************************************************************/
function fnSetCookie(name, value, date) {
	var exdate = new Date();
	exdate.setDate(exdate.getDate() + date);
	var cookiePath = "/duty";
	var value = escape(value) + ((date == null) ? '' : '; expires=' + exdate.toUTCString()) + ";";
	value += "path=" + cookiePath + ";";
	document.cookie = name + '=' + value;
}

/*************************************************************************
함수명: fnGetCookie(name) - 쿠키명
설  명: 쿠키값을 가져온다.
사용예: fnGetCookie("startDateInput")
***************************************************************************/
function fnGetCookie(name) {
	var x, y;
	var val = document.cookie.split(';');

	for (var i = 0; i < val.length; i++) {
		x = val[i].substr(0, val[i].indexOf('='));
		y = val[i].substr(val[i].indexOf('=') + 1);
		x = x.replace(/^\s+|\s+$/g, ''); // 앞과 뒤의 공백 제거하기
		if (x == name) {
			return unescape(y); // unescape로 디코딩 후 값 리턴
		}
	}
}