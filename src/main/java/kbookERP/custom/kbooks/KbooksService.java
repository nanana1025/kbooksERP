package kbookERP.custom.kbooks;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class KbooksService {

	@Autowired
	private KbooksMapper kbooksMapper;

	    /* 부품 ID 규칙 변경에 따른 데이터 일괄 수정을 위해 임시로 만든 함수*/
	    public Map<String, Object> test(Map<String, Object> params) throws Exception {
			Map<String, Object> resultMap = new HashMap<String, Object>();

			System.out.println("params = "+params);
			resultMap = kbooksMapper.test(params);

			resultMap.put("SUCCESS", true);

			return resultMap;
	    }











































}
