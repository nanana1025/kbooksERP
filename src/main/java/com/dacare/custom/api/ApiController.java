package com.dacare.custom.api;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dacare.custom.util.Util;

@Controller
@RequestMapping("/")
public class ApiController {

	@Autowired
	private ApiService apiService;

	@PostMapping(value = {"/sale.json", "/sale"})
	@ResponseBody
	public Map<String, Object> sale(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();

		Util.pramsNullCheck(params);

		result = apiService.sale(params);

		return result;
	}


	@PostMapping(value = {"/parameterCheck.json", "/parameterCheck"})
	@ResponseBody
	public Map<String, Object> check(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		System.out.println("check params = "+params);

//		Util.pramsNullCheck(params);

		return params;
	}


	@PostMapping(value = {"/initialize4test.json", "/initialize4test", "/initialize4Danawa"})
	@ResponseBody
	public Map<String, Object> deleteSaleExternal(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();

		Util.pramsNullCheck(params);

		result = apiService.deleteSaleExternal4Danawa(params);

		return result;
	}

	@GetMapping(value = {"/getsaleinfo4test.json", "/getsaleinfo4test", "/getsaleinfo4Danawa"})
	@ResponseBody
	public Map<String, Object> getSaleInfoNonEncrytion(HttpServletRequest req, @RequestParam Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();

		Util.pramsNullCheck(params);

		result = apiService.getSaleInfoNonEncrytion4Danawa(params);
		return result;
	}

	@PostMapping(value = {"/encryption.json", "/encryption"})
	@ResponseBody
	public Map<String, Object> encryption(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();

		Util.pramsNullCheck(params);

		result = apiService.encryption(params);

		return result;
	}

	@PostMapping(value = {"/decryption.json", "/decryption"})
	@ResponseBody
	public Map<String, Object> decryption(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();

		Util.pramsNullCheck(params);

		result = apiService.decryption(params);

		return result;
	}









	@GetMapping(value = {"/getsaleinfo.json", "/getsaleinfo"})
	@ResponseBody
	public Map<String, Object> getSaleInfo(HttpServletRequest req, @RequestParam Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();

		Util.pramsNullCheck(params);

		result = apiService.getSaleInfo(params);

		return result;
	}


	@PostMapping(value = {"/sale-external.json", "/sale-external"})
	@ResponseBody
	public Map<String, Object> saleExternal(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();

		Util.pramsNullCheck(params);

		result = apiService.saleExternal(params);

		return result;
	}

	@PostMapping(value = {"/initialize.json", "/initialize"})
	@ResponseBody
	public Map<String, Object> initialize(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();

		Util.pramsNullCheck(params);

		result = apiService.deleteSaleExternal(params);

		return result;
	}

	@PostMapping(value = {"/getsaleinfo4Dangol.json", "/getsaleinfo4Dangol"})
	@ResponseBody
	public Map<String, Object> getsaleinfo4Dangol(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		Map<String,Object> result = new HashMap<>();

		Util.pramsNullCheck(params);

		result = apiService.getSaleInfoNonEncrytion(params);

		return result;
	}


//	@GetMapping(value = "/getsaleinfo.json")
//	@GetMapping(value = {"/getsaleinformation.json", "/getsaleinformation"})
//	@ResponseBody
//	public Map<String, Object> getSaleInfos(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
//
//		Map<String,Object> result = new HashMap<>();
//
//		Util.pramsNullCheck(params);
//
//		result = apiService.getSaleInfo(params);
//
//		return result;
//	}
//	@PostMapping(value = {"/getsaleinformation1.json", "/getsaleinformation1"})
//	@ResponseBody
//	public Map<String, Object> getSaleInfoss(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
//
//		Map<String,Object> result = new HashMap<>();
//
//		Util.pramsNullCheck(params);
//
//		result = apiService.getSaleInfo(params);
//
//		return result;
//	}





//	@GetMapping(value = "/getsaleinfo4test")
//	@ResponseBody
//	public Map<String, Object> getSaleInfoNonEncrytion2(HttpServletRequest req, @RequestParam Map<String, Object> params) throws Exception {
//
//		Map<String,Object> result = new HashMap<>();
//
//		Util.pramsNullCheck(params);
//
//		result = apiService.getSaleInfoNonEncrytion(params);
//
//		return result;
//	}



	@PostMapping(value = "/test.json")
	@ResponseBody
	public Map<String, Object> test(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {

		System.out.println("ReservationController.test()");
		Map<String,Object> result = new HashMap<>();

		Util.pramsNullCheck(params);

		System.out.println("params = "+params);

		result = apiService.test( params);

		return result;
	}
}






















