package kbookERP.custom.login;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 사용자 컨트롤러
 */
@Controller
@RequestMapping(value="/login")
public class LoginController {
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);


//	@Autowired
//	private CommonService commonService;
//
//	@Autowired
//	private LoginService loginService;

	@Autowired
	private LoginService loginService;

//	@Autowired
//	private UserService userService;

	/*@Value("${user.password.exp.month}")
	private String EXP_MONTH;	// 비밀번호 만기 개월

	@Value("${spring.mail.master}")
	private String MASTER_MAIL;	// 발신 메일 주소*/



    @PostMapping("/login.json")
    @ResponseBody
    public Map<String,Object> login(HttpServletRequest request, @RequestBody Map<String,Object> params) {

    	Map<String,Object> result = new HashMap<>();
    	result = loginService.login(params);

    	return result;

    }

//    @PostMapping("/createUser.json")
//    @ResponseBody
//    public Map<String,Object> createUser(HttpServletRequest request, @RequestBody Map<String,Object> params) {
//
//    	Map<String,Object> result = new HashMap<>();
//    	result = loginService.createUser(params);
//
//    	return result;
//
//    }



//
//	/*
//	 * 약관동의 화면
//	 */
//	@GetMapping(value = {"/useAgree.do", "/useAgree_mobile.do"})
//	public void useAgree(@RequestParam Map<String,Object> params, Model model) throws Exception {
//	}
//
//	/*
//	 * 회원가입 화면
//	 */
//	@GetMapping(value = {"/userInst.do", "/userInst_mobile.do"})
//	public void userInst(@RequestParam Map<String,Object> params, Model model) throws Exception {
//		model.addAttribute("AGREE3_YN", params.get("AGREE3_YN").toString());
//	}
//
//	/*
//	 * 아이디 중복 체크
//	 */
//	@PostMapping("/idCheckProc.json")
//	@ResponseBody
//	public Map<String,Object> idCheckProc(@RequestParam Map<String,Object> params, Model model) throws Exception {
//		int cnt = memberService.idCheck(params);
//		if(cnt > 0) {
//			params.put("ID_CHECK", false);
//		} else if(cnt < 0){
//			params.put("ERROR", true);
//			params.put("ID_CHECK", true);
//		} else {
//			params.put("ERROR", false);
//			params.put("ID_CHECK", true);
//		}
//
//		return params;
//	}
//
//	/*
//	 * 사업자 등록번호 중복 체크
//	 */
//	@PostMapping("/companyIdCheckProc.json")
//	@ResponseBody
//	public Map<String,Object> companyIdCheckProc(@RequestParam Map<String,Object> params, Model model) throws Exception {
//		Map<String, Object> result = memberService.companyIdCheck(params);
//		params.put("COMPANYID_CHECK", true);
//		params.put("ERROR", false);
//		params.put("COMPANY_ID", result.get("COMPANY_ID"));
//		params.put("COMPANY_NM", result.get("COMPANY_NM"));
//		return params;
//	}
//
//
//	/*
//	 * 이메일 중복 체크
//	 */
//	@PostMapping("/emailCheckProc.json")
//	@ResponseBody
//	public Map<String,Object> emailCheckProc(@RequestParam Map<String,Object> params, Model model) throws Exception {
//		int cnt = memberService.emailCheck(params);
//		if(cnt > 0) {
//			params.put("EMAIL_CHECK", false);
//		} else if(cnt < 0){
//			params.put("ERROR", true);
//			params.put("EMAIL_CHECK", true);
//		} else {
//			params.put("ERROR", false);
//			params.put("EMAIL_CHECK", true);
//		}
//
//		return params;
//	}
//
//	/*
//	 * 닉네임 중복 체크
//	 */
//	@PostMapping("/nickNameCheckProc.json")
//	@ResponseBody
//	public Map<String,Object> nickNameCheckProc(@RequestParam Map<String,Object> params, Model model) throws Exception {
//		int cnt = memberService.nickNameCheck(params);
//		if(cnt > 0) {
//			params.put("NICK_NM_CHECK", false);
//		} else if(cnt < 0){
//			params.put("ERROR", true);
//			params.put("NICK_NM_CHECK", true);
//		} else {
//			params.put("ERROR", false);
//			params.put("NICK_NM_CHECK", true);
//		}
//
//		return params;
//	}
//
//	/*
//	 * 회원 가입 처리
//	 */
//	@PostMapping("/userInstProc.json")
//	@ResponseBody
//	public Map<String,Object> userInstProc(HttpServletRequest req,@RequestParam Map<String,Object> params, Model model) throws Exception {
//		Map<String, Object> result = new HashMap<>();
//		if (params.containsKey("COMPANY_ID") && params.get("COMPANY_ID").equals("-1")) {
//			// 등록된 기업이 아니면 신규 등록함
//			Map<String, Object> companyMap = userService.companyInsert(req, params);
//			params.put("COMPANY_ID", companyMap.get("COMPANY_ID"));
//			Map<String, Object> companyMap2 = userService.companyUpdate(req, params);
//		}
//		result = memberService.userInst(params);
//
//		return result;
//	}
//
//	/*
//	 * 아이디 찾기
//	 */
//	@PostMapping("/findIdProc.json")
//	@ResponseBody
//	public Map<String,Object> findIdProc(@RequestParam Map<String,Object> params, Model model) throws Exception {
//		Map<String, Object> resultMap = memberService.findIdProc(params);
//
//
//		if(resultMap == null)
//		{
//			params.put("ERROR", false);
//			params.put("result", false);
//		}
//		else
//		{
//			if(!StringUtils.isEmpty(resultMap.get("USER_ID").toString())) {
//				params.put("result", true);
//				params.put("USER_ID", resultMap.get("USER_ID").toString());
//			}else {
//				params.put("ERROR", false);
//				params.put("result", false);
//			}
//		}
//
//		return params;
//	}
//
//	/*
//	 * 비밀번호 찾기
//	 */
//	@PostMapping("/findPassWdProc.json")
//	@ResponseBody
//	public Map<String,Object> findPassWdProc(@RequestParam Map<String,Object> params, Model model) throws Exception {
//
//		int cnt = memberService.findPassWdProc(params);
//
//		if(cnt > 0) {
//			params.put("result", true);
//		} else if(cnt < 0){
//			params.put("ERROR", true);
//			params.put("result", false);
//		} else {
//			params.put("ERROR", false);
//			params.put("result", false);
//		}
//
//		return params;
//	}
//
//	/*
//	 * 비밀번호 변경
//	 */
//	@PostMapping("/resetPasswdProc.json")
//	@ResponseBody
//	public Map<String,Object> resetPasswdProc(@RequestParam Map<String,Object> params, Model model) throws Exception {
//		Map<String, Object> result = new HashMap<>();
//		result = memberService.resetPasswdProc(params);
//		return result;
//	}



	/*
	 * 아이디 찾기
	 */
	/*@GetMapping(value = {"userFindIdView.do", "userFindIdView_mobile.do"})
	public void userFindIdView(@RequestParam Map<String,Object> params, Model model) throws Exception {
	}*/

	/*
	 * 아이디 찾기 처리
	 */
	/*@PostMapping("userFindIdViewProc.json")
	@ResponseBody
	public Map<String,Object> userFindIdViewProc(@RequestParam Map<String,Object> params, Model model) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> list = userMapper.selectUserMstList(params);
		List<Map<String,Object>> reList = new ArrayList<Map<String,Object>>();
		for(Map<String,Object> map : list) {
			Map<String,Object> reMap = new HashMap<String,Object>();
			reMap.put("LOGIN_ID", userService.getEMailInfoHide(map.get("LOGIN_ID").toString()));
			reList.add(reMap);
		}
		result.put("list", reList);
		return result;
	}*/

	/*
	 * 비밀번호 찾기
	 */
	/*@GetMapping( value= {"userPasswordFindView.do", "userPasswordFindView_mobile.do"})
	public void userPasswordFindView(@RequestParam Map<String,Object> params, Model model) throws Exception {
		model.addAttribute("EMAIL", params.get("EMAIL").toString());
	}*/

	/*
	 * 비밀번호 찾기 처리
	 */
	/*@PostMapping("userPasswordFindViewProc.json")
	@ResponseBody
	public Map<String,Object> userPasswordFindViewProc(@RequestParam Map<String,Object> params, Model model) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		params.put("LOGIN_ID", params.get("EMAIL").toString());
		Map<String,Object> userMap = userMapper.selectUserMst(params);
		boolean success = false;
		String MSG = "";
		if(userMap != null) {
			String EMAIL = userMap.get("LOGIN_ID").toString();
			String USER_ID = userMap.get("USER_ID").toString();
			String LOGIN_ID = userMap.get("LOGIN_ID").toString();
			String _PW = RandomStringUtils.randomAlphabetic(4) + RandomStringUtils.randomNumeric(4);

			userMap.put("passwd", ShaEncrypt.encode(_PW, USER_ID+LOGIN_ID));
			userMap.put("STATE_CD", "N");
			userMap.put("EXP_MONTH", EXP_MONTH);
			int cnt = userMapper.updateUserPasswordInit(userMap);
			if(cnt > 0) {
				try {
					userMap.put("passwd", _PW);
					//mailService.sendMail(MASTER_MAIL, EMAIL, "[AutoSchedule365] 임시 비밀번호 발송 메일입니다.", userService.makeConetentPassword(userMap));
					success = true;
					MSG = "임시 비밀번호를 메일로 발송했습니다.\n확인 후 로그인하시기바랍니다.";
				} catch (GochigoException e) {
					logger.debug("##############################################################");
					logger.debug("######################## << 메일 전송 실패 >> ########################");
					logger.debug("###############################################################");
					logger.debug(e.toString());
					success = false;
					MSG = "메일 전송 기능에 문제가 발생했습니다.\n다시 한번 시도해 보시고 계속 문제가 발생하면 게시판에 문의 바랍니다.";
				}
			} else {
				success = false;
				MSG = "비밀번호를 다시 초기화 하시기 바랍니다.";
			}
		} else {
			success = false;
			MSG = "사용자 정보가 존재하지 않습니다.";
		}

		result.put("success", success);
		result.put("MSG", MSG);
		return result;
	}*/

	/*
	 * 사용자 수정 화면
	 */
	/*@GetMapping(value = {"userUpdt.do", "userUpdt_mobile.do"})
	public void uesrUpdt(@RequestParam Map<String,Object> params, Model model) throws Exception {
		params.put("USER_ID", params.get("S_USER_ID").toString());
		Map<String,Object> userMap = userMapper.selectUserMst(params);
		model.addAttribute("view", userMap);
	}*/

	/*
	 * 사용자 수정 처리
	 */
	@PostMapping("userUpdtProc.json")
	@ResponseBody
	public Map<String,Object> uesrUpdtProc(@RequestParam Map<String,Object> params, Model model, HttpServletRequest request) throws Exception {
		/*
		 * 수간호사에서 사용자 구분 변동 X
		 * 간호사 -> 지인 가능 (간호사 승인이 되어있으면 간호사 승인 해제)
		 * 지인 -> 간호사 가능
		 */
		Map<String,Object> reMap = new HashMap<String,Object>();
		String USER_ID = params.get("USER_ID").toString();				// 사용자ID
		String USER_TYPE_CD = params.get("USER_TYPE_CD").toString();	// 사용자구분 (A:관리자, M:수간호사, N:간호사, S:지인)
		String ORG_USER_TYPE_CD = params.get("ORG_USER_TYPE_CD").toString();	// 사용자구분 (A:관리자, M:수간호사, N:간호사, S:지인)

		String APPROVE_YN = params.get("APPROVE_YN").toString();		// 승인여부

		//=============================== 간호사
		if ("N".equals(USER_TYPE_CD)) {
			if("S".equals(ORG_USER_TYPE_CD)) {
				// 간호사로 변경
				APPROVE_YN = "N";
			}
		}



		params.put("USER_ID", USER_ID);
		/*params.put("USER_TYPE_CD", USER_TYPE_CD);

		params.put("APPROVE_YN", APPROVE_YN);
		int result = userMapper.updateUser(params);

		if(result > 0) {
			// 수간호사면 수간호사 마스터 테이블 수정
			if("M".equals(USER_TYPE_CD)) {
				result = userMapper.updateMatronMst(params);
			}

			// 사용자 권한 변경 (Spring Security)
			Map<String,Object> userMap = userMapper.selectUserMst(params);
			//loginService.setUserAuth(userMap);
			if (result > 0) {
				// 성공 시 세션 값도 수정
				//userService.setSessionUserInfo(request, userMap);
				reMap.put("success", true);
				reMap.put("MSG", "회원정보가 수정되었습니다.");
			} else {
				reMap.put("success", false);
				reMap.put("MSG", "회원정보 수정 기능에 문제가 발생했습니다.\n다시 한번 시도해 보시고 계속 문제가 발생하면 게시판에 문의 바랍니다.");
			}
		} else {
			reMap.put("success", false);
			reMap.put("MSG", "회원정보 수정 기능에 문제가 발생했습니다.\n다시 한번 시도해 보시고 계속 문제가 발생하면 게시판에 문의 바랍니다.");
		}*/

		return reMap;
	}

	/*
	 * 회원탈퇴 화면
	 */
	@GetMapping("userDelt.do")
	public void userDelt(@RequestParam Map<String,Object> params, Model model) throws Exception {
		//model.addAttribute("DEL_CHECK", userService.userDeleteCheck(params));
	}

	/*
	 * 회원탈퇴 처리
	 */
	@PostMapping("userDeltProc.json")
	@ResponseBody
	public Map<String,Object> userDeltProc(@RequestParam Map<String,Object> params, Model model) throws Exception {
		Map<String,Object> result = new HashMap<String,Object>();
		/*String MSG = "회원정보가 존재하지 않습니다.\n다시 확인 바랍니다.";
		boolean success = false;
		String S_USER_ID = params.get("S_USER_ID");
		String _PW = params.getStr("PW");
		params.put("USER_ID", S_USER_ID);
		Map<String,Object> userMap = userMapper.selectUserMst(params);
		if(userMap != null) {
			String USER_ID = userMap.getStr("USER_ID");
			String LOGIN_ID = userMap.getStr("LOGIN_ID");
			String PW = ShaEncrypt.encode(_PW, USER_ID+LOGIN_ID);
			String passwd = userMap.getStr("passwd");
			String STATE_CD = userMap.getStr("STATE_CD");	// 사용자 상태
			int PW_WRONG_CNT = userMap.getInt("PW_WRONG_CNT");

			if("L".equals(STATE_CD)) {
				// 비밀번호 5회 오류 (잠김)
				success = true;
				MSG = "비밀번호 5회 이상 틀려서 사용자 계정이 잠겼습니다.\n비밀번호가 기억이 나지 않는 경우\n'비밀번호 찾기'기능을 이용해 주시기바랍니다.";
			} else if ("D".equals(STATE_CD)) {
				// 계정 삭제
				success = true;
				MSG = "이미 회원탈퇴한 회원입니다.";
			} else {
				if(passwd.equals(PW)) {
					userMapper.updatePWWrongCntInit(userMap);
					String DEL_CHECK = userService.userDeleteCheck(params);
						int cnt = 0;
						// 삭제
						if("A".equals(DEL_CHECK)) {//관리자
							success = false;
							MSG = "관리자는 회원탈퇴할 수 없습니다.";

						}
						else if("N".equals(DEL_CHECK)) {//간호사
							cnt += userService.NurseDel(userMap);

							if(cnt > 0) {
								success = true;
								MSG = "회원탈퇴가 정상적으로 처리되었습니다.";
							}
						}
						else if("S".equals(DEL_CHECK)) {//일반인
							cnt += userService.userOrdinaryDel(userMap);

							if(cnt > 0) {
								success = true;
								MSG = "회원탈퇴가 정상적으로 처리되었습니다.";
							}
						}
						else if( "M1".equals(DEL_CHECK)) {//혼자인 수간호사
							//cnt += userService.userMatronDel(userMap);// 중복처리로 주석처리
							cnt += userService.NurseDel(userMap);
							if(cnt > 0) {
								success = true;
								MSG = "회원탈퇴가 정상적으로 처리되었습니다.";
							}
						} else if("M2".equals(DEL_CHECK)) {	// 간호사가 있는 수간호사
							success = false;
							MSG = "간호사가 있는 수간호사는 권한이양 후 삭제할 수 있습니다.";
						} else { // 삭제 불가
							success = false;
							MSG = "회원탈퇴 기능에 문제가 발생했습니다.\n다시 한번 시도해 보시고 계속 문제가 발생하면 게시판에 문의 바랍니다.";
						}

				} else {
					if(PW_WRONG_CNT >= 5) {
						// 비밀번호 횟수 초과
						success = true;
						MSG = "비밀번호 5회 이상 틀려서 사용자 계정이 잠겼습니다.\n비밀번호가 기억이 나지 않는 경우\n'비밀번호 찾기'기능을 이용해 주시기바랍니다.";
						userMap.put("STATE_CD", "L");
						userMapper.updateStateCD(userMap);
					} else {
						success = false;
						MSG = "비밀번호가 틀렸습니다.("+(PW_WRONG_CNT+1)+")회";
						userMapper.updatePWWrongCnt(userMap);
					}
				}
			}
		}*/

		//result.put("success", success);
		//result.put("MSG", MSG);
		return result;
	}





}
