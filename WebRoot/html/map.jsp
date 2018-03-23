<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="com.model.*"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	List<Gym> GymList = (List<Gym>)request.getAttribute("GymList");
%>
<c:url value="/" var="rootUrl" scope="application"></c:url>
<c:if test="${fn:contains(rootUrl,';jsession')}">
	<c:set value="${fn:split(rootUrl,';')[0] }" var="rootUrl"
		scope="application" />
</c:if>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/smartadmin-production-plugins.min.css">
    <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/jquery-ui.css">
    <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/add-app-class.css">
    <script src="../js/jquery-3.2.1.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <title>北京化工大学场馆地图</title>
</head>

<body>
<div class="container">
    <div class="row">
        <div class="log-box">
            <div id="logo" class="log">
                <a href="../index.html"><img src="../images/buct.jpg" class="img-responsive" /></a>
                <!--<a href="###">手机版</a>-->
                <!--<span >&nbsp;|&nbsp;</span>-->
                <!--<a href="###">意见反馈</a>-->
            </div>
        </div>
    </div>
    <div class="row">
        <div>
            <ul class="nav nav-tabs">
                <li><a href="../index.jsp">首页</a></li>
                <li><a href="stadium.jspl">场馆</a></li>
                <li><a href="appointment.jsp">场地预约</a></li>
                <li class="active"><a href="#">地图</a></li>
            </ul>
        </div>
    </div>
</div>
<div id="nav-main" style="overflow: auto;width: 100%"></div>
<br>
<div class="container">
    <!-- MAIN PANEL -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
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
												<th>场馆名称</th>
												<th>场馆类型</th>
												<th>可预约时间</th>
												<th>预约金额(小时)</th>
												<th>操作</th>
											</tr>
										</thead>
										<tbody>
										<%for(int i =0;GymList!=null && i<GymList.size();i++){
											Gym gym = GymList.get(i);
										%>
											<tr>
												<td><%=gym.getName() %></td>
												<td><%=gym.getStatus() %></td>
												<td><%=gym.getType() %></td>
												<td><%=gym.getOnTime() %></td>
												<td>
												<button class="btn btn-primary btn-sm" onclick="update('<%=gym.getId() %>');">修改</button>
												<button class="btn btn-primary btn-sm" onclick="isDel('<%=gym.getId() %>');">删除</button>
													
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
		<div id="GymDialog" style="display:none;margin:0;">
			<form id ="GymForm" class="form-horizontal" method="post" onSubmit="return check()" >
				<fieldset>
				<input type="hidden" name="id" id="id" ></input>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">姓名</label>
						<div class="col-xs-10">
							<input class="form-control" type="text" name="name" id="name">
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">加入时间</label>
						<div class="col-xs-10">
							<input class="form-control" type="text" name="addTime" id="addTime">
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">推荐人</label>
						<div class="col-xs-10">
							<input class="form-control" type="text" name="rec" id="rec">
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">是否会员</label>
						<div class="col-xs-10">
							<select class="form-control" name="vip" id="vip">
								<option value=1>是</option>
								<option value=0>否</option>
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
		
		<script src="${rootUrl}js/jquery-3.2.1.min.js"></script>
		<script src="${rootUrl}js/jquery.validate.min.js"></script>
		<script src="${rootUrl}js/jquery-ui-1.10.3.min.js"></script>
		<script src="${rootUrl}js/jquery.dataTables.min.js"></script>
		<script src="${rootUrl}js/dataTables.colVis.min.js"></script>
		<script src="${rootUrl}js/dataTables.tableTools.min.js"></script>
		<script src="${rootUrl}js/dataTables.bootstrap.min.js"></script>
		<script>
	var isEdit = false;
    //将form转为AJAX提交
	function ajaxSubmit() {
		var form = document.getElementById("GymForm");
		var dataPara = getFormJson(form);
   		$.ajax({
       		url: isEdit?"${rootUrl}Gym/update.do":"${rootUrl}Gym/save.do",
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
       		url: "${rootUrl}Gym/del.do?id="+id,
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
       		url: "${rootUrl}Gym/get.do?id="+id,
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
		$("#GymDialog").dialog("open");
	}
	function setForm(Gym){
		$("#id").val(Gym["id"]);
		$("#name").val(Gym["name"]);
		$("#addTime").val(Gym["addTime"]);
		$("#rec").val(Gym["rec"]);
		$("#vip").val(Gym["vip"]);
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
		$("#power-message").html("<h5 class='text-center line-70'>确认删除？</h5>")  ;
		$("#power").dialog("open");
		$("#power").dialog({width:300,height:200});
		$("#power").dialog({id:id});
	}

	$(document).ready(function() {
		$("#adds").validate();
		$("#GymForm").validate();
		/* BASIC ;*/
		
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
					$("#GymDialog").dialog("open");
				}
			}],
			},
			"autoWidth" : true
		}); 
		$("#GymDialog").dialog({
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
		
		
		$.datepicker.regional["zh-CN"] = { closeText: "关闭", prevText: "&#x3c;上月", nextText: "下月&#x3e;", currentText: "今天", monthNames: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"], monthNamesShort: ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"], dayNames: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"], dayNamesShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"], dayNamesMin: ["日", "一", "二", "三", "四", "五", "六"], weekHeader: "周", dateFormat: "yy-mm-dd", firstDay: 1, isRTL: !1, showMonthAfterYear: !0, yearSuffix: "年" }
        $.datepicker.setDefaults($.datepicker.regional["zh-CN"]);
		$('#addTime').datepicker({
			dateFormat : 'yy-mm-dd',
			prevText : '<i class="fa fa-chevron-left"></i>',
			nextText : '<i class="fa fa-chevron-right"></i>',
			onSelect : function(selectedDate) {
				$('#addTime').datepicker('option', '', selectedDate);
			}
		});
						
	});
</script>
</div>
<!--页脚版权信息-->
<div>
    <footer>
        <button type="button" class="btn btn-primary " style="width: 100%">
            <span class="glyphicon">北京化工大学© 版权所有  &nbsp;&nbsp;主办部门：北京化工大学信息中心</span>
        </button>
    </footer>
</div>
</body>
</html>