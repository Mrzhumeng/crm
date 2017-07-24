<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<jsp:include page="/WEB-INF/jsp/lib.jsp"></jsp:include>
<div>
	<label>职位名称</label> 
	<input id="positionName">
	<input id="queryPosition" type="button" value="查询">
</div>

<!-- 创建easyui表格 --> 
<table id="dg"></table>
<!-- 表单窗口 -->
<div id="dlg">
	<form id="form1" action="#">
		<label>部门名称</label>
		<select id="ideptId">
		</select>
		<label>职位名称</label>
		<input id="ipositionName" name="positionName">
		<input id="insertPosition" type="button" value="保存">
	</form>
</div>

<script type="text/javascript">
	$(function(){
		//获取所有的部门
		$.ajax({
			url:'dept/list.do',
			data:{rows:100},
			success:function(data){
				if(data.rows){
					//清空append中的option
					$("#ideptId").empty();
					$(data.rows).each(function(){
						//this 指的是rows里面的每一条数据
						$("#ideptId").append('<option value='+this.id+'>'+this.deptName+'</option>')
						
					})
				}
			}
		})
		
		
		
		//点击查询按钮根据部门名称查询
		$("#queryPosition").click(function(){
			var positionName = $("#positionName").val();
			if(positionName){
				$('#dg').datagrid({
					queryParams:{
						positionname:positionName}
				});
			}
			
		})
		//初始化表格
		$("#dg").datagrid({
				url:'position/list.do',    
				columns:[[    
				   {field:'deptName',title:'部门名称',width:150},     
				   {field:'positionName',title:'职位名称',width:150},     
				]],
				fit:true,
				fitColumns:true,
				singleSelect:true,
				pagination:true,
				toolbar:[{
							text:"增加",
							iconCls:'icon-add',
							handler:function(){
								$("#ipositionName").val('');
								//修改对话框的title(标题)
								$("#dlg").dialog("setTitle","增加职位");
								$("#dlg").dialog("open");
								//保存按钮 解除所有的事件绑定
								$("#insertPosition").unbind();
								//点击保存增加一个部门
								$("#insertPosition").click(function(){
									//获取职位的名称
									var ipositionName = $("#ipositionName").val();
									var ideptId = $("#ideptId").val();
									if(ipositionName){
										$.ajax({
											url:'position/add.do',//增加部门的接口
											data:{deptId:ideptId,positionName:ipositionName},
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
								$("#dlg").dialog("setTitle","修改职位");
								$("#dlg").dialog("open");
								//保存按钮 解除所有的事件绑定
								$("#insertPosition").unbind();
								//点击保存增加一个部门
								var row = $("#dg").datagrid("getSelected");
								if(row){
									$("#ipositionName").val(row.positionName);
									$("#ideptId").val(row.deptId);
									$("#insertPosition").click(function(){
										var ipositionName = $("#ipositionName").val();
										var ideptId = $("#ideptId").val(); 	
										if(ipositionName){
											$.ajax({
												//修改职位的接口
												url:'position/update.do', //增加部门的接口
												data:{id:row.id,positionName:ipositionName,deptId:ideptId},
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
								//获取选中的那一行数据
								var row = $("#dg").datagrid("getSelected");
								//如果有选中的就执行ajax
								if(row){
									$.ajax({
										url:'position/del.do', //删除部门的接口
										data:{id:row.id},//发送到接口的数据
										//回调函数（请求相应回来后执行这个函数）data服务器相应的数据
										success:function(data){
											if(data.flag){
												//重新加载（刷新）表格
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
	