package com.service.inter;

import java.util.List;

import com.model.User;

public interface UserService {

	public List<User> getAll();
	
	public User findById(Long id);
	
	public void save(User user);
	
	public void update(User user);
	
	public void delete(User user);
	
	public User login(String ucode,String password);
	
	public List<User> codeValid(User user);
	
}
