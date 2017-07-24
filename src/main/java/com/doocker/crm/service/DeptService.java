package com.doocker.crm.service;

import com.doocker.crm.po.Dept;
import com.github.pagehelper.PageInfo;

public interface DeptService {
	Integer updateDept(Dept dept);
	Integer deleteDept(Integer id);
	Integer insertDept(Dept dept);
	Dept getDept(Integer id);
	PageInfo<Dept> selectListByPage(String deptName, Integer page, Integer rows);
	Integer deleteById(Integer id);
	Integer add(Dept dept);
}
