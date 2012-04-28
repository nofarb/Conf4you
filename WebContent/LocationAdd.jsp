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
<div class="titleMain ">Add location</div>
<div style="clear:both;"></div>
<div class="titleSeparator"></div>
<div class="titleSub">Add a new location</div>
</div>
<div id="vn_mainbody">
<div class="formtable_wrapper">
<form method="post" action="LocationAdd.jsp">
<table class="formtable" cellspacing="0" cellpadding="0" border="0">
	<thead>
		<tr>
		<th class="header" colspan="2">
		<strong>Create a new location</strong>
		<br>
		</th>
		</tr>
	</thead>
	<tbody>
	<tr>
		<td class="labelcell required">
			<label for="locName">
			Location name:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<input id="locName" type="text" value="" name="locName">
			<div></div>
		</td>
	</tr>
		
		<tr>
		<td class="labelcell required">
			<label for="LocAdd">
			Address:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<input id="LocAdd" type="text" value="" name="LocAdd">
			<div></div>
		</td>
	</tr>
	<tr>
		<td class="labelcell required">
			<label for="MaxCap">
			Max Capacity:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<input id="MaxCap" type="text" value="" name="MaxCap">
			<div></div>
		</td>
	</tr>
	<tr>
		<td class="labelcell required">
			<label for="ContName">
			Contact Name:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<input id="ContName" type="text" value="" name="ContName">
			<div></div>
		</td>
	</tr>
	<tr>
		<td class="labelcell required">
			<label for="Ph1">
			Phone1:
			<span class="required_star"> *</span>
			</label>
		</td>
			<td class="inputcell">
			<input id="Ph1" type="text" value="" name="Ph1">
			<div></div>
		</td>
	</tr>
	
	<tr>
		<td class="labelcell required">
			<label for="Ph2">
			Phone2:			
			</label>
		</td>
			<td class="inputcell">
			<input id="Ph2" type="text" value="" name="Ph2">
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