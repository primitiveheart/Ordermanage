<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<!--  
	<script type="text/javascript" src="resources/js/jquery-3.2.1.js" ></script>
    <script type="text/javascript" src="resources/js/semantic.min.js"></script>
	-->
	 <style type="text/css">
     	body{
     		padding:1em;
     	}
     	.ui.menu{
     		margin:3em 0em;
     	}
     	.ui.menu:last-child{
     		margin-bottom:110px;
     	}
     </style>
</head>
<body>
	<div class="ui menu">
	  		<div class="header item">
	  			<img src="resources/images/logo.jpg">
	  			网格数据订单服务
	  		</div>
	  		<div class="item">
	  			<a href="home/userhome.html">主页</a>
	  		</div>
	  		<c:if test="${user == null}">
	  			<div class="item">
	  				<a class="ui button" href="home/login.html">登录</a>
	  			</div>
	  			<div class="item">
	  				<a class="ui blue button" href="home/signup.html">注册</a>
	  			</div>
	  		</c:if>
	  		
	  		<div class="right menu">
	  			<div class="item searchItem">
	  				<div class="ui small action left icon input">
	  					<i class="search icon"></i>
	  					<input type="text" placeholder="Search" value="${searchVal}"/>
	  				</div>
	  			</div>
	  			<c:if test="${user!=null && user.username != null}">
	  				<div class="item left icon ">
	   					欢迎您:${user.username} 
	  				</div>
	  				
					<div class="item left icon ">
						<i class="sign out icon"></i>
						<a class="item" href="home/logout.html">注销</a>
					</div>
					
					<div class="ui dropdown item">
			  			<div class="text left icon">
			  				<i class="user icon"></i>
			  				个人中心
			  			</div>
			  			<i class="dropdown icon"></i>
			  			<div class="menu">
			  				<div class="item left icon">
			  					<i class="in cart icon"></i>
			  					<a href="home/myOrder.html?pageNum=1">我的订单</a>
			  				</div>
			  				<div class="item left icon">
			  					<i class="talk icon"></i>
			  					<a href="home/myMessage.html">我的消息</a>
			  					<div class="floating ui teal label">22</div>
			  				</div>
		  				</div>
		  			</div>
				</c:if>
	  		</div>
	  </div>
	  <script>
	  	$(document).ready(function(){
	  		$('.ui.menu .ui.dropdown').dropdown({on: 'hover'});
	      	$('.ui.menu a.item').on('click', function() {
	          $(this).addClass('active').siblings().removeClass('active');
	        })
	  	})
	  </script>
</body>
</html>