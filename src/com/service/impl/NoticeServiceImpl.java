package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.inter.NoticeDao;
import com.model.Notice;
import com.service.inter.NoticeService;

@Service("NoticeService")
public class NoticeServiceImpl implements NoticeService{
	
	@Autowired
	NoticeDao noticeDao;
	
	@Override
	public List<Notice> getAll() {
		return noticeDao.findAll();
	}

	@Override
	public Notice findById(Long id) {
		return noticeDao.findById(id);
	}

	@Override
	public void save(Notice notice) {
		this.noticeDao.save(notice);
	}

	@Override
	public void update(Notice notice) {
		this.noticeDao.update(notice);
	}

	@Override
	public void delete(Notice notice) {
		this.noticeDao.delete(notice);
	}

	@Override
	public List<Notice> load() {
		return this.noticeDao.findList("from Notice where status=1 order by createTime");
	}

}
