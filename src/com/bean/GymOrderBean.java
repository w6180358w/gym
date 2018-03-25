package com.bean;

public class GymOrderBean {

	private Long gymId;
	
	private String time;
	
	private String gymName;
	
	private String day;

	private Long money;
	
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
}
