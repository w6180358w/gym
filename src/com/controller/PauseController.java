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

import com.bean.PauseBean;
import com.model.Pause;
import com.service.inter.PauseService;
import com.util.SystemUtil;
/**
 * 暂停预约的控制器
 * @author zxy
 *
 */
@Controller
@RequestMapping("/pause")
public class PauseController {
	//利用spring获取暂停预约的service
	@Autowired
	private PauseService pauseService;
	
	/**
	 * 场地保存的方法
	 * @param Gym
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/save.do")
	public String save(@ModelAttribute Pause pause,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "保存成功";
		try {
			pauseService.save(pause);
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
	public String update(@ModelAttribute Pause pause,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "修改成功";
		try {
			pauseService.update(pause);
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
	
	@RequestMapping("/getData.do")
	public String get(Long gymId,String day,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		List<PauseBean> pause = new ArrayList<PauseBean>();
		try {
			pause = pauseService.getData(gymId,day);
		} catch (Exception e) {
			code = 1;
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, pause, null));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
}
