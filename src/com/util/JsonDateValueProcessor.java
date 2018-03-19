package com.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonValueProcessor;
/**
 * 在用json工具把对象转换成字符串的时候
 * 如果有时间对象   默认会变成{key:value}的形式
 * 在前台会自动转换成object对象 而不是字符串
 * 所以这里我们继承JsonValueProcessor
 * json的转换接口   覆盖Date类型的方法使其变成字符串
 * @author 段宝丹
 *
 */
public class JsonDateValueProcessor implements JsonValueProcessor {
	private String format ="yyyy-MM-dd";
	
	public JsonDateValueProcessor() {
		super();
	}
	
	public JsonDateValueProcessor(String format) {
		super();
		this.format = format;
	}

	@Override
	public Object processArrayValue(Object paramObject,
			JsonConfig paramJsonConfig) {
		return process(paramObject);
	}

	@Override
	public Object processObjectValue(String paramString, Object paramObject,
			JsonConfig paramJsonConfig) {
		return process(paramObject);
	}
	
	
	private Object process(Object value){
        if(value instanceof Date){  
            SimpleDateFormat sdf = new SimpleDateFormat(format,Locale.CHINA);  
            return sdf.format(value);
        }  
        return value == null ? "" : value.toString();  
    }

}
