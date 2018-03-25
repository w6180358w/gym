package com.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bean.GymOrderBean;
import com.dao.inter.GymDao;
import com.dao.inter.OrderDao;
import com.model.Gym;
import com.model.Order;
import com.service.inter.GymService;

import net.sf.json.JSONArray;

@Service("GymService")
public class GymServiceImpl implements GymService{
	
	@Autowired
	GymDao gymDao;
	@Autowired
	OrderDao orderDao;
	
	@Override
	public List<Gym> getAll() {
		return gymDao.findAll();
	}

	@Override
	public Gym findById(Long id) {
		return gymDao.findById(id);
	}

	@Override
	public void save(Gym gym) {
		this.gymDao.save(gym);
	}

	@Override
	public void update(Gym gym) {
		this.gymDao.update(gym);
	}

	@Override
	public void delete(Gym gym) {
		this.gymDao.delete(gym);
	}

	@Override
	public List<Gym> nameValid(Gym gym) {
		return this.gymDao.findList("from Gym where name = '"+gym.getName()+"' and id !="+gym.getId());
	}

	@SuppressWarnings({ "unchecked", "deprecation" })
	@Override
	public Map<String, Object> getData(String onDay,Long gymId) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("gym", getByParam(null, gymId));
		List<Order> orderList = this.orderDao.findByDay(onDay);
		Map<String,Integer> map = new HashMap<String, Integer>();
		for (Order o : orderList) {
			List<GymOrderBean> beans = JSONArray.toList(JSONArray.fromObject(o.getGymData()), GymOrderBean.class);
			for (GymOrderBean bean : beans) {
				String[] times = bean.getTime().split(",");
				for (String time : times) {
					map.put(bean.getGymId()+"-"+time,o.getStatus());
				}
			}
		}
		result.put("order", map);
		return result;
	}

	private List<Gym> getByParam(String type,Long gymId){
		List<Gym> list = new ArrayList<Gym>();
		if(gymId!=null) {
			Gym gym= this.findById(gymId);
			if(gym!=null ) {
				list.add(gym);
			}
			return list;
		}
		if(type!=null) {
			return this.findByType(type);
		}
		return this.getAll();
	}

	@Override
	public List<Gym> findByType(String type) {
		return this.gymDao.findList("from Gym where type = "+type);
	}
}
