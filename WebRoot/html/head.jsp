<%@page import="com.util.SystemUtil"%>
<%@page import="com.model.*"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	String nowPage = request.getParameter("nowPage");
	User user = (User)session.getAttribute("user");
	List<Message> messageList = (List<Message>)session.getAttribute("messageList");
	String auth = user==null?null:user.getType();
%>
<c:url value="/" var="rootUrl" scope="application"></c:url>
<c:if test="${fn:contains(rootUrl,';jsession')}">
	<c:set value="${fn:split(rootUrl,';')[0] }" var="rootUrl"
		scope="application" />
</c:if>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${rootUrl }/css/bootstrap.min.css">
    <link rel="stylesheet" href="${rootUrl }/css/style.css">
    <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/smartadmin-production-plugins.min.css">
    <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/jquery-ui.css">
    <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/add-app-class.css">
<div class="container">
    <div class="row">
        <div class="log-box col-xs-9">
            <div id="logo" class="log">
                <a href="${rootUrl }html/appointment.jsp"><img src="${rootUrl }/images/buct.jpg" class="img-responsive" /></a>
            </div>
        </div>
        <%if(user!=null){%>	
        <div class="col-xs-3 head-login">
        	<a href="javascript:void(0)" onclick="logout()">退出</a>
        	<%if(auth!=null){%>	
        	<a href="javascript:void(0)" onclick="readMsg()">未读消息(<%=messageList==null?0:messageList.size() %>)</a>
        	<%} %>
        	<a href="javascript:void(0)"><%=user.getName() %></a>
		</div>	
        <%}else{%>
        <div class="col-xs-3 head-login">
        	<a href="javascript:void(0)" onclick="adminLogin()">管理员登录</a>
			<a href="javascript:void(0)">登录</a>
		</div>
        <%} %>
    </div>
    <div class="row">
        <div>
            <ul class="nav nav-tabs">
                <li class=<%="appointment".equals(nowPage)?"active":"" %>><a href="${rootUrl }html/appointment.jsp">场地预约</a></li>
                <li class=<%="order".equals(nowPage)?"active":"" %>><a href="${rootUrl }order/home.do">预约记录</a></li>
            <%if(SystemUtil.ADMIN.equals(auth) || SystemUtil.SUPERADMIN.equals(auth)) {%>
                <li class=<%="gym".equals(nowPage)?"active":"" %>><a href="${rootUrl }gym/home.do">场地管理</a></li>
                <li class=<%="message".equals(nowPage)?"active":"" %>><a href="${rootUrl }message/home.do">消息管理</a></li>
                <li class=<%="notice".equals(nowPage)?"active":"" %>><a href="${rootUrl }notice/home.do">公告管理</a></li>
            <%} %>
            <%if(SystemUtil.SUPERADMIN.equals(auth)) {%>
            	<li class=<%="user".equals(nowPage)?"active":"" %>><a href="${rootUrl }user/home.do">用户管理</a></li>
                <li class=<%="gymType".equals(nowPage)?"active":"" %>><a href="${rootUrl }gymType/home.do">场地类型管理</a></li>
            <%} %>
            </ul>
        </div>
    </div>
</div>
<%if(auth!=null){%>
<div id="messageDialog" style="display:none;margin:0;">
	<form id ="logForm" class="form-horizontal">
	<br>
		<fieldset>
		<%for(Message message : messageList){ %>
			<div class="form-group">
				<div class="col-xs-12">
					<%=message.getMsg() %>
				</div>
			</div>
			<HR>
		<%} %>
		</fieldset>
	</form>
</div>
<%}%>
		<!-- 弹出窗口 -->
<div id="logDialog" style="display:none;margin:0;">
	<form id ="logForm" class="form-horizontal">
		<fieldset>
			<div class="form-group">
				<label class="col-xs-2 txt-al-mar-pad">账号</label>
				<div class="col-xs-10">
					<input class="form-control" name="ucode" id="login_ucode" required>
				</div>
			</div>
			<div class="form-group">
				<label class="col-xs-2 txt-al-mar-pad">密码</label>
				<div class="col-xs-10">
					<input class="form-control" name="password" id="login_password" required>
				</div>
			</div>
		</fieldset>
	</form>
</div>
<script src="${rootUrl}js/jquery-2.1.1.min.js"></script>
<script src="${rootUrl}js/jquery-ui-1.10.3.min.js"></script>
<script src="${rootUrl}js/jquery.dataTables.min.js"></script>
<script src="${rootUrl}js/jquery.validate.min.js"></script>
<script src="${rootUrl}js/dataTables.colVis.min.js"></script>
<script src="${rootUrl}js/dataTables.tableTools.min.js"></script>
<script src="${rootUrl}js/dataTables.bootstrap.min.js"></script>
<script>
$(document).ready(function() {
	$.ajaxSetup({
		error:function(XMLHttpRequest, textStatus, errorThrown){
			console.log(XMLHttpRequest);
			if(XMLHttpRequest.status==404){
				alert("无权限");
			}else{
				alert("系统错误，请联系管理员！");
			}
			window.location = "${rootUrl}html/appointment.jsp";
		}
	})
	$("#logForm").validate();
	<%if(auth!=null){%>
	$("#messageDialog").dialog({
		autoOpen : false,
		title:"管理员消息",
		modal : true,
		height:300, 
		width:700
	});
	<%}%>
	$("#logDialog").dialog({
		autoOpen : false,
		title:"管理员登录",
		modal : true,
		height:250, 
		width:400, 
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
				doLogin();
			}
		}]
	});
});
<%if(auth!=null){%>
function readMsg(){
	$.ajax({
   		url: "${rootUrl}message/read.do",
   		type: "post",
   		dataType:"json",
   		success: function(data){
			if(data.code==0){
				$("#messageDialog").dialog("open");
			}else{
				alert(data.msg);
			}
		} 
	});
}
<%}%>
function adminLogin() {
	$("#logDialog").dialog("open");
}
function logout(){
	$.ajax({
   		url: "${rootUrl}index/logout.do",
   		type: "post",
   		dataType:"json",
   		success: function(data){
			if(data.code==0){
				window.location = "${rootUrl}html/appointment.jsp";
			}else{
				alert(data.msg);
			}
		} 
	});
}
function doLogin() {
	var form = document.getElementById("logForm");
	if(!$(form).valid()){
		return;
	}
	$.ajax({
   		url: "${rootUrl}index/doLogin.do",
   		type: "post",
   		data: {ucode:$("#login_ucode").val(),password:$("#login_password").val()},
   		dataType:"json",
   		success: function(data){
   			alert(data.msg);
   			$("#dialog-window").dialog("close"); 
			if(data.code==0){
				window.location.reload();
			}
		} 
	});
}
</script>