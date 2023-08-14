package kbookERP.core.view.list;

import java.lang.reflect.Type;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import kbookERP.core.files.FileController;
import kbookERP.core.view.data.DataMapper;
import kbookERP.core.xmlvo.data.ColumnItem;
import kbookERP.core.xmlvo.data.DataRoot;
import kbookERP.core.xmlvo.list.Col;
import kbookERP.core.xmlvo.list.ListRoot;
import kbookERP.util.Utils;
import kbookERP.util.constant.Cubrid;
import kbookERP.util.constant.MariaDB;
import kbookERP.util.constant.Oracle;
import kbookERP.util.map.UMap;
import kbookERP.util.vo.User;

@Controller
public class BatchGridController {

}
