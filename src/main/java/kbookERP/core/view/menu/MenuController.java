package kbookERP.core.view.menu;

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

import com.fasterxml.jackson.databind.ObjectMapper;

import kbookERP.core.xmlvo.menu.Menu;
import kbookERP.core.xmlvo.menu.MenuItem;
import kbookERP.dev.SystemController;
import kbookERP.dev.SystemService;
import kbookERP.util.Utils;
import kbookERP.util.tool.MenuAuthUtil;

@Controller
public class MenuController {

}
