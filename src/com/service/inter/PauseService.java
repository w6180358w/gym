package com.service.inter;

import java.util.List;

import com.model.Pause;

public interface PauseService {

	public void save(Pause Pause);
	
	public void update(Pause Pause);
	
	public List<Pause> findData(String day);
	
	public Pause getData(Long gymId,String day);
}
