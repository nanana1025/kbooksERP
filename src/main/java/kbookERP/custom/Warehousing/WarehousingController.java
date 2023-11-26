package kbookERP.custom.Warehousing;

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
@RequestMapping("/warehousing")
public class WarehousingController {

	@Autowired
	private WarehousingService warehousingService;


	@PostMapping(value = "/getWarehousingBookList.json")
    @ResponseBody
	public Map<String, Object> getWarehousingBookList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("WarehousingController.getWarehousingBookList");
		Util.pramsNullCheck(params);

        return warehousingService.getWarehousingBookList(params);
	}

	@PostMapping(value = "/checkHMA12HMA08_LOG.json")
    @ResponseBody
	public Map<String, Object> checkHMA12HMA08_LOG(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("WarehousingController.checkHMA12HMA08_LOG");
		Util.pramsNullCheck(params);

        return warehousingService.checkHMA12HMA08_LOG(params);
	}


	@PostMapping(value = "/insertWarehousingBook.json")
    @ResponseBody
	public Map<String, Object> insertWarehousingBook(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("WarehousingController.insertWarehousingBook");
		Util.pramsNullCheck(params);

        return warehousingService.insertWarehousingBook(params);
	}

	@PostMapping(value = "/getPurchInfo4Warehousing.json")
    @ResponseBody
	public Map<String, Object> getPurchInfo4Warehousing(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("WarehousingController.getPurchInfo4Warehousing");
		Util.pramsNullCheck(params);

        return warehousingService.getPurchInfo4Warehousing(params);
	}

	@PostMapping(value = "/deleteWarehousingBook.json")
    @ResponseBody
	public Map<String, Object> deleteWarehousingBook(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("WarehousingController.deleteWarehousingBook");
		Util.pramsNullCheck(params);

        return warehousingService.deleteWarehousingBook(params);
	}

	@PostMapping(value = "/confirmWarehousingBook.json")
    @ResponseBody
	public Map<String, Object> confirmWarehousingBook(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("WarehousingController.confirmWarehousingBook");
		Util.pramsNullCheck(params);

        return warehousingService.confirmWarehousingBook(params);
	}

	@PostMapping(value = "/getWarehousingBookList4Barcode.json")
    @ResponseBody
	public Map<String, Object> getWarehousingBookList4Barcode(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("WarehousingController.getWarehousingBookList4Barcode");
		Util.pramsNullCheck(params);

        return warehousingService.getWarehousingBookList4Barcode(params);
	}

	@PostMapping(value = "/updateWarehousingBookList4Barcode.json")
    @ResponseBody
	public Map<String, Object> updateWarehousingBookList4Barcode(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("WarehousingController.updateWarehousingBookList4Barcode");
		Util.pramsNullCheck(params);

        return warehousingService.updateWarehousingBookList4Barcode(params);
	}



























}




















