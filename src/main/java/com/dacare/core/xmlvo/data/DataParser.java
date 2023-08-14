package com.dacare.core.xmlvo.data;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import com.dacare.util.Utils;

public class DataParser extends DefaultHandler{

	boolean isData, isUserJs, isUserHtml, isHtml, isTable, isObject, isTable1, isObject1,  isValue, isColumns, isCol, isBlank, isLine, isSql, isDesc;
	boolean isEvent, isInsert, isUpdate, isDelete, isSelected;
	DataRoot curData;
	DataUserHtml userHtml;
	List<DataHtml> htmls;
	DataHtml html;
	Columns columns;
	List<ColumnItem> cols;
	Col col;
	Col tempCol;
	Blank blank;
	Line line;
	Event event;
	StringBuffer sb = new StringBuffer();
	Map<String, List<ColumnItem>> groupCheckBoxes = new HashMap<String, List<ColumnItem>>();
	List<ColumnItem> group = new ArrayList<ColumnItem>();
	List<String> labels = new ArrayList<String>();
	String prevGroupLabel = "";
	boolean groupChange = false;

	public DataParser() {
		curData = new DataRoot();
	}

	public DataRoot getData() {
		return curData;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes att) throws SAXException {
		if(qName.equals("data")) {
			curData.setName(att.getValue("name"));
			curData.setDivision(Integer.parseInt(att.getValue("division")));
			curData.setWidths(att.getValue("widths"));
		}
		if(qName.equals("userJs")) { isUserJs = true; }
		if(qName.equals("userHtml")) {
			isUserHtml = true;
			userHtml = new DataUserHtml();
			htmls = new ArrayList<DataHtml>();
			userHtml.setHtmls(htmls);
		}
		if(qName.equals("html")) {
			isHtml = true;
			html = new DataHtml();
			html.setPosition(att.getValue("position"));
			sb = new StringBuffer();
		}
		if(qName.equals("table")) { isTable = true; }
		if(qName.equals("object")) { isObject = true; }

		if(qName.equals("table1")) { isTable1 = true; }
		if(qName.equals("object1")) { isObject1 = true; }

		if(qName.equals("value")) { isValue = true; }
		if(qName.equals("columns")) {
			isColumns = true;
			columns = new Columns();
			cols = new ArrayList<ColumnItem>();
			columns.setCols(cols);
		}
		if(qName.equals("col")) {
			isCol = true;
			col = new Col();
			col.setId(att.getValue("id"));
			col.setColSpan(att.getValue("colSpan"));
			col.setGroupLabel(att.getValue("groupLabel"));
			col.setWidth(att.getValue("width"));
			col.setLine(att.getValue("line"));
			col.setAlign(att.getValue("align"));
			col.setType(att.getValue("type"));
			col.setHidden(att.getValue("hidden"));
			col.setEditable(att.getValue("editable"));
			col.setRequired(att.getValue("required"));
			col.setDefault(att.getValue("default"));
			col.setFormatter(att.getValue("formatter"));
			col.setInit(att.getValue("init"));
			if(StringUtils.isNotBlank(att.getValue("min"))) {
				col.setMin(Integer.parseInt(att.getValue("min")));
			}
			if(StringUtils.isNotBlank(att.getValue("max"))) {
				col.setMax(Integer.parseInt(att.getValue("max")));
			}
			col.setTooltip(att.getValue("tooltip"));

			if(groupChange && StringUtils.isNotBlank(prevGroupLabel)) {
				groupCheckBoxes.put(prevGroupLabel, group);
				group = new ArrayList<ColumnItem>();
				groupChange = false;
			}

			if(labels.size() > 0) {
				prevGroupLabel = labels.get(labels.size()-1);
			}
		}
		if(qName.equals("blank")) {
			isBlank = true;
			blank = new Blank();
			blank.setHeight(att.getValue("height"));
		}
		if(qName.equals("line")) {
			isLine = true;
			line = new Line();
		}
		if(qName.equals("event")) {
			isEvent = true;
			event = new Event();
		}
		if(qName.equals("insert")) { isInsert = true; sb = new StringBuffer();}
		if(qName.equals("update")) { isUpdate = true; sb = new StringBuffer();}
		if(qName.equals("delete")) { isDelete = true; sb = new StringBuffer();}
		if(qName.equals("sql")) { isSql = true; sb = new StringBuffer();}
		if(qName.equals("desc")) { isDesc = true; sb = new StringBuffer();}
	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		if(qName.equals("userJs")) { isUserJs = false; }
		if(qName.equals("userHtml")) {
			isUserHtml = false;
			curData.setUserHtml(userHtml);
		}
		if(qName.equals("html")) {
			isHtml = false;
			userHtml.getHtmls().add(html);
		}
		if(qName.equals("table")) { isTable = false; }
		if(qName.equals("object")) { isObject = false; }
		if(qName.equals("table1")) { isTable1 = false; }
		if(qName.equals("object1")) { isObject1 = false; }
		if(qName.equals("value")) { isValue = false; }
		if(qName.equals("columns")) {
			isColumns = false;
			curData.setColumns(columns);

			if(StringUtils.isNotBlank(prevGroupLabel)) {
				groupCheckBoxes.put(prevGroupLabel, group);
			}
		}
		if(qName.equals("col")) {
			isCol = false;
			columns.getCols().add(col);

			String groupLabel = Utils.nvl(col.getGroupLabel());
			if(!"".equals(groupLabel) && !"".equals(prevGroupLabel) && !prevGroupLabel.equals(groupLabel)) {
				groupChange = true;
			}
			if(!labels.contains(groupLabel)){
				labels.add(Utils.nvl(groupLabel));
			}
			if(tempCol != null && StringUtils.isNotBlank(groupLabel)) {
				group.add(tempCol);
				tempCol = null;
			}
			if(!groupChange && StringUtils.isNotBlank(groupLabel)) {
				group.add(col);
			} else if(groupChange && StringUtils.isNotBlank(groupLabel)) {
				tempCol = col;
			}
		}
		if(qName.equals("blank")) {
			isBlank = false;
			columns.getCols().add(blank);
		}
		if(qName.equals("line")) {
			isLine = false;
			columns.getCols().add(line);
		}
		if(qName.equals("event")) {
			isEvent = false;
			curData.setEvent(event);
		}
		if(qName.equals("insert")) { isInsert = false; }
		if(qName.equals("update")) { isUpdate = false; }
		if(qName.equals("delete")) { isDelete = false; }
		if(qName.equals("sql")) { isSql = false; }
		if(qName.equals("desc")) { isDesc = false; }
	}

