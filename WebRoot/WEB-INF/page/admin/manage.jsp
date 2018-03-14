<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
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
    
    <title>管理员主界面</title>
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
    <script type="text/javascript" src="resources/js/calendar.min.js"></script>
    <script type="text/javascript" src="resources/js/getRegionId.js"></script>
    <script type="text/javascript" src="resources/js/getExtent.js"></script>
    <script type="text/javascript" src="resources/js/bind-map.js"></script>
    <script type="text/javascript" src="resources/js/searchResultList.js"></script>
   	<script type="text/javascript" src="resources/js/getIP.js"></script>
    <!--script end-->
    
    <!--style start-->
    <link rel="stylesheet" href="resources/css/semantic.min.css" type="text/css"/>
    <link rel="stylesheet" href="resources/css/calendar.min.css" type="text/css">
    <style type="text/css">
    	body{
    		background-color: #FFFFFF;
    	}
    	.ui.menu .item img.logo{
    		margin-right:1.5em;
    	}
    	.main.container{
    		margin-top:5em;
    		font-family: 'Lato', 'Helvetica Neue', Arial, Helvetica, sans-serif;
    		max-width: 70% !important;
    		line-height:1.5;
    		font-size: 1.14285714rem;
    	}
    	.high{
			background-color:red
    	}
    	.item input{
    		width:35px;
    		height:30px
    	}
    </style>
    <!--style end--> 
  </head>
  <body>
  	<div class="ui fixed inverted menu">
  		<div class="ui container">
  			<a href="#" class="header item">
  				<img class="logo" src="resources/images/logo.jpg"/>
  				网格数据后台管理
  			</a>
  			<c:if test="${admin != null && admin.username != null}">
  				<a href="#" class="item">欢迎您：${admin.username}</a>
  				<a href="admin/logout.html" class="item">注销</a>
  			</c:if>
  		</div>
  	</div>
  	
	<div class="ui main container">
	
		<div class="ui large longer modal">
			<div class="header">
				显示范围
			</div>
			<div class="scrolling image content">
				<div class="description">
					<div class="map" id="map"></div>
				</div>
			</div>
			<div class="actions">
				<div class="ui positive right labeled icon button">返回</div>
			</div>
		</div>
		
		<div class="ui allOrder button">所有订单</div>
  		<div class="ui divider"></div>
		<div class="ui action input">
			<div class="ui singleOrderNum search selection dropdown">
				<input type="hidden" name="singleOrderNum"/>
				<i class="dropdown icon"></i>
				<div class="defautl text">请您输入订单号</div>
				<div class="menu"></div>
			</div>
			<div class="ui generalSearch button" type="submit">订单搜索</div>
			<div class="ui searchCondition button">
				精简筛选条件
				<i class="dropdown icon"></i>
			</div>
		</div>
		<div class="ui equal width form">
					<div class="inline field">
						<label>开始日期</label>
						<div class="ui calendar" id="startDate">
							<div class="ui input left icon">
								<i class="calendar icon"></i>
								<input type="text" placeholder="请您选择时间的起始" name="startDate">
							</div>
						</div>
					</div>
					<div class="inline field">
						<label>结束日期</label>
						<div class="ui calendar" id="endDate">
							<div class="ui input left icon">
								<i class="calendar icon"></i>
								<input type="text" placeholder="请您选择时间的结束" name="endDate"/>
							</div>
						</div>
					</div>
					<div class="field inline">
						<label>订单号</label>
						<div class="ui orderNum search selection dropdown">
							<input type="hidden" name="orderNum"/>
							<i class="dropdown icon"></i>
							<div class="defautl text">请您输入订单号</div>
							<div class="menu"></div>
						</div>
					</div>
					<div class="field inline">
						<label>用户名</label>
						<div class="ui usernames search selection dropdown">
							<input type="hidden" name="username">
							<i class="dropdown icon"></i>
							<div class="defualt text">请您输入用户名</div>
							<div class="menu">
							</div>
						</div>
					</div>
					<div class="field inline">
						<label>状态</label>
						<div class="ui state selection dropdown">
							<input type="hidden" name="state"/>
							<i class="angle down icon"></i>
							<div class="default text">请您选择状态</div>
							<div class="menu">
								<div class="item">审核中</div>
								<div class="item">审核通过</div>
							</div>
						</div>
					</div>
					<div class="ui red button" type="submit">
						搜索
					</div>
					
			</div>
		<table class="ui orderList celled table">
			<thead>
				<tr>
					<th>商品</th>
					<th>单价</th>
					<th>形状</th>
					<th>状态</th>
					<th>用户名</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${page!=null && page.list != null}">
					<c:forEach items="${page.list}" var="op" varStatus="status">
						<tr>
							<td colspan=6>
								<h3 class="ui header">日期:${fn:substring(op.date,0,19)}&nbsp;&nbsp;订单号:${op.uuid}</h3>
							</td>
						</tr>
						<c:if test="${op.products != null}">
								<c:forEach items="${op.products}" var="product">
									<tr>
										<td>
											<div class="ui item">
												<div class="content">
													<a class="header">产品的详细说明</a>
													<div class="description">
														<p>
															年份：${product.year}<br>
															面积(km^2)：${product.area}&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" class="checkScope" data-scope="${op.scope}" data-shape="${op.shape}">查看范围</a><br/>
															数据选项：${product.index}<br>
															产品类型：${product.inputForm}
														</p>
													</div>
												</div>
											</div>
											
										</td>
										<td>
											<p class="ui center aligned">${op.price}</p>
										</td>
										<td>
											<p class="ui center aligned">
												<c:if test="${op.shape == 'LineString'}">
													矩形
												</c:if>
												<c:if test="${op.shape == 'Polygon'}">
													多边形
												</c:if>
												<c:if test="${op.shape == 'Circle'}">
													圆形
												</c:if>
												<c:if test="${op.shape == 'adminRegion'}">
													行政区域(
														<c:if test="${op.scope != null}">
															<c:set var="scope1" value="${fn:split(op.scope,';')[0]}"></c:set>
															${fn:split(scope1,':')[0]}(${fn:split(scope1,':')[1]})
															<c:set var="scope2" value="${fn:split(op.scope,';')[1]}"></c:set>
															<c:if test="${fn:split(scope2,':')[0] != 'undefined'}">
																${fn:split(scope2,':')[0]}(${fn:split(scope2,':')[1]})
															</c:if>
															<c:set var="scope3" value="${fn:split(op.scope,';')[2]}"></c:set>
															<c:if test="${fn:split(scope3,':')[0] != 'undefined'}">
																${fn:split(scope3,':')[0]}(${fn:split(scope3,':')[1]})
															</c:if>
														</c:if>
													)
												</c:if>
											</p>
										</td>
										<td>
											<p class="ui center aligned">
												<c:if test="${product.state=='审核中'}">
													<span style="color:#F00">${product.state}</span>
												</c:if>
												<c:if test="${product.state=='审核通过'}">
													<span style="color:#00F">${product.state}</span>
												</c:if>
											</p>
										</td>
										<td>
											<p class="ui center aligned">${op.username}</p>
										</td>
										<td>
											<div class="ui primary check button" data-uuid="${op.uuid}" data-id="${product.id}"
											 data-user="${op.username}" data-state="${product.state }">审核</div>
											 <div class="ui black withdraw button" data-uuid="${op.uuid}" data-id="${product.id}"
											 data-user="${op.username}" data-state="${product.state }">撤销</div>
										</td>
									</tr>
								</c:forEach>
							</c:if>
					</c:forEach>
				</c:if>
			</tbody>
			<tfoot>
				<tr>
					<th colspan="6">
						<%@include file="./pagination.jsp" %>
					</th>
				</tr>
			</tfoot>
		</table> 
		<table class="ui searchResultList celled table">
			<thead>
				<tr>
					<th>商品</th>
					<th>单价</th>
					<th>形状</th>
					<th>状态</th>
					<th>用户名</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody></tbody>
			<tfoot>
				<tr>
					<th colspan="6">
					</th>
				</tr>
			</tfoot>
		</table>
	</div>
	<%@include file="../commons/footer.jsp" %>
  </body>
  	<script type="text/javascript">
  	
  		$(document).ready(function(){
  			//没有起作用
  			$(".current.item").on("click", function(){
  				$(this).addClass("high");
  				$(this).siblings().removeClass("high");
  			})
  			
  			//订单表格的显示与隐藏
  			$(".searchResultList").hide();
  			
  			//表单的显示与隐藏
  			$(".ui.form").hide();
  			$(".searchCondition").on("click", function(){
	  			$(".ui.form").toggle();
	  			$(".ui.singleOrderNum.search.selection.dropdown").dropdown('clear');
  			})
  			//单个订单搜索
  			//得到所得的订单号
  			$(".ui.singleOrderNum.search.selection.dropdown").dropdown({
  				onChange:function(value, text, $selectedItem){
  					$(".ui.generalSearch.button").on("click",function(){
  						//清空表单的内容
  						$(':input','.ui.form') 
						.not(':button, :submit, :reset, :hidden') 
						.val('') 
						.removeAttr('checked') 
						.removeAttr('selected');
						$(".ui.state.selection.dropdown").dropdown('clear');
  						$(".ui.orderNum.search.selection.dropdown").dropdown('clear');
  						$(".ui.usernames.search.selection.dropdown").dropdown('clear');
  						
  						//隐藏表单
  						$(".ui.form").hide();
  						
		  				$.ajax({
				  				url:"admin/submitSearchForm.html",
				  				data:{
				  					orderNum:value,
				  					pageNum:1
				  				},
				  				success:function(result){
				  					searchResultList(result);
				  				}
				  		})
		  			})
  				}
  			});
  			$.ajax({
  				url:"admin/acquireAllOrderUUID.html",
  				success:function(result){
  					$(".ui.singleOrderNum.search.selection.dropdown .menu").children().remove().end();
  					if(result.orderUUIDs == "nodata"){
  						$("<div>no result</div>").appendTo($(".ui.singleOrderNum.search.selection.dropdown .menu"));
  					}else{
  						for(var i=0; i<result.orderUUIDs.length; i++){
  							$("<div class='item'>"+result.orderUUIDs[i]+"</div>").appendTo($(".ui.singleOrderNum.search.selection.dropdown .menu"));
  						}
  					}
  				}
  			})
  			
  			//提交表单
  			$(".ui.red.button").on("click", function(){
  				var formData = $(".ui.form input").serialize();
  				formData += "&pageNum=1";
  				$.ajax({
		  				url:"admin/submitSearchForm.html",
		  				data:formData,
		  				success:function(result){
		  					searchResultList(result);
		  				}
		  			})
  			})
  			$(".ui.form").form({
  				onSuccess:function(e){
  					//阻止提交表单
  					e.preventDefault();
  					console.log(e);
  				}
  			})
  			
  			//订单搜索ui state selection dropdown
  			var today = new Date();
  			//开始日期
  			$("#startDate").calendar({
  				ampm:false,
  				endCalendar:$("#endDate"),
  				maxDate: new Date(today.getFullYear(),today.getMonth(),today.getDate()+1),
  				formatter:{
  					date:function(date, settings){
  						if(!date) return '';
  						var year = date.getFullYear();
  						var month = date.getMonth() + 1;
  						var day = date.getDate();
  						month = month < 10 ? '0'+month:month;
  						day = day < 10 ? '0'+day:day;
  						return year + '-' + month + '-' + day;
  					}
  				}
  			})
  			//结束日期
  			$("#endDate").calendar({
  				ampm:false,
  				startCalendar:$("#startDate"),
  				maxDate: new Date(today.getFullYear(),today.getMonth(),today.getDate()+1),
  				formatter:{
  					date:function(date, settings){
  						if(!date) return '';
  						var year = date.getFullYear();
  						var month = date.getMonth() + 1;
  						var day = date.getDate();
  						month = month < 10 ? '0'+month:month;
  						day = day < 10 ? '0'+day:day;
  						return year + '-' + month + '-' + day;
  					}
  				}
  			})
  			
  			//状态的下拉框
  			$(".ui.state.selection.dropdown").dropdown();
  			
  			$(".ui.orderNum.search.selection.dropdown").dropdown();
  			
  			$(".ui.usernames.search.selection.dropdown").dropdown();
  			
  			//得到所得的订单号
  			$.ajax({
  				url:"admin/acquireAllOrderUUID.html",
  				success:function(result){
  					$(".ui.orderNum.search.selection.dropdown .menu").children().remove().end();
  					if(result.orderUUIDs == "nodata"){
  						$("<div>no result</div>").appendTo($(".ui.orderNum.search.selection.dropdown .menu"));
  					}else{
  						for(var i=0; i<result.orderUUIDs.length; i++){
  							$("<div class='item'>"+result.orderUUIDs[i]+"</div>").appendTo($(".ui.orderNum.search.selection.dropdown .menu"));
  						}
  					}
  				}
  			})
  			//得到所有的用户名
  			$.ajax({
  				url:"admin/acquireAllUsername.html",
  				success:function(result){
  					//清除内容
  					$(".ui.usernames.search.selection.dropdown .menu").children().remove().end();
  					if(result.usernames == "nodata"){
  						$("<div>no result</div>").appendTo($(".ui.usernames.search.selection.dropdown .menu"));
  					}else{
  						for(var i=0; i<result.usernames.length; i++){
  							$("<div class='item'>"+result.usernames[i]+"</div>").appendTo($(".ui.usernames.search.selection.dropdown .menu"));
  						}
  					}
  				}
  			})
  			
  			$(".checkScope").on("click", function(){
  				$(".ui.modal").modal({
	       			offset:600,
	       			onApprove:function(){
	       				//清除内容
	       				$(".ui.modal .description .map").children().remove();
	       				return true;
	       			}
	       		}).modal('show');
	       		
     			var shape = $(this).attr("data-shape");
				var scope = $(this).attr("data-scope");
				//var shape = "lon:116.39644736030637;lat:39.9737369685711;radius:20.1904109411072"
				//var scope="Cicle"
				bindMap(shape, scope);
	  		})
	  		
  			
  			
  			//所有订单的按钮
  			$(".allOrder").on("click", function(){
  				$(location).attr("href","admin/manage.html?pageNum=1");
  			})
  			
  			//审核通过
  			$(".ui.check.button").on("click",function(){
  				var uuid = $(this).attr("data-uuid");
  				var id = $(this).attr("data-id");
  				var username = $(this).attr("data-user");
  				var state = $(this).attr("data-state");
  				var pageNum = ${page.pageNum};
  				$.ajax({
  					url:"admin/acquireSecretKey.html",
  					type:"POST",
  					data:{
  						order_uuid:uuid,
  						product_id:id,
  						username:username,
  						state:state
  					},
  					success:function(result){
  						//重新刷新页面
  						$(location).attr("href","admin/manage.html?pageNum=" + pageNum);
  					}
  				})
  			})
  			
  			//撤销审核
  			$(".ui.withdraw.button").on("click", function(){
  				var uuid = $(this).attr("data-uuid");
  				var id = $(this).attr("data-id");
  				var username = $(this).attr("data-user");
  				var state = $(this).attr("data-state");
  				var pageNum = ${page.pageNum};
  				$.ajax({
  					url:"admin/acquireSecretKey.html",
  					type:"POST",
  					data:{
  						order_uuid:uuid,
  						product_id:id,
  						username:username,
  						state:state
  					},
  					success:function(result){
  						//重新刷新页面
  						$(location).attr("href","admin/manage.html?pageNum=" + pageNum);
  					}
  				})
  			})
  			
  		})
  		
  	</script>
</html>
