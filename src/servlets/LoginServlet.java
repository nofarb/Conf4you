package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.corba.se.spi.activation.Repository;

import utils.EmailUtils;
import utils.MockCreation;
import utils.ProjConst;
import utils.UniqueUuid;
import model.Conference;
import model.Location;
import model.User;
import model.UserRole;
import daos.ConferenceDao;
import daos.ConferencesUsersDao;
import daos.LocationDao;
import daos.UserDao;



/**
 * Servlet implementation class LoginServlet
 */
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static Logger logger = Logger.getLogger(LoginServlet.class);
	private static final String RESET_PASSWORD = "resetPassword";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    protected void processLoginRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {  	
    	try 
		{
    		
    		User adminUser = UserDao.getInstance().getUserByUserName("admin");
    		
    		if (adminUser == null)
    		{
    			List<Conference> confs = (List<Conference>) MockCreation.createMockConferencesAndLocations();
    			List<User> users = (List<User>) MockCreation.createMockUsersAndCompanies(); 
    		}
    		
			String userName = request.getParameter("un");
			String password = request.getParameter("pw"); 
			
			User user = UserDao.getInstance().authenticateUser(userName, password);
			
			if (user != null)
			{
				request.getSession(true).setAttribute(ProjConst.SESSION_USER_ID, user.getUserId());

				// Update Cookie
				//Cookie userCookie = new Cookie(ProjConst.SESSION_USER_ID, String.valueOf(user.getUserId()));
				//userCookie.setMaxAge(ProjConst.SESSION_COOKIE_MAX_AGE);
				//response.addCookie(userCookie);
								
				//updating last login time:
				user.setLastLogin(new Date());
				UserDao.getInstance().updateUser(user);
				
				if (user.isAdmin())
				{
					response.sendRedirect(ProjConst.HOME_PAGE);
					return;
				}
				
				UserRole userRole = ConferencesUsersDao.getInstance().getUserHighestRole(user);
				
				if (userRole.getValue() <= 2)
				{
					logger.info("User with lower permitions tried to login, user id: " + user.getUserId());
					response.sendRedirect(ProjConst.LOGIN_PAGE + "?messageNotificationType=error&messageNotification=You have insufficient permissions to login");
					return;
				}
				
				if (userRole.getValue() == 3)
				{
					response.sendRedirect(ProjConst.RECEPTION_PAGE);
					return;
				}
				response.sendRedirect(ProjConst.HOME_PAGE);
			}
			else{
				logger.info("User with no permitions tried to login, user name: " + userName);
				response.sendRedirect(ProjConst.LOGIN_PAGE + "?messageNotificationType=error&messageNotification=Wrong user name or password");
			}
		}
		catch (Exception ex)
		{ 
			logger.error("unexpected error while login operation", ex);
		}
    }
    
    protected void processLogoutRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	try 
		{
				request.getSession(true).invalidate();
				response.sendRedirect(ProjConst.LOGIN_PAGE); 

		}
		catch (Throwable theException)
		{ 
			System.out.println(theException);	
		}
    }
    
    private void resetPassword(HttpServletRequest request, HttpServletResponse response) throws IOException
    {
    	String userName = request.getParameter("userName");
    	
    	User user = UserDao.getInstance().getUserByUserName(userName);
    	    	
    	JsonObject jsonObject = new JsonObject();
    	
    	String resultSuccess;
    	String message;
    	if (user != null)
    	{
	    	try 
	    	{
	    		UserDao.getInstance().resetForgottenPassword(user);
	    		message = "Email with new password sent";
	    		resultSuccess = "true";
	    		
	    	}
	    	catch (Exception e)
	    	{
	    		message = e.getMessage();
	    		resultSuccess = "false";
	    	}
    	}
    	else
    	{
    		message = "Can't remember your user name? Your conference manager can help!";
    		resultSuccess = "false";
    	}
    	
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
           	String json;

       		jsonObject.addProperty("resultSuccess", resultSuccess);
       		jsonObject.addProperty("message", message);
       		json = gson.toJson(jsonObject);
           	
           	out.write(json);
            out.flush();
        }
         finally {
            out.close();
        }
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String action = request.getParameter("action");
		
		if(action.equals("login")){
			processLoginRequest(request, response);
		}else if(action.equals("logout")){
			processLogoutRequest(request, response);
		}else if(action.equals(RESET_PASSWORD)){
			resetPassword(request, response);
		}else{
			logger.error("Unknown doHet request");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
