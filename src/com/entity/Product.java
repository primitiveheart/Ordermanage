package com.entity;

import java.io.Serializable;

/**
 * 该类主要是产品类
 * @author admin
 *
 */
public class Product implements Serializable{
	private Integer id;
	private String year;//年份
	private String area;//面积
	private String index;//指标
	private String inputForm;//输出结果的形式
	private String order_uuid;// 外键约束
	private String state;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public String getIndex() {
		return index;
	}
	public void setIndex(String index) {
		this.index = index;
	}
	public String getInputForm() {
		return inputForm;
	}
	public void setInputForm(String inputForm) {
		this.inputForm = inputForm;
	}
	public String getOrder_uuid() {
		return order_uuid;
	}
	public void setOrder_uuid(String orderUuid) {
		order_uuid = orderUuid;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	
	
}
