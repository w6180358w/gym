package com.service.inter;

import java.util.List;

import com.model.Message;

public interface MessageService {

	public List<Message> getAll();
	
	public Message findById(Long id);
	
	public void save(Message message);
	
	public void delete(Message message);

	public void read(List<Message> messageList);
	
	public List<Message> loadMessage();
}
