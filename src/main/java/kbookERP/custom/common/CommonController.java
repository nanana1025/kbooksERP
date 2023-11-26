package kbookERP.custom.common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kbookERP.custom.util.Util;

@Controller
@RequestMapping("/common")
public class CommonController {

	@Autowired
	private CommonService commonService;


	@PostMapping(value = "/checkGroupCd.json")
    @ResponseBody
	public Map<String, Object> checkGroupCd(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
    	result = commonService.checkGroupCd(params);
    	return result;
    }

	@PostMapping(value = "/getKbooksCodeList.json")
    @ResponseBody
	public Map<String, Object> getKbooksCodeList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.getKbooksCodeList(params);

    	return result;
    }

	@PostMapping(value = "/getKbooksProductCodeList.json")
    @ResponseBody
	public Map<String, Object> getKbooksProductCodeList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
    	result = commonService.getKbooksProductCodeList(params);
    	return result;
    }


	@PostMapping(value = "/getCodeList.json")
    @ResponseBody
	public Map<String, Object> getCodeList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.getCodeList(params.get("CODE").toString());

    	return result;
    }

	@PostMapping(value = "/getCodeListTable.json")
    @ResponseBody
	public Map<String, Object> getCodeListTable(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.getCodeListTable(params);

    	return result;
    }

	@PostMapping(value = "/getTable.json")
    @ResponseBody
	public Map<String, Object> getTable(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.getTable(params);

    	return result;
    }

	@PostMapping(value = "/getCodeListCustom.json")
    @ResponseBody
	public Map<String, List<Map<String, Object>>> getCodeListCustom(HttpServletRequest req, @RequestParam Map<String, Object> params) throws Exception {

		Map<String, List<Map<String, Object>>> result = new HashMap<String, List<Map<String, Object>>>();

		Util.pramsNullCheck(params);

    	result = commonService.getCodeListCustom(params);

    	return result;
    }

	@PostMapping(value = "/executeQuery.json")
    @ResponseBody
	public Map<String, Object> executeQuery(HttpServletRequest req, @RequestParam Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.executeQuery(req, params);

    	return result;
    }

	@PostMapping(value = "/execute.json")
    @ResponseBody
	public Map<String, Object> execute(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.execute(params);

    	return result;
    }

	@PostMapping(value = "/queryDT.json")
	 @ResponseBody
		public Map<String, Object> queryDT(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {


		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

   	result = commonService.queryDT(params);

   	return result;
   }

	@PostMapping(value = "/getRow.json")
	 @ResponseBody
		public Map<String, Object> getRow(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
		result = commonService.getRow(params);
		return result;
  }







	@PostMapping(value = "/getVisibleCol.json")
    @ResponseBody
	public Map<String, Object> updateWarehousingAdjustmentState(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

    	System.out.println("CommonController.getVisibleCol");
    	Map<String,Object> result = new HashMap<>();

		Util.pramsNullCheck(params);

    	result = commonService.getVisibleCol(req, params);

    	return result;
    }


	@PostMapping(value = "/updateVisibleCol.json")
    @ResponseBody
	public Map<String, Object> updateVisibleCol(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

    	System.out.println("CommonController.updateVisibleCol");
    	Map<String,Object> result = new HashMap<>();

		Util.pramsNullCheck(params);

    	result = commonService.updateVisibleCol(req, params);

    	return result;
    }

	@PostMapping(value = "/getCodeTable.json")
    @ResponseBody
	public Map<String, Object> getCodeTable(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.getCodeTable(params);

    	return result;
    }

	@PostMapping(value = "/getCodeListTable1.json")
    @ResponseBody
	public Map<String, Object> getCodeListTable1(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.getCodeListTable1(params);

    	return result;
    }

	@PostMapping(value = "/updateCode.json")
    @ResponseBody
	public Map<String, Object> updateCode(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.updateCode(params);

    	return result;
    }

	@PostMapping(value = "/updateCodeList.json")
    @ResponseBody
	public Map<String, Object> updateCodeList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.updateCodeList(params);

    	return result;
    }

	@PostMapping(value = "/createCode.json")
    @ResponseBody
	public Map<String, Object> createCode(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.createCode(params);

    	return result;
    }

	@PostMapping(value = "/createCodeList.json")
    @ResponseBody
	public Map<String, Object> createCodeList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.createCodeList(params);

    	return result;
    }

	@PostMapping(value = "/deleteCode.json")
    @ResponseBody
	public Map<String, Object> deleteCode(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.deleteCode(params);

    	return result;
    }


	@PostMapping(value = "/deleteCodeList.json")
    @ResponseBody
	public Map<String, Object> deleteCodeList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		Util.pramsNullCheck(params);

    	result = commonService.deleteCodeList(params);

    	return result;
    }











}






















