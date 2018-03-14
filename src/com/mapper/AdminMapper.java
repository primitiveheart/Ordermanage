package com.mapper;

import com.entity.Admin;

public interface AdminMapper {
	Admin queryAdminByUsername(String username);
}
