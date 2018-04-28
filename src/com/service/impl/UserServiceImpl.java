package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.inter.UserDao;
import com.model.User;
import com.service.inter.UserService;

@Service("userService")
public class UserServiceImpl implements UserService{
	
	@Autowired
	UserDao userDao;
	@Override
	public List<User> getAll() {
		return userDao.findAll();
	}

	@Override
	public User findById(Long id) {
		return userDao.findById(id);
	}

	@Override
	public void save(User user) {
		this.userDao.save(user);
	}

	@Override
	public void update(User user) {
		this.userDao.update(user);
	}

	@Override
	public void delete(User user) {
		this.userDao.delete(user);
	}

	@Override
	public User login(String ucode, String password) {
		List<User> userList = this.userDao.findList("from User where ucode='"+ucode+"' and password='"+password+"'");
		if(userList==null || userList.isEmpty()){
			return null;
		}
		return userList.get(0);
	}

	@Override
	public List<User> codeValid(User user) {
		return this.userDao.findList("from User where ucode = '"+user.getUcode()+"' and id !="+user.getId());
	}

}
