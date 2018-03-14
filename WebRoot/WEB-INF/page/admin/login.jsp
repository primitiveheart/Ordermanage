<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>管理员的登录界面</title>
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <!--script start-->
    <script type="text/javascript" src="resources/js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="resources/js/semantic.min.js"></script>
    <!--script end-->
    <!--style start-->
    <link rel="stylesheet" href="resources/css/semantic.min.css" type="text/css"/>
    <style type="text/css">
    	body{
    		background-color: #DADADA;
    	}
    	body > .grid{
    		height:100%;
    	}
    	.image{
    		margin-top: -100px;
    	}
    	.column{
    		max-width:450px;
    	}
    </style>
    <!--style end--> 
  </head>
  
  <body>
  	<div class="ui middle aligned center aligned grid">
  		<div class="column">
  			<h2 class="ui teal image header">
  				<img class="image"  src="resources/images/logo.jpg">
  				<div class="content">	
  					登录你的账户
  				</div>
  			</h2>
  			<form class="ui large form" action="admin/loginValid.html" method="post">
  				<div class="ui stacked segment">
  					<div class="field">
  						<div class="ui left icon input">
  							<i class="user icon"></i>
  							<input type="text" name="username" placeholder="用户名">
  						</div> 
  					</div>
  					<div class="field">
  						<div class="ui left icon input">
  							<i class="lock icon"></i>
  							<input type="password" name="password" placeholder="密码"/>
  						</div>
  					</div>
  					<div class="ui fluid large teal submit button">登录</div>
  				</div>
  				<div class="ui error message"></div>
  			</form>
  		</div>
  	</div>
  </body>
  <script>
  	$(document).ready(function(){
  		var $messageForm = $(".ui.form");
  		//这是表单验证
  		$messageForm.form({
  			inline:true,
  			on:'blur',
  			fields:{
  				username:{
  					identifier:"username",
  					rules:[
  						{
  							type:"empty",
  							prompt:"用户名不能为空"
  						}
  					]
  				},
  				password:{
  					identifier:"password",
  					rules:[
  						{
  							type:"length[6]",
  							prompt:"您的密码必须至少是6位数"
  						}
  					]
  				}
  			},
  			onValid:function(){
  				//主要是进行后台验证
  				var selector = $(this).attr("name");
  				var value = $(this).val();
  				$.ajax({
  					url:"admin/loginValidation.html",
  					data:{
  						name:selector,
  						value:value
  					},
  					success:function(result){
  						if(result.type == "username"){
  							$(".ui.form").form('add prompt', "username", "用户名不存在");
  						}else if(result.type == "password"){
  							$(".ui.form").form('add prompt', "password", "密码不正确");
  						}
  					}
  				})
  			}
	 	});
  	})
  </script>
</html>
