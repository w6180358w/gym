package com.service.inter;

import java.util.List;
import java.util.Map;

import com.model.Gym;

public interface GymService {

	public List<Gym> getAll();
	
	public Gym findById(Long id);
	
	public void save(Gym gym);
	
	public void update(Gym gym);
	
	public void delete(Gym gym);
	
	public List<Gym> nameValid(Gym gym);
	
	public Map<String,Object> getData(String onDay,Long gymId);
	
	public List<Gym> findByType(String type);
}
