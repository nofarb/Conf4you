package servlets;

import helpers.ProjConst;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Conference;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import daos.ConferenceDao;
import daos.ConferencesParticipantsDao;

import org.apache.commons.lang3.time.DateUtils;


/**
 * Servlet implementation class UsersServices
 */
public class ReportsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private static final String arrivedDates = "getArrivedUserDate";
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReportsServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
    	
    	String action = request.getParameter("action");

		if (action == null) {
			//throw new Exception("Critical error!!! Servlet path is NULL.");
		}
		else if (action.equals(arrivedDates)) {
			addLocation(request, response);
		}
		else {
			//throw new Exception("Unknown request");
		}	
    }
    
    private void addLocation(HttpServletRequest request, HttpServletResponse response) throws IOException, ParseException
    {	    	
    	JsonObject jsonObject = new JsonObject();
    	
    	StringBuilder sb = new StringBuilder();
    	
    	String resultSuccess = null;
    	String message = null;
    	try 
    	{
    		String confId = request.getParameter(ProjConst.CONF_ID);
        	Conference conf = ConferenceDao.getInstance().getConferenceById(Long.valueOf(confId.trim()));
        	
        	sb.append("[");
        	
        	Date start = conf.getStartDate();
    		start = DateUtils.setHours(start, 0);
    		start = DateUtils.setMinutes(start, 0);
    		start = DateUtils.setSeconds(start, 0);
    		start = DateUtils.setMilliseconds(start, 0);
    		
    		Date end = conf.getEndDate();
    		end = DateUtils.setHours(end, 0);
    		end = DateUtils.setMinutes(end, 0);
    		end = DateUtils.setSeconds(end, 0);
    		end = DateUtils.setMilliseconds(end, 0);
        	
    		while(start.before(end) || start.equals(end)){
    			String dateToPresent = new SimpleDateFormat("yyyy-MM-dd").format(start);
    			int arrived = ConferencesParticipantsDao.getInstance().getNumberOfUsersThatArrivedToConferenceInDate(conf, start);
    			
    			sb.append("['"+ dateToPresent +"'," +arrived + "], ");
    			
    			start = DateUtils.addDays(start, 1);
    		}
    		
    		sb.replace(sb.lastIndexOf(","), sb.lastIndexOf(",") + 2, "");
    		sb.append("]");
    		resultSuccess = "true";
    		
    	}
    	catch (Exception e)
    	{
    		message = "Failed to get conference arrival chart";
    		resultSuccess = "false";
    	}
    	
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            Gson gson = new Gson();
           	String json;
           	jsonObject.addProperty("results", sb.toString());
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
