package servlets;

import helpers.ProjConst;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Location;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import daos.LocationDao;


/**
 * Servlet implementation class UsersServices
 */
public class LocationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private static final String ADD_Loc = "add";
	private static final String DELETE_Loc = "delete";
	private static final String EDIT_Loc = "edit";
	private static final String Loc_NAME_VALIDATION = "validation";
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LocationServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
    	
    	String action = request.getParameter("action");

		if (action == null) {
			//throw new Exception("Critical error!!! Servlet path is NULL.");
		}
		else if (action.equals(ADD_Loc)) {
			addLocation(request, response);
		}
		else if (action.equals(DELETE_Loc)) {
			deleteLocation(request, response);
		}
		else if (action.equals(EDIT_Loc)) {
			editLocation(request, response);
		}
		else if (action.equals(Loc_NAME_VALIDATION)) {
			locationNameValidation(request, response);
		}
		else {
			//throw new Exception("Unknown request");
		}	
    }
    
    private void addLocation(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException
    {
    	String locationName = request.getParameter(ProjConst.LOC_NAME);
    	String locationAddress = request.getParameter(ProjConst.LOC_Address);
    	String locationMaxCapacityStr = request.getParameter(ProjConst.LOC_MaxCapacity);
    	String locationContactName = request.getParameter(ProjConst.LOC_ContactName);
    	String locationPhone1 = request.getParameter(ProjConst.LOC_Phone1);
    	String locationPhone2 = request.getParameter(ProjConst.LOC_Phone2);
    	//String location = request.getParameter(ProjConst.CONF_LOCATION);
    	
	    //DateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
    			  
    	//Date startDate = (Date)formatter.parse(request.getParameter(ProjConst.CONF_START_DATE));
    	//Date endDate = (Date)formatter.parse(request.getParameter(ProjConst.CONF_END_DATE));
    	
    	//Location locationInstance = LocationDao.getInstance().getLocationById(location);
    	    	
    	JsonObject jsonObject = new JsonObject();
    	
    	String resultSuccess = null;
    	String message = null;
    	try 
    	{
    		//ConferenceDao.getInstance().addNewConference(new Conference(confName, locationInstance, desc, startDate, endDate));
    		int locationMaxCapacity = Integer.parseInt( locationMaxCapacityStr );
    		LocationDao.getInstance().addLocation(new Location(locationName, locationAddress, locationMaxCapacity, locationContactName, locationPhone1, locationPhone2));
    		message = "Location " +locationName+ " successfully added";
    		resultSuccess = "true";
    		
    	}
    	catch (Exception e)
    	{
    		message = "Found problem while adding location";
    		resultSuccess = "false";
    	}
    	
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
           	String json;
          	if(LocationDao.getInstance().isLocationNameExists(locationName))
           	{
           		jsonObject.addProperty("resultSuccess", resultSuccess);
           		jsonObject.addProperty("message", message);
           		json = gson.toJson(jsonObject);
           	}
           	else
           	{
           		jsonObject.addProperty("resultSuccess", "false");
           		jsonObject.addProperty("message", "Failed to add location");
           		json = gson.toJson(jsonObject);
           	}
           	out.write(json);
            out.flush();
        }
         finally {
            out.close();
        }
    }
    
    private void deleteLocation(HttpServletRequest request, HttpServletResponse response) throws IOException
    {
    	JsonObject jsonObject = new JsonObject();
    	
    	String locationName = request.getParameter(ProjConst.LOC_NAME);
    	
      	String resultSuccess;
    	String message;
    	try 
    	{
    		LocationDao.getInstance().deleteLocation(locationName);
    		message = "Location " + locationName + " removed successfully from the system";
    		resultSuccess = "true";
    		
    	}
    	catch (Exception e)
    	{
    		//message = "Found problem while deleting location";
    		message = e.getMessage();
    		resultSuccess = "false";
    	}
    	
    	response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
           	String json;
           	if (LocationDao.getInstance().isLocationNameExists(locationName))
           	{
           		jsonObject.addProperty("resultSuccess", resultSuccess);
           		jsonObject.addProperty("message", message);
           		json = gson.toJson(jsonObject);
           	}
           	else
           	{
           		jsonObject.addProperty("resultSuccess", "false");
           		jsonObject.addProperty("message", "Failed to delete location");
           		json = gson.toJson(jsonObject);
           	}
           	out.write(json);
            out.flush();
        }
         finally {
            out.close();
        }
    }
    
    private void locationNameValidation(HttpServletRequest request, HttpServletResponse response) throws IOException
    {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
            
            String locationName = request.getParameter("data");
            if (locationName != null)
            {
 	           	String json;
 	           	if (LocationDao.getInstance().isLocationNameExists(locationName))
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

    private void editLocation(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException
    {
    	String locNameBeforeEdit = request.getParameter(ProjConst.LOC_NAME_BEFORE_EDIT);
    	Location origLoc = LocationDao.getInstance().getLocationByName(locNameBeforeEdit);
    	
    	String locationName = request.getParameter(ProjConst.LOC_NAME);
    	String locationAddress = request.getParameter(ProjConst.LOC_Address);
    	String locationMaxCapacityStr = request.getParameter(ProjConst.LOC_MaxCapacity);
    	String locationContactName = request.getParameter(ProjConst.LOC_ContactName);
    	String locationPhone1 = request.getParameter(ProjConst.LOC_Phone1);
    	String locationPhone2 = request.getParameter(ProjConst.LOC_Phone2);
    	int locationMaxCapacity = Integer.parseInt(locationMaxCapacityStr);
    	
    	origLoc.setName(locationName).setAddress(locationAddress).setContactName(locationContactName).setMaxCapacity(locationMaxCapacity);
    	origLoc.setPhone1(locationPhone1).setPhone2(locationPhone2);
    	
    	JsonObject jsonObject = new JsonObject();
    	
    	String resultSuccess;
    	String message;
    	try 
    	{
    		LocationDao.getInstance().updateLocation(origLoc);
    		message = "Location successfully edited";
    		resultSuccess = "true";
    		
    	}
    	catch (Exception e)
    	{
    		message = "Found problem while editing location";
    		resultSuccess = "false";
    	}
    	
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
           	String json;
           	//if (ConferenceDao.getInstance().isConferenceNameExists(confName))
           	if (LocationDao.getInstance().isLocationNameExists(locationName))
           	{
           		jsonObject.addProperty("resultSuccess", resultSuccess);
           		jsonObject.addProperty("message", message);
           		json = gson.toJson(jsonObject);
           	}
           	else
           	{
           		jsonObject.addProperty("resultSuccess", "false");
           		jsonObject.addProperty("message", "Failed to edit location");
           		json = gson.toJson(jsonObject);
           	}
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
