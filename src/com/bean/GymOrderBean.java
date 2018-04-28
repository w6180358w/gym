package com.bean;

public class GymOrderBean {

	private Long gymId;		//场馆ID
	
	private String time;	//预约时间（小时）
	
	private String gymName;	//场馆名称
	
	private String day;		//预约日期
	
	private Long money;		//场馆单位时间金额
	
	private Long paymoney;	//应付金额
	
	public Long getGymId() {
		return gymId;
	}

	public void setGymId(Long gymId) {
		this.gymId = gymId;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getDay() {
		return day;
	}

	public void setDay(String day) {
		this.day = day;
	}

	public String getGymName() {
		return gymName;
	}

	public void setGymName(String gymName) {
		this.gymName = gymName;
	}

	public Long getMoney() {
		return money;
	}

	public void setMoney(Long money) {
		this.money = money;
	}

	public Long getPaymoney() {
		return paymoney;
	}

	public void setPaymoney(Long paymoney) {
		this.paymoney = paymoney;
	}
	
}
