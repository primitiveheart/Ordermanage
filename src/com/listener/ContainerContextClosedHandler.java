package com.listener;

import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.event.Level;


public class ContainerContextClosedHandler implements ServletContextListener{

	private final static Logger logger = LoggerFactory.getLogger(ContainerContextClosedHandler.class);
	
	@Override
	public void contextDestroyed(ServletContextEvent servelContextEvent) {
	   Enumeration<Driver> drivers	= DriverManager.getDrivers();
	   Driver driver = null;
	   //clear drivers
	   while(drivers.hasMoreElements()){
		   driver = drivers.nextElement();
		   try{
			   logger.info("deregistering jdbc driver {}", driver);
			   DriverManager.deregisterDriver(driver);
		   }catch (SQLException e) {
			   logger.error("deregistration failed {}",driver, e);
		   }
	   }
	   
	   //mysql driver leaves arround a thread , this static method cleans it up
	}

	@Override
	public void contextInitialized(ServletContextEvent servelContextEvent) {
	}

}
