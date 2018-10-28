<%@page import="com.util.SystemUtil"%>
<%@page import="com.bean.GymOrderBean"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="com.model.*"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	List<Order> orderList = (List<Order>)request.getAttribute("orderList");
	User user = (User)session.getAttribute("user");
%>
<c:url value="/" var="rootUrl" scope="application"></c:url>
<c:if test="${fn:contains(rootUrl,';jsession')}">
	<c:set value="${fn:split(rootUrl,';')[0] }" var="rootUrl"
		scope="application" />
</c:if>
<!DOCTYPE html>
<html lang="en-us">
<head>
    <title>北京化工大学场馆地图</title>
</head>

<body id="myBody">
	<jsp:include page="/html/head.jsp" flush="true">     
     <jsp:param name="nowPage" value="order"/> 
	</jsp:include>
	<div id="nav-main" style="overflow: auto;width: 100%"></div>
<br>
<div class="container">
<!-- MAIN PANEL -->
<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
	<div id="myTable" class="col-xs-12 jarviswidget jarviswidget-color-blueDark">
		<header> <span>&nbsp;&nbsp;<i class="fa fa-table"></i>&nbsp;&nbsp;
			<h2>
				预约记录
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
							<th>预约人</th>
							<%if(user!=null && (SystemUtil.ADMIN.equals(user.getType()) || SystemUtil.SUPERADMIN.equals(user.getType()))){%><th>预约人唯一标识</th><%} %>
							<th>预约场地</th>
							<th>预约时间</th>
							<th>预约总金额（元）</th>
							<th>预约状态</th>
							<th>付款状态</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<%for(int i =0;orderList!=null && i<orderList.size();i++){
						Order order = orderList.get(i);
						List<GymOrderBean> beanList = JSONArray.toList(JSONArray.fromObject(order.getGymData()), GymOrderBean.class);
					%>
						<tr>
							<td><%=order.getUserName()==null?"":order.getUserName() %></td>
							<%if(user!=null && (SystemUtil.ADMIN.equals(user.getType()) || SystemUtil.SUPERADMIN.equals(user.getType()))){%><td><%=order.getUcode()==null?"":order.getUcode() %></td><%} %>
							<td>
								<a href="javascript:void(0);" onclick="info(<%=order.getId()%>)">
								<%for(GymOrderBean bean : beanList){%>
									<%="["+bean.getGymName()+"]" %>
								<%}%>
								</a>
							</td>
							<td><%=order.getOnDay() %></td>
							<td><%=order.getAllMoney() %></td>
							<td><%=order.getStatusName() %></td>
							<td><%=order.getPayStatusName() %></td>
							<td>
								<button class="btn btn-primary btn-sm" onclick="info(<%=order.getId()%>)">详情</button>
								<%if(!Order.SUCCESS.equals(order.getStatus()) && !Order.EXPIRE.equals(order.getStatus())){ %>
								<button class="btn btn-primary btn-sm" onclick="repay('<%=order.getId() %>');">重新付款</button>
								<%} %>
								<%if(Order.FAILURE.equals(order.getStatus())){ %>
								<button class="btn btn-primary btn-sm" onclick="isDel('<%=order.getId() %>');">删除</button>
								<%} %>
							</td>
						</tr>
						<%}%>
					</tbody>
				</table>
	
			</div>
		</div>
	</div>
	</article>
</div>
<div id="power" style="display:none;margin:0;">
	<div id="power-message">
				
	</div>
</div>
<div id="alert-gym-dialog" style="display:none;margin:0;">
	<form id ="alert-gym-form" class="form-horizontal"></form>
</div>		
<div id="gym-qc" style="display:none;margin:0;">
	<img alt="" src="">
</div>
<script>
function isDel(id){
	$("#power-message").html("<h5 class='text-center line-70'>确认删除？</h5>")  ;
	$("#power").dialog("open");
	$("#power").dialog({width:300,height:200});
	$("#power").dialog({id:id});
}
function del(id) {
	$.ajax({
   		url: "${rootUrl}order/del.do?id="+id,
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
function repay(id){
	$("#gym-qc").dialog("open");
	$("#gym-qc").find("img").prop("src","${rootUrl}order/qcImage.do?orderId="+id);
}
	$(document).ready(function() {
		$('#datatable_col_reorder').dataTable({
			"sDom" : "<'dt-toolbar'<'col-xs-6 col-sm-6'f><'col-sm-6 col-xs-6 hidden-xs'T>r>"
				+ "t"
				+ "<'dt-toolbar-footer'<'col-sm-6 col-xs-6 hidden-xs'i><'col-sm-12 col-xs-6'p>>",
			"oTableTools" : {
			"aButtons" : [],
			},
			"autoWidth" : true
		}); 
		
		$("#alert-gym-dialog").dialog({
			autoOpen : false,
			title:"确认预约",
			modal : true,
			height:350, 
			width:640, 
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
		$("#gym-qc").dialog({
			autoOpen : false,
			title:"请用微信扫描二维码付款",
			modal : true,
			height:400, 
			width:400
		});
	});
	
	function info(id){
		$.ajax({
			url: "${rootUrl}order/info.do?orderId="+id,
	   		type: "get",
	   		dataType:"json",
	   		success: function(data){
				if(data.code==0 && data.data!=null){
					initAlertForm(data.data);
					$("#alert-gym-dialog").dialog("open");
				}else{
					alert("查询失败");
				}
			} 
		})
	}
	
	//初始化预约场地提示框
	function initAlertForm(param){
		var form = $("#alert-gym-form");
		form.empty();
		var allmoney = 0;
		for(var i=0;i<param.length;i++){
			var p = param[i];
			//组装时间字符串
			var times = p["time"].split(",");
			var tStr = "";
			for(var j=0;j<times.length;j++){
				var t = times[j];
				tStr+= (t+":00")+"-"+((t==23?0:(parseInt(t)+1))+":00&nbsp;&nbsp;");
			}
			//计算金额
			var money = parseInt(p["paymoney"]);
			
			//总金额
			allmoney+=money;
			
			form.append(
			'<fieldset>'+
				'<div class="form-group">'+
					'<label class="col-xs-2 txt-al-mar-pad">场馆</label>'+
					'<span class="col-xs-3 pa-t-7">'+p["gymName"]+'</span>'+
					'<label class="col-xs-2 txt-al-mar-pad">预约日期</label>'+
					'<span class="col-xs-3 pa-t-7">'+p["day"]+'</span>'+
				'</div>'+
				'<div class="form-group">'+
					'<label class="col-xs-2 txt-al-mar-pad">预约时间</label>'+
					'<span class="col-xs-10 pa-t-7">'+tStr+'</span>'+
				'</div>'+
				'<div class="form-group">'+
					'<label class="col-xs-2 txt-al-mar-pad">预约金额</label>'+
					'<span class="col-xs-10 pa-t-7">'+money+'</span>'+
				'</div>'+
			'</fieldset><HR>'
			);
		}
		
		form.append(
			'<fieldset>'+
			'<div class="form-group">'+
				'<label class="col-xs-2 txt-al-mar-pad">总金额</label>'+
				'<label class="col-xs-10 txt-al-mar-pad">'+allmoney+'</label>'+
			'</div>'+
			'</fieldset>'
		)

	}
</script>
<jsp:include page="/html/footer.jsp" flush="true"></jsp:include> 
	</body>

</html>
