package com.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.dao.base.impl.BaseDaoImpl;
import com.dao.inter.OrderDao;
import com.model.Order;
@Repository
public class OrderDaoImpl extends BaseDaoImpl<Order> implements OrderDao{

	@Override
	public List<Order> findByDay(String date) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		try {
			cal.setTime(sdf.parse(date));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		String start = sdf.format(cal.getTime());
		cal.add(Calendar.DAY_OF_YEAR, 1);
		
		String end = sdf.format(cal.getTime());
		return this.findList("from Order where onDay >= ? and onDay <? and status < 3",start,end);
	}

}
