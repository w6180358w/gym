package com.dao.inter;

import java.util.List;

import com.dao.base.inter.BaseDao;
import com.model.Order;

public interface OrderDao extends BaseDao<Order>{

	public List<Order> findByDay(String date);
}
