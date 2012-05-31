<%@page import="model.User"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="utils.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%= UiHelpers.GetAllJsAndCss().toString() %>
<script>
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
});
</script>


</head>

<body>

<%= UiHelpers.GetHeader().toString() %>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_USERS).toString() %>

<div id="content">
<div class="pageTitle">
<div class="titleMain ">User details</div>
<div style="clear:both;"></div>
<div class="titleSeparator"></div>
<div class="titleSub">View, modify, add/remove participants for this user</div>
</div>


	<% String userId = request.getParameter("userId");
	   Long id = new Long(userId);
	   User user = UserDao.getInstance().getUserById(id);
	%>
	
<div id="detailsAndActions">

	<div class="vn_detailsgeneraltitle">Actions </div>
	<div class="vn_actionlistdiv yui-reset yui-base">
		<div class="vn_actionlistcolumn">
			<div class="vn_actionbuttondiv">
				<div class="title">
				<a title="Edit Conference" href="userAddEdit.jsp?action=edit&userId=<%=user.getUserId()%>">
					<img src="/conf4u/resources/imgs/vn_action_edit.png" alt=""> 
					Edit
				</a>
				</div>
			</div>
				<div class="vn_actionbuttondiv">
				<div class="title">
				<a title="Delete User" href="UsersServlet?action=delete&userId=<%=user.getUserId()%>">
					<img src="/conf4u/resources/imgs/vn_action_delete.png" alt=""> 
					Delete
				</a>
				</div>
			</div>
		</div>
	</div>
	<div class="vn_detailsgeneraltitle">Details </div>
	

	<div class="groupedList" style="width: 800px;">
	<table class="vn_envdetails" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
		<tbody>
			<tr>
				<td>Unique User Name</td>
				<td><%=user.getUserName()%></td>
			</tr>
			<tr>
				<td>Name</td>
				<td><%=user.getName()%></td>
			</tr>
			<tr>
				<td>Email</td>
				<td><%=user.getEmail()%></td>
			</tr>
			<tr>
				<td>ID #</td>
				<td><%=user.getPasportID()%></td>
			</tr>
			<tr>
				<td>Phone #1</td>
				<td><%=user.getPhone1()%></td>
			</tr>
			<tr>
				<td>Phone #2</td>
				<td><%=user.getPhone2()%></td>
			</tr>
			<tr>
				<td>Company Name</td>
				<td><%=user.getCompany().getName()%></td>
			</tr>
			<tr>
				<td>Company Type</td>
				<td><%=user.getCompany().getCompanyType()%></td>
			</tr>
			<tr>
				<td>Last Login</td>
			<%
				Date laseLogin = user.getLastLogin();
				if(laseLogin != null){
			%>
				<td><%=user.getLastLogin()%></td>
			<%		
				}
			%>
				
			</tr>
		</tbody>
	</table>
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
	</div>
</div>
</body>
</html>