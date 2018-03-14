<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <div class="ui right floated pagination menu">
	<div class="item" >共${page.totalPage}页</div>
	<div class="item">当前第${page.pageNum}页</div>
	<a class="item" href="admin/${path}?pageNum=1">首页</a>
	<%--如果当前页为第一页时，就没有上一页这个超链接显示 --%>
	<c:if test="${page.pageNum == 1}">
		<c:forEach begin="${page.startPage}" end="${page.endPage}" step="1" var="i">
			<c:if test="${page.pageNum == i}"><span class="item">${i}</span></c:if>
			<c:if test="${page.pageNum != i}">
				<a class="item" href="admin/${path}?pageNum=${i}">${i}</a>
			</c:if>
		</c:forEach>
		<a class="item"  href="admin/${path}?pageNum=${page.pageNum + 1}">
			<i class="right chevron icon"></i>
		</a>
	</c:if>
	
	<%--如果当前页不是第一页也不是最后一页，则上一页和下一页这个超链接显示 --%>
	<c:if test="${page.pageNum > 1 && page.pageNum < page.totalPage}">
		<a class="item" href="admin/${path}?pageNum=${page.pageNum - 1}">
			<i class="left chevron icon"></i>
		</a>
		<c:forEach begin="${page.startPage}" end="${page.endPage}" step="1" var = "i">
			<c:if test="${page.pageNum == i}"><span class="item">${i}</span></c:if>
			<c:if test="${page.pageNum != i}">
				<a class="item" href="admin/${path}?pageNum=${i}">${i}</a>
			</c:if>
		</c:forEach>
		<a class="item" href="admin/${path}?pageNum=${page.pageNum + 1}">
			<i class="right chevron icon"></i>
		</a>
	</c:if>
	
	<%--如果当前页是最后一页，则只有上一页这个超链接显示，下一页就没有 --%>
	<c:if test="${page.pageNum == page.totalPage}">
		<a class="item" href="admin/${path}?pageNum=${page.pageNum - 1}">
			<i class="left chevron icon"></i>
		</a>
		<c:forEach begin="${page.startPage}" end="${page.endPage}" step="1" var = "i">
			<c:if test="${page.pageNum == i}"><span class="item">${i}</span></c:if>
			<c:if test="${page.pageNum != i}">
				<a class="item" href="admin/${path}?pageNum=${i}">${i}</a>
			</c:if>
		</c:forEach>
	</c:if>
	
	<%--尾页 --%>
	<a class="item" href="admin/manage.html?pageNum=${page.totalPage}">尾页</a>
	
	<div class="item"><button class="ui primary button" id="go">跳转</button></div>
	<div class="item">
		<input type="text" id="goto" placeholder="页面"/>
	</div>
</div>
<script>
	$(document).ready(function(){
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
			
			$(window).attr("location","admin/manage.html?pageNum="+pages);
		})
	})
</script>