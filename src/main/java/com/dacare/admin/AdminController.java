package com.dacare.admin;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.dacare.core.mngm.MngmMapper;
import com.dacare.core.view.menu.MenuController;
import com.dacare.core.xmlvo.menu.Menu;
import com.dacare.core.xmlvo.menu.MenuItem;
import com.dacare.dev.SystemController;
import com.dacare.dev.SystemService;
import com.dacare.util.Utils;
import com.dacare.util.constant.Cubrid;
import com.dacare.util.constant.MariaDB;
import com.dacare.util.constant.Oracle;
import com.dacare.util.vo.User;
import com.fasterxml.jackson.databind.ObjectMapper;


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

    @Value("${spring.datasource.dbtype}")
	String dbType;


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
