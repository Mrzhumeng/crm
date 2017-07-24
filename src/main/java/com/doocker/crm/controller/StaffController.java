package com.doocker.crm.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.doocker.crm.controller.common.EasyuiResult;
import com.doocker.crm.po.Staff;
import com.doocker.crm.service.StaffService;
import com.github.pagehelper.PageInfo;
/**
<<<<<<< HEAD
 * 处理部门的控制器
 * @author Administrator  dulong two
=======  

>>>>>>> branch 'master' of https://github.com/doockercom/crm.git
 */
@Controller
@RequestMapping("staff")
public class StaffController {
	
	@Autowired
	private StaffService staffService;
	
	@RequestMapping("get")
	//作用是反悔的staff对象转化为json
	@ResponseBody
	public Staff getStaff(Integer id){
		return staffService.getStaff(id);
	}
	
	
	@RequestMapping("list")
	@ResponseBody
	public EasyuiResult listStaff(
			//@RequestParam(value="staffname" 指的是表单中的name 
			//             ,required=false  这个参数是否必须,
			//				defaultValue="1" 此参数的默认值)
			@RequestParam(value="staffname",required=false)String staffName,
			//easyui  分页查询传递的参数就是page,rows 不可以改变
			@RequestParam(value="page",defaultValue="1")Integer page,
			@RequestParam(value="rows",defaultValue="3")Integer rows
			){
		PageInfo<HashMap> list = new PageInfo<HashMap>();
		try{
			list = staffService.selectListByPage(staffName,page,rows);
		}catch(Exception e){
			e.printStackTrace();
			return new EasyuiResult(0L,null,false,"server error");
		}
		return new EasyuiResult(list.getTotal(),list.getList(),true,"success");
		
	}
	
	/*
	 * 根据id删除staff
	 */
	@RequestMapping("del")
	@ResponseBody
	public EasyuiResult delete(@RequestParam(value="id",required=true)Integer id){
		Integer ids = 0;
		try {
			ids = staffService.deleteById(id);
		} catch (Exception e) {
			e.printStackTrace();
			return new EasyuiResult(0L,null,false,"server error");
		}
		return new EasyuiResult(0L,ids,true,"success");
	}
	
	
	/*
	 * 增加部门
	 */
	@RequestMapping("add")
	@ResponseBody
	public EasyuiResult add(Staff staff){
		staff.setId(null);
		Integer ids = 0;
		try {
			ids = staffService.add(staff);
		} catch (Exception e) {
			e.printStackTrace();
			return new EasyuiResult(0L,null,false,"server error");
		}
		return new EasyuiResult(0L,ids,true,"success");
	}
	
	
	/*
	 * 修改部门
	 */
	@RequestMapping("update")
	@ResponseBody
	public EasyuiResult update(Staff staff){
		Integer ids = 0;
		try {
			ids = staffService.updateStaff(staff);
		} catch (Exception e) {
			e.printStackTrace();
			return new EasyuiResult(0L,null,false,"server error");
		}
		return new EasyuiResult(0L,ids,true,"success");
	}

}
