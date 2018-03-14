package com.mapper;

import java.util.List;

import com.entity.Product;

public interface ProductMapper {
	
	Integer addProduct(Product product);
	
	/**
	 * @param orderUUID 这是订单号
	 * @return
	 */
	List<Product> queryProductByOrderUUID(String order_uuid);
	
	Product queryProductById(Integer id);
	
	Integer updateProductById(Product product);
	
	Integer deleteProductById(Integer productId);
	
	List<Product> queryProductBySearchVal(String SearchVal);
}
