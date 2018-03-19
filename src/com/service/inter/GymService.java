package com.service.inter;

import java.util.List;

import com.model.Gym;

public interface GymService {

	public List<Gym> getAll();
	
	public Gym findById(Long id);
	
	public void save(Gym gym);
	
	public void update(Gym gym);
	
	public void delete(Gym gym);
	
	public List<Gym> nameValid(Gym gym);
	
}
