/*
 * 根据scope(行政区域的)，返回行政区的编码
 * */
function getRegionId(scope){
	var regions = scope.split(";");
	var regionId;
	if(regions[2].split(":")[1] != "undefined" && regions[2].split(":")[1] != "all"){
		regionId = regions[2].split(":")[1];
	}else if(regions[1].split(":")[1] != "undefined" && regions[1].split(":")[1] != "all"){
		regionId = regions[1].split(":")[1]
	}else{
		regionId = regions[0].split(":")[1]
	}
	return regionId;
}
/*
 * 返回的值1代表是省，2代表是市，3代表是县
 * */
function getLevel(scope){
	var regions = scope.split(";");
	var level;
	if(regions[2].split(":")[1] != "undefined" && regions[2].split(":")[1] != "all"){
		level = 3
	}else if(regions[1].split(":")[1] != "undefined" && regions[1].split(":")[1] != "all"){
		level = 2;
	}else{
		level = 1;
	}
	return level;
}