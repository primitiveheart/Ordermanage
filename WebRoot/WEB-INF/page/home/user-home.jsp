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
    
    <title>订单管理</title>
    <meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
   
    <!--script start-->
    <!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->
    <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
    <script src="https://openlayers.org/en/v4.5.0/build/ol.js"></script>
    <script type="text/javascript" src="resources/js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="resources/js/semantic.min.js"></script>

    <script type="text/javascript" src="resources/js/getMap.js"></script>
    <script type="text/javascript" src="resources/js/addInteraction.js"></script>
    <script type="text/javascript" src="resources/js/calcArea.js"></script>
    <script type="text/javascript" src="resources/js/displayOrder.js"></script>
    <script type="text/javascript" src="resources/js/getExtent.js"></script>
    <script type="text/javascript" src="resources/js/getIP.js"></script>
    
    <!--script end-->

    <!--style start-->
    <link rel="stylesheet" href="https://openlayers.org/en/v4.5.0/css/ol.css" type="text/css">
    <link rel="stylesheet" href="resources/css/semantic.min.css" type="text/css"/>
    <link rel="stylesheet" href="resources/three-part/jquery-zclip/jquery.zclip.css">
     <style type="text/css">
     		body > .ui.container{
     			margin-top:0em;
     		}
     </style>
    <!--style end--> 
  </head>
  
  <body>
	  	
	<!--把菜单包含进来  -->
	<%@include file="../commons/menu.jsp"%>
  		
  	<div class="ui container">
  		 <div class="main">
	    	<div id="order">
	    	
		        <h1>选择类型</h1>
		       	<div class="ui big header">选择年份</div>
		       	<select multiple="" name="year" id="year" class="ui year search fluid normal dropdown">
		       		<option value="">年份</option>
		       		<c:if test="${allyear != null}">
		       			<c:forEach items="${allyear}" var="y">
		       				<option value="${y}">${y }</option>
		       			</c:forEach>
		       		</c:if>
		       	</select>
		        <span>
		        	<input type="radio" name="regionRadio" value="1">
		        	<span  class="ui big header"> 自定义区域选择</span>
		      		<span class="regionRadio_1">
				        <div class="ui shapeSelection selection dropdown">
				        	<input type="hidden" name="shapeSelection"/>
				        	<i class="dropdown icon"></i>
					        <div class="default text">区域选择</div>
				        	<div class="menu">
				        		<div class="item" data-value="LineString">矩形</div>
				        		<div class="item" data-value="Circle">圆形</div>
				        		<div class="item" data-value="Polygon">多边形</div>
				        	</div>
				        </div>
		      		</span>
		      		
			        <input type="radio" name="regionRadio" value="2">
			        <span  class="ui big header"> 行政区域选择</span>
			        <span class="regionRadio_2">
				        <div class="ui province selection dropdown">
				        	<input type="hidden" name="province"/>
				        	<i class="dropdown icon"></i>
					        <div class="default text">省份选择</div>
				        	<div class="menu">
								<c:if test="${provinces != null}">
									<c:forEach items="${provinces}" var="p">
										<c:set var="p_" value="${fn:split(p,':')}"></c:set>
										<div class="item" data-value="${p_[1]}">${p_[0]}</div>
									</c:forEach>
								</c:if>			        	
				        	</div>
				        </div>
				        <span>-</span>
				        <div class="ui city selection dropdown">
				        	<input type="hidden" name="city"/>
				        	<i class="dropdown icon"></i>
					        <div class="default text">市选择</div>
				        	<div class="menu">
				        		<div class="item" data-value="all">所有</div>
				        	</div>
				        </div>
				        <span>-</span>
				        <div class="ui county selection dropdown">
				        	<input type="hidden" name="county"/>
				        	<i class="dropdown icon"></i>
					        <div class="default text">县选择</div>
				        	<div class="menu">
				        		<div class="item" data-value="all">所有</div>
				        	</div>
				        </div>
			        </span>
			        
		        </span>
		        
		        <div id="map"></div>
		        
		        <div class="ui big header">产品类型</div>
		        <div class="ui productType selection dropdown">
		        	<input type="hidden" name="productType"/>
		        	<i class="dropdown icon"></i>
		        	<div class="default text">产品类型</div>
		        	<div class="menu">
		        		<div class="item" data-value="data">矢量数据</div>
		        		<div class="item" data-value="special">专题图</div>
		        		<div class="item" data-value="sum">汇总值</div>
		        	</div>
		        </div>
		        
		       <div class="dataSelectionAddTitle">
		       		<div class="ui big header">数据选项</div>
			        <select multiple="" class="ui search fluid dataSelection normal dropdown">
			        	<c:if test="${requestScope.index != null}">
				        	<c:forEach items="${requestScope.index}" var = "s" varStatus="vs">
				        		<option type="checkbox" name="index" value="${s}">${s}</option>
					        </c:forEach>
		      		    </c:if>
			        </select>
		       </div>
		       
		        <button id="next" class="ui right labeled icon blue button">
		        	下一步
		        	<i class="right arrow icon"></i>
	        	</button>
		    </div>
		</div>

		<div id="display">
		    <label>年份:</label><label  for="year" id="dis_year" name="dis_yaer"></label><br>
		    <label>选取区域的工具：</label><label id="shape_type"></label><br>
		    <label>选择区域的面积(单位:km):</label><label id="area" name="area"></label><br/><br/>
		    <!--  
		    <lable><h2>统计</h2></label>
		    <label class="sum"></label>
		    -->
		    <button id="previous" class="ui left labeled icon blue button">
		        	上一步
		       <i class="left arrow icon"></i>
		    </button>
		    
		    <button id="createOrder" class="ui primary blue button">
		    	创建订单
		    </button>
		</div>
		
		<!--  
		<div class="ui large longer modal">
			<div class="header">
				专题图
			</div>
			<div class="scrolling image content">
				<div class="description"></div>
			</div>
			<div class="actions">
				<div class="ui positive right labeled icon button">返回</div>
			</div>
		</div>
		
		<div class="display_vector">
			<div class='ui left labeled icon blue button back_vector'>
				返回
				<i class="left arrow icon"></i>
			</div><br/>
			<div class="ui label">矢量数据</div>
			<div class="result_display_vector" style="height:90%;width:30%;overflow:scroll"></div>
		</div>
		-->
		
  	</div>
	
	<%@include file="../commons/footer.jsp" %>
	<script>
		
		 var draw_style = new ol.style.Style({
		        fill:new ol.style.Fill({
		            color:'rgba(255, 255, 255, 0.2)'
		        }),
		        stroke:new ol.style.Stroke({
		            color:"#ffcc33",
		            width:2
		        }),
		        image:new ol.style.Circle({
		            radius:7,
		            fill:new ol.style.Fill({
		                color:'#ffcc33'
		            })
		        })
		    })
	  	var bbox = []; //地图显示的范围
	    var viewParams = "";
	    var scope; //选择的范围
	    $(document).ready(function(){		
	    	var ipAddress = getRootPath();
	    	
	    	//隐藏菜单栏中搜索框
	    	$(".searchItem").hide();
	    	
	    	var map = getMap();
	    
	    	var source = new ol.source.Vector();
		    var vector = new ol.layer.Vector({
		        source:source
		    });
		
	    
	    	$("#display").hide();
	        $(".display_vector").hide();
	        $(".dataSelectionAddTitle").hide();
	        
	        //形状下拉框的值
	        var shapeText; //形状下拉框的值默认是矩形
			var sum_area ; //面积
			var selectionYear = [];//选择的年份
			var shape; //选择用的什么形状
			
			//年份
			$(".ui.year.dropdown").dropdown({
				maxSelections:5,
				onAdd:function(addedValue, addedText, $addedChoice){
					//添加数据选项
					selectionYear.push(addedValue);
				},
				onLabelRemove:function(value){
					//移除数据选项
					selectionYear.splice($.inArray(value,selectionYear), 1);
				}
			})
			
			//省份的代码
			var code_province;
			//省份的名称
			var text_province;
			
				//市的代码
			var code_city = "all";
			//是的名称
			var text_city;
			
			//县的编码
			var code_county  = "all";
			//县的名称
			var text_county;
			
			//行政区域图层
			var regionLayer;
			
			
			$("input[name=regionRadio]").on("click", function(){
				var regionRadio = $(this).val();
				if(regionRadio == 1){
					//清除行政区域的图层
					map.removeLayer(regionLayer);
					map.addLayer(vector);
					$(".regionRadio_1").show();
					$(".regionRadio_2").hide();
					//形状选择
					$(".ui.shapeSelection.dropdown").dropdown({
						onChange:function(value, text, $choice){
							 shapeText = text;
							 shape = value;
							 map.removeInteraction(draw);
							 addInteraction(value, vector, source, map);
						     draw.on('drawend',function(e){
				                var geometrty = e.feature.getGeometry();
				                sum_area = calcArea(value, geometrty)
				            },this);
						}
					});
				}else if(regionRadio == 2){
					map.removeLayer(vector);
					$(".regionRadio_2").show();
					$(".regionRadio_1").hide();
					//表示行政区域
					shape = "adminRegion";
					
					//行政区域的选择
					//省份
					$(".ui.province.dropdown").dropdown({
						onChange:function(value, text, $selectedItem){
							code_province = value;
							text_province = text; 
							//先清除city和county的下拉框中内容
							var inputCityValue = $(".ui.city.dropdown").dropdown('get value');
							var inputCountyValue = $(".ui.county.dropdown").dropdown('get value');
							if(inputCityValue != "all"){
								//$(".ui.city.dropdown").dropdown('clear');
								$(".ui.city.dropdown").dropdown('set selected',"所有");
							}
							if(inputCountyValue != "all"){
								//$(".ui.county.dropdown").dropdown('clear');
								$(".ui.county.dropdown").dropdown('set selected',"所有");
							}
							//获取该省下的所有市
							$.ajax({
								url:"home/acquireRegion.html",
								data:{
									type:"city",
									id:code_province
								},
								success:function(result){
									//先清除其他元素
									$(".ui.city.dropdown .menu div[data-value=all]").siblings().remove().end();
									if(result.city == "notExist"){
										//$(".ui.city.dropdown").dropdown("is visible", false);
										//$(".ui.county.dropdown").dropdown("is visible", false);
									}else{
										$.each(result.city, function(index, value){
											var temp = value.split(":");
											var $div = $("<div class='item' data-value='"+temp[1]+"'>"+temp[0]+"</div>");
											$div.appendTo($(".ui.city.dropdown .menu"));
										})
									}
								}
							});
							
							
							var viewparams = "r_id:"+value;
							if("all" == code_city &&  "all" == code_county){
								
								//设置行政区域的范围
								$.ajax({
									url:"home/getExtentByRegionId.html",
									data:{
										regionId:code_province
									},
									success:function(result){
										var temp = result.extent;
										var extent = getRegionExtent(temp);
										var view = new ol.View({
											center:ol.extent.getCenter(extent),
											zoom:8
										});
										map.setView(view);
									}
								});
									
								//获取面积
								$.ajax({
									url:"home/getAreaforRegion.html",
									data:{
										regionId:code_province
									},
									success:function(result){
										if(!$.isEmptyObject(result) && result.regionArea != "novalid" ){
											sum_area = result.regionArea;
										}
									}
								})
									
								regionLayer = new ol.layer.Tile({
									source:new ol.source.TileWMS({
										url:"http://"+ipAddress+":8080/map/census_china/wms",
										params:{
										'LAYERS': 'census_china:getRegionById', 
		    							'TILED': true,
		    							'projection':new ol.proj.Projection("EPSG:4326"),
		    							'displayProjection':new ol.proj.Projection("EPSG:3857"),
		    							'VIEWPARAMS':viewparams
		    							},
										serverType:"geoserver"
									})
								});
								
								//加入行政区域图
								map.addLayer(regionLayer);
							}
							//构建范围
							scope = text_province + ":" + code_province + ";" + text_city + ":" + code_city+ ";" + text_county + ":" + code_county;
						}
					});
					
					//市
					$(".ui.city.dropdown").dropdown('set selected',"所有").dropdown({
						onChange:function(value, text, $selectedItem){
							code_city = value;
							text_city = text;
							//清除县下拉框中的值
							var inputCountyValue = $(".ui.county.dropdown").dropdown('get value');
							if(inputCountyValue != "all"){
								//$(".ui.county.dropdown").dropdown('clear');
								$(".ui.county.dropdown").dropdown('set selected',"所有");
							}
							//获取该市下面的所有县
							$.ajax({
								url:"home/acquireRegion.html",
								data:{
									type:"county",
									id:code_city
								},
								success:function(result){
									//先清除其他元素
									$(".ui.county.dropdown .menu div[data-value=all]").siblings().remove().end();
									if(result.city == "notExist"){
										//$(".ui.county.dropdown").dropdown("is hidden", true);
									}else{
										$.each(result.city, function(index, value){
											var temp = value.split(":");
											var $div = $("<div class='item' data-value='"+temp[1]+"'>"+temp[0]+"</div>");
											$div.appendTo($(".ui.county.dropdown .menu"));
										})
									}
								}
							})
							
							var viewparams = "r_id:"+value;
							if("all" != code_city && "all" == code_county){
								//获取行政区域的范围
								$.ajax({
									url:"home/getExtentByRegionId.html",
									data:{
										regionId:code_city
									},
									success:function(result){
										if(!$.isEmptyObject(result) && result.extenxt != "novalid"){
											var temp = result.extent;
											var extent = getRegionExtent(temp);
											var view = new ol.View({
												center:ol.extent.getCenter(extent),
												zoom:10
											});
											map.setView(view);
										}
									}
								});
								
								//获取面积
								$.ajax({
									url:"home/getAreaforRegion.html",
									data:{
										regionId:code_city
									},
									success:function(result){
										if(!$.isEmptyObject(result) && result.regionArea != "novalid" ){
											sum_area = result.regionArea;
										}
									}
								})
								
								//移除图层
								map.removeLayer(regionLayer);
								regionLayer = new ol.layer.Tile({
										source:new ol.source.TileWMS({
											url:"http://"+ipAddress+":8080/map/census_china/wms",
											params:{
											'LAYERS': 'census_china:getRegionById', 
			    							'TILED': true,
			    							'projection':new ol.proj.Projection("EPSG:4326"),
			    							'displayProjection':new ol.proj.Projection("EPSG:3857"),
			    							'VIEWPARAMS':viewparams
			    							},
											serverType:"geoserver"
										})
								});
								//加入行政区域图
								map.addLayer(regionLayer);
								//构建范围
								scope = text_province + ":" + code_province + ";" + text_city + ":" + code_city + ";" + text_county + ":" + code_county;
							}
						}
					});
					
					//县
					$(".ui.county.dropdown").dropdown("set selected", "所有").dropdown({
						onChange:function(value, text, $selectedItem){
							code_county = value;
							text_county = text;
							var viewparams = "r_id:"+value;
							if("all" != code_city && "all" != code_county){
								//获取行政区域的范围
								$.ajax({
									url:"home/getExtentByRegionId.html",
									data:{
										regionId:code_county
									},
									success:function(result){
										if(!$.isEmptyObject(result) && result.extenxt != "novalid"){
											var temp = result.extent;
											var extent = getRegionExtent(temp);
											var view = new ol.View({
												center:ol.extent.getCenter(extent),
												zoom:10
											});
											map.setView(view);
										}
									}
								});
								
								//获取面积
								$.ajax({
									url:"home/getAreaforRegion.html",
									data:{
										regionId:code_county
									},
									success:function(result){
										if(!$.isEmptyObject(result) && result.regionArea != "novalid" ){
											sum_area = result.regionArea;
										}
									}
								})
								
							
								//移除图层
								map.removeLayer(regionLayer);
								regionLayer = new ol.layer.Tile({
										source:new ol.source.TileWMS({
											url:"http://"+ipAddress+":8080/map/census_china/wms",
											params:{
											'LAYERS': 'census_china:getRegionById', 
			    							'TILED': true,
			    							'projection':new ol.proj.Projection("EPSG:4326"),
			    							'displayProjection':new ol.proj.Projection("EPSG:3857"),
			    							'VIEWPARAMS':viewparams
			    							},
											serverType:"geoserver"
										})
								});
								//加入行政区域图
								map.addLayer(regionLayer);
								//构建范围
								scope = text_province + ":" + code_province + ";" + text_city + ":" + code_city + ";" + text_county + ":" + code_county;
							}
						}
					});
					
				}
			})
			
			
			
			//产品类型
			var productType ="special";
			//下拉框最多能选几个
			var maxSelections = 1;
			//数据选项
			var indexs = [];
			
			//产品类型
			$(".ui.productType.dropdown").dropdown({
				onChange:function(value, text, $choice){
					productType = value;
					
					//清空数据选项的下拉框
					$(".ui.dataSelection.dropdown").dropdown("clear");
					//清空数组
					indexs.splice(0,indexs.length);
					
					//当产品类型是专题图的话，只有一个选项
					if(value == "special"){
						maxSelections = 1;
						$(".dataSelectionAddTitle").show();
						//数据选项(index)
						$(".ui.dataSelection.dropdown").dropdown({
							maxSelections:maxSelections,
							onAdd:function(addedValue, addedText,  $addedChoice){
								indexs.push(addedValue);
							},
							onLabelRemove:function(value){
								indexs.splice($.inArray(value, indexs), 1);
							}
						})
					}else{
						maxSelections = 0;
						$(".dataSelectionAddTitle").show();
						//数据选项(index)
						$(".ui.dataSelection.dropdown").dropdown({
							maxSelections:maxSelections,
							onAdd:function(addedValue, addedText,  $addedChoice){
								indexs.push(addedValue);
							},
							onLabelRemove:function(value){
								indexs.splice($.inArray(value, indexs), 1);
							}
						})
					}
				}
			});
			
	
	        var result_special_layer = [];
	        //下一步
	        $("#next").on("click",function () {
	        	if(isEmpty(sum_area) || isEmpty(selectionYear) || isEmpty(shape) || isEmpty(productType) || isEmpty(indexs)){
	        		var $copysuc = $("<div class='copy-tips'><div class='copy-tips-wrap'>年份，区域选择，产品类型，数据选项其中有为空的，请您选择<br><div class='ui primary button ok'>确定</div></div></div>")
					$("body").find(".copy-tips").remove().end().append($copysuc);
					$(".ui.button.ok").on("click", function(){
						$(".copy-tips").fadeOut();
					})
	        	}else{
	        		$(".footer").hide();
	            	display_front(sum_area, indexs, selectionYear, shapeText);
	        	}
	        })    
	        
	        //上一步
	        $("#previous").on("click", function(){
	        	$("#order").show();
	        	$(".footer").show();
	        	$("#display").hide();
	        	//移除专题图中所有的结果
	        	for(var i=0; i < result_special_layer.length; i++){
	        		$("div.description").children().remove();
	        	}
	        	
	        	result_special_layer.splice(0,result_special_layer.length);
	        })
	        
	        //创建订单
	        $("#createOrder").on("click", function(){
	        	var year = selectionYear.join(",");
	        	var indexsString = indexs.join(",");
	        	
	        	var commitParam = {"year":year, "area":sum_area, "index":indexsString, "inputForm":productType,"scope":encodeURI(scope),"shape":shape};
	        	
	        	$.ajax({
	        		url:"home/isLogin.html",
	        		success:function(result){
	        			if(result.islogin){
	        				//已经登录	
	        				//提交订单
	        				$(location).attr("href","home/createOrder.html?"+$.param(commitParam));
	        			}else{
	        				//用户未登录，跳转到登录界面
	        				$(window).attr("location", "home/login.html?isLogin=false&"+$.param(commitParam));
	        			}
	        		}
	        	})
	        })
			/*
	        //专题图
	        $(".resultSpecial").on("click", function(){
        		$(".ui.modal").modal({
        			offset:600,
        			onApprove:function(){
        				$("#display").show();
        				return true;
        			}
        		}).modal('show');
	            result_special(value, indexs, result_special_layer);
	        })
	        
	        
	        //矢量数据
	        $(".resultVector").on("click",function(){
	        	for(var i=0; i<indexs.length; i++){
	        		$(".selection .menu").append("<div class='item' data-value='"+indexs[i]+"'>"+indexs[i]+"</div>");
	        	}
       			//选择之前把先前的移除掉
       			$(".display_vector .result_display_vector").text("");
	        	result_vector(value, indexs);
	        })
	        
	        //矢量数据返回
	         $(".back_vector").on("click", function(){
	        	$("#display").show();
	        	$(".display_vector").hide();
	        	//移除子元素
	        	$(".display_vector .result_display_vector").text("");
	        })
			*/
	    })
		
		function isEmpty(str){
			if(str != undefined && str != ""){
				return false;
			}
			return true;
		}
	
	</script>
	
  </body>
</html>
