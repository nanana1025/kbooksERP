package com.dacare.core.view.menu;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.dacare.core.xmlvo.menu.Menu;
import com.dacare.core.xmlvo.menu.MenuItem;
import com.dacare.dev.SystemController;
import com.dacare.dev.SystemService;
import com.dacare.util.Utils;
import com.dacare.util.tool.MenuAuthUtil;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class MenuController {

}
