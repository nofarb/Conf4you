<%@page import="java.util.LinkedList"%>
<%@page import="daos.ConferencesUsersDao"%>
<%@page import="model.*"%>
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
	
	 $('input#search').quicksearch('table tbody tr');
	 
	 $('#filterSelect').change(function () {
		 var selectedFilter = $("#filterSelect").val();
		 window.location.href = "conference.jsp?filter=" + selectedFilter; 
	 });
	 
	 var selectedFilter = $('.selectedFilter').text();
	 if (selectedFilter != null && selectedFilter.length != 0)
	 {
		 $("#filterSelect option[value='" + selectedFilter + "']").attr('selected', 'selected');
	 }
	 
	 $("#exportToExcel").downloadify({
 	    filename:  "ConferenceTable.csv",
			data: function(){
				return $('#table1').table2CSV({delivery:'value'});
			},
 	    onComplete: function(){ 
 	    	jSuccess('Conference table successfully exported'); 
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
	 
	 sorter.size(10);
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
<%= UiHelpers.GetTabs(viewingUser, ProjConst.TAB_CONFERENCES).toString() %>

<div id="content">
	<div class="pageTitle">
	<div class="titleMain ">Conferences</div>
	<br/>
	<div style="clear:both;"></div>
	<div class="titleSeparator"></div>
	<div class="titleSub">manage, view details and add new conferences</div>
	</div>

	<div id="vn_mainbody">
	<div class="vn_tblheadzone buttons">
		<% if (viewingUser.isAdmin()) {%>
		<div class="buttons">
			<a id="createNewConference" href="conferenceAddEdit.jsp?action=add">
			<span></span>
			<img src="/conf4u/resources/imgs/add.png">
			Add Conference
			</a>
		</div>
		<%} %>
		
		<div class="selectedFilter" style="display:none;"><%=request.getParameter("filter")%></div>
		<span id="vn_mainbody_filter">
			Search:
   			<input type="text" id="search">
   			<% if (viewingUser.isAdmin()) {%>
			Show: 	
			<select id="filterSelect">
				<option value="LAST7DAYS">Last Week</option>
				<option value="LAST30DAYS">Last Month</option>
				<option value="LAST90DAYS">Last 3 Months</option>
				<option value="ALL" selected="selected">All</option>
			</select>
			<%} %>
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
				<th><h3>Location</h3></th>
				<th><h3>Start date</h3></th>
				<th><h3>End date</h3></th>
				<th class="nosort"></th>
			</tr>
		</thead>
		<tbody>
			<% 
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
			}
			
			List <Conference> conferences = new LinkedList<Conference>();
			if (viewingUser.isAdmin())
			{
				conferences = ConferenceDao.getInstance().getConferences(filterEnum);
			}
			else
			{
				conferences = ConferencesUsersDao.getInstance().getAllActiveConferencesOfUserByUserType(viewingUser, UserRole.CONF_MNGR);
			}
			
			// Print each application in a single row
			for (Conference conference : conferences )
			{
				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm");
				String startDateFormatted = sdf.format(conference.getStartDate());
				String endDateFormatted = sdf.format(conference.getEndDate());
				String locationDetailsUrl = UiHelpers.GetLocationDetailsUrl(conference.getLocation().getName()); 
			%>
			<tr class="gridRow">
				<td><%=conference.getName()%></td>
				<td><a class="vn_boldtext" href="<%=locationDetailsUrl%>"><%=conference.getLocation().getName()%></a></td></td>
				<td><%= startDateFormatted %></td>
				<td><%= endDateFormatted %></td>
				<td><a class="vn_boldtext" href="conferenceDetails.jsp?conferenceName=<%=conference.getName()%>">
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