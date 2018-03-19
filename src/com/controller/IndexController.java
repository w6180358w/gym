package com.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.util.SystemUtil;
/**
 * 登录登出和首页的控制器
 * @author 段宝丹
 *
 */
@Controller
@RequestMapping("/index")
public class IndexController {
	@Value("#{configProperties['userName']}")
	public String userName;
	@Value("#{configProperties['password']}")
	public String password;
	/* 点击登录按钮进行的登录操作
	 * @param user	spring将账号密码等登录信息存入user对象中 （前台登录密码字段必须和user中的一致）
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/doLogin.do")
	public String doLogin(String userName,String password,HttpServletRequest request,
			HttpServletResponse response){
		try {
			if(this.userName.equals(userName) && this.password.equals(password)) {
				request.getSession().setAttribute("user", userName);
				request.getSession().setAttribute("code", true);
				return "redirect:/user/home.do"; 
			}else {
				request.getSession().setAttribute("code", false);
				request.getSession().setAttribute("msg", "用户名或密码错误!");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/index.jsp";		
	}
	/**
	 * 登出页面
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/logout.do")
	public String logout(HttpServletRequest request,
			HttpServletResponse response){
		//操作状态
		int code = 0;
		response.setContentType("text/javascript charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		try {
			//直接将session中的用户和登录时间设置为空
			request.getSession().setAttribute("user",null);
			request.getSession().setAttribute("login-time",null);
		} catch (Exception e) {
			code = 1;
			e.printStackTrace();
		}
		//将操作状态返回到前台页面
		try {
			response.getWriter().print(SystemUtil.request(code, null, null));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;		
	}
	/**
	 * 登录页
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/login.do")
	public String login(HttpServletRequest request,
			HttpServletResponse response){
		//直接返回到登录页
		return "login";
	}
}
