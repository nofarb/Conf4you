<%@page import="model.*"%>
<%@page import="daos.CompanyDao"%>
<%@page import="model.Company"%>
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
<link type="text/css" href="css/main.css" rel="stylesheet" />
<link type="text/css" href="css/tables/tableList.css" rel="stylesheet" />
<link type="text/css" href="css/cupertino/jquery-ui-1.8.18.custom.css"
	rel="stylesheet" />
<script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.18.custom.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	 $('#filterSelect').change(function () {
		 var selectedFilter = $("#filterSelect").val();
		 window.location.href = "company.jsp?filter=" + selectedFilter; 
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

<%= UiHelpers.GetHeader().toString() %>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_COMPANIES).toString() %>

<div id="content">
	<div class="pageTitle">
	<div class="titleMain ">Companies</div>
	<br/>
	<div style="clear:both;"></div>
	<div class="titleSeparator"></div>
	<div class="titleSub">manage, view details and add new companies</div>
	</div>

	<div id="vn_mainbody">
	<div class="vn_tblheadzone buttons">
		<div class="buttons">
			<a id="createNewCompany" href="companyAddEdit.jsp?action=add">
			<span></span>
			<img src="/conf4u/resources/imgs/vn_action_add.png">
			Add Company
			</a>
		</div>
		
		<div class="selectedFilter" style="display:none;"><%=request.getParameter("filter")%></div>
		<span id="vn_mainbody_filter">
			Show Type: 	
			<select id="filterSelect">
			<%
				//List<Location> locations = LocationDao.getInstance().getLocations();
								
				//for (Location location : locations) {
				for (CompanyType companyType : CompanyType.values()) {%>
					<option value="<%=companyType.toString()%>"><%=companyType.toString()%></option>
				<%} %>
				<!-- <option value="LAST7DAYS">Last Week</option> -->
				<!-- <option value="LAST30DAYS">Last Month</option> -->
				<!-- <option value="LAST90DAYS">Last 3 Months</option> -->
				<option value="ALL" selected="selected">All Types</option>
			</select>
		</span>
	</div>
	
	
	<div>
	<div class="groupedList">
	<table cellpadding="0" cellspacing="0" border="0" id="table1"
		class="sortable">
		<thead>
			<tr>
				<th><h3>Name</h3></th>
				<th><h3>Type</h3></th>
				<th class="nosort"><h3>Details</h3></th>
			</tr>
		</thead>
		<tbody>
			<% 
			String filter = request.getParameter("filter");
			//ConferencePreDefinedFilter filterEnum = ConferencePreDefinedFilter.ALL;
			List <Company> companyList = null;
			if (filter != null && !filter.equalsIgnoreCase("ALL"))
			{
				try
				{
					//filterEnum = ConferenceFilters.ConferencePreDefinedFilter.valueOf(filter);
					CompanyType compType = CompanyType.valueOf(filter);
					companyList =  CompanyDao.getInstance().getCompaniesOfType(compType);
					
				}
				catch (Exception e)
				{
					//PASS
				}
			}
			else
			{
				companyList = CompanyDao.getInstance().getAllCompanies();
			}
			//List <Conference> conferences = ConferenceDao.getInstance().getConferences(filterEnum);
			
		
			// Print each application in a single row
			for (Company company : companyList )
			{
			%>
			<tr class="gridRow">
				<td><%=company.getName()%></td>
				<td><%=company.getCompanyType()%></td>
				<td><a class="vn_boldtext" href="companyDetails.jsp?companyName=<%=company.getName()%>">
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