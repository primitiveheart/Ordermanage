package com.mapper;

import java.util.List;

import com.entity.Message;

/**
 * 消息的mapper
 * @author admin
 *
 */
public interface MessageMapper {
	
	Integer addMessage(Message message);
	
	List<Message> queryMessageByUsername(String username);
	
	Message queryMessageByProudctId(Integer productId);
}
