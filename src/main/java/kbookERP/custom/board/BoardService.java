package kbookERP.custom.board;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import kbookERP.custom.util.Util;

@Service
public class BoardService {

	@Autowired
	BoardMapper boardMapper;

//	@Autowired
//	CommonMapper commonMapper;

//	@Autowired
//	UserMapper userMapper;
//
//
//	@Autowired
//	DataMapper dataMapper;

      public Map<String, Object> updateCompanyInfo(HttpServletRequest req, Map<String, Object> params) throws Exception {

    	  Map<String, Object> newParams = new HashMap<String, Object>();
          Map<String, Object> resultMap = new HashMap<String, Object>();
          List<Object> listPart= new ArrayList<Object>();
          Map<Object, Object> faultIdMap = new HashMap<Object, Object>();
          List<Map<String, Object>> listFaultPart= new ArrayList<Map<String, Object>>();

          try {

        	  boardMapper.updateCompanyInfo(params);

	            resultMap.put("SUCCESS", true);
	            resultMap.put("MSG", "처리되었습니다.");
	            return resultMap;

          } catch (Exception ex) {
              resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
              resultMap.put("ERROR", ex.getMessage());
              resultMap.put("SUCCESS", false);
              return resultMap;
          }
      }

      public Map<String, Object> InsertCompanyBulk(HttpServletRequest req, Map<String, Object> params) throws Exception {
	    	Map<String, Object> resultMap = new HashMap<String, Object>();
			Map<String, Object> sqlMap = new HashMap<String, Object>();
			Map<String, Object> newParams = new HashMap<String, Object>();
			List<Object> listComponent = new ArrayList<Object>();
			List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
			List<String> listCol = new ArrayList<String>();

			try {

				if (params.containsKey("DATA")) {
					listComponent = (List<Object>) params.get("DATA");
				}

				for (Object oData : listComponent) {
					Map<String, Object> data = new HashMap<String, Object>();
					Map<String, Object> newData = new HashMap<String, Object>();
					data = (Map<String, Object>) oData;
					listSqlMap.add(data);
				}

				params.put("LIST_COMPANY", listSqlMap);
				params.put("DEL_YN", "N");

				boardMapper.InsertCompanyBulk(params);

				resultMap.put("SUCCESS", true);

				return resultMap;
		    }catch(Exception ex) {

		    	System.out.println("error: "+ex);
		    	resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
				resultMap.put("SUCCESS", false);

				return resultMap;
		    }
	    }



