package com.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.processors.JsonBeanProcessor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.alibaba.fastjson.JSONObject;
import com.entity.User;
import com.mapper.UserMapper;
import com.utils.JSONUtil;
import com.utils.ResponseUtil;

@Controller
@RequestMapping("home")
public class UserController {
	@Autowired
	private UserMapper userMapper;
	
	/**
	 * 判断是否登录
	 * @param session
	 */
	@RequestMapping("isLogin.html")
	public void isLogin(HttpServletResponse response, HttpSession session){
		JSONObject jsonObject = new JSONObject();
		User user = (User) session.getAttribute("user");
		if(user == null){
			jsonObject.put("islogin", false);
		}else{
			jsonObject.put("islogin", true);
		}
		
		ResponseUtil.renderJson(response, jsonObject);
	}
	
	/**
	 * 进入到登录页面
	 * @param session
	 * @param isLogin //主要判断订单提交前是否登录，false 是未登录
	 * @param year
	 * @param area
	 * @param index
	 * @param inputForm
	 * @param scope
	 * @param shape
	 * @return
	 */
	@RequestMapping("login.html")
	public String login(HttpSession session , @RequestParam(required=false) String isLogin, @RequestParam(required=false) String year,
			@RequestParam(required=false) String area, @RequestParam(required=false) String index, @RequestParam(required=false) String inputForm, 
			@RequestParam(required=false) String scope, @RequestParam(required=false) String shape){
		
		session.removeAttribute("jsonObject");
		session.removeAttribute("isLogin");
		
		if(isLogin != null && isLogin.equals("false")){
			JSONObject jsonObejct = new JSONObject();
			jsonObejct.put("year", year);
			jsonObejct.put("area", area);
			jsonObejct.put("index", index);
			jsonObejct.put("inputForm", inputForm);
			jsonObejct.put("scope", scope);
			jsonObejct.put("shape", shape);
			session.setAttribute("jsonObject", jsonObejct);
			session.setAttribute("isLogin", "true");
		}
		return "home/login";
	}
	
	/**
	 * 后台登录验证
	 * @param user
	 */
	@RequestMapping("loginValidation.html")
	public void loginValidation(HttpServletResponse response, HttpSession session, String name, String value){
		JSONObject jsonObject = new JSONObject();
		if(name.equals("username")){//进行用户名验证
			User queryUser = userMapper.queryUserByUsername(value);
			if(queryUser == null){
				jsonObject.put("type", name);
			}else{
				session.setAttribute("user", queryUser);
			}
		}else{//进行密码验证
			User existUser = (User) session.getAttribute("user");
			if(existUser != null){
				User queryUser = userMapper.queryUserByUsername(existUser.getUsername());
				if(!value.equals(queryUser.getPassword())){
					jsonObject.put("type", name);
				}
			}
		}
		
		ResponseUtil.renderJson(response, jsonObject);
	}
	
	/**
	 * 进行登录验证
	 * @param session
	 * @param user
	 * @return
	 */
	@RequestMapping(value="loginValid.html", method=RequestMethod.POST)
	public String loginValid(HttpSession session, User user){
		//根据用户名进行查询用户
		User queryUser = userMapper.queryUserByUsername(user.getUsername());
		//进行验证
		if(queryUser == null){
			//用户不存在
			return "redirect:login.html";
		}else if(user.getPassword().equals(queryUser.getPassword())){
			//用户存在
			session.setAttribute("user", queryUser);
			//如何提交表单操，isLogin是true
			String isLogin = (String) session.getAttribute("isLogin");
			if(isLogin!= null && isLogin.equals("true")){
				JSONObject jsonObject = (JSONObject) session.getAttribute("jsonObject");
				return "redirect:createOrder.html?"+JSONUtil.jsonToURL(jsonObject);
			}else{
				return "redirect:userhome.html";
			}
			
		}else{
			//用户存在，密码不正确
			return "redirect:login.html";
		}
	}
	
	/**
	 * 进入到注册页面
	 * @return
	 */
	@RequestMapping("signup.html")
	public String signup(){
		return "home/sign-up";
	}
	
	/**
	 * 后台注册验证
	 * @param response
	 * @param session
	 * @param name
	 * @param value
	 */
	@RequestMapping("signupValidation.html")
	public void signupValidation(HttpServletResponse response, HttpSession session , String name, String value){
		JSONObject jsonObject = new JSONObject();
		if(name.equals("username")){
			//根据用户名进行查询，看数据库中是否存在该用户名
			User queryUser = userMapper.queryUserByUsername(value);
			if(queryUser != null){
				jsonObject.put("type", name);
			}
		}else if(name.equals("telephone")){
			//根据电话进行查询，看数据库中是否存在该电话号码
			User queryUser = userMapper.queryUserByTelephone(value);
			if(queryUser != null){
				jsonObject.put("type", name);
			}
		}else if(name.equals("email")){
			//根据邮箱来查询，看数据库中是否存在该邮箱
			User queryUser = userMapper.queryUserByEmail(value);
			if(queryUser != null){
				jsonObject.put("type", name);
			}
		}
		
		//进行渲染字符串
		ResponseUtil.renderJson(response, jsonObject);
	}
	
	/**
	 * 进行注册验证
	 * @return
	 */
	@RequestMapping(value="signupValid.html", method=RequestMethod.POST)
	public String signupValid(User user){
		//把用户插入到users表中
		userMapper.addUser(user);
		//重定向到登录页面
		return "redirect:login.html";
	}
	
	
	/**
	 * 
	 * 注销用户
	 * @param session
	 * @return
	 */
	@RequestMapping("logout.html")
	public String logout(HttpSession session){
		
		//清楚session,使session失效
		session.invalidate();
		
		return "redirect:login.html";
	}
	
}
