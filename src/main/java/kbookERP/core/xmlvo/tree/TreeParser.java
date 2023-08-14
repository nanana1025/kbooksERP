package kbookERP.core.xmlvo.tree;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import kbookERP.core.xmlvo.list.ListHtml;
import kbookERP.core.xmlvo.list.ListUserHtml;

public class TreeParser extends DefaultHandler{

	boolean isTree, isUserJs, isUserHtml, isHtml, isColumn, isIcons, isEvent, isSql, isData, isKendoExtend, isDesc;
	boolean isChild, isDisplay, isObject, isParent, isIconId;
	boolean isIcon, isExpand, isSelect;

	Tree curTree;
	TreeUserHtml userHtml;
	List<TreeHtml> htmls;
	TreeHtml html;
	List<Icon> icons;
	Column column;
	Icon icon;
	Event event;
	StringBuffer sb = new StringBuffer();

	public TreeParser() {
		curTree = new Tree();
	}

	public Tree getTree() {
		return curTree;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes att) throws SAXException {
		if(qName.equals("tree")) {
			isTree = true;
			curTree.setName(att.getValue("name"));
		}
		if(qName.equals("userJs")) { isUserJs = true; }
		if(qName.equals("userHtml")) { 
			isUserHtml = true;
			userHtml = new TreeUserHtml();
			htmls = new ArrayList<TreeHtml>();
			userHtml.setHtmls(htmls);
		}
		if(qName.equals("html")) { 
			isHtml = true;
			html = new TreeHtml();
			html.setPosition(att.getValue("position"));
			sb = new StringBuffer();
		}	
//		if(qName.equals("div") || qName.equals("span") || qName.equals("input")) { 
//			isHtml = true;
//			curTag = qName;
//		}	
		if(qName.equals("column")) {
			isColumn = true;
			column = new Column();
		}
		if(qName.equals("child")) { isChild = true; }
		if(qName.equals("display")) { isDisplay = true; }
		if(qName.equals("object")) { isObject = true; }
		if(qName.equals("parent")) { isParent = true; }
		if(qName.equals("iconId")) { isIconId = true; }
		if(qName.equals("icons")) {
			curTree.setIcons(new Icons());
			isIcons = true;
			icons = new ArrayList<Icon>();
		}
		if(qName.equals("icon")) {
			isIcon = true;
			icon = new Icon();
			icon.setId(att.getValue("id"));
		}
		if(qName.equals("event")) {
			isEvent = true;
			event = new Event();
		}
		if(qName.equals("expand")) { isExpand = true; }
		if(qName.equals("select")) { isSelect = true; }
		if(qName.equals("kendoExtend")) { isKendoExtend = true; sb = new StringBuffer(); }
		if(qName.equals("sql")) { isSql = true; sb = new StringBuffer(); }
		if(qName.equals("data")) { isData = true; sb = new StringBuffer(); }
		if(qName.equals("desc")) { isDesc = true; sb = new StringBuffer(); }
	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		if(qName.equals("tree")) {
			isTree = false;
		}
		if(qName.equals("userJs")) {
			isUserJs = false;
		}
		if(qName.equals("userHtml")) {
			isUserHtml = false;
			curTree.setUserHtml(userHtml);
		}
		if(qName.equals("html")) {
			isHtml = false;
			userHtml.getHtmls().add(html);
		}
		if(qName.equals("column")) {
			isColumn = false;
			curTree.setColumn(column);
		}
		if(qName.equals("child")) { isChild = false; }
		if(qName.equals("display")) { isDisplay = false; }
		if(qName.equals("object")) { isObject = false; }
		if(qName.equals("parent")) { isParent = false; }
		if(qName.equals("iconId")) { isIconId = false; }
		if(qName.equals("icons")) {
			isIcons = false;
			curTree.getIcons().setIcons(icons);
		}
		if(qName.equals("icon")) {
			isIcon = false;
			icons.add(icon);
		}
		if(qName.equals("event")) {
			isEvent = false;
			curTree.setEvent(event);
		}
		if(qName.equals("expand")) { isExpand = false; }
		if(qName.equals("select")) { isSelect = false; }
		if(qName.equals("kendoExtend")) { isKendoExtend = false; }
		if(qName.equals("sql")) { isSql = false; }
		if(qName.equals("data")) { isData = false; }
		if(qName.equals("desc")) { isDesc = false; }
	}

	@Override
	public void characters(char[] ch, int start, int length) throws SAXException {
		String val = new String(ch, start, length).trim();
		if(StringUtils.isNotBlank(val) && isUserJs) { curTree.setUserJs(val); }
		if(StringUtils.isNotBlank(val) && isHtml) { 
			sb = sb.append(new String(ch, start, length));
			html.setValue(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isChild) { column.setChild(val); }
		if(StringUtils.isNotBlank(val) && isDisplay) { column.setDisplay(val); }
		if(StringUtils.isNotBlank(val) && isObject) { column.setObject(val); }
		if(StringUtils.isNotBlank(val) && isParent) { column.setParent(val); }
		if(StringUtils.isNotBlank(val) && isIconId) { column.setIconId(val); }
		if(StringUtils.isNotBlank(val) && isIcon) { icon.setValue(val); }
		if(StringUtils.isNotBlank(val) && isExpand) { event.setExpand(val); }
		if(StringUtils.isNotBlank(val) && isSelect) { event.setSelect(val); }
		if(StringUtils.isNotBlank(val) && isKendoExtend) {
			sb = sb.append(new String(ch, start, length));
			curTree.setKendoExtend(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isSql) {
			sb = sb.append(new String(ch, start, length));
			curTree.setSql(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isData) { 
			sb = sb.append(new String(ch, start, length));		
			curTree.setData(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isDesc) { 
			sb = sb.append(new String(ch, start, length));		
			curTree.setDesc(sb.toString());
		}
	}

	@Override
	public void endDocument() throws SAXException {

		System.out.println("NAME : "+curTree.getName());
		System.out.println("USER JS : "+curTree.getUserJs());
		System.out.println("USER HTML : "+curTree.getUserHtml());
		for(TreeHtml html : curTree.getUserHtml().htmls) {
			System.out.print("$>");
			System.out.print(" HTML POSITION : "+html.getPosition());
			System.out.println(" HTML VALUE : "+html.getValue());
		}
		System.out.print("#>");
		System.out.print(" COLUMN : "+curTree.getColumn().getChild());
		System.out.print(", DISPLAY : "+curTree.getColumn().getDisplay());
		System.out.print(", OBJECT : "+curTree.getColumn().getObject());
		System.out.print(", PARENT : "+curTree.getColumn().getParent());
		System.out.println(", ICON ID : "+curTree.getColumn().getIconId());
		for(Icon icon: curTree.getIcons().getIcons()) {
			System.out.print("$>");
			System.out.print(" ICON TITLE : "+icon.getValue());
			System.out.println(",ICON ID : "+icon.getId());
		}
		System.out.println("EXPAND : "+curTree.getEvent().getExpand());
		System.out.println("SELECT : "+curTree.getEvent().getSelect());
		System.out.println("kendoExtend : "+curTree.getKendoExtend());
		System.out.println("SQL : "+curTree.getSql());
		System.out.println("DATA : "+curTree.getData());		
		System.out.println("DESC : "+curTree.getDesc());		
	}
}
