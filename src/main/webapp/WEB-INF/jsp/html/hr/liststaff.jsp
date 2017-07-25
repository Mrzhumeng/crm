<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<jsp:include page="/WEB-INF/jsp/lib.jsp"></jsp:include>

<div>
	<label>员工姓名</label>
	<input id="qstaffname" type="text">
	<input type="button" value="查询" id="querystaff">
</div>
<!-- 1修改了注释 -     ->
<!-- 创建easyui表格         --> 
<table id="dg"></table>
<div id="addstaff">
	<label>姓名</label>
	<input type="text" id="istaffname" ><br>
	<label>性别</label>
		<select id="istaffsex">
			<option value='1'>男</option>
			<option value='0'>女</option>
		</select><br>
	<label>生日</label>
	<input id="istaffbirthday" type="text" class="easyui-datebox" ></input> <br>
	<label>入职日期</label>
		<input id="istaffentry" type="text" class="easyui-datebox" required="required"></input> <br>
	<label>部门</label>
		<select id="idept">
		</select><br>
	<label>职位</label>
		<select id="iposition">
			<option>--请选择--<option>
		</select><br>
		<input type="button" id="isave" value="保存">
</div>

<script type="text/javascript">
	$(function(){
		
		$("#querystaff").click(function(){
			var staffname = $("#qstaffname").val();
			$("#dg").datagrid({
				queryParams:{
					staffname:staffname
				}
			})
		})
		
		//获取所有的部门
		$.ajax({
			url:'dept/list.do',
			data:{rows:100},
			success:function(data){
				if(data.rows){
					//清空append中的option
					$("#idept").empty();
					$(data.rows).each(function(){
						//this 指的是rows里面的每一条数据
						$("#idept").append('<option value='+this.id+'>'+this.deptName+'</option>')
						
					})
					
					$.ajax({
						url:'position/getPositionByDept.do',
						data:{deptId:data.rows[0].id},
						success:function(data){
							$("#iposition").empty();
							$(data.rows).each(function(){
								//this 指的是rows里面的每一条数据
								$("#iposition").append('<option value='+this.id+'>'+this.positionName+'</option>')
								
							})
						}
					})
				}
			}
		
	})
	
		//当你改变部门的时候 职位也应该相应的改变  改变部门触发了select标签change事件
		$("#idept").change(function(){
			var deptid = $("#idept").val();
			$.ajax({
				url:'position/getPositionByDept.do',
				data:{deptId:deptid},
				success:function(data){
					$("#iposition").empty();
					$(data.rows).each(function(){
						//this 指的是rows里面的每一条数据
						$("#iposition").append('<option value='+this.id+'>'+this.positionName+'</option>')
						
					})
				}
			})
		})
		
		
		
		
		//初始化表格
		$("#dg").datagrid({
				url:'staff/list.do', 
				//{"id":1,"deptName":"人力资源部","birthday":"2017-06-01","sex":1,"positionId":1,
				//	"staffName":"张1","entry":"2017-06-01","positionName":"人力资源主管"}
				columns:[[    
				   {field:'id',title:'编号',width:150},     
				   {field:'staffName',title:'员工名称',width:150},
				   {field:'sex',title:'性别',width:150,formatter: function(value){
															if (value == '1'){
																return '男';
															} else if(value == '0'){
																return '女';
																}
														}
					},  
				   {field:'birthday',title:'生日',width:150},  
				   {field:'entry',title:'入职日期',width:150},  
				   {field:'deptName',title:'部门名称',width:150},  
				   {field:'positionName',title:'职位',width:150},  
				]],
				fit:true,
				fitColumns:true,
				singleSelect:true,
				pagination:true,
				toolbar:[{
							text:"增加",
							iconCls:'icon-add',
							handler:function(){
								$("#addstaff").dialog("open")
								//解除事件绑定
								$("#isave").unbind();
								//修改对话框标题
								$("#addstaff").dialog("setTitle","增加员工") 
								//点击保存按钮，保存数据
								$("#isave").click(function(){
									//[{"id":1,"deptName":"人力资源部","birthday":"2017-06-01","sex":1,"positionId":1,
										//"staffName":"张1","entry":"2017-06-01","positionName":"人力资源主管"}
									var istaffname = $("#istaffname").val();
									var istaffsex = $("#istaffsex").val();
									var istaffbirthday = $("#istaffbirthday").datebox('getValue');
									var istaffentry = $("#istaffentry").datebox('getValue');
									var ipositionid = $("#iposition").val();
									$.ajax({
										url:'staff/add.do',
										data:{name:istaffname,sex:istaffsex,birthday:istaffbirthday,entry:istaffentry,positionId:ipositionid},
										success:function(data){
											if(data.flag){
												//重新加载，刷新表格
												$("#dg").datagrid("reload");
												$("#addstaff").dialog("close");
											}
										}
									})
									
								});
									
								
							}
						},{
							text:"修改",
							iconCls:'icon-edit',
							handler:function(){
								//打开对话框
								$("#addstaff").dialog("open")
								//解除事件绑定
								$("#isave").unbind();
								//修改对话框标题
								$("#addstaff").dialog("setTitle","修改员工") 
								//获取选中的那一行数据
								//{"id":1,"deptName":"人力资源部","birthday":"2017-06-01","sex":1,"positionId":1,
								//	"staffName":"张1","entry":"2017-06-01","positionName":"人力资源主管"}
								var row = $("#dg").datagrid("getSelected");
								if(row){
									var istaffname = $("#istaffname").val(row.staffName);
									var istaffsex = $("#istaffsex").val(row.sex);
									var istaffbirthday = $("#istaffbirthday").datebox('setValue',row.birthday);
									var istaffentry = $("#istaffentry").datebox('setValue',row.entry);
									var idept = $("#idept").val(row.deptId);
									//ajax异步请求相当于java的一个线程，这个线程要花费较长时间，所以这个要先处理的数据得等线程完成后再处理
									//处理的函数应该放在success这个函数里面
									$.ajax({
										url:'position/getPositionByDept.do',
										data:{deptId:row.deptId},
										success:function(data){
											$("#iposition").empty();
											$(data.rows).each(function(){
												//this 指的是rows里面的每一条数据
												$("#iposition").append('<option value='+this.id+'>'+this.positionName+'</option>')
											})
											var ipositionid = $("#iposition").val(row.positionId);
										}
									})
									$("#isave").unbind();
									$("#isave").click(function(){
										
										var istaffname = $("#istaffname").val();
										var istaffsex = $("#istaffsex").val();
										var istaffbirthday = $("#istaffbirthday").datebox('getValue');
										var istaffentry = $("#istaffentry").datebox('getValue');
										var ipositionid = $("#iposition").val();
										$.ajax({
											url:'staff/update.do',
											data:{name:istaffname,id:row.id,sex:istaffsex,birthday:istaffbirthday,entry:istaffentry,positionId:ipositionid},
											success:function(data){
												if(data.flag){
													//重新加载，刷新表格
													$("#dg").datagrid("reload");
													$("#addstaff").dialog("close");
												}
											}
										})
										
									});
								}
					
							}
						},{
							text:"删除",
							iconCls:'icon-remove',
							handler:function(){
								//获取选中的那一行数据
								//{"id":1,"deptName":"人力资源部","birthday":"2017-06-01","sex":1,"positionId":1,
								//	"staffName":"张1","entry":"2017-06-01","positionName":"人力资源主管"}
								var row = $("#dg").datagrid("getSelected");
								//如果有选中的就执行ajax
								if(row){
									$.ajax({
										url:'staff/del.do', //删除部门的接口
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
		$("#addstaff").dialog({
			title: '增加员工',    
		    closed: true,    
		    cache: false,   
		    modal: true   
		})
	})
</script>
	