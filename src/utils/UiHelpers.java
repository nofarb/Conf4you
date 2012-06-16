package utils;

import daos.ConferencesUsersDao;
import model.User;
import model.UserRole;

public class UiHelpers {

	
	public static StringBuilder GetAllJsAndCss()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append("<link type=\"text/css\" href=\"css/main.css\" rel=\"stylesheet\" />");
		sb.append("<link type=\"text/css\" href=\"css/tables/tableList.css\" rel=\"stylesheet\" />");
		sb.append("<link type=\"text/css\" href=\"css/cupertino/jquery-ui-1.8.18.custom.css\" rel=\"stylesheet\" />");
		sb.append("<link type=\"text/css\" href=\"css/jNotify.jquery.css\" rel=\"stylesheet\" />");
		sb.append("<link href=\"/conf4u/resources/imgs/conf4u_logo.ico\" rel=\"shortcut icon\" />");
		sb.append("<script type=\"text/javascript\" src=\"js/jquery-1.7.1.min.js\"></script>");
		sb.append("<script type=\"text/javascript\" src=\"js/jquery-ui-1.8.18.custom.min.js\"></script>");
		sb.append("<script type=\"text/javascript\" src=\"js/jquery.validate.js\"></script>");
		sb.append("<script type=\"text/javascript\" src=\"js/jNotify.jquery.js\"></script>");
		sb.append("<script type=\"text/javascript\" src=\"js/jquery.quicksearch.js\"></script>");
		sb.append("<script type=\"text/javascript\" src=\"js/datetimepicker.js\"></script>");
		
