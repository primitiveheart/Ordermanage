package com.controller;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.crypto.URIDereferencer;

import net.sf.json.processors.JsonBeanProcessor;

import org.apache.commons.collections.map.HashedMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import sun.misc.BASE64Encoder;

import com.alibaba.fastjson.JSONObject;
import com.commons.Page;
import com.constant.LegendColorEnum;
import com.constant.ProductType;
import com.entity.Message;
import com.entity.Order;
import com.entity.OrderProduct;
import com.entity.Product;
import com.entity.User;
import com.mapper.IndexMapper;
import com.mapper.MessageMapper;
import com.mapper.OrderMapper;
import com.mapper.ProductMapper;
import com.service.PageService;
import com.sun.org.apache.xpath.internal.operations.Or;
import com.utils.ResponseUtil;
import com.utils.UUIDUtil;

@Controller
@RequestMapping("home")
public class OrderManageController {
	
	private final static Logger logger = LoggerFactory.getLogger(OrderManageController.class);
	
	@Autowired
	private ProductMapper productMapper;
	
	@Autowired
	private OrderMapper orderMapper;
	
	@Autowired
	private MessageMapper messageMapper;
	
	@Autowired
	private IndexMapper indexMapper;
	
	@Autowired
	private PageService pageService;
	
	/**
	 * 转向订单成功页面
	 * @return
	 */
	@RequestMapping("createOrderSuccess.html")
	public String creataOrderSuccess(){
		return "home/create-order-success";
	}
	
