<%@page import="java.util.LinkedList"%>
<%@page import="daos.*"%>
<%@page import="model.*"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="utils.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.commons.lang3.time.DateUtils"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%= UiHelpers.GetAllJsAndCss().toString() %>

<script type="text/javascript">
$(document).ready(function(){
	
	var message = "<%=request.getParameter("messageNotification")%>";
	if (message != "null")
	{
		var messageType = "<%=request.getParameter("messageNotificationType")%>";
		if (messageType == "success")
		{
			jSuccess(message);
		}
		else if (messageType == "error")
		{
			jError(message);
		}
		else
		{
			alert("unknown message type");
		}
	}
});
</script>
<body>
<div id="body_wrap">
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
<%= UiHelpers.GetTabs(viewingUser, ProjConst.TAB_HOME).toString() %>

<div id="content">
	<div class="pageTitle">
		<div class="titleMain titleMainNoSub">Conference highlights</div>
		<a href="<%=request.getRequestURL().toString()%>" style="float:right; padding-top: 6px; padding-right: 20px;">
			<img width="16" border="0" height="16" alt="" style="position:relative;margin-bottom:-3px" src="/conf4u/resources/imgs/refresh.png">
			Refresh
		</a>
		<div style="clear:both;"></div>
	</div>
	
<% SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy kk:mm");%>
	<div id="vn_mainbody">
	
	<div class="yui-cssreset yui-cssbase yui-cssfonts">
	<table class="homeMetaTable">
		<tbody>
			<tr>
			<td class="columnCell">
				<p> </p>
				<p> </p>
				<table class="groupedList homeGrid sortable">
				<thead>
				<tr>
					<th class="header mainHeader">
						Top five ongoing conferences statistics 
					<br>
					<%
						SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
						String today = sdf.format(new Date());
					%>
					<span class="annotation">For date <%= today %></span>
					</th>					
					<th>Invited</th>
					<th class="header scoreHeader">Approved</th>
					<th class="header scoreHeader">Arrived</th>
				</tr>
				</thead>
					<tbody>
					<% 	
					int ongoingConfereceCount = 5;
					int currentongoingCount = 1;
					List<Conference> currentConferences = ConferencesUsersDao.getInstance().getScopedConferenceByDate(viewingUser, ConferenceFilters.ConferenceTimeFilter.CURRENT.toString());
					for (Conference conf: currentConferences)
					{
						int invited = ConferencesUsersDao.getInstance().getCountOfUsersInConferenceWithRole(conf, UserRole.PARTICIPANT);
						
						Date now = new Date();
						now = DateUtils.setHours(now, 0);
						now = DateUtils.setMinutes(now, 0);
						now = DateUtils.setSeconds(now, 0);
						now = DateUtils.setMilliseconds(now, 0);
						
						String dateFormatted = new SimpleDateFormat("dd-MM-yyyy").format(now);
						
						int approved = ConferencesUsersDao.getInstance().getNumOfUsersInAttendanceStatusInConference(conf, UserAttendanceStatus.APPROVED);
							
						int arrived = ConferencesParticipantsDao.getInstance().getNumberOfUsersThatArrivedToConferenceInDate(conf, now);
						
						String confDetailsUrl = UiHelpers.GetConferenceDetailsUrl(conf.getName());
						 %>	
						 	<tr>
							<td>
							<a class="vn_boldtext" href="<%=confDetailsUrl%>"><%=conf.getName() %></a>
							</td>
							<td class="numericCell scoreCell"><%=invited %></td>
							<td class="numericCell scoreCell"><%=approved %></td>
							<td><a class="vn_boldtext" href="arrivedUsers.jsp?date=<%=dateFormatted%>&confId=<%=conf.getConferenceId()%>"><%=arrived%></a></td>
							</tr>						 
					<% 
					
						if (ongoingConfereceCount == currentongoingCount)
							break;
						currentongoingCount ++;
					} %>
					</tbody>
				</table>
				<% if (currentConferences.size() == 0) { %>
					<span>No available data</span>
				<%} %>
				<p></p>
				<p> </p>
				<table class="groupedList homeGrid sortable">
				<thead>
				<tr>
				<th class="header mainHeader">
					Top five upcoming conferences
				<br>
				<span class="annotation">Conferences in the near future</span>
				</th>
				<th class="header scoreHeader">Location</th>
				<th class="header scoreHeader">Start date</th>
				<th class="header scoreHeader">End date</th>
				</tr>
				</thead>
				<tbody>
				<%
					int futureConfereceCount = 5;
					int currentFutureCount = 1;
				
					List<Conference> futureConferences = ConferencesUsersDao.getInstance().getScopedConferenceByDate(viewingUser, ConferenceFilters.ConferenceTimeFilter.FUTURE.toString());
					for (Conference conf: futureConferences)
					{
												
						String confDetailsUrl = UiHelpers.GetConferenceDetailsUrl(conf.getName());
						String locationDetailsUrl = UiHelpers.GetLocationDetailsUrl(conf.getLocation().getName());
						String startDateFormatted =  dateFormat.format(conf.getStartDate());
						String endDateFormatted =  dateFormat.format(conf.getEndDate());
						 %>	
						 	<tr>
							<td>
								<a class="vn_boldtext" href="<%=confDetailsUrl%>"><%=conf.getName() %></a>
							</td>
							<td class="numericCell scoreCell"> <a class="vn_boldtext" href="<%=locationDetailsUrl%>"><%=conf.getLocation().getName()%></a></td>
							<td class="numericCell scoreCell"><%=startDateFormatted%></td>
							<td class="numericCell scoreCell"><%=endDateFormatted%></td>
							</tr>						 
					<% 
						
						if (futureConfereceCount == currentFutureCount)
							break;
						currentFutureCount ++;
					} %>
				</tbody>
				</table>
					<% if (futureConferences .size() == 0) { %>
						<span>No available data</span>
					<%} %>
				<p></p>
				<p></p>
			</td>
			<td class="columnCell notFirstColumn">
			<p> </p>
			<table class="groupedList homeGrid">
				<thead>
					<tr>
						<th style="padding-bottom: 35px;">Logged in users in the last 24 hours</th>
					</tr>
				</thead>
			<tbody>
			<%
				int activitiesSize = 20;
				int currentActivitiesCount = 0;
				boolean hasLoginData = false;
				
				for (Conference conf: currentConferences)
				{
					List<ConferencesUsers> conferenceUsers = ConferencesUsersDao.getInstance().getAllConferenceUsersByConferenceThatLoggedInLastHoursCount(conf, 24);
									
					for (ConferencesUsers cu: conferenceUsers)
					{
						hasLoginData = true;
						String confDetailsUrl = UiHelpers.GetConferenceDetailsUrl(cu.getConference().getName());
						String userDetailsUrl = UiHelpers.GetUserDetailsUrl(cu.getUser().getUserId());
						String loggedFormatted =  dateFormat.format(cu.getUser().getLastLogin());
							if (currentActivitiesCount < activitiesSize) {
						 %>	
						 	<tr>
							<td>
							<a class="vn_boldtext" href="<%=userDetailsUrl%>"><%=cu.getUser().getName()%></a>
							logged in on <%=loggedFormatted%>
							</td>
							</tr>	
						<%  currentActivitiesCount ++; 
						} %>	 
					<% } %>
				<% } %>
			</tbody>
			</table>
			<% if (!hasLoginData) { %>
				<span>No available data</span>
			<%} %>
			</td>
			</tr>
		</tbody>
	</table>
	</div>
</div>
</div>
</div>
</body>
</html>