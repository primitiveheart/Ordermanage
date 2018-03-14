package com.controller;

import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


import com.alibaba.fastjson.JSONObject;
import com.commons.Page;
import com.constant.ProductType;
import com.entity.Message;
import com.entity.Order;
import com.entity.OrderProduct;
import com.entity.Product;
import com.entity.SearchOrder;
import com.entity.User;
import com.mapper.IndexMapper;
import com.mapper.MessageMapper;
import com.mapper.OrderMapper;
import com.mapper.ProductMapper;
import com.mapper.UserMapper;
import com.service.PageService;
import com.utils.ResponseUtil;

/**
 * 管理员管理订单的界面
 * @author admin
 *
 */
@Controller
@RequestMapping("admin")
public class AdminManageController {
	
	private final static Logger logger = LoggerFactory.getLogger(AdminManageController.class);
	
	@Autowired
	private OrderMapper orderMapper;
	
	@Autowired
	private ProductMapper productMapper;
	
	@Autowired
	private IndexMapper indexMapper;
	
	@Autowired
	private MessageMapper messageMapper;
	
	@Autowired
	private PageService pageService;
	
	@Autowired
	private UserMapper userMapper;
	
//	@RequestMapping("manage.html")
	public String manage(HttpServletRequest request){
		List<OrderProduct> orderProducts = new ArrayList<OrderProduct>();
		try{
			List<Order> orders = orderMapper.queryAllOrder();
			for(Order order : orders){
				List<Product> products = productMapper.queryProductByOrderUUID(order.getUuid());
				OrderProduct orderProduct = new OrderProduct(order, products);
				orderProducts.add(orderProduct);
			}
		}catch (Exception e) {
			logger.error("AdminManageController manage 数据查找失败", e);
		}
		
		request.setAttribute("orderProducts", orderProducts);
		return "admin/manage";
	}
	
	/**
	 * 进入到管理员的主界面
	 * @param request
	 * @return
	 */
	@RequestMapping("manage.html")
	public String getPageData(Model model, Integer pageNum){
		List<OrderProduct> orderProducts = new ArrayList<OrderProduct>();
		int pageSize = 2;
		Page page = new Page();
		if(pageNum == null){
			pageNum = 1;
		}
		try {
			page = pageService.getPageData(pageNum, pageSize);
			List<Order> orders = page.getList();
			for(Order order : orders){
				List<Product> products = productMapper.queryProductByOrderUUID(order.getUuid());
				for(int i= 0; i<products.size(); i++){
					String inputForm = products.get(i).getInputForm();
					if(inputForm.equals("data")){
						products.get(i).setInputForm(ProductType.vector);
					}else if(inputForm.equals("special")){
						products.get(i).setInputForm(ProductType.special);
					}else{
						products.get(i).setInputForm(ProductType.sum);
					}
				}
				OrderProduct orderProduct = new OrderProduct(order, products);
				orderProducts.add(orderProduct);
			}
		} catch (Exception e) {
			logger.error("AdminManageController manage 数据查找失败", e);
		}
		
		page.setList(orderProducts);
		
		model.addAttribute("page", page);
		model.addAttribute("path", "manage.html");
		return "admin/manage";
	}
	
	@RequestMapping(value="acquireSecretKey.html", method=RequestMethod.POST)
	public void acquireSecretKey(HttpServletResponse response, String order_uuid, String product_id, String username, String state){
		//TODO 这里需要写日志
		JSONObject jsonObject = new JSONObject();
		
		User user = userMapper.queryUserByUsername(username);
		
		if("审核中".equals(state)){
			try {
				//第一步：改变的订单的状态
				//1.获得产品
				Product product = productMapper.queryProductById(Integer.valueOf(product_id));
				//2.更新状态
				product.setState("审核通过");
				productMapper.updateProductById(product);
				
				int typeValue = 0;
				//第二步：获取密钥
				if(product.getInputForm().equals("special")){
					typeValue = 1;
				}else if(product.getInputForm().equals("sum")){
					typeValue = 3;
				}else{
					typeValue = 2;
				}
				String account = indexMapper.getSecretKey(user.getId(),typeValue);
				JSONObject accountJson = JSONObject.parseObject(account);
				
				//第三步：把消息写到数据库中
				Message message = new Message();
				message.setAccount_num(accountJson.getString("acc_num"));
				message.setAccount_pwd(accountJson.getString("pwd"));
				message.setUsername(username);
				message.setProduct_id(Integer.valueOf(product_id));
				
				messageMapper.addMessage(message);
			} catch (Exception e) {
				logger.error("AdminManageController acquireSecretKey 产品更新数据失败或是消息插入数据库失败", e);
			}
			
			jsonObject.put("success", true);
		}
		
		if("审核通过".equals(state)){
			try {
				//1.获得产品
				Product product = productMapper.queryProductById(Integer.valueOf(product_id));
				//2.更新状态
				product.setState("审核中");
				productMapper.updateProductById(product);
			} catch (NumberFormatException e) {
				logger.error("AdminManageController acquireSecretKey 产品更新数据失败", e);
			}
		}
		
		ResponseUtil.renderJson(response, jsonObject);
	}
	
