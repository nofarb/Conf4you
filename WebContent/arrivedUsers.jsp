<%@page import="daos.ConferencesParticipantsDao"%>
<%@ page language="java" contentType="text/html; charset=windows-1255"
	pageEncoding="windows-1255"%>
<%@page import="utils.*"%>
<%@page import="model.*"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="daos.ConferencesUsersDao"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.UserDao"%>
<%@page import="org.apache.commons.lang3.time.DateUtils"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1255">
<title>Reports</title>
<%= UiHelpers.GetAllJsAndCss().toString() %>
</head>

<% User viewingUser = SessionUtils.getUser(request); %>
<% 
//If user got to not allowed page
String retUrl = (String)getServletContext().getAttribute("retUrl");
if (!viewingUser.isAdmin())
{
	if (ConferencesUsersDao.getInstance().getUserHighestRole(viewingUser) == null || ConferencesUsersDao.getInstance().getUserHighestRole(viewingUser).getValue() < UserRole.CONF_MNGR.getValue())
		response.sendRedirect(retUrl);
}
getServletContext().setAttribute("retUrl", request.getRequestURL().toString());
%>

<%= UiHelpers.GetHeader(viewingUser).toString() %>
<%= UiHelpers.GetTabs(viewingUser, ProjConst.TAB_REPORTS).toString() %>

<script type="text/javascript">

$(document).ready(function(){
	
	
});

</script>

<body>
			<% 
			
			String dateStr = request.getParameter("date");
			Date date = new SimpleDateFormat("dd-MM-yyyy").parse(dateStr);
			String confId = request.getParameter("confId");
			Conference conf = ConferenceDao.getInstance().getConferenceById(new Long(confId.trim()));
			List<User> usersList = ConferencesParticipantsDao.getInstance().getUsersThatArrivedToConferenceInDate(conf, date);
					
			%>
<div id="body_wrap">

		<div id="content">
			<div class="pageTitle">
				<div class="titleMain ">Report for conference : <%=conf.getName()%> </div>
				<br />
				<div style="clear: both;"></div>
				<div class="titleSeparator"></div>
				<div class="titleSub">Users That arrived on date: <%=dateStr%> </div>
			</div>

			<div id="vn_mainbody">
			

					<div>
					<div class="groupedList">
					<table cellpadding="0" cellspacing="0" border="0" id="table1"
						class="sortable">
						<thead>
							<tr>
								<th><h3>User Name</h3></th>
								<th><h3>Name</h3></th>
								<th><h3>Phone 1</h3></th>
								<th><h3>Phone 2</h3></th>
								<th><h3>Email</h3></th>
								<th><h3>Company</h3></th>
								<th><h3>Last Access</h3></th>
								<th class="nosort"><h3>Details</h3></th>
							</tr>
						</thead>
						<tbody>
					<% 	
					String newsDate;

					for (User user : usersList )
					{
						Date lastLoginDate = user.getLastLogin();
						if(lastLoginDate != null){
							newsDate = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss aaa").format(lastLoginDate);
						}else{
							newsDate = "";
						}
					%>
					<tr class="gridRow">
						<td><%=user.getUserName()%></td>
						<td><%=user.getName()%></td>
						<td><%=user.getPhone1()%></td>
						<td><%=user.getPhone2()%></td>
						<td><a style="color: blue;" href="mailto:<%=user.getEmail()%>"><%=user.getEmail()%></a></td>
						<td><%=user.getCompany().getName()%></td>
						<td><%=newsDate%></td>
						<td><a class="vn_boldtext"href="userDetails.jsp?userId=<%=user.getUserId()%>"> <img src="/conf4u/resources/imgs/vn_world.png" alt=""> Details </a> </td>
					</tr>
					<%	} %>
				</tbody>
			</table>
			
	
	<div id="controls">
		<div id="perpage">
			<select onchange="sorter.size(this.value)">
				<option value="5">5</option>
				<option value="10" selected="selected">10</option>
				<option value="20">20</option>
				<option value="50">50</option>
				<option value="100">100</option>
			</select> <span>Entries Per Page</span>
		</div>
		<div id="navigation">
			<img src="css/tables/images/first.gif" width="16" height="16"
				alt="First Page" onclick="sorter.move(-1,true)" /> <img
				src="css/tables/images/previous.gif" width="16" height="16"
				alt="First Page" onclick="sorter.move(-1)" /> <img
				src="css/tables/images/next.gif" width="16" height="16"
				alt="First Page" onclick="sorter.move(1)" /> <img
				src="css/tables/images/last.gif" width="16" height="16"
				alt="Last Page" onclick="sorter.move(1,true)" />
		</div>
		<div id="text">
			Displaying Page <span id="currentpage"></span> of <span
				id="pagelimit"></span>
		</div>
	</div>
	<script type="text/javascript" src="js/tables/script.js"></script>
	<script type="text/javascript">
		var sorter = new TINY.table.sorter("sorter");
		sorter.head = "head";
		sorter.asc = "asc";
		sorter.desc = "desc";
		sorter.even = "evenrow";
		sorter.odd = "oddrow";
		sorter.evensel = "evenselected";
		sorter.oddsel = "oddselected";
		sorter.paginate = true;
		sorter.currentid = "currentpage";
		sorter.limitid = "pagelimit";
		sorter.init("table1", 1);
	</script>	
	
			
			</div>
		</div>
	</div>
		</div>
	</div>
			</div>
	</div>
</body>
</html>