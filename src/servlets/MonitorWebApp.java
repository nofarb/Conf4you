package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Servlet implementation class MonitorWebApp
 */
public class MonitorWebApp extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String SERVLET_PATH_APPLICATION_LIST = "/ApplicationList.monitor";
	private static final String SERVLET_PATH_SERVLET_LIST = "/ServletList.monitor";
	private static final String SERVLET_PATH_SERVLET_MONITOR = "/ServletMonitor.monitor";	

	private static final String HTTP_METHOD_GET = "GET";
	private static final String HTTP_METHOD_POST = "POST";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public MonitorWebApp() {
		super();

		/* 
		 * Create new DB helper. 
		 * This DB helper instance will supply us web application info and statistics. 
		 */
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String servletPath = request.getServletPath();

		try {
			if (servletPath == null) {
				throw new Exception("Critical error!!! Servlet path is NULL.");
			}
			else if ( servletPath.equals(SERVLET_PATH_APPLICATION_LIST)) {
				sendApplicationList(request, response);
			}
			else if( servletPath.equals(SERVLET_PATH_SERVLET_LIST)) {
				sendServletList(request, response);
			}
			else if ( servletPath.equals(SERVLET_PATH_SERVLET_MONITOR)) {
				sendMonitorAppInfo(request, response);
			}
			else {
				throw new Exception("Unknown Servlet path '" + servletPath + "'");
			}
		}

		catch (Exception e) {
			sendErrorPage(request, response, e.getMessage());
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

	private void sendApplicationList(HttpServletRequest request, HttpServletResponse response) throws Exception {

		RequestDispatcher applicationListDispatcher;
		List <String> applicationList = null;

		// Get ApplicationList.jsp dispatcher
		//applicationListDispatcher = request.getRequestDispatcher("/ApplicationList.jsp");
		applicationListDispatcher = request.getRequestDispatcher("/test.jsp");



		// Get application list from the database
//		applicationList = DBWrapper.getDBWrapperObject().getApps();
		applicationList = new LinkedList<String>();
		applicationList.add("app1");
		applicationList.add("app2");
		applicationList.add("app3");
		applicationList.add("app4");

/*		if ( applicationList == null) {
			throw new Exception("Failed to get application list...");
		}*/

		// Set an error message through an error attribute
		request.setAttribute("ApplicationList", applicationList);

		// Forward to request to "/ApplicationList.jsp"
		applicationListDispatcher.forward(request, response);
	}

	private void sendServletList(HttpServletRequest request, HttpServletResponse response) throws Exception 
	{
		RequestDispatcher servletListDispatcher;
		List <String> servletList = null;
		String applicationName;

		applicationName = request.getParameter("ApplicationName");
		if ( applicationName == null || applicationName.trim().isEmpty()) {
			throw new Exception("Failed to get application name");
		}

		// Trim application name to avoid matching error
		applicationName = applicationName.trim();

		// Get ServletList.jsp dispatcher
		servletListDispatcher = request.getRequestDispatcher("/ServletList.jsp");

		// Get servlet list from the database by application name
//		servletList = DBWrapper.getDBWrapperObject().getResources(applicationName);
		servletList = new LinkedList<String>();
		servletList.add("serv1");
		servletList.add("serv2");
		servletList.add("serv3");
		servletList.add("serv4");
	/*	if ( servletList == null) {
			throw new Exception("Failed to get servlet list...");
		}*/

		// Send servlet list through ServletList attribute
		request.setAttribute("ServletList", servletList);

		// Send application name through ApplicationName attribute
		request.setAttribute("ApplicationName", applicationName);

		// Forward to request to "/ServletList.jsp"
		servletListDispatcher.forward(request, response);
	}

	private void sendMonitorAppInfo(HttpServletRequest request, HttpServletResponse response) throws Exception 
	{
		double [] servletInfoForGetMethod = null;
		double [] servletInfoForPostMethod = null;
		String resourceName = null;

		// Get Servlet resource name
		resourceName = request.getParameter("ServletName");
		if ( resourceName == null || resourceName.trim().isEmpty() == true ) {
			throw new Exception("Failed to get servlet resource name");
		}

		// Trim servlet name to avoid matching error
		resourceName = resourceName.trim();

		// Get info for GET method
//		servletInfoForGetMethod = DBWrapper.getDBWrapperObject().getDataForResourceByMethod(resourceName, HTTP_METHOD_GET);
		servletInfoForGetMethod = new double[3];
		servletInfoForGetMethod[0] = 3.6;
		servletInfoForGetMethod[1] = 5.6;
		servletInfoForGetMethod[2] = 6.9;
		
	/*	if (servletInfoForGetMethod == null) {
			throw new Exception("Failed to get data for " + HTTP_METHOD_GET + " method of resource: " + resourceName);
		}*/

		// Get info for POST method
//		servletInfoForPostMethod = DBWrapper.getDBWrapperObject().getDataForResourceByMethod(resourceName, HTTP_METHOD_POST);
		
		servletInfoForPostMethod = new double[3];
		servletInfoForPostMethod[0] = 3.6;
		servletInfoForPostMethod[1] = 5.6;
		servletInfoForPostMethod[2] = 6.9;
		
	/*	if (servletInfoForPostMethod == null) {
			throw new Exception("Failed to get data for " + HTTP_METHOD_POST + " method of resource: " + resourceName);
		}*/

		sendMonitorAppInfoAsXML(response, resourceName, servletInfoForGetMethod, servletInfoForPostMethod);
	}

	private void sendMonitorAppInfoAsXML(HttpServletResponse response, String Resource, double []ServletInfoForGetMethod, double []ServletInfoForPostMethod) throws Exception
	{
		// Set Content Type as XML
		response.setContentType("text/xml");

		// Get response writer
		PrintWriter responseWriter = response.getWriter();

		responseWriter.write("<?xml version=\"1.0\"?>\n\n");

		responseWriter.write("<ResourcesInfo>\n");
		
		responseWriter.write(	
				"	<Resource>\n" +
				"		<Name> " + Resource + "</Name>\n" +
				"		<Method> GET </Method>\n" +
				"		<AverageResponseTime>" + ServletInfoForGetMethod[0] + "</AverageResponseTime>\n" +
				"		<RequestPerMinute>" + ServletInfoForGetMethod[1] + "</RequestPerMinute>\n" + 
				"		<AverageBytesPerMinute>" + ServletInfoForGetMethod[2] + "</AverageBytesPerMinute>\n" +
				"	</Resource>\n");

		responseWriter.write(	
				"	<Resource>\n" +
				"		<Name> " + Resource + "</Name>\n" +
				"		<Method> POST </Method>\n" +
				"		<AverageResponseTime>" + ServletInfoForPostMethod[0] + "</AverageResponseTime>\n" +
				"		<RequestPerMinute>" + ServletInfoForPostMethod[1] + "</RequestPerMinute>\n" + 
				"		<AverageBytesPerMinute>" + ServletInfoForPostMethod[2] + "</AverageBytesPerMinute>\n" +
				"	</Resource>\n");
		
		responseWriter.write("</ResourcesInfo>\n");

		responseWriter.close();
	}

	void sendErrorPage(HttpServletRequest request, HttpServletResponse response, String errorMsg) {

		try {

			RequestDispatcher servletErrorDispatcher;

			// Get ServletError.jsp dispatcher
			servletErrorDispatcher = request.getRequestDispatcher("/ServletError.jsp");

			// Set an error message through an error attribute
			request.setAttribute("ServletError", "Monitoring Servlet encountered and error " + errorMsg);

			// Forward to request to "/ServletError.jsp"
			servletErrorDispatcher.forward(request, response);
		}

		// If will fail here, all we can do is to print an error message to console
		catch (Exception e) {

			System.out.println("Critical error: " + e.getMessage());

		}
	}
}
