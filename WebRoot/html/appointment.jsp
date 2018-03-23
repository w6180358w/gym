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
    <script src="../js/jquery-3.2.1.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
</head>
<body>
    <div class="container">
        <div class="row">
            <div class="log-box">
                <div id="logo" class="log">
                    <a href="../index.jsp"><img src="../images/buct.jpg" class="img-responsive" /></a>
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
                    <li><a href="stadium.jsp">场馆</a></li>
                    <li class="active"><a href="#">场地预约</a></li>
                	<li><a href="${rootUrl }user/home.do">用户管理</a></li>
                	<li><a href="${rootUrl }gym/home.do">场地管理</a></li>
                </ul>
            </div>
        </div>
    </div>
    <div id="nav-main" style="overflow: auto;width: 100%"></div>
    <br>
    <div class="container">
        <div class="row">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h2 id="section-1" class="panel-title">当前位置：场地预约</h2>
                </div>
                <div class="panel-body">
                    <label>场馆选择：</label>
                    <ul class="nav nav-pills">
                        <li class="active"><a href="#">不限</a></li>
                        <li><a href="#">篮球场</a></li>
                        <li><a href="#">足球场</a></li>
                        <li><a href="#">羽毛球场</a></li>
                        <li><a href="#">排球场</a></li>
                        <li><a href="#">网球场</a></li>
                    </ul>
                    <label>运动项目选择：</label>
                    <ul class="nav nav-pills">
                        <li class="active"><a href="#">不限</a></li>
                        <li><a href="#">篮球</a></li>
                        <li><a href="#">足球</a></li>
                        <li><a href="#">羽毛球</a></li>
                        <li><a href="#">排球</a></li>
                        <li><a href="#">网球</a></li>
                    </ul>
                    <label>日期选择：<font color="red">注：只显示当日和三天后场馆情况</font></label>
                    <ul class="nav nav-pills">
                        <li class="active"><a href="#">2017-09-10</a></li>
                        <li><a href="#">2017-09-11</a></li>
                        <li><a href="#">2017-09-12</a></li>
                        <li><a href="#">2017-09-13</a></li>
                    </ul>
                    <label>搜索结果：<font color="red"></font></label>
                    <ul class="nav nav-pills">
                        <li class="active"><a href="#">不限</a></li>
                        <li><a href="#">篮球场</a></li>
                        <li><a href="#">足球场</a></li>
                        <li><a href="#">羽毛球场</a></li>
                        <li><a href="#">排球场</a></li>
                        <li><a href="#">网球场</a></li>
                    </ul>
                    <br>
                    <div>
                        <label style="font-size: large">说明：</label>
                        <span class="label label-default">已过期</span>
                        <span class="label label-warning">已占用</span>
                        <span class="label label-success">可预约</span>
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
                        <button type="button" class="btn btn-primary " style="width: 100%">
                            <span class="glyphicon">预约场地</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

<!--<div class="appointment">-->
    <!--<button type="button" class="btn btn-primary " style="width: 100%">-->
        <!--<span class="glyphicon">预约场地</span>-->
    <!--</button>-->
<!--</div>-->
<!--页脚版权信息-->
<div class="overflow : hidden;">
    <footer>
        <button type="button" class="btn btn-primary " style="width: 100%">
            <span class="glyphicon">北京化工大学© 版权所有  &nbsp;&nbsp;主办部门：北京化工大学信息中心</span>
        </button>
    </footer>
</div>
<script type="text/javascript">
function initGym(data){
	var table = $("#gymTable");
	var headTr = table.find("thead>tr").first();
	var body = table.find("tbody");
	var gym = data;
	console.log(gym)
	//加行
	for(var i=0;i<time.length;i++){
		var tr = $('<tr style="text-align: center"></tr>');
		tr.append('<td>'+time[i]+'：00&nbsp;--&nbsp;'+(time[i]==24?'00':(time[i]+1))+'：00</td>');
		//加列
		for(var j=0;j<gym.length;j++){
			if(i==0){
				headTr.append('<td style="text-align: center">'+gym[j]["name"]+'</td>');
			}
			var status = getStatus(time[i],gym[j]);
			tr.append($('<td style="text-align: center"><span class="label label-'+status["css"]+'">'+status["name"]+'</span></td>'));
		}
		body.append(tr);
	}
}

function getStatus(index,gym){
	var arr = gym["onTime"].split(",");
	for(var i = 0; i < arr.length; i++){
        if(index === parseInt(arr[i])){
            return {css:'success',name:'可预约'};
        }
    }
    return {css:'default',name:'已过期'};
}

var time = [6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,1,2,3,4,5];
$(document).ready(function() {
	$.ajax({
   		url: "${rootUrl}gym/all.do",
   		type: "get",
   		dataType:"json",
   		success: function(data){
			if(data.code==0 && data.data!=null){
				console.log(data);
				initGym(data.data);	
			}else{
				alert("查询失败");
			}
		} 
		});
});
</script>
</body>
</html>