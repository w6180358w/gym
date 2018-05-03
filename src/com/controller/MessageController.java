package com.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.model.Message;
import com.service.inter.MessageService;
import com.util.SystemUtil;
/**
 * 消息管理的控制器
 * @author zxy
 *
 */
@Controller
@RequestMapping("/message")
public class MessageController {
	//利用spring获取消息的service
	@Autowired
	private MessageService messageService;
	/**
	 * 消息管理的页面
	 * @param Gym
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/home.do")
	public String home(HttpServletRequest request,
			HttpServletResponse response){
		//获取所有消息的信息
		List<Message> messageList = this.messageService.getAll();
		//将所有消息信息存入request中  在jsp中展现
		request.setAttribute("messageList", messageList);
		//返回到指定页面
		return "message";		
	}
	
	/**
	 * 修改消息状态
	 * @param Gym
	 * @param request
	 * @param response
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/read.do")
	public String read(HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "修改成功";
		try {
			List<Message> messageList = (List<Message>)request.getSession().getAttribute("messageList");
			messageService.read(messageList);
			request.getSession().setAttribute("messageList", null);
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
	 * 删除消息的方法
	 * @param Gym
	 * @param request
	 * @param response
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping("/del.do")
	public String del(@ModelAttribute Message message,HttpServletRequest request,
			HttpServletResponse response) throws IOException{
		messageService.delete(message);
		response.getWriter().print(SystemUtil.request(0, null, "删除成功!"));
		return null;		
	}
	
	@RequestMapping("/get.do")
	public String get(Long id,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		Message message = null;
		try {
			message = messageService.findById(id);
		} catch (Exception e) {
			code = 1;
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, message, null));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
}
