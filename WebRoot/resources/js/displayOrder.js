/*
 * 显示订单的页面
 * */
function display_front(sum_area, indexs, selectionYear, shapeText){
	$("#order").hide();
	$("#display").show();
	
	$(".resultVector").hide();
	$(".resultSpecial").hide();
	$(".resultSum").hide();
	
	var temp = sum_area;
	var year = selectionYear.join(",");
	$("#dis_year").text(year);
	$("#shape_type").text(shapeText);
	$("#area").html(temp);
	var appendAfter = "#display #area";
	$("input[name='index']").each(function(){
		if($(this).prop("checked")){
			if(indexs.indexOf($(this).val()) == -1){
//				$(appendAfter).append("<br><label>" +$(this).val() + "</label>");
				indexs.push($(this).val());
			}
		}
	})
	
	for(var i = 0; i < indexs.length; i++){
		$(appendAfter).append("<br><label>" +indexs[i] + "</label>");
	}
	
	//$(".sum").text("总值: " + sum_area * 100);
	if($("#data").prop("checked")) {
		$(".resultVector").show();
	}
	if($("#special").prop("checked")) {
		$(".resultSpecial").show();
	}
	if($("#sum").prop("checked")) {
		$(".resultSum").show();
	}
	
}
