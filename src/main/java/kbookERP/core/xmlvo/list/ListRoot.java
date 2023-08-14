package kbookERP.core.xmlvo.list;

public class ListRoot {
	private String name;
	private String width;
	private String editable;
	private String type;
	private String gridxscrollyn;
	private String userJs;
	private ListUserHtml userHtml;
	private String table;
	private String object;
    public Columns columns;
    private Event event;
    private String sql;
    private String kendoExtend;
    private String desc;
    
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
	public String getWidth() {
		return width;
	}
	public void setWidth(String width) {
		this.width = width;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
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
	public String getEditable() {
		return editable;
	}
	public void setEditable(String editable) {
		this.editable = editable;
	}
	public String getGridxscrollyn() {
		return gridxscrollyn;
	}
	public void setGridxscrollyn(String gridxscrollyn) {
		this.gridxscrollyn = gridxscrollyn;
	}
	public String getUserJs() {
		return userJs;
	}
	public void setUserJs(String userJs) {
		this.userJs = userJs;
	}
	public ListUserHtml getUserHtml() {
		return userHtml;
	}
	public void setUserHtml(ListUserHtml userHtml) {
		this.userHtml = userHtml;
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
