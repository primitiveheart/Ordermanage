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
    
    <title>汇总值</title>
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
    <script type="text/javascript" src="resources/js/getIP.js"></script>
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
  		<input type="hidden" data-pageNum="${pageNum}" id="pageNum"/>
  		<input type="hidden" data-shape="${shape}" id="shape"/>
  		<input type="hidden" data-viewparams="${VIEWPARAMS}" id="viewParam"/>
  		<div class="ui blue button back left icon">
  			<i class="left arrow icon"></i>
  			返回
  		</div>
		<div class="ui copy button">复制链接</div>
		<div class="ui header">汇总值</div>
		<div class="result_display_sum"></div>
  	</div>
	
	<script>
	    $(document).ready(function(){
	    	var ipAddress = getRootPath();
	    
	    	$(".ui.button.back").on("click", function(){
	    		var pageNum = $("#pageNum").attr("data-pageNum");
   				if(pageNum == null || pageNum == ""){
   					pageNum = 1 ;
   				}
	    		$(location).attr("href", "home/myOrder.html?pageNum="+pageNum);
	    	})
	    	var copyLink;
	    	var scope = "${scope}";
	    	var shape = $("#shape").attr("data-shape");
	    	var viewParams_vector = $("#viewParam").attr("data-viewparams");
	    	var typeName;	
	        if(shape == "Circle") {
				typeName = "census_china:getCensusbyRadius_features";
			} else if(shape == "Polygon") {
				typeName = "census_china:getCensusbyPoly_features"
			} else if(shape == "LineString"){
				typeName = "census_china:getCensusbyRectangle_features";
			}else {
				typeName = "census_china:getCensusbyRegionId_features"
			}
	    	if(shape=="adminRegion"){
	    		//var productId = ${productId};
	    		var regionId = getRegionId(scope);
	    		viewParams_vector = viewParams_vector.split(";fld")[1];
	    		viewParams_vector = "r_id:" + regionId + ";fld" + viewParams_vector;
	    	}
	    		
			$.ajax({  
		      url: "http://" + ipAddress + ":8080/map/census_china/ows?service=WFS&version=1.0.0&request=GetFeature&typeName="+typeName+"&maxFeatures=50&outputFormat=gml3",  
		      type: 'post', 
		      data: {  
		          VIEWPARAMS:viewParams_vector
		      },  
		      success:function(result){  
		    	  var serializer = new XMLSerializer;
		    	  var serialized = serializer.serializeToString(result);
		    	  $(".result_display_sum").text(serialized);
		      },  
		      error: function(){  
		        alert("执行失败");    
		      }  
  			});  
	  
	  
  			var completeLink = "http://" + ipAddress+ ":8080/map/census_china/ows?service=WFS&version=1.0.0&request=GetFeature&typeName="+typeName+"&outputFormat=gml3";
			var copyViewParams = viewParams_vector;
			copyViewParams = copyViewParams.replace(/\\,/g,"@");
			completeLink += "&VIEWPARAMS=" + copyViewParams;
			copyLink = completeLink;
	    	
	    	//复制链接
			$(".copy").val(copyLink);
			$(".copy").zclip({
				path:"resources/three-part/jquery-zclip/ZeroClipboard.swf",
				copy:function(){
					return $(this).val();
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
	
  </body>
</html>
