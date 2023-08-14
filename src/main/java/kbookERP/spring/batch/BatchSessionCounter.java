package kbookERP.spring.batch;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;

import kbookERP.util.Utils;


/**
 * <pre>
 *  배치작업에 대한 카운터 (주로 긴 시간이 소요되는 출력에 사용)
 *  BatchCounter 의 Session Scope 버전으로 각 세션별로 적용됨
 *
 * </pre>
 *
 *  @author  danlo
 *  @created 2016.08.23
 *  @version 1.0
 */
public class BatchSessionCounter implements BatchCounter, Serializable {
	private static final long serialVersionUID = -4077288519493781894L;
	private HttpSession ssn = null;
	private String jobName    = StringUtils.EMPTY;
	private Map<String,Object>   jobParam   = null;
	private int    totalCnt   = 0;
	private int    currCnt    = 0;
	private int    successCnt = 0;
	private int    failCnt    = 0;
	private boolean isCompleted = true;
	private boolean isWorking = false;
	private Map<String,Object>   beforeJobParam = null;
	public long   startTime = 0;

	private int arrayIndex = 0;	//배열 index
	private List<Map<String,Object>> arrayList = new ArrayList<Map<String,Object>>();

	public static final int ESTIMATION = -1;

	/**
	 * 카운터 최초 시작시 사용
	 * @param req
	 */
	public BatchSessionCounter(HttpServletRequest req) {
		ssn = req.getSession();
		isWorking = true;	// 처리중
		ssn.setAttribute("BatchSessionCounter", this);
	}

	/**
	 * 카운터 진행상황을 표시할 때 사용
	 *
	 * @param req
	 * @return
	 */
	public static BatchSessionCounter getInstance(HttpServletRequest req) {
		HttpSession ss = req.getSession();
		BatchSessionCounter bsc = (BatchSessionCounter)(ss.getAttribute("BatchSessionCounter"));
		if (bsc == null) {
			bsc = new BatchSessionCounter(req);
			bsc.end();
		}
		return bsc;
	}

	/**
	 * <pre>
	 * start를 호출하기 전까지 딜레이를 커버하기 위한 메서드
	 * start는 totalCnt가 필요하기 때문에 start를 호출하기 전 잠시 딜레이가 발생하는 경우가 있다(예: 파일 업로드 > 압축해제 > 파일정보 읽기)
	 * </pre>
	 *
	 */
	public boolean setReady(String jobName) {
		if(StringUtils.isNotEmpty(this.jobName)) {
			return false;
		}

		this.jobName     = jobName;
		this.isCompleted = false;
		this.totalCnt    = ESTIMATION;

		ssn.setAttribute("BatchSessionCounter", this);

		return true;
	}

	/**
	 * <pre>
	 * start를 호출하기 전까지 딜레이를 커버하기 위한 메서드
	 * start는 totalCnt가 필요하기 때문에 start를 호출하기 전 잠시 딜레이가 발생하는 경우가 있다(예: 파일 업로드 > 압축해제 > 파일정보 읽기)
	 * ArrayList에 담길 UMap의 내용은 [소제목  : subJobName, 분배받은 비율(%) : divRate]이다.
	 * </pre>
	 *
	 */
	public boolean setReady(String jobName, List<Map<String,Object>> array) {
		this.jobName     = jobName;
		this.isCompleted = false;
		this.totalCnt    = ESTIMATION;
		this.startTime   = 0;
		int accrueRate 	 = 0;
		if(array.size() > 0){
			for(int i = 0 ; i <  array.size(); i++){
				Map<String,Object> map = array.get(i);
				String nowDate = ""; 								//시작시간
				if(i == 0){
					nowDate = Utils.dateString(Utils.YMD_FROMAT_01);
				}else{
					accrueRate += (Integer)(array.get(i-1).get("divRate"));	//누적 비율
				}
				map.put("startTime", nowDate);
				map.put("endTime", "");
				map.put("accrueRate", accrueRate);
			}
		}

		this.arrayList	 = array;

		return true;
	}

