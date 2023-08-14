package com.dacare.spring.batch;

import java.util.Map;

/**
 * 배치작업을 위한 Counter 인터페이스
 *
 * @author 박주의
 *
 */
public interface BatchCounter {
	public void countUp(boolean isSuccess);
	public boolean setReady(String jobName);
	public boolean start(String jobName, Map<String,Object> jobParam, int totalCnt);
	public void setDivTotalCnt(int totalCnt);
}
