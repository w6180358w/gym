<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.util.SystemUtil"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="com.model.*"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%List<Notice> noticeList = (List<Notice>)request.getAttribute("noticeList");
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<c:url value="/" var="rootUrl" scope="application"></c:url>
<c:if test="${fn:contains(rootUrl,';jsession')}">
	<c:set value="${fn:split(rootUrl,';')[0] }" var="rootUrl"
		scope="application" />
</c:if>

<!DOCTYPE html>
<html>
<head>
    <title>北京化工大学场馆地图</title>
</head>

<body>
<jsp:include page="/html/head.jsp" flush="true">     
     <jsp:param name="nowPage" value="notice"/> 
</jsp:include> 

<div id="nav-main" style="overflow: auto;width: 100%"></div>
<br>
<div class="container">
    <article class="col-xs-12 col-sm-12 col-md-12 col-lg-12" style="height:100%">
			<div id="myTable" class="col-xs-12 jarviswidget jarviswidget-color-blueDark">
							<header> <span>&nbsp;&nbsp;<i class="fa fa-table"></i>&nbsp;&nbsp;
								<h2>
									公告管理
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
												<th>公告</th>
												<th>创建人</th>
												<th>创建时间</th>
												<th>状态</th>
												<th>操作</th>
											</tr>
										</thead>
										<tbody>
										<%for(int i =0;noticeList!=null && i<noticeList.size();i++){
											Notice notice = noticeList.get(i);
										%>
											<tr>
												<td><%=notice.getMsg() %></td>
												<td><%=notice.getUserName() %></td>
												<td><%=sdf.format(notice.getCreateTime()) %></td>
												<td><%=notice.getStatus().equals(1)?"已发布":"未发布" %></td>
												<td>
													<button class="btn btn-primary btn-sm" onclick="update('<%=notice.getId() %>');">修改</button>
													<button class="btn btn-primary btn-sm" onclick="isDel('<%=notice.getId() %>');">删除</button>
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
		<div id="noticeDialog" style="display:none;margin:0;">
			<form id ="noticeForm" class="form-horizontal">
				<fieldset>
				<input type="hidden" name="id" id="id" ></input>
 				<input type="hidden" name="createTime" id="createTime" ></input>
				<input type="hidden" name="userName" id="userName" ></input>
				<input type="hidden" name="userId" id="userId" ></input>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">公告</label>
						<div class="col-xs-10">
							<input class="form-control" type="text" name="msg" id="msg" required>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">状态</label>
						<div class="col-xs-10">
							<select class="form-control" name="status" id="status" required>
								<option value=1>已发布</option>
								<option value=0>未发布</option>
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
		var form = document.getElementById("noticeForm");
		var dataPara = getFormJson(form);
   		$.ajax({
       		url: isEdit?"${rootUrl}notice/update.do":"${rootUrl}notice/save.do",
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
       		url: "${rootUrl}notice/del.do?id="+id,
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
       		url: "${rootUrl}notice/get.do?id="+id,
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
		$("#noticeDialog").dialog("open");
	}
	function setForm(notice){
		$("#id").val(notice["id"]);
		$("#msg").val(notice["msg"]);
		$("#createTime").val(notice["createTime"]);
		$("#userName").val(notice["userName"]);
		$("#userId").val(notice["userId"]); 
		$("#status").val(notice["status"]);
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
		$("#noticeForm").validate();
		
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
					$("#noticeDialog").dialog("open");
				}
			}],
			},
			"autoWidth" : true
		}); 
		$("#noticeDialog").dialog({
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