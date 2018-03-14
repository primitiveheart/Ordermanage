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
    
    <title>我的消息</title>
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <!--script start-->
    <!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->
    <script type="text/javascript" src="resources/js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="resources/js/semantic.min.js"></script>
    <!--script end-->

    <!--style start-->
    <link rel="stylesheet" href="resources/css/semantic.min.css" type="text/css"/>
     <style type="text/css">
     		body > .ui.container{
     			margin-top:3em;
     		}
     </style>
    <!--style end--> 
  </head>
  
  <body>
	  	
	<!--把菜单包含进来  -->
	<%@include file="../commons/menu.jsp"%>
  	<h3 class="ui center aligned header">我的消息</h3>
  	<div class="ui stackable grid container">
  		<div class="ui segments">
  			<c:if test="${productSecretKeys != null}">
  				<c:forEach items="${productSecretKeys}" var="m">
					<div class="ui segment">
						<a href="home/productResultDisplay.html?productId=${m.productId}">您于${m.date}购买订单号为${m.uuid}, ${m.year}年面积为${m.area}产品类型为${m.inputForm},数据选项为${m.index}的产品</a>
					</div>
  				</c:forEach>
  		</c:if>
  		</div>
  	</div>
</body>
</html>