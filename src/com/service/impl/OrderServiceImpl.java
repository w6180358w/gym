package com.service.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bean.GymOrderBean;
import com.dao.inter.OrderDao;
import com.model.Order;
import com.model.User;
import com.service.inter.OrderService;

import net.sf.json.JSONArray;

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

	@Override
	public void approve(List<GymOrderBean> list,User user) {
		Order order = new Order();
		Long allMoney = 0l;
		for (GymOrderBean bean : list) {
			allMoney+= bean.getPaymoney();
		}
		order.setAllMoney(allMoney);
		order.setOnDay(list.get(0).getDay());
		order.setOrderTime(new Date());
		order.setGymData(JSONArray.fromObject(list).toString());
		order.setUcode(user.getUcode());
		order.setUserName(user.getName());
		order.setStatus(Order.PAYMENT);
		this.orderDao.save(order);
	}
	

	@Override
	public List<Order> findByGymId(Long gymId) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String hql = "from Order where onDay >= '"+sdf.format(Calendar.getInstance().getTime())+"' and gym_data like '%\"gymId\":"+gymId+"%' and status != 3";
		return this.orderDao.findList(hql);
	}

	@Override
	public List<GymOrderBean> getInfo(Long orderId) {
		Order order = this.orderDao.findById(orderId);
		return JSONArray.toList(JSONArray.fromObject(order.getGymData()), GymOrderBean.class);
	}

	@Override
	public List<Order> findByUcode(String ucode) {
		String hql = "from Order where ucode = '"+ucode+"'";
		return this.orderDao.findList(hql);
	}
}
