package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import system.exceptions.ItemCanNotBeDeleted;
import utils.ProjConst;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import model.Company;
import model.User;
import daos.CompanyDao;
import daos.UserDao;

/**
 * Servlet implementation class UsersServices
 */
public class UsersServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final String DELETE_USER = "delete";
	private static final String EDIT_USER = "edit";
	private static final String ADD_USER = "add";
	private static final String VALIDATION_USER_NAME_UNIQUE = "validateUserNameUnique";



       
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
				throw new Exception("Critical error!!! action is NULL.");
			}
			else if (action.equals(DELETE_USER)) {
				deleteUser(request, response);
			}
			else if (action.equals(EDIT_USER)) {
				editUser(request, response);
			}
			else if (action.equals(ADD_USER)) {
				addUser(request, response);
			}
			else if (action.equals(VALIDATION_USER_NAME_UNIQUE)) {
				validate(request, response);
			}
			else {
				throw new Exception("Unknown request");
			}
		}

		catch (Exception e) {
//			sendErrorPage(request, response, e.getMessage());
		}
	}

	private void validate(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String userName = request.getParameter(ProjConst.USER_NAME);
		if (userName == null) {
			throw new Exception("Failed to get user name");
		}

		response.setContentType("application/json;charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		try {
			Gson gson = new Gson();

			User userByUserName = UserDao.getInstance().getUserByUserName(userName);
			String json;
			if (userByUserName != null)
				json = gson.toJson("true");
			else
				json = gson.toJson("false");
			out.write(json);
			out.flush();
		} finally {
			out.close();
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	
	private void deleteUser(HttpServletRequest request,	HttpServletResponse response) throws Exception {


		String userIdstr = request.getParameter(ProjConst.USER_ID);
		
		if ( userIdstr == null) {
			throw new Exception("Failed to get user id");
		}
		
		Long userId = new Long(userIdstr);
				
		response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
       	String json;

        try {
            Gson gson = new Gson();
            
            if (userId != null)
            {
        		try {
					UserDao.getInstance().deleteUser(userId);
					json = gson.toJson("true");

				} catch (ItemCanNotBeDeleted e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					json = gson.toJson("false");
				}
 	           		
 	           	out.write(json);
            	}
            out.flush();
        }
         finally {
            out.close();
        }
	}
	
	private void editUser(HttpServletRequest request, HttpServletResponse response) throws Exception {


		String userName = request.getParameter(ProjConst.USER_NAME);
		
		if ( userName == null || userName.trim().isEmpty()) {
			throw new Exception("Failed to get user name");
		}
		
		//TODO - edit/
	}
	
	private void addUser(HttpServletRequest request, HttpServletResponse response) throws Exception {


		String userName = request.getParameter(ProjConst.USER_NAME);
		String name = request.getParameter(ProjConst.NAME);
		String phone1 = request.getParameter(ProjConst.PHONE1);
		String phone2 = request.getParameter(ProjConst.PHONE2);
		String email = request.getParameter(ProjConst.EMAIL);
		String passportId = request.getParameter(ProjConst.PASSPORT_ID);
		String companyIdStr = request.getParameter(ProjConst.COMPANY);
		long companyId = new Long(companyIdStr);
		Company company = CompanyDao.getInstance().getCompanyById(companyId);
		String password = request.getParameter(ProjConst.PASSWORD); // TODO should encrypt on client side
		boolean isAdmin = new Boolean(request.getParameter(ProjConst.IS_ADMIN)); 
		

    	JsonObject jsonObject = new JsonObject();
    	
    	String resultSuccess;
    	String message;
    	try 
    	{
    		if(phone2 == null){
    			phone2 = "";
    		}
    		
    		User newUser = new User(userName, passportId, company, name, email, phone1, phone2, password, isAdmin);
    		UserDao.getInstance().addUser(newUser);
    		message = "User successfully added";
    		resultSuccess = "true";
    		
    	}
    	catch (Exception e)
    	{
    		message = "Problem occurred while adding user";
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

}
