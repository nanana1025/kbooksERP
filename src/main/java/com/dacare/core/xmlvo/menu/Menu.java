package com.dacare.core.xmlvo.menu;

import java.util.List;

public class Menu {

	private String type;
	public List<MenuItem> items;
	private Home home;
	
	public Home getHome() {
		return home;
	}

	public void setHome(Home home) {
		this.home = home;
	}

	public String getType() {
		return type;
	}
	
	public void setType(String type) {
		this.type = type;
	}
	
	public List<MenuItem> getItems() {
		return items;
	}
	
	public void setItems(List<MenuItem> items) {
		this.items = items;	
	}
	
	public int size() {
		return items.size();
	}
	
	public MenuItem get(int idx) {
		return items.get(idx);
	}

	@Override
	public String toString() {
		StringBuffer sb = new StringBuffer("Menu [type=" + type );
		for(int i = 0 ; i < items.size() ; i++) {
			sb.append(",").append(items.get(i)).append("\n");
		}
		sb.append("]");
		return sb.toString();
	}
	
	
}
