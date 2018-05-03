package com.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.model.User;
import com.service.inter.MessageService;
import com.service.inter.UserService;
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
	@Autowired
	private UserService userService;
	@Autowired
	private MessageService messageService;
	/* 点击登录按钮进行的登录操作
	 * @param user	spring将账号密码等登录信息存入user对象中 （前台登录密码字段必须和user中的一致）
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/doLogin.do")
	public String doLogin(String ucode,String password,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "登录成功";
		try {
			User user = null;
			if(this.userName.equals(ucode) && this.password.equals(password)) {
				user = new User(ucode,password,ucode,SystemUtil.SUPERADMIN);
			}else {
				user = this.userService.login(ucode, password);
			}
			if(user==null){
				code = 1;
				msg = "登录失败，账号密码错误";
			}else{
				request.getSession().setAttribute("messageList", messageService.loadMessage());
				request.getSession().setAttribute("user", user);
			}
		} catch (Exception e) {
			e.printStackTrace();
			code = 1;
			msg = "系统错误，请联系管理员";
		}
		//将操作状态返回到前台页面
		try {
			response.getWriter().print(SystemUtil.request(code, null, msg));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;
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
		String msg = "";
		response.setContentType("text/javascript charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		try {
			//直接将session中的用户和登录时间设置为空
			request.getSession().setAttribute("messageList", null);
			request.getSession().setAttribute("user",null);
			request.getSession().setAttribute("login-time",null);
		} catch (Exception e) {
			code = 1;
			msg="系统错误，请联系管理员!";
			e.printStackTrace();
		}
		//将操作状态返回到前台页面
		try {
			response.getWriter().print(SystemUtil.request(code, null, msg));
		} catch (IOException e) {
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
