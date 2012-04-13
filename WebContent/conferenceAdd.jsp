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
<div class="titleMain ">Add conference</div>
<div style="clear:both;"></div>
<div class="titleSeparator"></div>
<div class="titleSub">Add a new conference</div>
</div>
<div id="vn_mainbody">
<div class="formtable_wrapper">
<form method="post" action="conferenceAdd.jsp">
<table class="formtable" cellspacing="0" cellpadding="0" border="0">
	<thead>
		<tr>
		<th class="header" colspan="2">
		<strong>Create a new conference</strong>
		<br>
		</th>
		</tr>
	</thead>
	<tbody>
	<tr>
		<td class="labelcell required">
			<label for="confName">
			Conference name:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<input id="confName" type="text" value="" name="confName">
			<div></div>
		</td>
	</tr>
		<tr>
		<td class="labelcell required">
			<label for="confName">
			Conference name:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<input id="confName" type="text" value="" name="confName">
			<div></div>
		</td>
	</tr>
	<tr>
		<td class="labelcell required">
			<label for="locations">
			Locations:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<select id="locations" class="type rdOnlyOnEdit" name="locations">
			
			<%
			List<Location> locations = LocationDao.getInstance().getLocations();
		
			for(Location location : locations )
			{
			%>
				<option value="<%=location.getLocationId()%>" selected="selected"><%=location.getName()%></option>
			<%	} %>
			</select>
			<div></div>
			</td>
	</tr>
	<tr>
		<td class="labelcell required">
			<label for="startDate">
			Start date:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<input id="datepicker startDate" class="datepicker" type="text" name="startDate">
			<div></div>
		</td>
	</tr>
	<tr>
		<td class="labelcell required">
			<label for="endDate">
			End date:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<input id="datepicker endDate" class="datepicker" type="text" name="endDate">
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