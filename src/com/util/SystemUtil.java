package com.util;

import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

public class SystemUtil {

	//public static final String ADMIN = "admin";
	
	public static JSONObject request(int code,List<?> data,String msg){
		JSONObject result = new JSONObject();
		JsonConfig con = new JsonConfig();
		con.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
		result.put("code", code);
		result.put("data", JSONArray.fromObject(data,con));
		result.put("msg", msg);
		return result;
	}
	
	public static JSONObject request(int code,Object data,String msg){
		JSONObject result = new JSONObject();
		JsonConfig con = new JsonConfig();
		con.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
		result.put("code", code);
		result.put("data", JSONObject.fromObject(data,con));
		result.put("msg", msg);
		return result;
	}
}
