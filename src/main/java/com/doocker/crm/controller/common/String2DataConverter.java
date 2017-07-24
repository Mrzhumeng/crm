package com.doocker.crm.controller.common;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.core.convert.converter.Converter;

//S	表示source 传入的参数String
//T target 目标类型Date
public class String2DataConverter implements Converter<String,Date> {

	@Override
	public Date convert(String source) {
		//传入事件字符串的类型是2017-7-22
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date parse = null;
		try {
			 parse = sdf.parse(source);
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
		}
		return parse;
	}

}
