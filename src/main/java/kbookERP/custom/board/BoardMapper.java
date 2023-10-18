package kbookERP.custom.board;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface BoardMapper {

	public  List<Map<String,Object>> getViewType(Map<String,Object> params);

	public  List<Map<String,Object>> getViewType2(Map<String,Object> params);

	public int deleteViewType2(Map<String,Object> params);

	public int insertDefaultViewType2(Map<String,Object> params);

	public int updateViewType(Map<String,Object> params);

	public int deleteViewType(Map<String,Object> params);

	public int insertViewTypeByUser(Map<String,Object> params);

	public Map<String,Object> getUser(Map<String,Object> params);

	public List<Map<String,Object>> getUserInfo(Map<String,Object> params);

	public  List<Map<String,Object>>  getNewView(Map<String,Object> params);

	public int insertNewView(Map<String,Object> params);






    public List<Map<String,Object>> getRequestList(Map<String,Object> params);

    public void insertRequestList(Map<String,Object> params);

    public void deleteRequestList(Map<String,Object> params);

    public void updateRequestList(Map<String,Object> params);


    public List<Map<String,Object>> getJobList(Map<String,Object> params);

    public Map<String,Object> selectJob(Map<String,Object> params);

    public void insertJobList(Map<String,Object> params);

    public void deleteJobList(Map<String,Object> params);

    public void updateJobList(Map<String,Object> params);


    public  List<Map<String,Object>> getScheduleList(Map<String,Object> params);

    public  List<Map<String,Object>> getScheduleReceiverStatistics(Map<String,Object> params);

    public int createNewSchedule(Map<String,Object> params);

    public int createNewSubSchedule(Map<String,Object> params);

    public int updateSchedule(Map<String,Object> params);

    public int updateSchedule4Sub(Map<String,Object> params);

    public int updateScheduleReceiver(Map<String,Object> params);

    public int createDetail(Map<String,Object> params);

    public  List<Map<String,Object>> getScheduleDesList(Map<String,Object> params);

    public int createSchduleReceiver(Map<String,Object> params);

    public int deleteSchduleReceiver(Map<String,Object> params);

    public int deleteSchduleReceiverByJobId(Map<String,Object> params);

    public  List<Map<String,Object>> getReceiveCheckInfo(Map<String,Object> params);

    public  List<Map<String,Object>> getAlarmCandidate(Map<String,Object> params);









    public int insertDefaultViewType(Map<String,Object> params);





    public int insertUpdateScheduleHistory(Map<String,Object> params);

    public int changeViewType(Map<String,Object> params);



    public  List<Map<String,Object>> getWorkOrderList(Map<String,Object> params);

    public int updateWorkOrder(Map<String,Object> params);

    public int createJobOrder(Map<String,Object> params);

    public int deleteJobOrder(Map<String,Object> params);





    public  List<Map<String,Object>> getCompanyInfo(Map<String,Object> params);

	public void insertCompanyInfo(Map<String,Object> params);

	public void deleteCompanyInfo(Map<String,Object> params);

	public void updateCompanyInfo(Map<String,Object> params);

	public long getRecentCompanyId(Map<String,Object> params);

	public void InsertCompanyBulk(Map<String,Object> params);

	public void updateOrderInfo(Map<String,Object> params);

	public Map<String,Object> getOrderInfo(Map<String,Object> params);

	public Map<String,Object> getCompanyInfoByCd(Map<String,Object> params);

	public  List<Map<String,Object>> getWarehouse(Map<String,Object> params);

	public  List<Map<String,Object>> getPallet(Map<String,Object> params);

	public int createWarehouse(Map<String,Object> params);

	public int createPallet(Map<String,Object> params);

	public int updateWarehouse(Map<String,Object> params);

	public int updatePallet(Map<String,Object> params);

	public int createWarehouseHistory(Map<String,Object> params);

	public int createPalletHistory(Map<String,Object> params);





}
