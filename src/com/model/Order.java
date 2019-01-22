package com.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.model.base.BaseModel;
/**
 * 用户表
 * @author 段宝丹
 *
 */
@Entity
@Table(name = "gym_order")
public class Order extends BaseModel{

	public final static Integer PAYMENT = 1;
	public final static Integer SUCCESS = 2;
	public final static Integer FAILURE = 3;
	public final static Integer EXPIRE = 4;
	public final static Integer REFUND = 5;
	
	public final static Integer PAY_FAILURE = 1;
	public final static Integer PAY_SUCCESS = 2;
	
	public final static String PAY_SUCCESS_STR = "success";
	public final static String PAY_FAILURE_STR = "failure";
	
	private Long id;		//id
	private String gymData;	//预约场地JSON [{gymId:1,time:[1,2,3,4]},{...}]
	private Integer status;	//状态 1:正在付款 2:已预定3:付款失败4:超时 5.已退款
	private String key; 	//付款url
	private String ucode;	//用户唯一标识
	private String userName;//用户名称
	private String onDay;	//预约日期
	private Long allMoney;	//预付价格 预约时间*单位时间价格
	private Date orderTime;	//订单申请时间
	private Date endTime;		//订单完成时间
	private Integer payStatus;//付款状态1:成功 2:失败
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	@Column(name = "gym_data")
	public String getGymData() {
		return gymData;
	}
	public void setGymData(String gymData) {
		this.gymData = gymData;
	}
	@Column(name = "status")
	public Integer getStatus() {
		return status;
	}
	@Transient 
	public String getStatusName(){
		if(Order.PAYMENT.equals(status)){
			return "付款中";
		}
		if(Order.SUCCESS.equals(status)){
			return "预约成功";
		}
		if(Order.FAILURE.equals(status)){
			return "预约失败";
		}
		if(Order.EXPIRE.equals(status)){
			return "付款超时";
		}
		if(Order.REFUND.equals(status)){
			return "已退款";
		}
		return "未知";
	}
	@Transient 
	public String getPayStatusName(){
		if(Order.PAY_SUCCESS.equals(payStatus)){
			return "付款成功";
		}
		if(Order.PAY_FAILURE.equals(payStatus)){
			return "付款失败";
		}
		return "未知";
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	@Column(name = "wechat_key")
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	@Column(name = "user_code")
	public String getUcode() {
		return ucode;
	}
	public void setUcode(String ucode) {
		this.ucode = ucode;
	}
	@Column(name = "user_name")
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	@Column(name = "order_time")
	public Date getOrderTime() {
		return orderTime;
	}
	public void setOrderTime(Date orderTime) {
		this.orderTime = orderTime;
	}
	@Column(name = "all_money")
	public Long getAllMoney() {
		return allMoney;
	}
	public void setAllMoney(Long allMoney) {
		this.allMoney = allMoney;
	}
	@Column(name = "end_time")
	public Date getEndTime() {
		return endTime;
	}
	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
	@Column(name = "on_day")
	public String getOnDay() {
		return onDay;
	}
	public void setOnDay(String onDay) {
		this.onDay = onDay;
	}
	@Column(name = "pay_status")
	public Integer getPayStatus() {
		return payStatus;
	}
	public void setPayStatus(Integer payStatus) {
		this.payStatus = payStatus;
	}

	
	public static Integer toPayStatus(String status) {
		if(Order.PAY_SUCCESS_STR.equals(status)) {
			return Order.PAY_SUCCESS;
		}else {
			return Order.PAY_FAILURE;
		}
	}
	
	/**
	 * 设置订单状态  如果付款状态为成功  设置订单状态为已预约  否则设置为预约失败
	 * @return
	 */
	public void toStatus() {
		if(Order.PAY_SUCCESS.equals(this.getPayStatus())) {
			this.setStatus(Order.SUCCESS);
		}else {
			this.setStatus(Order.FAILURE);
		}
	}
}
