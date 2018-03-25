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
<html>
<head>
    <title>北京化工大学场馆预约系统</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${rootUrl }css/bootstrap.min.css">
    <link rel="stylesheet" href="${rootUrl }css/style.css">
    <script src="js/jquery-3.2.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <!--引用百度地图API-->
    <style type="text/css">
        html,body{margin:0;padding:0;}
        .iw_poi_title {color:#CC5522;font-size:14px;font-weight:bold;overflow:hidden;padding-right:13px;white-space:nowrap}
        .iw_poi_content {font:12px arial,sans-serif;overflow:visible;padding-top:4px;white-space:-moz-pre-wrap;word-wrap:break-word}
    </style>
    <script type="text/javascript" src="http://api.map.baidu.com/api?key=&v=1.1&services=true"></script>
</head>
<body>

<div class="container">
    <div class="row">
        <div class="log-box">
            <div id="logo" class="log">
                <a href="${rootUrl }index.jsp"><img src="${rootUrl }images/buct.jpg" class="img-responsive" /></a>
            </div>
        </div>
    </div>
    <div class="row">
        <div>
            <ul class="nav nav-tabs">
                <li class="active"><a href="#">首页</a></li>
                <li><a href="${rootUrl }html/stadium.jsp">场馆</a></li>
                <li><a href="${rootUrl }html/appointment.jsp">场地预约</a></li>
                <li><a href="${rootUrl }user/home.do">用户管理</a></li>
                <li><a href="${rootUrl }gymType/home.do">场地类型管理</a></li>
                <li><a href="${rootUrl }gym/home.do">场地管理</a></li>
            </ul>
        </div>
    </div>
</div>
<div id="nav-main" style="overflow: auto;width: 100%"></div>
<br>
<div class="container">
    <!--<div class="row">-->
        <!--<div class="log-box">-->
            <!--<div id="logo" class="log">-->
                <!--<a href="index.jsp"><img src="images/buct.jpg" class="img-responsive" /></a>-->
                    <!--&lt;!&ndash;<a href="###">手机版</a>&ndash;&gt;-->
                    <!--&lt;!&ndash;<span >&nbsp;|&nbsp;</span>&ndash;&gt;-->
                    <!--&lt;!&ndash;<a href="###">意见反馈</a>&ndash;&gt;-->
            <!--</div>-->
        <!--</div>-->
        <!--<div id="nav-main">-->
            <!--<ul class="nav nav-tabs">-->
                <!--<li class="active"><a href="#">首页</a></li>-->
                <!--<li><a href="#">场馆</a></li>-->
                <!--<li><a href="#">场地预约</a></li>-->
                <!--<li><a href="#">地图</a></li>-->
            <!--</ul>-->
        <!--</div>-->
    <!--</div>-->
    <div class="row">
        <div id="myCarousel" class="carousel slide">
            <!-- 轮播（Carousel）指标 -->
            <ol class="carousel-indicators">
                <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                <li data-target="#myCarousel" data-slide-to="1"></li>
                <li data-target="#myCarousel" data-slide-to="2"></li>
            </ol>
            <!-- 轮播（Carousel）项目 -->
            <div class="carousel-inner">
                <div class="item active">
                    <img src="${rootUrl }images/a.jpg" alt="First slide" >
                </div>
                <div class="item">
                    <img src="${rootUrl }images/a.jpg" alt="Second slide">
                </div>
                <div class="item">
                    <img src="${rootUrl }images/a.jpg" alt="Third slide">
                </div>
            </div>
            <!--&lt;!&ndash; 轮播（Carousel）导航 &ndash;&gt;-->
            <!--<a class="carousel-control left" href="#myCarousel"-->
               <!--data-slide="prev">&lsaquo;-->
            <!--</a>-->
            <!--<a class="carousel-control right" href="#myCarousel"-->
               <!--data-slide="next">&rsaquo;-->
            <!--</a>-->
        </div>
    </div>
    <div class="clear"></div>
    <br>
    <div class="row">
        <div class="col-md-12">
            <marquee id="affiche" align="left" behavior="scroll" bgcolor="#ECF5FF" direction="left" loop="-1" scrollamount="10" scrolldelay="10" onMouseOut="this.start()" onMouseOver="this.stop()">
                <font size="6" style="height: auto">
                    2017-09-11 南足球场将举行入学典礼。       2017-09-23 西篮球场将举行院篮球比赛
                </font>
            </marquee>
        </div>
    </div>
    <br>
    <!--场馆预约和百度地图-->
    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title">场地情况</h3>
            </div>
            <div class="panel-body">
                <div class="row">
                    <!--场地预约-->
                    <div class="col-md-6">
                        <div>
                            <select>
                                <option value ="请选择">请选择场地</option>
                                <option value ="北体育场">北体育场</option>
                                <option value ="南体育场">南体育场</option>
                                <option value="西体育场">西体育场</option>
                                <option value="东体育场">东体育场</option>
                            </select>
                            <select>
                                <option value ="请选择">请选择运动</option>
                                <option value ="羽毛球">羽毛球</option>
                                <option value ="篮球">篮球</option>
                                <option value="足球">足球</option>
                                <option value="网球">网球</option>
                            </select>
                            <a href="###"><span class="label label-info" style="font-size: 16px">查询</span></a>
                            <div class="btn-group" style="float: right">
                                <button type="button" class="btn btn-default">上一天</button>
                                <button type="button" class="btn btn-default">今天</button>
                                <button type="button" class="btn btn-default">下一天</button>
                            </div>
                        </div>
                        <div style="overflow-x: auto; overflow-y: auto; height: 300px; width:100%;">
                            <table class="table" width="732px" align="center" cellspacing="0">
                                <tbody>
                                <th>2017-09-09</th><th>开放时间</th><th>详情</th><th>操作</th>
                                <tr><td>北篮球场</td><td>06:30-08:30</td><td>9余9<td><span class="label label-info ">预约</span></td></tr>
                                <tr><td>北篮球场</td><td>06:30-08:30</td><td>9余9<td><span class="label label-info ">预约</span></td></tr>
                                <tr><td>北篮球场</td><td>06:30-08:30</td><td>9余9<td><span class="label label-info ">预约</span></td></tr>
                                <tr><td>北篮球场</td><td>06:30-08:30</td><td>9余9<td><span class="label label-info ">预约</span></td></tr>
                                <tr><td>北篮球场</td><td>06:30-08:30</td><td>9余9<td><span class="label label-info ">预约</span></td></tr>
                                <tr><td>北篮球场</td><td>06:30-08:30</td><td>9余9<td><span class="label label-info ">预约</span></td></tr>
                                <tr><td>北篮球场</td><td>06:30-08:30</td><td>9余9<td><span class="label label-info ">预约</span></td></tr>
                                <tr><td>北篮球场</td><td>06:30-08:30</td><td>9余9<td><span class="label label-info ">预约</span></td></tr>
                                <tr><td>北篮球场</td><td>06:30-08:30</td><td>9余9<td><span class="label label-info ">预约</span></td></tr>
                                <tr><td>北篮球场</td><td>06:30-08:30</td><td>9余9<td><span class="label label-info ">预约</span></td></tr>
                                <tr><td>北篮球场</td><td>06:30-08:30</td><td>9余9<td><span class="label label-info ">预约</span></td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!--百度地图-->
                    <div class="col-md-6">
                        <div class="centertitle">
                            <p><span class="label label-info" style="font-size: 20px">体育馆分布</span></p>
                        </div>
                        <div style="overflow-x: auto; overflow-y: auto; height: 300px; width:100%;">
                            <div style="width:550px;height:300px;border:#ccc solid 1px;" id="dituContent"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!--场馆通知相关-->
    <div class="row">
        <div class="row">
            <!--场馆通知-->
            <div class="col-md-6">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title"><a href="###"><span class="badge pull-right">MORE</span></a>场馆通知</h3>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <ul class="list-group">
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                            </ul>
                        </div>

                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title"><a href="###"><span class="badge pull-right">MORE</span></a>健身房通知</h3>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <ul class="list-group">
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!--场馆动态相关-->
    <div class="row">
        <div class="row">
            <!--场馆通知-->
            <div class="col-md-6">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title"><a href="###"><span class="badge pull-right">MORE</span></a>场馆动态</h3>
                    </div>
                    <div class="panel-body">
                        <div class="col-md-6">
                                <img src="images/onepiece.jpg" width="300">
                        </div>
                        <div class="col-md-6">
                            <div class="row">
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <b>[篮球场]</b>
                                        <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                        <span class="badge" style="float:right">2017-07-06</span>
                                    </li>
                                    <li class="list-group-item">
                                        <b>[篮球场]</b>
                                        <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                        <span class="badge" style="float:right">2017-07-06</span>
                                    </li>
                                    <li class="list-group-item">
                                        <b>[篮球场]</b>
                                        <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                        <span class="badge" style="float:right">2017-07-06</span>
                                    </li>
                                    <li class="list-group-item">
                                        <b>[篮球场]</b>
                                        <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                        <span class="badge" style="float:right">2017-07-06</span>
                                    </li>
                                </ul>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title"><a href="###"><span class="badge pull-right">MORE</span></a>培训信息</h3>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <ul class="list-group">
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                                <li class="list-group-item">
                                    <b>[篮球场]</b>
                                    <a href="####">2017年秋季学期篮球球学期场预定通知</a>
                                    <span class="badge" style="float:right">2017-07-06</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

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
<script>
    $(function() {
        // 初始化轮播
        $("#myCarousel").carousel('cycle');
    });
</script>
<script type="text/javascript">
    //创建和初始化地图函数：
    function initMap(){
        createMap();//创建地图
        setMapEvent();//设置地图事件
        addMapControl();//向地图添加控件
        addMarker();//向地图中添加marker
    }

    //创建地图函数：
    function createMap(){
        var map = new BMap.Map("dituContent");//在百度地图容器中创建一个地图
        var point = new BMap.Point(116.427638,39.977918);//定义一个中心点坐标
        map.centerAndZoom(point,17);//设定地图的中心点和坐标并将地图显示在地图容器中
        window.map = map;//将map变量存储在全局
    }

    //地图事件设置函数：
    function setMapEvent(){
        map.enableDragging();//启用地图拖拽事件，默认启用(可不写)
        map.enableScrollWheelZoom();//启用地图滚轮放大缩小
        map.enableDoubleClickZoom();//启用鼠标双击放大，默认启用(可不写)
        map.enableKeyboard();//启用键盘上下左右键移动地图
    }

    //地图控件添加函数：
    function addMapControl(){
        //向地图中添加缩放控件
        var ctrl_nav = new BMap.NavigationControl({anchor:BMAP_ANCHOR_TOP_LEFT,type:BMAP_NAVIGATION_CONTROL_LARGE});
        map.addControl(ctrl_nav);
        //向地图中添加比例尺控件
        var ctrl_sca = new BMap.ScaleControl({anchor:BMAP_ANCHOR_BOTTOM_LEFT});
        map.addControl(ctrl_sca);
    }

    //标注点数组
    var markerArr = [{title:"足球场",content:"足球场",point:"116.425464|39.978623",isOpen:0,icon:{w:21,h:21,l:0,t:0,x:6,lb:5}}
        ,{title:"篮球场",content:"篮球场",point:"116.425841|39.977766",isOpen:0,icon:{w:21,h:21,l:0,t:0,x:6,lb:5}}
        ,{title:"篮球场2",content:"篮球场2",point:"116.428896|39.977683",isOpen:0,icon:{w:21,h:21,l:0,t:0,x:6,lb:5}}
        ,{title:"网球场",content:"网球场",point:"116.425805|39.977393",isOpen:0,icon:{w:21,h:21,l:0,t:0,x:6,lb:5}}
    ];
    //创建marker
    function addMarker(){
        for(var i=0;i<markerArr.length;i++){
            var json = markerArr[i];
            var p0 = json.point.split("|")[0];
            var p1 = json.point.split("|")[1];
            var point = new BMap.Point(p0,p1);
            var iconImg = createIcon(json.icon);
            var marker = new BMap.Marker(point,{icon:iconImg});
            var iw = createInfoWindow(i);
            var label = new BMap.Label(json.title,{"offset":new BMap.Size(json.icon.lb-json.icon.x+10,-20)});
            marker.setLabel(label);
            map.addOverlay(marker);
            label.setStyle({
                borderColor:"#808080",
                color:"#333",
                cursor:"pointer"
            });

            (function(){
                var index = i;
                var _iw = createInfoWindow(i);
                var _marker = marker;
                _marker.addEventListener("click",function(){
                    this.openInfoWindow(_iw);
                });
                _iw.addEventListener("open",function(){
                    _marker.getLabel().hide();
                });
                _iw.addEventListener("close",function(){
                    _marker.getLabel().show();
                });
                label.addEventListener("click",function(){
                    _marker.openInfoWindow(_iw);
                });
                if(!!json.isOpen){
                    label.hide();
                    _marker.openInfoWindow(_iw);
                }
            })()
        }
    }
    //创建InfoWindow
    function createInfoWindow(i){
        var json = markerArr[i];
        var iw = new BMap.InfoWindow("<b class='iw_poi_title' title='" + json.title + "'>" + json.title + "</b><div class='iw_poi_content'>"+json.content+"</div>");
        return iw;
    }
    //创建一个Icon
    function createIcon(json){
        var icon = new BMap.Icon("${rootUrl }images/mark.png", new BMap.Size(json.w,json.h),{imageOffset: new BMap.Size(-json.l,-json.t),infoWindowOffset:new BMap.Size(json.lb+5,1),offset:new BMap.Size(json.x,json.h)})
        return icon;
    }

    initMap();//创建和初始化地图
</script>
</html>
