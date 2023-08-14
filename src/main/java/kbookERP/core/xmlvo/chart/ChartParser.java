package kbookERP.core.xmlvo.chart;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class ChartParser extends DefaultHandler{

	boolean isChart, isUserJs, isTable, isObject, isUserHtml, isHtml, isSeries, isEvent, isSql, isKendoExtend, isDesc;
	boolean isTooltipTemplate;
//	boolean isDataBound, isRender, isSeriesClick, isPlotAreaClick;
	boolean isSeriesClick;

	Chart curChart;
	Series curSeries;
	Event curEvent;
	ChartUserHtml userHtml;
	List<ChartHtml> htmls;
	ChartHtml html;
	StringBuffer sb = new StringBuffer();

	public ChartParser() {
		curChart = new Chart();
	}

	public Chart getChart() {
		return curChart;
	}

	@Override
	public void startElement(String uri, String localName, String qName, Attributes att) throws SAXException {
		if(qName.equals("chart")) {
			isChart = true;
			curChart.setTitle(att.getValue("title"));
			curChart.setDefaultType(att.getValue("defaultType"));
		}
//		if(qName.equals("title")) { isTitle = true; }
		if(qName.equals("userJs")) { isUserJs = true; }
		if(qName.equals("userHtml")) { 
			isUserHtml = true;
			userHtml = new ChartUserHtml();
			htmls = new ArrayList<ChartHtml>();
			userHtml.setHtmls(htmls);
		}
		if(qName.equals("html")) { 
			isHtml = true;
			html = new ChartHtml();
			html.setPosition(att.getValue("position"));
			sb = new StringBuffer();
		}		
		if(qName.equals("table")) { isTable = true; }
		if(qName.equals("object")) { isObject = true; }
		if(qName.equals("series")) {
			isSeries = true;
			curSeries = new Series();
			curSeries.setName(att.getValue("name"));
			curSeries.setLabel(att.getValue("label"));
			curSeries.setValue(att.getValue("value"));
			curSeries.setUseTooltip(att.getValue("useTooltip"));
		}
		if(qName.equals("tooltipTemplate")) { isTooltipTemplate = true; }
		if(qName.equals("event")) {
			isEvent = true;
			curEvent = new Event();
		}
//		if(qName.equals("dataBound")) { isDataBound = true; }
//		if(qName.equals("render")) { isRender = true; }
		if(qName.equals("seriesClick")) { isSeriesClick = true; }
//		if(qName.equals("plotAreaClick")) { isPlotAreaClick = true; }
		if(qName.equals("kendoExtend")) { 
			isKendoExtend = true;
			sb = new StringBuffer();
		}
		if(qName.equals("sql")) { 
			isSql = true;
			sb = new StringBuffer();
		}
		if(qName.equals("desc")) { 
			isDesc = true;
			sb = new StringBuffer();
		}
	}

	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		if(qName.equals("chart")) {
			isChart = false;
		}
		if(qName.equals("userJs")) {
			isUserJs = false;
		}
		if(qName.equals("userHtml")) {
			isUserHtml = false;
			curChart.setUserHtml(userHtml);
		}
		if(qName.equals("html")) {
			isHtml = false;
			userHtml.getHtmls().add(html);
		}
		if(qName.equals("table")) { isTable = false; }
		if(qName.equals("object")) { isObject = false; }
		if(qName.equals("series")) {
			isSeries = false;
			curChart.setSeries(curSeries);
		}
		if(qName.equals("tooltipTemplate")) { isTooltipTemplate = false; }
		if(qName.equals("event")) {
			isEvent = false;
			curChart.setEvent(curEvent);
		}
//		if(qName.equals("dataBound")) { isDataBound = false; }
//		if(qName.equals("render")) { isRender = false; }
		if(qName.equals("seriesClick")) { isSeriesClick = false; }
//		if(qName.equals("plotAreaClick")) { isPlotAreaClick = false; }
		if(qName.equals("kendoExtend")) { isKendoExtend = false; }
		if(qName.equals("sql")) { isSql = false; }
		if(qName.equals("desc")) { isDesc = false; }
	}

	@Override
	public void characters(char[] ch, int start, int length) throws SAXException {
		String val = new String(ch, start, length).trim();
		if(StringUtils.isNotBlank(val) && isUserJs) { curChart.setUserJs(val); }
		if(StringUtils.isNotBlank(val) && isHtml) { 
			sb = sb.append(new String(ch, start, length));
			html.setValue(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isTable) { curChart.setTable(val); }
		if(StringUtils.isNotBlank(val) && isObject) { curChart.setObject(val); }
//		if(StringUtils.isNotBlank(val) && isName) { series.setName(val); }
//		if(StringUtils.isNotBlank(val) && isCategoryField) { series.setCategoryField(val); }
//		if(StringUtils.isNotBlank(val) && isField) { series.setField(val); }
//		if(StringUtils.isNotBlank(val) && isVisible) { tooltip.setVisible(val); }
		if(StringUtils.isNotBlank(val) && isTooltipTemplate) { curSeries.setTooltipTemplate(val); }
//		if(StringUtils.isNotBlank(val) && isDataBound) { event.setDataBound(val); }
//		if(StringUtils.isNotBlank(val) && isRender) { event.setRender(val); }
		if(StringUtils.isNotBlank(val) && isSeriesClick) { curEvent.setSeriesClick(val); }
//		if(StringUtils.isNotBlank(val) && isPlotAreaClick) { event.setPlotAreaClick(val); }
		if(StringUtils.isNotBlank(val) && isKendoExtend) {
			sb = sb.append(new String(ch, start, length));
			curChart.setKendoExtend(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isSql) {
			sb = sb.append(new String(ch, start, length));
			curChart.setSql(sb.toString());
		}
		if(StringUtils.isNotBlank(val) && isDesc) {
			sb = sb.append(new String(ch, start, length));
			curChart.setDesc(sb.toString());
		}
	}

	@Override
	public void endDocument() throws SAXException {

		System.out.println("TITLE : "+curChart.getTitle());
		System.out.println("USER JS : "+curChart.getUserJs());
		for(ChartHtml html : curChart.getUserHtml().htmls) {
			System.out.print("$>");
			System.out.print(" HTML POSITION : "+html.getPosition());
			System.out.println(" HTML VALUE : "+html.getValue());
		}
		System.out.println("SERIES NAME : "+curSeries.getName());
		System.out.println("SERIES LABEL : "+curSeries.getLabel());
		System.out.println("SERIES VALUE : "+curSeries.getValue());
		System.out.println("USE TOOLTIP : "+curSeries.getUseTooltip());
		System.out.println("TOOLTIP TEMPLATE : "+curSeries.getTooltipTemplate());
//		System.out.println("DATABOUND : "+event.getDataBound());
//		System.out.println("RENDER : "+event.getRender());
		System.out.println("SERIES CLICK : "+curEvent.getSeriesClick());
//		System.out.println("PLOT AREA CLICK : "+event.getPlotAreaClick());
//		System.out.println("USER HTML : "+curChart.getUserHtml());
		System.out.print("#>");
		System.out.println("kendoExtend : "+curChart.getKendoExtend());
		System.out.println("SQL : "+curChart.getSql());
		System.out.println("DESC : "+curChart.getDesc());

	}

}
