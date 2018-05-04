<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="com.model.*"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
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
    <title>北京化工大学场馆地图</title>
</head>

<body>
<jsp:include page="/html/head.jsp" flush="true">     
     <jsp:param name="nowPage" value="gymType"/> 
</jsp:include>
<div id="nav-main" style="overflow: auto;width: 100%"></div>
<br>
<div class="container">
    <!-- MAIN PANEL -->
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<div id="myTable" class="col-xs-12 jarviswidget jarviswidget-color-blueDark">
							<header> <span>&nbsp;&nbsp;<i class="fa fa-table"></i>&nbsp;&nbsp;
								<h2>
									场地类型管理
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
												<th>场馆类型名称</th>
												<!-- <th>描述</th> -->
												<th>操作</th>
											</tr>
										</thead>
										<tbody>
										<%for(int i =0;gymTypeList!=null && i<gymTypeList.size();i++){
											GymType gymType = gymTypeList.get(i);
										%>
											<tr>
												<td><%=gymType.getName() %></td>
												<%-- <td><%=gymType.getDesc() %></td> --%>
												<td>
												<button class="btn btn-primary btn-sm" onclick="update('<%=gymType.getId() %>');">修改</button>
												<button class="btn btn-primary btn-sm" onclick="isDel('<%=gymType.getId() %>');">删除</button>
													
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
		<div id="gymTypeDialog" style="display:none;margin:0;">
			<form id ="gymTypeForm" class="form-horizontal" method="post" onSubmit="return check()" >
				<fieldset>
				<input type="hidden" name="id" id="id" ></input>
					<div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">体育馆名称</label>
						<div class="col-xs-10">
							<input class="form-control" name="name" id="name" required>
						</div>
					</div>
					<!-- <div class="form-group">
						<label class="col-xs-2 txt-al-mar-pad">描述</label>
						<div class="col-xs-10">
							<textarea class="form-control" name="desc" id="desc" required></textarea>
						</div>
					</div> -->
				</fieldset>
			</form>
			</div>
		<div id="power" style="display:none;margin:0;">
			<div id="power-message">
				
			</div>
		</div>
		
		<script>
	var isEdit = false;
	var box;
    //将form转为AJAX提交
	function ajaxSubmit() {
		var form = document.getElementById("gymTypeForm");
		var dataPara = getFormJson(form);
		if(!$(form).valid()){
			return;
		}
   		$.ajax({
       		url: isEdit?"${rootUrl}gymType/update.do":"${rootUrl}gymType/save.do",
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
       		url: "${rootUrl}gymType/del.do?id="+id,
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
       		url: "${rootUrl}gymType/get.do?id="+id,
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
		$("#gymTypeDialog").dialog("open");
	}
	function setForm(gymType){
		$("#id").val(gymType["id"]);
		$("#name").val(gymType["name"]);
		$("#desc").val(gymType["desc"]);
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
		$("#gymTypeForm").validate();
		
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
					$("#gymTypeDialog").dialog("open");
				}
			}],
			},
			"autoWidth" : true
		}); 
		$("#gymTypeDialog").dialog({
			autoOpen : false,
			modal : true,
			height:200, 
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
	});
</script>
</div>
<jsp:include page="/html/footer.jsp" flush="true"></jsp:include> 
</body>
</html>