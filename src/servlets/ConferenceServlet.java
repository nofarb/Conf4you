package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import daos.ConferenceDao;

/**
 * Servlet implementation class UsersServices
 */
public class ConferenceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConferenceServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
       catch (Exception e)
       {
    	   String bla = e.getMessage();
       }
        finally {
           out.close();
       }
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}

}
