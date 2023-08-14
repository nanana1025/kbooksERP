package com.dacare.util.excelBuilder.data;

import java.util.List;

import com.dacare.util.map.UMap;

/**
 * ExcelBuilder 에서 List형 데이터를 DB를 통해서 셋팅하기 위한 데이터셋 인터페이스
 *
 * <pre>
 *  ■ 설명
 *   - 대용량의 데이터를 처리할 때에 DB 상에서 페이징쿼리로 데이터를 가져올 수 있도록 하기 위한 인터페이스
 *   - ExcelBuilder 에서의 호출을 위한 인터페이스로 실제 사용은 DefaultArrayDataSet 이나 DefaultCubridDataSet 같은 추상클래스를 구현해서 사용
 *
 *  ■ 변경이력
 *
 *  버전    변경일자    작업자      수정내용
 *  ----    --------    --------    -------------------------------------------
 *  v2.0    20190523	박주의		최초작성
 *
 * </pre>
 *
 * @author 박주의
 * @version v2.0
 */
public interface EbDataSet {
	// 데이터베이스 타입에 대한 enum
	public static enum DbType {
		ARRAY, ORACLE, CUBRID
	}

	/**
	 * @return
	 */
	public abstract int getDataSetCount();

	/**
	 * @return
	 */
	public abstract int getMaxPage();

	/**
	 * @param page
	 * @return
	 */
	public abstract List<UMap> getListByPage(int page);
}
