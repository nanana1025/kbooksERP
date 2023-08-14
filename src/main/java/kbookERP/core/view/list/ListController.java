package kbookERP.core.view.list;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Predicate;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.mybatis.spring.SqlSessionTemplate;
import org.reflections.Reflections;
import org.reflections.scanners.SubTypesScanner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.ClassUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import kbookERP.core.view.data.DataMapper;
import kbookERP.core.xmlvo.chart.Chart;
import kbookERP.core.xmlvo.data.DataRoot;
import kbookERP.core.xmlvo.list.Col;
import kbookERP.core.xmlvo.list.Columns;
import kbookERP.core.xmlvo.list.ListRoot;
import kbookERP.core.xmlvo.tree.Tree;
import kbookERP.custom.util.Util;
import kbookERP.util.Utils;
import kbookERP.util.constant.Cubrid;
import kbookERP.util.constant.MariaDB;
import kbookERP.util.constant.Oracle;
import kbookERP.util.map.CustomMapUtil;
import kbookERP.util.map.LowerKeyMap;
import kbookERP.util.map.UMap;

@Controller
public class ListController {

}
