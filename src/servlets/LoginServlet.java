package servlets;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import utils.MockCreation;
import utils.ProjConst;

import model.User;

import daos.CompanyDao;
import daos.ConferenceDao;
import daos.UserDao;



/**
 * Servlet implementation class LoginServlet
 */
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
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
    		
    		//CompanyDao.getInstance().addCompany(MockCreation.createMockCompanies());
    		ConferenceDao.getInstance().addNewConference(MockCreation.createMockConferences());
    		UserDao.getInstance().addUsers(MockCreation.createMockUsers()); 
    		
    		
			String userName = request.getParameter("un");
			String password = request.getParameter("pw"); 
			
			User user = UserDao.getInstance().authenticateUser(userName, password);
			
			if (user != null)
			{
				HttpSession session = request.getSession(true);
				session.setAttribute("currentSessionUser", userName);
								
				//updating last login time:
				user.setLastLogin(new Date());
				UserDao.getInstance().updateUser(user);
				
				response.sendRedirect(ProjConst.MAIN_PAGE); //redirect to main page
			}
			else{
				response.sendRedirect(ProjConst.LOGIN_PAGE); // TODO - alert on error if authentication fails
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
			//TODO - unknown request
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
