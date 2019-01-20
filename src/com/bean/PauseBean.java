package com.bean;

/**
 * 暂停预约bean
 * @author zhangxy
 *
 */
public class PauseBean {

	private String start;	//场次开始时间
	private String end;		//场次结束时间
	private String timeId;	//场次ID
	private String status;	//是否暂停
	private Long id;		//暂停对象ID
	private Long gymId;	//场馆ID
	
	public String getStart() {
		return start;
	}
	public void setStart(String start) {
		this.start = start;
	}
	public String getEnd() {
		return end;
	}
	public void setEnd(String end) {
		this.end = end;
	}
	public String getTimeId() {
		return timeId;
	}
	public void setTimeId(String timeId) {
		this.timeId = timeId;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getGymId() {
		return gymId;
	}
	public void setGymId(Long gymId) {
		this.gymId = gymId;
	}
	
}
