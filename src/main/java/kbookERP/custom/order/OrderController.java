package kbookERP.custom.order;

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
@RequestMapping("/order")
public class OrderController {

	@Autowired
	private OrderService orderService;

	@PostMapping(value = "/getSaleDataList.json")
    @ResponseBody
	public Map<String, Object> getSaleDataList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("OrderController.getSaleDataList");
		Util.pramsNullCheck(params);

        return orderService.getSaleDataList(params);
    }

	@PostMapping(value = "/getBookOrderInfo.json")
    @ResponseBody
	public Map<String, Object> getBookOrderInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("OrderController.getBookOrderInfo");
		Util.pramsNullCheck(params);

        return orderService.getBookOrderInfo(params);
    }



	@PostMapping(value = "/getOrderDataList.json")
    @ResponseBody
	public Map<String, Object> getOrderDataList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("OrderController.getOrderDataList");
		Util.pramsNullCheck(params);

        return orderService.getOrderDataList(params);
    }

	@PostMapping(value = "/checkPurchCd.json")
    @ResponseBody
	public Map<String, Object> checkPurchCd(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
    	result = orderService.checkPurchCd(params);
    	return result;
    }

	@PostMapping(value = "/insertOrderBook.json")
    @ResponseBody
	public Map<String, Object> insertOrderBook(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
    	result = orderService.insertOrderBook(params);
    	return result;
    }

	@PostMapping(value = "/insertOrderBookBySaleData.json")
    @ResponseBody
	public Map<String, Object> insertOrderBookBySaleData(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
    	result = orderService.insertOrderBookBySaleData(params);
    	return result;
    }

	@PostMapping(value = "/deleteOrderBookInfo.json")
    @ResponseBody
	public Map<String, Object> deleteOrderBookInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
    	result = orderService.deleteOrderBookInfo(params);
    	return result;
    }

	@PostMapping(value = "/updateOrderBookInfo.json")
    @ResponseBody
	public Map<String, Object> updateOrderBookInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
    	result = orderService.updateOrderBookInfo(params);
    	return result;
    }

	@PostMapping(value = "/confirmOrderBookList.json")
    @ResponseBody
	public Map<String, Object> confirmOrderBookList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
    	result = orderService.confirmOrderBookList(params);
    	return result;
    }

	@PostMapping(value = "/clearOrderBook.json")
    @ResponseBody
	public Map<String, Object> clearOrderBook(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
    	result = orderService.clearOrderBook(params);
    	return result;
    }

	@PostMapping(value = "/getUnregisteredBookList.json")
    @ResponseBody
	public Map<String, Object> getUnregisteredBookList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
    	result = orderService.getUnregisteredBookList(params);
    	return result;
    }

	@PostMapping(value = "/insertUnregisterdOrderBook.json")
    @ResponseBody
	public Map<String, Object> insertUnregisterdOrderBook(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
    	result = orderService.insertUnregisterdOrderBook(params);
    	return result;
    }

	@PostMapping(value = "/getOrderBookAllList.json")
    @ResponseBody
	public Map<String, Object> getOrderBookAllList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Util.pramsNullCheck(params);
    	result = orderService.getOrderBookAllList(params);
    	return result;
    }

	@PostMapping(value = "/getOrderDataReport.json")
    @ResponseBody
	public Map<String, Object> getOrderDataReport(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("OrderController.getOrderDataReport");
		Util.pramsNullCheck(params);

        return orderService.getOrderDataReport(params);
    }









}






















