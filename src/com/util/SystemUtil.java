package com.util;

import java.util.Date;
import java.util.HashSet;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

public class SystemUtil {

	public static final String USER = "user";
	public static final String ADMIN = "admin";
	public static final String SUPERADMIN = "superadmin";
	
	public static final HashSet<String> ADMIN_URL = new HashSet<String>(){{
			add("/gym/gym/home.do");add("/gym/gym/save.do");add("/gym/gym/update.do");add("/gym/gym/del.do");add("/gym/gym/get.do");
			add("/gym/notice/home.do");add("/gym/notice/save.do");add("/gym/notice/update.do");add("/gym/notice/del.do");add("/gym/notice/get.do");
			add("/gym/message/home.do");add("/gym/message/read.do");add("/gym/message/del.do");
			add("/gym/pause/save.do");add("/gym/pause/update.do");add("/gym/pause/getData.do");
	}};
	public static final HashSet<String> SUPERADMIN_URL = new HashSet<String>(){{
		add("/gym/user/home.do");add("/gym/user/all.do");add("/gym/user/save.do");add("/gym/user/update.do");add("/gym/user/del.do");add("/gym/user/get.do");
		add("/gym/gymType/home.do");add("/gym/gymType/save.do");add("/gym/gymType/update.do");add("/gym/gymType/del.do");add("/gym/gymType/get.do");
	}};
	
	
	public static JSONObject request(int code,List<?> data,String msg){
		JSONObject result = new JSONObject();
		JsonConfig con = new JsonConfig();
		con.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
		result.put("code", code);
		result.put("data", JSONArray.fromObject(data,con));
		result.put("msg", msg);
		return result;
	}
	
	public static JSONObject request(int code,String msg){
		JSONObject result = new JSONObject();
		JsonConfig con = new JsonConfig();
		con.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
		result.put("code", code);
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
