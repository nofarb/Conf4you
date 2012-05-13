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

import model.Conference;
import model.Location;

import utils.ProjConst;
import com.google.gson.Gson;

import daos.ConferenceDao;
import daos.LocationDao;

/**
 * Servlet implementation class UsersServices
 */
public class ConferenceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private static final String ADD_CONF = "add";
	private static final String DELETE_CONF = "delete";
	private static final String EDIT_CONF = "edit";
	private static final String CONF_NAME_VALIDATION = "validation";
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConferenceServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
    	
    	String action = request.getParameter("action");

		if (action == null) {
			//throw new Exception("Critical error!!! Servlet path is NULL.");
		}
		else if (action.equals(ADD_CONF)) {
			addConference(request, response);
		}
		else if (action.equals(DELETE_CONF)) {
			//deleteUser(request, response);
		}
		else if (action.equals(EDIT_CONF)) {
			//editUser(request, response);
		}
		else if (action.equals(CONF_NAME_VALIDATION)) {
			conferenceNameValidation(request, response);
		}
		else {
			//throw new Exception("Unknown request");
		}


    	
    	
    
    }
    
    private void addConference(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException
    {
    	String confName = request.getParameter(ProjConst.CONF_NAME);
    	String desc = request.getParameter(ProjConst.CONF_DESC);
    	String location = request.getParameter(ProjConst.CONF_LOCATION);
    	
	    DateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
    			  
    	Date startDate = (Date)formatter.parse(request.getParameter(ProjConst.CONF_START_DATE));
    	Date endDate = (Date)formatter.parse(request.getParameter(ProjConst.CONF_END_DATE));
    	
    	Location locationInstance = LocationDao.getInstance().getLocationByName(location);
    	
    	String resultSuccess;
    	String message;
    	try 
    	{
    		ConferenceDao.getInstance().addNewConference(new Conference(confName, locationInstance, desc, startDate, endDate));
    		message = "Conference successfully added";
    		resultSuccess = "true";
    		
    	}
    	catch (Exception e)
    	{
    		message = "Found problem while adding conference";
    		resultSuccess = "false";
    	}
    	
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
           	String json;
           	if (ConferenceDao.getInstance().isConferenceNameExists(confName))
           		json = gson.toJson("{resultSuccess:" + resultSuccess + "," + "message:" + message + "}");
           	else 
           		json = gson.toJson("false");
           	out.write(json);
            out.flush();
        }
         finally {
            out.close();
        }
    }
    
    private void conferenceNameValidation(HttpServletRequest request, HttpServletResponse response) throws IOException
    {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
            
            String confName = request.getParameter("data");
            if (confName != null)
            {
 	           	String json;
 	           	if (ConferenceDao.getInstance().isConferenceNameExists(confName))
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
