package com.mapper;

import java.sql.Timestamp;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.entity.Order;
import com.entity.SearchOrder;

public interface OrderMapper {
	
	/**
	 * 添加订单
	 * @param order
	 * @return
	 */
	Integer addOrder(Order order);
	
	/**
	 * 根据用户名查询订单
	 * @param username
	 * @return
	 */
	List<Order> queryOrderByUsername(String username);
	
	/**
	 * 订单总的数目
	 * @return
	 */
	Integer totalOrderNum();
	
	/**
	 * 某个用户的总的订单的数目
	 * @param username
	 * @return
	 */
	Integer totalOrderNumByUsername(String username);
	
	/**
	 * 查询所的订单
	 * @return
	 */
	List<Order> queryAllOrder();
	
	/**
	 * 根据订单号查询订单
	 * @param uuid
	 * @return
	 */
	Order queryOrderByUUID(String uuid);
	
	/**
	 * 查询页面的数目
	 * @param pageSize
	 * @param pageIndex
	 * @return
	 */
	List<Order> getPageData(@Param("pageSize")Integer pageSize, @Param("pageIndex")Integer pageIndex);
	
	/**
	 * 根据用户名查询页面的数目
	 * @param pageSize
	 * @param pageIndex
	 * @param username
	 * @return
	 */
	List<Order> getPageDataByUsername(@Param("pageSize") Integer pageSize, @Param("pageIndex")Integer pageIndex, @Param("username")String username);
	
	/**
	 * 根据订单号删除订单
	 * @param uuid
	 * @return
	 */
	Integer deleteOrderByUUID(String uuid);
	
	List<Order> queryOrderBySearchVal(@Param("searchVal")String searchVal, @Param("username")String username);
	
	List<Order> queryOrderBySearchOrder(@Param("pageSize")Integer pageSize, @Param("startIndex") Integer startIndex, @Param("startDate") Timestamp startDate, @Param("endDate") Timestamp endDate,
			@Param("orderNum") String orderNum, @Param("username")String username, @Param("state") String state);
	
	Integer queryTotalOrderBySearchOrder(@Param("startDate") Timestamp startDate, @Param("endDate") Timestamp endDate,
			@Param("orderNum") String orderNum, @Param("username")String username, @Param("state") String state);
}
