package com.dacare.core.xmlvo.data;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DataRoot {
	private String name;
	private int division;
	private String widths;
	private String userJs;
	private DataUserHtml userHtml;
	private String table;
	private String object;
	private String table1;
	private String object1;
	private String value;
    public Columns columns;
    private Event event;
    private String sql;
    private String desc;
    private Map<String, List<ColumnItem>> groupCheckBoxes = new HashMap<String, List<ColumnItem>>();

    public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public Map<String, List<ColumnItem>> getGroupCheckBoxes() {
		return groupCheckBoxes;
	}
	public void setGroupCheckBoxes(Map<String, List<ColumnItem>> groupCheckBoxes) {
		this.groupCheckBoxes = groupCheckBoxes;
	}
    public DataUserHtml getUserHtml() {
		return userHtml;
	}
	public void setUserHtml(DataUserHtml userHtml) {
		this.userHtml = userHtml;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public Columns getColumns() {
		return columns;
	}
	public void setColumns(Columns columns) {
		this.columns = columns;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getUserJs() {
		return userJs;
	}
	public int getDivision() {
		return division;
	}
	public void setDivision(int line) {
		this.division = line;
	}
	public String getWidths() {
		return widths;
	}
	public void setWidths(String widths) {
		this.widths = widths;
	}
	public void setUserJs(String userJs) {
		this.userJs = userJs;
	}
	public String getTable() {
		return table;
	}
	public void setTable(String table) {
		this.table = table;
	}

	public String getTable1() {
		return table1;
	}
	public void setTable1(String table) {
		this.table1 = table;
	}

	public String getObject() {
		return object;
	}
	public void setObject(String object) {
		this.object = object;
	}

	public String getObject1() {
		return object1;
	}
	public void setObject1(String object) {
		this.object1 = object;
	}

	public Event getEvent() {
		return event;
	}
	public void setEvent(Event event) {
		this.event = event;
	}
	public String getSql() {
		return sql;
	}
	public void setSql(String sql) {
		this.sql = sql;
	}
}
