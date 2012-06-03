<%@page import="model.*"%>
<%@page import="daos.LocationDao"%>
<%@page import="model.Location"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.UserDao"%>
<%@page import="utils.*"%>
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
});
</script>
<body>
<div id="body_wrap">

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
		<div class="buttons">
			<a id="createNewLocation" href="locationAddEdit.jsp?action=add">
			<span></span>
			<img src="/conf4u/resources/imgs/vn_action_add.png">
			Add Location
			</a>
		</div>
		<!-- 
		<div class="selectedFilter" style="display:none;"><%=request.getParameter("filter")%></div>
		<span id="vn_mainbody_filter">
			Show: 	
			<select id="filterSelect">
				<option value="LAST7DAYS">Last Week</option>
				<option value="LAST30DAYS">Last Month</option>
				<option value="LAST90DAYS">Last 3 Months</option>
				<option value="ALL" selected="selected">Ever</option>
			</select>
		</span>
		 -->
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
				<th class="nosort"><h3>Details</h3></th>
			</tr>
		</thead>
		<tbody>
			<%/* 
			String filter = request.getParameter("filter");
			ConferencePreDefinedFilter filterEnum = ConferencePreDefinedFilter.ALL;
			if (filter != null)
			{
				try
				{
					filterEnum = ConferenceFilters.ConferencePreDefinedFilter.valueOf(filter);
				}
				catch (Exception e)
				{
					//PASS
				}
			}*/
			
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
				<img src="/conf4u/resources/imgs/vn_world.png" alt="">
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
		sorter.init("table1", 1);
	</script>
</div>
</div>
</div>
</div>
</div>
</body>
</html>