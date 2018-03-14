package com.service;

import java.sql.Timestamp;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.convert.converter.Converter;

// 3、定义系统全局类型转换器
public class DateConverter implements Converter<String, Timestamp>{
	private final static Logger logger = LoggerFactory.getLogger(DateConverter.class);
	
    @Override
    public Timestamp convert(String source) {
        try {
        	source += ":00";
        	Timestamp timestamp = Timestamp.valueOf(source);
            return timestamp;
        } catch (Exception e) {
        	logger.error("DateConverter convert 日期转换失败", e);
        }
        return null;
    }

}