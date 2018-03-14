package com.controller;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.alibaba.fastjson.JSONObject;
import com.entity.Admin;
import com.mapper.AdminMapper;
import com.utils.ResponseUtil;

@Controller
@RequestMapping("admin")
public class AdminController {
	
	@Autowired
	private AdminMapper adminMapper;
	
	@RequestMapping("")
	public String admin(){
		return "redirect:admin/login.html";
	}
	
	/**
	 * 管理员进行登录
	 * @return
	 */
	@RequestMapping("login.html")
	public String login(){
		return "admin/login";
	}
	
	/**
	 * 管理员登录验证
	 * @param response
	 * @param session
	 * @param name
	 * @param value
	 */
	@RequestMapping("loginValidation.html")
	public void loginValidation(HttpServletResponse response, HttpSession session ,String name, String value){
		JSONObject jsonObject = new JSONObject();
		if(name.equals("username")){
			//进行管理员用户名验证
			Admin queryUser = adminMapper.queryAdminByUsername(value);
			if(queryUser != null){
				session.setAttribute("admin", queryUser);
			}else{
				jsonObject.put("type", name);
			}
		}else{
			//进行管理员密码验证
			Admin existUser = (Admin) session.getAttribute("admin");
			if(existUser != null){
				Admin queryUser = adminMapper.queryAdminByUsername(existUser.getUsername());
				if(!value.equals(queryUser.getPassword())){
					jsonObject.put("type", name);
				}
			}
		}
		
		ResponseUtil.renderJson(response, jsonObject);
	}

	/**
	 * 登录到管理员的主界面
	 * @param session
	 * @param admin
	 * @return
	 */
	@RequestMapping("loginValid.html")
	public String loginValid(HttpSession session, Admin admin){
		Admin queryUser = adminMapper.queryAdminByUsername(admin.getUsername());
		if(queryUser == null){
			//用户名不存在
			return "redirect:login.html";
		}else if(admin.getPassword().equals(queryUser.getPassword())){
			session.setAttribute("admin", queryUser);
			return "redirect:manage.html";
		}else {
			//密码不正确
			return "redirect:login.html";
		}
	}
	
	/**
	 * 注销，转到登录页面
	 * @param session
	 * @return
	 */
	@RequestMapping("logout.html")
	public String logout(HttpSession session){
		//清楚session
		session.invalidate();
		
		return "redirect:login.html";
	}
}
