package com.controller;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


import com.alibaba.fastjson.JSONObject;
import com.mapper.IndexMapper;
import com.utils.ResponseUtil;

@Controller
@RequestMapping("home")
public class MapController {
	
	private final static Logger logger = LoggerFactory.getLogger(MapController.class);
	
	@Autowired
	private IndexMapper indexMapper;

	@RequestMapping("getExtentByRegionId.html")
	@ResponseBody
	public void getExtentforRegion(HttpServletResponse response, String regionId){
		JSONObject jsonObject = new JSONObject();
		
		if("all".equals(regionId) || regionId == "" || regionId == "undefined"){
			jsonObject.put("extent", "novalid");
		}else{
			try {
				String temp = indexMapper.getExtentforRegion(Integer.valueOf(regionId));
				jsonObject.put("extent", temp);
				logger.info("MapController getExtentforRegion 根据编码获取范围成功");
			} catch (Exception e) {
				logger.error("MapController getExtentforRegion 根据编码获取范围失败", e);
			}
		}
		
		ResponseUtil.renderJson(response, jsonObject);
	}
	
}
