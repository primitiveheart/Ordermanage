/*
 * 把毫秒变成日期和时间
 * */
function getMyDate(str){
	var date = new Date(str);
	var year = date.getFullYear();
	var month = date.getMonth() + 1;
	var day = date.getDate();
	var hour = date.getHours();
	var minute = date.getMinutes();
	var second = date.getSeconds();
	var time = year + "-" + completeZero(month) + "-" + completeZero(day) + " " + completeZero(hour) + ":" + completeZero(minute) + ":" + completeZero(second);
	return time;
}
/*
 * 补零操作
 * */
function completeZero(num){
	if(parseInt(num) < 10){
		num = "0" + num;
	}
	return num;
}

function submitRequest(pageNum){
	var formData = $(".ui.form input").serialize();
	formData += "&pageNum=" + pageNum;
	$.ajax({
			url:"admin/submitSearchForm.html",
			async:false,
			data:formData,
			success:function(result){
				searchResultList(result);
			}
	})
}

/*
 * 搜索订单结果列表
 * */
function searchResultList(result){
	if(result.page != null && !$.isEmptyObject(result.page)){
		$(".ui.searchResultList.table tbody").children().remove();
		$(".ui.searchResultList.table tfoot tr th").children().remove();
		$(".orderList").hide();
		$(".searchResultList").show();
		var len = result.page.list.length;
		for(var i=0; i<len ; i++){
			var $tr = $("<tr></tr>");
			$tr.appendTo($(".ui.searchResultList.table tbody"));
			$("<td colspan='6'> <h3 class='ui header'>日期:" + getMyDate(result.page.list[i].date) + "&nbsp;&nbsp;订单号:" + result.page.list[i].uuid + "</h3></td>").appendTo($tr);
			for(var j=0; j<result.page.list[i].products.length; j++){
				$tr2 = $("<tr></tr>");
				$tr2.appendTo($(".ui.searchResultList.table tbody"));
				
				var showShape;
				if(result.page.list[i].shape == "LineString"){
						showShape = "矩形";
				}else if(result.page.list[i].shape == "Polygon"){
					showShape = "多边形";
				}else if(result.page.list[i].shape == "Circle"){
					showShape = "圆形";
				}else{
					if(result.page.list[i].scope != ""){
						var tempScope0 = result.page.list[i].scope.split(";")[0];
						var tempScope1 = result.page.list[i].scope.split(";")[1];
						var tempScope2 = result.page.list[i].scope.split(";")[2];
						showShape = tempScope0.split(":")[0] + "(" +tempScope0.split(":")[1] + ")";
						if(tempScope1.split(":")[0] != "undefined"){
							showShape += tempScope1.split(":")[0] + "(" +tempScope1.split(":")[1] + ")" ;
						}
						if(tempScope2.split(":")[0] != "undefined"){
						showShape += tempScope2.split(":")[0] + "(" +tempScope2.split(":")[1] + ")" ;
						}
									
					}
				}
				var opearate = "<div class='ui primary check button' data-uuid='"+result.page.list[i].uuid + "' data-id='"+result.page.list[i].products[j].id + "'"+
					" data-user='" + result.page.list[i].username + "' data-state='" + result.page.list[i].products[j].state +"'>审核</div> "+
					" <div class='ui black withdraw button' data-uuid='" + result.page.list[i].uuid + "' data-id='" + result.page.list[i].products[j].id +"'"+
					" data-user='" + result.page.list[i].username + "' data-state='" + result.page.list[i].products[j].state +"'>撤销</div>";
				
				var checkScope = "<a href='javascript:void(0)' class='checkScope' data-scope='" + result.page.list[i].scope + "' data-shape='" + result.page.list[i].shape + "'>查看范围</a>"
		
				$td = $("<td> 年份："+ result.page.list[i].products[j].year + " <br> 面积(km^2)：" + 
				result.page.list[i].products[j].area + checkScope + "<br> 数据选项：" + result.page.list[i].products[j].index +
			   "<br> 产品类型："+result.page.list[i].products[j].inputForm + "</td>" +
	    		"<td> " + result.page.list[i].price + "</td>"+
	    			"<td>" + showShape + "</td>" + 
	    			"<td>" + result.page.list[i].products[j].state + "<td>" + result.page.list[i].username+"</td>"+
	    			"</td><td>" + opearate + "</td>");
	    		$td.appendTo($tr2);
			}
		}
		
		//添加导航条
		
		var firstPage = "<a class='item' href='admin/submitSearchForm.html?pageNum=1'>首页</a>";
		var noPreviousPage="";
		var previous = result.page.pageNum + 1;
		var next = result.page.pageNum - 1;
		if(result.page.pageNum == 1){
			for(var i = result.page.startPage; i <= result.page.endPage; i++){
				if(result.page.pageNum == i){
					noPreviousPage = noPreviousPage + "<span class='item'>" + i + "</span>";
				}else{
					noPreviousPage = noPreviousPage + "<a class='item' href='javascript:void(0)' data-pageNum='"+i+"'>" + i + "</a>";
				}
			}
			noPreviousPage = noPreviousPage + "<a class='item' href='javascript:void(0)' data-pageNum='"+previous+"'><i class='right chevron icon'></i></a>";
		}
		
		var previousAndNextPage = "";
		if(result.page.pageNum > 1 && result.page.pageNum < result.page.totalPage){
			previousAndNextPage = previousAndNextPage + "<a class='item' href='javascript:void(0)' data-pageNum='"+next+"'><i class='left chevron icon'></i></a>";
			for(var i = result.page.startPage; i <= result.page.endPage; i++){
				if(result.page.pageNum == i){
					previousAndNextPage = previousAndNextPage + "<span class='item'>" + i + "</span>";
				}else{
					previousAndNextPage = previousAndNextPage + "<a class='item' href='javascript:void(0)' data-pageNum='"+i+"'>" + i + "</a>";
				}
			}
			previousAndNextPage = previousAndNextPage + "<a class='item' href='javascript:void(0)' data-pageNum='"+previous+"'><i class='right chevron icon'></i></a>";
		}
		
		var noNextPage = "";
		if(result.page.pageNum == result.page.totalPage){
			noNextPage = noNextPage + "<a class='item' href='javascript:void(0)' data-pageNum='"+next+"'><i class='left chevron icon'></i></a>";
			for(var i = result.page.startPage; i <= result.page.endPage; i++){
				if(result.page.pageNum == i){
					noNextPage = noNextPage + "<span class='item'>" + i + "</span>";
				}else{
					noNextPage = noNextPage + "<a class='item' href='javascript:void(0)' data-pageNum='"+i+"'>" + i + "</a>";
				}
			}
		}
		
		var lastPage = "<a class='item' href='javascript:void(0)' data-pageNum='"+ result.page.totalPage+"'>尾页</a>";
		
		var skip = "<div class='item'><button class='ui primary button' id='searchGo'>跳转</button></div>" +
				"<div class='item'><input type='text' id='searchGoto' placeholder='页面'/></div>";
		
		var $pagination = $("<div class='ui right floated pagination menu'>" +
		"<div class='item' >共" + result.page.totalPage + "页</div>" +
		"<div class='item'>当前第" + result.page.pageNum + "页</div>" + firstPage + noPreviousPage +
		previousAndNextPage + noNextPage +lastPage + skip + "</div>");
		
		$(".searchResultList tfoot tr th").append($pagination);
		
		$("#searchGo").on("click", function(){
			var maxPage = result.page.totalPage;
			var pages = $("#searchGoto").val();
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
			submitRequest(pages);
		})
		
		//a标签
		$("a.item").on("click", function(){
			var pageNum = $(this).attr("data-pageNum");
			submitRequest(pageNum);
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
			bindMap(shape, scope);
  		});
		
		//审核通过
		$(".ui.check.button").on("click",function(){
			var uuid = $(this).attr("data-uuid");
			var id = $(this).attr("data-id");
			var username = $(this).attr("data-user");
			var state = $(this).attr("data-state");
			var pageNum = result.page.pageNum;
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
					$(location).attr("href","admin/submitSearchForm.html?pageNum=" + pageNum);
				}
			})
		})
		
		//撤销审核
		$(".ui.withdraw.button").on("click", function(){
			var uuid = $(this).attr("data-uuid");
			var id = $(this).attr("data-id");
			var username = $(this).attr("data-user");
			var state = $(this).attr("data-state");
			var pageNum = result.page.pageNum;
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
					$(location).attr("href","admin/submitSearchForm.html?pageNum=" + pageNum);
				}
			})
		})
		
	}
}