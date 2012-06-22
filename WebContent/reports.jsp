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
	
	$('#apply').click(function () {
		
		var filterRadio = $('input[name=reportsFilter]');
		var checkedValue = filterRadio.filter(':checked').val();
		
		if(checkedValue == "filter2"){
			
			 var selectedConfId = $("#confSumFilter").val();
			 window.location.href = "reports.jsp?filterNum=2&confId="+selectedConfId; 
			
		}else{ //fiter1
			 
			 var selectedRole = $("#roleFilter").val();
			 var selectedConfId = $("#confFilter").val();
			 window.location.href = "reports.jsp?filterNum=1&role=" + selectedRole+"&confId="+selectedConfId; 
		 
		}
			
	 });
	
	
	$('#filterTableRow1').click(function () {
		
		$('#filter1').prop('checked',true);
			
	 });
	
	$('#filterTableRow2').click(function () {
		
		$('#filter2').prop('checked',true);
				
	});

	<%
		String filterNum = request.getParameter("filterNum");
		if(filterNum != null){
			if(filterNum.trim().equals("2")){
	%>
				var confIdstr = "<%=request.getParameter("confId")%>";

				$('#filter2').prop('checked',true);
				$("#confSumFilter option[value="+confIdstr+"]").attr('selected', 'selected');

	<%
			}else{ // filter 2
	%>
				var role = "<%=request.getParameter("role")%>";
				var confIdstr = "<%=request.getParameter("confId")%>";

 				$('#filter1').prop('checked',true);
				$("#confFilter option[value="+confIdstr+"]").attr('selected', 'selected');
				$("#roleFilter option[value="+role+"]").attr('selected', 'selected');
	<%

			}
		}
	%>

	 
});

</script>

<body>
<div id="body_wrap">

		<div id="content">
			<div class="pageTitle">
				<div class="titleMain ">Reports</div>
				<br />
				<div style="clear: both;"></div>
				<div class="titleSeparator"></div>
				<div class="titleSub">View custom reports</div>
			</div>

			<div id="vn_mainbody">
			
		<!-- Filter start 
	--------------------------------------->			
				<table class="filtersAndApllyTable">
					<tr>
						<td>
							<table class="filtersTable" >
								<tr id="filterTableRow1">
									<td>
										<input type="radio"  id="filter1" name="reportsFilter" value="filter1"  checked /> 
									</td>
									<td> User Role:
										<select id="roleFilter">
												<option value="PARTICIPANT">Participant</option>
												<option value="SPEAKER">Speaker</option>
												<option value="RECEPTIONIST">Receptionist</option>
												<option value="CONF_MNGR">Conference Manager</option>
										</select> 
										in Conference:
										<select id="confFilter">
										<%
										
										List <Conference> conferences = new LinkedList<Conference>();
										if (viewingUser.isAdmin())
										{
											conferences = ConferenceDao.getInstance().getConferences(ConferencePreDefinedFilter.ALL);
										}
										else
										{
											conferences = ConferencesUsersDao.getInstance().getAllActiveConferencesOfUserByUserType(viewingUser, UserRole.CONF_MNGR);
										}
											for(Conference conf : conferences){
										%>
											 	<option value="<%=conf.getConferenceId()%>" > <%=conf.getName()%> </option>
										<%
											}
										%>
										</select>
									</td>
								</tr>
								<tr id="filterTableRow2">
									<td>
										<input type="radio" id="filter2" name="reportsFilter" value="filter2"/> 
									</td>
									<td>
										<select id="confSumFilter">
										<%
											for(Conference conf : conferences){
										%>
											 	<option value="<%=conf.getConferenceId()%>" > <%=conf.getName()%> </option>
										<%
											}
										%>
										</select>
									</td>
								</tr>
							</table>
						</td>
						<td>
							<div class="buttons">
								<a id="apply"> 
									<img src="/conf4u/resources/imgs/yes_green.png"> Apply
								</a>
							</div>
						</td>
					</tr>
				</table>

		
	<!-- Filter end 
	--------------------------------------->	
	
			<% 

			List <User> usersList = new LinkedList <User>();
			
			String filterNumber = request.getParameter("filterNum");
			if(filterNumber != null){
				if(filterNumber.trim().equals("1")){
					String confIdStr = request.getParameter("confId");
					String roleStr = request.getParameter("role");
					
					if(confIdStr == null || roleStr == null){
						usersList = UserDao.getInstance().getActiveUsers();
					}
					else{
						Long confId = Long.valueOf(confIdStr.trim());
						Conference conf = ConferenceDao.getInstance().getConferenceById(confId);
						UserRole role = UserRole.valueOf(roleStr.trim());
						usersList = ConferencesUsersDao.getInstance().getUsersForRoleInConference(conf, role);		
					}
					
					%>
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
						Date date = user.getLastLogin();
						if(date != null){
							newsDate = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss aaa").format(date);
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
			
			<%
				}else{ //filter 2
					
					%>
					<div>
					<div class="groupedList">
					<table cellpadding="0" cellspacing="0" border="0" id="table1"
						class="sortable">
						<thead>
							<tr>
								<th><h3>Date</h3></th>
								<th><h3>Invited</h3></th>
								<th><h3>Approved</h3></th>
								<th><h3>Arrived</h3></th>
							</tr>
						</thead>
						<tbody>
					<% 	
		
					String confIdStr = request.getParameter("confId");
					Long confId = new Long(confIdStr.trim());
					Conference conf = ConferenceDao.getInstance().getConferenceById(confId);
					int invited = ConferencesUsersDao.getInstance().getCountOfUsersInConferenceWithRole(conf, UserRole.PARTICIPANT);
					
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
					
					int approved = ConferencesUsersDao.getInstance().getNumOfUsersInAttendanceStatusInConference(conf, UserAttendanceStatus.APPROVED);
							
					while(start.before(end) || start.equals(end)){
						String dateToPresent = new SimpleDateFormat("dd-MM-yyyy").format(start);
						int arrived = ConferencesParticipantsDao.getInstance().getNumberOfUsersThatArrivedToConferenceInDate(conf, start);

						 %>	
							<tr class="gridRow">
								<td><%=dateToPresent%></td>
								<td><%=invited%></td>
								<td><%=approved%></td>
								<td><a class="vn_boldtext"href="arrivedUsers.jsp?date=<%=dateToPresent%>&confId=<%=conf.getConferenceId()%>"> <img src="/conf4u/resources/imgs/vn_world.png" alt=""> <%=arrived%> </a> </td>
							</tr>
						 
						<% 	
						start = DateUtils.addDays(start, 1);
					} %>
						</tbody>
					</table>
				<% 	
				} 
				

			}else{ //filter is null
				
			}
			%>
	
	
	
	
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