<%@ page language="java" contentType="text/html; charset=windows-1255"
    pageEncoding="windows-1255"%>
    <%@page import="utils.*"%>
    <%@page import="model.*"%>
    <%@page import="java.util.LinkedList"%>
    <%@ page import="java.util.Date"%>
    <%@ page import="java.util.List"%>
   <%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
   <%@ page import="java.text.SimpleDateFormat"%>
    <%@page import="daos.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1255">
<title>Insert title here</title>
</head>

<%= UiHelpers.GetAllJsAndCss().toString() %>
<%= UiHelpers.GetHeader(SessionUtils.getUser(request)).toString() %>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_REPORTS).toString() %>

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
			
			 var selectedFilterVal = $("#confSumFilter").val();
			 window.location.href = "reports.jsp?filterNum=2&filterBy=" + selectedFilterVal; 
			
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
				$('#filter2').prop('checked',true);
				var filterBy = "<%=request.getParameter("filterBy")%>";
				$("#confSumFilter option[value="+filterBy+"]").attr('selected', 'selected');
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
											List<Conference> confrences = ConferenceDao.getInstance().getConferences(ConferencePreDefinedFilter.ALL);
											for(Conference conf : confrences){
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
												<option selected="selected" value="active">Active Users</option>
												<option value="nonActive">Non Active Users</option>
												<option value="admin">Admin Users</option>
												<option value="all">All Users</option>
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
				}

			}else{ //filter is null
				
			}
			%>
	
	
	
	
	
	
			
			</div>
		</div>
	</div>

</body>
</html>