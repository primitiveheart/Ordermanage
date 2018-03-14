<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>成功创建订单</title>
</head>
<body onload="returnUrlByTime()">
	<div>创建订单成功</div>
	<div id="autoskip">3</div>
	<div>秒后，转入到主界面。</div>
	<%
		//转向语句
		response.setHeader("Refresh","3;URL=userhome.html");
	 %>
</body>
<script>
	var time = 4;
	function returnUrlByTime(){
		window.setTimeout("returnUrlByTime()", 1000);
		time = time - 1;
		document.getElementById("autoskip").innerHTML = time;
	}
</script>
</html>