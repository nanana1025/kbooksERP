package com.dacare.core.view.layout;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.dacare.core.xmlvo.data.DataRoot;
import com.dacare.core.xmlvo.layout.Area;
import com.dacare.core.xmlvo.layout.Layout;
import com.dacare.core.xmlvo.layout.LayoutItem;
import com.dacare.core.xmlvo.layout.Tab;
import com.dacare.core.xmlvo.list.ListRoot;
import com.dacare.core.xmlvo.tree.Tree;
import com.dacare.dev.SystemController;
import com.dacare.util.Utils;
import com.dacare.util.map.UMap;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class LayoutContoller {
//
//	@RequestMapping(value = {"/layoutCustom.do", "/admin/layoutCustom.do"})
//    public String layoutCustom(@RequestParam Map<String,Object> params, Model model) throws Exception {
//
//		 Map<String,Object> sysInfo = SystemController.SYSTEM_INFO;
//
//		 String content = params.get("content").toString();
//
//
//		model.addAttribute("sysInfo", sysInfo);
//		model.addAttribute("copyrightStr", Utils.nvl(sysInfo.get("COPYRIGHT")));
//
//		if(content.equals("receipt"))
//			return "custom/consigned/consigned_receipt";
//		else if(content.equals("process"))
//		{
//			String key = params.get("KEY").toString();
//			String value = params.get(key).toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute(key, value);
//
//			return "custom/consigned/consigned_process";
//
//		}
//		else if(content.equals("return"))
//		{
//			String key = params.get("KEY").toString();
//			String value = params.get(key).toString();
//
////			String key1 = params.get("KEY1").toString();
////			String value1 = params.get(key1).toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute(key, value);
//
////			model.addAttribute("KEY1", key1);
////			model.addAttribute(key1, value1);
//
//			return "custom/consigned/consigned_return";
//
//		}
//		else if(content.equals("delivery_invoice"))
//		{
//			return "custom/consigned/consigned_delivery_invoice";
//		}
//
//		else if(content.equals("priceNTB"))
//		{
//			return "custom/price/priceNTB_custom";
//
//		}
//		else if(content.equals("orderSheet"))
//		{
//			return "custom/consigned/orderSheet";
//
//		}
//		else if(content.equals("ledger"))
//		{
//			return "custom/consigned/consigned_Ledger";
//
//		}
//		else if(content.equals("adjustment"))
//		{
//			return "custom/consigned/consigned_Adjustment";
//
//		}
//		else if(content.equals("NTBPrice"))
//		{
//			return "custom/price/price_NTB";
//
//		}
//		else if(content.equals("warehouseMovement"))
//		{
//			return "custom/warehouseMovement/warehouseMovement";
//
//		}
//		else if(content.equals("usedPurchaseCustomerCheck"))
//		{
//			return "custom/usedPurchase/usedPurchaseCustomerCheck";
//
//		}
//		else if(content.equals("reProduct"))
//		{
//			return "custom/product/reProduct/reProduct";
//
//		}
//
//
//
//		else
//			return "custom/product/inventoryCheck/checkListNTB";
//    }
//
//	@RequestMapping(value = {"/CustomP.do"})
//    public String CustomP(@RequestParam Map<String,Object> params, Model model) throws Exception {
//
//		 Map<String,Object> sysInfo = SystemController.SYSTEM_INFO;
//
//		 String content = params.get("content").toString();
//
//
//		model.addAttribute("sysInfo", sysInfo);
//		model.addAttribute("copyrightStr", Utils.nvl(sysInfo.get("COPYRIGHT")));
//
//
//		System.out.println("content = "+content);
//
//		if(content.equals("component")) {
//
//			String key = params.get("KEY").toString();
//			String value = params.get(key).toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY1").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY1", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY2").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY2", key);
//			model.addAttribute(key, value);
//
//			return "custom/consigned/consigned_componentModif";
//		}else if(content.equals("releaseCompare")) {
//
//			String key = params.get("KEY").toString();
//			String value = params.get(key).toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY1").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY1", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY2").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY2", key);
//			model.addAttribute(key, value);
//
//			return "custom/consigned/consigned_ReleaseCompare";
//		}
//		else if(content.equals("releaseReturnCheck")) {
//
//			String key = params.get("KEY").toString();
//			String value = params.get(key).toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY1").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY1", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY2").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY2", key);
//			model.addAttribute(key, value);
//
//			return "custom/consigned/consigned_ReleaseReturnCheck";
//		}
//		else if(content.equals("process"))
//		{
//			String key = params.get("KEY").toString();
//			String value = params.get("VALUE").toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute("VALUE", value);
//
//			return "custom/consigned/consigned_process";
//
//		}
//		else if(content.equals("consignedReleaseInventory"))
//		{
//			String key = params.get("KEY").toString();
//			String value = params.get(key).toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY1").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY1", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY2").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY2", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY3").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY3", key);
//			model.addAttribute(key, value);
//
//			return "custom/consigned/consigned_Release_Inventory";
//
//		}
//		else if(content.equals("consignedReleasePart"))
//		{
//			String key = params.get("KEY").toString();
//			String value = params.get(key).toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY1").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY1", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY2").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY2", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY3").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY3", key);
//			model.addAttribute(key, value);
//
//			return "custom/consigned/consigned_Release_Part";
//
//		}
//		else if(content.equals("consignedChangeType"))
//		{
//			String key = params.get("KEY").toString();
//			String value = params.get(key).toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY1").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY1", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY2").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY2", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY3").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY3", key);
//			model.addAttribute(key, value);
//
//			return "custom/consigned/consigned_inventory_changeType";
//		}
//		else if(content.equals("consignedOrderSheet"))
//		{
//			String key = params.get("KEY").toString();
//			String value = params.get(key).toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute(key, value);
//
//			return "custom/consigned/consigned_orderSheet";
//		}
//		else if(content.equals("orderSheet"))
//		{
//			return "custom/consigned/orderSheet";
//		}
//		else if(content.equals("deliveryInvoice"))
//		{
//			String key = params.get("KEY").toString();
//			String value = params.get(key).toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute(key, value);
//
//			return "custom/consigned/consigned_delivery_invoice";
//		}
//		else if(content.equals("selectReleaseComponent"))
//		{
//			String key = params.get("KEY").toString();
//			String value = params.get(key).toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute(key, value);
//
//			return "custom/consigned/consigned_Select_Release_Component";
//		}
//		else if(content.equals("MBDProduct"))
//		{
//			return "custom/product/warehousingMBDProductListPopup";
//		}
//		else if(content.equals("deliveryInvoiceFileupload"))
//		{
//			return "custom/consigned/consigned_delivery_invoice_fileupload";
//		}
//		else if(content.equals("inventoryFileupload"))
//		{
//			return "custom/product/inventoryCheck/inventory_fileupload";
//		}
//		else if(content.equals("receiptFileupload"))
//		{
//			return "custom/consigned/consigned_receipt_fileupload";
//		}
//		else if(content.equals("invoiceFileupload"))
//		{
//			return "custom/consigned/consigned_invoice_fileupload";
//		}
//		else if(content.equals("ntbPriceRatio"))
//		{
//			return "custom/price/ntb_price_ratio";
//		}
//		else if(content.equals("updateCompanyModel"))
//		{
//			return "custom/consigned/consigned_update_company_model";
//		}
//		else
//			return "custom/product/inventoryCheck/checkListNTB";
//    }
//
//	@RequestMapping(value = {"/CustomPP.do"})
//    public String CustomPP(@RequestParam Map<String,Object> params, Model model) throws Exception {
//
//		 Map<String,Object> sysInfo = SystemController.SYSTEM_INFO;
//
//		 String content = params.get("content").toString();
//
//
//		model.addAttribute("sysInfo", sysInfo);
//		model.addAttribute("copyrightStr", Utils.nvl(sysInfo.get("COPYRIGHT")));
//
//		if(content.equals("consignedReleaseInventory"))
//		{
//			String key = params.get("KEY").toString();
//			String value = params.get(key).toString();
//
//			model.addAttribute("KEY", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY1").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY1", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY2").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY2", key);
//			model.addAttribute(key, value);
//
//			key = params.get("KEY3").toString();
//			value = params.get(key).toString();
//
//			model.addAttribute("KEY3", key);
//			model.addAttribute(key, value);
//
//			return "custom/consigned/consigned_Release_Inventory";
//
//		}
//		else
//			return "custom/product/inventoryCheck/checkListNTB";
//    }
//
//	@RequestMapping(value = {"/layout.do", "/admin/layout.do"})
//    public ModelAndView layout(HttpSession session, @RequestParam Map<String,Object> params) throws Exception {
//        ModelAndView mav = new ModelAndView();
//
//        Utils.setLanguage(session, (String)params.get("language"));
//        String language = Utils.getLanguage(session);
//        String fileName = Utils.getFileName(params.get("xn").toString(), Utils.XML_EXTENTION);
//
//        if(!StringUtils.isEmpty(language)) {
//        	fileName = params.get("xn").toString() + "_" + language + ".xml";
//        }
//
//        String xmlPath = Utils.getFilePath(fileName);
//
//        if("ADM".equals(session.getAttribute("SESSION_USER_TYPE"))) {
//        	if("M".equals(session.getAttribute("USER_TYPE"))) {
//        		xmlPath = Utils.getAdmXmlPath(fileName);
//        	}else if("U".equals(session.getAttribute("USER_TYPE")) || "S".equals(session.getAttribute("USER_TYPE")) || "G".equals(session.getAttribute("USER_TYPE"))) {
//        		xmlPath = Utils.getAdmXmlPath(fileName);
//        	}
//        }
//
////        System.out.println("xmlPath = "+xmlPath);
//
//        if(!Utils.fileCheck(xmlPath)) {
//            throw new Exception("layout xml does not exist");
//        }
//
//        Map<String,Object> sysInfo = SystemController.SYSTEM_INFO;
//
//        Layout layout = Utils.getLayoutXmlToObject(xmlPath);
//
//        List<Area> arealist = layout.getAreas();
//
//        mav.addObject("xn", params.get("xn"));
//        mav.addObject("title", layout.getName());
//        mav.addObject("layouttype", layout.getType());
//
//        List<Map<String, Object>> layoutList = new ArrayList<>();
//
//        for (int i = 0; i < arealist.size(); i++) {
//            Area area = arealist.get(i);
//            Map<String, Object> map = new HashMap<>();
//            String url = area.getUrl();
//            String xn = url.substring(url.indexOf("xn=")+3);
//            String type = url.substring(1, url.indexOf(".")).toUpperCase();
//            map.put("sid", area.getId());
//            map.put("xn", xn);
//            map.put("id", area.getId());
//            map.put("type", type);
//            map.put("mode", "layout");
//            map.put("title", area.getValue());
//
//            map.put("width", area.getWidth());
//            map.put("height", area.getHeight());
//            map.put("collapsible", area.getCollapsible());
//            map.put("resizable", area.getResizable());
//            if (!StringUtils.isEmpty(area.getRefAreaId())) {
//
//            	String[] refs = area.getRefAreaId().split(";");
//            	String pids = "";
//            	String ptypes = "";
//            	String pns = "";
//            	for(String ref : refs) {
//            		if(ref.contains(".")) {
//            			String[] refArr = ref.split("\\.");
//            			String parentId = refArr[0];
//            			String paddparam = refArr[1];
//            			Area parentItem = (Area)layout.getRefLayoutItem().get(parentId);
//            			String purl = parentItem.getUrl();
//            			String ptype = (purl.substring(purl.indexOf("/")+1, purl.indexOf("."))).toUpperCase();
//            			String pid = parentItem.getId();
//            			String pn = purl.substring(purl.indexOf("xn=")+3);
//            			pids += pid + ",";
//            			ptypes += ptype + ",";
//            			pns += pn + ",";
//            		} else {
//            			String parentId = ref;
//            			Area parentItem = (Area)layout.getRefLayoutItem().get(parentId);
//            			String purl = parentItem.getUrl();
//            			String ptype = (purl.substring(purl.indexOf("/")+1, purl.indexOf("."))).toUpperCase();
//            			String pid = parentItem.getId();
//            			String pn = purl.substring(purl.indexOf("xn=")+3);
//            			pids += pid + ",";
//            			ptypes += ptype + ",";
//            			pns += pn + ",";
//            		}
//            	}
//            	map.put("pid", pids.substring(0, pids.length()-1));
//            	map.put("ptype", ptypes.substring(0, ptypes.length()-1));
//            	map.put("pn", pns.substring(0, pns.length()-1));
//            }
//            List<String> childList = layout.getRefChildAreaId().get(area.getId());
//            if(childList != null && childList.size() > 0) {
//	            String cids = "";
//	            String ctypes = "";
//	            String curls = "";
//	            String cns = "";
//	            String caddparams = "";
//	            for(String child : childList) {
//	            	Area childItem = (Area)layout.getRefLayoutItem().get(child);
//	            	if(childItem != null && StringUtils.isNotBlank(childItem.getClassType())) {
//	            		String curl = childItem.getUrl();
//	            		String ctype = (curl.substring(curl.indexOf("/")+1, curl.indexOf("."))).toUpperCase();
//	            		String cid = childItem.getId();
//	            		String cn = curl.substring(curl.indexOf("xn=")+3);
//	            		String childRefAreaId = childItem.getRefAreaId();
//	            		String caddparam = "";
//	            		if(childRefAreaId.contains(";")) { //부모가 여러건인지 체크
//	            			String[] refArr = childRefAreaId.split(";");
//	            			for(int j=0; j<refArr.length; j++ ) {
//	            				if(refArr[j].contains(".")) { //추가 파라미터 있는 경우
//	            					String[] refs = refArr[j].split("\\.");
//	            					if(refs[0].equals(area.getId())) { //area와 일치하는 refAreaId의 추가 파라미터
//	            						caddparam += refs[1];
//	            					}
//	            				}
//	            			}
//	            		} else { //부모 1건인 경우
//	            			if(childRefAreaId.contains(".")) { //추가 파라미터 있는 경우
//
//	            				String[] caddparamArr = childRefAreaId.split("\\.");
//            					caddparam += caddparamArr[1];
//	            			}
//	            		}
//	            		cids += cid+",";
//	            		ctypes += ctype+",";
//	            		curls += curl+",";
//	            		cns += cn+",";
//	            		caddparams += caddparam+";";
//	            	}
//	            }
//	            map.put("cid", cids.substring(0, cids.length()-1));
//	            map.put("ctype", ctypes.substring(0, ctypes.length()-1));
//	            map.put("cn", cns.substring(0, cns.length()-1));
//	            if(StringUtils.isNotBlank(caddparams)) {
//	            	map.put("caddparams", caddparams.substring(0, caddparams.length()-1));
//	            }
//
//
//            }
//            map.put("curl", url.substring(0, url.indexOf("?")));
//            if("MAIN".equals(url.substring(url.indexOf("xn=")+3))) {
//            	map.put("curl", "/admin/main.do");
//            }
//            layoutList.add(map);
//        }
//        ObjectMapper om = new ObjectMapper();
//        mav.addObject("layoutList", om.writeValueAsString(layoutList));
//
//        String viewName = "";
//        String scrnMode = "";
//
//        switch(layout.getType()) {
//            case "1" :  viewName = "core/layout/layout_t1";
//                break;
//            case "2" :  viewName = "core/layout/layout_t2";
//                scrnMode = "vertical";
//                break;
//            case "3" :  viewName = "core/layout/layout_t2";
//                scrnMode = "horizontal";
//                break;
//            case "4" :  viewName = "core/layout/layout_t3";
//                scrnMode = "vertical";
//                break;
//            case "5" :  viewName = "core/layout/layout_t3";
//                scrnMode = "horizontal";
//                break;
//            case "6":   viewName = "core/layout/layout_t4";
//    			scrnMode = "vertical";
//    			break;
//    		case "7":	viewName = "core/layout/layout_t4";
//    			scrnMode = "horizontal";
//    			break;
//    		case "8":	viewName = "core/layout/layout_t5";
//    		break;
//            default  :  viewName = "core/layout/layout_t1";
//                break;
//        }
//        System.out.println("layoutList = "+layoutList);
//        mav.addObject("scrnMode", scrnMode);
//
//        if(!StringUtils.isEmpty(language)) {
//        	mav.addObject("menu_sid", sysInfo.get("SYSTEM_ID") + "_" + language);
//        } else {
//        	mav.addObject("menu_sid", sysInfo.get("SYSTEM_ID"));
//        }
//
//        mav.addObject("sysInfo", sysInfo);
//        mav.addObject("language", language);
//        mav.addObject("copyrightStr", Utils.nvl(sysInfo.get("COPYRIGHT")));
//        mav.setViewName(viewName);
//
//        return mav;
//    }
//
//   @GetMapping("/tab.do")
//   public ModelAndView tab(HttpServletRequest request, @RequestParam Map<String, Object> params) throws Exception {
//       ModelAndView mav = new ModelAndView();
//       if (params.get("xn") == null || "".equals(params.get("xn").toString())) {
//           throw new Exception("============ [xn is null] ============");
//       }
//
//       UMap paramMap = new UMap(params);
//       String language = paramMap.getStr("language");
//       String fileName = params.get("xn").toString().trim() + ".xml";
//       String filePath = Utils.getFilePath(fileName);
//       if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//    	   filePath = Utils.getAdmXmlPath(params.get("xn") + ".xml");
//       }
//       if (!Utils.fileCheck(filePath)) {
//           throw new Exception("등록된 LAYOUT XML 파일이 없습니다.");
//       }
//
//       Layout layout = Utils.getLayoutXmlToObject(filePath);
//
//       List<Area> areas = layout.getAreas();
//
//       for (int i = 0; i < areas.size(); i++) {
//           Area area = areas.get(i);
//           String url = area.getUrl();
//           String xn = url.substring(url.indexOf("xn=")+3);
//           if (xn.equals(params.get("xn"))) {
//               mav.addObject("tabid", area.getId());
//               List<Tab> tabs = area.getTabs();
//               List<Map<String,Object>> scenes = new ArrayList<Map<String,Object>>();
//               List<Map<String, Object>> tabtitles = new ArrayList<>();
//               for (Tab tab : tabs) {
//                   String id = tab.getId();
//                   String tabUrl = tab.getUrl();
//                   String type = (tabUrl.substring(tabUrl.indexOf("/")+1, tabUrl.indexOf("."))).toUpperCase();;
//                   String title = tab.getValue();
//                   String tabXn = tabUrl.substring(tabUrl.indexOf("xn=")+3);
//
//                   Map<String, Object> tabtitle = new HashMap<>();
//                   Map<String, Object> scene = new HashMap<>();
//                   scene.put("id", id);
//                   scene.put("type", type);
//                   scene.put("url", tabUrl);
//                   String taburl = "";
//
//                   if (type != null) {
//                       if ("LIST".equals(type)) {
////       					String listFilePath = env.getProperty("xmlfile.dir")+ File.separator+ id + "_LIST.xml";
//                           String listFileName = tabXn + ".xml";
//                           String listFilePath = Utils.getFilePath(listFileName);
//                           if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//                        	   listFilePath = Utils.getAdmXmlPath(tabXn + "_LIST.xml");
//                           }
//                           if (!Utils.fileCheck(listFilePath)) {
//                               throw new Exception("등록된 LIST XML 파일이 없습니다.");
//                           }
//
//                           ListRoot listObject = Utils.getListXmlToObject(listFilePath);
//
//                           if (title == null) {
//                               title = listObject.getName();
//                           }
//                           List<String> childList = layout.getRefChildAreaId().get(tab.getId());
//                           String cStr = "";
//                           if(childList != null && childList.size() > 0) {
//	                           LayoutItem childItem = layout.getRefLayoutItem().get(childList.get(0));
//	                           String curl = childItem.getUrl();
//	                           String cn = curl.substring(curl.indexOf("xn=")+3);
//	                           cStr = "&cid=" + childItem.getId() + "&ctype=" + childItem.getType() + "&cn=" + cn;
//                           }
//                           taburl += "/list.do" + "?xn=" + tabXn + "&sid=" + tab.getId() + "&mode=" + params.get("mode") + cStr + "&language=" + language;
//
//                           LayoutItem parentItem = layout.getRefLayoutItem().get(tab.getRefAreaId());
//                           if(parentItem != null) {
//                        	   String purl = parentItem.getUrl();
//                   			   String pn = purl.substring(purl.indexOf("xn=")+3);
//                        	   taburl += "&pid=" + tab.getRefAreaId() +"&ptype=" + parentItem.getType() + "&pn=" + pn;
//                           }
//
//                           mav.addObject("xn", tabXn);
//
//                       } else if ("DATA".equals(type)) {
//                           String dataFileName = tabXn + ".xml";
//                           String dataFilePath = Utils.getFilePath(dataFileName);
//                           if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//                        	   dataFilePath = Utils.getAdmXmlPath(tabXn + "_DATA.xml");
//                           }
//                           if (!Utils.fileCheck(dataFilePath)) {
//                               throw new Exception("등록된 DATA XML 파일이 없습니다.");
//                           }
//
//                           DataRoot dataObject = Utils.getDataXmlToObject(dataFilePath);
//
//                           if (title == null) {
//                               title = dataObject.getName();
//                           }
//                           taburl += "/dataEdit.do" + "?xn=" + tabXn + "&sid=" + tab.getId() + "&mode=" + params.get("mode") + "&language=" + language;
//
//                           mav.addObject("xn", tabXn);
//                       } else if ("TREE".equals(type)) {
//                           String treeFileName = tabXn + ".xml";
//                           String treeFilePath = Utils.getFilePath(treeFileName);
//                           if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//                        	   treeFilePath = Utils.getAdmXmlPath(tabXn + "_LAYOUT.xml");
//                           }
//                           if (!Utils.fileCheck(treeFilePath)) {
//                               throw new Exception("등록된 TREE XML 파일이 없습니다.");
//                           }
//
//                           Tree treeObject = Utils.getTreeXmlToObject(treeFilePath);
//
//                           if (title == null) {
//                               title = treeObject.getName();
//                           }
//                           List<String> childList = layout.getRefChildAreaId().get(tab.getId());
//                           String cStr = "";
//                           if(childList != null && childList.size() > 0) {
//	                           LayoutItem childItem = layout.getRefLayoutItem().get(childList.get(0));
//	                           String curl = childItem.getUrl();
//	                           String cn = curl.substring(curl.indexOf("xn=")+3);
//	                           cStr = "&cid=" + childItem.getId() + "&ctype=" + childItem.getType() + "&cn=" + cn;
//                           }
//                           taburl += "/tree.do" + "?xn=" + tabXn + "&sid=" + tab.getId() + "&mode=" + params.get("mode") + cStr;
//                       }
//
//                       if (params.get("scrtype") != null) {
//                           taburl += "&scrtype=" + params.get("scrtype");
//                       }
//
//                       LayoutItem parentItem = layout.getRefLayoutItem().get(tab.getRefAreaId());
//                       if(parentItem != null) {
//                    	   tabtitle.put("pid", tab.getRefAreaId());
//                    	   tabtitle.put("ptype", parentItem.getType());
//                       }
//                       tabtitle.put("title", title);
//                       tabtitle.put("url", taburl);
//                       tabtitles.add(tabtitle);
//
//                       scenes.add(scene);
//                   }
//               }
//               ObjectMapper om = new ObjectMapper();
//               mav.addObject("tabDataSource", om.writeValueAsString(tabtitles));
//               mav.addObject("scenes", om.writeValueAsString(scenes));
//               mav.addObject("language", language);
//           }
//       }
//       mav.setViewName("core/tab");
//
//       return mav;
//   }
//
//   @RequestMapping(value = {"/layoutSelectP.do", "/layoutSaveP.do", "/layoutSearchP.do", "/admin/layoutSelectP.do", "/admin/layoutSaveP.do", "/admin/layoutSearchP.do"})
//   public ModelAndView layoutP(HttpServletRequest request, @RequestParam Map<String,Object> params) throws Exception {
//       ModelAndView mav = new ModelAndView();
//
//       String xmlPath = Utils.getFilePath(params.get("xn") + ".xml");
//       if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//       	xmlPath = Utils.getAdmXmlPath(params.get("xn") + ".xml");
//       }
//
//       if(!Utils.fileCheck(xmlPath)) {
//           throw new Exception("layout xml does not exist");
//       }
//
//       Map<String,Object> sysInfo = SystemController.SYSTEM_INFO;
//
//       Layout layout = Utils.getLayoutXmlToObject(xmlPath);
//
//
//       List<Area> arealist = layout.getAreas();
//
//       mav.addObject("xn", params.get("xn"));
//       mav.addObject("crudid", params.get("crudid"));
//       mav.addObject("callbackName", params.get("callbackName"));
//       mav.addObject("title", layout.getName());
//       mav.addObject("layouttype", layout.getType());
//
//       List<Map<String, Object>> layoutList = new ArrayList<>();
//
//       for (int i = 0; i < arealist.size(); i++) {
//           Area area = arealist.get(i);
//           Map<String, Object> map = new HashMap<>();
//           String url = area.getUrl();
//           String xn = url.substring(url.indexOf("xn=")+3);
//           String type = url.substring(1, url.indexOf(".")).toUpperCase();
//           map.put("sid", area.getId());
//           map.put("xn", xn);
//           map.put("type", type);
//           map.put("id", area.getId());
//           map.put("mode", "layout");
//           map.put("title", area.getValue());
//
//           map.put("width", area.getWidth());
//           map.put("height", area.getHeight());
//           map.put("collapsible", area.getCollapsible());
//           map.put("resizable", area.getResizable());
//           if (area.getRefAreaId() != null) {
//               for (Area parent : arealist) {
//                   String id = Utils.nvl(parent.getId());
//
//                   if (area.getRefAreaId().equals(id)) {
//                   	String purl = parent.getUrl();
//                       String ptype = (purl.substring(purl.indexOf("/")+1, purl.indexOf("."))).toUpperCase();
//                       String pid = parent.getId();
//                       map.put("pid", pid);
//                       map.put("ptype", ptype);
//
//                       for(Map<String, Object> tempMap : layoutList) {
//                       	if(tempMap.get("id").equals(id)) {
//                       		String ctype = (url.substring(url.indexOf("/")+1, url.indexOf("."))).toUpperCase();
//                       		String cid = area.getId();
//                       		tempMap.put("cid", cid);
//                       		tempMap.put("ctype", ctype);
//                       		tempMap.put("cn", url.substring(url.indexOf("xn=")+3));
//                       	}
//                       }
//                   }
//               }
//           }
//           map.put("curl", url.substring(0, url.indexOf("?")));
//           if("MAIN".equals(url.substring(url.indexOf("xn=")+3))) {
//        	   map.put("curl", "/admin/main.do");
//           }
//           layoutList.add(map);
//       }
//       ObjectMapper om = new ObjectMapper();
//       mav.addObject("layoutList", om.writeValueAsString(layoutList));
//
//       String viewName = "";
//       String scrnMode = "";
//
//       switch(layout.getType()) {
//           case "1" :  viewName = "core/layout/layout_t1";
//               break;
//           case "2" :  viewName = "core/layout/layout_t2";
//               scrnMode = "vertical";
//               break;
//           case "3" :  viewName = "core/layout/layout_t2";
//               scrnMode = "horizontal";
//               break;
//           case "4" :  viewName = "core/layout/layout_t3";
//               scrnMode = "vertical";
//               break;
//           case "5" :  viewName = "core/layout/layout_t3";
//               scrnMode = "horizontal";
//               break;
//           case "6":   viewName = "core/layout/layout_t4";
//   			scrnMode = "vertical";
//   			break;
//   		case "7":	viewName = "core/layout/layout_t4";
//   			scrnMode = "horizontal";
//   			break;
//           default  :  viewName = "core/layout/layout_t1";
//               break;
//       }
//
//       mav.addObject("scrnMode", scrnMode);
//
//       mav.addObject("sysInfo", sysInfo);
//       mav.addObject("copyrightStr", Utils.nvl(sysInfo.get("COPYRIGHT")));
//       mav.setViewName(viewName);
//
//       return mav;
//   }
//
//   @RequestMapping(value = {"/layoutNewW.do", "/admin/layoutNewW.do"})
//   public ModelAndView layoutW(HttpServletRequest request, @RequestParam Map<String,Object> params) throws Exception {
//       ModelAndView mav = new ModelAndView();
//
//       String xmlPath = Utils.getFilePath(params.get("xn") + ".xml");
//       if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//       	xmlPath = Utils.getAdmXmlPath(params.get("xn") + ".xml");
//       }
//
//       if(!Utils.fileCheck(xmlPath)) {
//           throw new Exception("layout xml does not exist");
//       }
//
//       boolean isHasCobjectId = false;
//       String cobjectId = "";
//       long cobjectvalue = -1;
//
//       boolean isHasCobjectId1 = false;
//       String cobjectId1 = "";
//       long cobjectvalue1 = -1;
//
//       if(params.containsKey("cobjectid")) {
//    	    isHasCobjectId = true;
//    	    cobjectId = params.get("cobjectid").toString();
//    	    cobjectvalue = Long.parseLong(params.get("cobjectval").toString());
//       }
//
//       if(params.containsKey("cobjectid1")) {
//   	    isHasCobjectId1 = true;
//   	    cobjectId1 = params.get("cobjectid1").toString();
//   	    cobjectvalue1 = Long.parseLong(params.get("cobjectval1").toString());
//      }
//
//       Map<String,Object> sysInfo = SystemController.SYSTEM_INFO;
//       Layout layout = Utils.getLayoutXmlToObject(xmlPath);
//
//       List<Area> arealist = layout.getAreas();
//
//       mav.addObject("xn", params.get("xn"));
//       mav.addObject("crudid", params.get("crudid"));
//       mav.addObject("callbackName", params.get("callbackName"));
//       mav.addObject("title", layout.getName());
//       mav.addObject("layouttype", layout.getType());
//
//       List<Map<String, Object>> layoutList = new ArrayList<>();
//
//       for (int i = 0; i < arealist.size(); i++) {
//           Area area = arealist.get(i);
//           Map<String, Object> map = new HashMap<>();
//           String url = area.getUrl();
//           String xn = url.substring(url.indexOf("xn=")+3);
//           String type = url.substring(1, url.indexOf(".")).toUpperCase();
//           map.put("sid", area.getId());
//           map.put("xn", xn);
//           map.put("type", type);
//           map.put("id", area.getId());
//           map.put("mode", "layout");
//           map.put("title", area.getValue());
//
//           map.put("width", area.getWidth());
//           map.put("height", area.getHeight());
//           map.put("collapsible", area.getCollapsible());
//           map.put("resizable", area.getResizable());
//
//           if (area.getRefAreaId() != null) {
//               for (Area parent : arealist) {
//                   String id = Utils.nvl(parent.getId());
//
//                   if (area.getRefAreaId().equals(id)) {
//                   	String purl = parent.getUrl();
//                       String ptype = (purl.substring(purl.indexOf("/")+1, purl.indexOf("."))).toUpperCase();
//                       String pid = parent.getId();
//                       map.put("pid", pid);
//                       map.put("ptype", ptype);
//
//                       for(Map<String, Object> tempMap : layoutList) {
//	                       	if(tempMap.get("id").equals(id)) {
//	                       		String ctype = (url.substring(url.indexOf("/")+1, url.indexOf("."))).toUpperCase();
//	                       		String cid = area.getId();
//	                       		tempMap.put("cid", cid);
//	                       		tempMap.put("ctype", ctype);
//	                       		tempMap.put("cn", url.substring(url.indexOf("xn=")+3));
//	                       	}
//                       }
//                   }
//               }
//           }
//           map.put("curl", url.substring(0, url.indexOf("?")));
//           if("MAIN".equals(url.substring(url.indexOf("xn=")+3))) {
//        	   map.put("curl", "/admin/main.do");
//           }
//           if(isHasCobjectId) {
//	           map.put("cobjectid", cobjectId);
//	           map.put("cobjectval", cobjectvalue);
//           }
//           if(isHasCobjectId1) {
//           map.put("cobjectid1", cobjectId1);
//           map.put("cobjectval1", cobjectvalue1);
//           }
//
//           layoutList.add(map);
//       }
//       ObjectMapper om = new ObjectMapper();
//       mav.addObject("layoutList", om.writeValueAsString(layoutList));
//
//       String viewName = "";
//       String scrnMode = "";
//
//       switch(layout.getType()) {
//           case "1" :  viewName = "core/layout/layout_t1_1";
//               break;
//           case "2" :  viewName = "core/layout/layout_t2";
//               scrnMode = "vertical";
//               break;
//           case "3" :  viewName = "core/layout/layout_t2";
//               scrnMode = "horizontal";
//               break;
//           case "4" :  viewName = "core/layout/layout_t3";
//               scrnMode = "vertical";
//               break;
//           case "5" :  viewName = "core/layout/layout_t3";
//               scrnMode = "horizontal";
//               break;
//           case "6":   viewName = "core/layout/layout_t4";
//   			scrnMode = "vertical";
//   			break;
//		  case "7":
//			 viewName = "core/layout/layout_t4_1";
//   			scrnMode = "horizontal";
//   			break;
//           default  :  viewName = "core/layout/layout_t1";
//               break;
//       }
//
////       if(params.containsKey("W_IDL"))
////    	   mav.addObject("W_IDL", params.get("WORLDMEMORY_IDL"));
////
////       if(params.containsKey("W_IDR"))
////    	   mav.addObject("W_IDR", params.get("WORLDMEMORY_IDR"));
//
//
//       mav.addObject("scrnMode", scrnMode);
//
//       mav.addObject("sysInfo", sysInfo);
//       mav.addObject("copyrightStr", Utils.nvl(sysInfo.get("COPYRIGHT")));
//       mav.setViewName(viewName);
//
//       return mav;
//   }
//
//   @RequestMapping(value = {"/layoutNewList.do", "/admin/layoutNewList.do"})
//   public ModelAndView layoutNewList(HttpServletRequest request, @RequestParam Map<String,Object> params) throws Exception {
//	   ModelAndView mav = new ModelAndView();
//
//       String xmlPath = Utils.getFilePath(params.get("xn") + ".xml");
//       if("ADM".equals(request.getSession().getAttribute("SESSION_USER_TYPE"))) {
//       	xmlPath = Utils.getAdmXmlPath(params.get("xn") + ".xml");
//       }
//
//       if(!Utils.fileCheck(xmlPath)) {
//           throw new Exception("layout xml does not exist");
//       }
//
//       boolean isHasCobjectId = false;
//       String cobjectId = "";
//       long cobjectvalue = -1;
//
//       boolean isHasCustomKey = false;
//       String CustomKey = "";
//       String CustomValue = "";
//
//       if(params.containsKey("cobjectid")) {
//    	    isHasCobjectId = true;
//    	    cobjectId = params.get("cobjectid").toString();
//    	    cobjectvalue = Long.parseLong(params.get("cobjectval").toString());
//       }
//
//       if(params.containsKey("CUSTOMKEY")) {
//    	   isHasCustomKey = true;
//    	   CustomKey = params.get("CUSTOMKEY").toString();
//    	   CustomValue = params.get("CUSTOMVALUE").toString();
//      }
//
//       Map<String,Object> sysInfo = SystemController.SYSTEM_INFO;
//       Layout layout = Utils.getLayoutXmlToObject(xmlPath);
//
//       List<Area> arealist = layout.getAreas();
//
//       mav.addObject("xn", params.get("xn"));
//       mav.addObject("crudid", params.get("crudid"));
//       mav.addObject("callbackName", params.get("callbackName"));
//       mav.addObject("title", layout.getName());
//       mav.addObject("layouttype", layout.getType());
//
//       List<Map<String, Object>> layoutList = new ArrayList<>();
//
//       for (int i = 0; i < arealist.size(); i++) {
//           Area area = arealist.get(i);
//           Map<String, Object> map = new HashMap<>();
//           String url = area.getUrl();
//           String xn = url.substring(url.indexOf("xn=")+3);
//           String type = url.substring(1, url.indexOf(".")).toUpperCase();
//           map.put("sid", area.getId());
//           map.put("xn", xn);
//           map.put("type", type);
//           map.put("id", area.getId());
//           map.put("mode", "layout");
//           map.put("title", area.getValue());
//
//           map.put("width", area.getWidth());
//           map.put("height", area.getHeight());
//           map.put("collapsible", area.getCollapsible());
//           map.put("resizable", area.getResizable());
//
//           if (area.getRefAreaId() != null) {
//               for (Area parent : arealist) {
//                   String id = Utils.nvl(parent.getId());
//
//                   if (area.getRefAreaId().equals(id)) {
//                   	String purl = parent.getUrl();
//                       String ptype = (purl.substring(purl.indexOf("/")+1, purl.indexOf("."))).toUpperCase();
//                       String pid = parent.getId();
//                       map.put("pid", pid);
//                       map.put("ptype", ptype);
//
//                       for(Map<String, Object> tempMap : layoutList) {
//	                       	if(tempMap.get("id").equals(id)) {
//	                       		String ctype = (url.substring(url.indexOf("/")+1, url.indexOf("."))).toUpperCase();
//	                       		String cid = area.getId();
//	                       		tempMap.put("cid", cid);
//	                       		tempMap.put("ctype", ctype);
//	                       		tempMap.put("cn", url.substring(url.indexOf("xn=")+3));
//	                       	}
//                       }
//                   }
//               }
//           }
//           map.put("curl", url.substring(0, url.indexOf("?")));
//           if("MAIN".equals(url.substring(url.indexOf("xn=")+3))) {
//        	   map.put("curl", "/admin/main.do");
//           }
//           if(isHasCobjectId) {
//	           map.put("cobjectid", cobjectId);
//	           map.put("cobjectval", cobjectvalue);
//           }
//
//           if(isHasCustomKey) {
//	           map.put("CUSTOMKEY", CustomKey);
//	           map.put("CUSTOMVALUE", CustomValue);
//           }
//           layoutList.add(map);
//       }
//       ObjectMapper om = new ObjectMapper();
//       mav.addObject("layoutList", om.writeValueAsString(layoutList));
//
//
//
//       String viewName = "";
//       String scrnMode = "";
//
//       switch(layout.getType()) {
//           case "1" :  viewName = "core/layout/layout_t1_1";
//               break;
//           case "2" :  viewName = "core/layout/layout_t2";
//               scrnMode = "vertical";
//               break;
//           case "3" :  viewName = "core/layout/layout_t2";
//               scrnMode = "horizontal";
//               break;
//           case "4" :  viewName = "core/layout/layout_t3";
//               scrnMode = "vertical";
//               break;
//           case "5" :  viewName = "core/layout/layout_t3";
//               scrnMode = "horizontal";
//               break;
//           case "6":   viewName = "core/layout/layout_t4";
//   			scrnMode = "vertical";
//   			break;
//		  case "7":
//			 viewName = "core/layout/layout_t4_1";
//   			scrnMode = "horizontal";
//   			break;
//           default  :  viewName = "core/layout/layout_t1";
//               break;
//       }
//
//       mav.addObject("scrnMode", scrnMode);
//
//       mav.addObject("sysInfo", sysInfo);
//       mav.addObject("copyrightStr", Utils.nvl(sysInfo.get("COPYRIGHT")));
//       mav.setViewName(viewName);
//
//
//       return mav;
//   }
}
