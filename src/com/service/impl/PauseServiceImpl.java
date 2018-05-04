package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.inter.OrderDao;
import com.dao.inter.PauseDao;
import com.model.Pause;
import com.service.inter.PauseService;

@Service("PauseService")
public class PauseServiceImpl implements PauseService{
	
	@Autowired
	PauseDao pauseDao;
	@Autowired
	OrderDao orderDao;
	
	@Override
	public void save(Pause Pause) {
		this.pauseDao.save(Pause);
	}

	@Override
	public void update(Pause Pause) {
		this.pauseDao.update(Pause);
	}

	@Override
	public List<Pause> findData(String day) {
		String hql = "from Pause where day ='"+day+"'";
		return this.pauseDao.findList(hql);
	}

	@Override
	public Pause getData(Long gymId, String day) {
		String hql = "from Pause where gymId = "+gymId+" and day ='"+day+"'";
		List<Pause> list = this.pauseDao.findList(hql);
		if(list!=null && !list.isEmpty()) {
			return list.get(0);
		}
		return null;
	}

}
