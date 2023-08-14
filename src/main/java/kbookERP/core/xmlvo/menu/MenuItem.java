package kbookERP.core.xmlvo.menu;

import java.util.ArrayList;
import java.util.List;

public class MenuItem {
    private String url;
    private String text;
    private int id;
    private int pid;
    public List<MenuItem> items = new ArrayList<MenuItem>();
    
	public List<MenuItem> getItems() {
		return items;
	}
	public void setItems(List<MenuItem> items) {
		this.items = items;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public int getPid() {
		return pid;
	}
	public void setPid(int pid) {
		this.pid = pid;
	}
	public void setItemNull() {
		this.items = null;
	}
	
	@Override
	public String toString() {
		return "MenuItem [url=" + url + ", text=" + text + ", id=" + id + ", pid=" + pid + ", items=" + items + "]";
	}
	
	
}
