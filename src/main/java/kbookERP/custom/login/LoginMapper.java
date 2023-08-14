package kbookERP.custom.login;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface LoginMapper {

	 //아이디 체크
	Map<String,Object> getUserInfo(Map<String,Object> param);

	public List<Map<String, Object>> getUserInfoList(Map<String, Object> params);

	Map<String,Object> temp(Map<String,Object> param);


//	// 사업자등록번호 중복 체크
//	Map<String,Object> companyNoCheck(Map<String,Object> param);
//
//	//이메일 중복 체크
//	int emailCheck(Map<String,Object> param);
//
//	//닉네임중복 체크
//	int nickNameCheck(Map<String,Object> param);
//
//	//회원 가입
//	void insertUser(Map<String,Object> param);
//
//	//아이디 찾기
//	Map<String,Object> findIdProc(Map<String,Object> param);
//
//	//비밀번호 찾기
//	int findPassWdProc(Map<String,Object> param);
//
//	//비밀번호 재 설정
//	void resetPasswdProc(Map<String,Object> param);
//
//	//비밀번호 가져오기
//	Map<String,Object> getPasswdProc(Map<String,Object> param);
//
//	//비밀번호 가져오기, 외부용
//	Map<String,Object> getPasswdProcFromExternalSystem(Map<String,Object> param);
//
//	//사용자 정보 가져오기, 외부용
//	Map<String,Object> getUserInfoFromExternalSystem(Map<String,Object> param);




	// 이메일 중복 체크
//	int emailCheck(Map<String,Object> param);
//	// 별명 중복 체크
//	int nickNameCheck(Map<String,Object> param);
//	// 회원가입
//	int insertUser(Map<String,Object> param);
//	// 회원정보수정
//	int updateUser(Map<String,Object> param);
//	// 수간호사등록
//	int insertMatronMst(Map<String,Object> param);
//	// 수간호사수정
//	int updateMatronMst(Map<String,Object> param);
//	// 시퀀스 조회
//	String selectSeq(Map<String,Object> param);
//
//	// 사용자 정보
//	Map<String,Object> selectUserMst(Map<String,Object> param);
//	// 사용자 정보
//	List<Map<String,Object>> selectUserMstList(Map<String,Object> param);
//	// 승인 토큰 갱신
//	int updateUserApproveToken(Map<String,Object> param);
//	// 사용자 승인 완료
//	int updateUserApprove(Map<String,Object> param);
//	// 비밀번호 틀린 횟수 증가
//	int updatePWWrongCnt(Map<String,Object> param);
//	// 사용자 상태 갱신
//	int updateStateCD(Map<String,Object> param);
//	// 수간호사 관련 사용자 정보 갱신
//	int updateUserStateRelatedMatron(Map<String,Object> param);
//	// 사용자 상태 변경 - 삭제상태(D), 사용여부(N)
//	int updateUserState(Map<String,Object> param);
//	// 비밀번호 틀린 횟수 초기화
//	int updatePWWrongCntInit(Map<String,Object> param);
//	// 사용자 정보 확인
//	int selectUserCnt(Map<String,Object> params);
//	// 수간호사 권한 이양 대상 목록 갯수
//	int selectUserAuthListCnt(Map<String,Object> param);
//	// 수간호사 권한 이양 대상 목록
//	List<Map<String,Object>> selectUserAuthList(Map<String,Object> param);
//	// 사용자 구분 변경
//	int updateUserAuth(Map<String,Object> param);
//	// 수간호사 사용자 ID변경
//	int updateMatronUserID(Map<String,Object> param);
//	// 비밀번호 변경
//	int updateUserPassword(Map<String,Object> param);
//	// 비밀번호 초기화
//	int updateUserPasswordInit(Map<String,Object> param);
//	// 탈퇴조건 조회
//	Map<String,Object> selectUserDeleteCheck(Map<String,Object> param);
//	// 회원계정 삭제
//	int updateUserDel(Map<String,Object> param);
}
