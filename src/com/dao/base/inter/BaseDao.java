package com.dao.base.inter;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

import com.model.base.BaseModel;

public abstract interface BaseDao<T extends BaseModel> {
	/**
	 * 查询所有
	 * @return
	 */
	public abstract List<T> findAll();
	/**
	 * 排序
	 * @param orderHql
	 * @return
	 */
	public List<T> findAllInOrder(String orderHql);
	/**
	 * 根据ID查询
	 * @param id
	 * @return
	 */
	public abstract T findById(Serializable id);
	/**
	 * 根据hql查询
	 * @param hql
	 * @return
	 */
	public abstract List<T> findList(String hql);
	
	/**
	 * 根据hql查询
	 * @param hql
	 * @return
	 */
	public abstract List<?> findListObject(String hql);
	
	/**
	 * 分页查询
	 * @param hql
	 * @param page
	 * @param size
	 * @return
	 */
	public abstract List<T> pageList(String hql , String page,String size);
	/**
	 * 保存
	 * @param t
	 * @return
	 */
	public abstract Serializable save(T t);
	/**
	 * 更新
	 * @param t
	 */
	public abstract void update(T t);
	/**
	 * 保存或更新单个
	 * @param t
	 */
	public abstract void saveOrUpdate(T t);
	/**
	 * 保存或更新多个
	 * @param collections
	 */
	public abstract void saveOrUpdateAll(Collection<T> collections);
	/**
	 * 删除多个
	 * @param collections
	 */
	public abstract void delete(Collection<T> collections);
	
	/**
	 * 删除单个
	 * @param t
	 */
	public abstract void delete(T t);
	
	/**
	 * 删除所有
	 * @return
	 */
	public abstract int deleteAll();
	/**
	 * 查询表中个数
	 * @return
	 */
	public abstract long getCount();
	
	/**
	 * 执行hql
	 * @param hql
	 * @return
	 */
	public abstract int executeHql(String hql);
}
