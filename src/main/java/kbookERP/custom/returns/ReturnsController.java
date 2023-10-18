package kbookERP.custom.returns;

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
@RequestMapping("/returns")
public class ReturnsController {

	@Autowired
	private ReturnsService returnsService;




	@PostMapping(value = "/getBookList4Return.json")
    @ResponseBody
	public Map<String, Object> getBookList4Return(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("ReturnsController.getBookList4Return");
		Util.pramsNullCheck(params);

        return returnsService.getBookList4Return(params);
    }

	@PostMapping(value = "/getReturnBookList.json")
    @ResponseBody
	public Map<String, Object> getReturnBookList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("ReturnsController.getReturnBookList");
		Util.pramsNullCheck(params);

        return returnsService.getReturnBookList(params);
    }

	@PostMapping(value = "/getPurchaseRate.json")
    @ResponseBody
	public Map<String, Object> getPurchaseRate(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("ReturnsController.getPurchaseRate");
		Util.pramsNullCheck(params);

        return returnsService.getPurchaseRate(params);
    }

	@PostMapping(value = "/insertReturnBook.json")
    @ResponseBody
	public Map<String, Object> insertReturnBook(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("ReturnsController.insertReturnBook");
		Util.pramsNullCheck(params);

        return returnsService.insertReturnBook(params);
    }

	@PostMapping(value = "/getPurchInfo4return.json")
    @ResponseBody
	public Map<String, Object> getPurchInfo4return(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("ReturnsController.getPurchInfo4return");
		Util.pramsNullCheck(params);

        return returnsService.getPurchInfo4return(params);
    }

	@PostMapping(value = "/getGroupInfo4return.json")
    @ResponseBody
	public Map<String, Object> getGroupInfo4return(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("ReturnsController.getGroupInfo4return");
		Util.pramsNullCheck(params);

        return returnsService.getGroupInfo4return(params);
    }

	@PostMapping(value = "/getStoreInfo4return.json")
    @ResponseBody
	public Map<String, Object> getStoreInfo4return(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("ReturnsController.getStoreInfo4return");
		Util.pramsNullCheck(params);

        return returnsService.getStoreInfo4return(params);
    }

	@PostMapping(value = "/saveReturnBook.json")
    @ResponseBody
	public Map<String, Object> saveReturnBook(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("ReturnsController.saveReturnBook");
		Util.pramsNullCheck(params);

        return returnsService.saveReturnBook(params);
    }

	@PostMapping(value = "/confirmReturnBook.json")
    @ResponseBody
	public Map<String, Object> confirmReturnBook(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("ReturnsController.confirmReturnBook");
		Util.pramsNullCheck(params);

        return returnsService.confirmReturnBook(params);
    }

}






















