package kbookERP.core.xmlvo.list;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class ListParser extends DefaultHandler{

	boolean isList, isUserJs, isUserHtml, isHtml, isTable, isObject, isColumns, isCol, isSql, isKendoExtend, isDesc;
	boolean isEvent, isInsert, isUpdate, isDelete, isSelect, isChange;
	ListRoot curList;
	ListUserHtml userHtml;
	List<ListHtml> htmls;
	ListHtml html;
	Columns columns;
	List<Col> cols;
	Col col;
	Event event;
	StringBuffer sb = new StringBuffer();

	public ListParser() {
		curList = new ListRoot();
	}

	public ListRoot getList() {
		return curList;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes att) throws SAXException {
		if(qName.equals("list")) {
			curList.setName(att.getValue("name"));
			curList.setType(att.getValue("type"));
			curList.setEditable(att.getValue("editable"));
			curList.setWidth(att.getValue("width"));
			curList.setGridxscrollyn(att.getValue("gridxscrollyn"));
		}
		if(qName.equals("userJs")) { isUserJs = true; }
		if(qName.equals("userHtml")) {
			isUserHtml = true;
			userHtml = new ListUserHtml();
			htmls = new ArrayList<ListHtml>();
			userHtml.setHtmls(htmls);
		}
		if(qName.equals("html")) {
			isHtml = true;
			html = new ListHtml();
			html.setPosition(att.getValue("position"));
			sb = new StringBuffer();
		}
		if(qName.equals("table")) { isTable = true; }
		if(qName.equals("object")) { isObject = true; }
		if(qName.equals("columns")) {
			isColumns = true;
			columns = new Columns();
			cols = new ArrayList<Col>();
			columns.setCols(cols);
		}
		if(qName.equals("col")) {
			isCol = true;
			col = new Col();
			col.setId(att.getValue("id"));
			col.setGroupLabel(att.getValue("groupLabel"));
			col.setWidth(att.getValue("width"));
			col.setAlign(att.getValue("align"));
			col.setType(att.getValue("type"));
			col.setSearch(att.getValue("search"));
			col.setHidden(att.getValue("hidden"));
			col.setEditable(att.getValue("editable"));
			col.setRequired(att.getValue("required"));
			col.setDefault(att.getValue("default"));
			col.setFormatter(att.getValue("formatter"));
			col.setInit(att.getValue("init"));
			col.setMin(att.getValue("min"));
			col.setMax(att.getValue("max"));
			col.setTooltip(att.getValue("tooltip"));
			col.setLock(att.getValue("lock"));
			col.setOnclick(att.getValue("onclick"));
		}
		if(qName.equals("event")) {
			isEvent = true;
			event = new Event();
		}
		if(qName.equals("insert")) { isInsert = true; sb = new StringBuffer();}
		if(qName.equals("update")) { isUpdate = true; sb = new StringBuffer();}
		if(qName.equals("delete")) { isDelete = true; sb = new StringBuffer();}
		if(qName.equals("select")) { isSelect = true; }
		if(qName.equals("change")) { isChange = true; }
		if(qName.equals("sql")) { isSql = true; sb = new StringBuffer();}
		if(qName.equals("kendoExtend")) { isKendoExtend = true; sb = new StringBuffer();}
		if(qName.equals("desc")) { isDesc = true; sb = new StringBuffer();}
	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		if(qName.equals("userJs")) { isUserJs = false; }
		if(qName.equals("userHtml")) {
			isUserHtml = false;
			curList.setUserHtml(userHtml);
		}
		if(qName.equals("html")) {
			isHtml = false;
			userHtml.getHtmls().add(html);
		}
		if(qName.equals("table")) { isTable = false; }
		if(qName.equals("object")) { isObject = false; }
		if(qName.equals("columns")) {
			isColumns = false;
			curList.setColumns(columns);
		}
		if(qName.equals("col")) {
			isCol = false;
			columns.getCols().add(col);
		}
		if(qName.equals("event")) {
			isEvent = false;
			curList.setEvent(event);
		}
		if(qName.equals("insert")) { isInsert = false; }
		if(qName.equals("update")) { isUpdate = false; }
		if(qName.equals("delete")) { isDelete = false; }
		if(qName.equals("select")) { isSelect = false; }
		if(qName.equals("change")) { isChange = false; }
		if(qName.equals("sql")) { isSql = false; }
		if(qName.equals("kendoExtend")) { isKendoExtend = false; }
		if(qName.equals("kendoExtend")) { isDesc = false; }
	}

	@Override
	public void characters(char[] ch, int start, int length) throws SAXException {
		String val = new String(ch, start, length).trim();
		if(StringUtils.isNotBlank(val) && isUserJs) { curList.setUserJs(val); }
		if(StringUtils.isNotBlank(val) && isHtml) {
			sb = sb.append(new String(ch, start, length));
			html.setValue(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isTable) { curList.setTable(val); }
		if(StringUtils.isNotBlank(val) && isObject) { curList.setObject(val); }
		if(StringUtils.isNotBlank(val) && isCol) { col.setValue(val); }
		if(StringUtils.isNotBlank(val) && isInsert) {
			sb = sb.append(new String(ch, start, length));
			event.setInsert(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isUpdate) {
			sb = sb.append(new String(ch, start, length));
			event.setUpdate(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isDelete) {
			sb = sb.append(new String(ch, start, length));
			event.setDelete(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isSelect) { event.setSelect(val); }
		if(StringUtils.isNotBlank(val) && isChange) { event.setChange(val); }
		if(StringUtils.isNotBlank(val) && isSql) {
			sb = sb.append(new String(ch, start, length));
			curList.setSql(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isKendoExtend) {
			sb = sb.append(new String(ch, start, length));
			curList.setKendoExtend(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isDesc) {
			sb = sb.append(new String(ch, start, length));
			curList.setDesc(sb.toString());
		}
	}

	@Override
	public void endDocument() throws SAXException {

		System.out.println("TYPE : "+curList.getType());
		System.out.println("EDITABLE : "+curList.getEditable());
		System.out.println("WIDTH : "+curList.getWidth());
		System.out.println("USER JS : "+curList.getUserJs());
		for(ListHtml html : curList.getUserHtml().htmls) {
			System.out.print("$>");
			System.out.print(" HTML POSITION : "+html.getPosition());
			System.out.println(" HTML VALUE : "+html.getValue());
		}
		for(Col col: curList.getColumns().getCols()) {
			System.out.print("$>컬럼");
			System.out.print(" LABEL : "+col.getValue());
			System.out.print(", ID : "+col.getId());
			System.out.print(", GROUPLABEL : "+col.getGroupLabel());
			System.out.print(", WIDTH : "+col.getWidth());
			System.out.print(", ALIGN : "+col.getAlign());
			System.out.print(", TYPE : "+col.getType());
			System.out.print(", SEARCH : "+col.getSearch());
			System.out.print(", HIDDEN : "+col.getHidden());
			System.out.print(", EDITABLE : "+col.getEditable());
			System.out.print(", REQUIRED : "+col.getRequired());
			System.out.print(", DEFAULT : "+col.getDefault());
			System.out.print(", FORMATTER : "+col.getFormatter());
			System.out.print(", INIT : "+col.getInit());
			System.out.print(" MIN : "+col.getMin());
			System.out.print(" MAX : "+col.getMax());
			System.out.print(" TOOLTIP : "+col.getTooltip());
			System.out.println(" LOCK : "+col.getLock());
			System.out.println(" ONCLICK : "+col.getOnclick());
		}
		System.out.print("$>EVENT> ");
		System.out.print("INSERT : "+curList.getEvent().getInsert());
		System.out.print(", UPDATE : "+curList.getEvent().getUpdate());
		System.out.print(", DELETE : "+curList.getEvent().getDelete());
		System.out.println(", SELECT : "+curList.getEvent().getSelect());
		System.out.println(", CHANGE : "+curList.getEvent().getChange());
		System.out.println("SQL : "+curList.getSql());
		System.out.println("KendoExtend : "+curList.getKendoExtend());
		System.out.println("DESC : "+curList.getDesc());
	}
}
