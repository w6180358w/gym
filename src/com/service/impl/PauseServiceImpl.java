package com.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bean.PauseBean;
import com.dao.inter.GymDao;
import com.dao.inter.OrderDao;
import com.dao.inter.PauseDao;
import com.model.Gym;
import com.model.Pause;
import com.service.inter.PauseService;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Service("PauseService")
public class PauseServiceImpl implements PauseService{
	
	@Autowired
	PauseDao pauseDao;
	@Autowired
	OrderDao orderDao;
	@Autowired
	GymDao gymDao;
	
	@Override
	public void save(Pause Pause) {
		this.pauseDao.save(Pause);
	}

	@Override
	public void update(Pause Pause) {
		this.pauseDao.update(Pause);
	}

	@Override
	public List<Pause> findData(String day) {
		String hql = "from Pause where day =?";
		return this.pauseDao.findList(hql,day);
	}

	@Override
	public List<PauseBean> getData(Long gymId, String day) {
		List<PauseBean> result = new ArrayList<PauseBean>();
		String hql = "from Pause where gymId = ? and day =?";
		Pause p = null;
		List<Pause> list = this.pauseDao.findList(hql,gymId,day);
		if(list!=null && !list.isEmpty()) {
			p = list.get(0);
		}
		Gym gym = this.gymDao.findById(gymId);
		JSONArray array = JSONArray.fromObject(gym.getOnTime());
		for(int i=0,j=array.size();i<j;i++) {
			JSONObject json = array.getJSONObject(i);
			PauseBean bean = new PauseBean();
			bean.setEnd(json.getString("end"));
			bean.setStart(json.getString("start"));
			bean.setTimeId(json.getString("id"));
			bean.setGymId(gym.getId());
			if(p!=null) {
				bean.setId(p.getId());
				if( p.getPauseTime().indexOf(bean.getTimeId())>-1) {
					bean.setStatus("checked");
				}
			}else {
				bean.setStatus("");
			}
			result.add(bean);
		}
		return result;
	}

}
