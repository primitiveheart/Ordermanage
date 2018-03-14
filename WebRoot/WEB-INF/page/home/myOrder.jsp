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
    
    <title>我的订单</title>
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
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <!--script end-->

    <!--style start-->
    <link rel="stylesheet" href="resources/css/semantic.min.css" type="text/css"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css" type="text/css">
     <style type="text/css">
     		body > .ui.container{
     			margin-top:3em;
     		}
     		.item #goto{
	    		width:35px;
	    		height:30px
	    	}
     </style>
    <!--style end--> 
  </head>
  
  <body>
	  	
	<!--把菜单包含进来  -->
	<%@include file="../commons/menu.jsp"%>
  	
  	<div class="ui container">
  		<div class="ui allOrder button">所有订单</div>
  		<div class="ui divider"></div>
  		<table class="ui celled orderlist table">
  			<thead>
				<tr>
					<th>商品</th>
					<th>单价</th>
					<th>形状</th>
					<th>状态</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${page != null && page.list != null}">
					<c:forEach items="${page.list}" var="op" varStatus="status">
						<tr>
							<td colspan=4>
								<h3 class="ui header">日期:${fn:substring(op.date,0,19)}&nbsp;&nbsp;订单号:${op.uuid}</h3>
							</td>
							<td>
								<div class="ui red button delOrder" data-uuid=${op.uuid}>删除</div>
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
															面积(km^2)：${product.area}<br>
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
												${product.state}<br>
												<c:if test="${product.state == '审核通过'}">
													<c:choose>
														<c:when test="${product.inputForm == '专题图'}">
															<a href="home/productResultDisplay.html?productId=${product.id}&pageNum=${page.pageNum}" data-content="想要复制链接，请您点击进去" class="dialog">查看</a><br/>
														</c:when>
														<c:otherwise>
															<a href="home/productResultDisplay.html?productId=${product.id}&pageNum=${page.pageNum}" data-content="想要复制链接，请您点击进去" class="dialog">
																<c:choose>
																	<c:when test="${product.inputForm == '矢量数据'}">
																		查看前50条记录
																	</c:when>
																	<c:otherwise>
																		查看汇总结果
																	</c:otherwise>
																</c:choose>
															</a><br/>
														</c:otherwise>
													</c:choose>
													<a href="javascript:void(0)" class="showCityInfo" data-proudctId="${product.id}" data-shape="${op.shape}" >查看城市总体信息</a>
												</c:if>
											</p>
										</td>
										<td>
											<div class="ui primary delete button" data-proudctId="${product.id}">删除</div>
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
						<div class="ui right floated pagination menu">
							<div class="item">共${page.totalPage}</div>
							<div class="item">当前第${page.pageNum}页</div>
							<a class="item" href="home/myOrder.html?pageNum=1">首页</a>
							<%--如果当前页是第一页，就没有上一页的链接 --%>
							<c:if test="${page.pageNum == 1}">
								<c:forEach begin="${page.startPage}" end="${page.endPage}" step="1" var="i">
									<c:if test="${page.pageNum == i}">
										<span class="item">${i}</span>
									</c:if>
									<c:if test="${page.pageNum != i}">
										<a class="item" href="home/myOrder.html?pageNum=${i}">${i}</a>
									</c:if>
								</c:forEach>
								<a class="item" href="home/myOrder.html?pageNum=${pageNum+1}">
									<i class="right chevron icon"></i>
								</a>
							</c:if>
							
							<%--如果当前页不是第一页也不是最后一页 --%>
							<c:if test="${page.pageNum > 1 && page.pageNum < page.totalPage}">
								<a class="item" href="home/myOrder.html?pageNum=${page.pageNum - 1}">
									<i class="left chevron icon"></i>
								</a>
								<c:forEach begin="${page.startPage}" end="${page.endPage}" step="1" var="i">
									<c:if test="${page.pageNum == i}">
										<span class="item">${i}</span>
									</c:if>
									<c:if test="${page.pageNum != i}">
										<a class="item" href="home/myOrder.html?pageNum=${i}">${i}</a>
									</c:if>
								</c:forEach>
								<a class="item" href="home/myOrder.html?pageNum=${pageNum+1}">
									<i class="right chevron icon"></i>
								</a>
							</c:if>
							
							<%--如果当前页是最后一页 --%>
							<c:if test="${page.pageNum == page.totalPage}">
								<a class="item" href="home/myOrder.html?pageNum=${page.pageNum-1}">
									<i class="left chevron icon"></i>
								</a>
								<c:forEach begin="${page.startPage}" end="${page.endPage}" step="1" var="i">
									<c:if test="${page.pageNum == i}">
										<span class="item">${i}</span>
									</c:if>
									<c:if test="${page.pageNum != i}">
										<a class="item" href="home/myOrder.html?pageNum=${i}">${i}</a>
									</c:if>
								</c:forEach>
							</c:if>
							
						   	<a class="item" href="home/myOrder.html?pageNum=${page.totalPage}">尾页</a>
						   	<div class="item">
						   		<button class="ui primary button" id="go">跳转</button>
						   	</div>
						   	<div class="item">
								<input type="text" id="goto" placeholder="页面"/>
							</div>
						</div>
					</th>
				</tr>
			</tfoot>
  		</table>
  		
  		
  		<div class="ui modal">
  			<div class="header">删除产品</div>
  			<div class="content">
  				<p class="center">是否删除产品?</p>
  			</div>
  			<div class="actions">
  				<div class="ui green cancel button">取消</div>
  				<div class="ui primary approve button">确定</div>
  			</div>
  		</div>
  		
  		<div class="ui modal deleteOrder">
  			<div class="header">删除订单</div>
  			<div class="content">
  				<p class="center">是否删除订单?</p>
  			</div>
  			<div class="actions">
  				<div class="ui green cancel button">取消</div>
  				<div class="ui primary approve button">确定</div>
  			</div>
  		</div>
  	</div>