	/**
	 * 我的订单
	 * @return
	 */
	@RequestMapping("myOrder.html")
	public String myOrder(HttpSession session, HttpServletRequest request, Integer pageNum){
		User user = (User) session.getAttribute("user");
		List<OrderProduct> orderProudcts = new ArrayList<OrderProduct>();
		if(user == null){
			return "redirect:login.html";
		}else{
			try{
				int pageSize = 3;
				Page page = pageService.getPageData(pageNum, pageSize, user.getUsername());
				List<Order> orders = page.getList();
				for(Order order : orders){
					List<Product> products = productMapper.queryProductByOrderUUID(order.getUuid());
					for(int i=0; i<products.size(); i++){
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
					orderProudcts.add(orderProduct);
				}
				page.setList(orderProudcts);
				request.setAttribute("page", page);
//				List<Order> orders = orderMapper.queryOrderByUsername(user.getUsername());
//				for(Order order : orders){
//					List<Product> products = productMapper.queryProductByOrderUUID(order.getUuid());
//					for(int i= 0; i<products.size(); i++){
//						String inputForm = products.get(i).getInputForm();
//						if(inputForm.equals("data")){
//							products.get(i).setInputForm(ProductType.vector);
//						}else if(inputForm.equals("special")){
//							products.get(i).setInputForm(ProductType.special);
//						}else{
//							products.get(i).setInputForm(ProductType.sum);
//						}
//					}
//					OrderProduct orderProduct = new OrderProduct(order, products);
//					orderProudcts.add(orderProduct);
//				}
			}catch (Exception e) {
				logger.error("OrderManageController myOrder 查找数据失败", e);
			}
		}
		
//		request.setAttribute("orderProudcts", orderProudcts);
		//这里主要进行查询数据库
		return "home/myOrder";
	}
	
	
	@RequestMapping("searchOrder.html")
	public String searchOrder(HttpSession session, String searchVal){
		//向session中添加
		session.setAttribute("searchVal", searchVal);
		return "redirect:searchOrderRedirect.html";
	}
	
	/**
	 * 订单的搜索功能
	 * @param response
	 * @param searchVal
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping("searchOrderRedirect.html")
	public String searchOrderRedirect(HttpSession session, HttpServletRequest request, @RequestParam(required=false)String searchVal){
		User user = (User) session.getAttribute("user");
		
		if(searchVal == "" || searchVal == null){
			searchVal = (String) session.getAttribute("searchVal");
			//当刷新页面时
			if(searchVal == "" || searchVal == null){
				return "redirect:myOrder.html?pageNum=1";
			}else{
				//移除session中searchVal值
				session.removeAttribute("searchVal");
			}
		}
		
		List<OrderProduct> orderProducts = new ArrayList<OrderProduct>();
		
		//当搜索字段是order中的字段
		if(searchVal.contains(":") || searchVal.contains("-") || "LineString".contains(searchVal) || "Polygon".contains(searchVal) || "Circle".contains(searchVal)){
			try {
				List<Order> orders = orderMapper.queryOrderBySearchVal(searchVal,user.getUsername());
				if(orders != null && orders.size() != 0){
					for(Order order : orders){
						List<Product> products = productMapper.queryProductByOrderUUID(order.getUuid());
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
							}
							
							OrderProduct orderProduct = new OrderProduct(order, products);
							orderProducts.add(orderProduct);
						}
					}
				}
				request.setAttribute("orderProducts", orderProducts);
				request.setAttribute("searchVal", searchVal);
			} catch (Exception e) {
				logger.error("OrderManageController searchOrder 产品数据查找失败", e);
			}
		}else{
			Map<String,List<Product>> tempMap = new HashedMap();
			try {
				List<Product> products = productMapper.queryProductBySearchVal(searchVal);
				if(products != null){
					//添加到map中根据订单号分类
					for(Product product : products){
						String inputForm = product.getInputForm();
						if(inputForm.equals("data")){
							product.setInputForm(ProductType.vector);
						}else if(inputForm.equals("special")){
							product.setInputForm(ProductType.special);
						}else{
							product.setInputForm(ProductType.sum);
						}
						
						
						if(tempMap.get(product.getOrder_uuid()) != null){
							tempMap.get(product.getOrder_uuid()).add(product);
						}else{
							List<Product> tempList = new ArrayList<Product>();
							tempList.add(product);
							tempMap.put(product.getOrder_uuid(), tempList);
						}
					}
					//要做个判断（判断该订单是否是该用户的）
					for(Entry entry : tempMap.entrySet()){
						String key = (String) entry.getKey();
						List<Product> value = (List<Product>) entry.getValue();
						Order order = orderMapper.queryOrderByUUID(key);
						if(order.getUsername().equals(user.getUsername())){
							OrderProduct orderProduct = new OrderProduct(order, value);
							orderProducts.add(orderProduct);
						}
					}
				
					request.setAttribute("orderProducts", orderProducts);
					request.setAttribute("searchVal", searchVal);
				}
				
			} catch (Exception e) {
				logger.error("OrderManageController searchOrder 产品数据查找失败", e);
			}

		}
		
		return "home/order-search-result";
	}
	
	
	/**
	 * 暂时没有用到该方法
	 * @param session
	 * @param response
	 * @param draw
	 * @param start
	 * @param length
	 */
	@RequestMapping("orderData.html")
	@ResponseBody
	public void orderData(HttpSession session, HttpServletResponse response, Integer draw, Integer start, Integer length){
		User user = (User) session.getAttribute("user");
		String username = user.getUsername();
		JSONObject jsonObject = new JSONObject();
		
		List<OrderProduct> orderProducts = new ArrayList<OrderProduct>();
		try{
			List<Order> orders = orderMapper.queryOrderByUsername(username);
			for(Order order : orders){
				List<Product> products = productMapper.queryProductByOrderUUID(order.getUuid());
				OrderProduct orderProduct = new OrderProduct(order, products);
				orderProducts.add(orderProduct);
			}
		}catch (Exception e) {
			logger.error("OrderManageController orderData 查找数据失败", e);
		}
		
		int orderProductSize = orderProducts.size();
		
		List<OrderProduct> data = new ArrayList<OrderProduct>();
		
		for(int i = start; i <(start + 1)*length; i++){
			if(i >= orderProductSize){
				break;//退出循环
			}
			data.add(orderProducts.get(i));
		}
		
		Integer recordsTotal = orderMapper.totalOrderNumByUsername(username);
		Integer recordsFiltered = orderMapper.totalOrderNumByUsername(user.getUsername());
		
		jsonObject.put("draw", draw);
		jsonObject.put("recordsTotal", recordsTotal);
		jsonObject.put("recordsFiltered", recordsFiltered);
		jsonObject.put("data", data);
		
		ResponseUtil.renderJson(response, jsonObject);
	}
	
	
	/**
	 * 创建订单
	 * @return
	 */
	@RequestMapping("createOrder.html")
	public String createOrder(HttpSession session, Product product, @RequestParam(required=false) String shape,
			@RequestParam(required=false) String scope){
		try {
			scope = URLDecoder.decode(scope, "UTF-8");
			logger.info("OrderManageController createOrder scope解码成功");
		} catch (UnsupportedEncodingException e1) {
			logger.error("OrderManageController createOrder scope 解码失败", e1);
		}
		//获取用户名
		User user = (User) session.getAttribute("user");
		if(user == null){
			return "redirect:login.html";
		}
		if(shape != null && scope != null){
			
			//创建订单
			Order order = new Order();
			String order_uuid = UUIDUtil.getUUID();
			String order_num = "1";
			String order_price = Integer.valueOf(product.getArea()) * 100 + "";
			String order_state = "审核中";
			order.setUuid(order_uuid);
			order.setNumber(order_num);
			order.setPrice(order_price);
			order.setState(order_state);
			order.setUsername(user.getUsername());
			order.setScope(scope);
			order.setShape(shape);
			try{
				//把订单插入到数据库中
				orderMapper.addOrder(order);
			}catch (Exception e) {
				logger.error("OrderManageController createOrder 订单数据插入失败", e);
			}
			
			String year = product.getYear();
			String[] yearProduct = year.split(",");
			try{
				for(int i=0; i < yearProduct.length; i++){
					Product tempProduct = new Product();
					tempProduct.setYear(yearProduct[i]);
					tempProduct.setArea(product.getArea());
					tempProduct.setIndex(product.getIndex());
					tempProduct.setInputForm(product.getInputForm());
					tempProduct.setOrder_uuid(order_uuid);
					tempProduct.setState(order_state);
					
					//把产品数据插入到数据库中
					productMapper.addProduct(tempProduct);
				}
			}catch (Exception e) {
				logger.error("OrderManageController createOrder 产品数据插入失败", e);
			}
			
			if(session.getAttribute("jsonObject") != null){
				session.removeAttribute("jsonObject");
			}
			
			//创建订单成功后转向成功的页面
			return "redirect:createOrderSuccess.html";
		}
		
		return "redirect:userhome.html";
	}
	
	@RequestMapping("productResultDisplay.html")
	public String productResultDisplay(HttpSession session, Integer productId, @RequestParam(required=false)Integer pageNum){
    	String VIEWPARAMS = "";
    	//第一步:获取密钥
		Message message = messageMapper.queryMessageByProudctId(productId);
		String account_num = message.getAccount_num();
		String account_pwd = message.getAccount_pwd();
		
		//获取产品
	    Product product = productMapper.queryProductById(productId);
	    
	    //获取订单
	    Order order = orderMapper.queryOrderByUUID(product.getOrder_uuid());
	    
	    String fld = product.getIndex();
		Integer year = Integer.valueOf(product.getYear());
	    
	    //获取数据选项
		String middle = product.getIndex().replace(",", "\\,");
		VIEWPARAMS = order.getScope() + ";fld:'"+ middle + "';year_:" + product.getYear() + ";usr_name:" + "'" + account_num +"';pwd:'" + account_pwd + "'";
		String inputForm = product.getInputForm();
		
		
	
		
		session.setAttribute("shape", order.getShape());
		session.setAttribute("scope", order.getScope());
		session.setAttribute("VIEWPARAMS", VIEWPARAMS);
		session.setAttribute("pageNum", pageNum);
		
		//session.setAttribute("productId", productId);
		
		
    	
    	if(inputForm.equals("data")){
    		return "redirect:../result/vector.html";
    	}else if(inputForm.equals("special")){
    		String env = getSLDAppendix(account_num, account_pwd, fld, year, order);
    		env = env.split("=")[1];
    		session.setAttribute("env", env);
    		return "redirect:../result/special.html";
    	}else{
    		return "redirect:../result/sum.html";
    	}
	}
	
	@RequestMapping("productPicture.html")
	@ResponseBody
	public void productPicture(HttpServletResponse response, String range) throws IOException{
		//范围值
		String[] ranges = new String[8];
		ranges[0] = "0..0";
		ranges[1] = "0.." + range.split(";")[0].split(":")[1];
		for(int i = 1; i < range.split(";").length; i++){
			ranges[i+1] = range.split(";")[i-1].split(":")[1] + ".." + range.split(";")[i].split(":")[1];
		}
		ranges[7] = "> " + range.split(";")[5].split(":")[1];
		
		//图片的宽度和高度
		int height = 160;
		int width = 120;
		//生成图片
		BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		//得到画布
		Graphics2D graphics2d = (Graphics2D) image.getGraphics();
		//设置背景颜色
		graphics2d.setColor(Color.WHITE);
		graphics2d.fillRect(0, 0, width, height);
		int i = 0;
		for(LegendColorEnum legendColorEnum : LegendColorEnum.values()){
			graphics2d.setColor(Color.decode(legendColorEnum.getColorValue()));
			graphics2d.fillRect(2, 20 * i, 20, 20);
			graphics2d.setColor(Color.BLACK);
			graphics2d.drawString(ranges[i], 30, 20 * (i + 1));
			i++;
		}
		
		//释放资源
		graphics2d.dispose();
		
		//设置返回类型
		response.setContentType("image/jpeg");
		ImageIO.write(image, "jpeg", response.getOutputStream());
	}
	
	/**
	 * @param account_num
	 * @param account_pwd
	 * @param order
	 * @return 获取参数为env的值
	 */
	public String getSLDAppendix(String accoutName, String accountPwd, String fld, Integer year, Order order){
		String shape = order.getShape();
		String env;
		
		if(shape.equals("Circle")){
			String[] middle = order.getScope().split(";");
			double lon = Double.parseDouble(middle[0].split(":")[1]);
			double lat = Double.parseDouble(middle[1].split(":")[1]);
			double radius = Double.parseDouble(middle[2].split(":")[1]);
			env = indexMapper.getSLDAppendix_byRadius(lon, lat, radius, fld, year, accoutName, accountPwd);
		}else if(shape.equals("Polygon")){
			String lineStr = order.getScope();
			String temp = lineStr.split(":")[1].replaceAll("'", "");
			env = indexMapper.getSLDAppendix_byPoly(temp, fld, year, accoutName, accountPwd);
		}else if(shape.equals("LineString")){
			String[] middle = order.getScope().split(";");
			double min_lon = Double.parseDouble(middle[0].split(":")[1]);
			double min_lat = Double.parseDouble(middle[1].split(":")[1]);
			double max_lon = Double.parseDouble(middle[2].split(":")[1]);
			double max_lat = Double.parseDouble(middle[3].split(":")[1]);
			env = indexMapper.getSLDAppendix_byRectangle(min_lon, min_lat, max_lon, max_lat, fld, year, accoutName, accountPwd);
		}else{
			Integer regionId = getRegionId(order);
			env = indexMapper.getSLDAppendix_byRegionId(regionId, fld, year, accoutName, accountPwd);
		}
		
		return env;
	}
	
	/**
	 * 查询统计信息
	 * @param productId
	 * @param shape
	 */
	@RequestMapping(value="showCityStatistics.html")
	public String showCityStatistics(HttpServletRequest request, Integer productId, String shape){
		//获取密钥
		Message message = messageMapper.queryMessageByProudctId(productId);
		String account_num = message.getAccount_num();
		String account_pwd = message.getAccount_pwd();
		//获取产品
		Product product = productMapper.queryProductById(productId);
		//获取订单
		Order order = orderMapper.queryOrderByUUID(product.getOrder_uuid());
		
		String fld = product.getIndex();
		Integer year = Integer.valueOf(product.getYear());
		
		
		JSONObject parseJson = new JSONObject();
		
		if(shape.equals("LineString")){
			String[] middle = order.getScope().split(";");
			double min_lon = Double.parseDouble(middle[0].split(":")[1]);
			double min_lat = Double.parseDouble(middle[1].split(":")[1]);
			double max_lon = Double.parseDouble(middle[2].split(":")[1]);
			double max_lat = Double.parseDouble(middle[3].split(":")[1]);
			String temp = indexMapper.showCityStatisticsByRectangle(min_lon, min_lat, max_lon, max_lat, fld, year, account_num, account_pwd);
		    parseJson = JSONObject.parseObject(temp);
		}else if(shape.equals("Circle")){
			String[] middle = order.getScope().split(";");
			double lon = Double.parseDouble(middle[0].split(":")[1]);
			double lat = Double.parseDouble(middle[1].split(":")[1]);
			double radius = Double.parseDouble(middle[2].split(":")[1]);
			String temp = indexMapper.showCityStatisticsByCircle(lon, lat, radius, fld, year, account_num, account_pwd);
			parseJson = JSONObject.parseObject(temp);
		}else if(shape.equals("Polygon")){
			String lineStr = order.getScope();
			String temp = indexMapper.showCityStatisticsByPoly(lineStr.split(":")[1], fld, year, account_num, account_pwd);
			parseJson = JSONObject.parseObject(temp);
		}else{
			Integer regionId = getRegionId(order);
			String temp = indexMapper.showCityStatisticsByRegionId(regionId, fld, year, account_num, account_pwd);
			parseJson = JSONObject.parseObject(temp);
		}
		
		String head = parseJson.getString("head").replace("(", "").replace(")", "");
		String content =  parseJson.getString("content");
		
		List<String> headList = new ArrayList<String>();
		String[] headSplit =  head.split(",");
		for(int i=0;i < headSplit.length; i++){
			headList.add(headSplit[i]);
		}
		
		request.setAttribute("head", headList);
		request.setAttribute("content", content);
		request.setAttribute("link", "home/showCityStatistics.html?productId="+productId + "&shape=" +shape);
		
		return "result/city-statistics";
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
		}else if(!regions[1].split(":")[1].equals("all") ){
			regionId = Integer.valueOf(regions[1].split(":")[1]);
		}else{
			regionId = Integer.valueOf(regions[0].split(":")[1]);
		}
		return regionId;
	}
	
