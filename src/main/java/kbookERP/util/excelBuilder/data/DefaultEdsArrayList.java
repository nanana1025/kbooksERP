package kbookERP.util.excelBuilder.data;

import java.util.List;

import kbookERP.util.map.UMap;

/**
 * EbDataSet 의 페이징을 쓰지 않는 리스트형 객체를 위한 데이터셋 구현 클래스
 *
 * <pre>
 *  ■ 설명
 *   - ArrayList 와 같은 페이징이 필요없는 리스트 데이터 처리시 사용할 데이터셋 클래스
 *   - 생성자에서 사용할 데이터셋만 지정하면 되며, 별도의 작업이 필요하면 @Override 메소드들만 오버라이드하면 됨
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
public class DefaultEdsArrayList implements EbDataSet {

	// 기본 프로퍼티
	public static final DbType dbType = EbDataSet.DbType.ARRAY;

	// 결과파라미터
	private List<UMap> listData;
	private int listSize;

	//데이터베이스 종류에 따라서 페이징 계산하는 생성자 사용
	public DefaultEdsArrayList(List<UMap> data) {
		listData = data;
		listSize = data.size();
	}

	@Override
	public int getDataSetCount() {
		return listSize;
	}

	@Override
	public int getMaxPage() {
		return 1;
	}

	@Override
	public List<UMap> getListByPage(int page) {
		return listData;
	}

}