	/**
	 * <pre>
	 * 작업시작
	 * </pre>
	 *
	 * @param jobName
	 * @param session
	 * @param totalCnt
	 * @return 다른작업이 진행중인 경우 false를 리턴한다.
	 */
	public boolean start(String jobName, Map<String,Object> jobParam, int totalCnt) {
		if(this.totalCnt != ESTIMATION && StringUtils.isNotEmpty(this.jobName)) {
			return false;
		}

		this.jobName  = jobName;
		this.jobParam = jobParam;
		this.totalCnt = totalCnt;
		this.isCompleted = false;
		this.startTime   = System.currentTimeMillis();

		this.jobParam.put("jobName", jobName);

		ssn.setAttribute("BatchSessionCounter", this);

		return true;
	}

	/**
	 * <pre>
	 * 건수 + 1
	 * </pre>
	 *
	 * @param isSuccess
	 */
	public void countUp(boolean isSuccess) {
		currCnt++;

		if (isSuccess) {
			successCnt++;
		} else {
			failCnt++;
		}

		ssn.setAttribute("BatchSessionCounter", this);
	}

	/**
	 * <pre>
	 * 반드시 호출해야함
	 * finally에 구현할 것
	 * </pre>
	 *
	 */
	public void end() {
		beforeJobParam = jobParam;

		jobName    = StringUtils.EMPTY;
		jobParam   = null;
		currCnt    = 0;
		totalCnt   = 0;
		successCnt = 0;
		failCnt    = 0;
		isCompleted = true;
		arrayIndex = 0;
		isWorking = false;

		ssn.setAttribute("BatchSessionCounter", this);
	}

	/**
	 * <pre>
	 * 현시점에 시작시간을 셋팅
	 * </pre>
	 *
	 */
	public void setStartTime() {
		setStartTime(0);
	}

	/**
	 * <pre>
	 * 현시점에 시작시간을 셋팅
	 * </pre>
	 *
	 */
	public void setStartTime(int idx) {
		if(idx == 0){
			Map<String,Object> map = this.arrayList.get(arrayIndex);
			if(map != null){
				map.put("startTime", Utils.dateString(Utils.YMD_FROMAT_01));
			}
		}else{
			Map<String,Object> map = this.arrayList.get(idx);
			if(map != null){
				map.put("startTime", Utils.dateString(Utils.YMD_FROMAT_01));
			}
		}
	}

	/**
	 * <pre>
	 * ArrayList에서 다음 index로 넘어감
	 * </pre>
	 *
	 */
	public void nextStep() {
		setEndTime();
		this.arrayIndex++;
	}

	/**
	 * <pre>
	 * 현시점에 종료시간을 셋팅
	 * </pre>
	 *
	 */
	public void setEndTime() {
		setEndTime(0);
	}

	/**
	 * <pre>
	 * 현시점에 종료시간을 셋팅
	 * </pre>
	 *
	 */
	public void setEndTime(int idx) {
		if(idx == 0){
			Map<String,Object> map = this.arrayList.get(arrayIndex);
			if(map != null){
				map.put("endTime", Utils.dateString(Utils.YMD_FROMAT_01));
			}
		}else{
			Map<String,Object> map = this.arrayList.get(idx);
			if(map != null){
				map.put("endTime", Utils.dateString(Utils.YMD_FROMAT_01));
			}
		}
	}


	public void setSuccessCnt(int cnt ) {
		this.successCnt = cnt;
		ssn.setAttribute("BatchSessionCounter", this);
	}
	/**
	 * <pre>
	 * 소제목
	 * </pre>
	 *
	 */
	public String getSubJobName() {
		String subName = "";
		if(this.arrayList.size() > arrayIndex){
			Map<String,Object> map = this.arrayList.get(arrayIndex);
			if(map != null){
				subName = (String)map.get("subJobName");
			}
		}
		return subName;
	}