</body>
	<script type="text/javascript">
		//显示菜单栏中搜索框
  		$(".searchItem").show();
		
		//搜索菜单按钮
	
		$(".ui.action.left.input").keypress(function(e){
			var code = e.keyCode ? e.keyCode : e.which ? e.which : e.charCode;
			if(code == 13){//响应enter键
				var searchVal = $(".ui.action.input").children("input").val();
				if("多边形".indexOf(searchVal) >= 0){
					searchVal = "Polygon";
				}
				if("圆形".indexOf(searchVal) >= 0){
					searchVal = "Circle";
				}
				if("矩形".indexOf(searchVal) >= 0){
					searchVal = "LineString";
				}
				
				if("矢量数据".indexOf(searchVal) >= 0){
					searchVal = "data";
				}
				if("专题图".indexOf(searchVal) >= 0){
					searchVal = "special";			
				}
				if("汇总值".indexOf(searchVal) >= 0){
					searchVal = "sum";
				}
				$(location).attr("href", "home/searchOrder.html?searchVal=" + searchVal);
			}
			
		})
	
		//所有订单
		$(".ui.allOrder.button").on("click", function(){
			$(location).attr("href", "home/myOrder.html?pageNum=1");
		})
	
		//显示城市总体信息
		$(".showCityInfo").on("click", function(){
			var productId = $(this).attr("data-proudctId");
			var shape = $(this).attr("data-shape");
			$(location).attr("href","home/showCityStatistics.html?productId="+productId + "&shape=" +shape);
		})
		
		//显示对话框的位置
		$(".dialog").popup({
			position:"top center"
		});
		$(".showCityInfo").popup({
			content:"想要复制链接，请您点击进去",
			position:"bottom center"
		})
		
		//删除订单
		$(".ui.button.delOrder").on("click", function(){
			var uuid = $(this).attr("data-uuid");
			$(".ui.modal.deleteOrder").modal({
				onDeny:function(){
					$(location).attr("href", "home/myOrder.html?pageNum=" + ${page.pageNum});
				},
				onApprove:function(){
					$(location).attr("href","home/deleteOrder.html?uuid="+uuid + "&pageNum=" + ${page.pageNum});
				}
			}).modal("show");
		})
		
		//删除产品
		$(".ui.delete.button").on("click", function(){
			var productId = $(this).attr("data-proudctId");
			$(".ui.modal").modal({
				onDeny:function(){
					$(location).attr("href", "home/myOrder.html?pageNum=" + ${page.pageNum});
				},
				onApprove:function(){
					$(location).attr("href","home/deleteProduct.html?productId=" + productId + "&pageNum=" + ${page.pageNum});
				}
			}).modal("show");
		})
		
		//跳转
		$("#go").on("click", function(){
			var maxPage = ${page.totalPage};
			var pages = $("#goto").val();
			if(pages == null || pages == "" ){	
				alert("页面不能为空");
				return;
			}
			if(!pages.match("\\d+")){
				alert("页面只能是数字");
				return;
			}
			if(pages<1 || pages> maxPage){
				alert("没有当前页码");
				return;
			}
			
			$(window).attr("location","home/myOrder.html?pageNum="+pages + "&pageSize=2");
		})
	</script>
</html>