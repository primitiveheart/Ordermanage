package com.utils;

import java.util.UUID;

/**
 * 生成uuid的唯一码
 * @author admin
 *
 */
public class UUIDUtil {
	
	public static String getUUID(){
		String uuid = UUID.randomUUID().toString();
		uuid = uuid.replace("-", "");
		return uuid;
	}
	
	public static void main(String[] args){
		System.out.println(getUUID());
	}
}
