package kbookERP.core.xmlvo.tree;

public class Tree {
    private String name;
    private String userJs;
    private TreeUserHtml userHtml;
    private String sql;
    private String kendoExtend;
    private String desc;
    private String data;
    private Column column;
    private Icons icons;
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
	public TreeUserHtml getUserHtml() {
		return userHtml;
	}
	public void setUserHtml(TreeUserHtml userHtml) {
		this.userHtml = userHtml;
	}
	public String getData() {
		return data;
	}
	public void setData(String data) {
		this.data = data;
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
	public void setUserJs(String userJs) {
		this.userJs = userJs;
	}
	public String getSql() {
		return sql;
	}
	public void setSql(String sql) {
		this.sql = sql;
	}
	public Column getColumn() {
		return column;
	}
	public void setColumn(Column column) {
		this.column = column;
	}
	public Icons getIcons() {
		return icons;
	}
	public void setIcons(Icons icons) {
		this.icons = icons;
	}
	public Event getEvent() {
		return event;
	}
	public void setEvent(Event event) {
		this.event = event;
	}

}
