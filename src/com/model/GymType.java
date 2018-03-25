package com.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import com.model.base.BaseModel;
@Entity
@Table(name = "gym_type")
public class GymType extends BaseModel{

	private Long id;		//id
	private String name;	//名称
	private String desc;	//描述

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
	@Column(name = "description")
	public String getDesc() {
		return desc;
	}
	public void setDesc(String desc) {
		this.desc = desc;
	}
}
