package com.dao.base.impl;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.dao.base.inter.BaseDao;
import com.model.base.BaseModel;

public class BaseDaoImpl<T extends BaseModel> extends HibernateDaoSupport implements BaseDao<T>{
	
	protected final Class<T> clazz;
	
	@SuppressWarnings("unchecked")
	public BaseDaoImpl(){
		this.clazz = ((Class<T>)((java.lang.reflect.ParameterizedType)getClass()
			      .getGenericSuperclass()).getActualTypeArguments()[0]);
	}
	
	@Override
	public List<T> findAll() {
	    return findAllInOrder(null);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<T> findAllInOrder(String orderHql){
		if (this.clazz == null)
			return new ArrayList();
	    String hql = "from " + this.clazz.getName();
	    if(orderHql!=null && !"".equals(orderHql))
	    	hql += " order by "+orderHql;
	    return getHibernateTemplate().find(hql);
	}

	@Override
	public T findById(Serializable id) {
		return id == null ? null : (T)getHibernateTemplate().get(this.clazz, id);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<T> findList(String hql) {
		return getHibernateTemplate().find(hql);
	}

	@Override
	public List<?> findListObject(String hql) {
		return getHibernateTemplate().find(hql);
	}
	
	@Override
	public List<T> pageList(String hql, String page, String size) {
		return null;
	}

	@Override
	public Serializable save(T t) {
		return getHibernateTemplate().save(t);
	}

	@Override
	public void update(T t) {
		if (t == null)
		      return;
		getHibernateTemplate().update(t);
	}

	@Override
	public void saveOrUpdate(T t) {
		if (t == null)
		      return;
		getHibernateTemplate().saveOrUpdate(t);
	}

	@Override
	public void saveOrUpdateAll(Collection<T> collections) {
		if(collections==null || collections.size()<1)
			return;
		getHibernateTemplate().saveOrUpdateAll(collections);
	}

	@Override
	public void delete(Collection<T> collections) {
		if(collections==null || collections.size()<1)
			return;
		getHibernateTemplate().deleteAll(collections);
	}

	@Override
	public void delete(T t) {
		if(t==null)
			return;
		getHibernateTemplate().delete(t);
	}

	@Override
	public int deleteAll() {
		String hql = "delete from " + this.clazz.getName();
	    return getHibernateTemplate().bulkUpdate(hql);
	}

	@SuppressWarnings("rawtypes")
	@Override
	public long getCount() {
		String hql = "select count(*) from " + this.clazz.getName();
		List list = findList(hql);
		return ((Long)list.get(0)).longValue();
	}

	@Override
	public int executeHql(String hql) {
		return getHibernateTemplate().bulkUpdate(hql);
	}
}
