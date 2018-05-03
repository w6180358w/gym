package com.dao.impl;

import org.springframework.stereotype.Repository;

import com.dao.base.impl.BaseDaoImpl;
import com.dao.inter.MessageDao;
import com.model.Message;
@Repository
public class MessageDaoImpl extends BaseDaoImpl<Message> implements MessageDao{

}
