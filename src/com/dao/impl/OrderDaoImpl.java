package com.dao.impl;

import org.springframework.stereotype.Repository;

import com.dao.base.impl.BaseDaoImpl;
import com.dao.inter.OrderDao;
import com.model.Order;
@Repository
public class OrderDaoImpl extends BaseDaoImpl<Order> implements OrderDao{

}
