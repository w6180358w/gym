package com.controller;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.model.Order;
import com.model.User;
import com.service.inter.OrderService;
import com.util.SystemUtil;

@Controller
@RequestMapping("/callBack")
public class CallbackController {
	@Autowired
	OrderService orderService;
	
	/**
	 * @api {post} /callBack/login.do 1.登陆回调，自动跳转到首页
	 * @apiName login
	 * @apiGroup callBack
	 * 
	 * @apiParam {String} ucode 账号
	 * @apiParam {String} name 姓名
	 * 
	 * @apiHeaderExample {form} Header-Example:
	 *     {
	 *       "Content-Type": "application/x-www-form-urlencoded"
	 *     }
	 * @apiParamExample {application/x-www-form-urlencoded} Request-Example:
		{
			"ucode" : "xxx",
			"name" : "xxx"
		}
	 * 
	 */
	@RequestMapping("/login.do")
	public String login(HttpServletRequest request,
			HttpServletResponse response,User user){
		try {
			user.setType(SystemUtil.USER);
			request.getSession().setAttribute("user", user);
			request.getSession().setAttribute("code", true);
			response.sendRedirect(request.getContextPath()+"/index.jsp");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * @api {post} /callBack/order.do 2.订单付款回调
	 * @apiName order
	 * @apiGroup callBack
	 * 
	 * @apiParam {String} id 订单ID
	 * @apiHeaderExample {form} Header-Example:
	 *     {
	 *       "Content-Type": "application/x-www-form-urlencoded"
	 *     }
	 * @apiParamExample {application/x-www-form-urlencoded} Request-Example:
	 *	{"id" : "xxx"}
	 * 
	 * @apiSuccess {Number} code 0:失败，1:成功
	 * @apiSuccess {String} msg 操作提示
	 * 
	 * @apiSuccessExample {json} Success-Response:
	 * 	{
	 *		"code": 0,
	 *		"msg": "更新成功"
	 *	}	
	 *	@apiErrorExample {json} Error-Response:
	 * 	{
	 * 		"code":1,
	 * 		"msg":"更新失败，订单【1】不存在!"
	 *  }
	 */
	@RequestMapping("/order.do")
	public String order(HttpServletRequest request,
			HttpServletResponse response,String id){
		int code = 0;
		String msg = "更新成功";
		try {
			if(!StringUtils.isEmpty(id)) {
				Order order = this.orderService.findById(Long.parseLong(id));
				if(order!=null) {
					order.setStatus(Order.SUCCESS);
					order.setEndTime(new Date());
					this.orderService.update(order);
				}else {
					code = 1;
					msg = "更新失败，订单【"+id+"】不存在!";
					response.setStatus(500);
				}
			}else {
				code = 1;
				msg = "更新失败，订单【"+id+"】不存在!";
				response.setStatus(500);
			}
		} catch (Exception e) {
			code = 1;
			msg = "系统错误,请联系管理员!";
			e.printStackTrace();
		}
		
		try {
			response.getWriter().print(SystemUtil.request(code, msg));
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return null;
	}
}
