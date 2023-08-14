//document.write("<script type='text/javascript' src='/js/gochigo.kendo.ui.js'><"+"/script>");


//common
(function($){
    $.fn.extend({
        center: function () {
            return this.each(function() {
                // var top = ($(window).height() - $(this).outerHeight()) / 2;
                var top = 0;
                var left = ($(window).width() - $(this).outerWidth()) / 2;
                $(this).css({position:'absolute', margin:0, top: (top > 0 ? top : 0)+'px', left: (left > 0 ? left : 0)+'px'});
            });
        }
    });
})(jQuery);

//replaceAll prototype 선언
String.prototype.replaceAll = function(org, dest) {
    return this.split(org).join(dest);
}

function fnEscapeStr(str) {
	str = str.replace(/#/gi, "%23");
	str = str.replace(/%/gi, "%25");
	str = str.replace(/&/gi, "%26");
	str = str.replace(/\?/gi, "%3F");
	str = str.replace(/=/gi, "%3D");
	return str;
}

var getParamsAsObject = function (query) {

    query = query.substring(query.indexOf('?') + 1);

    var re = /([^&=]+)=?([^&]*)/g;
    var decodeRE = /\+/g;

    var decode = function (str) {
        return decodeURIComponent(str.replace(decodeRE, " "));
    };

    var params = {}, e;
    while (e = re.exec(query)) {
        var k = decode(e[1]), v = decode(e[2]);
        if (k.substring(k.length - 2) === '[]') {
            k = k.substring(0, k.length - 2);
            (params[k] || (params[k] = [])).push(v);
        }
        else params[k] = v;
    }

    var assign = function (obj, keyPath, value) {
        var lastKeyIndex = keyPath.length - 1;
        for (var i = 0; i < lastKeyIndex; ++i) {
            var key = keyPath[i];
            if (!(key in obj))
                obj[key] = {}
            obj = obj[key];
        }
        obj[keyPath[lastKeyIndex]] = value;
    }

    for (var prop in params) {
        var structure = prop.split('[');
        if (structure.length > 1) {
            var levels = [];
            structure.forEach(function (item, i) {
                var key = item.replace(/[?[\]\\ ]/g, '');
                levels.push(key);
            });
            assign(params, levels, params[prop]);
            delete(params[prop]);
        }
    }
    return params;
};

function appendElmToHtml(htmlId, atHtml){
	var html = $("#"+htmlId);
	$(atHtml).append(html);
}
function insertAfterElmToHtml(htmlId, atHtml){
	var html = $("#"+htmlId);
	$(html).insertAfter(atHtml);
}
function insertBeforeElmToHtml(htmlId, atHtml){
	var html = $("#"+htmlId);
	$(html).insertBefore(atHtml);
}

function fnObj(str) {
	return window[str];
}

String.prototype.format = function() {
	  a = this;
	  for (k in arguments) {
	    a = a.replace("{" + k + "}", arguments[k])
	  }
	  return a
}

//IE용 includes 함수 polyfill
if (!Array.prototype.includes) {
  Object.defineProperty(Array.prototype, 'includes', {
    value: function(searchElement, fromIndex) {

      if (this == null) {
        throw new TypeError('"this" is null or not defined');
      }

      // 1. Let O be ? ToObject(this value).
      var o = Object(this);

      // 2. Let len be ? ToLength(? Get(O, "length")).
      var len = o.length >>> 0;

      // 3. If len is 0, return false.
      if (len === 0) {
        return false;
      }

      // 4. Let n be ? ToInteger(fromIndex).
      //    (If fromIndex is undefined, this step produces the value 0.)
      var n = fromIndex | 0;

      // 5. If n ≥ 0, then
      //  a. Let k be n.
      // 6. Else n < 0,
      //  a. Let k be len + n.
      //  b. If k < 0, let k be 0.
      var k = Math.max(n >= 0 ? n : len - Math.abs(n), 0);

      function sameValueZero(x, y) {
        return x === y || (typeof x === 'number' && typeof y === 'number' && isNaN(x) && isNaN(y));
      }

      // 7. Repeat, while k < len
      while (k < len) {
        // a. Let elementK be the result of ? Get(O, ! ToString(k)).
        // b. If SameValueZero(searchElement, elementK) is true, return true.
        if (sameValueZero(o[k], searchElement)) {
          return true;
        }
        // c. Increase k by 1.
        k++;
      }

      // 8. Return false
      return false;
    }
  });
}

function removeChar(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 )
		return;
	else
		event.target.value = event.target.value.replace(/[^0-9]/g, "");
}


