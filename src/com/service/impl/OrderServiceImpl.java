package com.service.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.bean.GymOrderBean;
import com.dao.inter.OrderDao;
import com.model.Order;
import com.model.User;
import com.service.inter.OrderService;
import com.util.HttpClientTool;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("OrderService")
public class OrderServiceImpl implements OrderService{
	
    @Value("${pay.url}")
    private String payUrl;
    
	@Autowired
	OrderDao orderDao;
	@Override
	public List<Order> getAll() {
		return orderDao.findAllInOrder(" orderTime desc ");
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
	public Long approve(List<GymOrderBean> list,User user) throws Exception {
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
		order.setKey(this.getPayUrl(order));
		return order.getId();
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
		String hql = "from Order where ucode = '"+ucode+"' order by orderTime desc";
		return this.orderDao.findList(hql);
	}
	/**
	 * 生成付款的url
	 * @return
	 */
	private String getPayUrl(Order order) throws Exception{
		String result = null;
		Map<String,String> params = new HashMap<String,String>();
		try {
			params.put("id", order.getId()+"");
			params.put("amount", order.getAllMoney()+"");
			String content = HttpClientTool.doPost(payUrl, params);
			JSONObject json = JSONObject.fromObject(content);
			result = json.getString("url");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public List<Order> findByStatus(Integer status) {
		return this.orderDao.findList("from Order where status = "+status);
	}
}
