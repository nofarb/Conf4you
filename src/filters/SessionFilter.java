package filters;

import java.io.IOException;
import java.util.ArrayList;
import java.util.StringTokenizer;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import utils.ProjConst;

/**
 * Servlet Filter implementation class SessionFilter
 */

public class SessionFilter implements Filter {

	private ArrayList<String> urlList;

	public SessionFilter() {
		// TODO Auto-generated constructor stub
	}

	public void destroy() {
		// TODO Auto-generated method stub
	}

	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain chain) throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;
		String url = request.getServletPath();

		if (!urlList.contains(url)) {

			HttpSession session = request.getSession(false);
			if (session != null) {
				if (session.isNew()) {
					navigateToLoginPage(response);
					return;
				} else {
					Long currUserId = (Long) session.getAttribute(ProjConst.SESSION_USER_ID);
					if (currUserId == null) {
						navigateToLoginPage(response);
						return;
					}
				}
			} else {
				// TODO - save to session the url that the user wanted to get
				// to, and after successful login go to this url,
				navigateToLoginPage(response);
				return;
			}
		}
		chain.doFilter(request, response);

	}

	public void navigateToLoginPage(HttpServletResponse response) throws IOException {
		response.sendRedirect(ProjConst.LOGIN_PAGE);
	}


	public void init(FilterConfig fConfig) throws ServletException {
		
		String urls = fConfig.getInitParameter("avoid-urls");
		StringTokenizer token = new StringTokenizer(urls, ",");

		urlList = new ArrayList<String>();

		while (token.hasMoreTokens()) {
			urlList.add(token.nextToken());

		}
	}

}
