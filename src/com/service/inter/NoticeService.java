package com.service.inter;

import java.util.List;

import com.model.Notice;

public interface NoticeService {

	public List<Notice> getAll();
	
	public Notice findById(Long id);
	
	public void save(Notice notice);
	
	public void update(Notice notice);
	
	public void delete(Notice notice);
	
	public List<Notice> load();

}
