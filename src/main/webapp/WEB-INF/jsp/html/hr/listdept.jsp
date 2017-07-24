<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<jsp:include page="/WEB-INF/jsp/lib.jsp"></jsp:include>
<div>
	<label>部门名称</label>
	<input id="deptName">
	<input id="queryDept" type="button" value="查询">
</div>

<!-- 创建easyui表格 -->
<table id="dg"></table>
<!-- 表单窗口 -->
<div id="dlg">
	<form id="form1" action="#">
		<label>部门名称</label>
		<input id="ideptName" name="deptName">
		<input id="insertDept" type="button" value="保存">
	</form>
</div>

<script type="text/javascript">
	$(function(){
		//点击查询按钮根据部门名称查询
		$("#queryDept").click(function(){
			var deptName = $("#deptName").val();
			if(deptName){
				$('#dg').datagrid({
					queryParams:{deptname:deptName}
				});
			}
			
		})
		//初始化表格
		$("#dg").datagrid({
				url:'dept/list.do',    
				columns:[[    
				   {field:'id',title:'ID',width:100},    
				   {field:'deptName',title:'部门名称',width:100},     
				]],
				fit:true,
				fitColumns:true,
				singleSelect:true,
				pagination:true,
				toolbar:[{
							text:"增加",
							iconCls:'icon-add',
							handler:function(){
								$("#ideptName").val('');
								//修改对话框的title(标题)
								$("#dlg").dialog("setTitle","增加部门");
								$("#dlg").dialog("open");
								//保存按钮 解除所有的事件绑定
								$("#insertDept").unbind();
								//点击保存增加一个部门
								$("#insertDept").click(function(){
									var ideptName = $("#ideptName").val();
									if(ideptName){
										$.ajax({
											url:'dept/add.do', //增加部门的接口
											data:{deptName:ideptName},
											success:function(data){
												if(data.flag){
													$("#dg").datagrid("reload");
													$("#dlg").dialog("close");
												}
											}
										})
									}
									
								})
							}
						},{
							text:"修改",
							iconCls:'icon-edit',
							handler:function(){
								//修改对话框的title(标题)
								$("#dlg").dialog("setTitle","修改部门");
								$("#dlg").dialog("open");
								//保存按钮 解除所有的事件绑定
								$("#insertDept").unbind();
								//点击保存增加一个部门
								var row = $("#dg").datagrid("getSelected");
								if(row){
									$("#ideptName").val(row.deptName);
									$("#insertDept").click(function(){
										var ideptName = $("#ideptName").val();
										if(ideptName){
											$.ajax({
												url:'dept/update.do', //增加部门的接口
												data:{id:row.id,deptName:ideptName},
												success:function(data){
													if(data.flag){
														$("#dg").datagrid("reload");
														$("#dlg").dialog("close");
													}
												}
											})
										}
										
									})
								}
								
								
								
								
							}
						},{
							text:"删除",
							iconCls:'icon-remove',
							handler:function(){
								var row = $("#dg").datagrid("getSelected");
								if(row){
									$.ajax({
										url:'dept/del.do', 
										data:{id:row.id},
										success:function(data){
											if(data.flag){
												$("#dg").datagrid("reload");
											}
										}
									})
								}
							}
						}]
		});
		//初始化表单窗口
		$('#dlg').dialog({    
		    title: '增加部门',    
		    closed: true,    
		    cache: false,   
		    modal: true   
		});  
	})
</script>
	