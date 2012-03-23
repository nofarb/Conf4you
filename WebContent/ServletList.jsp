<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<% String ApplicationName = (String)request.getAttribute("ApplicationName"); %>
<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title> Selecting Servlet and JSP pages to monitor ( Application: <%=ApplicationName%> ) </title>
	<link href = "WebAppStyle.css" rel="stylesheet"> 
</head>

<script>

	function isSomeCheckboxMonitorChecked(checkboxArray)
	{
		for( var i = 0; i < checkboxArray.length; i++) {
			if ( checkboxArray[i].checked ) {
				return true;
			}
		}
		
		return false;
	}
	
	function sumbitValidation( )
	{	
		var startMonitorButton = null;
		var monitorCheckboxArray = null;
		
		// Get Submit button
		startMonitorButton = document.getElementById('StartMonitorButton');
		
		// Get monitor checkbox array button
		monitorCheckboxArray = document.getElementsByName('ServletCheckbox[]');
		
		// If CheckedCounter == 0, disable submit button
		startMonitorButton.disabled = isSomeCheckboxMonitorChecked(monitorCheckboxArray) ? false : true; 
	}

</script>

<body onload=sumbitValidation()>

	<center> <h1> Monitoring Web Applications </h1> </center>
			
	<br>

	<form id = "servletForm" method="post" action="ServletMonitor.jsp">

		<table id = "servletTable">
	
			<caption> Servlet / JSP of <%=ApplicationName%> </caption>
	
			<tr>
				<th> Servlet / JSP </th>
				<th> Monitor ? </th>
			</tr>
		
		<% 
			// Get Application List from 'ApplicationList' attribute
			List<String> servletList = (List<String>)request.getAttribute("ServletList");
	
			int servletListIndex;
		
			// Print each application in a single row
			for (servletListIndex = 0; servletListIndex < servletList.size(); servletListIndex++)
			{
				// Get current application name 
				String servletName = (String)servletList.get(servletListIndex);
		%>
				<tr>
					<td> <%=servletName%> </td>
					<td> 
						<input type="checkbox" name="ServletCheckbox[]" value="<%=servletName%>" onclick="sumbitValidation(this);" />
					</td>
				</tr>
		<%	} %>
	
			<tr> 
				<td></td>
				<td>
					<input type="submit" id="StartMonitorButton" value="Start Monitor" disabled/>  
				</td>
			</tr>
		</table>
	
	</form>

</body>
</html>