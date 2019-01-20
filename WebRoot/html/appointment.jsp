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
    <title>北京化工大学场馆预约</title>
</head>
<body>
<jsp:include page="/html/head.jsp" flush="true">     
     <jsp:param name="nowPage" value="appointment"/> 
</jsp:include>
 	
    <div id="nav-main" style="overflow: auto;width: 100%"></div>
    <br>
    <div class="row">
        <div class="col-md-12">
            <marquee id="affiche" align="left" behavior="scroll" bgcolor="#ECF5FF" direction="left" loop="-1" scrollamount="10" scrolldelay="10" onMouseOut="this.start()" onMouseOver="this.stop()">
                <font size="6" style="height: auto" id="notice"></font>
            </marquee>
        </div>
    </div>
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
                                    
                                </thead>
                                <tbody style="overflow: auto">
                                </tbody>
                            </table>
                        </div>
                    </div>
             		<!--   多选 -->
                    <!-- <div class="row">  
                        <button type="button" class="btn btn-primary " style="width: 100%" id="sendOrder">
                            <span class="glyphicon">预约场地</span>
                        </button>
                    </div> -->
                </div>
            </div>
        </div>
    </div>
<jsp:include page="/html/footer.jsp" flush="true"></jsp:include> 

<div id="alert-gym-dialog" style="display:none;margin:0;">
	<form id ="alert-gym-form" class="form-horizontal"></form>
</div>

<div id="gym-qc" style="display:none;margin:0;">
	<img alt="" src="">
</div>

<script type="text/javascript">
//初始化场馆列表
function initGym(data){
	
	var table = $("#gymTable");
	
	var thead = table.find("thead");
	var body = table.find("tbody");
	thead.empty();
	body.empty();
	
	var headTr = $('<tr><td style="text-align: center" width="150">时间</td></tr>');
	
	var gym = data.gym;			//场馆
	var orderMap = data.order;	//预约信息
	var pause = data.pause;		//暂停预约信息
	var now = new Date();//系统当前日期（day）
	var onDay = parseInt(param["onDay"].split("-")[2]);//已选择当前日期
	
	var times = gym["onTime"];
	
	gym.forEach(function(g){
		headTr.append('<td style="text-align: center;">'+g["name"]+'</td>');
		var times = g["onTime"] || "";
		times = JSON.parse(times);
		
		times.forEach(function(time){
			var tr = $('<tr style="text-align: center"></tr>');
			tr.append('<td>'+time.start+'&nbsp;--&nbsp;'+time.end+'</td>');
			var status = getStatus(time,g,orderMap,now,onDay,pause);
			
			var nameTd = $('<td style="text-align: center;"><span class="label label-'+status["css"]+' gym-base" >'+status["name"]+'</span></td>');
			nameTd.find("span").on("click",function(e){
				var label = $(e.target);
				//不可预约直接返回
				if(!label.hasClass('label-primary')){
					return;
				}
				
				var param = toParam(time,g);
				if(param==null || param==""){
					alert("请选择预约场地!");
					return;
				}
				initAlertForm(param);
				param.time = param.time.id;
				$("#alert-gym-dialog").dialog("option",{"param": param});
				$("#alert-gym-dialog").dialog("open");
			});
			tr.append(nameTd);
			
			body.append(tr);
		});
	});
	
	thead.append(headTr);
	
}
//获取当前对应的可预约状态
function getStatus(time,gym,orderMap,now,onDay,pause){
	var startHour = parseInt(time.start.substring(0,2));
    var nowHour = now.getHours()+1;
  	//是否过期
	if(onDay==now.getDate() && startHour<(nowHour)){
		return gymStatus["expire"];
	}
  	//是否暂停预约
  	var pauseTimeId = pause[gym["id"]];
  	if(pauseTimeId==time.id){
  		return gymStatus["pause"];
  	}
  	
	//场馆可预约状态
  	//场馆是否已经预约的状态
    var key = gym["id"]+"-"+time.id;
    if(orderMap[key]==1){
    	return gymStatus["pay"];
    }
    if(orderMap[key]==2){
    	return gymStatus["success"];
    }
    //可预约
    return gymStatus["on"];
    
}
//初始化搜索条件中场馆信息
function initParamGym(data){
	var pg = $("#param-gym");
	pg.empty();
	
	var gym = data.gym;
	for(var i=0;i<gym.length;i++){
		var g = gym[i];
		var li = $('<li><a href="javascript:void(0);">'+g["name"]+'</a></li>');
		li.find("a").on("click",{gym:g},function(e){
			var li = $(e.target).parent("li");
			var gymData = e.data.gym;
			li.siblings().removeClass("active");
			li.addClass("active");
			
			param["gymId"] = gymData["id"];
			
			//场馆预约列表
			initGym({
				gym:[gymData],
				order:data.order,
				pause:data.pause
			});
		})
		pg.append(li);
	}
	pg.find("li").first().find("a").click();
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
	search();
}
//搜索条件中点击日期事件
function dayclick(){
	var li = $(this);
	li.siblings().removeClass("active");
	li.addClass("active");
	param["onDay"] = li.find("a").attr("value");
	param["gymId"] = null;
	search();
}
var time = [6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21];//预约时间
var param = {gymId:null,onDay:null,gymType:null};//搜索参数
var orderParam = [];//预约参数（前端）
var gymStatus = {
	"on":{css:'primary',name:'可预约'},
	"off":{css:'default',name:'不可预约'},
	"expire":{css:'default',name:'已过期'},
	"pause":{css:'default',name:'暂停预约'},
	"pay":{css:'info',name:'付款中'},
	"success":{css:'danger',name:'已预约'}
}
$(document).ready(function() {
	//初始化搜索条件  刚进页面只传日期
	initParamDay();
	initNotice();
	
	$.ajax({
   		url: "${rootUrl}gymType/all.do",
   		type: "get",
   		dataType:"json",
   		contentType: "application/json",
   		success: function(data){
			if(data.code==0 && data.data!=null){
				initParamGymType(data.data);
			}else{
				alert("查询失败");
			}
		} 
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
				var options = $("#alert-gym-dialog").dialog( "option" );
				$.ajax({
			   		url: "${rootUrl}order/approve.do",
			   		type: "post",
			   		data:JSON.stringify([options.param]),
			   		dataType:"json",
			   		contentType: "application/json",
			   		success: function(data){
						if(data.code==0 && data.data!=null){
							$("#alert-gym-dialog").dialog("close");
							//显示二维码
							$("#gym-qc").dialog("open");
							$("#gym-qc").find("img").prop("src","${rootUrl}order/qcImage.do?orderId="+data.data);
						}else{
							alert(data.msg);
						}
					} 
				});
			}
		}]
					
	});
	
	$("#gym-qc").dialog({
		autoOpen : false,
		title:"请用微信扫描二维码付款",
		modal : true,
		height:400, 
		width:400,
		beforeClose:function(){
			window.location.reload();
		}
	});
});

