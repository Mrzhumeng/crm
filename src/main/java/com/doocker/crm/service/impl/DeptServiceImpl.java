package com.doocker.crm.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.doocker.crm.mapper.DeptMapper;
import com.doocker.crm.po.Dept;
import com.doocker.crm.po.DeptExample;
import com.doocker.crm.po.DeptExample.Criteria;
import com.doocker.crm.service.DeptService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;


@Service
public class DeptServiceImpl implements DeptService {
	
	
	@Autowired
	private DeptMapper deptMapper;
	
	@Override
	public Integer updateDept(Dept dept) {
		if(null == dept.getId()){
			return 0;
		}
		return deptMapper.updateByPrimaryKey(dept);
	}

	@Override
	public Integer deleteDept(Integer id) {
		return deptMapper.deleteByPrimaryKey(id);
	}

	@Override
	public Integer insertDept(Dept dept) {
		if( null != dept.getId()){
			return 0;
		}
		return deptMapper.insert(dept);
	}

	@Override
	public Dept getDept(Integer id) {
		return deptMapper.selectByPrimaryKey(id);
	}
	/*
	 * esayui的分页查询接口
	 * 
	 */
	@Override
	public PageInfo<Dept> selectListByPage(String deptName, Integer page, Integer rows) {
		//example通过DeptExample来动态的增加修改查询条件
		DeptExample example = new DeptExample();
		if(null != deptName){
			Criteria createCriteria = example.createCriteria();
			createCriteria.andDeptNameLike("%"+deptName+"%");
		}
		//分页插件的使用
		PageHelper.startPage(page, rows);
		
		List<Dept> selectByExample = deptMapper.selectByExample(example);
		
		PageInfo<Dept> info = new PageInfo(selectByExample);
		return info;
	}

	@Override
	public Integer deleteById(Integer id) {
		
		return deptMapper.deleteByPrimaryKey(id);
	}

	@Override
	public Integer add(Dept dept) {
		return deptMapper.insert(dept);
	}

}
