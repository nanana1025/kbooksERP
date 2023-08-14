package com.dacare.core.view.list;

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

import com.dacare.core.view.data.DataMapper;
import com.dacare.core.xmlvo.chart.Chart;
import com.dacare.core.xmlvo.data.DataRoot;
import com.dacare.core.xmlvo.list.Col;
import com.dacare.core.xmlvo.list.Columns;
import com.dacare.core.xmlvo.list.ListRoot;
import com.dacare.core.xmlvo.tree.Tree;
import com.dacare.custom.util.Util;
import com.dacare.util.Utils;
import com.dacare.util.constant.Cubrid;
import com.dacare.util.constant.MariaDB;
import com.dacare.util.constant.Oracle;
import com.dacare.util.map.CustomMapUtil;
import com.dacare.util.map.LowerKeyMap;
import com.dacare.util.map.UMap;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@Controller
public class ListController {

}
