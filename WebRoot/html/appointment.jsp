<%@page import="com.model.*"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:url value="/" var="rootUrl" scope="application"></c:url>
<c:if test="${fn:contains(rootUrl,';jsession')}">
	<c:set value="${fn:split(rootUrl,';')[0] }" var="rootUrl"
		scope="application" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>北京化工大学场馆预约</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/jquery-ui.css">
    <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/add-app-class.css">
    <script src="../js/jquery-2.1.1.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <script src="${rootUrl}js/jquery-ui-1.10.3.min.js"></script>
</head>
<body>
<jsp:include page="/html/head.jsp" flush="true">     
     <jsp:param name="nowPage" value="appointment"/> 
</jsp:include>
 	
    <div id="nav-main" style="overflow: auto;width: 100%"></div>
    <br>
    <div class="container">
        <div class="row">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h2 id="section-1" class="panel-title">当前位置：场地预约</h2>
                </div>
                <div class="panel-body">
               	 	<label>场馆类型选择：</label>
                    <ul class="nav nav-pills" id="param-gym-type"></ul>
                    <label>场馆选择：</label>
                    <ul class="nav nav-pills" id="param-gym"></ul>
                    <label>日期选择：<font color="red">注：只显示当日和明日场馆预约情况</font></label>
                    <ul class="nav nav-pills" id="param-day"></ul>
                    <br>
                    <div>
                        <label style="font-size: large">说明：</label>
                        <span class="label label-default">不可预约</span>
                        <span class="label label-default">已过期</span>
                        <span class="label label-info">付款中</span>
                        <span class="label label-primary">可预约</span>
                        <span class="label label-danger">已预约</span>
                    </div>
                    <div class="row">
                        <div class="col-md-12" style="overflow: auto">
                            <table class="table table-bordered" id="gymTable">
                                <thead class="navbar-static-top">
                                    <tr>
                                        <td style="text-align: center" width="150">时间</td>
                                    </tr>
                                </thead>
                                <tbody style="overflow: auto">
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row">
                        <button type="button" class="btn btn-primary " style="width: 100%" id="sendOrder">
                            <span class="glyphicon">预约场地</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
<jsp:include page="/html/footer.jsp" flush="true"></jsp:include> 

<div id="alert-gym-dialog" style="display:none;margin:0;">
	<form id ="alert-gym-form" class="form-horizontal"></form>
</div>
		
