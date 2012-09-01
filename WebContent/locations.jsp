<%@page import="model.*"%>
<%@page import="daos.LocationDao"%>
<%@page import="model.Location"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.UserDao"%>
<%@page import="helpers.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%= UiHelpers.GetAllJsAndCss().toString() %>
<script type="text/javascript">
$(document).ready(function()
{
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
	
	$('input#search').quicksearch('table#table1 tbody tr');
	
	$('#filterSelect').change(function ()
	{
		var selectedFilter = $("#filterSelect").val();
	 	window.location.href = "location.jsp?filter=" + selectedFilter; 
	});
	
	var selectedFilter = $('.selectedFilter').text();
	if (selectedFilter != null && selectedFilter.length != 0)
	{
		 $("#filterSelect option[value='" + selectedFilter + "']").attr('selected', 'selected');
	}
	
	 $("#exportToExcel").downloadify({
	 	    filename:  "LocationsTable.csv",
				data: function(){
					return $('#table1').table2CSV({delivery:'value'});
				},
	 	    onComplete: function(){ 
	 	    	jSuccess('Locations table successfully exported'); 
	 	    },
	 	    onCancel:function(){ 
	 	    	jNotify('Export to excel canceled'); 
	 	    },
	 	    transparent: false,
	 	    swf: '/conf4u/resources/imgs/downloadify.swf',
	 	    downloadImage: '/conf4u/resources/imgs/excel.gif',
	 	    width: 100,
	 	    height: 30,
	 	    transparent: true,
	 	    append: false
 	  });
	 
	 //perform only if the class "evenrow" exists
	 if ($(".evenrow")[0]){
		 sorter.size(10);
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
	response.sendRedirect(retUrl);

getServletContext().setAttribute("retUrl", request.getRequestURL().toString());
%>
<%= UiHelpers.GetHeader(SessionUtils.getUser(request)).toString()%>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_LOCATIONS).toString() %>

<div id="content">
	<div class="pageTitle">
	<div class="titleMain ">Locations</div>
	<br/>
	<div style="clear:both;"></div>
	<div class="titleSeparator"></div>
	<div class="titleSub">manage, view details and add new locations</div>
	</div>

	<div id="vn_mainbody">
	<div class="vn_tblheadzone buttons">
		<% if (viewingUser.isAdmin()) {%>
		<div class="buttons">
			<a id="createNewLocation" href="locationAddEdit.jsp?action=add">
			<span></span>
			<img src="/conf4u/resources/imgs/add.png">
			Add Location
			</a>
		</div>
		<%} %>
		<span id="vn_mainbody_filter">
			Search:
   			<input type="text" id="search">
   			<span id="exportToExcel" style="vertical-align:-10px;">
				You must have Flash 10 installed to download this file.
			</span>
		</span>
	</div>
	
	
	<div>
	<div class="groupedList">
	<table cellpadding="0" cellspacing="0" border="0" id="table1"
		class="sortable">
		<thead>
			<tr>
				<th><h3>Name</h3></th>
				<th><h3>Address</h3></th>
				<th><h3>Max Capacity</h3></th>
				<th><h3>Contact name</h3></th>
				<th><h3>Phone 1</h3></th>
				<th><h3>Phone 2</h3></th>
				<th class="nosort"></th>
			</tr>
		</thead>
		<tbody>
			<%
			
			List <Location> locations = LocationDao.getInstance().getLocations();
		
			// Print each application in a single row
			for (Location location : locations )
			{
			%>
			<tr class="gridRow">
				<td><%=location.getName()%></td>
				<td><%=location.getAddress()%></td>
				<td><%=location.getMaxCapacity()%></td>
				<td><%=location.getContactName()%></td>
				<td><%=location.getPhone1()%></td>
				<td><%=location.getPhone2()%></td>
				<td><a class="vn_boldtext" href="LocationDetails.jsp?locName=<%=location.getName()%>">
				<img src="/conf4u/resources/imgs/details.png" alt="">
				Details
				</a>
				</td>
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
		sorter.init("table1", 0);
	</script>
</div>
</div>
</div>
</div>
</div>
</body>
</html>