/*
 * SystemName 을 반환
 */
function fnGetSystemName() {
	if (opener != null) {
		try{
			var systemName = opener._systemName;
		} catch(error) {
			var systemName = "LEADERSTECH ERP";
		}
		return systemName;
	} else {
		if(typeof _systemName === 'undefined') return "LEADERSTECH ERP";
		else return _systemName;
	}
}

function fnOnlyNumberKeyPress(event) {
	var keyCode = (event.which) ? event.which : event.keyCode;
	if( keyCode == 8 || keyCode == 16 || (keyCode >= 48 && keyCode <= 57 ) || keyCode == 60 || (keyCode >=96 && keyCode <= 105) || keyCode == 189 || keyCode == 190 ){
		return;
	} else {
		return false;
	}
}

function removeChar(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 )
		return;
	else
		event.target.value = event.target.value.replace(/[^0-9]/g, "");
}

function windowOpenUrl(url, winName, intWidth, intHeight, isScroll, isResize, intLeft, intTop) {
	var xPos  = (document.body.clientWidth /2) - (intWidth / 2);
	xPos += window.screenLeft;
	var yPos  = (screen.availHeight / 2) - (intHeight / 2);
	var settings  ='width='     + intWidth + ',';
		settings +='height='    + intHeight + ',';
	    settings +='left='      +  xPos + ',';
	    settings +='top='       +  yPos + ',';
	    settings +='scrollbars='+ ( isScroll  || 'no') + ',';
	    settings +='resizable=' + ( isResize  || 'no');
	    //window.open(url, (winName||'popup'), settings).focus();

	var popup = window.open(url, (winName||'popup'), settings);
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
 * 비밀번호 연속성 체크 (invnetory.utils.js 로 통합처리 필요 @FIXME)
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

    	if(i >= 2) {
    		chr_pass_0 = pw.charCodeAt(i-2);
            chr_pass_1 = pw.charCodeAt(i-1);
            chr_pass_2 = pw.charCodeAt(i);

			//동일문자 카운트
			if((chr_pass_0 == chr_pass_1) && (chr_pass_1 == chr_pass_2)) {
            	SamePass_0++;
			} else {
				SamePass_0 = 0;
			}

			//연속성(+) 카운드
			if(chr_pass_0 - chr_pass_1 == 1 && chr_pass_1 - chr_pass_2 == 1) {
				SamePass_1++;
			} else {
				SamePass_1 = 0;
			}

			//연속성(-) 카운드
            if(chr_pass_0 - chr_pass_1 == -1 && chr_pass_1 - chr_pass_2 == -1) {
				SamePass_2++;
			} else {
				SamePass_2 = 0;
			}
    	}

    	if(SamePass_0 > 0) {
    		GochigoAlert("비밀번호는 동일문자를 3자 이상 연속 입력할 수 없습니다.");
			pw_passed = false;
		}

    	if(SamePass_1 > 0 || SamePass_2 > 0 ) {
    		GochigoAlert("비밀번호는 영문, 숫자는 3자 이상 연속 입력할 수 없습니다.");
			pw_passed = false;
		}

    	if(!pw_passed) {
            return false;
            break;
		}
    }
	return true;
}

