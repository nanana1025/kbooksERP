package kbookERP.custom.search;

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
@RequestMapping("/search")
public class SearchController {

	@Autowired
	private SearchService searchService;

	@PostMapping(value = "/getSearchBookList.json")
    @ResponseBody
	public Map<String, Object> getSearchBookList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getSearchBookList");
		Util.pramsNullCheck(params);

        return searchService.getSearchBookList(params);
    }

	@PostMapping(value = "/getSearchBookList4Purchase.json")
    @ResponseBody
	public Map<String, Object> getSearchBookList4Purchase(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getSearchBookList4Purchase");
		Util.pramsNullCheck(params);

        return searchService.getSearchBookList4Purchase(params);
    }

	@PostMapping(value = "/getBookList.json")
    @ResponseBody
	public Map<String, Object> getBookList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getBookList");
		Util.pramsNullCheck(params);

        return searchService.getBookList(params);
    }



	@PostMapping(value = "/getNewBooksList.json")
    @ResponseBody
	public Map<String, Object> getNewBooksList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getNewBooksList");
		Util.pramsNullCheck(params);

        return searchService.getNewBooksList(params);
    }

	@PostMapping(value = "/getBestSellerBooksList.json")
    @ResponseBody
	public Map<String, Object> getBestSellerBooksList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getBestSellerBooksList");
		Util.pramsNullCheck(params);

        return searchService.getBestSellerBooksList(params);
    }

	@PostMapping(value = "/getBookInfoDetail.json")
    @ResponseBody
	public Map<String, Object> getBookInfoDetail(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getBookInfoDetail");
		Util.pramsNullCheck(params);

        return searchService.getBookInfoDetail(params);
    }

	@PostMapping(value = "/getShopBookInfoDetail.json")
    @ResponseBody
	public Map<String, Object> getShopBookInfoDetail(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getShopBookInfoDetail");
		Util.pramsNullCheck(params);

        return searchService.getShopBookInfoDetail(params);
    }

	@PostMapping(value = "/getPurchaseList.json")
    @ResponseBody
	public Map<String, Object> getPurchaseList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getPurchaseList");
		Util.pramsNullCheck(params);

        return searchService.getPurchaseList(params);
    }

	@PostMapping(value = "/getPurchaseList4Order.json")
    @ResponseBody
	public Map<String, Object> getPurchaseList4Order(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getPurchaseList4Order");
		Util.pramsNullCheck(params);

        return searchService.getPurchaseList4Order(params);
    }

	@PostMapping(value = "/getPublisherList.json")
    @ResponseBody
	public Map<String, Object> getPublisherList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getPublisherList");
		Util.pramsNullCheck(params);

        return searchService.getPublisherList(params);
    }

	@PostMapping(value = "/getBookPurchasInfo.json")
    @ResponseBody
	public Map<String, Object> getBookPurchasInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getBookPurchasInfo");
		Util.pramsNullCheck(params);

        return searchService.getBookPurchasInfo(params);
    }

	@PostMapping(value = "/getSearchPublisherOutcome.json")
    @ResponseBody
	public Map<String, Object> getSearchPublisherOutcome(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getSearchPublisherOutcome");
		Util.pramsNullCheck(params);

        return searchService.getSearchPublisherOutcome(params);
    }

	@PostMapping(value = "/getPurchaseDetail.json")
    @ResponseBody
	public Map<String, Object> getPurchaseDetail(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getPurchaseDetail");
		Util.pramsNullCheck(params);

        return searchService.getPurchaseDetail(params);
    }

	@PostMapping(value = "/getOrderBookPurchRate.json")
    @ResponseBody
	public Map<String, Object> getOrderBookPurchRate(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getOrderBookPurchRate");
		Util.pramsNullCheck(params);

        return searchService.getOrderBookPurchRate(params);
    }

	@PostMapping(value = "/getOrderBookCntInfo.json")
    @ResponseBody
	public Map<String, Object> getOrderBookCntInfo(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.getOrderBookCntInfo");
		Util.pramsNullCheck(params);

        return searchService.getOrderBookCntInfo(params);
    }

	@PostMapping(value = "/checkHMA02.json")
    @ResponseBody
	public Map<String, Object> checkHMA02(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("SearchController.checkHMA02");
		Util.pramsNullCheck(params);

        return searchService.checkHMA02(params);
    }














//	@PostMapping(value = "/getSaleDataList.json")
//    @ResponseBody
//	public Map<String, Object> getSaleDataList(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
//		System.out.println("SearchController.getSaleDataList");
//		Util.pramsNullCheck(params);
//
//        return searchService.getSaleDataList(params);
//    }

}






















