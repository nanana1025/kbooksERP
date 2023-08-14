package com.dacare.core.mngm;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.apache.taglibs.standard.functions.Functions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.dacare.core.files.FileController;
import com.dacare.core.files.FileMapper;
import com.dacare.core.files.FileStorageService;
import com.dacare.core.xmlvo.layout.Area;
import com.dacare.core.xmlvo.layout.Layout;
import com.dacare.dev.SystemService;
import com.dacare.util.Utils;
import com.dacare.util.map.CustomMapUtil;
import com.dacare.util.map.LowerKeyMap;
import com.dacare.util.tool.KNullKeySerializer;
import com.dacare.util.vo.User;
import com.fasterxml.jackson.databind.ObjectMapper;

public class MngmController {

}
