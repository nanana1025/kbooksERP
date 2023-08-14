package kbookERP.core.xmlvo.chart;

public class Series {
    private String name;
    private String label;
    private String value;
    private String useTooltip;
    private String tooltipTemplate;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getUseTooltip() {
		return useTooltip;
	}
	public void setUseTooltip(String useTooltip) {
		this.useTooltip = useTooltip;
	}
	public String getTooltipTemplate() {
		return tooltipTemplate;
	}
	public void setTooltipTemplate(String tooltipTemplate) {
		this.tooltipTemplate = tooltipTemplate;
	}
}
