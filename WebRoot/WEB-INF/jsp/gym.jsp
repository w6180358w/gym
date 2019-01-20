<%@page import="java.text.SimpleDateFormat"%>
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
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	Calendar cal = Calendar.getInstance();
	String today = sdf.format(cal.getTime());	//今天
	cal.add(Calendar.DAY_OF_YEAR, 1);
	String tomorrow = sdf.format(cal.getTime());//明天
	
	Map<String,String> typeMap = new HashMap<String,String>();
	for(GymType type : gymTypeList){
		typeMap.put(type.getId().toString(), type.getName());
	}
	
%>
<c:url value="/" var="rootUrl" scope="application"></c:url>
<c:if test="${fn:contains(rootUrl,';jsession')}">
	<c:set value="${fn:split(rootUrl,';')[0] }" var="rootUrl"
		scope="application" />
</c:if>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/select.css">
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
												<td><%=typeMap.get(gym.getType()) %></td>
												<td><%=gym.getMoney()+"" %></td>
												<td>
												<button class="btn btn-primary btn-sm" onclick="pause('<%=gym.getId() %>');">暂停预约</button>
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
						<div class="col-xs-10 txt-al-mar-pad" id="time"></div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">价格（元）</label>
						<div class="col-xs-10">
							<input type="number" class="form-control" name="money" id="money" required min=0.01>
						</div>
					</div>
				</fieldset>
			</form>
			</div>
			<!-- 弹出窗口 -->
		<div id="PauseDialog" style="display:none;margin:0;">
			<form id ="PauseForm" class="form-horizontal" >
				<fieldset>
					<input type="hidden" name="p_id" id="p_id" ></input>
					<input type="hidden" name="p_gymId" id="p_gymId" ></input>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">日期</label>
						<div class="col-xs-10">
							<select class="form-control" name="p_day" id="p_day" required>
								<option value="<%=today%>"><%=today%></option>
								<option value="<%=tomorrow%>"><%=tomorrow%></option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">暂停时间</label>
						<div class="col-xs-10 txt-al-mar-pad" id="pauseTime"></div>
					</div>
				</fieldset>
			</form>
			</div>
		<div id="power" style="display:none;margin:0;">
			<div id="power-message">
				
			</div>
		</div>
		
