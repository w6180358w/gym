package com.filter;
import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.util.SystemUtil;

@Component
public class LoginFilter implements Filter{
	private static String contextPath;
	private static final String ROOT_CONTEXT = "/";
	@Value("${userName}")
	public String userName;
	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest servletRequest = (HttpServletRequest)request;
		HttpServletResponse servletResponse = (HttpServletResponse)response;
		HttpSession session = servletRequest.getSession();
		try {
			String uri = servletRequest.getContextPath()+"/"+getUri(servletRequest);
			Object userName = session.getAttribute("user");
			if(uri.indexOf("/css")>=0 || uri.indexOf("/fonts")>=0 || uri.indexOf("/img")>=0 || uri.indexOf("/js")>=0 ) {
				chain.doFilter(servletRequest, servletResponse);
				return;
			}
			/*if(uri.equals(servletRequest.getContextPath()+"/user/home.do") ){
				if(userName==null || "".equals(userName)) {
					servletResponse.sendRedirect(servletRequest.getContextPath()+"/index.jsp");
					return;
				}else {
					chain.doFilter(servletRequest, servletResponse);
					return;
				}
			}else if (uri.equals(servletRequest.getContextPath()+"/index/doLogin.do") 
					|| uri.equals(servletRequest.getContextPath()+"/user/save.do")
					|| uri.equals(servletRequest.getContextPath()+"/user/update.do")
					|| uri.equals(servletRequest.getContextPath()+"/user/del.do")
					|| uri.equals(servletRequest.getContextPath()+"/user/get.do")
					|| uri.equals(servletRequest.getContextPath()+"/index.jsp")){
				chain.doFilter(servletRequest, servletResponse);
			} else {
				servletResponse.sendRedirect(servletRequest.getContextPath()+"/user/home.do");
			}*/
			chain.doFilter(servletRequest, servletResponse);
		} catch (Exception e) {
			servletResponse.getOutputStream().print(SystemUtil.request(1, null, null).toString());
			e.printStackTrace();
		}
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// TODO Auto-generated method stub
		
	}

	
	private String getUri(HttpServletRequest request)
	{

		if (contextPath == null) contextPath = "" + request.getContextPath();
		String uri = request.getRequestURI();
		if (!(contextPath.equals(ROOT_CONTEXT))) uri = uri.replaceFirst(contextPath + "/", "");
		return uri;
	}
}
