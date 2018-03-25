package com.service.inter;

import java.util.List;

import com.model.GymType;

public interface GymTypeService {

	public List<GymType> getAll();
	
	public GymType findById(Long id);
	
	public void save(GymType gymType);
	
	public void update(GymType gymType);
	
	public void delete(GymType gymType);
	
	public List<GymType> nameValid(GymType gymType);
}
