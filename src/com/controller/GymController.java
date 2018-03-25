package com.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.model.Gym;
import com.service.inter.GymService;
import com.util.SystemUtil;
/**
 * 场地管理的控制器
 * @author zxy
 *
 */
@Controller
@RequestMapping("/gym")
public class GymController {
	//利用spring获取场地的service
	@Autowired
	private GymService gymService;
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
		List<Gym> gymList = this.gymService.getAll();
		//将所有场地信息存入request中  在jsp中展现
		request.setAttribute("GymList", gymList);
		//返回到指定页面
		return "gym";		
	}
	
	@RequestMapping("/appointment.do")
	public String appointment(HttpServletRequest request,
			HttpServletResponse response){
		//获取所有场地的信息
		List<Gym> gymList = this.gymService.getAll();
		//将所有场地信息存入request中  在jsp中展现
		request.setAttribute("GymList", gymList);
		//返回到指定页面
		return "appointment";		
	}
	
	@RequestMapping("/all.do")
	public String all(HttpServletRequest request,
			HttpServletResponse response){
		//获取所有场地的信息
		List<Gym> gymList = this.gymService.getAll();
		//将所有场地信息存入request中  在jsp中展现
		request.setAttribute("gymList", gymList);
		try {
			response.getWriter().print(SystemUtil.request(0, gymList, ""));
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@RequestMapping("/getData.do")
	public String getData(HttpServletRequest request,
			HttpServletResponse response,String onDay,Long gymId){
		//获取所有场地的信息
		Map<String, Object> gymList = this.gymService.getData(onDay,gymId);
		try {
			response.getWriter().print(SystemUtil.request(0, gymList, ""));
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 场地保存的方法
	 * @param Gym
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/save.do")
	public String save(@ModelAttribute Gym gym,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "保存成功";
		try {
			gymService.save(gym);
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
	public String update(@ModelAttribute Gym gym,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "修改成功";
		try {
			gymService.update(gym);
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
	 * 场地修改自己的方法
	 * @param Gym
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/GymUpdateGym.do")
	public String GymUpdateGym(@ModelAttribute Gym gym,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "修改成功";
		try {
			//场地名称判重
			//根据当前场地查询
			List<Gym> valid = this.gymService.nameValid(gym);
			if(valid.size()>0){
				//如果能查出数据   操作状态设置为1
				code=1;
				//提示信息
				msg = "场地名重复";
			}else{
				//如果查不出来则更新当前场地
				gymService.update(gym);
				//将当前登录场地信息清空   强制退出
				request.getSession().setAttribute("Gym", null);
				request.getSession().setAttribute("login-time", null);
			}
		} catch (Exception e) {
			//如果出错操作状态变为1 失败
			code = 1;
			//提示信息
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
	 */
	@RequestMapping("/del.do")
	public String del(@ModelAttribute Gym gym,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		try {
			gymService.delete(gym);
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
		Gym gym = null;
		try {
			gym = gymService.findById(id);
		} catch (Exception e) {
			code = 1;
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, gym, null));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
}