<script src="${rootUrl}js/select.js"></script>
<script src="${rootUrl}js/jquery-timepicker.js"></script>
<script>
	var isEdit = false;
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

	function pauseSubmit() {
		var ids = [];
		$("#pauseTime").find("input[name=timeId]").each(function(index,el){
			var checkbox = $(el);
			if(checkbox.is(":checked")){
				ids.push(checkbox.val())
			}
		});
   		$.ajax({
       		url: $("#PauseDialog").dialog("option","isEdit")?"${rootUrl}pause/update.do":"${rootUrl}pause/save.do",
       		type: "post",
       		data: {id:$("#p_id").val(),
       			gymId:$("#p_gymId").val(),
       			day:$("#p_day").val(),
       			pauseTime:ids.join()},
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
		$("#time").empty();
		var time = Gym["onTime"] || JSON.stringify([{'start':'','end':''}]);
		time = JSON.parse(time);
		time.forEach(function(t){
			addTimePicker(t.start,t.end);
		});
	}
	function setPauseForm(pause){
		pause = pause || [];
		$("#pauseTime").empty();
		pause.forEach(function(p){
			$("#p_id").val(p.id);
			if(!!p.id){
				$("#PauseDialog").dialog({isEdit:true});
			 }else{
				 $("#PauseDialog").dialog({isEdit:false});
			 }
			//渲染
			var view = $(
					'<div class="form-group" key="group">'+
					'	<div class="col-xs-1"><input type="checkbox" '+p.status+' name="timeId" value="'+p.timeId+'"></div>'+
					'	<div class="col-xs-6" >'+
					'		<span class="col-xs-5" >'+p.start+'</span>'+
					'		<span class="col-xs-1" >-</span>'+
					'		<span class="col-xs-5" >'+p.end+'</span>'+
					'	</div>'+
					'</div>'
				);
			$("#pauseTime").append(view);
		});
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
    	var times = [];
    	$("#time").find("div[key=group]").each(function(){
    		var start = $(this).find("input[name=timeStart]").val();
    		var end = $(this).find("input[name=timeEnd]").val();
    		times.push({
    			id:start.replace(":","")+end.replace(":","")+uuid(16,16),
    			start:start,
    			end:end
    		});
    	});
    	o["onTime"] = JSON.stringify(times);
    	return o;
	}
	function isDel(id){
		$("#power-message").html("<h5 class='text-center line-70'>确认删除？</h5>")  ;
		$("#power").dialog("open");
		$("#power").dialog({width:300,height:200});
		$("#power").dialog({id:id});
	}

	function pause(id){
		$("#p_gymId").val(id);
		$("#PauseDialog").dialog({id:id});
		$("#PauseDialog").dialog("open");
		$("#p_day").trigger("change");
	}
	
	//添加时间区域
	function addTimePicker(start,end){
		var time = $("#time");
		time.find("button.add").remove();
		var view = $(
			'<div class="form-group" key="group">'+
			'	<div class="col-xs-4">'+
			'		<input name="timeStart" class="form-control time" required readOnly value="'+(start || "")+'">'+
			'	</div>'+
			'	<div class="col-xs-1">'+
			'		-'+
			'	</div>'+
			'	<div class="col-xs-4" >'+
			'		<input name="timeEnd" class="form-control time" required readOnly value="'+(end || "")+'">'+
			'	</div>'+
			'	<div class="col-xs-3" >'+
			'	<button type="button" class="btn btn-primary btn-sm del">-</button>'+
			'	<button type="button" class="btn btn-primary btn-sm add">+</button>'+
			'	</div>'+
			'</div>'
		);
		
		time.append(view);
		view.find("input.time").hunterTimePicker();
		view.find("input.time").rules("add",{required:true});
		view.find("button.del").click(function(){
			delTimePicker(this);
		});
		view.find("button.add").click(function(){
			addTimePicker();
		});
	}
	//删除时间区域
	function delTimePicker(el){
		var time = $("#time");
		var times = time.find('div[key=group]');
		var prev = $(el).parents('div[key=group]').prev();
		if(times.length>1 || prev.length>0){
			$(el).parents('div[key=group]').remove();
			if( time.find('button.add').length==0){
				prev.find("button.del").parent("div.col-xs-3").append(
					'<button type="button" class="btn btn-primary btn-sm add">+</button>'
				)
				prev.find("button.add").click(function(){
					addTimePicker();
				});
			}
		}else{
			$(el).parents('div[key=group]').find("input").val("");
		}
	}
	$(document).ready(function() {
		$("#GymForm").validate();
		$("#time").find("input").hunterTimePicker({
		     callback: function(e){
		        //console.log(e);
		     }
		});
		
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
		
		$("#PauseDialog").dialog({
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
					pauseSubmit();
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
		
		$("#p_day").on("change",function(){
			$.ajax({
	       		url: "${rootUrl}pause/getData.do?gymId="+$("#p_gymId").val()+"&day="+$("#p_day").val(),
	       		type: "get",
	       		dataType:"json",
	       		success: function(data){
					if(data.code==0){
						 setPauseForm(data.data);
					}else{
						alert("查询失败");
					} 
				} 
	   		});
		});
	});
	
	function uuid(len, radix) {
	    var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
	    var uuid = [], i;
	    radix = radix || chars.length;
	 
	    if (len) {
	      // Compact form
	      for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random()*radix];
	    } else {
	      // rfc4122, version 4 form
	      var r;
	 
	      // rfc4122 requires these characters
	      uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
	      uuid[14] = '4';
	 
	      // Fill in random data.  At i==19 set the high bits of clock sequence as
	      // per rfc4122, sec. 4.1.5
	      for (i = 0; i < 36; i++) {
	        if (!uuid[i]) {
	          r = 0 | Math.random()*16;
	          uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
	        }
	      }
	    }
	 
	    return uuid.join('');
	}
</script>
</div>
<jsp:include page="/html/footer.jsp" flush="true"></jsp:include> 
</body>
</html>