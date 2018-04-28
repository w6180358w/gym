package com.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.model.User;
import com.util.SystemUtil;

@Controller
@RequestMapping("/callBack")
public class CallbackController {

	@RequestMapping("/login.do")
	public String home(HttpServletRequest request,
			HttpServletResponse response,User user){
		try {
			user.setType(SystemUtil.USER);
			request.getSession().setAttribute("user", user);
			request.getSession().setAttribute("code", true);
			response.sendRedirect(request.getContextPath()+"/index.jsp");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
}
