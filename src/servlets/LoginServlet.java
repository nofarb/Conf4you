package servlets;

import java.io.IOException;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import utils.EmailUtils;
import utils.MockCreation;
import utils.ProjConst;
import model.User;
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
    	
    /*		List <String> emails = new LinkedList<String>();
    		emails.add("nofarb@gmail.com");
    		
    		EmailUtils.sendEmail("smtp.gmail.com", "nofarb@gmail.com", "PASS", "587", "subj", emails, "yada", false);
    		EmailUtils.sendEmail("smtp.gmail.com", "nofarb@gmail.com", "PASS", "587", "subj", emails, "<h1>This is actual message</h1>", true);*/

    		
			String userName = request.getParameter("un");
			String password = request.getParameter("pw"); 
			
			User user = UserDao.getInstance().authenticateUser(userName, password);
			
			if (user != null)
			{
				request.getSession(true).setAttribute(ProjConst.SESSION_USER_ID, user.getUserId());
								
				//updating last login time:
				user.setLastLogin(new Date());
				UserDao.getInstance().updateUser(user);
				
				response.sendRedirect(ProjConst.USER_PAGE); //redirect to main page
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
