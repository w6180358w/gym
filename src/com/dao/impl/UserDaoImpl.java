package com.dao.impl;

import org.springframework.stereotype.Repository;

import com.dao.base.impl.BaseDaoImpl;
import com.dao.inter.UserDao;
import com.model.User;
@Repository
public class UserDaoImpl extends BaseDaoImpl<User> implements UserDao{

}
