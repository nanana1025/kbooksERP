package com.dacare.core.view.data;

import java.io.File;
import java.lang.reflect.Type;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.ctc.wstx.util.StringUtil;
import com.dacare.core.files.FileController;
import com.dacare.core.xmlvo.data.ColumnItem;
import com.dacare.core.xmlvo.data.DataRoot;
import com.dacare.util.Utils;
import com.dacare.util.constant.Cubrid;
import com.dacare.util.constant.MariaDB;
import com.dacare.util.constant.Oracle;
import com.dacare.util.map.UMap;
import com.dacare.util.vo.User;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;

@Controller
public class DataController {



//
//	  @GetMapping("/dataView.json")
//	  @ResponseBody
//	  public String dataViewJson(HttpServletRequest request, @RequestParam Map<String, Object> params) throws Exception {
//	      String fileName = params.get("xn").toString().trim() + ".xml";
//	      fileName = fileName.replaceAll("(?i)LIST", "DATA");
//	      String filePath = Utils.getFilePath(fileName);
//	      if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//	    	  filePath = Utils.getAdmXmlPath(fileName);
//	      }
//	      if (!Utils.fileCheck(filePath)) {
//	          throw new Exception("등록된 DATA XML 파일이 없습니다.");
//	      }
//	      DataRoot dataObject = Utils.getDataXmlToObject(filePath);
//	      int division = 1;
//	      division = dataObject.getDivision();
//
//	      if (params.get("xn") == null || "".equals(params.get("xn").toString())) {
//	          throw new Exception("============ [xn is null] ============");
//	      }
//
//	      Map<String, Object> rtnMap = new HashMap<>();
//	      List<String> fileList = new ArrayList<String>();
//
//	      List<ColumnItem> columns = dataObject.getColumns().getCols();
//	      ArrayList<String> eventCols = new ArrayList<String>();
//
//	      Map<String, Object> sParam = new HashMap<>();
//	      sParam.put("mainSql", dataObject.getSql());
//	      if(StringUtils.isEmpty(dataObject.getSql())) {
//	    	  if("CUBRID".equalsIgnoreCase(dbType)) {
//	    		  sParam.put("mainSql", Cubrid.DUMMY);
//	    	  } else if("ORACLE".equalsIgnoreCase(dbType)) {
//	    		  sParam.put("mainSql", Oracle.DUMMY);
//	    	  } else if("MARIADB".equalsIgnoreCase(dbType)) {
//	    		  sParam.put("mainSql", MariaDB.DUMMY);
//	    	  }
//	      }
//	      boolean test = false;
//	      if(Cubrid.DUMMY.equals(sParam.get("mainSql"))||Oracle.DUMMY.equals(sParam.get("mainSql"))||MariaDB.DUMMY.equals(sParam.get("mainSql"))) {
//	    	  test = true;
//	      }
//
//	      String chkGroupLabel = "";
//	      boolean chkGroupEnd = false;
//
//	      String whereCon = " 1=1 ";
//
//	      if(!test) {
//		      if (dataObject.getObject() != null && !"".equals(dataObject.getObject())) {
//		    	  int idx = 0;
//		          for (String oid : dataObject.getObject().split(",")) {
//		              if (params.get(oid) != null) {
//		                  whereCon += "AND " + oid + "= '" + Utils.decodeJavascriptString((String) params.get(oid)) + "' ";
//		              } else {
//		            	  if(StringUtils.isNotBlank(dataObject.getValue())) {
//		            		  String[] value = dataObject.getValue().split(",");
//		            		  whereCon += "AND " + oid + "= '"+value[idx]+"' ";
//		            	  } else if (params.get("cobjectid") == null) {
//		                      whereCon += "AND " + oid + "= '' ";
//		                  }
//		              }
//		              idx++;
//		          }
//		      }
//
//		      if (params.get("cobjectid") != null) {
//		          String[] cobjids = params.get("cobjectid").toString().split(",");
//		          String[] cobjvals = params.get("cobjectval").toString().split(",");
//
//		          int N = cobjids.length <= cobjvals.length ? cobjids.length:cobjvals.length;
//
//		          for (int i = 0; i < N; i++) {
//		              whereCon += " AND " + cobjids[i] + "=" + "'" + cobjvals[i] + "' ";
//		          }
//		      }
//	      }
//
//	      sParam.put("where", whereCon);
//
//	      Map<String, Object> sResult = dataMapper.getDataViewByXml(sParam);
//	      UMap test111 = new UMap(sResult);
//
//	      params.put("CLASS_NAME", dataObject.getTable());
//	      List<UMap> attrList = new ArrayList<UMap>();
//	      if("CUBRID".equalsIgnoreCase(dbType)) {
//	    	  attrList = dataMapper.getColAttr(params);
//	      } else if("ORACLE".equalsIgnoreCase(dbType)) {
//	    	  attrList = dataMapper.getOracleColAttr(params);
//	      }else if("MARIADB".equalsIgnoreCase(dbType)) {
//	    	  attrList = dataMapper.getMariaDBColAttr(params);
//	      }
//
//	      if(dataObject.getTable1() != null && dataObject.getTable1().length() > 0)
//	      {
//	    	  Map<String, Object> newParam = new HashMap<String, Object> ();
//
//	    	  newParam.put("CLASS_NAME", dataObject.getTable1());
//	    	  List<UMap> attrList1 = new ArrayList<UMap>();
//		      if("CUBRID".equalsIgnoreCase(dbType)) {
//		    	  attrList1 = dataMapper.getColAttr(newParam);
//		      } else if("ORACLE".equalsIgnoreCase(dbType)) {
//		    	  attrList1 = dataMapper.getOracleColAttr(newParam);
//		      }else if("MARIADB".equalsIgnoreCase(dbType)) {
//		    	  attrList1 = dataMapper.getMariaDBColAttr(newParam);
//		      }
//
//		      for(UMap map : attrList1){
//		    	  String key = map.getStr("ATTR_NAME");
//
//		    	  boolean isNotContains = true;
//
//		    	  for(UMap map1 : attrList){
//		    		  String key1 = map1.getStr("ATTR_NAME");
//
//		    		  if(key.equals(key1)){
//		    			  isNotContains = false;
//		    			  break;
//		    		  }
//			      }
//
//		    	  if(isNotContains){
//		    		  attrList.add(map);
//		    	  }
//		      }
//	      }
//
////	      System.out.println("params111111111111 = "+params);
//
//	      String html = "";
//	      int count = 0;
//	      int colCnt = 0;
//	      boolean colSpan = false;
//	      colloop : for (ColumnItem col : columns) {
//	    	  String normFormatter = col.getFormatter();
//	          String eventHml = "";
//	          colSpan = false;
//	          if("pwInit".equals(normFormatter)) {
//	        	  eventHml += "<button type='button' class='k-button' style='width:105px;' onclick='javascript:fnPasswordInit();'>비밀번호 초기화</button>";
//	        	  eventHml += "<script>function fnPasswordInit(){\r\n" +
//	        	  		"								if($(\"#login_id\").prop(\"disabled\")) {\r\n" +
//	        	  		"									return;\r\n" +
//	        	  		"								}\r\n" +
//	        	  		"								var userId = $(\"#user_id\").val();\r\n" +
//	        	  		"								if(userId) {\r\n" +
//	        	  		"									$.ajax({\r\n" +
//	        	  		"										url : '/admin/pwInit.json',\r\n" +
//	        	  		"										data : {user_id : $('#user_id').val()},\r\n" +
//	        	  		"										success : function(data) {\r\n" +
//	        	  		"											if(data.success) {\r\n" +
//	        	  		"												GochigoAlert(data.rtnMsg);\r\n" +
//	        	  		"											} else {\r\n" +
//	        	  		"												GochigoAlert(data.rtnMsg);\r\n" +
//	        	  		"											}\r\n" +
//	        	  		"										}\r\n" +
//	        	  		"									});\r\n" +
//	        	  		"								} else {\r\n" +
//	        	  		"									GochigoAlert(\"선택된 항목이 없습니다.\");\r\n" +
//	        	  		"									return;\r\n" +
//	        	  		"								}\r\n" +
//	        	  		"							}</script>";
//	          } else if("idCheck".equals(normFormatter)) {
//	        	  eventHml += "<button type='button' class='k-button' style='width:105px;' onclick='javascript:idCheckBtnClick();'>아이디 중복검사</button>";
//	        	  eventHml += "<script>function idCheckBtnClick(){\r\n" +
//	        	  		"								if($(\"#login_id\").prop(\"disabled\")) {\r\n" +
//	        	  		"									return;\r\n" +
//	        	  		"								}\r\n" +
//	        	  		"								if($(\"#login_id\").val()=='' || $(\"#login_id\").val() == null){\r\n" +
//	        	  		"									GochigoAlert('아이디를 입력해주세요');\r\n" +
//	        	  		"									return;\r\n" +
//	        	  		"								}\r\n" +
//	        	  		"								$.ajax({\r\n" +
//	        	  		"									url : '/admin/idCheck.json',\r\n" +
//	        	  		"									data : {login_id : $('#login_id').val()},\r\n" +
//	        	  		"									success : function(data) {\r\n" +
//	        	  		"										if(data.success) {\r\n" +
//	        	  		"											GochigoAlert(data.rtnMsg);\r\n" +
//	        	  		"										} else {\r\n" +
//	        	  		"											GochigoAlert(data.rtnMsg);\r\n" +
//	        	  		"											$('#login_id').val('').focus();\r\n" +
//	        	  		"										}\r\n" +
//	        	  		"									}\r\n" +
//	        	  		"								});\r\n" +
//	        	  		"							}</script>";
//	          }
//	          if(StringUtils.isNotBlank(col.getFormatter())) {
//	        	  try {
//			          Gson formatGson = new Gson();
//		              Type frmModelType = new TypeToken<HashMap<String,Object>>() {}.getType();
//		              HashMap<String,Object> jsonFormatter = formatGson.fromJson( col.getFormatter(), frmModelType);
//		              String formatType = (String)jsonFormatter.get("type");
//		              if("url".equals(formatType)){
//		            	  String formatUrl = (String)jsonFormatter.get("url");
//		            	  String callbackName = "fnLinkCallback_"+col.getId();
//		            	  String size = (String)jsonFormatter.get("size");
//		            	  if(StringUtils.isNotBlank(size)) {
//		            		  size = size.toUpperCase();
//		            	  }
//		            	  eventHml += "<span class='k-icon k-i-windows' onclick='javascript:fnObj(\"CRUD_"+params.get("sid")+"\").fnWindowOpen(\""+formatUrl+"\",\""+callbackName+"\",\""+size+"\");'></span>";
//		            	  eventHml += "<script>function "+callbackName+"(data){\r\n" +
//	  	        	  		          "	if(data) {\r\n";
//    	  		          if("select".equals(col.getType())) {
//    	  		        	  eventHml += "var dropdownlist = $(\"#"+col.getId()+"\").data(\"kendoDropDownList\");\r\n" +
//    	  		        	  		"dropdownlist.select(function(dataItem) {\r\n" +
//    	  		        	  		"    return dataItem.value === data."+col.getId()+";\r\n" +
//    	  		        	  		"});";
//    	  		          } else {
//    	  		        	  eventHml += "console.log(data);\r\n";
//    	  		        	  eventHml += "$('#"+col.getId()+"').val(data."+col.getId()+")\r\n";
//    	  		          }
//	  	        	  	   eventHml +=" }\r\n" +
//	  	        	  		          "	}</script>";
//		              }
//	        	  }catch(IllegalStateException e) {
//	        		  System.out.println("NOT JSON Formatter");
//		          }catch(JsonSyntaxException e) {
//		        	  System.out.println("NOT JSON Formatter");
//		          }
//	          }
//
//
//	          String hideClass = "";
//	          String fileClass = "";
//
//	          if ("Y".equals(col.getHidden()) || Utils.nvl(col.getInit()) != "") {
//	              hideClass = "display:none;";
//	          }
//
//	          if ("file".equals(col.getType())) {
//	              fileClass = "file";
//	          }
//
//	          if (count == 0) {
//	        	  if(division == 1) {
//	        		  html += "<tr style='" + hideClass + "' class='" + fileClass + "'>";
//	        	  } else if(division == 2) {
//	        		  if(colCnt == 0) {
//	        			  html += "<tr style='" + hideClass + "' class='" + fileClass + "'>";
//	        		  }
//	        	  }
//	          }
//
//	          if("BLANK".equalsIgnoreCase(col.getClassType())) {
//        		  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//                  html += "<td style='text-align:right;'></td>";
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += " </td>";
//        	  } else if("LINE".equalsIgnoreCase(col.getClassType())) {
//        		  if(division ==2) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//                  html += "<td style='text-align:center;background-image: url(\"/codebase/imgs/line.png\");background-repeat-y:no-repeat;background-repeat:repeat-x;background-position-y:center;'><span class='data_line'>"+Utils.nvl(col.getValue())+"</span></td>";
//                  if(division ==2) {
//              		  html += "<td colspan='3' style='background-image: url(\"/codebase/imgs/line.png\");background-repeat-y:no-repeat;background-repeat:repeat-x;background-position-y:center;'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td style='background-image: url(\"/codebase/imgs/line.png\");background-repeat-y:no-repeat;background-repeat:repeat-x;background-position-y:center;>";
//	              }
//
//	              html += "</td>";
//        	  }
//
//	          if ("checkbox".equals(col.getType())) {
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              String _chkVal = col.getDefault();
//	              String _val = Utils.nvl(sResult.get(col.getId().toLowerCase()));
//	              chkGroupLabel = col.getGroupLabel();
//	              if(StringUtils.isEmpty(chkGroupLabel)) {
//		              if ("Y".equals(col.getRequired())) {
//		                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//		              } else {
//		                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//		              }
//		              if("Y".equals(col.getColSpan())) {
//	              		  html += "<td colspan='3'>";
//	              		  colSpan = true;
//		              } else {
//		            	  html += "<td>";
//		              }
//		              html += "<input type='checkbox' ";
//		              html += "id='" + col.getId() + "' name='" + col.getId() + "' class='view' ";
//		              if (_val.equals(_chkVal)) {
//		                  html += "checked='checked' ";
//		              } else {
//		              }
//
//	//	              html += "style='width:" + col.getWidth() + ";' ";
//		              if(StringUtils.isNotBlank(col.getTooltip())) {
//		            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//		              }
//		              if ("Y".equals(col.getRequired())) {
//		                  html += "required ";
//		              }
//		              boolean exclude = true;
//
//			              for(UMap e : attrList) {
//			            	  if(col.getId().equalsIgnoreCase((String)e.get("ATTR_NAME")) || col.getId().equalsIgnoreCase((String)e.get("attr_name"))) {
//			            		  exclude = false;
//			            		  break;
//			            	  }
//			              }
//			              if("S".equals(col.getEditable()))
//			            	  exclude = false;
//
//			              if(exclude) {
//			            	  col.setEditable("N");
//			            	  html += "class='exclude' disabled='disabled' ";
//			              }
//			              if ("N".equals(col.getEditable())) {
//			                  html += "readonly='readonly' ";
//			              }
//
//	              } else {
//	            	  Map<String, List<ColumnItem>> groupCheckBoxes = dataObject.getGroupCheckBoxes();
//	            	  List<ColumnItem> checkList = groupCheckBoxes.get(chkGroupLabel);
//	            	  for(int i=0; i < checkList.size(); i++) {
//	            		  if(!col.getId().equals(checkList.get(0).getId())) {
//	            			  continue colloop;
//	            		  }
//	            	  }
//	            	  html += "<td style='text-align:right;'>" + chkGroupLabel + "</td>";
//	            	  if("Y".equals(col.getColSpan())) {
//	            		  html += "<td colspan='3'>";
//	            		  colSpan = true;
//	            	  } else {
//	            		  html += "<td>";
//	            	  }
//	            	  for(int i=0; i < checkList.size(); i++) {
//	            		  ColumnItem item = checkList.get(i);
//
//	            		  String chkSelCol = item.getId();
//	            		  String chkVal = item.getDefault();
//	            		  String val = Utils.nvl(sResult.get(item.getId().toLowerCase()));
//
//	            		  if (StringUtils.isNotBlank(chkSelCol) && chkSelCol.contains(".")) {
//	        	              chkSelCol = chkSelCol.substring(chkSelCol.indexOf(".") + 1, chkSelCol.length());
//	        	          }
//	            		  html += "<input type='checkbox' ";
//			              html += "id='" + chkSelCol + "' name='" + chkSelCol + "' class='view' ";
//			              html += "value='" + _chkVal + "'";
//			              if (val.equals(chkVal)) {
//			                  html += "checked='checked' ";
//			              }
//
//			              if(StringUtils.isNotBlank(item.getTooltip())) {
//			            	  html += "data-tooltip='"+item.getTooltip()+"' ";
//			              }
//			              if ("Y".equals(item.getRequired())) {
//			                  html += "required ";
//			              }
//			              boolean exclude = true;
//
//			              for(UMap e : attrList) {
//			            	  if(chkSelCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || chkSelCol.equalsIgnoreCase((String)e.get("attr_name"))) {
//			            		  exclude = false;
//			            		  break;
//			            	  }
//			              }
//
//			              if("S".equals(col.getEditable()))
//			            	  exclude = false;
//
//			              if(exclude) {
//			            	  item.setEditable("N");
//			            	  html += "class='exclude' ";
//			              }
//			              if ("N".equals(item.getEditable())) {
//			                  html += "readonly='readonly' ";
//			              }
//
//		        		  html += "/>";
//		        		  html += "<label for='"+chkSelCol+"'>" + item.getValue() + "</label>&nbsp;&nbsp;";
//	            	  }
//	            	  html += "</td>";
//	              }
//	          } else if ("select".equals(col.getType())) {
//	              Map<String, Object> _param = new HashMap<>();
//	              Gson gson = new Gson();
//                  Type modelType = new TypeToken<HashMap<String,Object>>() {}.getType();
//                  HashMap<String,Object> formatter = gson.fromJson( col.getFormatter(), modelType);
//                  String type = (String)formatter.get("type");
//                  List<Map<String, Object>> rslt = new ArrayList<Map<String, Object>>();;
//                  if("sql".equals(type)){
//                	  String selectSql = Utils.nvl(formatter.get("sql"));
//                	  _param.put("selectSql", selectSql);
//                	  rslt = dataMapper.getSelectComboBySql(_param);
//                  } else if("array".equals(type)){
//                	  String[] arrays = Utils.nvl(formatter.get("array")).split(";");
//                      List<Map<String,Object>> sList = new ArrayList<>();
//                      for(String val : arrays) {
//                          Map<String,Object> sMap = new HashMap<>();
//                          sMap.put("value", val.split(":")[0]);
//                          sMap.put("text", val.split(":")[1]);
//                          sList.add(sMap);
//                      }
//                      rslt = sList;
//                  }
//
//                  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<select id='" + col.getId() + "' class=\"select view\" title=\"" + col.getValue() + "\"' ";
//            	  html += "style='width:" + col.getWidth() + ";' ";
//	              if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
////	                  html += " " + Utils.nvl(col.getValidationMessage()) + " ";
//	              }
//	              boolean exclude = false;
//
//	              for(UMap e : attrList) {
//	            	  if(col.getId().equalsIgnoreCase((String)e.get("ATTR_NAME")) || col.getId().equalsIgnoreCase((String)e.get("attr_name"))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
//	              if(exclude) {
//	            	  col.setEditable("N");
////	            	  html += "class='select exclude' disabled='disabled' ";
//	              } else {
//	            	  html += "class='select' ";
//	              }
////	              if ("N".equals(col.getEditable())) {
////	                  html += "readonly='readonly' ";
////	              }
//
//	              html += "<option value=\"\">선택</option>";
//	              if (sResult != null) {
//	                  String _val = Utils.nvl(sResult.get(col.getId().toLowerCase()));
//	                  for (int i = 0; i < rslt.size(); i++) {
//	                      Map<String, Object> map = rslt.get(i);
//	                      if (_val.equals(map.get("value").toString())) {
//	                          html += "<option value=\"" + map.get("value") + "\" selected='selected'>" + map.get("text") + "</option>";
//	                      } else {
//	                          html += "<option value=\"" + map.get("value") + "\">" + map.get("text") + "</option>";
//	                      }
//	                  }
//	              } else {
//	                  for (int i = 0; i < rslt.size(); i++) {
//	                      Map<String, Object> map = rslt.get(i);
//	                      html += "<option value=\"" + map.get("value") + "\">" + map.get("text") + "</option>";
//	                  }
//	              }
//	              html += "</select>";
//
////
//	          } else if ("date".equals(col.getType())) {
//
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<input id='" + col.getId() + "' class=\"calendar view\" ";
//            	  html += "style='width:" + col.getWidth() + ";' ";
//	              if (sResult != null) {
//	                  html += "value='" + Utils.nvl(sResult.get(col.getId().toLowerCase())) + "' ";
//	              }
//	              if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              boolean exclude = true;
//
//	              for(UMap e : attrList) {
//	            	  if(col.getId().equalsIgnoreCase((String)e.get("ATTR_NAME")) || col.getId().equalsIgnoreCase((String)e.get("attr_name"))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
//	              if(exclude) {
//	            	  col.setEditable("N");
//	            	  html += "class='calendar exclude' disabled='disabled' ";
//	              } else {
//	            	  html += "class='calendar' ";
//	              }
//	              if ("N".equals(col.getEditable())) {
//	                  html += "readonly='readonly' ";
//	              }
//
//	              html += " />";
//
//	          } else if ("radio".equals(col.getType())) {
//	        	  Gson gson = new Gson();
//                  Type modelType = new TypeToken<HashMap<String,Object>>() {}.getType();
//                  HashMap<String,Object> formatter = gson.fromJson( col.getFormatter(), modelType);
//                  String type = (String)formatter.get("type");
//                  String[] arrays = null;
//                  if("array".equals(type)){
//                	  arrays = Utils.nvl(formatter.get("array")).split(";");
//                      List<Map<String,Object>> sList = new ArrayList<>();
//                      for(String val : arrays) {
//                          Map<String,Object> sMap = new HashMap<>();
//                          sMap.put("value", val.split(":")[0]);
//                          sMap.put("text", val.split(":")[1]);
//                          sList.add(sMap);
//                      }
//                  }
//
//                  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              for (String val : arrays) {
//	                  html += "<input type='radio' name='" + col.getId() + "' ";
//	                  html += "value='" + val.split(":")[1] + "' ";
//	                  if (sResult != null) {
//	                      if (val.split(":")[1].equals(Utils.nvl(sResult.get(col.getId().toLowerCase())))) {
//	                          html += "checked='checked' ";
//	                      }
//	                  }
//	                  if(StringUtils.isNotBlank(col.getTooltip())) {
//		            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//		              }
//	                  if ("Y".equals(col.getRequired())) {
//	                      html += "required ";
////	                      html += " " + Utils.nvl(col.getValidationMessage()) + " ";
//	                  }
//	                  boolean exclude = true;
//		              for(UMap e : attrList) {
//		            	  if(col.getId().equalsIgnoreCase((String)e.get("ATTR_NAME")) || col.getId().equalsIgnoreCase((String)e.get("attr_name"))) {
//		            		  exclude = false;
//		            		  break;
//		            	  }
//		              }
//
//		              if("S".equals(col.getEditable()))
//		            	  exclude = false;
//
//		              if(exclude) {
//		            	  col.setEditable("N");
//		            	  html += "class='view exclude' disabled='disabled' ";
//		              } else {
//		            	  html += "class='view'";
//		              }
//	                  if ("N".equals(col.getEditable())) {
//	                      html += "readonly='readonly'";
//	                  }
//	                  html += " />" + val.split(":")[0] + "&nbsp;&nbsp;";
//	              }
//
//	          } else if ("textarea".equals(col.getType())) {
//
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<textarea type='input' ";
//	              html += "id='" + col.getId() + "' name='" + col.getId() + "' class='k-textbox view'  ";
//
//	              if ("".equals(col.getLine()) || col.getLine() == null) {
//	                  html += "rows=4 ";
//	              } else {
//	                  html += "rows=" + col.getLine() + " ";
//	              }
//
//
//            	  html += "style='width:" + col.getWidth() + ";' ";
//	              if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              boolean exclude = true;
//
//	              for(UMap e : attrList) {
//	            	  if(col.getId().equalsIgnoreCase((String)e.get("ATTR_NAME")) || col.getId().equalsIgnoreCase((String)e.get("attr_name"))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//	              if(exclude) {
//	            	  col.setEditable("N");
//	            	  html += "class='k-textbox exclude'";
//	              } else {
//	            	  html += "class='k-textbox' ";
//	              }
//	              if ("N".equals(col.getEditable())) {
//	                  html += "readonly='readonly' ";
//	                  html += "disabled='disabled' ";
//	              }
//
//	              html += " >";
//	              if (sResult != null) {
//	                  html += Utils.nvl(sResult.get(col.getId().toLowerCase()));
//	              }
//	              html += "</textarea>";
//
//
//	          } else if ("editor".equals(col.getType())) {
//
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<textarea ";
//	              html += "id='" + col.getId() + "' name='" + col.getId() + "' ";
//	              html += "rows=4 ";
//
//
//            	  html += "style='width:" + col.getWidth() + ";' ";
//	              if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              boolean exclude = true;
//
//	              for(UMap e : attrList) {
//	            	  if(col.getId().equalsIgnoreCase((String)e.get("ATTR_NAME")) || col.getId().equalsIgnoreCase((String)e.get("attr_name"))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
//	              if(exclude) {
//	            	  col.setEditable("N");
//	            	  html += "class='k-textbox exclude view editor' disabled='disabled' ";
//	              } else {
//	            	  html += "class='k-textbox view editor' ";
//	              }
//	              if ("N".equals(col.getEditable())) {
//	                  html += "readonly='readonly' ";
//	              }
//
//	              html += ">";
//	              if (sResult != null) {
//	                  html += Utils.decodeJavascriptString(Utils.nvl(sResult.get(col.getId().toLowerCase())));
//	              }
//	              html += "</textarea>";
//	              User user = (User)request.getSession().getAttribute("userInfo");
//	              html += "<script>$('#" + col.getId() + "').kendoEditor({"+
//		              		"resizable: {content: true,toolbar: false},"+
//		              		"tools: [ 'bold','italic','underline','strikethrough','fontName','fontSize','foreColor','backColor',"
//		              		+ "'justifyLeft','justifyCenter','justifyRight','justfifyFull',"
//		              		+ "'insertUnorderedList','insertOrderedList','indent','outdent',"
//		              		+ "'createLink','insertImage',"
//		              		+ "'tableWizard','createTable' ],"+
//		              		"imageBrowser: {\r\n" +
//			              	"   path : \""+user.getUser_id()+"\",\r\n" +
//		              		"	messages: {\r\n" +
//		              		"		dropFilesHere: \"파일을 드래그하십시오.\"\r\n" +
//		              		"	},\r\n" +
//		              		"	transport: {\r\n" +
//		              		"		read: \"/imageBrowser/read\",\r\n" +
//		              		"		destroy: {\r\n" +
//		              		"			url: \"/imageBrowser/destroy\",\r\n" +
//		              		"			type: \"POST\"\r\n" +
//		              		"		},\r\n" +
//		              		"		create: {\r\n" +
//		              		"			url: \"/imageBrowser/create\",\r\n" +
//		              		"			type: \"POST\"\r\n" +
//		              		"		},\r\n" +
//		              		"		thumbnailUrl: \"/imageBrowser/thumbnail\",\r\n" +
//		              		"		uploadUrl: \"/imageBrowser/upload\",\r\n" +
//		              		"		imageUrl: \"/imageBrowser/image?path={0}\"\r\n" +
//		              		"	}\r\n" +
//		              		"}, "+
//		              		"});</script>";
//
//
//	          } else if ("tree".equals(col.getType())) {
//
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<input type='input'  class=\"select view\" ";
//	              html += "id='" + col.getId() + "' name='" + col.getId() + "' ";
//
//	              html += "style='width:" + col.getWidth() + ";' ";
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              html += "/>";
//
//	          } else if ("file".equals(col.getType()) || "imgfile".equals(col.getType())) {
//
//	              Map<String, Object> fParam = new HashMap<String, Object>();
//	              if(sResult != null) {
//	            	  if(sResult.get(col.getId().toLowerCase()) != null) {
//	            		  fParam.put("FILE_ID", Integer.valueOf(String.valueOf(sResult.get(col.getId().toLowerCase()))));
//	            	  }
//		              String fileId = "";
//		              String fileStr = "";
//
//		              List<Map<String, Object>> files = dataMapper.getFileNameBySql(fParam);
//		              List<UMap> fileInfoList = new ArrayList<UMap>();
//		              for (int i = 0; i < files.size(); i++) {
//		                  Map<String, Object> file = files.get(i);
//		                  String fileNm = (String) file.get("file_nm");
//		                  fileId = String.valueOf(file.get("file_id"));
//		                  String fileSeq = String.valueOf(file.get("file_seq"));
//		                  String fileType = (String) file.get("file_type");
//		                  String svrFileName = fileId+"_"+fileSeq+"."+fileType;
//
//		                  String fPath = uploadPath + "/" + svrFileName;
//		                  File f = new File(fPath);
//		                  UMap fileInfo = new UMap();
//		                  if (f.exists()) {
//		                      fileInfo.put("size", f.length());
//		                      fileInfo.put("extension", "." + FilenameUtils.getExtension(fileNm));
//		                      fileInfo.put("name", fileNm);
//		                      fileInfo.put("fileId", fileId+"_"+fileSeq);
//		                      fileInfo.put("fileCol", col.getId().toLowerCase());
////		                      ObjectMapper om = new ObjectMapper();
////		                      fileStr += om.writeValueAsString(fileInfo);
////		                      if (i != files.size() - 1) {
////		                          fileStr += ",";
////		                      }
//		                      fileInfoList.add(fileInfo);
//		                  }
//		              }
//		              ObjectMapper om = new ObjectMapper();
//		              fileStr = om.writeValueAsString(fileInfoList);
//
//		              rtnMap.put("fileStr_"+fileId, fileStr);
//		              fileList.add("fileStr_"+fileId);
//	              }
//
//	              if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<input type='file' ";
//	              html += "name='files[]' class='files view'";
//
//	              html += "style='width:" + col.getWidth() + ";' ";
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              html += "/>";
//	              String value = "";
//	              if(sResult != null) {
//	            	  value = Utils.nvl(sResult.get(col.getId().toLowerCase()));
//	              }
//	              html += "<input type='hidden' id='" + col.getId() + "' class='fileId' value='" + value + "'/>";
//
//	          } else if ("num".equals(col.getType())) {
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<input ";
//	              html += "id='" + col.getId() + "' name='" + col.getId() + "' ";
//
//            	  html += "style='width:" + col.getWidth() + ";' ";
//            	  if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//            	  if(StringUtils.isNotBlank(normFormatter)) {
//            		  html += "data-format='"+normFormatter+"' ";
//            	  }
//            	  if(col.getMin() != null) {
//            		  html += "data-min='"+col.getMin()+"' ";
//            	  }
//            	  if(col.getMax() != null) {
//            		  html += "data-max='"+col.getMax()+"' ";
//            	  }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              boolean exclude = true;
//	              for(UMap e : attrList) {
//	            	  if(col.getId().equalsIgnoreCase((String)e.get("ATTR_NAME")) || col.getId().equalsIgnoreCase((String)e.get("attr_name"))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
//	              if (sResult != null) {
//	                  html += "value=\"" + Utils.nvl(sResult.get(col.getId().toLowerCase())) + "\" ";
//	              }
//
//	              if(exclude && StringUtils.isNotEmpty(dataObject.getSql())) {
//	            	  col.setEditable("N");
//	            	  html += "class='numeric exclude' ";
//	              } else {
//	            	  html += "class='numeric ' ";
//	              }
//	              if ("N".equals(col.getEditable())) {
//	                  html += "readonly='readonly' ";
//	              }
//
//	              html += " />";
//	          } else if ("mask".equals(col.getType())) {
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<input ";
//	              html += "id='" + col.getId() + "' name='" + col.getId() + "' ";
//
//            	  html += "style='width:" + col.getWidth() + ";' ";
//            	  if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//            	  if(StringUtils.isNotBlank(normFormatter)) {
//            		  String mask = "";
//            		  if("ssn".equals(normFormatter)) {
//            			  mask = "000000-0000000";
//            		  } else if("card_no".equals(normFormatter)) {
//            			  mask = "0000-0000-0000-0000";
//            		  } else if("phone_no".equals(normFormatter)) {
//            			  mask = "999-0000-0000";
//            		  } else if("email".equals(normFormatter)) {
//            			  html += "type='email' validationMessage='이메일 형식이 부적절합니다.' ";
//            			  mask = "";
//            		  }
//            		  html += "data-mask='"+mask+"' ";
//            		  html += "data-maskname='"+normFormatter+"' ";
//            	  }
//            	  if(col.getMin() != null) {
//            		  html += "data-min='"+col.getMin()+"' ";
//            	  }
//            	  if(col.getMax() != null) {
//            		  html += "data-max='"+col.getMax()+"' ";
//            	  }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              boolean exclude = true;
//	              for(UMap e : attrList) {
//	            	  if(col.getId().equalsIgnoreCase((String)e.get("ATTR_NAME")) || col.getId().equalsIgnoreCase((String)e.get("attr_name"))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
//	              if (sResult != null) {
//	                  html += "value=\"" + Utils.nvl(sResult.get(col.getId().toLowerCase())) + "\" ";
//	              }
//
//	              if(exclude && StringUtils.isNotEmpty(dataObject.getSql())) {
//	            	  col.setEditable("N");
//	            	  html += "class='masked exclude' ";
//	              } else {
//	            	  html += "class='masked ' ";
//	              }
//	              if ("N".equals(col.getEditable())) {
//	                  html += "readonly='readonly' ";
//	              }
//	              html += " />";
//	          } else if("text".equals(col.getType()) || "password".equals(col.getType())) {
//
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style=\"text-align:right;\"><span class=\"requiredDot\">* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style=\"text-align:right;\">" + col.getValue() + "</td>";
//	              }
//
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan=\"3\">";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              if(StringUtils.isNotBlank(eventHml) && StringUtils.isNotBlank(normFormatter)) {
//	            	  html += "<span class='k-textbox k-space-right' style='width:100%;'>";
//	              }
//	              if ("password".equals(col.getType())) {
//	                  html += "<input type=\"password\" class=\"view k-textbox\" ";
//	              } else {
//	            	  if(StringUtils.isNotBlank(eventHml) && StringUtils.isNotBlank(normFormatter)) {
//		            	  html += "<input type=\"input\" class=\"view\" ";
//		              } else {
//		            	  html += "<input type=\"input\" class=\"view k-textbox\" ";
//		              }
//	              }
//
//                  html += "id=\"" + col.getId() + "\" name=\"" + col.getId() + "\" ";
//
//                  if("pwInit".equals(normFormatter) || "idCheck".equals(normFormatter)) {
//                	  html += "style=\"width:" + col.getWidth() + ";max-width:80%;display:inline-flex;\" ";
//                  } else {
//                	  html += "style='width:" + col.getWidth() + ";' ";
//                  }
//
//                  if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//                  if(col.getMin() != null) {
//            		  html += "minlength='"+col.getMin()+"' ";
//            	  }
//            	  if(col.getMax() != null) {
//            		  html += "maxlength='"+col.getMax()+"' ";
//            	  }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
////	                  html += " validationMessage='" + Utils.nvl(col.getValidationMessage()) + "' ";
//	              }
//
//	              boolean exclude = true;
//
//
//	              for(UMap e : attrList) {
//
//	            	  if(col.getId().equalsIgnoreCase((String)e.get("ATTR_NAME")) || col.getId().equalsIgnoreCase((String)e.get("attr_name"))) {
//
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
//	              if(exclude) {
//	            	  col.setEditable("N");
//	            	  html += "class=\"k-textbox exclude\" ";
//	              } else {
//	            	  html += "class=\"k-textbox\" ";
//	              }
//
//
//	              if ("N".equals(col.getEditable())) {
//	                  html += "readonly=\"readonly\" ";
//	                  html += "disabled=\"disabled\" ";
//	              }
//
//	              if (sResult != null) {
//	                  html += "value=\"" + Utils.nvl(sResult.get(col.getId().toLowerCase())) + "\" ";
//	              }
//
//	              html += "/>";
//
//	          }
//
//	          html += eventHml;
//	          if("text".equals(col.getType())) {
//	        	  if(StringUtils.isNotBlank(eventHml) && StringUtils.isEmpty(normFormatter)) {
//	        		  html += "</span>";
//	        	  }
//	          }
//	          if(!"checkbox".equals(col.getType())) {
//	        	  html += "</td>";
//	          } else {
//	        	  if(StringUtils.isEmpty(chkGroupLabel)) {
//	        		  html += "</td>";
//	        	  }
//	          }
//	          if(chkGroupEnd) {
//	        	  html += "</td>";
//	          }
//
//	          if(colSpan) {
//	        	  colCnt = 0;
//	        	  html += "</tr>";
//	        	  continue;
//	          }
//	          colCnt++;
//	          if ("bottom".equals(params.get("scrtype"))) {
//	              if (count == 1) {
//	            	  if(division == 1) {
//	            		  html += "</tr>";
//	            	  } else if(division == 2) {
//	            		  if(colCnt == 2) {
//	            			  html += "</tr>";
//	            			  colCnt = 0;
//	            		  }
//	            	  }
//	                  count = 0;
//	              } else {
//	                  count++;
//	              }
//	          } else {
//	        	  if(division == 1) {
//	        		  html += "</tr>";
//	        	  } else if(division == 2) {
//	        		  if(hideClass != "") {
//	        			  html += "</tr>";
//	        			  colCnt = 0;
//	        			  continue;
//	        		  }
//	        		  if(colCnt == 2) {
//	        			  html += "</tr>";
//	        			  colCnt = 0;
//	        		  }
//	        	  }
//	          }
//	      }
//
//	      rtnMap.put("eventCols", eventCols);
//	      rtnMap.put("html", html);
//	      rtnMap.put("fileList", fileList);
//	      ObjectMapper om = new ObjectMapper();
//
//	      return om.writeValueAsString(rtnMap);
//	  }
//
//	  @GetMapping(value= {"/dataView.do","/data.do"})
//	  public ModelAndView dataView(HttpServletRequest request, @RequestParam Map<String, Object> params) throws Exception {
//	      ModelAndView mav = new ModelAndView();
//	      String fileName = params.get("xn").toString().trim() + ".xml";
//	      fileName = fileName.replaceAll("(?i)LIST", "DATA");
//	      String filePath = Utils.getFilePath(fileName);
//	      if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//	    	  filePath = Utils.getAdmXmlPath(fileName);
//	      }
//
//	      if (!Utils.fileCheck(filePath)) {
//	          throw new Exception("등록된 DATA XML 파일이 없습니다.");
//	      }
//
//	      DataRoot dataObject = Utils.getDataXmlToObject(filePath);
//	      int lines = 1;
//
//	      if (params.get("xn") == null || "".equals(params.get("xn").toString())) {
//	          throw new Exception("============ [xn is null] ============");
//	      }
//
////	      List<Col> columns = dataObject.getColumns().getCols();
//	      ArrayList<String> eventCols = new ArrayList<String>();
//
////	      String[] columnIds = new String[columns.size()];
////	      List<String> keyCols = new ArrayList<String>();
////	      for (int i = 0; i < columns.size(); i++) {
////	          if (!"Y".equalsIgnoreCase(columns.get(i).getExcludequery())) {
////	              String _selCol = Utils.nvl(columns.get(i).getSelcol());
////	              columnIds[i] = _selCol;
////	              if ("Y".equals(columns.get(i).getKeyyn())) {
////	                  keyCols.add(_selCol);
////	              }
////	          }
////	      }
//
//	      lines = dataObject.getDivision();
//	      if(lines == 1) {
//	    	  String[] widthArr = dataObject.getWidths().split(":");
//	    	  mav.addObject("labelWidth", widthArr[0] + "%");
//	      } else {
//	    	  String[] widthsArr = dataObject.getWidths().split(";");
//	    	  String[] widthArr1 = widthsArr[0].split(":");
//	    	  String[] widthArr2 = widthsArr[1].split(":");
//	    	  mav.addObject("lines", "2");
//	    	  mav.addObject("label1Width", widthArr1[0] + "%");
//	    	  mav.addObject("data1Width", widthArr1[1] + "%");
//	    	  mav.addObject("label2Width", widthArr2[0] + "%");
//	      }
//
//	      mav.addObject("sid", params.get("sid"));
//	      mav.addObject("xn", params.get("xn"));
//	//      mav.addObject("mode","R");
//
//	      mav.addObject("keyCols", dataObject.getObject());
//	    //  System.out.println("dataObject.getObject() = "+dataObject.getObject());
//
////	      mav.addObject("columnIds", toObjStr(columnIds));
//	      String[] eventColArr = eventCols.toArray(new String[eventCols.size()]);
//	      mav.addObject("eventCols", toObjStr(eventColArr));
//
////	      System.out.println("toObjStr(eventColArr) = "+toObjStr(eventColArr));
//
//	      mav.addObject("scrtype", params.get("scrtype"));
//	      mav.addObject("title", params.get("title"));
//	      mav.addObject("objectid", params.get("objectid"));
//	      String objectIds = Objects.toString(params.get("objectid"), "");
//
//	      //System.out.println("objectIds= "+objectIds);
//
//	      if (!StringUtils.isEmpty(objectIds)) {
//	          String[] objectIdArr = objectIds.trim().split(",");
//	          for (int i = 0; i < objectIdArr.length; i++) {
//	              mav.addObject(objectIdArr[i], params.get(objectIdArr[i]));
//	          }
//	      }
//
//	      //TODO 그리드에서 키로 활용되는 objectid가 한개라는 보장은 없음. 2개 이상일 때 파일처리 개선되어야 함
//	      String objId = (String) params.get("objectid");
//	      String objectKeyVal = getObjectKeyVal(objId, params);
//
//	      mav.addObject("objectkeyval", objectKeyVal);
//	      //mav.addObject("objectkeyval", params.get(objId));
//	      mav.addObject("customUpdate", Utils.nvl(dataObject.getEvent().getUpdate()));
////	      mav.addObject("customView", Utils.nvl(dataObject.getEvent().getUpdate()));
//	      if(StringUtils.isNotBlank(dataObject.getUserJs())) {
//	    	  mav.addObject("jsfileyn", "Y");
//	    	  mav.addObject("jsfileurl", Utils.nvl(dataObject.getUserJs()));
//	      }
//	      mav.addObject("userHtml", Utils.nvl(dataObject.getUserHtml().getHtmls()));
//	      mav.addObject("desc", Utils.nvl(dataObject.getDesc()).replaceAll("\n", "<br/>"));
//		  mav.addObject("isDevMode", isDevMode);
////	      mav.addObject("pre_function_js", crudItem.getPre_function_js());
////	      mav.addObject("post_function_js", crudItem.getPost_function_js());
//
//		  System.out.println("params = "+params);
//		  System.out.println("mav = "+mav);
//
//
//	      mav.setViewName("core/dataView");
//	      return mav;
//	  }
//
//	  private String getObjectKeyVal(String objId, Map<String, Object> params) {
//	  	StringBuilder objectKeyVal = new StringBuilder();
//	  	if(!StringUtils.isEmpty(objId)) {
//		        String[] objIdArr = objId.split(",");
//		        for (int i = 0; i < objIdArr.length; i++) {
//		            objectKeyVal.append(params.get(objIdArr[i]));
//
//		            if (i < (objIdArr.length - 1))
//		                objectKeyVal.append(",");
//		        }
//	  	}
//
//	      return objectKeyVal.toString();
//	  }
//
//	  @GetMapping("/dataInsert.json")
//	  @ResponseBody
//	  public String dataInsert(HttpServletRequest req, @RequestParam Map<String, Object> params) throws Exception {
//
//	      String fileName = params.get("xn").toString().trim() + ".xml";
//	      fileName = fileName.replaceAll("(?i)LIST", "DATA");
//	      String filePath = Utils.getFilePath(fileName);
//	      String userId = "0";
//
//	      System.out.println("userInfo = "+req.getSession().getAttribute("SESSION_USER_TYPE"));
//	      System.out.println("params = "+params);
//	      userId = req.getSession().getAttribute("userId").toString();
//	      if("ADM".equals(req.getSession().getAttribute("SESSION_USER_TYPE"))) {
//	    	  filePath = Utils.getAdmXmlPath(fileName);
//	      }
//	      if (!Utils.fileCheck(filePath)) {
//	          throw new Exception("등록된 DATA XML 파일이 없습니다.");
//	      }
//
//	     /* HttpSession session = req.getSession();
//	      User userInfo = (User) session.getAttribute("userInfo");
//	      System.out.println("userInfo = "+userInfo);
//	      if (userInfo != null) {
//	          userId = userInfo.getUser_id();
//	      }else{*/
//
//	     /* }*/
//
//	      DataRoot dataObject = Utils.getDataXmlToObject(filePath);
//
//	      if (params.get("xn") == null || "".equals(params.get("xn").toString())) {
//	          throw new Exception("============ [xn is null] ============");
//	      }
//
//	      long dataId = -1;
//	      String partNm = "";
//	      String code = "";
//	      String colNm = "";
//
//	      List<ColumnItem> columns = dataObject.getColumns().getCols();
//
//	      ObjectMapper om = new ObjectMapper();
//
//	      Map<String, Object> sParam = new HashMap<>();
//	      sParam.put("CLASS_NAME", dataObject.getTable());
//	      List<UMap> attrList = new ArrayList<UMap>();
//	      if("CUBRID".equalsIgnoreCase(dbType)) {
//	    	  attrList = dataMapper.getColAttr(sParam);
//	      } else if("ORACLE".equalsIgnoreCase(dbType)) {
//	    	  attrList = dataMapper.getOracleColAttr(sParam);
//	      }
//	      else if("MARIADB".equalsIgnoreCase(dbType)) {
//	    	  attrList = dataMapper.getMariaDBColAttr(sParam);
//	      }
//	      boolean createIdYn = false;
//	      boolean createDtYn = false;
//
//	      boolean updateIdYn = false;
//	      boolean updateDtYn = false;
//
//	      boolean createUserId = false;
//	      boolean updateUserId = false;
//
//	      String menuCategory = "";
//
//	      for (int i = columns.size()-1; i >=0 ; i--) {
//	          String _selCol = Utils.nvl(columns.get(i).getId());
//	          if(_selCol.equals("MENU_CATEGORY"))
//	          {
//	        	  menuCategory = URLDecoder.decode(Utils.nvl(params.get(_selCol)), "UTF-8");
//	        	  menuCategory = Utils.unescapeStr(menuCategory);
//	        	  break;
//	          }
//	      }
//
//	      for (UMap cols : attrList) {
//	          String attr = (String) cols.get("ATTR_NAME");
//	          if(StringUtils.isEmpty(attr))
//	        	  attr = (String) cols.get("attr_name");
//
//	          if ("CREATE_ID".equals(attr)) {
//	              createIdYn = true;
//	          }
//	          if ("CREATE_DT".equals(attr)) {
//	              createDtYn = true;
//	          }
//	          if ("UPDATE_ID".equals(attr)) {
//	        	  updateIdYn = true;
//	          }
//	          if ("CREATE_DT".equals(attr)) {
//	        	  updateDtYn = true;
//	          }
//
//	          if ( "CREATE_USER_ID".equals(attr)) {
//	        	  createUserId = true;
//	          }
//	          if ("UPDATE_USER_ID".equals(attr)) {
//	        	  updateUserId = true;
//	          }
//
//	      }
//
//	      String insertColumns = "";
//	      String insertValues = "";
//
//	      String objectId = Objects.toString(params.get("objectid"), "");
//	      if (!"".equals(objectId)) {
//	          String[] objectIdArr = objectId.split(",");
//	          String[] objectValArr = (Objects.toString(params.get("objectval"), "")).split(",");
//	          for (int i = 0; i < objectIdArr.length; i++) {
//	              insertColumns += objectIdArr[i] + ",";
//	              insertValues += "'" + objectValArr[i] + "',";
//	          }
//	      }
//
//	      for (int i = 0; i < columns.size(); i++) {
//	          String _selCol = Utils.nvl(columns.get(i).getId());
//	          String _paramValue = URLDecoder.decode(Utils.nvl(params.get(_selCol)), "UTF-8");
//	          _paramValue = Utils.unescapeStr(_paramValue);
//
//	          if(_selCol.equals("CREATE_ID")||_selCol.equals("CREATE_DT")||_selCol.equals("UPDATE_ID")||_selCol.equals("UPDATE_DT")||_selCol.equals("DATA_ID") || _selCol.equals("UPDATE_USER_ID")||_selCol.equals("CREATE_USER_ID"))
//	        	  continue;
//
//	        //meta 컬럼에 있는지 체크 후 없으면 pass
//              boolean exclude = true;
//              for(UMap e : attrList) {
//            	  if(_selCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || _selCol.equalsIgnoreCase((String)e.get("attr_name"))) {
//            		  exclude = false;
//            		  break;
//            	  }
//              }
//
//              if(exclude) { continue; }
//
////	          String keyInsCondition = Utils.nvl(columns.get(i).getInsert_condition());
//
////	          if (!"Y".equalsIgnoreCase(columns.get(i).getExcludequery())) {
//
//	//              if(keyInsCondition!= "") {
//	//                  _paramValue = keyInsCondition;
//	//                  insertColumns += _selCol;
//	//                  insertValues += _paramValue;
//	//                  if(i!=selectColumns.size()-1) {
//	//                      insertColumns += ",";
//	//                      insertValues += ",";
//	//                  }
//	//              } else {
//	              if (!"".equals(_paramValue)) {
//	                  if (_paramValue.indexOf("'") > 0) {
//	                      _paramValue = _paramValue.replaceAll("'", "''");
//	                  }
//
//	                  _paramValue = "'" + _paramValue + "'";
//	                  insertColumns += _selCol;
//	                  insertValues += _paramValue;
//	                  if (i != columns.size() - 1) {
//	                      insertColumns += ",";
//	                      insertValues += ",";
//	                  }
//	              } else {
//	                  if ("file".equals(columns.get(i).getType())) {
//	                      continue;
//	                  }
//	                  insertColumns += _selCol;
//	                  insertValues += "null";
//	                  if (i != columns.size() - 1) {
//	                      insertColumns += ",";
//	                      insertValues += ",";
//	                  }
//	              }
////	          }
//	      }
//	//      }
//
//
//
//	      String from = dataObject.getTable().trim();
//	      int spaceIdx = from.indexOf(" "); //테이블 alias로 인한 공백이 있는지 탐색
//	      if (spaceIdx >= 0) {
//	          from = from.substring(0, spaceIdx);
//	      }
//
//	      if (createIdYn) {
//	          insertColumns += ", CREATE_ID";
//	          insertValues += ", '" + userId + "'";
//	      }
//
//	      if (createUserId) {
//	          insertColumns += ", CREATE_USER_ID";
//	          insertValues += ", '" + userId + "'";
//	      }
//
//
//
//	      if (createDtYn) {
//	    	  String datetime = "";
//	    	  if("CUBRID".equalsIgnoreCase(dbType)) {
//	    		  datetime =  Cubrid.DATETIME;
//	    	  } else if("ORACLE".equalsIgnoreCase(dbType)) {
//	    		  datetime =  Oracle.DATE;
//	    	  } else if("MARIADB".equalsIgnoreCase(dbType)) {
//	    		  datetime =  MariaDB.DATETIME;
//	    	  }
//
//	          insertColumns += ", CREATE_DT";
//	          insertValues += ", "+datetime;
//	      }
//
//	      if (updateIdYn) {
//	          insertColumns += ", UPDATE_ID";
//	          insertValues += ", '" + userId + "'";
//	      }
//
//	      if (updateUserId) {
//	          insertColumns += ", UPDATE_USER_ID";
//	          insertValues += ", '" + userId + "'";
//	      }
//
//	      if (updateDtYn) {
//	    	  String datetime = "";
//	    	  if("CUBRID".equalsIgnoreCase(dbType)) {
//	    		  datetime =  Cubrid.DATETIME;
//	    	  } else if("ORACLE".equalsIgnoreCase(dbType)) {
//	    		  datetime =  Oracle.DATE;
//	    	  } else if("MARIADB".equalsIgnoreCase(dbType)) {
//	    		  datetime =  MariaDB.DATETIME;
//	    	  }
//
//	          insertColumns += ", UPDATE_DT";
//	          insertValues += ", "+datetime;
//	      }
//
//	      if(menuCategory.equals("CPN") || menuCategory.equals("IVT")){
//	    	  String[] data = from.split("_");
//	    	  partNm = data[1];
//	    	  Map<String,Object> tempParam = new HashMap<>();
//
//	    	  //colNm은 예전 코드 만들때 사용하던 것이라 현재는 사용하지 않는다.
//	    	  System.out.println("partNm = "+partNm);
//	    	  switch(partNm){
//	    	  case "CPU":
//	    		  colNm = "CODE_NM";
//	    		  code = "CPU";
//	    		  break;
//	    	  case "MBD":
//	    		  colNm = "MODEL_NM";
//	    		  code = "MBD";
//	    		  break;
//	    	  case "VGA":
//	    		  colNm = "MODEL_NM";
//	    		  code = "VGA";
//	    		  break;
//	    	  case "MEM":
//	    		  colNm = "MANUFACTURE_NM";
//	    		  code = "MEM";
//	    		  break;
//	    	  case "MON":
//	    		  colNm = "SIZE";
//	    		  code = "MON";
//	    		  break;
//	    	  case "STG":
//	    		  colNm = "STG_TYPE";
//	    		  code = "STG";
//	    		  break;
//	    	  case "POW":
//	    		  colNm = "MODEL_NM";
//	    		  code = "POW";
//	    		  break;
//	    	  case "CAS":
//	    		  colNm = "MANUFACTURE_NM";
//	    		  code = "CAS";
//	    		  break;
//	    	  case "ADP":
//	    		  colNm = "MANUFACTURE_NM";
//	    		  code = "ADP";
//	    		  break;
//	    	  }
//
//	    	  tempParam.put("PART", code);
//
//	    	  dataId = dataMapper.getSerialNo(tempParam);
//
//	    	  insertColumns += ", DATA_ID";
//	          insertValues += ", " + dataId;
//
//
//	      }else if(menuCategory.equals("TEST"))
//	      {
//
//	      }
//
//	      insertColumns = insertColumns.replace(",,", ",");
//	      insertValues = insertValues.replace(",,", ",");
//
//	      if (insertColumns.endsWith(",")) insertColumns = insertColumns.substring(0, insertColumns.length() - 1);
//	      if (insertValues.endsWith(",")) insertValues = insertValues.substring(0, insertValues.length() - 1);
//
//
//	      sParam.put("from", from);
//	      sParam.put("columns", insertColumns);
//	      sParam.put("insertValues", insertValues);
//
//	      int rtnVal = 0;
//	      try {
//	          rtnVal = dataMapper.setDataInsert(sParam);
//	      } catch (Exception e) {
//	          params.put("success", false);
//	          params.put("errMsg", e.getLocalizedMessage());
//	          return om.writeValueAsString(params);
//	      }
//
//
//	      if(menuCategory.equals("CPN")){
//	    	  Map<String,Object> cParam = new HashMap<>();
//
//	    	  cParam.put("PART", "COMPONENT");
//	    	  long componentId = dataMapper.getSerialNo(cParam);
//
//	    	  String componentPart = "comp_"+code.toLowerCase();
//	    	  cParam.clear();
//	    	  cParam.put("PART", componentPart);
//	    	  long serialNo = dataMapper.getSerialNo(cParam);
//	    	  String sSerialNo = String.format("%05d", serialNo);
//
//	    	  cParam.clear();
//
//	    	  String component = "";
//	    	  String value = "";
//
//	    	  for (int i = 0; i <columns.size() ; i++) {
//		          String _selCol = Utils.nvl(columns.get(i).getId());
//		          if(_selCol.equals(colNm))
//		          {
//		        	  value = URLDecoder.decode(Utils.nvl(params.get(_selCol)), "UTF-8");
//		        	  value = Utils.unescapeStr(value);
//		        	  break;
//		          }
//		      }
//
//	    	  component = code+sSerialNo;
//
//	    	  cParam.put("COMPONENT_ID", componentId);
//	    	  cParam.put("COMPONENT", component);
//	    	  cParam.put("COMPONENT_CD", code);
//	    	  cParam.put("COMPONENT_STATE", "N");
//	    	  cParam.put("COMPONENT_CAT", "C");
//	    	  cParam.put("DATA_ID", dataId);
//	    	  cParam.put("INIT_PRICE", 0);
//	    	  cParam.put("COMP_PRICE_ID", 0);
//	    	  cParam.put("COMP_EXPL_ID", 0);
//	    	  cParam.put("CUSTOM_CNT", 0);
//	    	  cParam.put("USER_ID", userId);
//
//	    	  try {
//	    		  rtnVal = dataMapper.setCompManageInsert(cParam);
//		      } catch (Exception e) {
//		          params.put("success", false);
//		          params.put("errMsg", e.getLocalizedMessage());
//		          return om.writeValueAsString(params);
//		      }
//
//	      }else if(menuCategory.equals("IVT")){
//	    	  Map<String,Object> cParam = new HashMap<>();
//	    	  cParam.put("PART", "INVENTORY");
//	    	  long inventoryId = dataMapper.getSerialNo(cParam);
//
//	    	  cParam.clear();
//	    	  cParam.put("PART", "BARCODE");
//	    	  long serialNo = dataMapper.getSerialNo(cParam);
//
////	    	  Date time = new Date();
////	    	  SimpleDateFormat format = new SimpleDateFormat ( "yyMMdd");
////	    	  String today = format.format(time);
////	    	  String ProductCd = "1509";
//
////	    	  String partCd = "";
//	    	  //String sSerialNo = String.format("%04d", serialNo);
//
//
////	    	  if(partNm.equals("CPU")){
////	    		  partCd = "CP";
////	    	  }else if(partNm.equals("MAINBOARD")){
////	    		  partCd = "MB";
////	    	  }else if(partNm.equals("MEMORY")){
////	    		  partCd = "RM";
////	    	  }else if(partNm.equals("VGA")){
////	    		  partCd = "VG";
////	    	  }else if(partNm.equals("MONITOR")){
////	    		  partCd = "MT";
////	    	  }else if(partNm.equals("STORAGE")){
////	    		  String stgType = params.get("STG_TYPE").toString();
////	    		  if (stgType.toUpperCase().contains("SSD"))
////	    			  partCd = "SD";
////	    		  else
////	    			  partCd = "HD";
////	    	  }else if(partNm.equals("POWER")){
////	    		  partCd = "PW";
////	    	  }else if(partNm.equals("CASE")){
////	    		  partCd = "CS";
////	    	  }else if(partNm.equals("ADAPTER")){
////	    		  partCd = "AD";
////	    	  }
//
//	    	  String barcode = "LT" + Long.toString(serialNo);
//
//	    	  cParam.put("INVENTORY_ID", inventoryId);
//	    	  cParam.put("BARCODE", barcode);
//	    	  cParam.put("COMPONENT_ID", params.get("COMPONENT_ID").toString());
//	    	  cParam.put("COMPONENT_CD", code);
//	    	  cParam.put("INVENTORY_STATE", "E");
//	    	  cParam.put("INVENTORY_CAT", "G");
//	    	  cParam.put("PROPERTY_STATE", "A");
//	    	  cParam.put("TREE_YN", "N");
//	    	  cParam.put("DATA_ID", dataId);
//	    	  cParam.put("LOCATION", params.get("LOCATION").toString());
//	    	  cParam.put("USER_ID", userId);
//
//	    	  try {
//	    		  rtnVal = dataMapper.setInvenManageInsert(cParam);
//	    		  //rtnVal = dataMapper.setInvenInfoInsert(cParam);
//
//		      } catch (Exception e) {
//		          params.put("success", false);
//		          params.put("errMsg", e.getLocalizedMessage());
//		          return om.writeValueAsString(params);
//		      }
//
//	      }
//
//	      params.put("success", rtnVal > 0);
//
//	      return om.writeValueAsString(params);
//	  }
//
//	  @GetMapping("/dataDelete.json")
//	  public ModelAndView dataDelete(HttpServletRequest req, @RequestParam Map<String, Object> params) throws Exception {
//	      ModelAndView mav = new ModelAndView();
//
//	      String fileName = params.get("xn").toString().trim() + ".xml";
//	      fileName = fileName.replaceAll("(?i)LIST", "DATA");
//	      String filePath = Utils.getFilePath(fileName);
//	      if("ADM".equals(req.getSession().getAttribute("SESSION_USER_TYPE"))) {
//	    	  filePath = Utils.getAdmXmlPath(fileName);
//	      }
//	      if (!Utils.fileCheck(filePath)) {
//	          throw new Exception("등록된 DATA XML 파일이 없습니다.");
//	      }
//
//	      DataRoot dataObject = Utils.getDataXmlToObject(filePath);
//
//	      if (params.get("xn") == null || "".equals(params.get("xn").toString())) {
//	          throw new Exception("============ [xn is null] ============");
//	      }
//
//	      if(params.containsKey("DELETABLE")){
//				String deletable = params.get("DELETABLE").toString();
//				if(deletable.equals("N")){
//					throw new Exception("삭제할 수 없는 항목입니다.");
//				}
//	      }
//
//	      List<ColumnItem> columns = dataObject.getColumns().getCols();
//	      List<String> files = new ArrayList<String>(); //파일컬럼명
//	      for (ColumnItem col : columns) {
//	          if ("file".equals(col.getType()) || "imgfile".equals(col.getType())) {
//	              files.add(col.getId());
//	          }
//	      }
//
//	      Map<String, Object> sParam = new HashMap<>();
//	      sParam.put("from", dataObject.getTable());
//	      String whereCon = " 1=1 ";
//	      for (String oid : dataObject.getObject().split(",")) {
//	          whereCon += "AND " + oid + "= '" + Utils.decodeJavascriptString((String) params.get(oid)) + "'";
//
//	      }
//
//	      sParam.put("whereClause", whereCon);
//
//	      if (files.size() > 0) {
//	          for (int i = 0; i < files.size(); i++) {
//	              String fileCol = files.get(i);
//	              sParam.put("WHERE", whereCon);
//	              sParam.put("TABLE_ID", dataObject.getTable());
//	              sParam.put("FILE_COL", fileCol);
//	              String fileId = dataMapper.getFileIdBySql(sParam);
//	              if (!"".equals(fileId) && fileId != null) {
//	                  sParam.put("FILE_ID", fileId);
//	                  fileController.removeFileById(sParam);
//	              }
//	          }
//	      }
//
//	      System.out.println("params= "+params);
//
//	      int rtnVal = 0;
//	      try {
//	          rtnVal = dataMapper.setDataDelete(sParam);
//	      } catch (Exception e) {
//	          String cause = e.getCause().toString();
//	          if (cause.contains("foreign key")) {
//	              throw new Exception("다른 업무에서 사용중인 정보이므로 삭제할 수 없습니다.");
//	          } else {
//	              throw new Exception("데이터 처리에 문제가 있어 삭제할 수 없습니다.");
//	          }
//	      }
//
//	      mav.setView(new MappingJackson2JsonView());
//	      mav.addObject("pid", Objects.toString(params.get("pid"), ""));
//
//	      if (rtnVal > 0) {
//	          mav.addObject("success", true);
//	      } else {
//	          mav.addObject("success", false);
//	      }
//
//	      return mav;
//	  }
//
//	  @PostMapping("/dataUpdate.json")
//	  @ResponseBody
//	  public String dataUpdate(HttpServletRequest request, @RequestParam Map<String, Object> params) throws Exception {
//		  Map<String, Object> newParams = new HashMap<String, Object>();
//
//		  String userId = request.getSession().getAttribute("userId").toString();
//
//		  params.put("UPDATE_USER_ID", userId);
//
//		  int menuCategory = 0;
//			if(params.containsKey("MENU_CATEGORY")){
//				String category = params.get("MENU_CATEGORY").toString();
//
//				if(!StringUtils.isEmpty(category)) {
//					menuCategory = Integer.parseInt(category);
//				}
//
//				if(menuCategory == 1) {
//					String inventoryState = params.get("INVENTORY_STATE").toString();
//					String location = params.get("LOCATION").toString();
//					String whereClause = "INVENTORY_STATE = '"+inventoryState+"', "+"LOCATION = '"+location+"', "+"UPDATE_USER_ID = '"+userId+"', "+"UPDATE_DT = NOW()";
//
//					newParams.put("INVENTORY_ID", params.get("INVENTORY_ID"));
//					newParams.put("INVENTORY_STATE", inventoryState);
//					newParams.put("LOCATION", location);
//					newParams.put("UPDATE_USER_ID", userId);
//					newParams.put("WHERE_CLAUSE", whereClause);
//				}else {
//
//					String whereClause = "UPDATE_USER_ID = '"+userId+"', "+"UPDATE_DT = NOW()";
//
//					newParams.put("UPDATE_USER_ID", userId);
//					newParams.put("WHERE_CLAUSE", whereClause);
//				}
//			}
//
//	      String fileName = params.get("xn").toString().trim() + ".xml";
//	      fileName = fileName.replaceAll("(?i)LIST", "DATA");
//	      String filePath = Utils.getFilePath(fileName);
//	      String now = "NOW()";
//	      if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//	    	  filePath = Utils.getAdmXmlPath(fileName);
//	      }
//
//	      if (!Utils.fileCheck(filePath)) {
//	          throw new Exception("등록된 DATA XML 파일이 없습니다.");
//	      }
//
//	      DataRoot dataObject = Utils.getDataXmlToObject(filePath);
//	      if (params.get("xn") == null || "".equals(params.get("xn").toString())) {
//	          throw new Exception("============ [xn is null] ============");
//	      }
//
//	      List<ColumnItem> columns = dataObject.getColumns().getCols();
//
//	      params.put("CLASS_NAME", dataObject.getTable());
//	      List<UMap> attrList = new ArrayList<UMap>();
//
//	      if("CUBRID".equalsIgnoreCase(dbType)) {
//	    	  attrList = dataMapper.getColAttr(params);
//	    	  now = "NOW()";
//	      } else if("ORACLE".equalsIgnoreCase(dbType)) {
//	    	  attrList = dataMapper.getOracleColAttr(params);
//	    	  now = "SYSDATE";
//	      }
//	      else if("MARIADB".equalsIgnoreCase(dbType)) {
//	    	  attrList = dataMapper.getMariaDBColAttr(params);
//	    	  now = "NOW()";
//	      }
//
//	      ObjectMapper om = new ObjectMapper();
//
//	      int rtnVal = 0;
//
//	      UMap updatedMap = new UMap();
//          String updateClause = "";
//          for (int i = 0; i < columns.size(); i++) {
//              String _selCol = Utils.nvl(columns.get(i).getId());
//              String _paramValue = URLDecoder.decode((Utils.nvl(params.get(_selCol))), "UTF-8");
//
//              updatedMap.put(_selCol, _paramValue);
//              //meta 컬럼에 있는지 체크 후 없으면 pass
//              boolean exclude = true;
//              for(UMap e : attrList) {
//            	  if(_selCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || _selCol.equalsIgnoreCase((String)e.get("attr_name"))) {
//            		  exclude = false;
//            		  break;
//            	  }
//              }
//              if(exclude) { continue; }
//
//              if (_paramValue.indexOf("'") > 0) {
//                  _paramValue = _paramValue.replaceAll("'", "''");
//              }
//
//              if (!"".equals(_paramValue)) {
//                  if ("checkbox".equals(columns.get(i).getType())) {
//                      String chkVal = Utils.nvl(columns.get(i).getDefault());
//                      if (chkVal.equals(_paramValue)) {
//                          _paramValue = chkVal;
//                      } else {
//                          _paramValue = "";
//                      }
//                  } else if ("calendar".equals(columns.get(i).getType())) {
//                  }
//
//                  if(_selCol.equals("CREATE_DT"))
//                	  continue;
//                  else if(_selCol.equals("UPDATE_DT") )
//                  {
//                	  updateClause += _selCol + "= "+now;
//                  }
//                  else
//                	  updateClause += _selCol + "= '" + _paramValue + "'";
//
//                  if (i != columns.size() - 1) {
//                      updateClause += ",";
//                  }
//              } else {
//            	  if(_selCol.equals("CREATE_DT"))
//                	  continue;
//                  else if(_selCol.equals("UPDATE_DT") )
//                  {
//                	  updateClause += _selCol + "= "+now;
//                  }
//                  else
//                	  updateClause += _selCol + "= null";
//
//                  if (i != columns.size() - 1) {
//                      updateClause += ",";
//                  }
//              }
//          }
//
//          if (updateClause.endsWith(",")) updateClause = updateClause.substring(0, updateClause.length() - 1);
//
//          if(!updateClause.contains("UPDATE_DT")){
//        	  for(UMap e : attrList) {
//            	  if("UPDATE_DT".equalsIgnoreCase((String)e.get("ATTR_NAME")) || "UPDATE_DT".equalsIgnoreCase((String)e.get("attr_name"))) {
//            		  updateClause += ", UPDATE_DT = "+now;
//            		  break;
//            	  }
//              }
//          }
//
//          Map<String, Object> sParam = new HashMap<>();
//          sParam.put("from", dataObject.getTable());
//          sParam.put("updateClause", updateClause);
//          String whereCon = " 1=1 ";
//          for (String oid : dataObject.getObject().split(",")) {
//              whereCon += "AND " + oid + " = '" + Utils.decodeJavascriptString((String) params.get(oid)) + "'";
//              updatedMap.put(oid, Utils.decodeJavascriptString((String) params.get(oid)));
//          }
//
//          sParam.put("whereClause", whereCon);
//
//          rtnVal = dataMapper.setDataUpdate(sParam);
//
//          params.put("updatedData", updatedMap);
//
//          System.out.println("menuCategory ="+ menuCategory);
//
//
//
//	      return om.writeValueAsString(params);
//	  }
//
//	  @GetMapping("/dataEdit.json")
//	  @ResponseBody
//	  public String dataEditJson(HttpServletRequest request, @RequestParam Map<String, Object> params) throws Exception {
//	      String fileName = params.get("xn").toString().trim() + ".xml";
//	      fileName = fileName.replaceAll("(?i)LIST", "DATA");
//	      String filePath = Utils.getFilePath(fileName);
//	      if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//	    	  filePath = Utils.getAdmXmlPath(fileName);
//	      }
//	      if (!Utils.fileCheck(filePath)) {
//	          throw new Exception("등록된 DATA XML 파일이 없습니다.");
//	      }
//
//	      DataRoot dataObject = Utils.getDataXmlToObject(filePath);
//	      int division = 1;
//
//	      if (params.get("xn") == null || "".equals(params.get("xn").toString())) {
//	          throw new Exception("============ [xn is null] ============");
//	      }
//
//	      List<ColumnItem> columns = dataObject.getColumns().getCols();
//
//	      ArrayList<String> eventCols = new ArrayList<String>();
//	      division = dataObject.getDivision();
//
//	      params.put("CLASS_NAME", dataObject.getTable());
//	      List<UMap> attrList = new ArrayList<UMap>();
//	      if("CUBRID".equalsIgnoreCase(dbType)) {
//	    	  attrList = dataMapper.getColAttr(params);
//	      } else if("ORACLE".equalsIgnoreCase(dbType)) {
//	    	  attrList = dataMapper.getOracleColAttr(params);
//	      }
//	      else if("MARIADB".equalsIgnoreCase(dbType)) {
//	    	  attrList = dataMapper.getMariaDBColAttr(params);
//	      }
//
////	      List<Map<String, Object>> cpntList = new ArrayList<>();
//	      String html = "";
//	      int count = 0;
//	      int colCnt = 0;
//	      String chkGroupLabel = "";
//	      boolean chkGroupEnd = false;
//	      boolean colSpan = false;
//	      colloop : for (ColumnItem col : columns) {
//	          String normFormatter = col.getFormatter();
//	          String eventHml = "";
//	          colSpan = false;
//	          if("pwInit".equals(normFormatter)) {
//	        	  eventHml += "<button class='k-button' style='width:105px;' onclick='javascript:fnPasswordInit();'>비밀번호 초기화</button>";
//	        	  eventHml += "<script>function fnPasswordInit(){\r\n" +
//	        	  		"								if($(\"#login_id\").prop(\"disabled\")) {\r\n" +
//	        	  		"									return;\r\n" +
//	        	  		"								}\r\n" +
//	        	  		"								var userId = $(\"#user_id\").val();\r\n" +
//	        	  		"								if(userId) {\r\n" +
//	        	  		"									$.ajax({\r\n" +
//	        	  		"										url : '/admin/pwInit.json',\r\n" +
//	        	  		"										data : {user_id : $('#user_id').val()},\r\n" +
//	        	  		"										success : function(data) {\r\n" +
//	        	  		"											if(data.success) {\r\n" +
//	        	  		"												GochigoAlert(data.rtnMsg);\r\n" +
//	        	  		"											} else {\r\n" +
//	        	  		"												GochigoAlert(data.rtnMsg);\r\n" +
//	        	  		"											}\r\n" +
//	        	  		"										}\r\n" +
//	        	  		"									});\r\n" +
//	        	  		"								} else {\r\n" +
//	        	  		"									GochigoAlert(\"선택된 항목이 없습니다.\");\r\n" +
//	        	  		"									return;\r\n" +
//	        	  		"								}\r\n" +
//	        	  		"							}</script>";
//	          } else if("idCheck".equals(normFormatter)) {
//	        	  eventHml += "<button class='k-button' style='width:105px;' onclick='javascript:idCheckBtnClick();'>아이디 중복검사</button>";
//	        	  eventHml += "<script>function idCheckBtnClick(){\r\n" +
//	        	  		"								if($(\"#login_id\").prop(\"disabled\")) {\r\n" +
//	        	  		"									return;\r\n" +
//	        	  		"								}\r\n" +
//	        	  		"								if($(\"#login_id\").val()=='' || $(\"#login_id\").val() == null){\r\n" +
//	        	  		"									GochigoAlert('아이디를 입력해주세요');\r\n" +
//	        	  		"									return;\r\n" +
//	        	  		"								}\r\n" +
//	        	  		"								$.ajax({\r\n" +
//	        	  		"									url : '/admin/idCheck.json',\r\n" +
//	        	  		"									data : {login_id : $('#login_id').val()},\r\n" +
//	        	  		"									success : function(data) {\r\n" +
//	        	  		"										if(data.success) {\r\n" +
//	        	  		"											GochigoAlert(data.rtnMsg);\r\n" +
//	        	  		"										} else {\r\n" +
//	        	  		"											GochigoAlert(data.rtnMsg);\r\n" +
//	        	  		"											$('#login_id').val('').focus();\r\n" +
//	        	  		"										}\r\n" +
//	        	  		"									}\r\n" +
//	        	  		"								});\r\n" +
//	        	  		"							}</script>";
//	          }
//	          if(StringUtils.isNotBlank(col.getFormatter())) {
//	        	  try {
//			          Gson formatGson = new Gson();
//		              Type frmModelType = new TypeToken<HashMap<String,Object>>() {}.getType();
//		              HashMap<String,Object> jsonFormatter = formatGson.fromJson( col.getFormatter(), frmModelType);
//		              String formatType = (String)jsonFormatter.get("type");
//		              if("url".equals(formatType)){
//		            	  String formatUrl = (String)jsonFormatter.get("url");
//		            	  String callbackName = "fnLinkCallback_"+col.getId();
//		            	  String size = (String)jsonFormatter.get("size");
//		            	  if(StringUtils.isNotBlank(size)) {
//		            		  size = size.toUpperCase();
//		            	  }
//		            	  eventHml += "<span class='k-icon k-i-windows' onclick='javascript:fnObj(\"CRUD_"+params.get("sid")+"\").fnWindowOpen(\""+formatUrl+"\",\""+callbackName+"\",\""+size+"\");'></span>";
//		            	  eventHml += "<script>function "+callbackName+"(data){\r\n" +
//	  	        	  		          "	if(data) {\r\n";
//    	  		          if("select".equals(col.getType())) {
//    	  		        	  eventHml += "var dropdownlist = $(\"#"+col.getId()+"\").data(\"kendoDropDownList\");\r\n" +
//    	  		        	  		"dropdownlist.select(function(dataItem) {\r\n" +
//    	  		        	  		"    return dataItem.value === data."+col.getId()+";\r\n" +
//    	  		        	  		"});";
//    	  		          } else {
//    	  		        	  eventHml += "$('#"+col.getId()+"').val(data."+col.getId()+")\r\n";
//    	  		          }
//	  	        	  	   eventHml +=" }\r\n" +
//	  	        	  		          "	}</script>";
//		              }
//	        	  }catch(IllegalStateException e) {
//	        		  System.out.println("NOT JSON Formatter");
//		          }catch(JsonSyntaxException e) {
//		        	  System.out.println("NOT JSON Formatter");
//		          }
//	          }
//
//	          String selCol = col.getId();
//	          if (StringUtils.isNotBlank(selCol) && selCol.contains(".")) {
//	              selCol = selCol.substring(selCol.indexOf(".") + 1, selCol.length());
//	          }
//
//	          String hideClass = "";
//              if ("Y".equals(col.getHidden())) {
//                  hideClass = "display:none;";
//              }
//        	  if (hideClass != "") {
//        		  if(division == 1) {
//        			  html += "<tr style='" + hideClass + "'>";
//        		  } else if(division == 2) {
////        			  if(colCnt == 0) {
//        				  html += "<tr style='" + hideClass + "'>";
////        			  }
//        		  }
//        	  } else {
//        		  if(division == 1) {
//        			  html += "<tr>";
//        		  } else if(division == 2) {
//        			  if(colCnt == 0) {
//        				  html += "<tr>";
//        			  }
//        		  }
//        	  }
//
//        	  if("BLANK".equalsIgnoreCase(col.getClassType())) {
//        		  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//        		  String height = Utils.nvl(col.getHeight());
//                  html += "<td style='text-align:right;'></td>";
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3' height='"+height+"'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td height='"+height+"'>";
//	              }
//	              html += " </td>";
//        	  } else if("LINE".equalsIgnoreCase(col.getClassType())) {
//        		  if(division ==2) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//                  html += "<td style='text-align:center;background-image: url(\"/codebase/imgs/line.png\");background-repeat-y:no-repeat;background-repeat:repeat-x;background-position-y:center;'><span class='data_line'>"+Utils.nvl(col.getValue())+"</span></td>";
//                  if(division ==2) {
//              		  html += "<td colspan='3' style='background-image: url(\"/codebase/imgs/line.png\");background-repeat-y:no-repeat;background-repeat:repeat-x;background-position-y:center;'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td style='background-image: url(\"/codebase/imgs/line.png\");background-repeat-y:no-repeat;background-repeat:repeat-x;background-position-y:center;>";
//	              }
//
//	              html += "</td>";
//        	  }
//
//	          if ("checkbox".equals(col.getType())) {
//	              String _chkVal = Utils.nvl(col.getDefault());
//	              if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              chkGroupLabel = col.getGroupLabel();
//
//	              if(StringUtils.isEmpty(chkGroupLabel)) {
//		              if ("Y".equals(col.getRequired())) {
//		                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//		              } else {
//		                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//		              }
//		              if("Y".equals(col.getColSpan())) {
//		            	  html += "<td colspan='3'>";
//		            	  colSpan = true;
//		              } else {
//		            	  html += "<td>";
//		              }
//		              html += "<input type='checkbox' ";
//		              html += "id='" + selCol + "' name='" + selCol + "' ";
//		              html += "value='" + _chkVal + "'";
//
//		              if(StringUtils.isNotBlank(col.getTooltip())) {
//		            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//		              }
//		              if ("Y".equals(col.getRequired())) {
//		                  html += "required ";
//		              }
//		              boolean exclude = true;
//		              for(UMap e : attrList) {
//		            	  if(selCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || selCol.equalsIgnoreCase((String)e.get("attr_name"))) {
//		            		  exclude = false;
//		            		  break;
//		            	  }
//		              }
//		              if("S".equals(col.getEditable()))
//		            	  exclude = false;
//
//		              if(exclude) {
//		            	  col.setEditable("N");
//		            	  html += "class='exclude' ";
//		              }
//		              if ("N".equals(col.getEditable())) {
//		                  html += "readonly='readonly' ";
//		              }
//	        		  html += "/>";
//	              } else {
//	            	  Map<String, List<ColumnItem>> groupCheckBoxes = dataObject.getGroupCheckBoxes();
//	            	  List<ColumnItem> checkList = groupCheckBoxes.get(chkGroupLabel);
//	            	  for(int i=0; i < checkList.size(); i++) {
//	            		  if(!col.getId().equals(checkList.get(0).getId())) {
//	            			  continue colloop;
//	            		  }
//	            	  }
//	            	  html += "<td style='text-align:right;'>" + chkGroupLabel + "</td>";
//	            	  if("Y".equals(col.getColSpan())) {
//	            		  html += "<td colspan='3'>";
//	            		  colSpan = true;
//	            	  } else {
//	            		  html += "<td>";
//	            	  }
//	            	  for(int i=0; i < checkList.size(); i++) {
//	            		  ColumnItem item = checkList.get(i);
//
//	            		  String chkSelCol = item.getId();
//	            		  if (StringUtils.isNotBlank(selCol) && selCol.contains(".")) {
//	        	              chkSelCol = selCol.substring(selCol.indexOf(".") + 1, selCol.length());
//	        	          }
//	            		  html += "<input type='checkbox' ";
//			              html += "id='" + chkSelCol + "' name='" + chkSelCol + "' ";
//			              html += "value='" + _chkVal + "'";
//
//			              if(StringUtils.isNotBlank(item.getTooltip())) {
//			            	  html += "data-tooltip='"+item.getTooltip()+"' ";
//			              }
//			              if ("Y".equals(item.getRequired())) {
//			                  html += "required ";
//			              }
//			              boolean exclude = true;
//			              for(UMap e : attrList) {
//			            	  if(chkSelCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || chkSelCol.equalsIgnoreCase((String)e.get("attr_name"))) {
//			            		  exclude = false;
//			            		  break;
//			            	  }
//			              }
//			              if("S".equals(col.getEditable()))
//			            	  exclude = false;
//
//			              if(exclude) {
//			            	  item.setEditable("N");
//			            	  html += "class='exclude' ";
//			              }
//			              if ("N".equals(item.getEditable())) {
//			                  html += "readonly='readonly' ";
//			              }
//		        		  html += "/>";
//		        		  html += "<label for='"+chkSelCol+"'>" + item.getValue() + "</label>&nbsp;&nbsp;";
//	            	  }
//	            	  html += "</td>";
//	              }
//	          } else if ("select".equals(col.getType())) {
//	              Map<String, Object> _param = new HashMap<>();
//	              Gson gson = new Gson();
//                  Type modelType = new TypeToken<HashMap<String,Object>>() {}.getType();
//                  HashMap<String,Object> formatter = gson.fromJson( col.getFormatter(), modelType);
//                  String type = (String)formatter.get("type");
//                  List<Map<String, Object>> rslt = new ArrayList<Map<String, Object>>();;
//                  if("sql".equals(type)){
//                	  String selectSql = Utils.nvl(formatter.get("sql"));
//                	  _param.put("selectSql", selectSql);
//                	  rslt = dataMapper.getSelectComboBySql(_param);
//                  } else if("array".equals(type)){
//                	  String[] arrays = Utils.nvl(formatter.get("array")).split(";");
//                      List<Map<String,Object>> sList = new ArrayList<>();
//                      for(String val : arrays) {
//                          Map<String,Object> sMap = new HashMap<>();
//                          sMap.put("value", val.split(":")[0]);
//                          sMap.put("text", val.split(":")[1]);
//                          sList.add(sMap);
//                      }
//                      rslt = sList;
//                  }
//                  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<select id='" + selCol + "' ";
//            	  html += "style='width:" + col.getWidth() + ";' ";
//	              if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "title='"+col.getTooltip()+"' ";
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
////	                  html += " " + Utils.nvl(col.getValidationMessage());
//	              }
//	              boolean exclude = true;
//	              for(UMap e : attrList) {
//	            	  if(selCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || selCol.equalsIgnoreCase((String)e.get("attr_name"))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
////	              if(exclude) {
////	            	  col.setEditable("N");
////	            	  html += "class='select exclude' ";
////	              } else {
//	            	  html += "class='select' ";
////	              }
////	              if ("N".equals(col.getEditable())) {
////	                  html += "readonly='readonly' ";
////	              }
//
//	              html += ">";
//
//	              html += "<option value=\"\">선택</option>";
//	              for (int i = 0; i < rslt.size(); i++) {
//	                  Map<String, Object> map = rslt.get(i);
//	                  html += "<option value=\"" + map.get("value") + "\"";
//	                  if(StringUtils.isNotBlank(col.getDefault())) {
//	                	  if(col.getDefault().equals(map.get("value"))) {
//	                		  html += "selected='selected' ";
//	                	  }
//	                  }
//	                  html += ">"+ map.get("text") + "</option>";
//	              }
//	              html += "</select>";
//
//	          } else if ("date".equals(col.getType())) {
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<input id='" + selCol + "' ";
//            	  html += "style='width:" + col.getWidth() + ";' ";
//	              if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
////	                  html += " " + Utils.nvl(col.getValidationMessage());
//	              }
//	              boolean exclude = true;
//	              for(UMap e : attrList) {
//	            	  if(selCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || selCol.equalsIgnoreCase((String)e.get("attr_name"))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
//	              if(exclude) {
//	            	  col.setEditable("N");
//	            	  html += "class='calendar exclude' ";
//	              } else {
//	            	  html += "class='calendar' ";
//	              }
//	              if ("N".equals(col.getEditable())) {
//	                  html += "readonly='readonly' ";
//	              }
//	              html += "/>";
//
//	          } else if ("radio".equals(col.getType())) {
//	        	  //Map<String, Object> _param = new HashMap<>();
//	              Gson gson = new Gson();
//                  Type modelType = new TypeToken<HashMap<String,Object>>() {}.getType();
//                  HashMap<String,Object> formatter = gson.fromJson( col.getFormatter(), modelType);
//                  String type = (String)formatter.get("type");
////                  List<Map<String, Object>> rslt = new ArrayList<Map<String, Object>>();;
//                  String[] arrays = null;
//                  if("array".equals(type)){
//                	  arrays = Utils.nvl(formatter.get("array")).split(";");
//                      List<Map<String,Object>> sList = new ArrayList<>();
//                      for(String val : arrays) {
//                          Map<String,Object> sMap = new HashMap<>();
//                          sMap.put("value", val.split(":")[0]);
//                          sMap.put("text", val.split(":")[1]);
//                          sList.add(sMap);
//                      }
//  //                    rslt = sList;
//                  }
//                  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              for (String val : arrays) {
//	                  html +=  " <input type='radio' name='" + selCol + "' ";
//	                  if(StringUtils.isNotBlank(col.getTooltip())) {
//		            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//		              }
//	                  html += "value='" + val.split(":")[1] + "' ";
//	                  boolean exclude = true;
//		              for(UMap e : attrList) {
//		            	  if(selCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || selCol.equalsIgnoreCase((String)e.get("attr_name"))) {
//		            		  exclude = false;
//		            		  break;
//		            	  }
//		              }
//		              if("S".equals(col.getEditable()))
//		            	  exclude = false;
//
//		              if(exclude) {
//		            	  col.setEditable("N");
//		            	  html += "class='exclude' disabled='disabled' ";
//		              }
//	                  if ("N".equals(col.getEditable())) {
//	                      html += "readonly='readonly' ";
//	                  }
//	                  if(StringUtils.isNotBlank(col.getDefault())) {
//	                	  if(col.getDefault().equals(val.split(":")[1])) {
//	                		  html += "checked='checked' ";
//	                	  }
//	                  }
//	                  html += "/>" + val.split(":")[0] + "&nbsp;&nbsp;";
//	              }
//	          } else if ("textarea".equals(col.getType())) {
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<textarea ";
//	              html += "id='" + selCol + "' name='" + selCol + "' ";
//	              if ("".equals(col.getLine()) || col.getLine() == null) {
//	                  html += "rows=4 ";
//	              } else {
//	                  html += "rows=" + col.getLine() + " ";
//	              }
//
//            	  html += "style='width:" + col.getWidth() + ";' ";
//            	  if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              boolean exclude = true;
//	              for(UMap e : attrList) {
//	            	  if(selCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || selCol.equalsIgnoreCase((String)e.get("attr_name"))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
//	              if(exclude && StringUtils.isNotEmpty(dataObject.getSql())) {
//	            	  col.setEditable("N");
//	            	  html += "class='k-textbox exclude' ";
//	              } else {
//	            	  html += "class='k-textbox' ";
//	              }
//	              if ("N".equals(col.getEditable())) {
//	                  html += "readonly='readonly' ";
//	              }
//	              html += " />";
//	          } else if ("editor".equals(col.getType())) {
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<textarea ";
//	              html += "id='" + selCol + "' name='" + selCol + "' ";
//	              html += "rows=4 ";
//
//            	  html += "style='width:" + col.getWidth() + ";' ";
//	              if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              boolean exclude = true;
//	              for(UMap e : attrList) {
//	            	  if(selCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || selCol.equalsIgnoreCase((String)e.get("attr_name"))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
//	              if(exclude) {
//	            	  col.setEditable("N");
//	            	  html += "class='k-textbox exclude editor' ";
//	              } else {
//	            	  html += "class='k-textbox editor' ";
//	              }
//	              if ("N".equals(col.getEditable())) {
//	                  html += "readonly='readonly' ";
//	              }
//	              if(StringUtils.isNotBlank(col.getDefault())) {
//	            	  html += "placeholder='"+col.getDefault()+"' ";
//	              }
//	              html += " />";
//	              User user = (User)request.getSession().getAttribute("userInfo");
//	              html += "<script>$('#" + col.getId() + "').kendoEditor({"+
//		              		"resizable: {content: true,toolbar: true},"+
//		              		"tools: [ 'bold','italic','underline','strikethrough','fontName','fontSize','foreColor','backColor',"
//		              		+ "'justifyLeft','justifyCenter','justifyRight','justfifyFull',"
//		              		+ "'insertUnorderedList','insertOrderedList','indent','outdent',"
//		              		+ "'createLink','insertImage',"
//		              		+ "'tableWizard','createTable' ],"+
//		              		"imageBrowser: {\r\n" +
//			              	"   path : \""+user.getUser_id()+"\",\r\n" +
//		              		"	messages: {\r\n" +
//		              		"		dropFilesHere: \"파일을 드래그하십시오.\"\r\n" +
//		              		"	},\r\n" +
//		              		"	transport: {\r\n" +
//		              		"		read: \"/imageBrowser/read\",\r\n" +
//		              		"		destroy: {\r\n" +
//		              		"			url: \"/imageBrowser/destroy\",\r\n" +
//		              		"			type: \"POST\"\r\n" +
//		              		"		},\r\n" +
//		              		"		create: {\r\n" +
//		              		"			url: \"/imageBrowser/create\",\r\n" +
//		              		"			type: \"POST\"\r\n" +
//		              		"		},\r\n" +
//		              		"		thumbnailUrl: \"/imageBrowser/thumbnail\",\r\n" +
//		              		"		uploadUrl: \"/imageBrowser/upload\",\r\n" +
//		              		"		imageUrl: \"/imageBrowser/image?path={0}\"\r\n" +
//		              		"	}\r\n" +
//		              		"}, "+
//		              		"});</script>";
//
//	          } else if ("tree".equals(col.getType())) {
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<input ";
//	              html += "id='" + selCol + "' name='" + selCol + "' ";
//
//	              html += "style='width:" + col.getWidth() + ";' ";
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              html += " />";
//
//	          } else if ("file".equals(col.getType())) {
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<input type='file' ";
//	              html += "name='files[]' class='files' ";
//
//	              html += "style='width:" + col.getWidth() + ";' ";
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              html += " />";
//	              html += "<input type='hidden' id='" + selCol + "' class='fileId'/>";
//	          } else if ("num".equals(col.getType())) {
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<input ";
//	              html += "id='" + selCol + "' name='" + selCol + "' ";
//
//            	  html += "style='width:" + col.getWidth() + ";' ";
//            	  if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//            	  if(StringUtils.isNotBlank(normFormatter)) {
//            		  html += "data-format='"+normFormatter+"' ";
//            	  }
//            	  if(col.getMin() != null) {
//            		  html += "data-min='"+col.getMin()+"' ";
//            	  }
//            	  if(col.getMax() != null) {
//            		  html += "data-max='"+col.getMax()+"' ";
//            	  }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              boolean exclude = true;
//	              for(UMap e : attrList) {
//	            	  if(selCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || selCol.equalsIgnoreCase((String)e.get("attr_name"))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
//	              if(exclude && StringUtils.isNotEmpty(dataObject.getSql())) {
//	            	  col.setEditable("N");
//	            	  html += "class='numeric exclude' ";
//	              } else {
//	            	  html += "class='numeric ' ";
//	              }
//	              if ("N".equals(col.getEditable())) {
//	                  html += "readonly='readonly' ";
//	              }
//	              html += " />";
//	          } else if ("mask".equals(col.getType())) {
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              html += "<input ";
//	              html += "id='" + selCol + "' name='" + selCol + "' ";
//
//            	  html += "style='width:" + col.getWidth() + ";' ";
//            	  if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//            	  if(StringUtils.isNotBlank(normFormatter)) {
//            		  String mask = "";
//            		  if("ssn".equals(normFormatter)) {
//            			  mask = "000000-0000000";
//            		  } else if("card_no".equals(normFormatter)) {
//            			  mask = "0000-0000-0000-0000";
//            		  } else if("phone_no".equals(normFormatter)) {
//            			  mask = "999-0000-0000";
//            		  } else if("email".equals(normFormatter)) {
//            			  html += "type='email' validationMessage='이메일 형식이 부적절합니다.' ";
//            			  mask = "";
//            		  }
//            		  html += "data-mask='"+mask+"' ";
//            		  html += "data-maskname='"+normFormatter+"' ";
//            	  }
//            	  if(col.getMin() != null) {
//            		  html += "data-min='"+col.getMin()+"' ";
//            	  }
//            	  if(col.getMax() != null) {
//            		  html += "data-max='"+col.getMax()+"' ";
//            	  }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
//	              }
//	              boolean exclude = true;
//	              for(UMap e : attrList) {
//	            	  if(selCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || selCol.equalsIgnoreCase((String)e.get("attr_name"))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
//	              if(exclude && StringUtils.isNotEmpty(dataObject.getSql())) {
//	            	  col.setEditable("N");
//	            	  html += "class='masked exclude' ";
//	              } else {
//	            	  html += "class='masked ' ";
//	              }
//	              if ("N".equals(col.getEditable())) {
//	                  html += "readonly='readonly' ";
//	              }
//	              html += " />";
//	          } else if("text".equals(col.getType()) || "password".equals(col.getType())) {
//	        	  if("Y".equals(col.getColSpan())) {
//              		  if(colCnt == 1) {
//              			  html += "</tr>";
//              		  }
//	              }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "<td style='text-align:right;'><span class='requiredDot'>* </span>" + col.getValue() + "</td>";
//	              } else {
//	                  html += "<td style='text-align:right;'>" + col.getValue() + "</td>";
//	              }
//	              if("Y".equals(col.getColSpan())) {
//              		  html += "<td colspan='3'>";
//              		  colSpan = true;
//	              } else {
//	            	  html += "<td>";
//	              }
//	              if(StringUtils.isNotBlank(eventHml) && StringUtils.isNotBlank(normFormatter)) {
//	            	  html += "<span class='k-textbox k-space-right' style='width:100%;'>";
//	              }
//	              if ("password".equals(col.getType())) {
//	                  html += "<input type='password' ";
//	              } else {
//	            	  if(StringUtils.isNotBlank(eventHml) && StringUtils.isNotBlank(normFormatter)) {
//		            	  html += "<input type=\"input\" ";
//		              } else {
//		            	  html += "<input type=\"input\" class=\"k-textbox\" ";
//		              }
//	              }
//	              String keyInsCondition = Utils.nvl(col.getInit());
//	              if (keyInsCondition != "" && (keyInsCondition.startsWith("sq") || keyInsCondition.startsWith("seq") || keyInsCondition.startsWith("SQ") || keyInsCondition.startsWith("SEQ"))) {
//	                  html += "value='자동생성' ";
//	                  html += "disabled='true' ";
//	                  html += "id='" + selCol + "_show' name='" + selCol + "_show' ";
//	              } else {
//	                  html += "id='" + selCol + "' name='" + selCol + "' ";
//	              }
//
//	              /**if(!StringUtils.isEmpty(params.get("objectid")) && !StringUtils.isEmpty(params.get("objectval"))) {
//	               String objectid = (String)params.get("objectid");
//	               String objectval = (String)params.get("objectval");
//	               if(selCol.equals(objectid)) {
//	               System.out.println("&&&objectid :" + objectid);
//	               System.out.println("&&&objectval : " + objectval);
//	               html += "value='"+ objectval + "' ";
//	               }
//	               }*/
//
//	              if(col.getMin() != null) {
//            		  html += "minlength='"+col.getMin()+"' ";
//            	  }
//            	  if(col.getMax() != null) {
//            		  html += "maxlength='"+col.getMax()+"' ";
//            	  }
//
//	              if("pwInit".equals(normFormatter) || "idCheck".equals(normFormatter)) {
//                	  html += "style='width:" + col.getWidth() + "; max-width:80%; display:inline-flex;' ";
//                  } else {
//                	  html += "style='width:" + col.getWidth() + ";' ";
//                  }
//	              if ("Y".equals(col.getRequired())) {
//	                  html += "required ";
////	                  html += " " + Utils.nvl(col.getValidationMessage()) + " ";
//	              }
//	              if(StringUtils.isNotBlank(col.getTooltip())) {
//	            	  html += "data-tooltip='"+col.getTooltip()+"' ";
//	              }
//	              boolean exclude = true;
//	              for(UMap e : attrList) {
//	            	  if(StringUtils.isNotBlank(selCol) && (selCol.equalsIgnoreCase((String)e.get("ATTR_NAME")) || selCol.equalsIgnoreCase((String)e.get("attr_name")))) {
//	            		  exclude = false;
//	            		  break;
//	            	  }
//	              }
//	              if("S".equals(col.getEditable()))
//	            	  exclude = false;
//
//	              if(exclude && StringUtils.isNotEmpty(dataObject.getSql())) {
//	            	  col.setEditable("N");
//	            	  html += "class='exclude' disabled='disabled' ";
//	              }
//	              if ("N".equals(col.getEditable())) {
//	                  html += "readonly='readonly' ";
//	              }
//	              if(StringUtils.isNotBlank(col.getDefault())) {
//	            	  html += "placeholder='"+col.getDefault()+"' ";
//	              }
//
//	              html += "/>";
//
//	              if (keyInsCondition != "" && (keyInsCondition.startsWith("sq") || keyInsCondition.startsWith("seq") || keyInsCondition.startsWith("SQ") || keyInsCondition.startsWith("SEQ"))) {
//	                  params.put("insert_condition", keyInsCondition);
//	                  String insCondValue = "";
//	                  if("CUBRID".equalsIgnoreCase(dbType)) {
//	                	  insCondValue = dataMapper.getInsCondValue(params);
//	                  } else if("ORACLE".equalsIgnoreCase(dbType)) {
//	                	  insCondValue = dataMapper.getOracleInsCondValue(params);
//	                  }
//	                  else if("MARIADB".equalsIgnoreCase(dbType)) {
//	                	  insCondValue = dataMapper.getMariaDBInsCondValue(params);
//	                  }
//	                  html += "<input type='hidden'";
//	                  html += "id='" + selCol + "' name='" + selCol + "' ";
//	                  html += "value='" + insCondValue + "' ";
//	                  html += "/>";
//	              }
//	          }
//
//
//
//	          html += eventHml;
//	          if("text".equals(col.getType())) {
//	        	  if(StringUtils.isNotBlank(eventHml) && StringUtils.isEmpty(normFormatter)) {
//	        		  html += "</span>";
//	        	  }
//	          }
//	          if(!"checkbox".equals(col.getType())) {
//	        	  html += "</td>";
//	          } else {
//	        	  if(StringUtils.isEmpty(chkGroupLabel)) {
//	        		  html += "</td>";
//	        	  }
//	          }
//	          if(chkGroupEnd) {
//            	  html += "</td>";
//              }
//	          if(colSpan) {
//	        	  colCnt = 0;
//	        	  html += "</tr>";
//	        	  continue;
//	          }
//	          colCnt++;
//	          if(division == 1) {
//        		  html += "</tr>";
//        	  } else if(division == 2) {
//        		  if(hideClass != "") {
//        			  html += "</tr>";
//        			  colCnt = 0;
//        			  continue;
//        		  }
//        		  if(colCnt == 2) {
//        			  html += "</tr>";
//        			  colCnt = 0;
//        		  }
//        	  }
//	      }
//
//	      Map<String, Object> rtnMap = new HashMap<>();
//	      rtnMap.put("html", html);
//	      rtnMap.put("eventCols", eventCols);
//	      ObjectMapper om = new ObjectMapper();
//	      return om.writeValueAsString(rtnMap);
//	  }
//
//	  @GetMapping("/dataEdit.do")
//	  public ModelAndView dataEdit(HttpServletRequest request, @RequestParam Map<String, Object> params) throws Exception {
//	      ModelAndView mav = new ModelAndView();
//
//	      String fileName = params.get("xn").toString().trim() + ".xml";
//	      fileName = fileName.replaceAll("(?i)LIST", "DATA");
//	      String filePath = Utils.getFilePath(fileName);
//	      if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//	    	  filePath = Utils.getAdmXmlPath(fileName);
//	      }
//	      if (!Utils.fileCheck(filePath)) {
//	          throw new Exception("등록된 DATA XML 파일이 없습니다.");
//	      }
//
//	      DataRoot dataObject = Utils.getDataXmlToObject(filePath);
//	      int lines = 1;
//
//	      if (params.get("xn") == null || "".equals(params.get("xn").toString())) {
//	          throw new Exception("============ [xn is null] ============");
//	      }
//
//	      ArrayList<String> eventCols = new ArrayList<String>();
//	      lines = dataObject.getDivision();
//	      if(lines == 1) {
//	    	  String[] widthArr = dataObject.getWidths().split(":");
//	    	  mav.addObject("labelWidth", widthArr[0] + "%");
//	      } else {
//	    	  String[] widthsArr = dataObject.getWidths().split(";");
//	    	  String[] widthArr1 = widthsArr[0].split(":");
//	    	  String[] widthArr2 = widthsArr[1].split(":");
//	    	  mav.addObject("lines", "2");
//	    	  mav.addObject("label1Width", widthArr1[0] + "%");
//	    	  mav.addObject("data1Width", widthArr1[1] + "%");
//	    	  mav.addObject("label2Width", widthArr2[0] + "%");
//	      }
//
//	      mav.addObject("sid", params.get("sid"));
//	      mav.addObject("xn", params.get("xn"));
//	      mav.addObject("pid", params.get("pid"));
//	      mav.addObject("objectid", params.get("objectid"));
//	      mav.addObject("objectval", params.get("objectval"));
//	      mav.addObject("pobjectid", params.get("pobjectid"));
//	      mav.addObject("pobjval", params.get("pobjval"));
////	      mav.addObject("columnIds", toObjStr(columnIds));
//	      if(StringUtils.isNotBlank(dataObject.getUserJs())) {
//	    	  mav.addObject("jsfileyn", "Y");
//	    	  mav.addObject("jsfileurl", Utils.nvl(dataObject.getUserJs()));
//	      }
//	      mav.addObject("userHtml", Utils.nvl(dataObject.getUserHtml().getHtmls()));
//	      mav.addObject("desc", Utils.nvl(dataObject.getDesc()).replaceAll("\n", "<br/>"));
//		  mav.addObject("isDevMode", isDevMode);
//	      String[] eventColArr = eventCols.toArray(new String[eventCols.size()]);
//	      mav.addObject("eventCols", toObjStr(eventColArr));
//
//	      if(params.containsKey("height"))
//	    	  mav.addObject("height",Integer.parseInt(params.get("height").toString()));
//	      else {
//	    	  mav.addObject("height",0);
//	      }
//	//      mav.addObject("mode","C");
//
//	      mav.addObject("title", dataObject.getName());
//
//	      mav.addObject("customInsert", dataObject.getEvent().getInsert());
//
//	      mav.setViewName("core/dataEdit");
//	      return mav;
//	  }
//
//	  @GetMapping("/dataFill.json")
//	  public ModelAndView dataFill(HttpServletRequest request, @RequestParam Map<String, Object> params) throws Exception {
//	      ModelAndView mav = new ModelAndView();
//
//	      String fileName = params.get("xn").toString().trim() + ".xml";
//	      fileName = fileName.replaceAll("(?i)LIST", "DATA");
//	      String filePath = Utils.getFilePath(fileName);
//	      if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//	    	  filePath = Utils.getAdmXmlPath(fileName);
//	      }
//	      if (!Utils.fileCheck(filePath)) {
//	          throw new Exception("등록된 DATA XML 파일이 없습니다.");
//	      }
//
//	      DataRoot dataObject = Utils.getDataXmlToObject(filePath);
//	      int lines = 1;
//
//	      if (params.get("xn") == null || "".equals(params.get("xn").toString())) {
//	          throw new Exception("============ [xn is null] ============");
//	      }
//
//	      ArrayList<String> eventCols = new ArrayList<String>();
//	      lines = dataObject.getDivision();
//	      if(lines == 1) {
//	    	  String[] widthArr = dataObject.getWidths().split(":");
//	    	  mav.addObject("labelWidth", widthArr[0] + "%");
//	      } else {
//	    	  String[] widthsArr = dataObject.getWidths().split(";");
//	    	  String[] widthArr1 = widthsArr[0].split(":");
//	    	  String[] widthArr2 = widthsArr[1].split(":");
//	    	  mav.addObject("lines", "2");
//	    	  mav.addObject("label1Width", widthArr1[0] + "%");
//	    	  mav.addObject("data1Width", widthArr1[1] + "%");
//	    	  mav.addObject("label2Width", widthArr2[0] + "%");
//	      }
//
//	      mav.addObject("sid", params.get("sid"));
//	      mav.addObject("xn", params.get("xn"));
//	      mav.addObject("pid", params.get("pid"));
//	      mav.addObject("objectid", params.get("objectid"));
//	      mav.addObject("objectval", params.get("objectval"));
//	      mav.addObject("pobjectid", params.get("pobjectid"));
//	      mav.addObject("pobjval", params.get("pobjval"));
////	      mav.addObject("columnIds", toObjStr(columnIds));
//	      if(StringUtils.isNotBlank(dataObject.getUserJs())) {
//	    	  mav.addObject("jsfileyn", "Y");
//	    	  mav.addObject("jsfileurl", Utils.nvl(dataObject.getUserJs()));
//	      }
//	      String[] eventColArr = eventCols.toArray(new String[eventCols.size()]);
//	      mav.addObject("eventCols", toObjStr(eventColArr));
//	//      mav.addObject("mode","C");
//
//	      mav.addObject("title", dataObject.getName());
//
//	      mav.addObject("customInsert", dataObject.getEvent().getInsert());
//
//	      mav.setViewName("core/dataEdit");
//	      return mav;
//	  }
//
//	  private String toObjStr(String[] src) {
//        String resultStr = "";
//        for (int i = 0; i < src.length; i++) {
//            if (i == src.length - 1) {
//                resultStr += src[i];
//            } else {
//                resultStr += src[i] + ",";
//            }
//        }
//        return resultStr;
//	  }
}
