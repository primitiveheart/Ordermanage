package com.utils;

import java.util.Map.Entry;

import com.alibaba.fastjson.JSONObject;

public class JSONUtil {
	public static String jsonToURL(JSONObject jsonObject){
		StringBuffer sb = new StringBuffer();
		int len = jsonObject.entrySet().size();
		int count = 0;
		for(Entry<String, Object> entry : jsonObject.entrySet()){
			String key = entry.getKey();
			String value = (String) entry.getValue();
			count++;
			if(count == len){
				sb.append(key + "=" + value);
			}else{
				sb.append(key + "=" + value + "&");
			}
		}
		return sb.toString();
	}
}
