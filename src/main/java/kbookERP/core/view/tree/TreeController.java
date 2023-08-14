package kbookERP.core.view.tree;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import kbookERP.core.xmlvo.chart.Chart;
import kbookERP.core.xmlvo.data.DataRoot;
import kbookERP.core.xmlvo.list.ListRoot;
import kbookERP.core.xmlvo.tree.Column;
import kbookERP.core.xmlvo.tree.Icon;
import kbookERP.core.xmlvo.tree.Icons;
import kbookERP.core.xmlvo.tree.Tree;
import kbookERP.util.Utils;
import kbookERP.util.map.LowerKeyMap;
import kbookERP.util.map.UMap;
import kbookERP.util.tool.KNullKeySerializer;

@Controller
public class TreeController {

}
