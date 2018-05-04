package com.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import com.model.base.BaseModel;
/**
 * 用户表
 * @author 段宝丹
 *
 */
@Entity
@Table(name = "pause")
public class Pause extends BaseModel{

	private Long id;		//id
	private String day;		//姓名
	private Long gymId;	//描述
	private String pauseTime;	//暂停时间[0,1,2,3...] 0-23的数组 一个数字代表一个小时  0表示0点-1点 1表示1点-2点以此类推
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	@Column(name = "day")
	public String getDay() {
		return day;
	}
	public void setDay(String day) {
		this.day = day;
	}
	@Column(name = "gym_id")
	public Long getGymId() {
		return gymId;
	}
	public void setGymId(Long gymId) {
		this.gymId = gymId;
	}
	@Column(name = "pause_time")
	public String getPauseTime() {
		return pauseTime;
	}
	public void setPauseTime(String pauseTime) {
		this.pauseTime = pauseTime;
	}
	
}
