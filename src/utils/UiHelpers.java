package utils;

import daos.ConferenceDao;
import model.User;

public class UiHelpers {

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
		
		if (requstingUser.isAdmin() || ConferenceDao.getInstance().getUserHighestRole(requstingUser).getValue() >= 3)
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
		
		if (requstingUser.isAdmin() || ConferenceDao.getInstance().getUserHighestRole(requstingUser).getValue() >= 3)
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
		
		if (requstingUser.isAdmin() || ConferenceDao.getInstance().getUserHighestRole(requstingUser).getValue() >= 3)
		{
			//Companies tab
			//--------------------------------------------------------------------
			sb.append(String.format("<li%s>", ProjConst.TAB_COMPANIES == chosenTab ? " class=\"focuslink\"" : ""));
			sb.append("<a href=\"companyList.jsp\">");
			sb.append("<span>Companies</span>");
			sb.append("</a>");
			sb.append("</li>");
			//--------------------------------------------------------------------
		}
		
		if (requstingUser.isAdmin() || ConferenceDao.getInstance().getUserHighestRole(requstingUser).getValue() >= 3)
		{
			//Locations tab
			//--------------------------------------------------------------------
			sb.append(String.format("<li%s>", ProjConst.TAB_LOCATIONS == chosenTab ? " class=\"focuslink\"" : ""));
			sb.append("<a href=\"Location.jsp\">");
			sb.append("<span>Locations</span>");
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
}
