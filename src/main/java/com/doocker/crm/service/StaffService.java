package com.doocker.crm.service;

import java.util.HashMap;

import com.doocker.crm.po.Staff;
import com.github.pagehelper.PageInfo;

public interface StaffService {
	Integer updateStaff(Staff staff);
	Integer deleteStaff(Integer id);
	Integer insertStaff(Staff staff);
	Staff getStaff(Integer id);
	PageInfo<HashMap> selectListByPage(String staffName, Integer page, Integer rows);
	Integer deleteById(Integer id);
	Integer add(Staff staff); 
}
