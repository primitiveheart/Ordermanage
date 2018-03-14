/*
 * 根据shape（矩形，园形和多边形)得到选中区域的范围
 * */
function getSelectShapeExtent(scope, shape){
	var extent = [];
	if("LineString" == shape){
		var temp = scope.split(";")
		var min_lon = temp[0].split(":")[1];
		var min_lat = temp[1].split(":")[1];
		var max_lon = temp[2].split(":")[1];
		var max_lat = temp[3].split(":")[1];
		
		extent = [parseFloat(min_lon), parseFloat(min_lat), parseFloat(max_lon), parseFloat(max_lat)];
	}else if("Polygon" == shape){
		var lineStr = scope.split(":")[1];
		var temp = lineStr.split("@@");
		var tempX = [];
		var tempY = [];
		for(var i=0; i<temp.length; i++){
			tempX.push(parseFloat(temp[i].split("@")[0].replace("'", "")));
			tempY.push(parseFloat(temp[i].split("@")[1].replace("'", "")));
		}
		
		var min_x = tempX[0];
		var min_y = tempY[0];
		var max_x = tempX[0];
		var max_y = tempY[0];
		for(var i=1; i<tempX.length; i++ ){
			if(tempX[i] < min_x){
				min_x = tempX[i];
			}
			if(tempX[i] > max_x){
				max_x = tempX[i];
			}
		}
		
		for(var i=1; i<tempY.length; i++ ){
			if(tempY[i] < min_y){
				min_y = tempY[i];
			}
			if(tempY[i] > max_y){
				max_y = tempY[i];
			}
		}
		
		extent = [parseFloat(min_x), parseFloat(min_y), parseFloat(max_x), parseFloat(max_y)];
	}else{
		var temp = scope.split(";");
		var centerX = temp[0].split(":")[1];
		var centerY = temp[1].split(":")[1];
		var radius = temp[2].split(":")[1] * 1000;
		var centerLL = ol.proj.transform([parseFloat(centerX),parseFloat(centerY)], 'EPSG:4326', 'EPSG:3857');
		
		/*
		var wgs84Sphere= new ol.Sphere(6378137);
		
		var centerLL = ol.proj.transform([parseFloat(centerX),parseFloat(centerY)], 'EPSG:4326', 'EPSG:3857');
		var edgeCoor = [centerLL[0] + radius, centerLL[1]];
		var groudRadius = wgs84Sphere.haversineDistance(
					ol.proj.transform(centerLL, 'EPSG:3857', 'EPSG:4326'),
					ol.proj.transform(edgeCoor, 'EPSG:3857', 'EPSG:4326')
				);
		*/
		var tempCircle = new ol.geom.Circle(centerLL, radius);
		extent = tempCircle.getExtent();
		var min_x = ol.proj.transform([extent[0], extent[1]], 'EPSG:3857','EPSG:4326')[0];
		var min_y = Math.abs(ol.proj.transform([extent[0], extent[1]], 'EPSG:3857','EPSG:4326')[1]);
		var max_x = ol.proj.transform([extent[2], extent[3]], 'EPSG:3857','EPSG:4326')[0];
		var max_y = Math.abs(ol.proj.transform([extent[2], extent[3]], 'EPSG:3857','EPSG:4326')[1]);
		extent = [parseFloat(min_x), parseFloat(min_y), parseFloat(max_x), parseFloat(max_y)];
		console.log(extent);
		//extent = [parseFloat(centerX)-5, parseFloat(centerY)-5, parseFloat(centerX) + 5, parseFloat(centerY) + 5];
	}
	return extent;
}

/*
 * 得到一个行政区域的范围,temp就是行政区域的最大范围
 */
function getRegionExtent(temp){
	var extent =[];
	var min_lon = temp.split(",")[0];
	var min_lat = temp.split(",")[1];
	var max_lon = temp.split(",")[2];
	var max_lat = temp.split(",")[3];
	var min_x = ol.proj.transform([min_lon, min_lat], "EPSG:4326", "EPSG:3857")[0];
	var min_y = Math.abs(ol.proj.transform([min_lon, -min_lat], "EPSG:4326", "EPSG:3857")[1]);
	var max_x = ol.proj.transform([max_lon, max_lat], "EPSG:4326", "EPSG:3857")[0];
	var max_y = Math.abs(ol.proj.transform([max_lon, -max_lat], "EPSG:4326", "EPSG:3857")[1]);
	extent = [min_x, min_y, max_x, max_y];
	return extent;
}
	