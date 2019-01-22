package com.dao.inter;

import java.util.List;

import com.dao.base.inter.BaseDao;
import com.model.Order;

public interface OrderDao extends BaseDao<Order>{

	public List<Order> findByDay(String date);
	
	/**
	 * 获取7天内的退款订单
	 * @return
	 */
	public List<Order> find7Refund();
}
