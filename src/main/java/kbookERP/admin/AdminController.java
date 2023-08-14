package kbookERP.admin;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kbookERP.core.mngm.MngmMapper;
import kbookERP.core.view.menu.MenuController;
import kbookERP.dev.SystemController;
import kbookERP.dev.SystemService;


@Controller
public class AdminController {
    @Autowired
    SystemService systemService;

    @Autowired
    MngmMapper mngmMapper;

    @Autowired
    AdminMapper adminMapper;

    @Autowired
    AdminService adminService;

    @Autowired
    private MenuController menuController;

    @Autowired
    private Environment env;

//    @Value("${spring.datasource.dbtype}")
//	String dbType;


	@RequestMapping(value = "/main.do")
    public String admLogin(HttpServletRequest request, @RequestParam Map<String,Object> params, Model model) throws Exception {
        Map<String,Object> sysInfo = SystemController.SYSTEM_INFO;

//        System.out.println("111111111111111111111");
//        if(sysInfo.isEmpty()) {
//            throw new Exception("등록된 시스템 정보가 없습니다.");
//        } else {
//            model.addAttribute("sysInfo",sysInfo);
//        }
//
//        if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//            return "redirect:/admin/layout.do?xn=MAIN_LAYOUT";
//        } else {
        	return "reservation/reservation";
//        }

    }

}
