package com.utils;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.alibaba.fastjson.JSONObject;

public class ResponseUtil {
	//获得日志记录对象
	private final static Logger logger = LoggerFactory.getLogger(ResponseUtil.class);
	
	public static void renderJson(HttpServletResponse response, String jsonStr){
		//设置编码类型
		response.setCharacterEncoding("UTF-8");
		//设置内容类型
		response.setContentType("application/json;charset=utf-8");
		PrintWriter write = null;
		try{
			write = response.getWriter();
			write.append(jsonStr);
		}catch (Exception e) {
			logger.error("没有得到输出流",e);
		}finally{
			if(write != null){
				write.close();
			}
		}
	}
	
	public static void renderJson(HttpServletResponse response, JSONObject jsonObject){
		renderJson(response, jsonObject.toJSONString());
	}
}
