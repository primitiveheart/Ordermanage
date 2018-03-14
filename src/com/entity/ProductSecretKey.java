package com.entity;

import java.io.Serializable;
import java.sql.Timestamp;

public class ProductSecretKey implements Serializable{
	private Timestamp date;
	private String uuid;//这是订单
	
	private String account_num;
	private String account_pwd;
	
	private Integer productId;
	private String year;
	private String area;
	private String index;
	private String inputForm;
	
	
	public ProductSecretKey(Timestamp date,String uuid, String accountNum, String accountPwd, Integer productId, String year,
			String area, String index, String inputForm) {
		super();
		this.date = date;
		this.uuid = uuid;
		account_num = accountNum;
		account_pwd = accountPwd;
		this.productId = productId;
		this.year = year;
		this.area = area;
		this.index = index;
		this.inputForm = inputForm;
	}


	public ProductSecretKey() {
		super();
	}
	
	public ProductSecretKey(Timestamp date,String uuid, String accountNum, String accountPwd, Product product){
		this(date, uuid, accountNum, accountPwd,product.getId(), product.getYear(), product.getArea(), product.getIndex(), product.getInputForm());
	}


	public Integer getProductId() {
		return productId;
	}


	public void setProductId(Integer productId) {
		this.productId = productId;
	}


	public Timestamp getDate() {
		return date;
	}


	public void setDate(Timestamp date) {
		this.date = date;
	}


	public String getUuid() {
		return uuid;
	}


	public void setUuid(String uuid) {
		this.uuid = uuid;
	}


	public String getAccount_num() {
		return account_num;
	}


	public void setAccount_num(String accountNum) {
		account_num = accountNum;
	}


	public String getAccount_pwd() {
		return account_pwd;
	}


	public void setAccount_pwd(String accountPwd) {
		account_pwd = accountPwd;
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
	
	
}
