<%@page import="com.util.SystemUtil"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="com.model.*"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%List<Message> messageList = (List<Message>)request.getAttribute("messageList");%>
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
     <jsp:param name="nowPage" value="message"/> 
</jsp:include> 

<div id="nav-main" style="overflow: auto;width: 100%"></div>
<br>
<div class="container">
    <article class="col-xs-12 col-sm-12 col-md-12 col-lg-12" style="height:100%">
			<div id="myTable" class="col-xs-12 jarviswidget jarviswidget-color-blueDark">
							<header> <span>&nbsp;&nbsp;<i class="fa fa-table"></i>&nbsp;&nbsp;
								<h2>
									消息管理
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
												<th>消息</th>
												<th>状态</th>
												<th>操作</th>
											</tr>
										</thead>
										<tbody>
										<%for(int i =0;messageList!=null && i<messageList.size();i++){
											Message message = messageList.get(i);
										%>
											<tr>
												<td><%=message.getMsg() %></td>
												<td><%=message.getStatus().equals(1)?"已读":"未读" %></td>
												<td>
													<button class="btn btn-primary btn-sm" onclick="isDel('<%=message.getId() %>');">删除</button>
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
		<div id="power" style="display:none;margin:0;">
			<div id="power-message">
				
			</div>
		</div>
		
		<script>
	function del(id) {
		$.ajax({
       		url: "${rootUrl}message/del.do?id="+id,
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
	function isDel(id){
		$("#power-message").html("<h5 class='text-center line-70'>确认删除？</h5>");
		$("#power").dialog("open");
		$("#power").dialog({width:300,height:200});
		$("#power").dialog({id:id});
	}

	$(document).ready(function() {
		$("#messageForm").validate();
		
		$('#datatable_col_reorder').dataTable({
			"sDom" : "<'dt-toolbar'<'col-xs-6 col-sm-6'f><'col-sm-6 col-xs-6 hidden-xs'T>r>"
				+ "t"
				+ "<'dt-toolbar-footer'<'col-sm-6 col-xs-6 hidden-xs'i><'col-sm-12 col-xs-6'p>>",
			"oTableTools" : {
			"aButtons" : [],
			},
			"autoWidth" : true
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