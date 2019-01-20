package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.inter.GymTypeDao;
import com.dao.inter.OrderDao;
import com.model.GymType;
import com.service.inter.GymTypeService;

@Service("GymTypeService")
public class GymTypeServiceImpl implements GymTypeService{
	
	@Autowired
	GymTypeDao GymTypeDao;
	@Autowired
	OrderDao orderDao;
	
	@Override
	public List<GymType> getAll() {
		return GymTypeDao.findAll();
	}

	@Override
	public GymType findById(Long id) {
		return GymTypeDao.findById(id);
	}

	@Override
	public void save(GymType gymType) {
		this.GymTypeDao.save(gymType);
	}

	@Override
	public void update(GymType gymType) {
		this.GymTypeDao.update(gymType);
	}

	@Override
	public void delete(GymType gymType) {
		this.GymTypeDao.delete(gymType);
	}

	@Override
	public List<GymType> nameValid(GymType gymType) {
		return this.GymTypeDao.findList("from GymType where name = ? and id !=?",gymType.getName(),gymType.getId());
	}

}
