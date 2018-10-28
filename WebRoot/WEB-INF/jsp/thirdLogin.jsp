<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="com.model.*"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	Boolean success = (Boolean)request.getAttribute("third-login");
	String errorMsg = request.getAttribute("third-login-msg")+"";
%>
<html>
<c:url value="/" var="rootUrl" scope="application"></c:url>
<c:if test="${fn:contains(rootUrl,';jsession')}">
	<c:set value="${fn:split(rootUrl,';')[0] }" var="rootUrl"
		scope="application" />
</c:if>
<script src="${rootUrl}js/jquery-2.1.1.min.js"></script>
<script>
$(document).ready(function() {
	var success = '<%=success%>';
	if(!success || success!='true'){
		alert("<%=errorMsg%>");
	}
	window.location = "${rootUrl}";
});
</script>
</html>