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
    
    <title>城市统计数据</title>
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <link rel="stylesheet" href="https://openlayers.org/en/v4.5.0/css/ol.css" type="text/css">
      <!--script start-->
    <!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->
    <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
    <script src="https://openlayers.org/en/v4.5.0/build/ol.js"></script>
    <script type="text/javascript" src="resources/js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="resources/js/semantic.min.js"></script>
    <script type="text/javascript" src="resources/three-part/jquery-zclip/jquery.zclip.js"></script>
    <!--script end-->

    <!--style start-->
    <link rel="stylesheet" href="resources/css/semantic.min.css" type="text/css"/>
    <link rel="stylesheet" href="resources/three-part/jquery-zclip/jquery.zclip.css" type="text/css">
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
	
  	<div class="ui container">
  		<c:if test="">
  		
  		</c:if>
		<c:choose>
			<c:when test="${pageNum != null}">
				<a href="home/myOrder.html?pageNum=${pageNum}" class="ui left icon blue button">
					<i class="left arrow icon"></i>
					返回
				</a>
			</c:when>
			<c:otherwise>
				<a href="home/myOrder.html?pageNum=1" class="ui left icon blue button">
					<i class="left arrow icon"></i>
					返回
				</a>
			</c:otherwise>
		</c:choose>
		<div class="ui button copy" value="<%=basePath%>${link}">复制链接</div>
		<table class="ui celled table">
  				<thead>
  					<tr>
  						<c:if test="${head!=null}">
  							<c:forEach items="${head}" var="h">
  								<th>${h}</th>
  							</c:forEach>
  						</c:if>
  					</tr>
  				</thead>
  				<tbody>
  					<c:if test="${content != null}">
  						<c:set var="item" value="${fn:split(content, '(')}"></c:set>
  						<c:forEach items="${item}" var="i">
  							<tr>
  								<c:forEach items="${fn:split(i,',')}" var="j">
  									<td>${fn:replace(j,")","")}</td>
  								</c:forEach>
  							</tr>
  						</c:forEach>
  					</c:if>
  				</tbody>
  		</table>
  	</div>
  </body>
  <script type="text/javascript">
  	$(document).ready(function(){
  		$(".copy").zclip({
				path:"resources/three-part/jquery-zclip/ZeroClipboard.swf",
				copy:function(){
					return $(this).attr("value");
				},
				beforeCopy:function(){
					$(this).css("color", "organe");
				},
				afterCopy:function(){
					var $copysuc = $("<div class='copy-tips'><div class='copy-tips-wrap'>复制成功</div></div>");
					$("body").find(".copy-tips").remove().end().append($copysuc);
					$(".copy-tips").fadeOut(3000);
					
				}
			})
  	})
  </script>
</html>
