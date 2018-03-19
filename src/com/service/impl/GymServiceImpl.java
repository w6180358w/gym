package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.inter.GymDao;
import com.model.Gym;
import com.service.inter.GymService;

@Service("GymService")
public class GymServiceImpl implements GymService{
	
	@Autowired
	GymDao gymDao;
	@Override
	public List<Gym> getAll() {
		// TODO Auto-generated method stub
		return gymDao.findAll();
	}

	@Override
	public Gym findById(Long id) {
		// TODO Auto-generated method stub
		return gymDao.findById(id);
	}

	@Override
	public void save(Gym gym) {
		this.gymDao.save(gym);
	}

	@Override
	public void update(Gym gym) {
		this.gymDao.update(gym);
	}

	@Override
	public void delete(Gym gym) {
		this.gymDao.delete(gym);
	}

	@Override
	public List<Gym> nameValid(Gym gym) {
		return this.gymDao.findList("from Gym where name = '"+gym.getName()+"' and id !="+gym.getId());
	}

}
