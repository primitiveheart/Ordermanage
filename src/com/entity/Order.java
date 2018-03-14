package com.entity;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * 该类主要是订单实体类
 * @author admin
 *
 */
public class Order implements Serializable{
	private String uuid;//订单号
	private String number;//数量
	private String price;//价格
	private Timestamp date;
	private String state;
	private String scope; //选择的范围
	private String shape; //选择的形状
	
	private String username;//uses表的主键，order表中的外键
	
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
	public Timestamp getDate() {
		return date;
	}
	public void setDate(Timestamp date) {
		this.date = date;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getScope() {
		return scope;
	}
	public void setScope(String scope) {
		this.scope = scope;
	}
	public String getShape() {
		return shape;
	}
	public void setShape(String shape) {
		this.shape = shape;
	}
	
}
