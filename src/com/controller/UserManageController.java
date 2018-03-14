package com.controller;


import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.ibatis.annotations.Param;
import org.junit.runners.Parameterized.Parameters;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.entity.Message;
import com.entity.Order;
import com.entity.Product;
import com.entity.ProductSecretKey;
import com.entity.User;
import com.mapper.IndexMapper;
import com.mapper.MessageMapper;
import com.mapper.OrderMapper;
import com.mapper.ProductMapper;
import com.utils.ResponseUtil;

@Controller
@RequestMapping("home")
public class UserManageController {
	
	private final static Logger logger = LoggerFactory.getLogger(UserManageController.class);
	
	@Autowired
	private IndexMapper indexMapper;
	
	@Autowired
	private MessageMapper messageMapper;
	
	@Autowired
	private ProductMapper productMapper;
	
	@Autowired
	private OrderMapper orderMapper;
	
	@RequestMapping("userhome.html")
	public String order(HttpServletRequest request){
		List<String> result;
		List<Integer> allYear;
		try {
			result = new ArrayList<String>();
			//获取所有的年份
			allYear = indexMapper.getAllYear();
			logger.info("UserManageController order 成功获取年份");
			
			//获取所有的指标
			String index = indexMapper.getIndex();
			logger.info("UserManageController order 获取数据产品成功");
			
			if(index != null && StringUtils.isNotEmpty(index)){
				JSONObject jsonObject1 = JSONObject.parseObject(index);
				String temp = jsonObject1.getString("result");
				JSONObject eng_name = JSONObject.parseObject(temp);
				result = JSONArray.parseArray(eng_name.getString("eng_name")).toJavaList(String.class);
			}
			
			List<String> provinces = new ArrayList<String>();
			
			//获取所有的省份
	    	String provinceStr = indexMapper.getProvince();
	    	logger.info("UserManageController order 成功获取省份");
	    	
	    	if(provinceStr != null && StringUtils.isNotEmpty(provinceStr)){
	    		JSONObject provinceJson = JSONObject.parseObject(provinceStr);
	    		String city_list = provinceJson.getString("city_list");
	    		JSONArray provinceArray = JSONArray.parseArray(city_list);
	    		for(String str : provinceArray.toJavaList(String.class)){
	    			provinces.add(str.replace("{", "").replace("}", "").replaceAll("\"", ""));
	    		}
	    	}
	    	
	    	request.setAttribute("provinces", provinces);
			request.setAttribute("index", result);
	    	request.setAttribute("allyear", allYear);
		} catch (Exception e) {
			logger.error("UserManageController order 获取年份或获取指标失败", e);
		}
    	
		return "home/user-home";
	}
	
	
	
	/**
	 * 进入到我的消息界面
	 * @return
	 */
	@RequestMapping("myMessage.html")
	public String myMessage(HttpSession session, HttpServletRequest request){
		User user = (User) session.getAttribute("user");
		List<ProductSecretKey> productSecretKeys = new ArrayList<ProductSecretKey>();
		try {
			//获取消息
			List<Message> messages = messageMapper.queryMessageByUsername(user.getUsername());
			for(Message message : messages){
				Product product = productMapper.queryProductById(message.getProduct_id());
				Order order = orderMapper.queryOrderByUUID(product.getOrder_uuid());
				ProductSecretKey productSecretKey = new ProductSecretKey(order.getDate(), order.getUuid(), message.getAccount_num(), message.getAccount_pwd(), product);
				productSecretKeys.add(productSecretKey);
			}
		} catch (Exception e) {
			logger.error("UserManageController myMessage 查询失败", e);
		}
		
		request.setAttribute("productSecretKeys", productSecretKeys);
		
		return "home/myMessage";
	}
	
	
	
}
