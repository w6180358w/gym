<%@page import="com.util.SystemUtil"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="com.model.*"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%List<User> userList = (List<User>)request.getAttribute("userList");%>
<c:url value="/" var="rootUrl" scope="application"></c:url>
<c:if test="${fn:contains(rootUrl,';jsession')}">
	<c:set value="${fn:split(rootUrl,';')[0] }" var="rootUrl"
		scope="application" />
</c:if>

<!DOCTYPE html>
<html>
<head>
    <script src="../js/jquery-3.2.1.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <title>北京化工大学场馆地图</title>
</head>

<body>
<jsp:include page="/html/head.jsp" flush="true">     
     <jsp:param name="nowPage" value="user"/> 
</jsp:include> 

<div id="nav-main" style="overflow: auto;width: 100%"></div>
<br>
<div class="container">
    <article class="col-xs-12 col-sm-12 col-md-12 col-lg-12" style="height:100%">
			<div id="myTable" class="col-xs-12 jarviswidget jarviswidget-color-blueDark">
							<header> <span>&nbsp;&nbsp;<i class="fa fa-table"></i>&nbsp;&nbsp;
								<h2>
									用户管理
								</h2>
							</span> </header>
	
							<!-- widget div-->
							<div>
	
								<!-- widget edit box -->
								<div class="jarviswidget-editbox">
									<!-- This area used as dropdown edit box -->
								</div>
								<!-- end widget edit box -->
	
								<!-- widget content -->
								<div class="widget-body no-padding table-responsive">
									<table id="datatable_col_reorder"
										class="table table-striped table-bordered table-hover table-line"
										width="100%"  >
										<thead>
											<tr>
												<th>账号</th>
												<th>姓名</th>
												<th>类型</th>
												<th>操作</th>
											</tr>
										</thead>
										<tbody>
										<%for(int i =0;userList!=null && i<userList.size();i++){
											User user = userList.get(i);
										%>
											<tr>
												<td><%=user.getUcode() %></td>
												<td><%=user.getName() %></td>
												<td><%=user.getType() %></td>
												<td>
													<button class="btn btn-primary btn-sm" onclick="update('<%=user.getId() %>');">修改</button>
													<button class="btn btn-primary btn-sm" onclick="isDel('<%=user.getId() %>');">删除</button>
												</td>
											</tr>
											<%	
										}
										%>
										</tbody>
									</table>
	
								</div>
							</div>
						</div>
				</article>
		<!-- END MAIN PANEL -->
		<!-- 弹出窗口 -->
		<div id="userDialog" style="display:none;margin:0;">
			<form id ="userForm" class="form-horizontal">
				<fieldset>
				<input type="hidden" name="id" id="id" ></input>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">姓名</label>
						<div class="col-xs-10">
							<input class="form-control" type="text" name="name" id="name">
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">账号</label>
						<div class="col-xs-10">
							<input class="form-control" type="text" name="ucode" id="ucode">
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">密码</label>
						<div class="col-xs-10">
							<input class="form-control" type="text" name="password" id="password">
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">类型</label>
						<div class="col-xs-10">
							<select class="form-control" name="type" id="type" required>
								<option value="<%=SystemUtil.SUPERADMIN%>">总管理员</option>
								<option value="<%=SystemUtil.ADMIN%>">场地管理员</option>
							</select>
						</div>
					</div>
				</fieldset>
			</form>
			</div>
		<div id="power" style="display:none;margin:0;">
			<div id="power-message">
				
			</div>
		</div>
		
		<script>
	var isEdit = false;
    //将form转为AJAX提交
	function ajaxSubmit() {
		var form = document.getElementById("userForm");
		var dataPara = getFormJson(form);
   		$.ajax({
       		url: isEdit?"${rootUrl}user/update.do":"${rootUrl}user/save.do",
       		type: "post",
       		data: dataPara,
       		dataType:"json",
       		success: function(data){
				if(data.code==0){
					$("#dialog-window").dialog("close"); 
					window.location.reload();
				}else{
					alert(data.msg);
				}
			} 
   		});
	}

	function del(id) {
		$.ajax({
       		url: "${rootUrl}user/del.do?id="+id,
       		type: "get",
       		dataType:"json",
       		success: function(data){
				if(data.code==0){
					$("#dialog-window").dialog("close"); 
					window.location.reload();
				}else{
					alert(data.msg);
				}
			} 
   		});
	}
	
	function update(id){
		$.ajax({
       		url: "${rootUrl}user/get.do?id="+id,
       		type: "get",
       		dataType:"json",
       		success: function(data){
       			console.log(data);
				if(data.code==0 && data.data!=null){
					setForm(data.data);	
					isEdit = true;
				}else{
					alert("查询失败");
				}
			} 
   		});
		isEdit = false;
		$("#userDialog").dialog("open");
	}
	function setForm(user){
		$("#id").val(user["id"]);
		$("#name").val(user["name"]);
		$("#ucode").val(user["ucode"]);
		$("#password").val(user["password"]);
		$("#type").val(user["type"]);
	}
	//将form中的值转换为键值对。
	function getFormJson(frm) {
    	var o = {};
    	var a = $(frm).serializeArray();
    	$.each(a, function () {
        	if (o[this.name] !== undefined) {
           		if (!o[this.name].push) {
              		o[this.name] = [o[this.name]];
           		}
            	o[this.name].push(this.value || '');
        	} else {
            	o[this.name] = this.value || '';
        	}
    	});
    	return o;
	}
	function isDel(id){
		console.log(id)
		$("#power-message").html("<h5 class='text-center line-70'>确认删除？</h5>");
		$("#power").dialog("open");
		$("#power").dialog({width:300,height:200});
		$("#power").dialog({id:id});
	}

	$(document).ready(function() {
		$("#adds").validate();
		$("#userForm").validate();
		
		$('#datatable_col_reorder').dataTable({
			"sDom" : "<'dt-toolbar'<'col-xs-6 col-sm-6'f><'col-sm-6 col-xs-6 hidden-xs'T>r>"
				+ "t"
				+ "<'dt-toolbar-footer'<'col-sm-6 col-xs-6 hidden-xs'i><'col-sm-12 col-xs-6'p>>",
			"oTableTools" : {
			"aButtons" : [{
				"sExtends" : "text",
				"sButtonText": "新增",
				"fnClick":function(nButton, oConfig, oFlash){
					isEdit = false;
					setForm({});
					$("#userDialog").dialog("open");
				}
			}],
			},
			"autoWidth" : true
		}); 
		$("#userDialog").dialog({
			autoOpen : false,
			modal : true,
			height:350, 
			width:640, 
			buttons : [{
				html : "取消",
				"class" : "btn btn-default btn-sm",
				click : function() {
				$(this).dialog("close");
				}
			}, {
				html : "<i class='fa fa-check'></i>&nbsp; 保存",
				"class" : "btn btn-primary btn-sm",
				click : function() {
					ajaxSubmit();
				}
			}]
						
		});
		
		$("#power").dialog({
			autoOpen : false,
			modal : true,
			height:350, 
			width:640, 
			buttons : [{
				html : "取消",
				"class" : "btn btn-default btn-sm",
				click : function() {
				$(this).dialog("close");
				}
			}, {
				html : "<i class='fa fa-check'></i>&nbsp; 确定",
				"class" : "btn btn-primary btn-sm",
				click : function() {
					var id=$("#power").dialog("option","id");
					del(id);
				}
			}]
						
		});
		
	});
</script>
</div>
<jsp:include page="/html/footer.jsp" flush="true"></jsp:include> 
</body>
</html>