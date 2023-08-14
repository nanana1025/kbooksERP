package kbookERP.core.xmlvo.layout;

import java.util.ArrayList;
import java.util.List;

public class Area extends LayoutItem {
    private String width;
    private String height;
    private String collapsible;
    private String resizable;
    private String value;
    
    public List<Tab> tabs = new ArrayList<Tab>();
    
	public List<Tab> getTabs() {
		return tabs;
	}
	public void setTabs(List<Tab> tabs) {
		this.tabs = tabs;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getWidth() {
		return width;
	}
	public void setWidth(String width) {
		this.width = width;
	}
	public String getHeight() {
		return height;
	}
	public void setHeight(String height) {
		this.height = height;
	}
	public String getCollapsible() {
		return collapsible;
	}
	public void setCollapsible(String collapsible) {
		this.collapsible = collapsible;
	}
	public String getResizable() {
		return resizable;
	}
	public void setResizable(String resizable) {
		this.resizable = resizable;
	}
}
