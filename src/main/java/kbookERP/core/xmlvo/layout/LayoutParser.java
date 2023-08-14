package kbookERP.core.xmlvo.layout;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import kbookERP.util.sax.SAXHelper;

public class LayoutParser extends DefaultHandler{

	boolean isLayout, isArea, isTab;
	Layout curLayout;
	Area area;
	Tab tab;

	public LayoutParser() {
		curLayout = new Layout();
	}

	public Layout getLayout() {
		return curLayout;
	}
	@Override
	public void startElement(String uri, String localName, String qName, Attributes att) throws SAXException {
		if(qName.equals("layout")) {
			isLayout = true;
			curLayout.setType(att.getValue("type"));
			curLayout.setName(att.getValue("name"));
		}
		if(qName.equals("area")) {
			isArea = true;
			area = new Area();
			area.setId(att.getValue("id"));
			area.setUrl(att.getValue("url"));
			area.setWidth(att.getValue("width"));
			area.setHeight(att.getValue("height"));
			area.setCollapsible(att.getValue("collapsible"));
			area.setResizable(att.getValue("resizable"));
			area.setRefAreaId(att.getValue("refAreaId"));
		}
		if(qName.equals("tab")) {
			isTab = true;
			tab = new Tab();
			tab.setId(att.getValue("id"));
			tab.setUrl(att.getValue("url"));
			tab.setRefAreaId(att.getValue("refAreaId"));
		}
	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		if(qName.equals("layout")) {
			isLayout = false;
		}
		if(qName.equals("area")) {
			isArea = false;
			curLayout.getAreas().add(area);
			curLayout.getRefLayoutItem().put(area.getId(), area);
		}
		if(qName.equals("tab")) {
			isTab = false;
			area.getTabs().add(tab);
			curLayout.getRefLayoutItem().put(tab.getId(), tab);
		}
	}

	@Override
	public void characters(char[] ch, int start, int length) throws SAXException {
		String val = new String(ch, start, length).trim();
		if(StringUtils.isNotBlank(val) && isArea) {
			area.setValue(val);
		}
		if(StringUtils.isNotBlank(val) && isTab) {
			tab.setValue(val);
		}
	}

	@Override
	public void endDocument() throws SAXException {
		Map<String, List<String>> refChildMap = new HashMap<String, List<String>>();
		for(Area area: curLayout.getAreas()) {
			List<String> refAreaIdList = area.getRefAreaIdList();
			if (refAreaIdList.size() > 0) {
				for(int i = 0 ; i < refAreaIdList.size() ; i++) {
					String refAreaId = refAreaIdList.get(i);
					int sp = refAreaId.indexOf(".");
					if (sp > -1) {
						refAreaId = refAreaId.substring(0, sp);
					}
					System.out.println(String.format("★★★★★area★★★★<%d> [%s]", i,refAreaId));
					putRefMap(refChildMap, area.getId(), refAreaId);
				}
			}

			for(Tab tab: area.getTabs()) {
				List<String> refTabIdList = tab.getRefAreaIdList();
				if (refTabIdList.size() > 0) {
					for(int i = 0 ; i < refTabIdList.size() ; i++) {
						String refTabId = refTabIdList.get(i);
						int sp = refTabId.indexOf(".");
						if (sp > -1) {
							refTabId = refTabId.substring(0, sp);
						}
						System.out.println(String.format("★★★★★tab★★★★<%d> [%s]", i,refTabId));
						putRefMap(refChildMap, tab.getId(), refTabId);
					}
				}
			}
		}
		curLayout.setRefChildAreaId(refChildMap);

		System.out.println(curLayout.getType());
		System.out.println(curLayout.getName());
		for(Area area: curLayout.getAreas()) {
			System.out.print("#>");
			System.out.print(" TITLE : "+area.getValue());
			System.out.print(", URL : "+area.getUrl());
			System.out.print(", ID : "+area.getId());
			System.out.print(", WIDTH : "+area.getWidth());
			System.out.print(", HEIGHT : "+area.getHeight());
			System.out.print(", COLLAPSIBLE : "+area.getCollapsible());
			System.out.print(", RESIZABLE : "+area.getResizable());
			System.out.println(", RefId : "+area.getRefAreaId());
			for(Tab tab: area.getTabs()) {
				System.out.print("$>");
				System.out.print(" TITLE  : "+tab.getValue());
				System.out.print(", ID : "+tab.getId());
				System.out.print(", URL : "+tab.getUrl());
				System.out.print(", RefId : "+tab.getRefAreaId());
			}
		}
	}

	private void putRefMap(Map<String, List<String>> refChildMap, String id, String refAreaId) {
		List<String> childList = null;

		if (refChildMap.containsKey(refAreaId)) {
			childList = refChildMap.get(refAreaId);
		}
		else {
			childList = new ArrayList<String>();
		}

		childList.add(id);
		refChildMap.put(refAreaId, childList);
	}

	public static void main(String[] ar) throws Exception {
				String str = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\r\n" +
				"<layout type=\"8\" name=\"4단화면\">\r\n" +
				"	<area id=\"UC_WBS\" url=\"/list.do?xn=WBS_LIST\" width=\"50%\" height=\"50%\" collapsible=\"Y\" resizable=\"Y\">부대WBS</area>\r\n" +
				"	<area id=\"SYS_WBS\" url=\"/list.do?xn=WBS_LIST\" width=\"50%\" height=\"50%\" collapsible=\"Y\" resizable=\"Y\">체계WBS</area>\r\n" +
				"	<area id=\"FAIL_CODE\" url=\"/list.do?xn=CODE_LIST\" width=\"50%\" height=\"40%\" collapsible=\"Y\" resizable=\"Y\" refAreaId=\"UC_WBS.wbstp;SYS_WBS.wbstp*\">고장코드</area>\r\n" +
				"	<area id=\"MNT_CODE\" url=\"/list.do?xn=CODE_LIST\" width=\"50%\" height=\"40%\" collapsible=\"N\" resizable=\"Y\" refAreaId=\"UC_WBS.wbstp,wbsnm*;SYS_WBS.wbsnm\">정비코드</area>\r\n" +
				"	<area id=\"WBS_TAB\" url=\"/tab.do?xn=TAB_TEST_LAYOUT\" width=\"50%\" height=\"100%\" collapsible=\"N\" resizable=\"N\">WBS_TAB\r\n"+
				"		<tab id=\"TAB_A\" url=\"/list.do?xn=TAB_A_LIST\" refAreaId=\"UC_WBS\">TAB_A</tab>	\r\n" +
				"		<tab id=\"TAB_B\" url=\"/list.do?xn=TAB_A_LIST\" refAreaId=\"UC_WBS\">TAB_B</tab>	\r\n" +
				"		<tab id=\"TAB_C\" url=\"/data.do?xn=WBS_DATA\" refAreaId=\"UC_WBS\">TAB_C</tab>	\r\n" +
				"</area>"+
				"</layout>";
		System.out.println(str);

		System.out.println("파싱시작############################");
        LayoutParser parser = new LayoutParser();
		SAXHelper.parseStr(str, parser);
		System.out.println();
		System.out.println("파싱종료############################");
		 Map<String, List<String>> refChildMap = parser.getLayout().getRefChildAreaId();
		 for(String key : refChildMap.keySet()) {
			 System.out.println("###key### "+key);
			 List<String> list = refChildMap.get(key);
			 for(int i = 0; i < list.size() ; i++) {
				 System.out.println(String.format("%d> %s", i, list.get(i)));
			 }
		 }
		System.out.println("결과종료############################");
	}

}