      public Map<String, Object> getScheduleList(Map<String, Object> params) throws Exception {
  		Map<String, Object> resultMap = new HashMap<String, Object>();
  		List<Map<String, Object>> listDataList = new ArrayList<Map<String, Object>>();
  		List<Map<String, Object>> listReceiverList = new ArrayList<Map<String, Object>>();
  		try {

  			listDataList = boardMapper.getScheduleList(params);

  			if(listDataList.size() < 1) {
  				resultMap.put("EXIST", false);
  				resultMap.put("RECEIVER_EXIST", true);
  			}
  			else{

  				listReceiverList = boardMapper.getScheduleReceiverStatistics(params);

  				if(listReceiverList.size() < 1)
  	  				resultMap.put("RECEIVER_EXIST", false);
  	  			else{
  	  				resultMap.put("RECEIVER_EXIST", true);
  	  				resultMap.put("RECEIVER_DATA", listReceiverList);
  	  			}

  				resultMap.put("EXIST", true);
  				resultMap.put("DATA", listDataList);
  			}
  			resultMap.put("SUCCESS", true);
  			return resultMap;
  		}catch(Exception ex){
  			resultMap.put("SUCCESS", false);
  			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
  			resultMap.put("ERROR", ex.getMessage());
  			return resultMap;
  		}
  	}

//      public Map<String, Object> createNewSchedule(Map<String, Object> params) throws Exception {
//  		Map<String, Object> resultMap = new HashMap<String, Object>();
//  		Map<String, Object> newParams = new HashMap<String, Object>();
//  		try {
//
//  			newParams.clear();
//			newParams.put("PART", "schedule");
//			long receiptNo = dataMapper.getSerialNo(newParams);
//			String job = "J" + receiptNo;
//
//			newParams.clear();
//			newParams.put("JOB", job);
//			newParams.put("USER_ID", params.get("USER_ID"));
//
//			boardMapper.createNewSchedule(newParams);
//
//  			long id = commonMapper.getLastAutoIncreasedId();
//
//  			resultMap.put("JOB", job);
//  			resultMap.put("JOB_ID", id);
//  			resultMap.put("SUCCESS", true);
//
//  			return resultMap;
//  		} catch (Exception ex) {
//  			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
//  			resultMap.put("ERROR", ex.getMessage());
//  			resultMap.put("SUCCESS", false);
//  			return resultMap;
//  		}
//  	}

//      public Map<String, Object> createNewSubSchedule(Map<String, Object> params) throws Exception {
//    		Map<String, Object> resultMap = new HashMap<String, Object>();
//    		try {
//
//    			boardMapper.createNewSubSchedule(params);
//    			long id = commonMapper.getLastAutoIncreasedId();
//
//    			resultMap.put("JOB_ID", id);
//    			resultMap.put("SUCCESS", true);
//
//    			return resultMap;
//    		} catch (Exception ex) {
//    			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
//    			resultMap.put("ERROR", ex.getMessage());
//    			resultMap.put("SUCCESS", false);
//    			return resultMap;
//    		}
//    	}

//      public Map<String, Object> updateScheduleSimple(Map<String, Object> params) throws Exception {
//  		Map<String, Object> resultMap = new HashMap<String, Object>();
//  		try {
//  			boardMapper.updateSchedule(params);
//
//  			resultMap.put("SUCCESS", true);
//  			return resultMap;
//  		} catch (Exception ex) {
//  			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
//  			resultMap.put("ERROR", ex.getMessage());
//  			resultMap.put("SUCCESS", false);
//  			return resultMap;
//  		}
//	}
//
//      public Map<String, Object> deleteSchedule(Map<String, Object> params) throws Exception {
//    		Map<String, Object> resultMap = new HashMap<String, Object>();
//    		try {
//
//    			if(!params.containsKey("JOB_STATE"))
//    				params.put("JOB_STATE", -1);
//
//    			boardMapper.updateSchedule(params);
//
//    			boardMapper.deleteSchduleReceiverByJobId(params);
//
//    			resultMap.put("SUCCESS", true);
//    			return resultMap;
//    		} catch (Exception ex) {
//    			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
//    			resultMap.put("ERROR", ex.getMessage());
//    			resultMap.put("SUCCESS", false);
//    			return resultMap;
//    		}
//  	}




  		public Map<String, Object> getScheduleDesList(Map<String, Object> params) throws Exception {
  	  		Map<String, Object> resultMap = new HashMap<String, Object>();
  	  		List<Map<String, Object>> listDataList = new ArrayList<Map<String, Object>>();
  	  		try {

  	  			listDataList = boardMapper.getScheduleDesList(params);

  				if(listDataList.size() < 1)
  	  				resultMap.put("EXIST", false);
  	  			else{
  	  				resultMap.put("EXIST", true);
  	  				resultMap.put("DATA", listDataList);
  	  			}

  	  			resultMap.put("SUCCESS", true);
  	  			return resultMap;
  	  		}catch(Exception ex){
  	  			resultMap.put("SUCCESS", false);
  	  			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
  	  			resultMap.put("ERROR", ex.getMessage());
  	  			return resultMap;
  	  		}
  	  	}

  		public Map<String, Object> getReceiveCheckInfo(Map<String, Object> params) throws Exception {
  	  		Map<String, Object> resultMap = new HashMap<String, Object>();
  	  		List<Map<String, Object>> listDataList = new ArrayList<Map<String, Object>>();
  	  		try {

  	  			listDataList = boardMapper.getReceiveCheckInfo(params);

  				if(listDataList.size() < 1)
  	  				resultMap.put("EXIST", false);
  	  			else{
  	  				resultMap.put("EXIST", true);
  	  				resultMap.put("DATA", listDataList);
  	  			}

  	  			resultMap.put("SUCCESS", true);
  	  			return resultMap;
  	  		}catch(Exception ex){
  	  			resultMap.put("SUCCESS", false);
  	  			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
  	  			resultMap.put("ERROR", ex.getMessage());
  	  			return resultMap;
  	  		}
  	  	}

