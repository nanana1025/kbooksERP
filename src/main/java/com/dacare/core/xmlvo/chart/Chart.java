package com.dacare.core.xmlvo.chart;

public class Chart {
    private String title;
    private String defaultType;
    private String userJs;
    private ChartUserHtml userHtml;
    private String table;
    private String object;
    private String kendoExtend;
    private String desc;
    private String sql;
    private Series series;
    private Event event;
    
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
	public String getKendoExtend() {
		return kendoExtend;
	}
	public void setKendoExtend(String kendoExtend) {
		this.kendoExtend = kendoExtend;
	}
	public String getTable() {
		return table;
	}
	public void setTable(String table) {
		this.table = table;
	}
	public String getObject() {
		return object;
	}
	public void setObject(String object) {
		this.object = object;
	}
	public ChartUserHtml getUserHtml() {
		return userHtml;
	}
	public void setUserHtml(ChartUserHtml userHtml) {
		this.userHtml = userHtml;
	}
	public String getUserJs() {
		return userJs;
	}
	public void setUserJs(String userJs) {
		this.userJs = userJs;
	}
	public String getSql() {
		return sql;
	}
	public void setSql(String sql) {
		this.sql = sql;
	}
	public Event getEvent() {
		return event;
	}
	public void setEvent(Event event) {
		this.event = event;
	}
	public String getDefaultType() {
		return defaultType;
	}
	public void setDefaultType(String defaultType) {
		this.defaultType = defaultType;
	}
	public Series getSeries() {
		return series;
	}
	public void setSeries(Series series) {
		this.series = series;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}

}
