package com.doocker.crm.service;


import java.util.List;

import com.doocker.crm.po.Position;
import com.github.pagehelper.PageInfo;

public interface PositionService {
	Integer updatePosition(Position position);
	Integer deletePosition(Integer id);
	Integer insertPosition(Position position);
	Position getPosition(Integer id);
	PageInfo<Position> selectListByPage(String positionName, Integer page, Integer rows);
	Integer deleteById(Integer id);
	Integer add(Position position);
	List<Position> getPositionByDeptId(Integer deptId);
	
}
