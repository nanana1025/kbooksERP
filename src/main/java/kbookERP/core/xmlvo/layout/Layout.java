package kbookERP.core.xmlvo.layout;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Layout {

	private String type;
	private String name;
    private List<Area> areas = new ArrayList<Area>();
	private Map<String, LayoutItem> refLayoutItem = new HashMap<String, LayoutItem>();
	private Map<String, List<String>> refChildAreaId = new HashMap<String, List<String>>();

	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<Area> getAreas() {
		return areas;
	}
	public void setAreas(List<Area> areas) {
		this.areas = areas;
	}
	public Map<String, LayoutItem> getRefLayoutItem() {
		return refLayoutItem;
	}
	public void setRefLayoutItem(Map<String, LayoutItem> refLayoutItem) {
		this.refLayoutItem = refLayoutItem;
	}
	public Map<String, List<String>> getRefChildAreaId() {
		return refChildAreaId;
	}
	public void setRefChildAreaId(Map<String, List<String>> refChildAreaId) {
		this.refChildAreaId = refChildAreaId;
	}

}