  		public Map<String, Object> getAlarmCandidate(Map<String, Object> params) throws Exception {
  	  		Map<String, Object> resultMap = new HashMap<String, Object>();
  	  		List<Map<String, Object>> listDataList = new ArrayList<Map<String, Object>>();
  	  		try {

  	  			listDataList = boardMapper.getAlarmCandidate(params);

  				if(listDataList.size() < 1)
  	  				resultMap.put("EXIST", false);
  	  			else{
  	  				resultMap.put("EXIST", true);
  	  				resultMap.put("DATA", listDataList);
  	  			}

  	  			resultMap.put("SUCCESS", true);
  	  			return resultMap;
  	  		}catch(Exception ex){
  	  			resultMap.put("SUCCESS", false);
  	  			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
  	  			resultMap.put("ERROR", ex.getMessage());
  	  			return resultMap;
  	  		}
  	  	}

	public Map<String, Object> getViewType(Map<String, Object> params) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> listCategory= new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> listView = new ArrayList<Map<String, Object>>();

		try {

			params.put("TYPE", 1);
			listCategory = boardMapper.getViewType(params);

			params.put("TYPE", 0);
			listView = boardMapper.getViewType(params);

			if(listCategory.size() < 1 || listView.size() < 1) {
				boardMapper.deleteViewType(params);
				boardMapper.insertDefaultViewType(params);

				params.put("TYPE", 1);
				listCategory = boardMapper.getViewType(params);

				params.put("TYPE", 0);
				listView = boardMapper.getViewType(params);

			}

			if (listCategory.size() < 1)
				resultMap.put("CATEGORY_EXIST", false);
			else {
				resultMap.put("CATEGORY_EXIST", true);
				resultMap.put("CATEGORY_DATA", listCategory);
			}

			if (listView.size() < 1)
				resultMap.put("VIEW_EXIST", false);
			else {
				resultMap.put("VIEW_EXIST", true);
				resultMap.put("VIEW_DATA", listView);
			}

			resultMap.put("SUCCESS", true);
			return resultMap;
		} catch (Exception ex) {
			resultMap.put("SUCCESS", false);
			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
			resultMap.put("ERROR", ex.getMessage());
			return resultMap;
		}
	}

	public Map<String, Object> getViewType2(Map<String, Object> params) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> listdata= new ArrayList<Map<String, Object>>();

		try {

			listdata = boardMapper.getViewType2(params);

			if(listdata.size() < 1) {
				boardMapper.deleteViewType2(params);
				boardMapper.insertDefaultViewType2(params);

				listdata = boardMapper.getViewType2(params);
			}

			if (listdata.size() < 1)
				resultMap.put("EXIST", false);
			else {
				resultMap.put("EXIST", true);
				resultMap.put("DATA", listdata);
			}


			resultMap.put("SUCCESS", true);
			return resultMap;
		} catch (Exception ex) {
			resultMap.put("SUCCESS", false);
			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
			resultMap.put("ERROR", ex.getMessage());
			return resultMap;
		}
	}


	public Map<String, Object> updateViewType(Map<String, Object> params) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		List<Map<String, Object>> listSqlMap = new ArrayList<Map<String, Object>>();
		List<Object> listData = new ArrayList<Object>();

		try {

			if (params.containsKey("DATA")) {
				listData = (List<Object>) params.get("DATA");
				for (Object oData : listData){
					boardMapper.updateViewType((Map<String, Object>) oData);
				}
			}

			resultMap.put("SUCCESS", true);
			return resultMap;
		}
		 catch (Exception ex) {
			resultMap.put("SUCCESS", false);
			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
			resultMap.put("ERROR", ex.getMessage());
			return resultMap;
		}
	}

	public Map<String, Object> changeViewType(Map<String, Object> params) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> newParams = new HashMap<String, Object>();

		try {

			List<String> listData = Util.getListString(params.get("LIST_USER_ID"));
			params.put("LIST_USER_ID", listData);
			boardMapper.deleteViewType(params);

			newParams.put("SELECT_USER_ID", params.get("SELECT_USER_ID"));
			for(String copyUserId: listData) {
				newParams.put("COPY_USER_ID", copyUserId);
				boardMapper.insertViewTypeByUser(newParams);
			}

			resultMap.put("SUCCESS", true);
			return resultMap;
		}
		 catch (Exception ex) {
			resultMap.put("SUCCESS", false);
			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
			resultMap.put("ERROR", ex.getMessage());
			return resultMap;
		}
	}

	public Map<String, Object> getWorkOrderList(Map<String, Object> params) throws Exception {
	  		Map<String, Object> resultMap = new HashMap<String, Object>();
	  		List<Map<String, Object>> listDataList = new ArrayList<Map<String, Object>>();
	  		try {

	  			listDataList = boardMapper.getWorkOrderList(params);

				if(listDataList.size() < 1)
	  				resultMap.put("EXIST", false);
	  			else{
	  				resultMap.put("EXIST", true);
	  				resultMap.put("DATA", listDataList);
	  			}

	  			resultMap.put("SUCCESS", true);
	  			return resultMap;
	  		}catch(Exception ex){
	  			resultMap.put("SUCCESS", false);
	  			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
	  			resultMap.put("ERROR", ex.getMessage());
	  			return resultMap;
	  		}
	  	}

	public Map<String, Object> updateWorkOrder(Map<String, Object> params) throws Exception {
		Map<String, Object> newParams = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Object> listPart = new ArrayList<Object>();
		try {

			if (params.containsKey("DATA")) {
				listPart = (List<Object>) params.get("DATA");

				for (Object oData : listPart){

					newParams = (Map<String, Object>) oData;
					newParams.put("USER_ID", params.get("USER_ID"));
					boardMapper.updateWorkOrder(newParams);
				}
			}

			resultMap.put("SUCCESS", true);
			return resultMap;

		} catch (Exception ex) {

			System.out.println("error: " + ex);
			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
			resultMap.put("SUCCESS", false);

			return resultMap;
		}
	}

