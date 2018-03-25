<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%String nowPage = request.getParameter("nowPage"); %>
<c:url value="/" var="rootUrl" scope="application"></c:url>
<c:if test="${fn:contains(rootUrl,';jsession')}">
	<c:set value="${fn:split(rootUrl,';')[0] }" var="rootUrl"
		scope="application" />
</c:if>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${rootUrl }/css/bootstrap.min.css">
    <link rel="stylesheet" href="${rootUrl }/css/style.css">
        <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/smartadmin-production-plugins.min.css">
    <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/jquery-ui.css">
    <link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/add-app-class.css">
<div class="container">
    <div class="row">
        <div class="log-box">
            <div id="logo" class="log">
                <a href="${rootUrl }index.jsp"><img src="${rootUrl }/images/buct.jpg" class="img-responsive" /></a>
            </div>
        </div>
    </div>
    <div class="row">
        <div>
            <ul class="nav nav-tabs">
                <li class=<%="index".equals(nowPage)?"active":"" %>><a href="${rootUrl }index.jsp">首页</a></li>
                <li class=<%="stadium".equals(nowPage)?"active":"" %>><a href="${rootUrl }html/stadium.jsp">场馆</a></li>
                <li class=<%="appointment".equals(nowPage)?"active":"" %>><a href="${rootUrl }html/appointment.jsp">场地预约</a></li>
                <li class=<%="user".equals(nowPage)?"active":"" %>><a href="${rootUrl }user/home.do">用户管理</a></li>
                <li class=<%="gymType".equals(nowPage)?"active":"" %>><a href="${rootUrl }gymType/home.do">场地类型管理</a></li>
                <li class=<%="tym".equals(nowPage)?"active":"" %>><a href="${rootUrl }gym/home.do">场地管理</a></li>
            </ul>
        </div>
    </div>
</div>