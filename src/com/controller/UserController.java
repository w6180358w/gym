package com.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.model.User;
import com.service.inter.UserService;
import com.util.SystemUtil;
/**
 * 用户管理的控制器
 * @author zxy
 *
 */
@Controller
@RequestMapping("/user")
public class UserController {
	//利用spring获取用户的service
	@Autowired
	private UserService userService;
	/**
	 * 用户管理的页面
	 * @param user
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/home.do")
	public String home(HttpServletRequest request,
			HttpServletResponse response){
		//获取所有用户的信息
		List<User> userList = this.userService.getAll();
		//将所有用户信息存入request中  在jsp中展现
		request.setAttribute("userList", userList);
		//返回到指定页面
		return "user";		
	}
	@RequestMapping("/all.do")
	public String all(HttpServletRequest request,
			HttpServletResponse response){
		//获取所有用户的信息
		List<User> userList = this.userService.getAll();
		//将所有用户信息存入request中  在jsp中展现
		request.setAttribute("userList", userList);
		try {
			response.getWriter().print(SystemUtil.request(0, userList, ""));
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * 用户保存的方法
	 * @param user
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/save.do")
	public String save(@ModelAttribute User user,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "保存成功";
		try {
			List<User> userList = this.userService.codeValid(user);
			if(userList!=null && !userList.isEmpty()){
				code = 1;
				msg = "账号重复";
			}else{
				userService.save(user);
			}
		} catch (Exception e) {
			code = 1;
			msg = "保存失败";
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, null, msg));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
	/**
	 * 管理员页面修改用户的方法
	 * @param user
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/update.do")
	public String update(@ModelAttribute User user,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "修改成功";
		try {
			List<User> userList = this.userService.codeValid(user);
			if(userList!=null && !userList.isEmpty()){
				code = 1;
				msg = "账号重复";
			}else{
				userService.update(user);
			}
		} catch (Exception e) {
			code = 1;
			msg = "修改失败";
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, null, msg));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
	/**
	 * 删除用户的方法
	 * @param user
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/del.do")
	public String del(@ModelAttribute User user,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		try {
			userService.delete(user);
		} catch (Exception e) {
			code = 1;
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, null, null));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
	
	@RequestMapping("/get.do")
	public String get(Long id,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		User user = null;
		try {
			user = userService.findById(id);
		} catch (Exception e) {
			code = 1;
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, user, null));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
}
