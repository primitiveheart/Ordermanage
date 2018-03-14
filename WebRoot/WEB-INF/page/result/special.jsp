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
    
    <title>专题图</title>
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

    <script type="text/javascript" src="resources/js/getRegionId.js"></script>
    <script type="text/javascript" src="resources/js/getExtent.js"></script>
    <script type="text/javascript" src="resources/js/getIP.js"></script>
    <!--script end-->

    <!--style start-->
    <link rel="stylesheet" href="resources/css/semantic.min.css" type="text/css"/>
    <link rel="stylesheet" href="resources/three-part/jquery-zclip/jquery.zclip.css">
    <!--
     <link rel="stylesheet" href="resources/css/base.css" type="text/css"/>
       -->
      <style type="text/css">
      		body > .ui.container{
      			margin-top:3em;
      		}
      </style>
    <!--style end--> 
  </head>
  
  <body>
	  	
  	<div class="ui container">
  		<input type="hidden" data-pageNum="${pageNum}" id="pageNum"/>
		<input type="hidden" data-shape="${shape}" id="shape"/>
  		<input type="hidden" data-viewparams="${VIEWPARAMS}" id="viewParam"/>
  		<input type="hidden" data-env="${env}" id="env"> 
		<div class="ui large longer modal">
			<div class="header">
				专题图 <div class="ui button copy">复制链接</div> <a class="sum" href="">汇总值链接</a>
			</div>
			
			<div class="scrolling content">
				<div class="ui header">专题图</div>
				<div class="ui image" id="image">
				</div>
				<div class="ui header">图例</div>
				<div class="ui image">
					<img alt="" src="home/productPicture.html?range=${env}">
				</div>
				<div class="ui header">汇总值</div>
				<div class="description" id="description">
					<p class="sumDescription"></p>
				</div>
			</div>
			<div class="actions">
				<div class="ui positive right labeled icon button">返回</div>
			</div>
		</div>
		
  	</div>
	
	<script>
		
	    $(document).ready(function(){
	    
	    	var ipAddress = getRootPath();
	    	
	    	//专题图
       		$(".ui.modal").modal({
       			offset:600,
       			onApprove:function(){
       				var pageNum = $("#pageNum").attr("data-pageNum");
       				if(pageNum == null || pageNum == ""){
       					pageNum = 1 ;
       				}
       				
       				$(location).attr("href","home/myOrder.html?pageNum="+pageNum);
       			}
       		}).modal('show');
       			
	    	var shape = $("#shape").attr("data-shape");
	    	var viewParams_vector = $("#viewParam").attr("data-viewparams");	
			var layers = "";
			var env = $("#env").attr("data-env");
			var scope = "${scope}";
			
			//var extent = [71.0, 16.0, 136.0, 55.0];
			var extent = [];
			
	
			if(shape == "Circle") {
				layers = "census_china:getCensusByRadius";
			} else if(shape == "Polygon") {
				layers = "census_china:getCensusbyPoly"
			} else if(shape == "LineString"){
				layers = "census_china:getCensusbyRectangle";
			}else{
				layers = "census_china:getCensusbyRegionId";
			}
			
			//汇总值
			var sumHref = "http://" + ipAddress+ ":8080/map/census_china/ows?service=WFS&version=1.0.0&request=GetFeature&typeName="+layers+"&outputFormat=gml3";
			var sumHrefViewParams = viewParams_vector;
			sumHrefViewParams = sumHrefViewParams.replace(/\\,/g,"@");
			sumHref += "&VIEWPARAMS=" + sumHrefViewParams;
			$(".sum").attr("href",sumHref);
			
			$.ajax({  
		      url: "http://" + ipAddress + ":8080/map/census_china/ows?service=WFS&version=1.0.0&request=GetFeature&typeName="+layers+"&maxFeatures=50&outputFormat=gml3",  
		      type: 'post', 
		      data: {  
		          VIEWPARAMS:viewParams_vector
		      },  
		      success:function(result){  
		    	  var val = $($(result).children().children().children().children()[1]).text()
		    	  $(".sumDescription").text(val);
		      },  
		      error: function(){  
		        alert("执行失败");    
		      }  
  			});  
  			
  		
			
			//专题图
		
			var completeLink;
			if(shape == "adminRegion"){
	    		//var productId = ${productId};
	    		var regionId = getRegionId(scope);
	    		viewParams_vector = viewParams_vector.split(";fld")[1];
	    		viewParams_vector = "r_id:" + regionId + ";fld" + viewParams_vector;
	    		//设置行政区域的范围
				$.ajax({
					url:"home/getExtentByRegionId.html",
					data:{
						regionId:regionId
					},
					success:function(result){
						var temp = result.extent;
						temp = temp.split(",");
						for(var i = 0; i <temp.length; i++){
							extent.push(parseFloat(temp[i]));
						}
						
						var middle_layer = new ol.layer.Tile({
							//extent: extent,
							source: new ol.source.TileWMS({
								url: "http://" + ipAddress+":8080/map/census_china/wms",
								params: {
									'LAYERS': layers,
									'VERSION': '1.1.1',
									'TRANSPARENCY': true,
									'VIEWPARAMS': viewParams_vector,
									'env':env,
									'TILED': true,
									'BBOX':extent
								},
								serverType: 'geoserver'
							})
						})
						
						//投影
						var projection = ol.proj.get("EPSG:4326");
						//var projection = ol.proj.get("EPSG:3857");
						
						var map = new ol.Map({
							extent: extent,
							layers: [middle_layer],
							target: image,
							view: new ol.View({
								center: ol.extent.getCenter(extent),
								projection: projection,
								zoom: 10
							}),
						})
						
						completeLink = "http://"+ipAddress+":8080/map/census_china/wms?service=wms&REQUEST=GetMap&width=768&height=460&srs=EPSG:4326&LAYERS="+layers+"&VERSION=1.1.1&TRANSPARENCY=true&VIEWPARAMS="+viewParams_vector+"&TILED=true&format=image/png&bbox=" + extent + "&env=" + env;
						$(".copy").val(completeLink);
					}
				});
	    	}else{
	    		extent = getSelectShapeExtent(scope, shape);
	    		var middle_layer = new ol.layer.Tile({
					//extent: extent,
					source: new ol.source.TileWMS({
						url: "http://" + ipAddress +":8080/map/census_china/wms",
						params: {
							'LAYERS': layers,
							'VERSION': '1.1.1',
							'TRANSPARENCY': true,
							'VIEWPARAMS': viewParams_vector,
							'env':env,
							'TILED': true,
							'BBOX':extent
						},
						serverType: 'geoserver'
					})
				})
				
				//投影
				var projection = ol.proj.get("EPSG:4326");
				//var projection = ol.proj.get("EPSG:3857");
				
				var map = new ol.Map({
					extent: extent,
					layers: [middle_layer],
					target: image,
					view: new ol.View({
						center: ol.extent.getCenter(extent),
						projection: projection,
						zoom: 9
					}),
				})
				/*
				if(shape == "Circle"){
					extent = [71.0,16.0,136.0,55.0]
				}*/
				completeLink = "http://" +ipAddress +":8080/map/census_china/wms?service=wms&REQUEST=GetMap&width=768&height=460&srs=EPSG:4326&LAYERS="+layers+"&VERSION=1.1.1&TRANSPARENCY=true&VIEWPARAMS="+viewParams_vector+"&TILED=true&format=image/png&bbox=" + extent + "&env=" + env;;
				$(".copy").val(completeLink);
	    	}
	    	
			
			$(".copy").zclip({
				path:"resources/three-part/jquery-zclip/ZeroClipboard.swf",
				copy: function(){
					return $(this).val();
				},
				beforeCopy:function(){//按住鼠标时的操作
					$(this).css("color","organe");
				},
				afterCopy:function(){//复制成功的操作
					alert("复制成功");
					var $copysuc = $("<div class='copy-tips'><div class='copy-tips-wrap'>复制成功</div></div>")
					$("body").find(".copy-tips").remove().end().append($copysuc);
					$(".copy-tips").fadeOut(3000);
				}
			})
			
	    })
	
	</script>
	
  </body>
</html>
