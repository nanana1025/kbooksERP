package kbookERP.core.mngm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.fasterxml.jackson.databind.ObjectMapper;

import kbookERP.core.files.FileController;
import kbookERP.util.Utils;
import kbookERP.util.map.CustomMapUtil;
import kbookERP.util.map.LowerKeyMap;

public class KendoController {
    @Autowired
    MngmMapper mngmMapper;
    @Autowired
    FileController fileController;

    /**
     * 목록 json
     * @param request
     * @param params
     * @return
     * @throws Exception
     */
//    @GetMapping("/gridDataList.json")
//    public ModelAndView gridDataList(HttpServletRequest request, @RequestParam Map<String,Object> params) throws Exception {
//        ModelAndView mav = new ModelAndView();
//
//        String filePath = "D:/adminXml/"+params.get("sid")+"_LIST.xml";
//        if(!Utils.fileCheck(filePath)) {
//            throw new Exception("등록된 CRUD XML 파일이 없습니다.");
//        }
//
//        ListObject listObject = Utils.getListXmlToObject(filePath);
//        ListItem listItem = null;
//        if(params.get("sid") == null || "".equals(params.get("sid").toString())) {
//            throw new Exception("============ [SID is null] ============");
//        }
//
//        for(ListItem item : listObject.listItem) {
//            if(params.get("sid").equals(item.getSid())) {
//                listItem = item;
//            }
//        }
//
//        List<ListColumn> selectColumns = listItem.getSelect();
//
//        String[] columnIds = new String[selectColumns.size()];
//        String[] colTypes  = new String[selectColumns.size()];
//        String[] colNames  = new String[selectColumns.size()];
//
//        for(int i = 0; i < selectColumns.size(); i++) {
//            String _condition = Utils.nvl(selectColumns.get(i).getCondition());
//            String _alias = Utils.nvl(selectColumns.get(i).getAlias());
//            String _selCol = Utils.nvl(selectColumns.get(i).getSelcol());
//
//            String _tableAlias = Utils.nvl(selectColumns.get(i).getTargettable());
//            if(!"".equals(_tableAlias)) {
//                _tableAlias += ".";
//            }
//
//            String _prefixFK = "fk".equals(selectColumns.get(i).getColtype())?"fk_":"";
//
//            colTypes[i] = selectColumns.get(i).getColtype();
//
//            if("file".equals(colTypes[i]) || "imgfile".equals(colTypes[i])){
//                columnIds[i] = "(select GROUP_CONCAT(file_id || '|' || file_seq || '|' || file_nm || '|' || file_type SEPARATOR '/')" +
//                        " from tesy_file where file_id="+_tableAlias + _selCol+") as "+_selCol;
//            } else {
//                if(!StringUtils.isEmpty(_alias)) {
//                    if(StringUtils.isEmpty(_condition)) {
//                        columnIds[i] = "("+_tableAlias + _selCol +") as " + _prefixFK + _alias;
//                    } else {
//                        columnIds[i] = "("+_condition +") as " + _prefixFK + _alias;
//                    }
//                } else {
//                    if(StringUtils.isEmpty(_condition)) {
//                        columnIds[i] = "("+_tableAlias + _selCol +") as " + _prefixFK + _selCol;
//                    } else {
//                        columnIds[i] = "("+_condition +") as " + _prefixFK + _selCol;
//                    }
//                }
//            }
//
//            colNames[i] = _selCol;
//        }
//
//        int posStart = 0;
//        int take = 0;
//        if(params.get("skip") != null) {
//            posStart = Integer.parseInt(params.get("skip").toString())+1;
//        } else {
//            posStart = 1;
//        }
//        if(params.get("take") != null) {
//            take = Integer.parseInt(params.get("take").toString());
//        } else {
//            take = 20;
//        }
//
//        Map<String,Object> sParam = new HashMap<>();
//        sParam.put("querytag"	, listItem.getQuerytag());
//        sParam.put("columnArr"  , columnIds);
//        sParam.put("from"       , listItem.getFrom());
//        sParam.put("where"      , listItem.getWhere());
//        sParam.put("groupby"    , listItem.getGroupby());
//        sParam.put("orderby"    , listItem.getOrderby());
//        sParam.put("startNum"   , posStart-1);
//        sParam.put("endNum"     , take);
//        sParam.put("nm_mask"    , params.get("nm_mask"));
//        sParam.put("cd_mask"    , params.get("cd_mask"));
//        sParam.put("orderByClause", getOrderByClauses(selectColumns, params));
//
//        String searchClause = getSearchClause(selectColumns, params);
//
//        if(params.get("cobjectid") != null) {
//            String[] cobjids = params.get("cobjectid").toString().split(",");
//            String[] cobjvals = params.get("cobjectval").toString().split(",");
//
//            for(int i=0;i<cobjids.length;i++) {
//                searchClause += " AND "+cobjids[i]+"=" +"'"+cobjvals[i]+"' ";
//            }
//            sParam.put("searchClause" , searchClause);
//        } else {
//            sParam.put("searchClause" , searchClause);
//        }
//
//        String dynamicSearchClause = CustomMapUtil.converseDynamicParamMapToString(params);
//        if(!StringUtils.isEmpty(dynamicSearchClause)) {
//            sParam.put("dynamicSearchClause" , dynamicSearchClause);
//        }
//        List<LowerKeyMap> sResult = mngmMapper.getDataListByXml(sParam);
//        int totalCnt = mngmMapper.getDataListByXmlCnt(sParam);
//        System.out.println(sResult);
//
//        mav.setView(new MappingJackson2JsonView());
//        mav.addObject("gridData", sResult);
//        mav.addObject("total", totalCnt);
//
//        return mav;
//    }
//
//    @RequestMapping("/kendo/grid.do")
//    public ModelAndView grid(HttpServletRequest request, @RequestParam Map<String,Object> params) throws Exception {
//        ModelAndView mav = new ModelAndView();
//
//        String xmlPath = "D:/adminXml/"+params.get("sid")+"_LIST.xml";
//
//        if(!Utils.fileCheck(xmlPath)) {
//            throw new Exception("등록된 LIST XML 파일이 없습니다.");
//        }
//
//        ListObject listObject = Utils.getListXmlToObject(xmlPath);
//        ListItem listItem = null;
//
//        for(ListItem item : listObject.listItem) {
//            if(params.get("sid").equals(item.getSid())) {
//                listItem = item;
//            }
//        }
//
//        List<ListColumn> selectColumns = listItem.getSelect();
//
//        String objectIdIdx = "";
//        List<HashMap> columns = new ArrayList<HashMap>();
//        List<HashMap> colgroups = new ArrayList<HashMap>();
//        LowerKeyMap fields = new LowerKeyMap();
//        HashMap<String,Object> schemafields = new HashMap<String,Object>();
//
//        for(int i=0;i<selectColumns.size();i++) {
//            ListColumn column = selectColumns.get(i);
//            HashMap<String,Object> map = new HashMap<String,Object>();
//            LowerKeyMap type = new LowerKeyMap();
//            String selCol = Utils.nvl(column.getSelcol()).toLowerCase();
//            if(selCol.contains(".")){
//                selCol = selCol.substring(selCol.indexOf(".")+1, selCol.length());
//            }
//            map.put("field", selCol);
//            map.put("title", Utils.nvl(column.getLabel()));
//            map.put("width", Utils.nvl(column.getWidth())+"%");
//            map.put("ordno", Utils.nvl(column.getOrdno()));
//
//            LowerKeyMap headerAttr = new LowerKeyMap();
//            headerAttr.put("style", "text-align:center;vertical-align:middle;");
//            map.put("headerAttributes", headerAttr);
//
//            if("Y".equals(column.getHiddenyn())) {
//                map.put("hidden", true);
//            }
//
//            if("link".equals(column.getColtype())){
//                map.put("template", "<a href=\\\"#:"+Utils.nvl(column.getSelcol().toLowerCase())+"#\\\">${\""+Utils.nvl(column.getSelcol()).toLowerCase()+"\\\"}</a>"); /*kendo link column 설정*/
//            } else if("checkbox".equals(column.getColtype())){
//                map.put("template", "<input type=\\\"checkbox\\\" #="+Utils.nvl(column.getSelcol().toLowerCase())+"==\\\"Y\\\" ? checked=\\\"checked\\\" : \\\"\\\" #  disabled=\\\"disabled\\\" />");
//            } else if("price".equals(column.getColtype())){
//                map.put("format", "{0:c}");
//            }else if("select_sql".equals(column.getColtype())){
//                List<Map<String,Object>> rslt = new ArrayList<>();
//                Map<String,Object> _param = new HashMap<>();
//                _param.put("selectSql",column.getSelect_sql());
//                rslt = mngmMapper.getSelectComboBySql(_param);
//                map.put("values", rslt);
//            } else if("emptych".equals(column.getColtype())){
//                map.put("template", "<input class=\\\""+params.get("sid")+"_emptych\\\" type=\\\"checkbox\\\" />");
//                map.put("field", "emptych");
//            }else if("emptyed".equals(column.getColtype())){
//                map.put("template", "<input class=\\\""+params.get("sid")+"_emptyed\\\" style=\\\"width:100%;\\\" type=\\\"number\\\" />");
//                map.put("field", "emptyed");
//            }else if("custombtn".equals(column.getColtype())){
//                map.put("template", "<button class=\\\"kendoBtn "+params.get("sid")+"_custombtn\\\" style=\\\"width:100%;height:25px;\\\" type=\\\"button\\\" onClick=\\\""+column.getOnclick()+"(#:"+column.getObjid()+"#)"+"\\\">"+column.getBtntext()+"</button>");
//            }else if("customfilebtn".equals(column.getColtype())){
//                map.put("template", "<button class=\\\"kendoBtn "+params.get("sid")+"_custombtn\\\" style=\\\"width:100%;height:25px;\\\" type=\\\"button\\\" onClick=\\\""+column.getOnclick()+"(#:"+column.getObjid()+"#"+",&bq;"+column.getObjcol()+"&bq;)\\\">"+column.getBtntext()+"</button>");
//            }else if("id".equals(column.getColtype())){
//                mav.addObject("grididcol", Utils.nvl(column.getSelcol()).toLowerCase());
//            }
//
//            if("file".equals(column.getColtype()) || "imgfile".equals(column.getColtype())){
//                mav.addObject("filecolname", column.getSelcol());
//                map.put("template", "<div class=\\\"fileInfo\\\">#="+Utils.nvl(column.getSelcol()).toLowerCase()+"==null?\\\"\\\":"+Utils.nvl(column.getSelcol()).toLowerCase()+"#</div>");
//            }
//
//            LowerKeyMap alignMap = new LowerKeyMap();
//
//            if(!"".equals(column.getColalign())){
//                alignMap.put("style", "text-align:"+column.getColalign()+";");
//            }
//            HashMap<String,Object> schemafield = new HashMap<String,Object>();
//
//            if(column.getSelcol().toLowerCase().equals(column.getSelcol().toLowerCase())){
//                if("link".equals(column.getColtype())){
//                    alignMap.put("class", column.getColtype());
//                    map.put("template", "<a href=\\\"#:"+Utils.nvl(column.getSelcol().toLowerCase())+"#\\\">${"+Utils.nvl(column.getSelcol()).toLowerCase()+"}</a>"); /*kendo link column 설정*/
//                }else if("select_sql".equals(column.getColtype())) {
//                    alignMap.put("class", column.getColtype());
//
//                    List<Map<String, Object>> rslt = new ArrayList<>();
//                    Map<String, Object> _param = new HashMap<>();
//                    _param.put("selectSql", column.getSelect_sql());
//                    rslt = mngmMapper.getSelectComboBySql(_param);
//                    map.put("values", rslt);
//
//
//                    schemafield.put("field", column.getSelcol().toLowerCase());
//                    schemafields.put(column.getSelcol().toLowerCase(), schemafield);
//                }else if("price".equals(column.getColtype())) {
//                    alignMap.put("class", column.getColtype());
//
//                    schemafield.put("field", column.getSelcol().toLowerCase());
//                    schemafield.put("format", "{0:c}");
//                    schemafields.put(column.getSelcol().toLowerCase(), schemafield);
//                }else if("calendar".equals(column.getColtype())){
//                    alignMap.put("class", column.getColtype());
//                }else if("checkbox".equals(column.getColtype())){
//                    alignMap.put("class", column.getColtype());
////                    map.put("template", "<input type='checkbox' #="+ column.getSelcol().toLowerCase() +" == 'Y' ? \"checked='checked'\" : '' # class='chkbx' disabled='disabled' />");
//                    map.put("template", "<input type=\\\"checkbox\\\" #="+Utils.nvl(column.getSelcol().toLowerCase())+"==\\\"Y\\\" ? checked=\\\"checked\\\" : \\\"\\\" #  disabled=\\\"disabled\\\" />");
//                    map.put("editable", false);
//
//                    schemafield.put("field", column.getSelcol().toLowerCase());
//                    schemafields.put(column.getSelcol().toLowerCase(), schemafield);
//                }else if("file".equals(column.getColtype())){
//                    alignMap.put("class", column.getColtype());
//                    schemafield.put("field", column.getSelcol().toLowerCase());
//                    schemafield.put("editable", false);
//                    schemafields.put(column.getSelcol().toLowerCase(), schemafield);
//                }
//
//                if("Y".equals(column.getKeyyn())){
//                    mav.addObject("grididcol", column.getSelcol());
//                }
//
//            }
//            map.put("attributes", alignMap);
//
//            type.put("type", "string");
//            fields.put(column.getSelcol(), type);
//
//            if("".equals(column.getColgroup()) || column.getColgroup() == null ){
//                columns.add(map);
//            }else{
//                map.put("colgroup", column.getColgroup());
//                colgroups.add(map);
//            }
//        }
//
//        List<String> groupNameList = new ArrayList<String>();
//        List<HashMap> groupList = new ArrayList<HashMap>();
//        for(HashMap map : colgroups){
//            String cg = (String)map.get("colgroup");
//            HashMap<String,Object> cmap = new HashMap<String, Object>();
//            if(!groupNameList.contains(cg)){
//                groupNameList.add(cg);
//                cmap.put("title", cg);
//
//                LowerKeyMap cAlignMap = new LowerKeyMap();
//                cAlignMap.put("style", "text-align:center;");
//                cmap.put("headerAttributes", cAlignMap);
//
//                List<HashMap<String,Object>> gcolumns= new ArrayList<>();
//                gcolumns.add(map);
//                cmap.put("columns", gcolumns);
//                groupList.add(cmap);
//            }else{
//                for(HashMap tmap : groupList){
//                    List<HashMap<String,Object>> tcolumns= new ArrayList<>();
//                    if(tmap.get("title").equals(cg)){
//                        tcolumns = (List<HashMap<String, Object>>) tmap.get("columns");
//                        tcolumns.add(map);
//                        tmap.put("columns", tcolumns);
//                    }
//                }
//            }
//        }
//
//        for(HashMap tmap : groupList){
//            List<HashMap<String,Object>> tcolumns = (List<HashMap<String, Object>>) tmap.get("columns");
//            String sordno = (String)tcolumns.get(0).get("ordno");
//            int ordno = Integer.parseInt(sordno);
//            columns.add(ordno, tmap);
//        }
//
//        mav.addObject("gridInline", Utils.nvl(listItem.getGridinline()));
//        mav.addObject("listmode", Utils.nvl(listItem.getListmode()));
//        mav.addObject("jsfileyn", Utils.nvl(listItem.getJsfileyn()));
//        mav.addObject("jsfileurl", Utils.nvl(listItem.getJsfileurl()));
//        mav.addObject("customDeleteUrl", Utils.nvl(listItem.getCustomdeleteurl()));
//
//        ObjectMapper mapper = new ObjectMapper();
//        String columnStr = mapper.writeValueAsString(columns);
//        columnStr = Utils.replaceCol(columnStr);
//        mav.addObject("schemafields", mapper.writeValueAsString(schemafields));
//        mav.addObject("columns", columnStr);
//        mav.addObject("fields", mapper.writeValueAsString(fields));
//        mav.addObject("total", "0");
//
//        mav.addObject("searchHml", getSearchComboHtml(selectColumns, params.get("sid").toString()));
//
//        mav.addObject("sid", params.get("sid"));
//        mav.addObject("scrtype", params.get("scrtype"));
//        mav.addObject("objectIdIdx", objectIdIdx);
//        mav.addObject("objectId", listItem.getObjectid());
//        mav.addObject("title", listItem.getTitle());
//
//        mav.setViewName("core/kendo/grid");
//
//        return mav;
//    }
//
//    @RequestMapping("/kendo/tree.do")
//    public String tree(@RequestParam Map<String,Object> params) throws Exception {
//        return "core/kendo/tree";
//    }
//
//    @RequestMapping("/kendo/view.do")
//    public String view(@RequestParam Map<String,Object> params) throws Exception {
//        return "core/kendo/view";
//    }
//
//    @RequestMapping("/kendo/splitter.do")
//    public String splitter(@RequestParam Map<String,Object> params) throws Exception {
//        return "core/kendo/splitter";
//    }
//
//    @RequestMapping("/kendo/tab.do")
//    public String tab(@RequestParam Map<String,Object> params) throws Exception {
//        return "core/kendo/tab";
//    }
//
//    @RequestMapping("/kendo/layout.do")
//    public String layout(@RequestParam Map<String,Object> params, Model model) throws Exception {
//        String viewName = "";
//        String menuMode = Utils.nvl(params.get("menuMode"),"horizonntal");
//        String scrnMode = "";
//
//        switch(params.get("type").toString()) {
//            case "1" :  viewName = "core/layout/layout_t1";
//                        break;
//            case "2" :  viewName = "core/layout/layout_t2";
//                        scrnMode = "vertical";
//                        break;
//            case "3" :  viewName = "core/layout/layout_t2";
//                        scrnMode = "horizontal";
//                        break;
//            case "4" :  viewName = "core/layout/layout_t3";
//                        scrnMode = "vertical";
//                        break;
//            case "5" :  viewName = "core/layout/layout_t3";
//                        scrnMode = "horizontal";
//                        break;
//            default  :  viewName = "core/layout/layout_t1";
//                        break;
//        }
//
//        model.addAttribute("menuMode", menuMode);
//        model.addAttribute("scrnMode", scrnMode);
//
//        return viewName;
//    }
//
//    @RequestMapping("/kendo/menu.do")
//    public String menu(@RequestParam Map<String,Object> params) throws Exception {
//        return "core/kendo/menu";
//    }
//
//
//    public String getSearchComboHtml(List<ListColumn> columns, String sid) {
//        String searchDivId = sid+"_searchDiv";
//        String rtnStr = "";
//        String hml = "";
//        int count = 0;
//        for(ListColumn col : columns) {
//            if("Y".equals(col.getSearchyn())) {
//                hml += "<div class='period-wrapper'>";
//                if("date".equals(col.getSearchtype())) {
//                    hml += "<label class=\"ml\" for='"+col.getSelcol()+ "'>" + col.getLabel() + " </label>" +  "<input id='"+col.getSelcol()+"' class=\"calendar ml\" title=\""+col.getLabel()+"\"'>";
//                } else if("date_fromto".equals(col.getSearchtype())) {
//                    hml += "<label class=\"ml\" for='"+col.getSelcol()+ "'>" + col.getLabel() + " </label>" +  "<input id='"+col.getSelcol()+"_date_from' class=\"calendar ml\" title=\""+col.getLabel()+"\"'>";
//                    hml += " ~ " +  "<input id='"+col.getSelcol()+"_date_to' class=\"calendar\" title=\""+col.getLabel()+"\"'>";
//                } else if("qty_fromto".equals(col.getSearchtype())) {
//                    hml += "<label class=\"ml\" for='" + col.getSelcol() + "'>" + col.getLabel() + " </label>" + "<input id='" + col.getSelcol() + "_qty_from' class=\"k-textbox ml\" title=\"" + col.getLabel() + "\"'>";
//                    hml += " ~ " + "<input id='" + col.getSelcol() + "_qty_to' class=\"k-textbox\" title=\"" + col.getLabel() + "\"'>";
//                } else if("qty".equals(col.getSearchtype())) {
//                    hml += "<label class=\"ml\" for='"+col.getSelcol()+ "'>" + col.getLabel() + " </label>" +  "<input id='"+col.getSelcol()+"' class=\"k-textbox ml\" title=\""+col.getLabel()+"\"'>";
//                } else if("select_sql".equals(col.getSearchtype())) {
//                    String selectSql = Utils.nvl(col.getSearchcondition());
//                    Map<String,Object> _param = new HashMap<String, Object>();
//                    _param.put("selectSql",selectSql);
//                    List<Map<String,Object>> sResult = mngmMapper.getSelectComboBySql(_param);
//
//                    hml += "<label class=\"ml\" for='"+col.getSelcol()+ "'>" + col.getLabel() + " </label>" +  "<select id='"+col.getSelcol()+"' class=\"select ml\" title=\""+col.getLabel()+"\"'>";
//                    hml += "<option value=\"\">선택</option>";
//                    for(int i=0; i<sResult.size(); i++){
//                        Map<String,Object> map = sResult.get(i);
//                        hml += "<option value=\""+map.get("value")+"\">"+map.get("text")+"</option>";
//                    }
//                    hml += "</select>";
//                } else if("select_array".equals(col.getSearchtype())) {
//                    String[] arrays = Utils.nvl(col.getSearchcondition()).split(";");
//                    List<Map<String,Object>> sList = new ArrayList<>();
//                    for(String val : arrays) {
//                        Map<String,Object> sMap = new HashMap<>();
//                        sMap.put("value", val.split(":")[0]);
//                        sMap.put("text", val.split(":")[1]);
//                        sList.add(sMap);
//                    }
//
//                    hml += "<label class=\"ml\" for='"+col.getSelcol()+ "'>" + col.getLabel() + " </label>" +  "<select id='"+col.getSelcol()+"' class=\"select ml\" title=\""+col.getLabel()+"\"'>";
//                    for(int i=0; i<sList.size(); i++){
//                        Map<String,Object> map = sList.get(i);
//                        hml += "<option value=\""+map.get("value")+"\">"+map.get("text")+"</option>";
//                    }
//                    hml += "</select>";
//                } else if("compare".equals(col.getSearchtype())) {
//                    hml += "<label class=\"ml\" for='"+col.getSelcol()+ "'>" + col.getLabel() + " </label>" +    "<select id='"+col.getSelcol()+"_compare' class=\"select ml\" title=\""+col.getLabel()+"\"' style='width:50px;'>";
//                    hml += "<option value=\"=\">=</option>";
//                    hml += "<option value=\"<=\"><=</option>";
//                    hml += "<option value=\"<\"><</option>";
//                    hml += "<option value=\">\">></option>";
//                    hml += "<option value=\">=\">>=</option>";
//                    hml += "</select>";
//                    hml += "<input type='text' class=\"k-textbox\" id='"+col.getSelcol()+"'>";
//                } else {
//                    hml += "<label class=\"ml\" for='"+col.getSelcol()+ "'>" + col.getLabel() + " </label>" +  "<input type='text' class=\"k-textbox ml\" id='"+col.getSelcol()+"'>";
//                    hml += "<input type=\"checkbox\" id='"+col.getSelcol()+"_like' checked='checked' class=\"k-checkbox ml\"><label class=\"k-checkbox-label k-tool like-chkbox ml\" for='"+col.getSelcol()+"_like'> LIKE</label> ";
//                }
//                hml += "</div>";
//                count++;
//            }
//        }
//        if(count > 0) {
//            hml += "<button id=\""+ sid +"_searchBtn\" class=\"ml\">검색</button>";
//            rtnStr = "<div id='"+searchDivId+"' style='margin: 3px 10px'>" + hml+ "</div>";
//        } else {
//            rtnStr = "<div style='margin: 3px 10px'>" + hml+ "</div>";
//        }
//
//        return rtnStr;
//    }
//
//    public String getSearchClause(List<ListColumn> columns, Map<String,Object> params) {
//        String clause = "";
//        for(ListColumn col : columns) {
//            if("Y".equals(col.getSearchyn())) {
//                if("date_fromto".equals(col.getSearchtype())) {
//                    if(params.get(col.getSelcol()+"_date_from") != null && params.get(col.getSelcol()+"_date_from") != "") {
//                        String colAlias = col.getSelcol().replaceAll("_date_from","");
//                        if(!StringUtils.isEmpty(col.getSearchkey())) {
//                            colAlias = col.getSearchkey();
//                        }
//                        if(colAlias.indexOf(".")>-1) {
//                            colAlias = colAlias.substring(colAlias.indexOf(".")+1, colAlias.length());
//                        }
//                        clause += "AND " + colAlias + " >= '" + Utils.nvl(params.get(col.getSelcol()+"_date_from")) + "'";
//                    }
//                    if(params.get(col.getSelcol()+"_date_to") != null && params.get(col.getSelcol()+"_date_to") != "") {
//                        String colAlias = col.getSelcol().replaceAll("_date_to","");
//                        if(!StringUtils.isEmpty(col.getSearchkey())) {
//                            colAlias = col.getSearchkey();
//                        }
//                        if(colAlias.indexOf(".")>-1) {
//                            colAlias = colAlias.substring(colAlias.indexOf(".")+1, colAlias.length());
//                        }
//                        clause += "AND " + colAlias + " <= '" + Utils.nvl(params.get(col.getSelcol()+"_date_to")) + "'";
//                    }
//                } else if("qty_fromto".equals(col.getSearchtype())) {
//                    if(params.get(col.getSelcol()+"_qty_from") != null && params.get(col.getSelcol()+"_qty_from") != "") {
//                        String colAlias = col.getSelcol();
//                        if(!StringUtils.isEmpty(col.getSearchkey())) {
//                            colAlias = col.getSearchkey();
//                        }
//                        if(colAlias.indexOf(".")>-1) {
//                            colAlias = colAlias.substring(colAlias.indexOf(".")+1, colAlias.length());
//                        }
//                        clause += "AND " + colAlias + " >= '" + Utils.nvl(params.get(col.getSelcol()+"_qty_from")) + "'";
//                    }
//                    if(params.get(col.getSelcol()+"_qty_to") != null && params.get(col.getSelcol()+"_qty_to") != "") {
//                        String colAlias = col.getSelcol();
//                        if(!StringUtils.isEmpty(col.getSearchkey())) {
//                            colAlias = col.getSearchkey();
//                        }
//                        if(colAlias.indexOf(".")>-1) {
//                            colAlias = colAlias.substring(colAlias.indexOf(".")+1, colAlias.length());
//                        }
//                        clause += "AND " + colAlias + " <= '" + Utils.nvl(params.get(col.getSelcol()+"_qty_to")) + "'";
//                    }
//                } else if("compare".equals(col.getSearchtype())) {
//                    if(params.get(col.getSelcol()) != null && params.get(col.getSelcol()) != "") {
//                        String colAlias = col.getSelcol();
//                        if(!StringUtils.isEmpty(col.getSearchkey())) {
//                            colAlias = col.getSearchkey();
//                        }
//                        if (colAlias.indexOf(".") > -1) {
//                            colAlias = colAlias.substring(colAlias.indexOf(".") + 1, colAlias.length());
//                        }
//                        clause += "AND " + colAlias + " " + Utils.nvl(params.get(col.getSelcol()+"_compare")) + " '" + Utils.nvl(params.get(col.getSelcol())) + "'";
//                    }
//                } else {
//                    if(params.get(col.getSelcol()) != null && params.get(col.getSelcol()) != "") {
//                        String colAlias = col.getSelcol();
//                        if(!StringUtils.isEmpty(col.getSearchkey())) {
//                            colAlias = col.getSearchkey();
//                        }
//                        if(colAlias.indexOf(".")>-1) {
//                            colAlias = colAlias.substring(colAlias.indexOf(".")+1, colAlias.length());
//                        }
//                        if("true".equals(params.get(col.getSelcol()+"_like"))) {
//                            clause += "AND UCASE(" + colAlias + ") LIKE UCASE('%'||'" + Utils.decodeJavascriptString(Utils.nvl(params.get(col.getSelcol()))) + "'||'%')";
//                        } else {
//                            clause += "AND UCASE(" + colAlias + ") = UCASE('" + Utils.decodeJavascriptString(Utils.nvl(params.get(col.getSelcol()))) + "')";
//                        }
//
//                    }
//                }
//            }
//        }
//        //필터 영역
//        if(params.get("filter[logic]") != null && !"".equals(params.get("filter[logic]"))){
//            int i=0;
//            while(true){
//                if(params.get("filter[filters]["+i+"][field]") == null){
//                    break;
//                }
//                String column = (String)params.get("filter[filters]["+i+"][field]");
//                String operator = (String)params.get("filter[filters]["+i+"][operator]");
//                String value = (String)params.get("filter[filters]["+i+"][value]");
//                if("contains".equals(operator)){
//                    clause += "AND UCASE(" + column + ") ";
//                    clause += "LIKE UCASE('%'||'" + Utils.decodeJavascriptString(value) + "'||'%') ";
//                } else if("startswith".equals(operator)){
//                    clause += "AND UCASE(" + column + ") ";
//                    clause += "LIKE UCASE('" + Utils.decodeJavascriptString(value) + "'||'%') ";
//                } else if("eq".equals(operator)){
//                    clause += "AND UCASE(" + column + ") ";
//                    clause += "= UCASE('" + Utils.decodeJavascriptString(value) + "') ";
//                } else if("neq".equals(operator)){
//                    clause += "AND UCASE(" + column + ") ";
//                    clause += "!= UCASE('" + Utils.decodeJavascriptString(value) + "') ";
//                } else if("isnull".equals(operator)){
//                    clause += "AND " + column + " ";
//                    clause += "IS NULL ";
//                } else if("isnotnull".equals(operator)){
//                    clause += "AND " + column + " ";
//                    clause += "IS NOT NULL ";
//                } else if("gte".equals(operator)){
//                    clause += "AND " + column + " ";
//                    clause += ">= '" + Utils.decodeJavascriptString(value) + "' ";
//                } else if("lte".equals(operator)){
//                    clause += "AND " + column + " ";
//                    clause += "<= '" + Utils.decodeJavascriptString(value) + "' ";
//                }
//
//                i++;
//            }
//        }
//        return clause;
//    }
//
//
//    public String getOrderByClauses(List<ListColumn> columns, Map<String,Object> params) {
//
//        String clause = "";
//
//        if(params.get("sort[0][field]") == null || "".equals(params.get("sort[0][field]"))) {
//            return "";
//        } else {
//            String direction = "desc".equals(params.get("sort[0][dir]"))?" DESC":" ASC";
//            clause += " ORDER BY " + params.get("sort[0][field]") + " " + direction;
//        }
//        return clause;
//
////        if(params.get("orderBy") == null || "".equals(params.get("orderBy"))){
////            return "";
////        } else {
////            int ind = Integer.parseInt(params.get("orderBy").toString());
////            String colId = columns.get(ind).getSelcol();
////
////            if(colId.indexOf(".")>-1) {
////                colId = colId.substring(colId.indexOf(".")+1, colId.length());
////            }
////
////            String direction = "des".equals(params.get("direction"))?" DESC":" ASC";
////            clause += " ORDER BY " + colId + " " + direction;
////            return clause;
////        }
//    }
}
