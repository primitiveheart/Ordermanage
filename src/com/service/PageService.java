package com.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.commons.Page;
import com.entity.Order;
import com.entity.SearchOrder;
import com.mapper.OrderMapper;

/**
 * 获得每页的服务
 * @author admin
 *
 */
@Service
public class PageService {

	@Autowired
	private OrderMapper orderMapper;
	
	public Page getPageData(Integer pageNum, Integer pageSize){
		int totalRecords = orderMapper.totalOrderNum();
		Page page = new Page(totalRecords, pageSize, pageNum);
		int startIndex = page.getStartIndex();
		List<Order> orders = orderMapper.getPageData(pageSize, startIndex);
		page.setList(orders);
		return page;
	}
	
	public Page getPageData(Integer pageNum, Integer pageSize, String username){
		int totalRecords = orderMapper.totalOrderNumByUsername(username);
		Page page = new Page(totalRecords, pageSize, pageNum);
		int startIndex = page.getStartIndex();
		List<Order> orders = orderMapper.getPageDataByUsername(pageSize, startIndex, username);
		page.setList(orders);
		return page;
	}
	
	public Page getPageDataBySearchOrder(Integer pageSize, Integer pageNum, SearchOrder searchOrder){
		int totalRecords = orderMapper.queryTotalOrderBySearchOrder(searchOrder.getStartDate(), searchOrder.getEndDate(),
				searchOrder.getOrderNum(), searchOrder.getUsername(), searchOrder.getState());
		
		Page page = new Page(totalRecords, pageSize, pageNum);
		int startIndex = page.getStartIndex();
		List<Order> orders = orderMapper.queryOrderBySearchOrder(pageSize, startIndex,
				searchOrder.getStartDate(), searchOrder.getEndDate(), searchOrder.getOrderNum(),
				searchOrder.getUsername(), searchOrder.getState());
		page.setList(orders);
		return page;
	}
}
