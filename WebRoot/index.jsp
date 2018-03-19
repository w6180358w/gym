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
<title>首页</title>
<head>
<meta charset="utf-8">
<title>
</title>
<meta name="description" content="">
<meta name="author" content="">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

<link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/smartadmin-production-plugins.min.css">
<link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/smartadmin-production.min.css">
<link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/smartadmin-skins.min.css">
<link rel="stylesheet" type="text/css" media="screen" href="${rootUrl }css/add-app-class.css">

<style>
body, h1, h2, h3, h4, h5, h6, hr, p, blockquote, dl, dt, dd, ul, ol, li, pre, form, legend, button, input, textarea, th, td {
	margin: 0;
	padding: 0;
}
body, html {
	background: #f1f1f3;
	background-image: none;
}
h1, h2, h3, h4, h5, h6 {
	font-size: 100%;
}
address, cite, dfn, em, var {
	font-style: normal;
}
code, kbd, pre, samp {
	font-family: couriernew, courier, monospace;
}
ul, ol {
	list-style: none;
}
a {
	text-decoration: none;
	color: blue;
}
a:hover {
	text-decoration: underline;
}
legend {
	color: #000;
}
img {
	border: 0;
}
button, input, select, textarea {
	font-size: 100%;
}
table {
	border-collapse: collapse;
	border-spacing: 0;
}
html, body {
	height: 100%;
}
.smart-form .checkbox i, .smart-form .icon-append, .smart-form .icon-prepend, .smart-form .input input, .smart-form .radio i, .smart-form .select select, .smart-form .textarea textarea, .smart-form .toggle i {
	border-radius: 4px;
}
.login-logo {
	margin-top: 30px;
	margin-bottom:20px;
}
footer {
	background-color: parent;
	height: auto;
}
#login {
	width: 350px;
	min-height: 255px;
	position:absolute;
	top:50%;
	left:50%;
	margin:-250px 0 0 -175px;
}
.login-bg{
	background-color: rgba(240,240,240,0.9);
	background-color: #f0f0f0\0;
	border-radius: 10px;
	-moz-border-radius: 10px;
	box-shadow: 0px 0px 8px #aaa;
}
.login-top{
	background:#0e4470;
	text-align:center;
	color:#FFF;
	height:42px;
	line-height:42px;
	border-radius: 10px 10px 0 0;
	-moz-border-radius: 10px 10px 0 0;
	font-size:16px;
}
form {
	margin: 50px 40px;
	background:#FFF;
	border-radius: 0 0 10px 10px;
	-moz-border-radius: 0 0 10px 10px;
	padding:0 30px;
}
input#btn {
	color: #fff;
	width: 100px;
	height: 25px;
	margin: 5px 0 5px 65px;
	-moz-border-radius: 3px;
	border-radius: 3px;
	background-color: #3355dd;
	border: 0px;
	box-shadow: inset 0px 10px 8px rgba(255,255,255,0.5), inset 0px 5px 4px rgba(255,255,255,0.7), 0px 0px 5px #33f;
}
input#btn:hover {
	color: #fff;
	width: 100px;
	height: 25px;
	margin: 5px 0 5px 65px;
	-moz-border-radius: 3px;
	border-radius: 3px;
	background-color: #3355dd;
	border: 0px;
	box-shadow: inset 0px 10px 8px rgba(255,255,255,0.5);
}
#reflection {
	background: url(/img/adconnecthelp/bg2.jpg);
	height: 36px;
	opacity: 0.7;
	filter: alpha(opacity='70');
	-moz-border-radius: 5px;
	border-radius: 5px;
}
#lay {
	height: 36px;
	position: relative;
	bottom: 36px;
	background-image: -moz-linear-gradient(center bottom, rgb(255,255,255) 20%, rgba(255,255,255,0) 90%);
	background-image: -o-linear-gradient(rgba(255,255,255,0) 10%, rgb(255,255,255) 30%);
	background-image: -webkit-gradient(linear, left bottom, left top, color-stop(0.20, rgb(255,255,255)), color-stop(0.90, rgba(255,255,255,0)));
