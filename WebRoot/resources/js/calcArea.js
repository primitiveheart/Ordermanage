/*
 * 计算面积，拼接viewparams，scope
 */
function calcArea(shapeType, geometry){
	var tArea;
	if(shapeType == "LineString"){
		var coord = geometry.getCoordinates();
		var startX = coord[0][0][0];
		var startY = coord[0][0][1];
		var endX = coord[0][2][0];
		var endY = coord[0][2][1];
		
		//地图显示范围
		var min_x = ol.proj.transform(coord[0][0], 'EPSG:3857' ,'EPSG:4326')[0];
		var min_y = ol.proj.transform(coord[0][0], 'EPSG:3857' ,'EPSG:4326')[1];
		var max_x = ol.proj.transform(coord[0][2], "EPSG:3857" ,"EPSG:4326")[0];
		var max_y = ol.proj.transform(coord[0][2], "EPSG:3857" ,"EPSG:4326")[1];
		if(max_x < min_x){
			var temp = min_x;
			min_x = max_x;
			max_x = temp;
		}
		
		if(max_y < min_y){
			var temp = min_y;
			min_y = max_y;
			max_y = temp;
		}
		
		bbox.push(min_x);
		bbox.push(min_y);
		bbox.push(max_x);
		bbox.push(max_y);
		//视图参数
		viewParams = "min_lon:" + min_x + ";min_lat:" + min_y + ";max_lon:" + max_x + ";max_lat:" + max_y;
		scope = viewParams;
		
		var dx = Math.abs(endX - startX)/1000;
		var dy = Math.abs(endY - startY)/1000;
		tArea = Math.round(dx * dy);
	}else if(shapeType == "Circle"){
		var radius = geometry.getRadius();
		var center = geometry.getCenter();
		var min_coord = [center[0] - radius, center[1] - radius];
		var max_coord = [center[0] + radius, center[1] + radius];
		var center_lonlat = ol.proj.transform(center, "EPSG:3857", "EPSG:4326");
		
		//地图显示范围
		bbox.push(ol.proj.transform(min_coord, 'EPSG:3857', "EPSG:4326")[0]);
		bbox.push(ol.proj.transform(min_coord, 'EPSG:3857', "EPSG:4326")[1]);
		bbox.push(ol.proj.transform(max_coord, 'EPSG:3857', 'EPSG:4326')[0]);
		bbox.push(ol.proj.transform(max_coord, 'EPSG:3857', 'EPSG:4326')[1]);
		
		//视图参数
		viewParams = "lon:" + center_lonlat[0] + ";lat:" + center_lonlat[1] + ";radius:" + radius/1000;
		scope = viewParams;
		
		tArea = Math.round(Math.PI * Math.pow(radius/1000,2));
	}else{
		var coord = geometry.getCoordinates();
		var len = coord[0].length;
		var min_x = coord[0][0][0];
		var min_y = coord[0][0][1];
		var max_x = coord[0][0][0];
		var max_y = coord[0][0][1];
		
		for(var i = 1; i < len; i++){
			min_x = coord[0][i][0] > min_x ? min_x : coord[0][i][0];
			min_y = coord[0][i][1] > min_y ? min_y : coord[0][i][1];
			max_x = coord[0][i][0] > max_x ? coord[0][i][0] : max_x;
			max_y = coord[0][i][1] > max_y ? coord[0][i][1] : max_y;
		}
		
		//地图显示范围
		bbox.push(ol.proj.transform([min_x, min_y], 'EPSG:3857', "EPSG:4326")[0]);
		bbox.push(ol.proj.transform([min_x, min_y], 'EPSG:3857', "EPSG:4326")[1]);
		bbox.push(ol.proj.transform([max_x, max_y], 'EPSG:3857', "EPSG:4326")[0]);
		bbox.push(ol.proj.transform([max_x, max_y], 'EPSG:3857', "EPSG:4326")[1]);
		
		//视图参数
		for(var i = 0; i < len-1; i++){
//			ol.proj.transform(coord[0][0], "EPSG:3857" , "EPSG:4326")
			var temp_lon = ol.proj.transform(coord[0][i], "EPSG:3857" , "EPSG:4326")[0];
			var temp_lat = ol.proj.transform(coord[0][i], "EPSG:3857", "EPSG:4326")[1];
			viewParams += temp_lon + "@" + temp_lat + "@@";
		}
		var last_lon = ol.proj.transform(coord[0][len - 1], "EPSG:3857", "EPSG:4326")[0];
		var last_lat = ol.proj.transform(coord[0][len - 1], "EPSG:3857", "EPSG:4326")[1];
		viewParams += last_lon + "@" + last_lat;
		viewParams = "line_str:'" + viewParams +"'";
		scope = viewParams;
		
		tArea = ploygon_area(len, coord);
	}
	return tArea;
}

function det(x0, y0, x1, y1, x2, y2){
	return (x1-x0)*(y2-y0) - (x2 - x0)*(y1 - y0);
}

function ploygon_area(n ,coord){
	var sum = 0.0;
	for(var i = 1;i < n- 1; i++){
		var temp = det(coord[0][0][0]/1000, coord[0][0][1]/1000, coord[0][i][0]/1000, 
			coord[0][i][1]/1000, coord[0][i+1][0]/1000, coord[0][i+1][1]/1000);
		sum += temp;
	}
	return Math.round(Math.abs(sum/2));
}