//初始化预约场地提示框
function initAlertForm(param){
	var form = $("#alert-gym-form");
	form.empty();
	var allmoney = 0;
	var p = param;
	//组装时间字符串
	var time = p["time"];
	var tStr = time.start+"-"+time.end;
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
	
	form.append(
		'<fieldset>'+
		'<div class="form-group">'+
			'<label class="col-xs-2 txt-al-mar-pad">总金额</label>'+
			'<label class="col-xs-10 txt-al-mar-pad">'+allmoney+'</label>'+
		'</div>'+
		'</fieldset>'
	)

}
function search(isTypeClick){
	//获取场馆预约列表
	$.ajax({
   		url: "${rootUrl}gym/getData.do",
   		type: "post",
   		data:param,
   		dataType:"json",
   		success: function(data){
			if(data.code==0 && data.data!=null){
				//初始化场馆搜索列表
				initParamGym(data.data);
			}else{
				alert("查询失败");
			}
		} 
	});
	
}
//预约参数  前端格式转换为后端格式
function toParam(time,gym){
	var result = [];
	if(!!time && !!gym){
		return {
			gymName:gym.name,
			gymId:gym.id,
			paymoney:gym.money,
			money:gym.money,
			time:time,
			day:$("#param-day").find("li.active a").attr("value")
		};
	}
	return {};
}
//获取今天以及后三天的字符串
function getDay(day){
	var mydate = new Date();
	var result = [];
	var str = "" + mydate.getFullYear() + "-";
	var month = (mydate.getMonth()+1);
	str += (month<10?("0"+month):month) + "-";
	
	var day = mydate.getDate();
	var next = day+1;
	result.push(str+(day<10?("0"+day):day));
	result.push(str+(next<10?("0"+next):next));
	return result;
}

function initNotice(){
	//获取场馆预约列表
	$.ajax({
   		url: "${rootUrl}notice/load.do",
   		type: "get",
   		dataType:"json",
   		success: function(data){
			if(data.code==0 && data.data!=null){
				var el = $("#notice");
				var msg = "";
				data.data.forEach(function(notice){
					msg += (notice["msg"]+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
				})
				el.html(msg);
			}else{
				alert("查询失败");
			}
		} 
	});
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