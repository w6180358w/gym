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
    <title>北京化工大学场馆信息</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/style.css">
    <script src="../js/jquery-3.2.1.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
</head>
<body style="width: 100%;height: 100%" >
    <!--<style>-->
        <!--body{-->
            <!--background:url(../images/background.jpg) top left;-->
            <!--background-size:100% 100%;-->
        <!--}-->
    <!--</style>-->
    <style>
        body{
            background:url(../images/background.jpg) top left;
            background-size:100% 100%;
        }
        /* Custom Styles */
        ul.nav-tabs1{
            width: 140px;
            margin-top: 20px;
            border-radius: 4px;
            border: 1px solid #ddd;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.067);
        }
        ul.nav-tabs1 li{
            margin: 0;
            border-top: 1px solid #ddd;
        }
        ul.nav-tabs1 li:first-child{
            border-top: none;
        }
        ul.nav-tabs1 li a{
            margin: 0;
            padding: 8px 16px;
            border-radius: 0;
        }
        ul.nav-tabs1 li.active a, ul.nav-tabs1 li.active a:hover{
            color: #fff;
            background: #0088cc;
            border: 1px solid #0088cc;
        }
        ul.nav-tabs1 li:first-child a{
            border-radius: 4px 4px 0 0;
        }
        ul.nav-tabs1 li:last-child a{
            border-radius: 0 0 4px 4px;
        }
        ul.nav-tabs1.affix{
            top: 30px; /* Set the top position of pinned element */
        }
    </style>

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
                    <li class="active"><a href="#">场馆</a></li>
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
        <div class="row">
            <div class="col-xs-3" id="myScrollspy">
                <ul class="nav nav-tabs1 nav-stacked" data-spy="affix" data-offset-top="125">
                    <li class="active"><a href="#section-1">篮球场</a></li>
                    <li><a href="#section-2">体育场</a></li>
                    <li><a href="#section-3">网球场</a></li>
                    <li><a href="#section-4">排球场</a></li>
                    <li><a href="#section-5">足球场</a></li>
                </ul>
            </div>
            <div class="col-xs-9">
                <ol class="breadcrumb">
                    <li><a href="#">首页</a></li>
                    <li class="active"><a href="#">场馆</a></li>
                </ol>
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h2 id="section-1" class="panel-title"><a href="###"><span class="badge pull-right">详细</span></a>篮球场</h2>
                    </div>
                    <div class="panel-body">
                        <div class="col-md-6">
                            <img src="../images/onepiece.jpg" width="300">
                        </div>
                        <div class="col-md-6">
                            <div class="row">
                                <p>Integer pulvinar leo id risus pellentesque vestibulum. Sed diam libero, sodales eget sapien vel, porttitor bibendum enim. Donec sed nibh vitae lorem porttitor blandit in nec ante. Pellentesque vitae metus ipsum. Phasellus sed nunc ac sem malesuada condimentum. Etiam in aliquam lectus. Nam vel sapien diam. Donec pharetra id arcu eget blandit. Proin imperdiet mattis augue in porttitor. Quisque tempus enim id lobortis feugiat. Suspendisse tincidunt risus quis dolor fringilla blandit. Ut sed sapien at purus lacinia porttitor. Nullam iaculis, felis a pretium ornare, dolor nisl semper tortor, vel sagittis lacus est consequat eros. Sed id pretium nisl. Curabitur dolor nisl, laoreet vitae aliquam id, tincidunt sit amet mauris.</p>
                             </div>
                        </div>
                    </div>
                    <br><br><br>
                </div>
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h2 id="section-2" class="panel-title"><a href="###"><span class="badge pull-right">详细</span></a>体育场</h2>
                    </div>
                    <div class="panel-body">
                        <div class="col-md-6">
                            <img src="../images/onepiece.jpg" width="300">
                        </div>
                        <div class="col-md-6">
                            <div class="row">
                                <p>Integer pulvinar leo id risus pellentesque vestibulum. Sed diam libero, sodales eget sapien vel, porttitor bibendum enim. Donec sed nibh vitae lorem porttitor blandit in nec ante. Pellentesque vitae metus ipsum. Phasellus sed nunc ac sem malesuada condimentum. Etiam in aliquam lectus. Nam vel sapien diam. Donec pharetra id arcu eget blandit. Proin imperdiet mattis augue in porttitor. Quisque tempus enim id lobortis feugiat. Suspendisse tincidunt risus quis dolor fringilla blandit. Ut sed sapien at purus lacinia porttitor. Nullam iaculis, felis a pretium ornare, dolor nisl semper tortor, vel sagittis lacus est consequat eros. Sed id pretium nisl. Curabitur dolor nisl, laoreet vitae aliquam id, tincidunt sit amet mauris.</p>
                            </div>
                        </div>
                    </div>
                    <br><br><br>
                </div>
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h2 id="section-3" class="panel-title"><a href="###"><span class="badge pull-right">详细</span></a>网球场</h2>
                    </div>
                    <div class="panel-body">
                        <div class="col-md-6">
                            <img src="../images/onepiece.jpg" width="300">
                        </div>
                        <div class="col-md-6">
                            <div class="row">
                                <p>Integer pulvinar leo id risus pellentesque vestibulum. Sed diam libero, sodales eget sapien vel, porttitor bibendum enim. Donec sed nibh vitae lorem porttitor blandit in nec ante. Pellentesque vitae metus ipsum. Phasellus sed nunc ac sem malesuada condimentum. Etiam in aliquam lectus. Nam vel sapien diam. Donec pharetra id arcu eget blandit. Proin imperdiet mattis augue in porttitor. Quisque tempus enim id lobortis feugiat. Suspendisse tincidunt risus quis dolor fringilla blandit. Ut sed sapien at purus lacinia porttitor. Nullam iaculis, felis a pretium ornare, dolor nisl semper tortor, vel sagittis lacus est consequat eros. Sed id pretium nisl. Curabitur dolor nisl, laoreet vitae aliquam id, tincidunt sit amet mauris.</p>
                            </div>
                        </div>
                    </div>
                    <br><br><br>
                </div>
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h2 id="section-4" class="panel-title"><a href="###"><span class="badge pull-right">详细</span></a>排球场</h2>
                    </div>
                    <div class="panel-body">
                        <div class="col-md-6">
                            <img src="../images/onepiece.jpg" width="300">
                        </div>
                        <div class="col-md-6">
                            <div class="row">
                                <p>Integer pulvinar leo id risus pellentesque vestibulum. Sed diam libero, sodales eget sapien vel, porttitor bibendum enim. Donec sed nibh vitae lorem porttitor blandit in nec ante. Pellentesque vitae metus ipsum. Phasellus sed nunc ac sem malesuada condimentum. Etiam in aliquam lectus. Nam vel sapien diam. Donec pharetra id arcu eget blandit. Proin imperdiet mattis augue in porttitor. Quisque tempus enim id lobortis feugiat. Suspendisse tincidunt risus quis dolor fringilla blandit. Ut sed sapien at purus lacinia porttitor. Nullam iaculis, felis a pretium ornare, dolor nisl semper tortor, vel sagittis lacus est consequat eros. Sed id pretium nisl. Curabitur dolor nisl, laoreet vitae aliquam id, tincidunt sit amet mauris.</p>
                            </div>
                        </div>
                    </div>
                    <br><br><br>
                </div>
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h2 id="section-5" class="panel-title"><a href="###"><span class="badge pull-right">详细</span></a>足球场</h2>
                    </div>
                    <div class="panel-body">
                        <div class="col-md-6">
                            <img src="../images/onepiece.jpg" width="300">
                        </div>
                        <div class="col-md-6">
                            <div class="row">
                                <p>Integer pulvinar leo id risus pellentesque vestibulum. Sed diam libero, sodales eget sapien vel, porttitor bibendum enim. Donec sed nibh vitae lorem porttitor blandit in nec ante. Pellentesque vitae metus ipsum. Phasellus sed nunc ac sem malesuada condimentum. Etiam in aliquam lectus. Nam vel sapien diam. Donec pharetra id arcu eget blandit. Proin imperdiet mattis augue in porttitor. Quisque tempus enim id lobortis feugiat. Suspendisse tincidunt risus quis dolor fringilla blandit. Ut sed sapien at purus lacinia porttitor. Nullam iaculis, felis a pretium ornare, dolor nisl semper tortor, vel sagittis lacus est consequat eros. Sed id pretium nisl. Curabitur dolor nisl, laoreet vitae aliquam id, tincidunt sit amet mauris.</p>
                            </div>
                        </div>
                    </div>
                    <br><br><br>
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
</html>