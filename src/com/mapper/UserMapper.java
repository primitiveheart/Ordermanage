package com.mapper;

import java.util.List;

import com.entity.User;

public interface UserMapper {
	User queryUserByUsername(String username);
	
	User queryUserByTelephone(String telephone);
	
	User queryUserByEmail(String email);
	
	void addUser(User user);
	
	List<User> queryAllUser();
}
