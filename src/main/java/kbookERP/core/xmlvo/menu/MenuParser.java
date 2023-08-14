package kbookERP.core.xmlvo.menu;

import java.io.File;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Stack;

import org.apache.commons.lang3.StringUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import kbookERP.util.Utils;
import kbookERP.util.sax.SAXHelper;

public class MenuParser extends DefaultHandler{

	boolean isItem, isHome;
	Menu curMenu;
	MenuItem item;
	Home home;
	int id = 0;
	int prevPid = 0;
	Stack<MenuItem> itemStack = new Stack<MenuItem>();
	List<MenuItem> itemList = new ArrayList<MenuItem>();
	StringBuffer sb = new StringBuffer();

	public MenuParser() {
		curMenu = new Menu();
	}

	public Menu getMenu() {
		return curMenu;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes att) throws SAXException {
		if(qName.equals("menu")) {
			curMenu.setType(att.getValue("type"));
		}
		if(qName.equals("home")) {
			isHome = true;
			home = new Home();
			home.setUrl(att.getValue("url"));
		}
		if(qName.equals("item")) {
			id++;
			item = new MenuItem();
			item.setId(id);
			item.setUrl(att.getValue("url"));
			itemStack.push(item);
		}
	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		if(qName.equals("home")) {
			isHome = false;
			curMenu.setHome(home);
		}
		if(qName.equals("item")) {
			MenuItem currentItem = itemStack.pop();
			if(currentItem != null) {
				int pId = 0;
				if (!itemStack.isEmpty()) {
					MenuItem parentItem = itemStack.peek();
					pId = parentItem.getId();
					currentItem.setPid(pId);
					parentItem.getItems().add(currentItem);
				}
				itemList.add(currentItem);
			}
		}
	}

	@Override
	public void characters(char[] ch, int start, int length) throws SAXException {
		String val = new String(ch, start, length).trim();
		if(StringUtils.isNotBlank(val) && !itemStack.isEmpty()) {
			MenuItem currentItem = itemStack.peek();
			if(currentItem != null) {
				currentItem.setText(val);
			}
		}
		if(StringUtils.isNotBlank(val) && isHome) {
			home.setValue(val);
		}
	}

	@Override
	public void endDocument() throws SAXException {
//		Collections.sort(itemList, new AscendingId());
		curMenu.setItems(itemList);

		System.out.println(curMenu.getType());
		for(MenuItem items: curMenu.getItems()) {
			System.out.print("#>");
			System.out.print(" TEXT : "+items.getText());
			System.out.print(", URL : "+items.getUrl());
			System.out.print(", ID : "+items.getId());
			System.out.println(", PID : "+items.getPid());
		}
		System.out.println(curMenu.getItems());
	}

	public static void main(String[] args) throws Exception {
		String filePath = Utils.getFilePath("SYS0003_MENU.xml");
		File xmlFile = new File(filePath);
		MenuParser parser = new MenuParser();

		SAXHelper.parseXml(xmlFile, parser);
	}

	class AscendingId implements Comparator<MenuItem> {

		@Override
		public int compare(MenuItem menu1, MenuItem menu2) {
			return menu1.getId() - menu2.getId();
		}
	}
}
