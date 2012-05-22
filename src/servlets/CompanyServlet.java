package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Company;
import model.CompanyType;



import utils.ProjConst;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import daos.CompanyDao;


/**
 * Servlet implementation class UsersServices
 */
public class CompanyServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private static final String ADD_COMP = "add";
	private static final String DELETE_COMP = "delete";
	private static final String EDIT_COMP = "edit";
	private static final String COMP_NAME_VALIDATION = "validation";
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CompanyServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
    	
    	String action = request.getParameter("action");

		if (action == null) {
			//throw new Exception("Critical error!!! Servlet path is NULL.");
		}
		else if (action.equals(ADD_COMP)) {
			addCompany(request, response);
		}
		else if (action.equals(DELETE_COMP)) {
			deleteCompany(request, response);
		}
		else if (action.equals(EDIT_COMP)) {
			//editUser(request, response);
		}
		else if (action.equals(COMP_NAME_VALIDATION)) {
			companyNameValidation(request, response);
		}
		else {
			//throw new Exception("Unknown request");
		}	
    }
    
    private void addCompany(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException
    {
    	String companyName = request.getParameter(ProjConst.COMP_NAME);
    	String compTypeStr = request.getParameter(ProjConst.COMP_TYPE);
    	//String location = request.getParameter(ProjConst.CONF_LOCATION);
    	
	    //DateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
    			  
    	//Date startDate = (Date)formatter.parse(request.getParameter(ProjConst.CONF_START_DATE));
    	//Date endDate = (Date)formatter.parse(request.getParameter(ProjConst.CONF_END_DATE));
    	
    	//Location locationInstance = LocationDao.getInstance().getLocationById(location);
    	    	
    	JsonObject jsonObject = new JsonObject();
    	
    	String resultSuccess;
    	String message;
    	try 
    	{
    		//ConferenceDao.getInstance().addNewConference(new Conference(confName, locationInstance, desc, startDate, endDate));
    		CompanyType companyType = CompanyType.valueOf(compTypeStr); 
    		CompanyDao.getInstance().addCompany(new Company(companyName, companyType));
    		message = "Company successfully added";
    		resultSuccess = "true";
    		
    	}
    	catch (Exception e)
    	{
    		message = "Found problem while adding company";
    		resultSuccess = "false";
    	}
    	
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
           	String json;
           	//if (ConferenceDao.getInstance().isConferenceNameExists(companyName))
          	if(CompanyDao.getInstance().isCompanyNameExists(companyName))
           	{
           		jsonObject.addProperty("resultSuccess", resultSuccess);
           		jsonObject.addProperty("message", message);
           		json = gson.toJson(jsonObject);
           	}
           	else
           	{
           		jsonObject.addProperty("resultSuccess", "false");
           		jsonObject.addProperty("message", "Failed to add company");
           		json = gson.toJson(jsonObject);
           	}
           	out.write(json);
            out.flush();
        }
         finally {
            out.close();
        }
    }
    
    private void deleteCompany(HttpServletRequest request, HttpServletResponse response) throws IOException
    {
    	JsonObject jsonObject = new JsonObject();
    	
    	String companyName = request.getParameter(ProjConst.COMP_NAME);
    	
      	String resultSuccess;
    	String message;
    	try 
    	{
    		CompanyDao.getInstance().deleteCompany(companyName);
    		message = "Company successfully deleted";
    		resultSuccess = "true";
    		
    	}
    	catch (Exception e)
    	{
    		message = "Found problem while deleting company";
    		resultSuccess = "false";
    	}
    	
    	response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
           	String json;
           	if (CompanyDao.getInstance().isCompanyNameExists(companyName))
           	{
           		jsonObject.addProperty("resultSuccess", resultSuccess);
           		jsonObject.addProperty("message", message);
           		json = gson.toJson(jsonObject);
           	}
           	else
           	{
           		jsonObject.addProperty("resultSuccess", "false");
           		jsonObject.addProperty("message", "Failed to delete company");
           		json = gson.toJson(jsonObject);
           	}
           	out.write(json);
            out.flush();
        }
         finally {
            out.close();
        }
    }
    
    private void companyNameValidation(HttpServletRequest request, HttpServletResponse response) throws IOException
    {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
            
            String companyName = request.getParameter("data");
            if (companyName != null)
            {
 	           	String json;
 	           	if (CompanyDao.getInstance().isCompanyNameExists(companyName))
 	           		json = gson.toJson("true");
 	           	else 
 	           		json = gson.toJson("false");
 	           	out.write(json);
            	}
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
		try {
			processRequest(request, response);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			processRequest(request, response);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
