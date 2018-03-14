package com.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 获取数据产品的结果
 * @author admin
 *
 */
@Controller
@RequestMapping("result")
public class DataProductController {

	@RequestMapping("vector.html")
	public String vector(){
		return "result/vector";
	}
	
	@RequestMapping("special.html")
	public String special(){
		return "result/special";
	}
	
	@RequestMapping("sum.html")
	public String sum(){
		return "result/sum";
	}
	
}
