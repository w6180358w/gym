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
@Table(name = "user")
public class User extends BaseModel{

	private Long id;		//id
	private String name;	//姓名
	private String addTime;	//加入时间
	private String rec;//推荐人
	private Integer vip;	//是否为vip 0:否 1：是
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	@Column(name = "name")
	public String getName() {
		return name==null?"":name;
	}
	public void setName(String name) {
		this.name = name;
	}
	@Column(name = "add_time")
	public String getAddTime() {
		return addTime==null?"":addTime;
	}
	public void setAddTime(String addTime) {
		this.addTime = addTime;
	}
	@Column(name = "rec")
	public String getRec() {
		return rec==null?"":rec;
	}
	public void setRec(String rec) {
		this.rec = rec;
	}
	@Column(name = "vip")
	public Integer getVip() {
		return vip==null?0:vip;
	}
	public void setVip(Integer vip) {
		this.vip = vip;
	}
	
}
