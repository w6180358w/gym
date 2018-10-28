package com.controller;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.bean.CallBackBean;
import com.model.Order;
import com.model.User;
import com.service.inter.OrderService;
import com.util.HttpClientTool;
import com.util.SystemUtil;

import net.sf.json.JSONObject;

@Controller
@RequestMapping("/callBack")
public class CallbackController {
	@Autowired
	OrderService orderService;
	
	@Value("${login.url.info}")
	private String info;
	
	@Value("${login.accesskey}")
	private String accesskey;
	
	@Value("${login.consid}")
	private String consid;
	
	/**
	 * @api {get} /callBack/login.do 1.登陆回调，自动跳转到首页
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
	public ModelAndView login(HttpServletRequest request,
			HttpServletResponse response,CallBackBean bean){
		Boolean success = true;
		String errorMsg = "第三方登陆成功!";
		try {
			if("0".equals(bean.getCode())) {
				Map<String,String> params = new HashMap<String, String>();
				Long now = System.currentTimeMillis()/1000;
				String md5 = DigestUtils.md5DigestAsHex((this.accesskey+now+bean.getConsuserid()+"123456").getBytes());
				params.put("sign", md5);
				params.put("consid", consid);
				params.put("consuserid", bean.getConsuserid());
				params.put("rand", "123456");
				params.put("timestamp", now+"");
				System.out.println("-------------callBack-doGet------------");
				String result = HttpClientTool.doGet(info, params);
				System.out.println("callBack-doGet-result:"+result);
				System.out.println("-------------callBack-doGet------------");
				//组装对象
				JSONObject json = JSONObject.fromObject(result);
				if(json.containsKey("code")) {
					if(json.getString("code").equals("0")) {
						JSONObject userInfo = json.getJSONObject("userinfo");
						User user = new User();
						user.setType(SystemUtil.USER);
						user.setUcode(userInfo.getString("consuserid"));
						user.setName(userInfo.getString("username"));
						request.getSession().setAttribute("user", user);
						request.getSession().setAttribute("code", true);
					}else {
						success = false;
						errorMsg = json.getString("message");
					}
				}else {
					success = false;
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
			success = false;
			errorMsg = "系统错误,请联系管理员!";
		}
		request.setAttribute("third-login", success);
		request.setAttribute("third-login-msg", errorMsg);
		return new ModelAndView("thirdLogin");
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
