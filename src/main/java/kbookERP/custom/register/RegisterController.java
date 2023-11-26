package kbookERP.custom.register;

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
@RequestMapping("/regist")
public class RegisterController {

	@Autowired
	private RegisterService registerService;


	@PostMapping(value = "/getNewBookCd.json")
    @ResponseBody
	public Map<String, Object> getNewBookCd(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.getNewBookCd");
		Util.pramsNullCheck(params);

        return registerService.getNewBookCd(params);
    }

	@PostMapping(value = "/getBookRegistInfo.json")
    @ResponseBody
	public Map<String, Object> getBookRegistInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.getBookRegistInfo");
		Util.pramsNullCheck(params);

        return registerService.getBookRegistInfo(params);
    }

	@PostMapping(value = "/deleteBookInfo.json")
    @ResponseBody
	public Map<String, Object> deleteBookInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.deleteBookInfo");
		Util.pramsNullCheck(params);

        return registerService.deleteBookInfo(params);
    }

	@PostMapping(value = "/updateBookInfo.json")
    @ResponseBody
	public Map<String, Object> updateBookInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.updateBookInfo");
		Util.pramsNullCheck(params);

        return registerService.updateBookInfo(params);
    }

	@PostMapping(value = "/insertBookInfo.json")
    @ResponseBody
	public Map<String, Object> insertBookInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.insertBookInfo");
		Util.pramsNullCheck(params);

        return registerService.insertBookInfo(params);
    }

	@PostMapping(value = "/getPurchaseInfo.json")
    @ResponseBody
	public Map<String, Object> getPurchaseInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.getPurchaseInfo");
		Util.pramsNullCheck(params);

        return registerService.getPurchaseInfo(params);
    }

	@PostMapping(value = "/deletePurchaseInfo.json")
    @ResponseBody
	public Map<String, Object> deletePurchaseInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.deletePurchaseInfo");
		Util.pramsNullCheck(params);

        return registerService.deletePurchaseInfo(params);
    }

	@PostMapping(value = "/updatePurchaseInfo.json")
    @ResponseBody
	public Map<String, Object> updatePurchaseInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.updatePurchaseInfo");
		Util.pramsNullCheck(params);

        return registerService.updatePurchaseInfo(params);
    }

	@PostMapping(value = "/insertPurchaseInfo.json")
    @ResponseBody
	public Map<String, Object> insertPurchaseInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.insertPurchaseInfo");
		Util.pramsNullCheck(params);

        return registerService.insertPurchaseInfo(params);
    }

	@PostMapping(value = "/getPublishInfo.json")
    @ResponseBody
	public Map<String, Object> getPublishInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.getPublishInfo");
		Util.pramsNullCheck(params);

        return registerService.getPublishInfo(params);
    }

	@PostMapping(value = "/insertPublishInfo.json")
    @ResponseBody
	public Map<String, Object> insertPublishInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.insertPublishInfo");
		Util.pramsNullCheck(params);

        return registerService.insertPublishInfo(params);
    }

	@PostMapping(value = "/updatePublishInfo.json")
    @ResponseBody
	public Map<String, Object> updatePublishInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.updatePublishInfo");
		Util.pramsNullCheck(params);

        return registerService.updatePublishInfo(params);
    }

	@PostMapping(value = "/deletePublishInfo.json")
    @ResponseBody
	public Map<String, Object> deletePublishInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.deletePublishInfo");
		Util.pramsNullCheck(params);

        return registerService.deletePublishInfo(params);
    }

	@PostMapping(value = "/getHolidayData.json")
    @ResponseBody
	public Map<String, Object> getHolidayData(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.getHolidayData");
		Util.pramsNullCheck(params);

        return registerService.getHolidayData(params);
    }

	@PostMapping(value = "/insertHolidayData.json")
    @ResponseBody
	public Map<String, Object> insertHolidayData(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.insertHolidayData");
		Util.pramsNullCheck(params);

        return registerService.insertHolidayData(params);
    }

	@PostMapping(value = "/updateHolidayData.json")
    @ResponseBody
	public Map<String, Object> updateHolidayData(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.updateHolidayData");
		Util.pramsNullCheck(params);

        return registerService.updateHolidayData(params);
    }


	@PostMapping(value = "/getReturnInfo.json")
    @ResponseBody
	public Map<String, Object> getReturnInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.getReturnInfo");
		Util.pramsNullCheck(params);

        return registerService.getReturnInfo(params);
    }

	@PostMapping(value = "/updateReturnInfo.json")
    @ResponseBody
	public Map<String, Object> updateReturnInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.updateReturnInfo");
		Util.pramsNullCheck(params);

        return registerService.updateReturnInfo(params);
    }

	@PostMapping(value = "/insertReturnInfo.json")
    @ResponseBody
	public Map<String, Object> insertReturnInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.insertReturnInfo");
		Util.pramsNullCheck(params);

        return registerService.insertReturnInfo(params);
    }

	@PostMapping(value = "/deleteReturnInfo.json")
    @ResponseBody
	public Map<String, Object> deleteReturnInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.deleteReturnInfo");
		Util.pramsNullCheck(params);

        return registerService.deleteReturnInfo(params);
    }






















	@PostMapping(value = "/getGroupInfo4return.json")
    @ResponseBody
	public Map<String, Object> getGroupInfo4return(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.getGroupInfo4return");
		Util.pramsNullCheck(params);

        return registerService.getGroupInfo4return(params);
    }

	@PostMapping(value = "/getStoreInfo4return.json")
    @ResponseBody
	public Map<String, Object> getStoreInfo4return(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.getStoreInfo4return");
		Util.pramsNullCheck(params);

        return registerService.getStoreInfo4return(params);
    }

	@PostMapping(value = "/saveReturnBook.json")
    @ResponseBody
	public Map<String, Object> saveReturnBook(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.saveReturnBook");
		Util.pramsNullCheck(params);

        return registerService.saveReturnBook(params);
    }

	@PostMapping(value = "/confirmReturnBook.json")
    @ResponseBody
	public Map<String, Object> confirmReturnBook(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("RegisterController.confirmReturnBook");
		Util.pramsNullCheck(params);

        return registerService.confirmReturnBook(params);
    }

}






















