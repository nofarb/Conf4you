<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title> Monitoring Web Applications </title>
	<link href = "WebAppStyle.css" rel="stylesheet"> 
</head>

<script>

	// Check if resource name is JSP
	function isJspResourceName(resourceName)
	{
		var resourceNameAsString = new String(resourceName);
		
		return resourceNameAsString.match(".jsp$") ? true : false;
	}

	// This function creats an AJAX object
	function getXmlHttpObject()
	{ 
		var xmlHttpObject = null;

		try {
			xmlHttpObject = new ActiveXObject("Microsoft.XMLHTTP");
		} 
		
		catch(e) {
			
			try {
				xmlHttpObject = new XMLHttpRequest();
			} 
			
			catch (e) {
				
				try {
					xmlHttpObject = new ActiveXObject("Msxml2.XMLHTTP");
				} 
				
				catch (e2) {
					xmlHttpObject = null;
				}
			}
		}

		return xmlHttpObject;
	}

	function updateResourceTableDataInfoByMethod(methodType, methodResourceInfo, tableNumber)
	{
		var methodTypeLowerCase = new String(methodType).toLocaleLowerCase();
		var resounceName = methodResourceInfo.childNodes[0].text;
		var avgResponseTimeCol = document.getElementById(methodTypeLowerCase + "AvgResponseTimeCol_" + tableNumber);
		var reqPerMinCol = document.getElementById(methodTypeLowerCase + "ReqPerMinCol_" + tableNumber);
		
		avgResponseTimeCol.innerHTML = methodResourceInfo.childNodes[2].text;
		reqPerMinCol.innerHTML  = methodResourceInfo.childNodes[3].text;
		
		if ( !isJspResourceName(resounceName) ) {
			var avgBytesPerMinCol = document.getElementById(methodTypeLowerCase + "AvgBytesPerMinCol_" + tableNumber);
			
			avgBytesPerMinCol.innerHTML = methodResourceInfo.childNodes[4].text;
		}
		
	}
	
	function updateResourceTableDataInfoByMethod(xmlDoc, tableNumber, rowIndex)
	{
		
		
	}
	
	
	function updateResourceTableDataInfo(xmlDoc, tableNumber)
    {	
		var tableObj = document.getElementById("ServletTable_" + tableNumber);
		var tableRows = tableObj.rows;
		
		var resounceName = xmlDoc.getElementsByTagName('Name')[0].childNodes[0].nodeValue;
		
		tableRows[1].cells[1].innerHTML = xmlDoc.getElementsByTagName('AverageResponseTime')[0].childNodes[0].nodeValue;;
		tableRows[2].cells[1].innerHTML = xmlDoc.getElementsByTagName('AverageResponseTime')[1].childNodes[0].nodeValue;;
		tableRows[1].cells[2].innerHTML  = xmlDoc.getElementsByTagName('RequestPerMinute')[0].childNodes[0].nodeValue;;
		tableRows[2].cells[2].innerHTML  = xmlDoc.getElementsByTagName('RequestPerMinute')[1].childNodes[0].nodeValue;;
		
		if ( !isJspResourceName(resounceName) ) {
			tableRows[1].cells[3].innerHTML = xmlDoc.getElementsByTagName('AverageBytesPerMinute')[0].childNodes[0].nodeValue;;
			tableRows[2].cells[3].innerHTML = xmlDoc.getElementsByTagName('AverageBytesPerMinute')[1].childNodes[0].nodeValue;;
		}
 	}

	
	function sendResourceUpdateRequest(tableNumber)
	{
		var ajaxRequestObj = null;
		var servletNameToMonitor = null;
		
		ajaxRequestObj = getXmlHttpObject();
		if ( !ajaxRequestObj ) {
			alert("Failed to initiate AJAX");
			return;
		}
		
		// Get Servlet resource name from hidden field
		servletNameToMonitor = document.getElementById("SevletName_" + tableNumber).value;
		
		// Start request
		ajaxRequestObj.open("GET","ServletMonitor.monitor?ServletName=" + servletNameToMonitor);
			
		// Create async response callback
		ajaxRequestObj.onreadystatechange = function()
		{	
			if (ajaxRequestObj.readyState == 4 && ajaxRequestObj.status == 200)
			{		
				var xmlDoc = ajaxRequestObj.responseXML;
				
				updateResourceTableDataInfo(xmlDoc, tableNumber);
			}
		}
			
		ajaxRequestObj.send(null);
	}

	function getResourceDataAsync(numberOfServlets)
	{	
		for(var i = 0; i < numberOfServlets; i++)
		{
			sendResourceUpdateRequest(i);
		}
		
		// Reschedule next update in 10 seconds (10000 milliseconds)
		setTimeout("getResourceDataAsync(" + numberOfServlets + ")", 10000);
	}

</script>

<%!
	// This function check is the resource is a JSP resource. 
	// If so it's return 'true'.
	public boolean isJspResource(String resourceName) 
	{
		if ( resourceName.toLowerCase().endsWith(".jsp") ) {
			// JSP resource
			return true;
		}
		else {
			// No JSP resource
			return false;
		}
	}
%>

<%
	// Get selected servelt / jsp resources values
	String[] monitoringServletArray = (String[])request.getParameterValues("ServletCheckbox[]"); 
%>

<body onload=getResourceDataAsync(<%=monitoringServletArray.length%>)>

	<center> <h1> Servlet Monitor </h1> </center>
	
	<%   
		String currentMonitoringServlet = null;
		boolean isCurrentMonitoringServletJspResource;
	
		for (int monitoringServletIndex = 0; monitoringServletIndex < monitoringServletArray.length; monitoringServletIndex++)       
		{
			currentMonitoringServlet = monitoringServletArray[monitoringServletIndex];
			
			// Figure if the current resource is JSP
			isCurrentMonitoringServletJspResource = isJspResource(currentMonitoringServlet);
	%>
		<table id=ServletTable_<%=monitoringServletIndex%>>
			
			<caption> <%=currentMonitoringServlet%> </caption>
			
			<tr>
				<th width="15%"> Method </th>
				<th> Average Response Time </th>
				<th> Requests Per Minute </th>
				
			<% 
				// We dont show average bytes for JSP resources
				if (!isCurrentMonitoringServletJspResource) { %>
					<th> Average Bytes Per Minute</th>
			<%	} %>
			</tr>
			
			<tr>
				<th> GET </th>
				<td id="getAvgResponseTimeCol_<%=monitoringServletIndex%>"> N/A </td>
				<td id="getReqPerMinCol_<%=monitoringServletIndex%>"> N/A </td>
				<% 
				// We dont show average bytes for JSP resources
				if (!isCurrentMonitoringServletJspResource) { %>
					<td id="getAvgBytesPerMinCol_<%=monitoringServletIndex%>"> N/A </td>
				<%	} %>
			</tr>
			
			<tr>
				<th> POST </th>
				<td id="postAvgResponseTimeCol_<%=monitoringServletIndex%>"> N/A </td>
				<td id="postReqPerMinCol_<%=monitoringServletIndex%>"> N/A </td>
				
				<% 
				// We dont show average bytes for JSP resources
				if (!isCurrentMonitoringServletJspResource) { %>
					<td id="postAvgBytesPerMinCol_<%=monitoringServletIndex%>"> N/A </td>
				<%	} %>
			</tr>
			
			<input type="hidden" id = SevletName_<%=monitoringServletIndex%> value = "<%=currentMonitoringServlet%>" />
		
		</table>
		
		<br>
	<%	
		}
	%>

</body>
</html>