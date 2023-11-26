package kbookERP.custom.board;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kbookERP.custom.util.Util;

@Controller
@RequestMapping("/board")
public class BoardController {

	@Autowired
	BoardService boardService;

	@Autowired
	BoardMapper boardMapper;



	@ResponseBody
	@PostMapping(value = "/insertRequestList.json")
	public Map<String, Object> insertRequestList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();
		Util.pramsNullCheck(params);
//    	result = boardService.insertRequestList(req, params);

    	return result;
	}

	@ResponseBody
	@PostMapping(value = "/deleteRequestList.json")
	public Map<String, Object> deleteRequestList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();
		Util.pramsNullCheck(params);
//    	result = boardService.deleteRequestList(req, params);

    	return result;
	}

	@ResponseBody
	@PostMapping(value = "/updateRequestList.json")
	public Map<String, Object> updateRequestList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();
		Util.pramsNullCheck(params);
//    	result = boardService.updateRequestList(req, params);

    	return result;
	}





	@ResponseBody
	@PostMapping(value = "/searchJobList.json")
	public Map<String, Object> searchJobList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();
		Util.pramsNullCheck(params);
//    	result = boardService.searchJobList(req, params);

    	return result;
	}

	@ResponseBody
	@PostMapping(value = "/insertJobList.json")
	public Map<String, Object> insertJobList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();
		Util.pramsNullCheck(params);
//    	result = boardService.insertJobList(req, params);

    	return result;
	}

	@ResponseBody
	@PostMapping(value = "/deleteJobList.json")
	public Map<String, Object> deleteJobList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();
		Util.pramsNullCheck(params);
//    	result = boardService.deleteJobList(req, params);

    	return result;
	}

	@ResponseBody
	@PostMapping(value = "/updateJobList.json")
	public Map<String, Object> updateJobList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();
		Util.pramsNullCheck(params);
//    	result = boardService.updateJobList(req, params);

    	return result;
	}


    @PostMapping(value = "/getCompanyInfo.json")
    @ResponseBody
	public Map<String, Object> getCompanyInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

    	System.out.println("BoardController.getCompanyInfo");
    	Map<String,Object> result = new HashMap<>();

    	Util.pramsNullCheck(params);

//    	result = boardService.getCompanyInfo(req, params);

    	return result;
    }

    @PostMapping(value = "/deleteCompanyInfo.json")
    @ResponseBody
	public Map<String, Object> deleteCompanyInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

    	System.out.println("BoardController.deleteCompanyInfo");
    	Map<String,Object> result = new HashMap<>();

    	Util.pramsNullCheck(params);

//    	result = boardService.deleteCompanyInfo(req, params);

    	return result;
    }

    @PostMapping(value = "/insertCompanyInfo.json")
    @ResponseBody
	public Map<String, Object> insertCompanyInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

    	System.out.println("BoardController.insertCompanyInfo");
    	Map<String,Object> result = new HashMap<>();

    	Util.pramsNullCheck(params);

