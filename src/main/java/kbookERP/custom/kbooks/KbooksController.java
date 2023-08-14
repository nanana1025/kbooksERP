package kbookERP.custom.kbooks;

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

import kbookERP.custom.util.Util;

@Controller
@RequestMapping("/kbooks")
public class KbooksController {

	@Autowired
	private KbooksService logService;

	@PostMapping(value = "/test")
    @ResponseBody
	public Map<String, Object> test(HttpServletRequest req, @RequestBody Map<String, Object> params) throws Exception {
		System.out.println("LogController.getInventoryLog");
		Util.pramsNullCheck(params);

        return logService.test(params);
    }
}






