filter: progid:DXImageTransform.Microsoft.Gradient(gradientType=0, startColor=0, EndColorStr=#000000);
	-moz-border-radius: 5px;
	border-radius: 5px;
}
.btn-fts{
	padding:8px 0;
	width:100%; 
	text-align:center; 
	margin-top:10px;
}
.btn-login {
  color: #fff;
  background-color: #29ae9b;
  border-color: #29ae9b;
}
.btn-login:hover,
.btn-login:focus,
.btn-login.focus,
.btn-login:active,
.btn-login.active,
.open > .dropdown-toggle.btn-login {
  color: #fff;
  background-color: #1fbfa7;
  border-color: #1fbfa7;
}
.btn-login:active,
.btn-login.active,
.open > .dropdown-toggle.btn-login {
  background-image: none;
}
.btn-login.disabled,
.btn-login[disabled],
fieldset[disabled] .btn-login,
.btn-login.disabled:hover,
.btn-login[disabled]:hover,
fieldset[disabled] .btn-login:hover,
.btn-login.disabled:focus,
.btn-login[disabled]:focus,
fieldset[disabled] .btn-login:focus,
.btn-login.disabled.focus,
.btn-login[disabled].focus,
fieldset[disabled] .btn-login.focus,
.btn-login.disabled:active,
.btn-login[disabled]:active,
fieldset[disabled] .btn-login:active,
.btn-login.disabled.active,
.btn-login[disabled].active,
fieldset[disabled] .btn-login.active {
  background-color: #29ae9b;
  border-color: #29ae9b;
}
.btn-login .badge {
  color: #29ae9b;
  background-color: #29ae9b;
}
.color-login{
	color:#3b88be;
}
.smart-form footer {
    border-top: 0px solid rgba(0, 0, 0, 0.1);
	margin-top:0;
	margin-bottom:5px;
}
@media only screen and (max-width: 767px){
#login {
	width: 280px;
	margin:-200px 0 0 -140px;
}
form {
	padding:0 10px;
}
.login-top{
	height:36px;
	line-height:36px;
	font-size:14px;
}
.smart-form fieldset {
	padding: 10px 5px 5px 5px;
}
.smart-form footer {
	padding: 7px 5px 7px 5px;
}
.smart-form .label {
	margin-bottom: 3px;
}
.mar-b-10 {
	margin-bottom: 5px;
}
.btn-fts{
	padding:4px 0;
	margin-top:6px;
}
.smart-form .btn {
	margin-bottom: 10px;
}
}
</style>
</head>
<body>
  <div id="login">
    <div class="login-bg">
    <div class="login-top">用户管理</div>
    <form action="${rootUrl }index/doLogin.do" id="login-form" method="post" class="smart-form client-form">
      <fieldset>
        <label class="label">
          用户名<%=request.getAttribute("code") %>
        </label>
        <label class="input mar-b-10"> <i class="icon-append fa fa-user"></i>
          <input type="text" name="userName"/>
          <b class="tooltip tooltip-top-right"><i class="fa fa-user txt-color-teal"></i> 请输入您的用户名</b></label>
        <label class="label">
         密码
        </label>
        <label class="input mar-b-10"> <i class="icon-append fa fa-lock"></i>
          <input type="password" name="password" />
          <b class="tooltip tooltip-top-right"><i class="fa fa-lock txt-color-teal"></i> 请输入您的密码</b> </label>
        <div class="row" style="margin:0;">
          <div class="col-xs-8" style="padding-top:3px;">
            <label class="checkbox">
              <input type="checkbox" name="remember" checked="checked">
              <i></i>记住用户名</label>
          </div>
        </div>
        <div class="row" style="margin:0;">
        	<div class="col-xs-12">
            	<button id="btn" type="submit" onclick="javascript:login()" class="btn btn-login btn-fts" style="" data-loading-text="登录中... ">
                登陆
                </button>
            </div>
        </div>
      </fieldset>
      <footer class="hidden-xs"><i><span class="color-login">提示:</span>为了达到最佳浏览效果，请使用Chrome、Firefox、IE9.0及以上版本浏览器。</i></footer>
    </form>
    </div>
  </div>
  <div id="reflection" style="display:none">&nbsp;</div>
  <div id="lay" style="display:none"></div>
<script type="text/javascript">
	window.onload = function(){
		var form = document.getElementById('login-form');
		form.ucode.value =  getCookieValue("ucode");		
		form.password.value = getCookieValue("password");
	}
	<%
		Object code = session.getAttribute("code");
		if(code!=null && code.equals(false)){
			%>
				alert("用户名或密码错误");
			<%
		}
	%>
	function login(){			
		var form = document.getElementById('login-form');		
		if(form.remember.checked){
			var day = 7*24;
			var ucode = form.ucode.value;
			var password = form.password.value;
			setCookie("ucode",ucode,day,"/");
       		setCookie("password",password,day,"/");
		}else{
			deleteCookie("ucode","/");
			deleteCookie("password","/");
		}					
		return true;
	}
	
	function setCookie(key,value,hours,path){
		var key = escape(key);
		var value = escape(value);
		var expires = new Date();
		expires.setTime(expires.getTime() + hours*3600000);
		_expires = (typeof hours) == "string" ? "" : ";expires=" + expires.toUTCString();		
		document.cookie = key + "=" + value + _expires + path;
	}
	
	function getCookieValue(key){
		var key = escape(key);
		var allcookies = document.cookie; 		   
		key += "=";
		var pos = allcookies.indexOf(key);    
		if (pos != -1){                                             
	        var start = pos + key.length;                  
	        var end = allcookies.indexOf(";",start);        
	        if (end == -1) end = allcookies.length;       
	        var value = allcookies.substring(start,end); 
	        return unescape(value);                          
         }else 
         	return "";           
	}
	
	function deleteCookie(key,path){	
		setCookie(key,null,0,"/");       		
	}
</script>
</html>