	/**
	 * 获得有的用户名
	 * @param response
	 * @return
	 */
	@RequestMapping("acquireAllUsername.html")
	@ResponseBody
	public void acquireAllUsername(HttpServletResponse response){
		JSONObject jsonObject = new JSONObject();
		List<String> usernames = new ArrayList<String>();
		try {
			List<User> users = userMapper.queryAllUser();
			if(users != null && users.size()!= 0){
				for(User user : users){
					usernames.add(user.getUsername());
				}
				jsonObject.put("usernames", usernames);
			}else{
				jsonObject.put("usernames", "nodata");
			}
		} catch (Exception e) {
			logger.error("AdminManageController acquireAllUsername 获取所有的用户失败", e);
		}
		
		ResponseUtil.renderJson(response, jsonObject);
	}
	
	/**
	 * 获得所有的订单号
	 * @param response
	 */
	@RequestMapping("acquireAllOrderUUID.html")
	@ResponseBody
	public void acquireAllOrderUUID(HttpServletResponse response){
		JSONObject jsonObject = new JSONObject();
		List<String> orderUUIDs = new ArrayList<String>();
		try {
			List<Order> orders = orderMapper.queryAllOrder();
			logger.info("AdminManageController acquireAllOrderUUID 获得所有的订单成功");
			if(orders != null && orders.size()!= 0){
				for(Order order : orders){
					orderUUIDs.add(order.getUuid());
				}
				jsonObject.put("orderUUIDs", orderUUIDs);
			}else{
				jsonObject.put("orderUUIDs", "nodata");
			}
		} catch (Exception e) {
			logger.error("AdminManageController acquireAllOrderUUID 获得所有的订单失败", e);
		}
		
		ResponseUtil.renderJson(response, jsonObject);
	}
	
	/**
	 * 提交搜索订单
	 * @param response
	 */
	@RequestMapping(value = "submitSearchForm.html")
	@ResponseBody
	public void submitSearchForm(HttpServletResponse response, SearchOrder searchOrder, Integer pageNum){
		JSONObject jsonObject = new JSONObject();
		List<OrderProduct> orderProducts = new ArrayList<OrderProduct>();
		Integer pageSize = 2;
		Page page = pageService.getPageDataBySearchOrder(pageSize, pageNum, searchOrder);
		List<Order> orders = page.getList();
		if(orders != null && orders.size() != 0){
			for(Order order : orders){
				List<Product> products = productMapper.queryProductByOrderUUID(order.getUuid());
				//主要是筛选审核通过和未审核
				List<Product> tempProducts = new ArrayList<Product>();
				if(products != null && products.size() != 0){
					for(Product product : products){
						String inputForm = product.getInputForm();
						if(inputForm.equals("data")){
							product.setInputForm(ProductType.vector);
						}else if(inputForm.equals("special")){
							product.setInputForm(ProductType.special);
						}else{
							product.setInputForm(ProductType.sum);
						}
						if(product.getState().equals(searchOrder.getState())){
							tempProducts.add(product);
						}
					}
					if(searchOrder.getState() != null && searchOrder.getState() != ""){
						if(tempProducts.size() != 0){
							OrderProduct orderProduct = new OrderProduct(order, tempProducts);
							orderProducts.add(orderProduct);
						}
					}else{//主要是针对单个订单搜索
						OrderProduct orderProduct = new OrderProduct(order, products);
						orderProducts.add(orderProduct);
					}
					
				}
			}
			page.setList(orderProducts);
			jsonObject.put("page", page);
		}
		
		ResponseUtil.renderJson(response, jsonObject);
	}
	
}
