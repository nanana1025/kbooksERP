package kbookERP.core.files;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kbookERP.util.map.LowerKeyMap;

@Mapper
public interface FileMapper {

	int fileDataSeq();
	int fileDataOracleSeq();

	int fileSeq(int fileId);

	int saveRawData(Map<String, Object> param);

	int saveFileData(Map<String, Object> param);

	int editFileData(Map<String, Object> param);

	int deleteRawData(Map<String, Object> param);

	int deleteFileData(Map<String, Object> param);

	List<LowerKeyMap> getFileNameBySql(Map<String, Object> param);

	String getFileIdBySql(Map<String, Object> param);

	LowerKeyMap getFileInfoById(Map<String, Object> param);

	int selectFileCnt(Map<String, Object> param);

	Map<String, Object> getInventoryCheckLatestFile();
}