	/**
	 * <pre>
	 * 현재까지 진행된 퍼센트
	 * </pre>
	 *
	 */
	public double getCurrentRate() {
		double rate = 0.0;
		if(this.arrayList.size() > arrayIndex){
			Map<String,Object> map = this.arrayList.get(arrayIndex);
			if(map != null && totalCnt > 0){
				double div = 0.0;
				if(currCnt >= totalCnt){
					div = 1.0;
				}else{
					div = ((currCnt* 1.0) / totalCnt );
				}
				rate = (  div * (Double)map.get("divRate") ) + (Double)map.get("accrueRate");
			}
		}
		return rate;
	}

	public double getCurrentRateForNotSubJob() {
		double rate = 0.0;

		double div = 0.0;
		if(successCnt >= totalCnt){
			div = 1.0;
		}else{
			div = ((successCnt* 1.0) / totalCnt );
		}
		rate = div * 100;

		return rate;
	}

	/**
	 * <pre>
	 * end 후에 호출하면 분배%을 확인 할 수 있음
	 * </pre>
	 *
	 */
	public String endHistory() {
		if(arrayList.size() > 0){
			String totalStartTime = "";
			String totalEndTime = "";
			int totalTime = 0;
			String type = Utils.YMD_FROMAT_01;
			for(int i = 0 ; i < arrayList.size() ; i++){
				Map<String,Object> map = arrayList.get(i);
				if(i == 0){
					totalStartTime = (String)map.get("startTime");
				}else if( i == (arrayList.size()-1) ){
					totalEndTime = (String)map.get("endTime");
				}
			}
			totalTime = Utils.getDayDiffByFormat(totalStartTime, totalEndTime, type); //시간차이를 구함

			for(int i = 0 ; i < arrayList.size() ; i++){
				Map<String,Object> map = arrayList.get(i);
				String startTime = (String)map.get("startTime");
				String endTime = (String)map.get("endTime");
				int timeDiff = Utils.getDayDiffByFormat(startTime, endTime, type); //시간차이를 구함
				double expectRate = (( timeDiff * 1.0 / totalTime ) * 100.0);
				map.put("expectRate", expectRate); 										//예상값(배분%)을 넣는다
			}
		}

		return toDebugString();
	}

	/**
	 * getter and setter
	 */
	public String getJobName() {
		return jobName;
	}

	/**
	 * <pre>
	 * 현재 진행중인 작업파라미터를 반환
	 * </pre>
	 *
	 * @return
	 */
	public Map<String,Object> getJobParam() {
		return jobParam;
	}

	public int getTotalCnt() {
		return totalCnt;
	}

	public int getCurrCnt() {
		return currCnt;
	}

	public int getSuccessCnt() {
		return successCnt;
	}

	public int getFailCnt() {
		return failCnt;
	}

//	public boolean isWorking() {
//		return StringUtils.isNotEmpty(this.jobName);
//	}

	public boolean isWorking() {
		return isWorking;
	}

	public boolean isCompleted() {
		return isCompleted;
	}

	public Map<String,Object> getBeforeJobParam() {
		return beforeJobParam;
	}

	/*
	 * BatchGlobalCounter 에서만 사용
	 * 인터페이스로 인해서 강제로 추가한 메소드
	 */
	public void setDivTotalCnt(int totalCnt) {
		this.currCnt = 0;
		this.totalCnt = totalCnt;
	}

	public String toDebugString() {
		String debug = "";
		debug += String.format("jobName=[%s], isCompleted=[%s], isWorking=[%s], CURRNT_RATE=[%f], TOTAL=[%d], CURRNT=[%d], SUCCESS=[%d], FAIL=[%d]"
				, getJobName(), isCompleted(), isWorking(), getCurrentRate(), getTotalCnt(), getCurrCnt(), getSuccessCnt(), getFailCnt());
		debug += "\n▶ [ ArrayList size["+arrayList.size()+"] current index["+arrayIndex+"] ]";
		for(int i = 0 ; i < arrayList.size() ; i++){
			if(i == arrayIndex){
				debug += "\n▶   [NOW] ArrayList["+i+"] : "+arrayList.get(i);
			}else{
				debug += "\n▶   ArrayList["+i+"] : "+arrayList.get(i);
			}

		}
		return debug;
	}
}
