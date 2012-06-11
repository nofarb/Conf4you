package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Conference;
import model.ConferencesUsers;
import model.Location;
import model.User;
import model.UserRole;

import utils.ProjConst;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import daos.ConferenceDao;
import daos.ConferencesParticipantsDao;
import daos.ConferencesUsersDao;
import daos.LocationDao;
import daos.UserDao;

/**
 * Servlet implementation class UsersServices
 */
public class ReceptionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private static final String FILTER_CHANGE = "filterChange";
	private static final String UPDATE_USER_ARRIVAL = "updateUserArrival";
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReceptionServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
    	
    	String action = request.getParameter("action");

		if (action == null) {
			//throw new Exception("Critical error!!! Servlet path is NULL.");
		}
		else if (action.equals(FILTER_CHANGE)) {
			getConferences(request, response);
		}
		else if(action.equals(UPDATE_USER_ARRIVAL))
		{
			userArrivalUpdate(request, response);
		}
		else {
			//throw new Exception("Unknown request");
		}	
    }
    
    private void getConferences(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException
    {
    	String userId = request.getParameter(ProjConst.USER_ID);
    	String filter = request.getParameter("filter");
   
    	User user = UserDao.getInstance().getUserById(Long.parseLong(userId));
    	    	
    	JsonObject jsonObject = new JsonObject();
    	
    	String resultSuccess;
    	String message;
    	
    	List<String> confList = null;
    	
    	try 
    	{
    		confList = ConferencesUsersDao.getInstance().getScopedConferenceByDate(user, filter);
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
       		json = gson.toJson(confList);
           		
           	out.write(json);
            out.flush();
        }
         finally {
            out.close();
        }
    }
    
    private void userArrivalUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException
    {
    	String confName = request.getParameter(ProjConst.CONF_NAME);
    	String userId = request.getParameter(ProjConst.USER_ID);
    	
    	User user = UserDao.getInstance().getUserById(Long.parseLong(userId));
    	Conference conference = ConferenceDao.getInstance().getConferenceByName(confName);
    	
    	
    	JsonObject jsonObject = new JsonObject();
    	
    	String resultSuccess;
    	String message;
    	
    	try 
    	{
    		//ConferencesUsersDao.getInstance().assignUserToConference(conference, user, Integer.parseInt(userRole));
    		ConferencesParticipantsDao.getInstance().updateUserArrival(conference, user);
    		resultSuccess = "true";
    		message = "User " + user.getName() + " arrived to conference " + conference.getName();
    		
    	}
    	catch (Exception e)
    	{
    		resultSuccess = "false";
    		message = "Failed to update user arrival";
    	}
    	
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try 
        {
            Gson gson = new Gson();
           	String json;
       		jsonObject.addProperty("resultSuccess", resultSuccess);
       		jsonObject.addProperty("message", message);
       		json = gson.toJson(jsonObject);
           	out.write(json);
            out.flush();
       	}
        finally
        {
            out.close();
        }
    }
    
    private void editConference(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException
    {
    	String confNameBeforeEdit = request.getParameter(ProjConst.CONF_NAME_BEFORE_EDIT);
    	Conference origConf = ConferenceDao.getInstance().getConferenceByName(confNameBeforeEdit);
    	
    	String confName = request.getParameter(ProjConst.CONF_NAME);
    	String desc = request.getParameter(ProjConst.CONF_DESC);
    	String location = request.getParameter(ProjConst.CONF_LOCATION);
    	
	    DateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
    			  
    	Date startDate = (Date)formatter.parse(request.getParameter(ProjConst.CONF_START_DATE));
    	Date endDate = (Date)formatter.parse(request.getParameter(ProjConst.CONF_END_DATE));
    	
    	Location locationInstance = LocationDao.getInstance().getLocationById(location);  	
    	
    	origConf.setName(confName).setDescription(desc).setLocation(locationInstance).setStartDate(startDate).setEndDate(endDate);
    	
    	JsonObject jsonObject = new JsonObject();
    	
    	String resultSuccess;
    	String message;
    	try 
    	{
    		
    		ConferenceDao.getInstance().updateConference(origConf);
    		message = "Conference successfully edited";
    		resultSuccess = "true";
    		
    	}
    	catch (Exception e)
    	{
    		message = "Found problem while editing conference";
    		resultSuccess = "false";
    	}
    	
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
           	String json;
           	if (ConferenceDao.getInstance().isConferenceNameExists(confName))	
           	{
           		jsonObject.addProperty("resultSuccess", resultSuccess);
           		jsonObject.addProperty("message", message);
           		json = gson.toJson(jsonObject);
           	}
           	else
           	{
           		jsonObject.addProperty("resultSuccess", "false");
           		jsonObject.addProperty("message", "Failed to edit conference");
           		json = gson.toJson(jsonObject);
           	}
           	out.write(json);
            out.flush();
        }
         finally {
            out.close();
        }
    }
     
    private void removeUser(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException
    {
    	String confName = request.getParameter(ProjConst.CONF_NAME);
    	Conference conference = ConferenceDao.getInstance().getConferenceByName(confName);
    	
    	String userName = request.getParameter("userName");
    	User user = UserDao.getInstance().getUserByUserName(userName);
    	
    	JsonObject jsonObject = new JsonObject();
    	
    	String resultSuccess;
    	String message;
    	try 
    	{
    		ConferencesUsersDao.getInstance().removeUserFromConference(conference, user);
    		resultSuccess = "true";
    		
    	}
    	catch (Exception e)
    	{
    		resultSuccess = "false";
    	}
    	
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
           	String json;
           	if (ConferenceDao.getInstance().isConferenceNameExists(confName))	
           	{
           		jsonObject.addProperty("resultSuccess", resultSuccess);
           		json = gson.toJson(jsonObject);
           	}
           	else
           	{
           		jsonObject.addProperty("resultSuccess", "false");
           		jsonObject.addProperty("message", "Failed to edit conference");
           		json = gson.toJson(jsonObject);
           	}
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
