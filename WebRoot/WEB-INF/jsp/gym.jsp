<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="com.model.*"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%List<User> userList = (List<User>)request.getAttribute("userList");%>
<%
	List<Gym> gymList = (List<Gym>)request.getAttribute("gymList");
	List<GymType> gymTypeList = (List<GymType>)request.getAttribute("gymTypeList");
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
    <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/select.css">
    <script src="../js/jquery-3.2.1.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <title>北京化工大学场馆地图</title>
</head>

<body>
<jsp:include page="/html/head.jsp" flush="true">     
     <jsp:param name="nowPage" value="gym"/> 
</jsp:include>
<div id="nav-main" style="overflow: auto;width: 100%"></div>
<br>
<div class="container">
    <!-- MAIN PANEL -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<div id="myTable" class="col-xs-12 jarviswidget jarviswidget-color-blueDark">
							<header> <span>&nbsp;&nbsp;<i class="fa fa-table"></i>&nbsp;&nbsp;
								<h2>
									场地管理
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
												<th>预约金额(元)</th>
												<th>操作</th>
											</tr>
										</thead>
										<tbody>
										<%for(int i =0;gymList!=null && i<gymList.size();i++){
											Gym gym = gymList.get(i);
										%>
											<tr>
												<td><%=gym.getName() %></td>
												<td><%=gym.getType() %></td>
												<td><%=gym.getOnTime() %></td>
												<td><%=gym.getMoney()+"" %></td>
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
						<label class="col-xs-2 txt-al-mar-pad">体育馆名称</label>
						<div class="col-xs-10">
							<input class="form-control" name="name" id="name" required>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">体育馆类型</label>
						<div class="col-xs-10">
							<select class="form-control" name="type" id="type" required>
							<%for(int i =0;gymTypeList!=null && i<gymTypeList.size();i++){
								GymType type = gymTypeList.get(i);%>
								<option value=<%=type.getId() %>><%=type.getName() %></option>
							<%}%>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">状态</label>
						<div class="col-xs-10">
							<select class="form-control" name="status" id="status" required>
								<option value=1>可用</option>
								<option value=0>不可用</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">可预约时间</label>
						<div class="col-xs-10">
							<div class="toggle-all-container">
               					<div class="gym_select select-box-container">
							        <div class="toggle-all-container">
							            <a href="javascript:void(0);" class="btn btn-md btn-default toggle-all-btn">全选/取消全选</a>
							        </div>
						        </div>
						    </div>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">价格（元）</label>
						<div class="col-xs-10">
							<input type="number" class="form-control" name="money" id="money" required min=0.01>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">描述</label>
						<div class="col-xs-10">
							<textarea class="form-control" name="desc" id="desc" required></textarea>
						</div>
					</div>
				</fieldset>
			</form>
			</div>
		<div id="power" style="display:none;margin:0;">
			<div id="power-message">
				
			</div>
		</div>
		
		<script src="${rootUrl}js/jquery-2.1.1.min.js"></script>
		<script src="${rootUrl}js/jquery.validate.min.js"></script>
		<script src="${rootUrl}js/jquery-ui-1.10.3.min.js"></script>
		<script src="${rootUrl}js/jquery.dataTables.min.js"></script>
		<script src="${rootUrl}js/dataTables.colVis.min.js"></script>
		<script src="${rootUrl}js/dataTables.tableTools.min.js"></script>
		<script src="${rootUrl}js/dataTables.bootstrap.min.js"></script>
		<script src="${rootUrl}js/select.js"></script>
		<script>
	var isEdit = false;
	var box;
    //将form转为AJAX提交
	function ajaxSubmit() {
		var form = document.getElementById("GymForm");
		var dataPara = getFormJson(form);
		if(dataPara["onTime"]==null || dataPara["onTime"]==""){
			alert("请添加预约时间！");
			return;
		}
		if(!$(form).valid()){
			return;
		}
   		$.ajax({
       		url: isEdit?"${rootUrl}gym/update.do":"${rootUrl}gym/save.do",
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
       		url: "${rootUrl}gym/del.do?id="+id,
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
       		url: "${rootUrl}gym/get.do?id="+id,
       		type: "get",
       		dataType:"json",
       		success: function(data){
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
		$("#desc").val(Gym["desc"]);
		$("#type").val(Gym["type"]);
		$("#status").val(Gym["status"]);
		$("#money").val(Gym["money"]);
		box.reset();
		box.setValues(Gym["onTime"]==null?[]:Gym["onTime"].split(","));
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
    	o["onTime"] = box.getValues().join();
    	return o;
	}
	function isDel(id){
		$("#power-message").html("<h5 class='text-center line-70'>确认删除？</h5>")  ;
		$("#power").dialog("open");
		$("#power").dialog({width:300,height:200});
		$("#power").dialog({id:id});
	}

	$(document).ready(function() {
		$("#GymForm").validate();
		
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
			height:580, 
			width:680, 
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
		box = initSelectBox('.gym_select',
				[
					{value:1,text:1},
					{value:2,text:2},
					{value:3,text:3},
					{value:4,text:4},
					{value:5,text:5},
					{value:6,text:6},
					{value:7,text:7},
					{value:8,text:8},
					{value:9,text:9},
					{value:10,text:10},
					{value:11,text:11},
					{value:12,text:12},
					{value:13,text:13},
					{value:14,text:14},
					{value:15,text:15},
					{value:16,text:16},
					{value:17,text:17},
					{value:18,text:18},
					{value:19,text:19},
					{value:20,text:20},
					{value:21,text:21},
					{value:22,text:22},
					{value:23,text:23},
					{value:24,text:24},
				],
				function(a){
			console.log(a);
		});	
	});
</script>
</div>
<jsp:include page="/html/footer.jsp" flush="true"></jsp:include> 
</body>
</html>