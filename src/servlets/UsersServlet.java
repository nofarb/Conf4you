package servlets;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import daos.UserDao;

/**
 * Servlet implementation class UsersServices
 */
public class UsersServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final String DELETE_USER = "delete";
	private static final String EDIT_USER = "EDIT"; //used both for add and edit

       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UsersServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String action = request.getParameter("action");

		try {
			if (action == null) {
				throw new Exception("Critical error!!! Servlet path is NULL.");
			}
			else if (action.equals(DELETE_USER)) {
				deleteUser(request, response);
			}
			else if (action.equals(EDIT_USER)) {
				editUser(request, response);
			}
			else {
				throw new Exception("Unknown request");
			}
		}

		catch (Exception e) {
//			sendErrorPage(request, response, e.getMessage());
		}
	}


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}
	
	
	private void deleteUser(HttpServletRequest request,	HttpServletResponse response) throws Exception {


		String userName = request.getParameter("userName");
		if ( userName == null || userName.trim().isEmpty()) {
			throw new Exception("Failed to get user name");
		}
		
		//TODO - delete - add a mark for inactive user
	}
	
	private void editUser(HttpServletRequest request,	HttpServletResponse response) throws Exception {


		String userName = request.getParameter("userName");
		
		if ( userName == null || userName.trim().isEmpty()) {
			throw new Exception("Failed to get user name");
		}
		
		//TODO - edit/add 
		}

}
