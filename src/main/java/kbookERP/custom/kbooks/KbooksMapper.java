package kbookERP.custom.kbooks;

import java.util.Map;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface KbooksMapper {

	public Map<String,Object> test(Map<String,Object> params);

}