<script type="text/javascript">
//初始化场馆列表
function initGym(data){
	var table = $("#gymTable");
	var headTr = table.find("thead>tr").first();
	var body = table.find("tbody");
	
	headTr.children().first().siblings().remove();
	body.empty();
	orderParam = [];
	
	var gym = data.gym;
	var orderMap = data.order;
	var now = new Date();//系统当前日期（day）
	var onDay = parseInt(param["onDay"].split("-")[2]);//已选择当前日期
	
	//加行
	for(var i=0;i<time.length;i++){
		var tr = $('<tr style="text-align: center"></tr>');
		tr.append('<td>'+time[i]+'：00&nbsp;--&nbsp;'+(time[i]==24?'00':(time[i]+1))+'：00</td>');
		//加列
		for(var j=0;j<gym.length;j++){
			if(i==0){
				headTr.append('<td style="text-align: center;">'+gym[j]["name"]+'</td>');
				orderParam.push({gymId:gym[j]["id"],gymName:gym[j]["name"],time:[],money:gym[j]["money"]});
			}
			var status = getStatus(time[i],gym[j],orderMap,now,onDay);
			
			tr.append($('<td style="text-align: center;"><span data-time="'+time[i]+'" data-index='+j+' class="label label-'+status["css"]+' gym-base">'+status["name"]+'</span></td>').find("span").on("click",labelClick).parent("td"));
		}
		body.append(tr);
	}
}
//获取当前对应的可预约状态
function getStatus(index,gym,orderMap,now,onDay){
    var nowHour = now.getHours()+1;
	//场馆可预约状态
	var arr = gym["onTime"].split(",");
	for(var i = 0; i < arr.length; i++){
		//可预约状态判断是否可用
        if(index === parseInt(arr[i])){
        	//是否过期
        	if(onDay==now.getDate() && index<(nowHour)){
        		return gymStatus["expire"];
        	}
        	//场馆是否已经预约的状态
            var key = gym["id"]+"-"+index;
            if(orderMap[key]==1){
            	return gymStatus["pay"];
            }
            if(orderMap[key]==2){
            	return gymStatus["success"];
            }
            //可预约
            return gymStatus["on"];
        }
    }
	//不可预约
    return gymStatus["off"];
    
}
//初始化搜索条件中场馆信息
function initParamGym(data){
	var pg = $("#param-gym");
	pg.empty();
	pg.append($('<li class="active"><a href="javascript:void(0);">不限</a></li>').on("click",gymclick));
	
	var gym = data.gym;
	for(var i=0;i<gym.length;i++){
		pg.append($('<li><a href="javascript:void(0);" value='+gym[i]["id"]+'>'+gym[i]["name"]+'</a></li>').on("click",gymclick));
	}
}
//初始化搜索条件中场馆信息
function initParamGymType(data){
	var pg = $("#param-gym-type");
	
	pg.append($('<li class="active"><a href="javascript:void(0);">不限</a></li>').on("click",gymTypeclick));
	
	var gym = data;
	for(var i=0;i<gym.length;i++){
		pg.append($('<li><a href="javascript:void(0);" value='+gym[i]["id"]+'>'+gym[i]["name"]+'</a></li>').on("click",gymTypeclick));
	}
}
//初始化搜索条件中日期信息
function initParamDay(){
	var day = $("#param-day");
	var dayData = getDay();
	for(var i=0;i<dayData.length;i++){
		day.append($('<li><a href="javascript:void(0);" value='+dayData[i]+'>'+dayData[i]+'</a></li>').on("click",dayclick));
	}
	day.find("li").first().click();
}
//搜索条件中点击场馆事件
function gymTypeclick(){
	var li = $(this);
	li.siblings().removeClass("active");
	li.addClass("active");
	param["gymType"] = li.find("a").attr("value");
	param["gymId"] = null;
	search(true);
}
//搜索条件中点击场馆事件
function gymclick(){
	var li = $(this);
	li.siblings().removeClass("active");
	li.addClass("active");
	param["gymId"] = li.find("a").attr("value");
	search();
}
//搜索条件中点击日期事件
function dayclick(){
	var li = $(this);
	li.siblings().removeClass("active");
	li.addClass("active");
	param["onDay"] = li.find("a").attr("value");
	search();
}
//点击预约label事件
function labelClick(){
	var label = $(this);
	//不可预约直接返回
	if(!label.hasClass('label-primary')){
		return;
	}
	var time = label.data("time");
	var index = label.data("index");
	//判断是选中还是消除
	if (label.hasClass('label-success')) {
		//消除样式  去掉参数
		label.removeClass('label-success');
		orderParam[index]["time"].remove(time);
    }else{
    	//添加样式  添加参数
    	label.addClass("label-success");
    	orderParam[index]["time"].push(time);
    }
}
var time = [6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,1,2,3,4,5];//预约时间
var param = {gymId:null,onDay:null,gymType:null};//搜索参数
var orderParam = [];//预约参数（前端）
var gymStatus = {
	"on":{css:'primary',name:'可预约'},
	"off":{css:'default',name:'不可预约'},
	"expire":{css:'default',name:'已过期'},
	"pay":{css:'info',name:'付款中'},
	"success":{css:'danger',name:'已预约'}
}
$(document).ready(function() {
	//初始化搜索条件  刚进页面只传日期
	initParamDay();
	search(true);
	
	$.ajax({
   		url: "${rootUrl}gymType/all.do",
   		type: "get",
   		dataType:"json",
   		contentType: "application/json",
   		success: function(data){
   			console.log(data);
			if(data.code==0 && data.data!=null){
				initParamGymType(data.data);
			}else{
				alert("查询失败");
			}
		} 
	});
	
	$("#sendOrder").on("click",function(){
		var param = toParam(orderParam);
		console.log(param);
		if(param==null || param==""){
			alert("请选择预约场地!");
			return;
		}
		initAlertForm(param);
		$("#alert-gym-dialog").dialog("open");
	});
	
	$("#alert-gym-dialog").dialog({
		autoOpen : false,
		title:"确认预约",
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
			html : "<i class='fa fa-check'></i>&nbsp; 预约",
			"class" : "btn btn-primary btn-sm",
			click : function() {
				var param = toParam(orderParam);
				console.log(param);
				
				$.ajax({
			   		url: "${rootUrl}order/approve.do",
			   		type: "post",
			   		data:JSON.stringify(param),
			   		dataType:"json",
			   		contentType: "application/json",
			   		success: function(data){
			   			console.log(data);
						if(data.code==0 && data.data!=null){
							window.location.reload();
						}else{
							alert("查询失败");
						}
					} 
				});
			}
		}]
					
	});
});

//初始化预约场地提示框
function initAlertForm(param){
	var form = $("#alert-gym-form");
	form.empty();
	var allmoney = 0;
	for(var i=0;i<param.length;i++){
		console.log(i)
		var p = param[i];
		//组装时间字符串
		var times = p["time"].split(",");
		var tStr = "";
		for(var j=0;j<times.length;j++){
			var t = times[j];
			tStr+= (t+":00")+"-"+((t==23?0:(parseInt(t)+1))+":00&nbsp;&nbsp;");
			
		}
		//计算金额
		var money = times.length*parseInt(p["money"]);
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
function search(initSearch){
	//获取场馆预约列表
	$.ajax({
   		url: "${rootUrl}gym/getData.do",
   		type: "post",
   		data:param,
   		dataType:"json",
   		success: function(data){
			if(data.code==0 && data.data!=null){
				//场馆预约列表
				initGym(data.data);	
				if(initSearch){
					console.log("init")
					//初始化场馆搜索列表
					initParamGym(data.data);
				}
			}else{
				alert("查询失败");
			}
		} 
	});
	
}
//预约参数  前端格式转换为后端格式
function toParam(p){
	var result = [];
	for(i in p){   
		var bean = p[i];
		if(bean["time"]!=null && bean["time"].length>0){
			result.push({gymId:bean["gymId"],gymName:bean["gymName"],time:bean["time"].join(),day:param["onDay"],money:bean["money"]});
		}
	}
	return result;
}
//获取今天以及后三天的字符串
function getDay(day){
	var mydate = new Date();
	var result = [];
	var str = "" + mydate.getFullYear() + "-";
	var month = (mydate.getMonth()+1);
	str += (month<10?("0"+month):month) + "-";
	
	result.push(str+mydate.getDate());
	result.push(str+(mydate.getDate()+1));
	return result;
}

//以下为数组删除元素方法
Array.prototype.indexOf = function(val) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == val) return i;
    }
    return -1;
};

Array.prototype.remove = function(val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};
</script>
</body>
</html>