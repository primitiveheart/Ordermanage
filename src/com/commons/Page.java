package com.commons;

import java.util.List;

/**
 * 页面的类
 * @author admin
 *
 * @param <E> 实际的类型
 */
public class Page<E> {
	private List<E> list; //存放数据
	
	private int totalPage; //总的页数
	
	private int totalRecords; //总的记录数
	
	private int pageNum; //当前页数
	
	private int pageSize; //页面的大小
	
	private int startPage; //开始的页数
	
	private int endPage; //结束的页数
	
	private int startIndex;
	
	public Page(){}
	
	public Page(int totalRecords, int pageSize, int pageNum){
		this.totalRecords = totalRecords;
		this.pageSize = pageSize;
		this.pageNum = pageNum;
		
		//计算总的页数
		if(this.totalRecords % this.pageSize == 0){
			this.totalPage = this.totalRecords/this.pageSize;
		}else{
			this.totalPage = this.totalRecords / this.pageSize + 1;
		}
		
		this.startIndex = (pageNum - 1) * pageSize;
		
		this.startPage = 1;
		this.endPage = 5;
		
		if(totalPage <= 5){
			this.endPage = totalPage;
		}else{
			this.startPage = this.pageNum - 2;
			this.endPage = this.pageNum + 2; 
			//计算开始页
			if(this.startPage <= 0){
				this.startPage = 1;
				this.endPage = 5;
			}
			
			//计算结束页
			if(this.endPage >  this.totalPage){
				this.endPage = this.totalPage;
				this.startPage = this.endPage - 5;
			}
		}
	}

	public List<E> getList() {
		return list;
	}

	public void setList(List<E> list) {
		this.list = list;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getTotalRecords() {
		return totalRecords;
	}

	public void setTotalRecords(int totalRecords) {
		this.totalRecords = totalRecords;
	}

	public int getPageNum() {
		return pageNum;
	}

	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public int getStartIndex() {
		return startIndex;
	}

	public void setStartIndex(int startIndex) {
		this.startIndex = startIndex;
	}
	
	
}
