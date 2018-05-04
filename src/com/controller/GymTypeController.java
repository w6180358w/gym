package com.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.model.Gym;
import com.model.GymType;
import com.service.inter.GymService;
import com.service.inter.GymTypeService;
import com.util.SystemUtil;
/**
 * 场地类型管理的控制器
 * @author zxy
 *
 */
@Controller
@RequestMapping("/gymType")
public class GymTypeController {
	//利用spring获取场地的service
	@Autowired
	private GymTypeService gymTypeService;
	@Autowired
	private GymService gymService;
	/**
	 * 场地管理的页面
	 * @param gymType
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/home.do")
	public String home(HttpServletRequest request,
			HttpServletResponse response){
		//获取所有场地的信息
		List<GymType> gymTypeList = this.gymTypeService.getAll();
		//将所有场地信息存入request中  在jsp中展现
		request.setAttribute("gymTypeList", gymTypeList);
		//返回到指定页面
		return "gymType";		
	}
	
	@RequestMapping("/appointment.do")
	public String appointment(HttpServletRequest request,
			HttpServletResponse response){
		//获取所有场地的信息
		List<GymType> gymTypeList = this.gymTypeService.getAll();
		//将所有场地信息存入request中  在jsp中展现
		request.setAttribute("gymTypeList", gymTypeList);
		//返回到指定页面
		return "appointment";		
	}
	
	@RequestMapping("/all.do")
	public String all(HttpServletRequest request,
			HttpServletResponse response){
		//获取所有场地的信息
		List<GymType> gymTypeList = this.gymTypeService.getAll();
		//将所有场地信息存入request中  在jsp中展现
		request.setAttribute("gymTypeList", gymTypeList);
		try {
			response.getWriter().print(SystemUtil.request(0, gymTypeList, ""));
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 场地保存的方法
	 * @param gymType
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/save.do")
	public String save(@ModelAttribute GymType gymType,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "保存成功";
		try {
			List<GymType> userList = this.gymTypeService.nameValid(gymType);
			if(userList!=null && !userList.isEmpty()){
				code = 1;
				msg = "名称重复";
			}else{
				gymTypeService.save(gymType);
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
	 * 管理员页面修改场地的方法
	 * @param gymType
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/update.do")
	public String update(@ModelAttribute GymType gymType,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "修改成功";
		try {
			List<GymType> userList = this.gymTypeService.nameValid(gymType);
			if(userList!=null && !userList.isEmpty()){
				code = 1;
				msg = "名称重复";
			}else{
				gymTypeService.update(gymType);
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
	 * 删除场地的方法
	 * @param gymType
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping("/del.do")
	public String del(@ModelAttribute GymType gymType,HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		List<Gym> gymList = this.gymService.findByType(gymType.getId()+"");
		if(gymList!=null && !gymList.isEmpty()){
			response.getWriter().print(SystemUtil.request(1, null, "删除失败，该场馆类型下存在未删除的场馆!"));
			return null;
		}
		gymTypeService.delete(gymType);
		response.getWriter().print(SystemUtil.request(0, null, "删除成功!"));
		return null;		
	}
	
	@RequestMapping("/get.do")
	public String get(Long id,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		GymType gymType = null;
		try {
			gymType = gymTypeService.findById(id);
		} catch (Exception e) {
			code = 1;
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, gymType, null));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
}
