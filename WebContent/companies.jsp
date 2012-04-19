<%@page import="daos.CompanyDao"%>
<%@page import="model.Company"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="model.User"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" href="css/main.css" rel="stylesheet" />
<link type="text/css" href="css/tables/tableList.css" rel="stylesheet" />
<link type="text/css" href="css/cupertino/jquery-ui-1.8.18.custom.css"
	rel="stylesheet" />
<script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.18.custom.min.js"></script>

<script>
	$(function() {
		$( ".addButton" ).button({
            icons: {
                primary: "ui-icon-plus"
            }
		});
		
	});
	</script>


</head>

<body>

	<p class="horizontal-line">Actions</p>

	<p class="horizontal-line">Companies</p>

<a class="addButton" href="companyAdd.jsp">Add Company</a>

	<table cellpadding="0" cellspacing="0" border="0" id="table"
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

			List <Company> companies = CompanyDao.getInstance().getAllCompanies();
		
			// Print each application in a single row
			for (Company comp : companies )
			{
		%>
			<tr>
				<td><%=comp.getName()%></td>
				<td><%=comp.getCompanyType().toString()%></td>
				<td><a class="vn_boldtext"href="companyDetails.jsp?companyId=<%=comp.getCompanyID()%>"> <img src="/conf4u/resources/imgs/vn_world.png" alt=""> Details </a> </td>
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
		sorter.init("table", 1);
	</script>

</body>
</html>