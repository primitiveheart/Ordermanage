package com.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.entity.Admin;
import com.entity.User;

public class LoginInterceptor implements HandlerInterceptor{

	@Override
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response,
			Object handler, ModelAndView modelAndView) throws Exception {
		
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
			Object handler) throws Exception {
		//获取url请求
		String url = request.getRequestURI();
		//判断是否是公开地址
		if(url.indexOf("login.html") >= 0 || url.indexOf("logout.html") >=0 ||
				url.indexOf("signupValid.html") >= 0 || url.indexOf("signupValidation.html") >= 0 || 
			     url.indexOf("signup.html") >= 0 || url.indexOf("loginValid.html") >= 0 ||
				url.indexOf("loginValidation.html") >= 0 || url.indexOf("isLogin.html") >= 0 || 
				url.indexOf("userhome.html") >= 0 || url.indexOf("acquireRegion.html") >= 0 || 
				url.indexOf("getExtentByRegionId.html") >= 0 || url.indexOf("getAreaforRegion.html") >= 0 ){
			return true;
		}
		
		HttpSession session = request.getSession();
		
		//用户
		User user = (User) session.getAttribute("user");
		
		//管理员
		Admin admin = (Admin) session.getAttribute("admin");
		
		if(user != null || admin != null){
			return true;
		}
		
		//执行到这里表示用户省份需要认证，跳转到登录的页面
		if(url.indexOf("admin") >= 0){
			request.getRequestDispatcher("/admin/login.html").forward(request, response);
		}else{
			request.getRequestDispatcher("/home/login.html").forward(request, response);
		}
		return false;
	}

}
