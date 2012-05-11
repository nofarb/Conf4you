<%@page import="model.Conference"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" href="css/main.css" rel="stylesheet" />
<link type="text/css" href="css/tables/tableList.css" rel="stylesheet" />
<link type="text/css" href="css/cupertino/jquery-ui-1.8.18.custom.css"
	rel="stylesheet" />
<script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.18.custom.min.js"></script>

<body>
<div id="body_wrap">
<div id="content">

	<div class="pageTitle">
	<div class="titleMain ">Conferences</div>
	<br/>
	<div style="clear:both;"></div>
	<div class="titleSeparator"></div>
	<div class="titleSub">manage, view details and add new conferences</div>
	</div>

	<div id="vn_mainbody">
	
	<div class="buttons">
		<a id="createNewConference" href="conferenceAdd.jsp">
		<span></span>
		<img src="/conf4u/resources/imgs/vn_action_add.png">
		Add Conference
		</a>
	</div>
	
	<div>
	<div class="groupedList">
	<table cellpadding="0" cellspacing="0" border="0" class="sortable">
		<thead>
			<tr>
				<th><h3>Name</h3></th>
				<th><h3>Location</h3></th>
				<th><h3>Start date</h3></th>
				<th><h3>End date</h3></th>
				<th class="nosort"><h3>Details</h3></th>
			</tr>
		</thead>
		<tbody>
			<% 

			List <Conference> conferences = ConferenceDao.getInstance().getConferences(ConferencePreDefinedFilter.ALL);
		
			// Print each application in a single row
			for (Conference conference : conferences )
			{
		%>
			<tr class="gridRow">
				<td><%=conference.getName()%></td>
				<td><%=conference.getLocation().getName()%></td>
				<td><%=conference.getStartDate()%></td>
				<td><%=conference.getEndDate()%></td>
				<td><a class="vn_boldtext" href="conferenceDetails.jsp?conferenceName=<%=conference.getName()%>">
				<img src="/conf4u/resources/imgs/vn_world.png" alt="">
				Details
				</a>
				</td>
			</tr>
			<%	} %>
		</tbody>
	</table>
</div>
</div>
</div>
</div>
</div>
</body>
</html>