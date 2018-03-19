package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.inter.OrderDao;
import com.model.Order;
import com.service.inter.OrderService;

@Service("OrderService")
public class OrderServiceImpl implements OrderService{
	
	@Autowired
	OrderDao orderDao;
	@Override
	public List<Order> getAll() {
		return orderDao.findAll();
	}

	@Override
	public Order findById(Long id) {
		return orderDao.findById(id);
	}

	@Override
	public void save(Order order) {
		this.orderDao.save(order);
	}

	@Override
	public void update(Order order) {
		this.orderDao.update(order);
	}

	@Override
	public void delete(Order order) {
		this.orderDao.delete(order);
	}

}
