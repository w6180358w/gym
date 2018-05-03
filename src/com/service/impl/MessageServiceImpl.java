package com.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.inter.MessageDao;
import com.model.Message;
import com.service.inter.MessageService;

@Service("MessageService")
public class MessageServiceImpl implements MessageService{
	
	@Autowired
	MessageDao messageDao;
	
	@Override
	public List<Message> getAll() {
		return messageDao.findAll();
	}

	@Override
	public Message findById(Long id) {
		return messageDao.findById(id);
	}

	@Override
	public void save(Message message) {
		this.messageDao.save(message);
	}
	
	@Override
	public void delete(Message message) {
		this.messageDao.delete(message);
	}

	@Override
	public void read(List<Message> messageList) {
		for (Message message : messageList) {
			message.setStatus(1);
			this.messageDao.update(message);
		}
	}

	@Override
	public List<Message> loadMessage() {
		return this.messageDao.findList("from Message where status=0");
	}

}
