<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title> Monitoring Web Applications </title>
	<link href = "WebAppStyle.css" rel="stylesheet"> 
</head>
<body>

	<center> <h1> Monitoring Web Applications </h1> </center>
	
	<br>
	
	<h2> Applications running on the web server </h2>

	<table id = "applicationTable">
	
		<tr>
			<th> Application Name  </th>
		</tr>
		
	<% 
		// Get Application List from 'ApplicationList' attribute
		List<String> applicationsList = (List<String>)request.getAttribute("ApplicationList");
	
		int applicationListIndex;
		
		// Print each application in a single row
		for (applicationListIndex = 0; applicationListIndex < applicationsList.size(); applicationListIndex++)
		{
			// Get current application name 
			String applicationName = (String)applicationsList.get(applicationListIndex);
	%>
			<tr>
				<td>
					<a href="ServletList.monitor?ApplicationName=<%=applicationName%>"> <%=applicationName%> </a>
				</td>
			</tr>
	<%	} %>
	</table>
	
	<ul>
		<li> 
			<a href = "docs/report.pdf"> <h3> Report PDF link </h3> </a>
		</li>
	</ul>

</body>
</html>