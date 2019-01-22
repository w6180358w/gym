package com.controller;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bean.GymOrderBean;
import com.model.Order;
import com.model.User;
import com.service.inter.OrderService;
import com.service.inter.POIService;
import com.util.QRCodeFactory;
import com.util.SystemUtil;

import net.sf.json.JSONArray;
/**
 * 订单管理的控制器
 * @author zxy
 *
 */
@Controller
@RequestMapping("/order")
public class OrderController {
	//利用spring获取订单的service
	@Autowired
	private OrderService orderService;
	
	@Autowired
	private POIService<Order> poiService;
	/**
	 * 订单管理的页面
	 * @param Order
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/home.do")
	public String home(HttpServletRequest request,
			HttpServletResponse response){
		User user = (User) request.getSession().getAttribute("user");
		List<Order> orderList = null;
		//根据用户查询预约记录
		if(user==null){
			orderList = new ArrayList<Order>();
		}else if(SystemUtil.ADMIN.equals(user.getType()) 
				|| SystemUtil.SUPERADMIN.equals(user.getType()) ){
			//获取所有订单的信息
			orderList = this.orderService.getAll();
		}else{
			orderList = this.orderService.findByUcode(user.getUcode());
		}
		//将所有订单信息存入request中  在jsp中展现
		request.setAttribute("orderList", orderList);
		//返回到指定页面
		return "order";		
	}
	@RequestMapping("/all.do")
	public String all(HttpServletRequest request,
			HttpServletResponse response){
		User user = (User) request.getSession().getAttribute("user");
		List<Order> orderList = null;
		//根据用户查询预约记录
		if(user==null){
			orderList = new ArrayList<Order>();
		}else if(SystemUtil.ADMIN.equals(user.getType()) 
				|| SystemUtil.SUPERADMIN.equals(user.getType()) ){
			//获取所有订单的信息
			orderList = this.orderService.getAll();
		}else{
			orderList = this.orderService.findByUcode(user.getUcode());
		}
		//将所有订单信息存入request中  在jsp中展现
		request.setAttribute("orderList", orderList);
		try {
			response.getWriter().print(SystemUtil.request(0, orderList, ""));
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * 订单保存的方法
	 * @param Order
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/save.do")
	public String save(@ModelAttribute Order order,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "保存成功";
		try {
			orderService.save(order);
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
	 * 管理员页面修改订单的方法
	 * @param Order
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/update.do")
	public String update(@ModelAttribute Order order,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "修改成功";
		try {
			orderService.update(order);
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
	 * 删除订单的方法
	 * @param Order
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/del.do")
	public String del(@ModelAttribute Order order,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg =  "删除成功!";
		try {
			orderService.delete(order);
		} catch (Exception e) {
			code = 1;
			msg = "删除失败";
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, null, msg));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
	
	@RequestMapping("/get.do")
	public String get(Long id,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		Order order = null;
		try {
			order = orderService.findById(id);
		} catch (Exception e) {
			code = 1;
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, order, null));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
	
	/**
	 * 场馆预约的方法
	 * @param Order
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/approve.do", method = RequestMethod.POST, consumes = "application/json")
	public String save(@RequestBody List<GymOrderBean> list,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg = "预约成功";
		Long id = null;
		try {
			User user = (User) request.getSession().getAttribute("user");
			if(user==null){
				code = 1;
				msg = "请先登录";
			}else{
				id = orderService.approve(list,user);
			}
		} catch (Exception e) {
			code = 1;
			msg = "预约失败";
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, Arrays.asList(id), msg));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
	
	/**
	 * 获取场馆预约信息
	 * @param Order
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/info.do", method = RequestMethod.GET)
	public String save(HttpServletRequest request,
			HttpServletResponse response,Long orderId){
		int code = 0;
		String msg = "查询成功";
		List<GymOrderBean> list = new ArrayList<GymOrderBean>();
		try {
			list = this.orderService.getInfo(orderId);
		} catch (Exception e) {
			code = 1;
			msg = "查询失败";
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, list, msg));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;		
	}
	
	/**
	 * 获取订单二维码
	 * @param Order
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/qcImage.do", method = RequestMethod.GET)
	public String qcImage(HttpServletRequest request,
			HttpServletResponse response,Long orderId){
		try {
			Order order = this.orderService.findById(orderId);
			new QRCodeFactory().CreatQrStream(order.getKey(), "png", response.getOutputStream(),null, 300);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;		
	}
	
	/**
	 * 退款的方法
	 * @param Order
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/refund.do")
	@ResponseBody
	public String refund(Long id,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg =  "退款成功!";
		try {
			Order order = this.orderService.findById(id);
			if(order!=null) {
				List<GymOrderBean> data = JSONArray.toList(JSONArray.fromObject(order.getGymData()),GymOrderBean.class);
				GymOrderBean o = data.get(0);
				Date now = new Date();
				Long nowHour = Long.valueOf(new SimpleDateFormat("HH").format(now));
				if(new SimpleDateFormat("yyyy-MM-dd").format(now).equals(order.getOnDay()) && Long.valueOf(o.getTime().substring(0, 2))-nowHour<=1) {
					return SystemUtil.request(1, Arrays.asList(id), "距开场不足一小时,不允许退款!").toString();
				}
				order.setStatus(Order.REFUND);
				this.orderService.update(order);
			}
		} catch (Exception e) {
			code = 1;
			msg = "退款失败";
			e.printStackTrace();
		}
		
		return SystemUtil.request(code, Arrays.asList(id), msg).toString();
	}
	
	
	/**
	 * 退款的方法
	 * @param Order
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/export.do")
	@ResponseBody
	public String export(Long id,HttpServletRequest request,
			HttpServletResponse response){
		int code = 0;
		String msg =  "退款成功!";
		try {
			List<Order> order = this.orderService.find7Refund();
			for (Order o : order) {
				List<GymOrderBean> list = JSONArray.toList(JSONArray.fromObject(o.getGymData()),GymOrderBean.class);
				GymOrderBean bean = list.get(0);
				String data = bean.getTime();
				o.setGymData(data.substring(0, 2)+":"+data.substring(2,4)+" - "+data.substring(4,6)+":"+data.substring(6,8));
			}
			String[] dataFields = new String[]{"id","ucode","userName","onDay","gymData","allMoney"};
			String[] columns = new String[]{"订单编号","用户唯一标识","用户名称","预约日期","预约时间","付款金额"};
			
			response.setContentType("application/x-download");
	        response.setCharacterEncoding("UTF-8");  
	        response.setHeader("Content-Disposition", "attachment; filename=order.xlsx");  
	        
			poiService.exportExcel(order, dataFields,response.getOutputStream(), columns, "yyyy-MM-dd");
			
		} catch (Exception e) {
			code = 1;
			msg = "退款失败";
			e.printStackTrace();
		}
		
		return SystemUtil.request(code, Arrays.asList(id), msg).toString();
	}
}
