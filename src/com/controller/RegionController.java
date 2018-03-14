package com.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.entity.Message;
import com.entity.Order;
import com.entity.OrderProduct;
import com.entity.Product;
import com.mapper.IndexMapper;
import com.mapper.MessageMapper;
import com.mapper.OrderMapper;
import com.mapper.ProductMapper;
import com.utils.ResponseUtil;

@Controller
@RequestMapping("home")
public class RegionController {
	
	private final static Logger logger = LoggerFactory.getLogger(RegionController.class);
	
	@Autowired
	private IndexMapper indexMapper;
	
	@Autowired
	private MessageMapper messageMapper;
	
	@Autowired
	private ProductMapper productMapper;
	
	@Autowired
	private OrderMapper orderMapper;
	
	/**
	 * @param response
	 * @param type :市或是县
	 * @param id ： 市或是县的id
	 */
	@RequestMapping("acquireRegion.html")
	@ResponseBody
	public void acquireRegion(HttpServletResponse response, String type, String id){
		JSONObject jsonObject = new JSONObject();
		
		List<String> city = new ArrayList<String>();
		
		if("all".equals(id) || id == ""){
			jsonObject.put("city", "notExist");
		}else{
			if("city".equals(type)){
				try {
					//根据省份id获取所有的市
					String cityStr = indexMapper.getCity(Integer.valueOf(id));
					logger.info("RegionController acquireRegion 成功获取所有的市");
					
					if(cityStr != null || StringUtils.isNotEmpty(cityStr)){
						JSONObject cityJson =  JSONObject.parseObject(cityStr);
						String cityList = cityJson.getString("city_list");
						if(cityList != null && StringUtils.isNotEmpty(cityList)){
							JSONArray provinceArray = JSONArray.parseArray(cityList);
							for(String str : provinceArray.toJavaList(String.class)){
								city.add(str.replace("{", "").replace("}", "").replaceAll("\"", ""));
							}
						}else{
							jsonObject.put("city", "notExist");
						}
					}
				} catch (Exception e) {
					logger.error("RegionController acquireRegion 失败获取所有的市", e);
				}
			}else{
				try {
					//根据市的id获取所有的县
					String countyStr = indexMapper.getCounty(Integer.valueOf(id));
					logger.info("RegionController acquireRegion 成功获取所有的县");
					
					if(countyStr != null && StringUtils.isNotEmpty(countyStr)){
						JSONObject countyJson = JSONObject.parseObject(countyStr);
						String cityList = countyJson.getString("city_list");
						if(cityList != null && StringUtils.isNotEmpty(cityList)){
							JSONArray provinceArray = JSONArray.parseArray(cityList);
							for(String str : provinceArray.toJavaList(String.class)){
								city.add(str.replace("{", "").replace("}", "").replaceAll("\"", ""));
							}
						}else{
							jsonObject.put("city", "notExist");
						}
					}
				} catch (Exception e) {
					logger.error("RegionController acquireRegion 失败获取所有的县", e);
				}
			}
		}
		
		jsonObject.put("city", city);
		ResponseUtil.renderJson(response, jsonObject);
	}
	
	/**
	 * 得到行政区域的编码
	 * @param order
	 * @return
	 */
	private Integer getRegionId(Order order) {
		String region = order.getScope();
		String[] regions = region.split(";");
		Integer regionId = 0;
		if(!regions[2].split(":")[1].equals("all")){
			regionId = Integer.valueOf(regions[2].split(":")[1]);
		}else if(!regions[1].split(":")[1].equals("all")){
			regionId = Integer.valueOf(regions[1].split(":")[1]);
		}else{
			regionId = Integer.valueOf(regions[0].split(":")[1]);
		}
		return regionId;
	}
	
	
	@RequestMapping(value="getFeaturesByRegionId.html")
	@ResponseBody
	public void getFeaturesByRegionId(HttpServletResponse response, Integer productId){
		JSONObject jsonObject = new JSONObject();
		
		try {
			//第一步:获取密钥
			Message message = messageMapper.queryMessageByProudctId(productId);
			logger.info("RegionController getFeaturesByRegionId 获取密钥成功");
			String account_num = message.getAccount_num();
			String account_pwd = message.getAccount_pwd();
			
			//根据产品号获取产品
			Product product = productMapper.queryProductById(productId);
			logger.info("RegionController getFeaturesByRegionId 获取产品成功");
			
			//根据订单号获取订单
			Order order = orderMapper.queryOrderByUUID(product.getOrder_uuid());
			logger.info("RegionController getFeaturesByRegionId 获取产品成功");
			
			String fld = product.getIndex();
			Integer year = Integer.valueOf(product.getYear());
			
			Integer regionId = getRegionId(order);
			
			// SELECT getFeaturesByRegionId(?, ?, ?, ?, ?)]) but failed to remove it when the web application was stopped. This is very likely to create a memory leak.
			List<String> temp = indexMapper.getFeaturesByRegionId(regionId, fld, year, account_num, account_pwd);
			logger.info("RegionController getFeaturesByRegionId 获取特征成功");
			
			jsonObject.put("features", temp.toString());
		} catch (Exception e) {
			logger.error("RegionController getFeaturesByRegionId 获取密钥,获取产品,获取订单,获取特征失败", e);
		}
		ResponseUtil.renderJson(response, jsonObject);
	}
	
	/**
	 * 根据行政区域的编码得到行政区域的面积 
	 * @param response
	 * @param regionId
	 */
	@RequestMapping("getAreaforRegion.html")
	@ResponseBody
	public void getAreaforRegion(HttpServletResponse response, String regionId){
		JSONObject jsonObject = new JSONObject();
		
		if("all".equals(regionId) || regionId == ""){
			jsonObject.put("regionArea", "novalid");
		}else{
			try{
				String temp = indexMapper.getAreaforRegion(Integer.valueOf(regionId));
				jsonObject.put("regionArea", temp);
			}catch (Exception e) {
				logger.error("RegionController getAreaforRegion 根据行政区域的编码得到行政区域的面积 失败", e);
			}
		}
		
		ResponseUtil.renderJson(response, jsonObject);
	}
	
}