	/**
	 * 根据产品号删除产品
	 * @param productId
	 * @return
	 */
	@RequestMapping("deleteProduct.html")
	public String deleteProduct(HttpSession session, Integer productId, Integer pageNum, @RequestParam(required=false) String searchVal){
		try{
			//根据id查询产品
			Product product = productMapper.queryProductById(productId);
			logger.info("OrderManageController deleteProduct 根据id成功查找产品");
			//根据订单号查询
			List<Product> products = productMapper.queryProductByOrderUUID(product.getOrder_uuid());
			if(products.size()==1){
				productMapper.deleteProductById(productId);
				orderMapper.deleteOrderByUUID(product.getOrder_uuid());
			}else{
				productMapper.deleteProductById(productId);
			}
		}catch (Exception e) {
			logger.error("OrderManageController deleteProduct 删除失败", e);
		}
		if(pageNum == 0){
			session.setAttribute("searchVal", searchVal);
			return "redirect:searchOrderRedirect.html";
		}else{
			return "redirect:myOrder.html?pageNum=" + pageNum;
		}
		
	}
	
	/**
	 * 删除订单
	 * @param uuid
	 * @return
	 */
	@RequestMapping("deleteOrder.html")
	public String deleteOrder(HttpSession session, String uuid, Integer pageNum, @RequestParam(required=false) String searchVal){
		try{
			//根据订单号查询
			List<Product> products = productMapper.queryProductByOrderUUID(uuid);
			logger.info("OrderManageController deleteOrder 根据订单号查询产品成功");
			//删除所有产品
			if(products == null){
				logger.info("OrderManageController deleteOrder 订单{}下所有的产品已经删除了",uuid);
			}else{
				for(Product product : products){
					productMapper.deleteProductById(product.getId());
					logger.info("OrderManageController deleteOrder 根据产品号删除产品成功");
				}
			}
			orderMapper.deleteOrderByUUID(uuid);
			logger.info("OrderManageController deleteOrder 根据订单号删除订单成功");
		}catch (Exception e) {
			logger.error("OrderManageController deleteProduct 删除失败", e);
		}
		//pageNum等于0，说明是搜索后再删除的
		if(pageNum == 0){
			session.setAttribute("searchVal", searchVal);
			return "redirect:searchOrderRedirect.html";
		}else{
			return "redirect:myOrder.html?pageNum="+pageNum;
		}
	}
}
