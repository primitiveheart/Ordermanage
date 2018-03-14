package com.entity;

import java.io.Serializable;

public class Message implements Serializable{
	private Integer id;
	private String username;
	private String account_num;
	private String account_pwd;
	private Integer product_id;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
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
	public Integer getProduct_id() {
		return product_id;
	}
	public void setProduct_id(Integer productId) {
		product_id = productId;
	}
	@Override
	public String toString() {
		return "Message [account_num=" + account_num + ", account_pwd="
				+ account_pwd + ", id=" + id + ", product_id=" + product_id
				+ ", username=" + username + "]";
	}
	
}