//	public Map<String, Object> createJobOrder(Map<String, Object> params) throws Exception {
//		Map<String, Object> resultMap = new HashMap<String, Object>();
//
//		try {
//
//			boardMapper.createJobOrder(params);
//
//			long id = commonMapper.getLastAutoIncreasedId();
//
//			resultMap.put("ID", id);
//			resultMap.put("SUCCESS", true);
//
//			return resultMap;
//
//		} catch (Exception ex) {
//
//			System.out.println("error: " + ex);
//			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
//			resultMap.put("SUCCESS", false);
//
//			return resultMap;
//		}
//	}

	public Map<String, Object> deleteJobOrder(Map<String, Object> params) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		try {

			boardMapper.deleteJobOrder(params);

			resultMap.put("SUCCESS", true);

			return resultMap;

		} catch (Exception ex) {

			System.out.println("error: " + ex);
			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
			resultMap.put("SUCCESS", false);

			return resultMap;
		}
	}


	public Map<String, Object> updateUserView(Map<String, Object> params) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> newParams = new HashMap<String, Object>();
		List<Map<String, Object>> listUser= new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> listdata= new ArrayList<Map<String, Object>>();

		try {
			List<String> listUserId = new ArrayList<String>();

			if(params.containsKey("SELECT_USER_ID")){

				System.out.println("params = "+params);
				newParams.put("USER_ID", params.get("SELECT_USER_ID"));
				System.out.println("newParams = "+newParams);
				Map<String, Object> userMap = boardMapper.getUser(newParams);

				if(userMap != null)
					listUserId.add(params.get("SELECT_USER_ID").toString());

			}else {
				newParams.put("STATE_CD", "A");

				listUser = boardMapper.getUserInfo(newParams);

				listUserId = Util.getListString(listUser, "USER_ID");

				listUserId.add("MASTER");
				listUserId.add("SUPER USER");
				listUserId.add("MANAGER");
				listUserId.add("USER");
				listUserId.add("EXTERNAL");
			}

			for(String userId : listUserId) {

				newParams.clear();
				newParams.put("USER_ID", userId);

				listdata = boardMapper.getNewView(newParams);

				if(listdata.size() > 0) {

					List<Long> listId = Util.getListLong(listdata, "ID");

					newParams.put("SELECT_USER_ID", userId);
					newParams.put("LIST_ID", listId);

					boardMapper.insertNewView(newParams);
				}
			}

			resultMap.put("SUCCESS", true);
			return resultMap;
		} catch (Exception ex) {
			resultMap.put("SUCCESS", false);
			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
			resultMap.put("ERROR", ex.getMessage());
			return resultMap;
		}
	}

	public Map<String, Object> getWarehouse(Map<String, Object> params) throws Exception {
  		Map<String, Object> resultMap = new HashMap<String, Object>();
  		List<Map<String, Object>> listDataList = new ArrayList<Map<String, Object>>();
  		try {

  			listDataList = boardMapper.getWarehouse(params);

			if(listDataList.size() < 1)
  				resultMap.put("EXIST", false);
  			else{
  				resultMap.put("EXIST", true);
  				resultMap.put("DATA", listDataList);
  			}

  			resultMap.put("SUCCESS", true);
  			return resultMap;
  		}catch(Exception ex){
  			resultMap.put("SUCCESS", false);
  			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
  			resultMap.put("ERROR", ex.getMessage());
  			return resultMap;
  		}
  	}

	public Map<String, Object> getPallet(Map<String, Object> params) throws Exception {
  		Map<String, Object> resultMap = new HashMap<String, Object>();
  		List<Map<String, Object>> listDataList = new ArrayList<Map<String, Object>>();
  		try {

  			listDataList = boardMapper.getPallet(params);

			if(listDataList.size() < 1)
  				resultMap.put("EXIST", false);
  			else{
  				resultMap.put("EXIST", true);
  				resultMap.put("DATA", listDataList);
  			}

  			resultMap.put("SUCCESS", true);
  			return resultMap;
  		}catch(Exception ex){
  			resultMap.put("SUCCESS", false);
  			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
  			resultMap.put("ERROR", ex.getMessage());
  			return resultMap;
  		}
  	}




	public Map<String, Object> updateWarehouse(Map<String, Object> params) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Object> listPart = new ArrayList<Object>();

		try {

			if (params.containsKey("DATA")) {
				listPart = (List<Object>) params.get("DATA");

				for (Object oData : listPart){
					Map<String, Object> dataMap = (Map<String, Object>) oData;
					dataMap.put("USER_ID", params.get("USER_ID"));
					boardMapper.updateWarehouse(dataMap);

					boardMapper.createWarehouseHistory(dataMap);
				}
			}


			resultMap.put("SUCCESS", true);
			return resultMap;
		} catch (Exception ex) {
			resultMap.put("SUCCESS", false);
			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
			resultMap.put("ERROR", ex.getMessage());
			return resultMap;
		}
	}

	public Map<String, Object> updatePallet(Map<String, Object> params) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Object> listPart = new ArrayList<Object>();
		try {

			if (params.containsKey("DATA")) {
				listPart = (List<Object>) params.get("DATA");

				for (Object oData : listPart){
					Map<String, Object> dataMap = (Map<String, Object>) oData;
					dataMap.put("USER_ID", params.get("USER_ID"));
					boardMapper.updatePallet(dataMap);

					boardMapper.createPalletHistory(dataMap);
				}
			}


			resultMap.put("SUCCESS", true);
			return resultMap;

		} catch (Exception ex) {

			System.out.println("error: " + ex);
			resultMap.put("MSG", "오류가 발생했습니다. 관리자에게 문의하세요.");
			resultMap.put("SUCCESS", false);

			return resultMap;
		}
	}







































































}