		return sb;
	}
	
	public static StringBuilder GetHeader()
	{
		StringBuilder sb = new StringBuilder();
		
		//Header start
		//--------------------------------------------------------------------
		sb.append("<div id=\"vn_header_div\">");
		
		//Logo image
		//--------------------------------------------------------------------
		sb.append("<div id=\"vn_header_logo\">");
		sb.append("<img  width=\"97\" height=\"56\" border=\"0\" alt=\"\" src=\"/conf4u/resources/imgs/conf4u_logo.png\">");
		sb.append("</div>");
		//--------------------------------------------------------------------
		
		//Top links
		//--------------------------------------------------------------------
		sb.append("<div id=\"vn_header_toprightlinks\">");
		
		sb.append("<div class=\"vn_header_toprightlink\">");
		sb.append("<a class=\"isnormal\" href=\"LoginServlet?action=logout\">Log off</a>");
		sb.append("</div>");
		
		sb.append("</div>");
		//--------------------------------------------------------------------
						
		sb.append("</div>");
		//--------------------------------------------------------------------
		sb.append("<div class=\"clearboth\"></div>");
		
		return sb;	
	}
	
	public static StringBuilder GetTabs(User requstingUser, String chosenTab)
	{
		StringBuilder sb = new StringBuilder();
		
		//Tabs starts
		//--------------------------------------------------------------------
		sb.append("<div id=\"navHIDDENBYTAL\">");
		sb.append("<div id=\"vn_header_tabs\">");
		sb.append("<ul>");
		
		if (requstingUser.isAdmin())
		{
			//Users tab
			//--------------------------------------------------------------------
			sb.append(String.format("<li%s>", ProjConst.TAB_USERS == chosenTab ? " class=\"focuslink\"" : ""));
			sb.append("<a href=\"users.jsp\">");
			sb.append("<span>Users</span>");
			sb.append("</a>");
			sb.append("</li>");
			//--------------------------------------------------------------------
		}
		
		if (requstingUser.isAdmin() || ConferencesUsersDao.getInstance().getUserHighestRole(requstingUser).getValue() >= 4)
		{
			//Conferences tab
			//--------------------------------------------------------------------
			sb.append(String.format("<li%s>", ProjConst.TAB_CONFERENCES == chosenTab ? " class=\"focuslink\"" : ""));
			sb.append("<a href=\"conference.jsp\">");
			sb.append("<span>Conferences</span>");
			sb.append("</a>");
			sb.append("</li>");
			//--------------------------------------------------------------------
		}
		
		if (requstingUser.isAdmin())
		{
			//Companies tab
			//--------------------------------------------------------------------
			sb.append(String.format("<li%s>", ProjConst.TAB_COMPANIES == chosenTab ? " class=\"focuslink\"" : ""));
			sb.append("<a href=\"company.jsp\">");
			sb.append("<span>Companies</span>");
			sb.append("</a>");
			sb.append("</li>");
			//--------------------------------------------------------------------
		}
		
		if (requstingUser.isAdmin())
		{
			//Locations tab
			//--------------------------------------------------------------------
			sb.append(String.format("<li%s>", ProjConst.TAB_LOCATIONS == chosenTab ? " class=\"focuslink\"" : ""));
			sb.append("<a href=\"locations.jsp\">");
			sb.append("<span>Locations</span>");
			sb.append("</a>");
			sb.append("</li>");
			//--------------------------------------------------------------------
		}

		if (requstingUser.isAdmin() || ConferencesUsersDao.getInstance().getUserHighestRole(requstingUser).getValue() >= UserRole.RECEPTIONIST.getValue())
		{
			//Reception tab
			//--------------------------------------------------------------------
			sb.append(String.format("<li%s>", ProjConst.TAB_RECEPTION == chosenTab ? " class=\"focuslink\"" : ""));
			sb.append("<a href=\"reception.jsp\">");
			sb.append("<span>Reception</span>");
			sb.append("</a>");
			sb.append("</li>");
			//--------------------------------------------------------------------
		}
		if (requstingUser.isAdmin() || ConferencesUsersDao.getInstance().getUserHighestRole(requstingUser).getValue() >= 4)
		{
			//reports tab
			//--------------------------------------------------------------------
			sb.append(String.format("<li%s>", ProjConst.TAB_REPORTS == chosenTab ? " class=\"focuslink\"" : ""));
			sb.append("<a href=\"reports.jsp\">");
			sb.append("<span>Reports</span>");
			sb.append("</a>");
			sb.append("</li>");
			//--------------------------------------------------------------------
		}
		sb.append("</ul>");
		sb.append("</div>");
		sb.append("</div>");
		sb.append("<div id=\"bottomNav\"> </div>");
		//--------------------------------------------------------------------
		
		
		sb.append("<div class=\"clearboth\"></div>");
		return sb;
	}

	public static StringBuilder GetHeader(User requstingUser)
	{
		StringBuilder sb = new StringBuilder();
		
		//Header start
		//--------------------------------------------------------------------
		sb.append("<div id=\"vn_header_div\">");
		
		//Logo image
		//--------------------------------------------------------------------
		sb.append("<div id=\"vn_header_logo\">");
		sb.append("<img  width=\"97\" height=\"56\" border=\"0\" alt=\"\" src=\"/conf4u/resources/imgs/conf4u_logo.png\">");
		sb.append("</div>");
		//--------------------------------------------------------------------
		
		//Top links
		//--------------------------------------------------------------------
		sb.append("<div id=\"vn_header_toprightlinks\">");
		sb.append("<div class=\"vn_header_toprightlink\">");
		sb.append("<a class=\"isnormal\"> Welcome: " + requstingUser.getName() + " | </a>");
		sb.append("<a class=\"isbold\" href=\"LoginServlet?action=logout\">Log off</a>");
		sb.append("</div>");
		
		sb.append("</div>");
		//--------------------------------------------------------------------
						
		sb.append("</div>");
		//--------------------------------------------------------------------
		sb.append("<div class=\"clearboth\"></div>");
		
		return sb;	
	}
	
	public static String GetConferenceDetailsUrl(String confName)
	{
		return "conferenceDetails.jsp?conferenceName=" + confName;
	}
	
	public static String GetUserDetailsUrl(String userId)
	{
		return "userDetails.jsp?userId=" + userId;
	}
	
}
