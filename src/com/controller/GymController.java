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
import com.model.GymType;
import com.model.Order;
import com.service.inter.GymService;
import com.service.inter.GymTypeService;
import com.service.inter.OrderService;
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
	@Autowired
	private GymTypeService gymTypeService;
	@Autowired
	private OrderService orderService;
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
		List<GymType> gymTypeList = this.gymTypeService.getAll();
		//将所有场地信息存入request中  在jsp中展现
		request.setAttribute("gymList", gymList);
		request.setAttribute("gymTypeList", gymTypeList);
		//返回到指定页面
		return "gym";		
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
			HttpServletResponse response,String onDay,Long gymId,String gymType){
		//获取所有场地的信息
		Map<String, Object> gymList = this.gymService.getData(onDay,gymId,gymType);
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
	 * 删除场地的方法
	 * @param Gym
	 * @param request
	 * @param response
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping("/del.do")
	public String del(@ModelAttribute Gym gym,HttpServletRequest request,
			HttpServletResponse response) throws IOException{
		List<Order> list = this.orderService.findByGymId(gym.getId());
		if(list!=null && !list.isEmpty()){
			response.getWriter().print(SystemUtil.request(1, null, "删除失败，该场馆已被预约!"));
			return null;
		}
		gymService.delete(gym);
		response.getWriter().print(SystemUtil.request(0, null, "删除成功!"));
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