function fnGetDate(sFmt, date, day) {
	var objDate = new Date();
	if(date) {
		objDate = date;
	}

	if(day) {
		objDate.setDate(objDate.getDate() + day);
	}
	var year = objDate.getFullYear();
	var month = fnLPad(objDate.getMonth() + 1, 2, '0');
	var day = fnLPad(objDate.getDate(), 2, '0');
	var hour = fnLPad(objDate.getHours(), 2, '0');
	var min = fnLPad(objDate.getMinutes(), 2, '0');
	var sec = fnLPad(objDate.getSeconds(), 2, '0');
	switch(sFmt) {
		case 'Ymd':
			return (year + month + day);
		case 'Ymd Hm':
			return (year + month + day + ' ' + hour + min);
		case 'Ymd Hms':
			return (year + month + day + ' ' + hour + min + sec);
		case 'Y-m-d':
			return (year + '-' + month + '-' + day);
		case 'Y-m-d H:m':
			return (year + '-' + month + '-' + day + ' ' + hour + ':' + min);
		case 'Y-m-d H:m:s':
			return (year + '-' + month + '-' + day + ' ' + hour + ':' + min + ':' + sec);
		case 'Y/m/d H:m:s':
			return (year + '/' + month + '/' + day + ' ' + hour + ':' + min + ':' + sec);
	}

	return (year + month + day + hour + min + sec);
}

function fnGetTime(sFmt, date, addHour) {
	var objDate = new Date();
	if(date) {
		objDate = date;
	}

	if(addHour) {
		objDate.setHours(objDate.getHours() + new Number(addHour));
	}
	var year = objDate.getFullYear();
	var month = fnLPad(objDate.getMonth() + 1, 2, '0');
	var day = fnLPad(objDate.getDate(), 2, '0');
	var hour = fnLPad(objDate.getHours(), 2, '0');
	var min = fnLPad(objDate.getMinutes(), 2, '0');
	var sec = fnLPad(objDate.getSeconds(), 2, '0');
	switch(sFmt) {
		case 'Ymd':
			return (year + month + day);
		case 'Ymd Hm':
			return (year + month + day + ' ' + hour + min);
		case 'Ymd Hms':
			return (year + month + day + ' ' + hour + min + sec);
		case 'Hm':
			return (hour + min);
		case 'H:m':
			return (hour + ':' + min);
		case 'Hms':
			return (hour + min + sec);
		case 'Y-m-d':
			return (year + '-' + month + '-' + day);
		case 'Y-m-d H:m':
			return (year + '-' + month + '-' + day + ' ' + hour + ':' + min);
		case 'Y-m-d H:m:s':
			return (year + '-' + month + '-' + day + ' ' + hour + ':' + min + ':' + sec);
		case 'Y/m/d H:m:s':
			return (year + '/' + month + '/' + day + ' ' + hour + ':' + min + ':' + sec);
	}

	return (year + month + day + hour + min + sec);
}

function fnLPad(n, digits, ch) {
	var zero = '';
	n = n.toString();

	if (n.length < digits) {
		for (var i=0; i < digits - n.length; i++) {
			zero += ch;
		}
	}
	return zero + n;
}

function htmlDecode(input) {
	var e = document.createElement('textarea');
	e.innerHTML = input;
	return e.childNodes.length === 0 ? "" : e.childNodes[0].nodeValue;
}

function getMaxByteStr(str, limit) {
    var bytes = 0;
    var returnStr;
    for (var i = 0; i < str.length; i++) {
        var ch = str.substr(i, 1).toUpperCase();
        var code = str.charCodeAt(i);
        code = parseInt(code);

        if ((ch < "0" || ch > "9") && (ch < "A" || ch > "Z") && ((code > 255) || (code < 0)))
            bytes += 2;
        else
            bytes++;

        if(bytes > limit) {
            returnStr = str.substr(0, i);
            break;
        }

        if(i == (str.length - 1))
            returnStr = str;
    }

    return returnStr;
}

function GochigoAlert(content, isClose, titleText) {
	if (titleText === undefined) {
		titleText = fnGetSystemName();
		//titleText = "LEADERSTECH ERP";
	}

	$("<div></div>").kendoAlert({
		buttonLayout: "stretched",
		actions: [{
			action: function(e){
				if(isClose){
					if(opener){
						self.close();
					}
				}
			}
		}],
		minWidth : 200,
		title: titleText,
        content: content === undefined ? '시스템 오류가 발생했습니다. 관리자에게 문의하세요.' : content
    }).data("kendoAlert").open();
}
