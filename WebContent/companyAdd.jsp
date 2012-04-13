<%@page import="model.CompanyType"%>
<%@page import="model.Conference"%>
<%@page import="model.Location"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.LocationDao"%>
<%@page import="daos.UserDao"%>
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
	$( ".datepicker" ).datepicker();
});

</script>

</head>

<body>
<div class="pageTitle">
<div class="titleMain ">Add company</div>
<div style="clear:both;"></div>
<div class="titleSeparator"></div>
<div class="titleSub">Add a new company</div>
</div>
<div id="vn_mainbody">
<div class="formtable_wrapper">
<form method="post" action="companyAdd.jsp">
<table class="formtable" cellspacing="0" cellpadding="0" border="0">
	<thead>
		<tr>
		<th class="header" colspan="2">
		<strong>Create a new company</strong>
		<br>
		</th>
		</tr>
	</thead>
	<tbody>
	<tr>
		<td class="labelcell required">
			<label for="compName">
			Company name:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<input id="compName" type="text" value="" name="compName">
			<div></div>
		</td>
	</tr>
		<tr>
		<td class="labelcell required">
			<label for="compName">
			Company name:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<input id="compName" type="text" value="" name="compName">
			<div></div>
		</td>
	</tr>
	<tr>
		<td class="labelcell required">
			<label for="Type">
			Type:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<select id="types" class="type rdOnlyOnEdit" name="types">
			
			<%
			//List<Location> locations = LocationDao.getInstance().getLocations();
			
			for(CompanyType type : CompanyType.values() )
			{
			%>
				<option value="<%=type.name()%>" selected="selected"><%=type.name()%></option>
			<%	} %>
			</select>
			<div></div>
			</td>
	</tr>
	
	<tr>
	<td></td>
		<td class="inputcell">
			<div class="buttons">
				<button id="createButton" type="submit">
				<img class="img_png" width="16" height="16" alt="" src="/conf4u/resources/imgs/table_save.png">
				Create
				</button>
				<button id="cancelButton" type="button" onClick="history.back()">
				<img class="img_png" width="16" height="16" alt="" src="/conf4u/resources/imgs/cancel.png">
				Cancel
				</button>
			</div>
		</td>
	</tr>
	</tbody>
</table>
</form>
</div>
<div class="clearboth"></div>
</div>
	
</body>
</html>