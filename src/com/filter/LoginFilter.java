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

import com.model.User;
import com.util.SystemUtil;

@Component
public class LoginFilter implements Filter{
	private static String contextPath;
	private static final String ROOT_CONTEXT = "/";
	@Value("${userName}")
	public String userName;
	@Override
	public void destroy() {
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest servletRequest = (HttpServletRequest)request;
		HttpServletResponse servletResponse = (HttpServletResponse)response;
		HttpSession session = servletRequest.getSession();
		
		try {
			String uri = servletRequest.getContextPath()+"/"+getUri(servletRequest);
			User user = (User)session.getAttribute("user");
			if(uri.indexOf("/css")>=0 || uri.indexOf("/fonts")>=0 || uri.indexOf("/img")>=0 || uri.indexOf("/js")>=0 ) {
				chain.doFilter(servletRequest, servletResponse);
				return;
			}

			String auth = user==null?null:user.getType();
			if(uri.indexOf("/home.do")>-1){
				if(!isAuth(auth,uri)){
					servletResponse.sendRedirect(servletRequest.getContextPath()+"/html/appointment.jsp");
				}else{
					chain.doFilter(servletRequest, servletResponse);
				}
				return;
			}
			
			if(!isAuth(auth,uri)){
				servletResponse.sendError(404, "无权限");
				return;
			}
			
			chain.doFilter(servletRequest, servletResponse);
		} catch (Exception e) {
			servletResponse.getOutputStream().print(SystemUtil.request(1, null, null).toString());
			e.printStackTrace();
		}
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		
	}

	
	private String getUri(HttpServletRequest request)
	{

		if (contextPath == null) contextPath = "" + request.getContextPath();
		String uri = request.getRequestURI();
		if (!(contextPath.equals(ROOT_CONTEXT))) uri = uri.replaceFirst(contextPath + "/", "");
		return uri;
	}
	/**
	 * 判断是否有权限
	 * @param auth
	 * @param uri
	 * @return
	 */
	private Boolean isAuth(String auth,String uri){
		//如果用户权限代码为空或者为普通用户 
		if(auth==null || SystemUtil.USER.equals(auth)){
			//如果当前url在管理员权限列表中存在  返回false  无权限
			if(SystemUtil.ADMIN_URL.contains(uri)){
				return false;
			}
			//如果当前url在超级管理员权限列表中存在  返回false  无权限
			if(SystemUtil.SUPERADMIN_URL.contains(uri)){
				return false;
			}
		}
		//如果用户未管理员权限  判断当前url在超级管理员权限列表中是否存在  如果存在 返回false 无权限
		if(SystemUtil.ADMIN.equals(auth) && SystemUtil.SUPERADMIN_URL.contains(uri)){
			return false;
		}
		//其余情况为有权限
		return true;
	}
	
}
