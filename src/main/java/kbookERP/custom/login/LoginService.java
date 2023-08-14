package kbookERP.custom.login;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kbookERP.custom.Function.Function;

/**
 * 사용자 서비스
 */
@Service
public class LoginService {
	private static final Logger logger = LoggerFactory.getLogger(LoginService.class);

//	@Autowired
//	private MailService mailService;
//
//	@Autowired
//	private CommonService commonService;

	@Autowired
	private LoginMapper loginMapper;

	public Map<String, Object> login(Map<String,Object> params) {

		Map<String, Object> userMap = new HashMap<>();
		Map<String,Object> resultMap = new HashMap<>();
		Map<String, Object> newParams = new HashMap<>();

		try{

		String userId = params.get("USER_ID").toString();

		newParams.put("USER_ID", userId);
		userMap = loginMapper.getUserInfo(newParams);

		if(userMap == null) {
			resultMap.put("MSG", "존재하지 않는 ID입니다.");
        	resultMap.put("SUCCESS", false);
        	return resultMap;
		}
		else {

			System.out.println("userMap = "+userMap);

			String passwd = params.get("PASSWD").toString();
			String dbPasswd = userMap.get("PASS_WD").toString();
			String encdbPasswd  = Function.Password(userId, dbPasswd);

//			String hash = Function.HashSHA256(dbPasswd);
//			String sha = Function.EncryptionSHA256(dbPasswd);
//			String result = Function.Password(userId, dbPasswd);


	        if(passwd.equals(encdbPasswd)){

//	        	List<Map<String, Object>> listUserMap = new ArrayList<Map<String, Object>>();

//	        	listUserMap = loginMapper.getUserInfoList(params);

	        	resultMap.put("USER_NM", userMap.get("USER_NAME"));
	        	resultMap.put("SUCCESS", true);
//        		resultMap.put("DATA", listUserMap);
	            return resultMap;
        	}else {
    			resultMap.put("MSG", "아이디 또는 비밀번호가 일치하지 않습니다.");
    			resultMap.put("SUCCESS", false);
    			return resultMap;
            }
		}

		}
		catch (Exception ex){
			resultMap.put("SUCCESS", false);
			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
			resultMap.put("ERROR", ex.getMessage());
			return resultMap;
		}
	}


//	public Map<String, Object> userInst(Map<String,Object> params){
//		Map<String, Object> userParams = new HashMap<>();
//		Map<String, Object> reMap = new HashMap<>();
//
//		String USER_ID = params.get("USER_ID").toString();	// 사용자ID
//		String EMAIL = params.get("EMAIL").toString();
//		String USER_TYPE_CD = params.get("USER_TYPE_CD").toString();	// 사용자구분 (A:관리자, U:user, E:external)
//
//		if(!StringUtils.isEmpty(USER_ID)) {
//			userParams.put("USER_ID", USER_ID);
//			PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
//			//String _encPw = passwordEncoder.encode(params.get("PW").toString()+USER_ID);
//			//userParams.put("PASSWD", ShaEncrypt.encode(params.get("PW").toString(), USER_ID));
//			userParams.put("PASSWD", passwordEncoder.encode(params.get("PW").toString()+USER_ID));
//
//			userParams.put("USER_NM", params.containsKey("USER_NM") ? params.get("USER_NM").toString() : "");
//			userParams.put("USER_TYPE_CD", USER_TYPE_CD);
//			userParams.put("STATE_CD", 'S');
//			userParams.put("COMPANY_CD", "LT");
//			userParams.put("DEPT_CD", params.containsKey("DEPT_CD") ? params.get("DEPT_CD").toString() : "");
//			userParams.put("EMAIL", EMAIL);
//			userParams.put("MOBILE", params.get("MOBILE").toString());
//			userParams.put("TEL", params.get("TEL").toString());
//			userParams.put("RECOMMENDER_ID", params.containsKey("RECOMMENDER_ID") ?  params.get("RECOMMENDER_ID").toString() : "");
//			userParams.put("POSITION_NM", params.containsKey("POSITION") ?  params.get("POSITION").toString() : "");
//			userParams.put("FAX", params.containsKey("FAX") ?  params.get("FAX").toString() : "");
//
//			userParams.put("COMPANY_ID", params.containsKey("COMPANY_ID") ?  params.get("COMPANY_ID").toString() : null);
//			userParams.put("COMPANY_NM", params.containsKey("COMPANY_NM") ?  params.get("COMPANY_NM").toString() : "");
//
//			// 사용자 정보 등록
//			memberMapper.insertUser(userParams);
//
//			int result = memberMapper.idCheck(userParams);
//
//			if (result > 0) {
//				reMap.put("success", true);
//				reMap.put("MSG", "회원가입 정보가 정상 등록되었습니다.\n5초 뒤 로그인페이지로 이동합니다.");
//			} else {
//				reMap.put("success", false);
//				reMap.put("MSG", "회원가입 기능에 문제가 발생했습니다.\n다시 한번 시도해 보시고 계속 문제가 발생하면 관리자에게 문의 바랍니다.");
//			}
//		}
//		else {
//			reMap.put("success", false);
//			reMap.put("MSG", "회원가입 기능에 문제가 발생했습니다.관리자에게 문의 바랍니다.");
//		}
//
//		return reMap;
//	}
//
//	public Map<String, Object> findIdProc(Map<String,Object> params) {
//		Map<String, Object> resultMap = new HashMap<>();
//
//		resultMap = memberMapper.findIdProc(params);
//
//		return resultMap;
//	}
//
//
//	public int findPassWdProc(Map<String,Object> params) {
//		int result = -1;
//
//		result = memberMapper.findPassWdProc(params);
//
//		return result;
//	}
//
//	public Map<String, Object> resetPasswdProc(Map<String,Object> params) {
//		Map<String, Object> userParams = new HashMap<>();
//		Map<String, Object> reMap = new HashMap<>();
//		Map<String, Object> passWdMap = new HashMap<>();
//
//		String USER_ID = params.get("USER_ID").toString();	// 사용자ID
//		String EMAIL = params.get("EMAIL").toString();
//
//		if(!StringUtils.isEmpty(USER_ID)) {
//			userParams.put("USER_ID", USER_ID);
//			userParams.put("EMAIL", EMAIL);
//
//			PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
//			userParams.put("PASSWD", passwordEncoder.encode(params.get("PW").toString()+USER_ID));
//
//
//			memberMapper.resetPasswdProc(userParams);
//			passWdMap = memberMapper.getPasswdProc(userParams);
//
//			if (passWdMap.get("PASSWD").toString().equals(userParams.get("PASSWD").toString())) {
//				reMap.put("success", true);
//				reMap.put("MSG", "비밀번호가 변경되었습니다.");
//			} else {
//				reMap.put("success", false);
//				reMap.put("MSG", "비밀 번호 변경 기능에 문제가 발생했습니다.\n다시 한번 시도해 보시고 계속 문제가 발생하면 관리자에게 문의 바랍니다.");
//			}
//		}
//		else
//		{
//			reMap.put("success", false);
//			reMap.put("MSG", "아이디 또는 이메일 정보가 입력되지 않았습니다. \n 다시 한번 시도해 보시고 계속 문제가 발생하면 관리자에게 문의 바랍니다.");
//		}
//
//		return reMap;
//	}
//
//
//	public Map<String, Object> loginCheckFromExternalSystem(Map<String,Object> params) {
//
//		String userId = params.get("USER_ID").toString();
//		Map<String, Object> sqlMap = new HashMap<>();
//		Map<String,Object> resultMap = new HashMap<>();
//
//		sqlMap = memberMapper.getPasswdProcFromExternalSystem(params);
//
//		if(sqlMap == null) {
//			resultMap.put("MSG", "존재하지 않는 ID입니다.");
//        	resultMap.put("SUCCESS", false);
//        	return resultMap;
//		}
//
//		PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
//
//        if(passwordEncoder.matches(params.get("PASSWD").toString()+userId, sqlMap.get("PASSWD").toString())){
//
//        	sqlMap = memberMapper.getUserInfoFromExternalSystem(params);
//
//        	String userNm = sqlMap.get("USER_NM").toString();
//        	String stateCd = sqlMap.get("STATE_CD").toString();
//
//        	if(StringUtils.isEmpty(stateCd)) {
//        		resultMap.put("MSG", "승인되지 않은 사용자입니다.");
//            	resultMap.put("SUCCESS", false);
//        	}else if(stateCd.equals("D")) {
//        		resultMap.put("MSG", "회원 탈퇴한 사용자입니다.");
//            	resultMap.put("SUCCESS", false);
//        	}else if(stateCd.equals("L")) {
//        		resultMap.put("MSG", "잠금상태입니다. 먼저 홈페이지에서 로그인 해 주세요.");
//            	resultMap.put("SUCCESS", false);
//        	}else if(stateCd.equals("S")) {
//        		resultMap.put("MSG", "승인대기상태입니다. 관리자에게 승인요청하세요.");
//            	resultMap.put("SUCCESS", false);
//        	}else {
//
//        		 if(StringUtils.isNotBlank(userNm)){
//                 	resultMap.put("USER_NM", sqlMap.get("USER_NM").toString());
//        		 }
//                 else {
//                 	resultMap.put("USER_NM", userId);
//                 }
//
//        		 resultMap.put("COMPANY_ID", Util.getLong(sqlMap.get("COMPANY_ID"), -1));
//        		 resultMap.put("USER_TYPE", sqlMap.get("USER_TYPE_CD").toString());
//        		 resultMap.put("TEAM_CD", sqlMap.get("TEAM_CD").toString());
//        		 resultMap.put("POSITION", sqlMap.get("POSITION").toString());
//        		 resultMap.put("MOBILE", sqlMap.get("MOBILE"));
//
//        		 resultMap.put("USER_ID", userId);
//        		 resultMap.put("MSG", "로그인 되었습니다.");
//        		 resultMap.put("SUCCESS", true);
//
//        	}
//
//            return resultMap;
//		}else {
//			resultMap.put("MSG", "아이디 또는 비밀번호가 일치하지 않습니다.");
//			resultMap.put("SUCCESS", false);
//			return resultMap;
//        }
//	}
//
//	public Map<String, Object> login(Map<String,Object> params) {
//
//		String userId = params.get("LOGIN_ID").toString();
//		Map<String, Object> sqlMap = new HashMap<>();
//		Map<String,Object> resultMap = new HashMap<>();
//		Map<String, Object> newParams = new HashMap<>();
//
//		newParams.put("USER_ID", userId);
//		sqlMap = memberMapper.getPasswdProcFromExternalSystem(newParams);
//
//		PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
//
//        if(passwordEncoder.matches(params.get("PASSWD").toString()+userId, sqlMap.get("PASSWD").toString())){
//
//        	sqlMap = memberMapper.getUserInfoFromExternalSystem(newParams);
//
//        	String userNm = sqlMap.get("USER_NM").toString();
//        	String stateCd = sqlMap.get("STATE_CD").toString();
//
//        	if(StringUtils.isEmpty(stateCd)) {
//        		resultMap.put("MSG", "승인되지 않은 사용자입니다.");
//            	resultMap.put("RESULT", false);
//        	}else if(stateCd.equals("D")) {
//        		resultMap.put("MSG", "회원 탈퇴한 사용자입니다.");
//            	resultMap.put("RESULT", false);
//        	}else if(stateCd.equals("L")) {
//        		resultMap.put("MSG", "잠금상태입니다. 먼저 홈페이지에서 로그인해 주세요.");
//            	resultMap.put("RESULT", false);
//        	}else if(stateCd.equals("S")) {
//        		resultMap.put("MSG", "승인대기상태입니다. 관리자에게 승인요청하세요.");
//            	resultMap.put("RESULT", false);
//        	}else {
//
//        		 if(StringUtils.isNotBlank(userNm))
//                 	resultMap.put("USER_NM", sqlMap.get("USER_NM").toString());
//                 else
//                 	resultMap.put("USER_NM", userId);
//
//        		 resultMap.put("USER_ID", userId);
//        		 resultMap.put("MSG", "로그인 되었습니다.");
//        		 resultMap.put("RESULT", true);
//
//        	}
//
//            return resultMap;
//		}else {
//			resultMap.put("MSG", "아이디 또는 비밀번호가 일치하지 않습니다.");
//			resultMap.put("RESULT", false);
//			return resultMap;
//        }
//	}
//
//
//
//
//
//
//
//
//	/*
//	 * 가입 승인 메일 내용
//	 */
////	public String makeConetent(UMap userMap) throws GochigoException {
////		String EMAIL = "";
////
////		try {
////			EMAIL = AES256Cipher.AES_Encode(userMap.getStr("LOGIN_ID")); // 이메일 암호화
////			EMAIL = URLEncoder.encode(EMAIL, "UTF-8");	// '+'기호등..문자변환을 위한 URLEncoder
////		} catch (InvalidKeyException e) {
////			e.printStackTrace();
////			throw new GochigoException(e.toString());
////		} catch (UnsupportedEncodingException e) {
////			e.printStackTrace();
////			throw new GochigoException(e.toString());
////		} catch (NoSuchAlgorithmException e) {
////			e.printStackTrace();
////			throw new GochigoException(e.toString());
////		} catch (NoSuchPaddingException e) {
////			e.printStackTrace();
////			throw new GochigoException(e.toString());
////		} catch (InvalidAlgorithmParameterException e) {
////			e.printStackTrace();
////			throw new GochigoException(e.toString());
////		} catch (IllegalBlockSizeException e) {
////			e.printStackTrace();
////			throw new GochigoException(e.toString());
////		} catch (BadPaddingException e) {
////			e.printStackTrace();
////			throw new GochigoException(e.toString());
////		}
////
////		String body = "";
////		body += "        	<div style='color: #383838; line-height: 18px;'>";
////		body += "            	<span style='color: blue; font-weight: 500;'>"+userMap.getStr("USER_NM")+"</span>님, 안녕하세요!<br/>";
////		body += "				고객님께서 이메일(ID) (<span style='color: #383838;'>"+userMap.getStr("LOGIN_ID")+"</span>)로 회원가입을 신청하셨습니다.<br/>";
////		body += "				아래 링크를 클릭하셔서 진행을 완료하시기 바랍니다.";
////		body += "			</div>";
////		body += "			<div style='margin: 30px 0; padding-left: 15px; font-size:18px;'>";
////		body += "				<a style='color: #589bc6; text-decoration: none;' target='_blank' href='"+DOMAIN_URL+"system/userApprove.do?E="+EMAIL+"&T="+userMap.getStr("MAIL_TOKEN")+"'>&gt;&gt; 회원가입 확인 &lt;&lt;</a>";
////		body += "			</div>";
////		return mailService.makeDefaultContent("회원가입 확인", body);
////	}
////
////	/*
////	 * 임시 비밀번호 발송
////	 */
////	public String makeConetentPassword(UMap userMap) throws GochigoException {
////		String PW = userMap.getStr("passwd");
////		String body = "";
////		body += "        	<div style='color: #383838; line-height: 18px;'>";
////		body += "            	<span style='color: blue; font-weight: 500;'>"+userMap.getStr("USER_NM")+"</span>님, 안녕하세요!<br/>";
////		body += "				고객님께서 이메일(ID) (<span style='color: #383838;'>"+userMap.getStr("LOGIN_ID")+"</span>)로 비밀번호 찾기를 신청하셨습니다.<br/>";
////		body += "				아래 링크를 클릭하셔서 임시로 발급받은 비밀번호로 로그인 바랍니다.";
////		body += "			</div>";
////		body += "			<div style='margin: 30px 0; padding-left: 15px; font-size:14px; color: red'>";
////		body += "				[임시 비밀번호] "+PW;
////		body += "			</div>";
////		body += "			<div style='margin: 30px 0; padding-left: 15px; font-size:18px;'>";
////		body += "				<a style='color: #589bc6; text-decoration: none;' target='_blank' href='"+DOMAIN_URL+"system/login.do'>&gt;&gt; 로그인 페이지 이동  &lt;&lt;</a>";
////		body += "			</div>";
////		return mailService.makeDefaultContent("비밀번호 발급", body);
////	}
//
////	/*
////	 * 승인 토큰 갱신
////	 */
////	public int updateApproveToken(UMap userMap) {
////		int result = userMapper.updateUserApproveToken(userMap);
////		return result;
////	}
////
////	/*
////	 * 승인 완료
////	 */
////	public int updateUserApprove(UMap userMap) {
////		int result = userMapper.updateUserApprove(userMap);
////		return result;
////	}
////
////	public boolean isExistUser(UMap params) {
////		int userCnt = userMapper.selectUserCnt(params);
////		if(userCnt > 0)
////			return true;
////		else
////			return false;
////	}
//
//	/*
//	 * 정보 숨김
//	 */
//	public String getStrInfoHide(String str) {
//		String reStr = "";
//		if(str.contains("@")) {
//			int index = str.indexOf("@");
//			reStr = str.substring(0, index) + "*****";
//		} else {
//			reStr = str;
//		}
//		return reStr;
//	}
//
//	/*
//	 * 이메일 찾기 정보
//	 */
//	public String getEMailInfoHide(String str) {
//		String reStr = "";
//		if(str.contains("@")) {
//			int index = str.indexOf("@");
//			reStr = str.substring(0, 1) + "*****" + str.substring(index);
//		} else {
//			reStr = str;
//		}
//		return reStr;
//	}
//
//	/*
//	 * 삭제 여부 체크
//	 */
//	public String userDeleteCheck(UMap params) {
//		params.put("USER_ID", params.getStr("S_USER_ID"));
//		UMap checkMap = null;//userMapper.selectUserDeleteCheck(params);
//		String DEL_CHECK = "NO";
//		String USER_TYPE_CD = checkMap.getStr("USER_TYPE_CD");	// 사용자 구분
//		int MATRON_CNT = checkMap.getInt("MATRON_CNT");	// 담당 수간호사로 선택한 사용자 개수
//		if ("A".equals(USER_TYPE_CD)) {
//			// 관리자라 삭제 안됨
//			DEL_CHECK = "A";
//		} else if("M".equals(USER_TYPE_CD)) {
//			// 수간호사
//			if(MATRON_CNT <= 1) {
//				// 담당 수간호사 (본인) 포함하여 1명이면 삭제 가능
//				DEL_CHECK = "M1";
//			} else {
//				// 같은 병원 간호사가 2명 이상이면 수간호사 권한 이양이 가능하기때문에 권한 이양처리를 권하고 삭제처리
//				DEL_CHECK = "M2";
//			}
//		} else if("N".equals(USER_TYPE_CD)) {
//			// 간호사
//			DEL_CHECK = "N";
//		}
//		else if("S".equals(USER_TYPE_CD)) {
//			// 일반인
//			DEL_CHECK = "S";
//		}
//		else {
//			DEL_CHECK = "X";
//		}
//
//		return DEL_CHECK;
//	}
//
//
//
//
////	/*
////	 * 일반 회원의 회원 삭제
////	 */
////	public  int userOrdinaryDel(UMap params) throws Exception {
////		int rtnVal = 0;
////		try {
////
////			rtnVal += userMapper.updateUserState(params);//회원 상태 -->'D', 사용여부 --> 'N'
////
////		} catch (Exception e) {
////			params.put("success", false);
////			params.put("errMsg", e.getMessage());
////			return 0;
////		}
////
////		return rtnVal;
////	}
//
//	/*
//	 * 세션에 사용자 정보 변경 (UMap Class에서 정의)
//	 */
//	public void setSessionUserInfo(HttpServletRequest request, UMap userMap) {
//		request.getSession().setAttribute(this.getSessionName(), userMap);
//	}


}
