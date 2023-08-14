package kbookERP.util.excelBuilder.data;

import java.util.List;

import kbookERP.util.map.UMap;

/**
 * EbDataSet 의 큐브리드 데이터베이스를 위한 페이징 데이터셋 구현 클래스
 *
 * <pre>
 *  ■ 설명
 *   - 큐브리드 데이터베이스를 쓸 경우 페이징이 필요할 때에만 사용
 *   - 생성자에서는 쿼리에서 사용할 조건문을 UMap 형태로 넘겨주고, 페이징 크기를 지정한다.
 *   - getListCntImpl() 메소드에는 전체건수를 계산하는 쿼리문을 오버라이드한다.
 *   - getListImpl() 메소드에는 실제 데이터를 가져오는 페이징쿼리를 오버라이드한다.
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
public abstract class DefaultEdsCubrid implements EbDataSet {

	// 기본 프로퍼티
	public static final DbType dbType = EbDataSet.DbType.CUBRID;

	// 입력파라미터
	private UMap dbParam;
	private int pageSize;

	// 계산값
	private int totalCnt;

	// 결과파라미터
	private List<UMap> listData;

	/**
	 * @param param
	 * @param pageSize
	 * @throws Exception
	 */
	public DefaultEdsCubrid(UMap param, int pageSize){
		dbParam = param;
		this.pageSize = pageSize;
		totalCnt = getListCntImpl(dbParam);
	}

	@Override
	public int getDataSetCount() {
		return totalCnt;
	}


	@Override
	public int getMaxPage() {
		return ((totalCnt -1) / pageSize) + 1;
	}

	/**
	 * 프로그램 쪽에서 사용
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<UMap> getListByPage(int page){
		//페이징 파라미터 추가
		int skip = (page - 1) * pageSize;
		dbParam.put("startNum", skip);
		dbParam.put("endNum", pageSize);
		listData = getListImpl(dbParam);
		return listData;
	}

	/**
	 * 페이징 카운트 쿼리
	 *
	 * @return
	 */
	public abstract int getListCntImpl(UMap param);


	/**
	 * 페이징쿼리
 	 *  - param 에 startNum 과 endNum 으로 파라미터 넘어옴
	 *  - 무시하고 자체적으로 페이징로직 사용하려면 getListImpl 내에서 구현
	 *
	 * @return
	 */
	public abstract List<UMap> getListImpl(UMap param);

}
