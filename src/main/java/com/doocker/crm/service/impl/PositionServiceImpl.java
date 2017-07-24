package com.doocker.crm.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.doocker.crm.mapper.DeptMapper;
import com.doocker.crm.mapper.PositionMapper;
import com.doocker.crm.po.Dept;
import com.doocker.crm.po.Position;
import com.doocker.crm.po.PositionExample;
import com.doocker.crm.po.PositionExample.Criteria;
import com.doocker.crm.service.PositionService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Service
public class PositionServiceImpl implements PositionService {
	@Autowired
	private PositionMapper positionMapper;
	
	@Autowired
	private DeptMapper deptMapper;
	/*
	 * 网页传参数只传递部门的id,不传递部门名称
	 * 要拿到部门的id 从数据库中查询出部门名称 然后再修改
	 */
	
	@Override
	public Integer updatePosition(Position position) {
		if(null == position.getId()){
			return 0;
		}
		Integer deptId = position.getDeptId();
		Dept dept = deptMapper.selectByPrimaryKey(deptId);
		position.setDeptName(dept.getDeptName());
		
		return positionMapper.updateByPrimaryKey(position);
	}

	@Override
	public Integer deletePosition(Integer id) {
		return positionMapper.deleteByPrimaryKey(id);
	}

	/*
	 * 网页传参数只传递部门的id,不传递部门名称
	 * 要拿到部门的id 从数据库中查询出部门名称 然后再插入
	 */
	@Override
	public Integer insertPosition(Position position) {
		if( null != position.getId()){
			return 0;
		}
		Integer deptId = position.getDeptId();
		Dept dept = deptMapper.selectByPrimaryKey(deptId);
		position.setDeptName(dept.getDeptName());
		return positionMapper.insert(position);
	}

	@Override
	public Position getPosition(Integer id) {
		return positionMapper.selectByPrimaryKey(id);
	}
	/*
	 * esayui的分页查询接口
	 * 
	 */
	@Override
	public PageInfo<Position> selectListByPage(String positionName, Integer page, Integer rows) {
		//example通过PositionExample来动态的增加修改查询条件
		PositionExample example = new PositionExample();
		if(null != positionName){
			Criteria createCriteria = example.createCriteria();
			createCriteria.andPositionNameLike("%"+positionName+"%");
			//如果要根据部门名称查询增加这一行代码；
			//createCriteria.andDeptNameLike("%"+deptName+"%");
		}
		//分页插件的使用
		PageHelper.startPage(page, rows);
		
		List<Position> selectByExample = positionMapper.selectByExample(example);
		
		PageInfo<Position> info = new PageInfo(selectByExample);
		return info;
	}

	@Override
	public Integer deleteById(Integer id) {
		
		return positionMapper.deleteByPrimaryKey(id);
	}

	@Override
	public Integer add(Position position) {
		/*
		 * 网页传参数只传递部门的id,不传递部门名称
		 * 要拿到部门的id 从数据库中查询出部门名称 然后再修改
		 */
		if(null != position.getId()){
			return 0;
		}
		Integer deptId = position.getDeptId();
		Dept dept = deptMapper.selectByPrimaryKey(deptId);
		position.setDeptName(dept.getDeptName());
		return positionMapper.insert(position);
	}

	@Override
	public List<Position> getPositionByDeptId(Integer deptId) {
		PositionExample example = new PositionExample();
		Criteria createCriteria = example.createCriteria();
		createCriteria.andDeptIdEqualTo(deptId);
		List<Position> selectByExample = positionMapper.selectByExample(example);
		return selectByExample;
	}

}
