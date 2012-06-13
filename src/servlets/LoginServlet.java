package servlets;

import java.io.IOException;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import utils.EmailUtils;
import utils.MockCreation;
import utils.ProjConst;
import model.Conference;
import model.User;
import model.UserRole;
import daos.ConferenceDao;
import daos.ConferencesUsersDao;
import daos.UserDao;



/**
 * Servlet implementation class LoginServlet
 */
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static Logger logger = Logger.getLogger(LoginServlet.class);
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
					response.sendRedirect(ProjConst.USER_PAGE);
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
				response.sendRedirect(ProjConst.CONFERENCE_PAGE); //TODO: Will be home page
			}
			else{
				logger.info("User with no permitions tried to login, user name: " + userName);
				response.sendRedirect(ProjConst.LOGIN_PAGE + "?messageNotificationType=error&messageNotification=Wrong user name or password");
			}
		}
		catch (Throwable theException)
		{ 
			System.out.println(theException);	
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

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String action = request.getParameter("action");
		
		if(action.equals("login")){
			processLoginRequest(request, response);
		}else if(action.equals("logout")){
			processLogoutRequest(request, response);
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
