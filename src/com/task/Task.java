package com.task;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.model.Order;
import com.service.inter.OrderService;

@Component
public class Task {
	
	@Value("${expire.time:15}")
	private Integer expire;
	@Autowired
	private OrderService orderService;
	
	//订单15分钟超时 设置为付款失败状态
	@Scheduled(cron = "0 0/1 * * * ? ") // 间隔一分钟执行
	public void syncOrder() {
		System.out.println("定时更新订单状态，超过"+expire+"分钟设置为付款超时");
		List<Order> orderList = this.orderService.findByStatus(Order.PAYMENT);
		Long now = System.currentTimeMillis();
		for (Order order : orderList) {
			Date date = order.getOrderTime();
			if(now-date.getTime()>(expire*60*1000)) {
				order.setStatus(Order.EXPIRE);
				this.orderService.update(order);
			}
		}
	}
}
