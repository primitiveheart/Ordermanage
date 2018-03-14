package com.commons;

import java.sql.DriverManager;
import java.sql.SQLException;

import org.apache.tomcat.dbcp.dbcp.BasicDataSource;

/**
 * @author admin
 * 主要重写close方法
 */
public class FixedBasicDataSource extends BasicDataSource{

	@Override
	public synchronized void close() throws SQLException {
		DriverManager.deregisterDriver(DriverManager.getDriver("jdbc:postgresql://47.93.237.6:5432/census_china"));
		super.close();
	}
		
}
