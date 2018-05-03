package com.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.model.Notice;
import com.model.User;
import com.service.inter.NoticeService;
import com.util.SystemUtil;
/**
 * 公告的控制器
 * @author zxy
 *
 */
@Controller
@RequestMapping("/notice")
public class NoticeController {
	//利用spring获取场地的service
	@Autowired
	private NoticeService noticeService;
	/**
	 * 场地管理的页面
	 * @param Gym
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/home.do")
	public String home(HttpServletRequest request,
			HttpServletResponse response){
		//获取所有场地的信息
		List<Notice> noticeList = this.noticeService.getAll();
		//将所有场地信息存入request中  在jsp中展现
		request.setAttribute("noticeList", noticeList);
		//返回到指定页面
		return "notice";		
	}
	
	/**
	 * 公告保存的方法
	 * @param Gym
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/save.do")
	public String save(@ModelAttribute Notice notice,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "保存成功";
		try {
			User user = (User)request.getSession().getAttribute("user");
			notice.setCreateTime(System.currentTimeMillis());
			notice.setUserId(user.getId()+"");
			notice.setUserName(user.getName());
			noticeService.save(notice);
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
	 * 管理员页面修改场地的方法
	 * @param Gym
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/update.do")
	public String update(@ModelAttribute Notice notice,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "修改成功";
		try {
			noticeService.update(notice);
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
	 * 删除场地的方法
	 * @param Gym
	 * @param request
	 * @param response
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping("/del.do")
	public String del(@ModelAttribute Notice notice,HttpServletRequest request,
			HttpServletResponse response) throws IOException{
		noticeService.delete(notice);
		response.getWriter().print(SystemUtil.request(0, null, "删除成功!"));
		return null;		
	}
	
	@RequestMapping("/get.do")
	public String get(Long id,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		Notice notice = null;
		try {
			notice = noticeService.findById(id);
		} catch (Exception e) {
			code = 1;
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, notice, null));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
	
	@RequestMapping("/load.do")
	public String load(HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		List<Notice> notice = new ArrayList<Notice>();
		try {
			notice = noticeService.load();
		} catch (Exception e) {
			code = 1;
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, notice, null));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
}