	@Override
	public void characters(char[] ch, int start, int length) throws SAXException {
		String val = new String(ch, start, length).trim();
		if(StringUtils.isNotBlank(val) && isUserJs) { curData.setUserJs(val); }
		if(StringUtils.isNotBlank(val) && isHtml) {
			sb = sb.append(new String(ch, start, length));
			html.setValue(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isTable) { curData.setTable(val); }
		if(StringUtils.isNotBlank(val) && isObject) { curData.setObject(val); }

		if(StringUtils.isNotBlank(val) && isTable1) { curData.setTable1(val); }
		if(StringUtils.isNotBlank(val) && isObject1) { curData.setObject1(val); }

		if(StringUtils.isNotBlank(val) && isValue) { curData.setValue(val); }
		if(StringUtils.isNotBlank(val) && isCol) { col.setValue(val); }
		if(StringUtils.isNotBlank(val) && isLine) { line.setValue(val); }
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
		if(StringUtils.isNotBlank(val) && isSql) {
			sb = sb.append(new String(ch, start, length));
			curData.setSql(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isDesc) {
			sb = sb.append(new String(ch, start, length));
			curData.setDesc(sb.toString());
		}
	}

	@Override
	public void endDocument() throws SAXException {

		curData.setGroupCheckBoxes(groupCheckBoxes);

		System.out.println("DIVISION : "+curData.getDivision());
		System.out.println("WIDTHS : "+curData.getWidths());
		System.out.println("USER JS : "+curData.getUserJs());
		for(DataHtml html : curData.getUserHtml().htmls) {
			System.out.print("$>");
			System.out.print(" HTML POSITION : "+html.getPosition());
			System.out.println(" HTML VALUE : "+html.getValue());
		}
		System.out.println("TABLE : "+curData.getTable());
		System.out.println("OBJECT : "+curData.getObject());
		System.out.println("VALUE : "+curData.getValue());

		System.out.println("TABLE1 : "+curData.getTable1());
		System.out.println("OBJECT1 : "+curData.getObject1());

		for(ColumnItem col: curData.getColumns().getCols()) {
			System.out.print("$>컬럼");
			System.out.print(" LABEL : "+col.getValue());
			System.out.print(", ID : "+col.getId());
			System.out.print(", COLSPAN : "+col.getColSpan());
			System.out.print(", GROUPLABEL : "+col.getGroupLabel());
			System.out.print(", WIDTH : "+col.getWidth());
			System.out.print(", LINE : "+col.getLine());
			System.out.print(", ALIGN : "+col.getAlign());
			System.out.print(", TYPE : "+col.getType());
			System.out.print(", HIDDEN : "+col.getHidden());
			System.out.print(", EDITABLE : "+col.getEditable());
			System.out.print(", REQUIRED : "+col.getRequired());
			System.out.print(", DEFAULT : "+col.getDefault());
			System.out.print(", FORMATTER : "+col.getFormatter());
			System.out.print(", INIT : "+col.getInit());
			System.out.print(", MIN : "+col.getMin());
			System.out.print(", MAX : "+col.getMax());
			System.out.println(" TOOLTIP : "+col.getTooltip());
		}
		System.out.print("$>EVENT> ");
		System.out.print("INSERT : "+curData.getEvent().getInsert());
		System.out.print(", UPDATE : "+curData.getEvent().getUpdate());
		System.out.println(", DELETE : "+curData.getEvent().getDelete());
		System.out.println("SQL : "+curData.getSql());
		System.out.println("DESC : "+curData.getDesc());
	}
}
