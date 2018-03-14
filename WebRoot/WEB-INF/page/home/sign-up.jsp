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
    
    <title>登录界面</title>
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
  					注册账户 
  				</div>
  			</h2>
  			<form class="ui large form" action="home/signupValid.html" method="post">
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
  					<div class="field">
  						<div class="ui left icon input">
  							<i class="mail icon"></i>
  							<input type="text" name="email" placeholder="邮箱"/>
  						</div>
  					</div>
  					<div class="field">
  						<div class="ui left icon input">
  							<i class="mobile icon"></i>
  							<input type="text" name="telephone" placeholder="电话号码"/>
  						</div>
  					</div>
  					<div class="field">
  						<div class="ui left icon input">
  							<i class="info icon"></i>
  							<input type="text" name="company" placeholder="单位"/>
  						</div>
  					</div>
  					<div class="field">
  						<div class="ui left icon input">
  							<i class="info icon"></i>
  							<input type="text" name="job" placeholder="职务"/>
  						</div>
  					</div>
  					<div class="ui fluid large teal submit button">注册</div>
  				</div>
  				<div class="ui error message"></div>
  			</form>
  		</div>
  	</div>
  </body>
  <script>
  	$(document).ready(function(){
  		$signupForm = $(".ui.form");
  		//这是表单验证
  		$signupForm.form({
  			inline:true,
  			on:"blur",
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
  							type:"empty",
  							prompt:"密码不能为空"
  						},
  						{
  							type:"length[6]",
  							prompt:"您的密码必须至少是6位数"
  						}
  					]
  				},
  				email:{
  					identifier:"email",
  					rules:[
  						{
  							type:"empty",
  							prompt:"邮箱不能为空"
  						},
  						{
  							type:"email",
  							prompt:"邮箱的格式不正确"
  						}
  					]
  				},
  				telephone:{
  					identifier:"telephone",
  					rules:[
  						{
  							type:"number",
  							prompt:"手机号码只允许是数字"
  						},
  						{
  							type:"exactLength[11]",
  							prompt:"手机长度不正确"
  						}
  					]
  				},
  				company:{
  					identifier:"company",
  					rules:[
  						{
  							type:"empty",
  							prompt:"请输入您的单位"
  						}
  					]
  				},
  				job:{
  					identifier:"job",
  					rules:[
  						{
  							type:"empty",
  							prompt:"请输入您的职务"
  						}
  					]
  				}
  			},
  			onValid:function(){
  				var selector = $(this).attr("name");
  				var value = $(this).val();
  				$.ajax({
  					url:"home/signupValidation.html",
  					data:{
  						name:selector,
  						value:value
  					},
  					success:function(result){
  						if(result.type == "username"){
  							$signupForm.form("add prompt", "username", "用户名已经存在，请您重新换一个");
  						}else if(result.type == "telephone"){
  							$signupForm.form("add prompt", "telephone","电话号码，已经存在")
  						}else if(result.type == "email"){
  							$signupForm.form("add prompt", "email", "邮箱已经存在");
  						}
  					}
  				})
  			}
  		})
  	})
  </script>
</html>
