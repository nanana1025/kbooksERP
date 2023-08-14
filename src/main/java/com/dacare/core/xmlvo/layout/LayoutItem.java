package com.dacare.core.xmlvo.layout;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

public class LayoutItem {
    private String id;
    private String url;
    private List<String> refAreaIdList;

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}

	public String getRefAreaId() {
		return StringUtils.join(refAreaIdList, ";");
	}

	public List<String> getRefAreaIdList() {
		return refAreaIdList;
	}

	public void setRefAreaId(String refAreaId) {
		if (StringUtils.isNotBlank(refAreaId)) {
			refAreaId = refAreaId.trim();
			refAreaIdList = Arrays.asList(refAreaId.split("\\s*;\\s*"));
		}
		else {
			refAreaIdList = new ArrayList<String>();
		}
	}

	public String getClassType() {
		String className = this.getClass().getName().toUpperCase();
		int endIdx = className.lastIndexOf(".");
		if (endIdx > -1) {
			className = className.substring(endIdx+1);
		}
		return className;
	}

	public String getType() {
		String type = "CUSTOM";
		int beginIdx = url.indexOf("/")+1;
		int endIdx = url.indexOf(".do?xn=", beginIdx);
		if (beginIdx > 0 && endIdx > -1) {
			type = url.substring(beginIdx, endIdx).toUpperCase();
		}
		return type;
	}

	@Override
	public String toString() {
		return String.format("LayoutItem [id=%s, url=%s, refAreaId=%s, getClassType()=%s, getType()=%s]", id, url,
				getRefAreaId(), getClassType(), getType());
	}
}
