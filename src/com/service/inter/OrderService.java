package com.service.inter;

import java.util.List;

import com.bean.GymOrderBean;
import com.model.Order;

public interface OrderService {

	public List<Order> getAll();
	
	public Order findById(Long id);
	
	public void save(Order order);
	
	public void update(Order order);
	
	public void delete(Order order);
	
	public void approve(List<GymOrderBean> list);
	
	public List<Order> findByGymId(Long gymId);
}