//    	result = boardService.insertCompanyInfo(req, params);

    	return result;
    }

    @PostMapping(value = "/updateCompanyInfo.json")
    @ResponseBody
	public Map<String, Object> updateCompanyInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

    	System.out.println("BoardController.updateCompanyInfo");
    	Map<String,Object> result = new HashMap<>();

    	Util.pramsNullCheck(params);

    	result = boardService.updateCompanyInfo(req, params);

    	return result;
    }

    @PostMapping(value = "/InsertCompanyBulk.json")
    @ResponseBody
	public Map<String, Object> InsertCompanyBulk(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

    	System.out.println("BoardController.InsertCompanyBulk");
    	Map<String,Object> result = new HashMap<>();

    	Util.pramsNullCheck(params);

    	result = boardService.InsertCompanyBulk(req, params);

    	return result;
    }

    @PostMapping(value = "/getScheduleList.json")
    @ResponseBody
	public Map<String, Object> getScheduleList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.getScheduleList");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.getScheduleList(params);
    	return result;
    }

    @PostMapping(value = "/createNewSchedule.json")
    @ResponseBody
	public Map<String, Object> createNewSchedule(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.createNewSchedule");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
//    	result = boardService.createNewSchedule(params);
    	return result;
    }

    @PostMapping(value = "/createNewSubSchedule.json")
    @ResponseBody
	public Map<String, Object> createNewSubSchedule(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.createNewSubSchedule");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
//    	result = boardService.createNewSubSchedule(params);
    	return result;
    }

    @PostMapping(value = "/deleteSchedule.json")
    @ResponseBody
	public Map<String, Object> deleteSchedule(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.deleteSchedule");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
//    	result = boardService.deleteSchedule(params);
    	return result;
    }

    @PostMapping(value = "/updateSchedule.json")
    @ResponseBody
	public Map<String, Object> updateSchedule(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.updateSchedule");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
//    	result = boardService.updateSchedule(params);
    	return result;
    }

    @PostMapping(value = "/updateScheduleSimple.json")
    @ResponseBody
	public Map<String, Object> updateScheduleSimple(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.updateScheduleSimple");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
//    	result = boardService.updateScheduleSimple(params);
    	return result;
    }

    @PostMapping(value = "/updateScheduleReceiver.json")
    @ResponseBody
	public Map<String, Object> updateScheduleReceiver(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.updateScheduleReceiver");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
//    	result = boardService.updateScheduleReceiver(params);
    	return result;
    }

    @PostMapping(value = "/getScheduleDesList.json")
    @ResponseBody
	public Map<String, Object> getScheduleDesList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.getScheduleDesList");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.getScheduleDesList(params);
    	return result;
    }

    @PostMapping(value = "/getReceiveCheckInfo.json")
    @ResponseBody
	public Map<String, Object> getReceiveCheckInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.getReceiveCheckInfo");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.getReceiveCheckInfo(params);
    	return result;
    }

    @PostMapping(value = "/getAlarmCandidate.json")
    @ResponseBody
	public Map<String, Object> getAlarmCandidate(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.getAlarmCandidate");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.getAlarmCandidate(params);
    	return result;
    }

    @PostMapping(value = "/getViewType.json")
    @ResponseBody
	public Map<String, Object> getViewType(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.getViewType");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.getViewType(params);
    	return result;
    }

    @PostMapping(value = "/getViewType2.json")
    @ResponseBody
	public Map<String, Object> getViewType2(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.getViewType2");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.getViewType2(params);
    	return result;
    }

    @PostMapping(value = "/updateViewType.json")
    @ResponseBody
	public Map<String, Object> updateViewType(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.updateViewType");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.updateViewType(params);
    	return result;
    }

    @PostMapping(value = "/changeViewType.json")
    @ResponseBody
	public Map<String, Object> changeViewType(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.changeViewType");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.changeViewType(params);
    	return result;
    }

    @PostMapping(value = "/getWorkOrderList.json")
    @ResponseBody
	public Map<String, Object> getWorkOrderList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.getWorkOrderList");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.getWorkOrderList(params);
    	return result;
    }

    @PostMapping(value = "/updateWorkOrder.json")
    @ResponseBody
	public Map<String, Object> updateWorkOrder(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.updateWorkOrder");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.updateWorkOrder(params);
    	return result;
    }

    @PostMapping(value = "/createJobOrder.json")
    @ResponseBody
	public Map<String, Object> createJobOrder(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.createJobOrder");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
//    	result = boardService.createJobOrder(params);
    	return result;
    }

    @PostMapping(value = "/deleteJobOrder.json")
    @ResponseBody
	public Map<String, Object> deleteJobOrder(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.deleteJobOrder");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.deleteJobOrder(params);
    	return result;
    }

    @PostMapping(value = "/updateUserView.json")
    @ResponseBody
	public Map<String, Object> updateUserView(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.updateUserView");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.updateUserView(params);
    	return result;
    }






    @PostMapping(value = "/getWarehouse.json")
    @ResponseBody
	public Map<String, Object> getWarehouse(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.getWarehouse");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.getWarehouse(params);
    	return result;
    }

    @PostMapping(value = "/getPallet.json")
    @ResponseBody
	public Map<String, Object> getPallet(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.getPallet");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.getPallet(params);
    	return result;
    }

    @PostMapping(value = "/createWarehouse.json")
    @ResponseBody
	public Map<String, Object> createWarehouse(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.createWarehouse");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
//    	result = boardService.createWarehouse(params);
    	return result;
    }

    @PostMapping(value = "/createPallet.json")
    @ResponseBody
	public Map<String, Object> createPallet(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.createPallet");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
//    	result = boardService.createPallet(params);
    	return result;
    }

    @PostMapping(value = "/updateWarehouse.json")
    @ResponseBody
	public Map<String, Object> updateWarehouse(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.updateWarehouse");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.updateWarehouse(params);
    	return result;
    }

    @PostMapping(value = "/updatePallet.json")
    @ResponseBody
	public Map<String, Object> updatePallet(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
    	System.out.println("BoardController.updatePallet");
    	Map<String,Object> result = new HashMap<>();
    	Util.pramsNullCheck(params);
    	result = boardService.updatePallet(params);
    	return result;
    }



}
