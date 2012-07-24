<%@page import="model.*"%>
<%@page import="daos.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="model.User"%>
<%@page import="helpers.ProjConst"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="helpers.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%= UiHelpers.GetAllJsAndCss().toString() %>
<style type="text/css">
div.message {
	background: transparent url(/conf4u/resources/imgs/msg_arrow.gif)
		no-repeat scroll left center;
	padding-left: 7px;
}

div.error {
	background-color: #F3E6E6;
	border-color: #924949;
	border-style: solid solid solid none;
	border-width: 2px;
	padding: 4px;
}
</style>
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
	
	 $('.select_all').click(function(){
		 if (this.checked)
		 {
			 $('input:checkbox[name=userNames]:not(:checked)').each(function() {
		 	    	$(this).prop("checked", true);
		 	     });
		 }
		 else
		 {
			 $('input:checkbox[name=userNames]:checked').each(function() {
		 	    	$(this).prop("checked", false);
		 	     });
		 }
	 });

});
</script>
</head>

<body>
<% 
User viewingUser = SessionUtils.getUser(request);
//If user got to not allowed page
String retUrl = (String)getServletContext().getAttribute("retUrl");
if (!viewingUser.isAdmin())
{
	if (ConferencesUsersDao.getInstance().getUserHighestRole(viewingUser) == null || ConferencesUsersDao.getInstance().getUserHighestRole(viewingUser).getValue() < UserRole.CONF_MNGR.getValue())
		response.sendRedirect(retUrl);
}
getServletContext().setAttribute("retUrl", request.getRequestURL().toString());

Conference conf = ConferenceDao.getInstance().getConferenceByName(request.getParameter("confName"));
%>

<%= UiHelpers.GetHeader(viewingUser).toString() %>
<%= UiHelpers.GetTabs(viewingUser, ProjConst.TAB_CONFERENCES).toString() %>
<div id="content">
	<div class="pageTitle">
	<div class="titleMain ">Assign user</div>
	<div style="clear: both;"></div>
	<div class="<%=ProjConst.CONF_NAME%>" style="display:none;"><%=conf.getName()%></div>
	<div class="<%=ProjConst.OPERATION%>" style="display:none;">assignUser</div>
	<div class="titleSeparator"></div>
	<div class="titleSub">Assign users to conference with specific user role</div>
	</div>
	<div id="vn_mainbody">
	<div class="vn_tblheadzone buttons" style="width: 1300px;">
		<span id="vn_mainbody_filter">
			Search:
   			<input type="text" id="search">
		</span>
	</div>
	<div class="groupedList" style="width: 1300px;">
	<table class="sortable" id="table2" cellspacing="0" border="0">
		<thead>
		<tr>
			<th class="nosort" style="width:3em; text-align: center;">
				<input class="select_all" type="checkbox">
			</th>
			<th>User name</th>
			<th>Name</th>
			<th>Email</th>
			<th>Passport ID</th>
		</tr>
		</thead>
		<tbody>
			<% 
			List<User> users = ConferencesUsersDao.getInstance().getUsersThatNotBelongsToConference(conf);
			for (User user : users) { %>
			<tr class="gridRow">
			<td align="center">
				<input class="checkboxUserName" id="select_one" type="checkbox" value="<%=user.getUserName()%>" name="userNames">
			</td>
			<td id="userNameTd"><%=user.getUserName()%></td>
			<td><a class="vn_boldtext" href="userDetails.jsp?userId=<%=user.getUserId()%>"><%=user.getName()%></a></td>
			<td><%=user.getEmail()%></td>
			<td><%=user.getPasportID()%></td>
			</tr>
			<%} %>
		</tbody>
	</table>
	<% if (users.size() != 0) {%>
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
		sorter.init("table2", 2);
	</script>
	<%} else { %>
		<div>No spare users to assign</div>
	<% }%>
	</div>
	
	<div class="buttons" style="padding-top: 15px;">
	<span style="float: left; font-size: 12px; padding: 4px 10px 6px 0px;">
		Select user role:
	</span>
		<select id="<%=ProjConst.USER_ROLE%>" class="type rdOnlyOnEdit" name="<%=ProjConst.USER_ROLE%>" style="float: left; padding: 4px 10px 6px 7px;
    border-color: #CFCFCF #5F5F5F #5F5F5F #CFCFCF;
    border-style: solid;
    border-width: 1px;
    cursor: pointer;
    display: block;
    margin-right: 7px;">
		<% 
		Map<Integer, String> roles= UserRole.getAllRoles();
		
		Iterator it = roles.entrySet().iterator();
	    while (it.hasNext()) {
	        Map.Entry pairs = (Map.Entry)it.next(); 
	        String selected  = (Integer)pairs.getKey() == UserRole.PARTICIPANT.getValue() ? "selected=\"selected\"" : "";
	        if ( viewingUser.isAdmin() || (ConferencesUsersDao.getInstance().getConferenceUser(conf, viewingUser).getUserRole() == UserRole.CONF_MNGR.getValue() && (Integer)pairs.getKey() == UserRole.PARTICIPANT.getValue())) {
	        %>
				<option value="<%=pairs.getKey()%>" <%=selected%>><%=pairs.getValue()%></option>
			<%} %>
		<%} %>
		</select>
		<a id="createButton" class="assignUsers">
			<img src="/conf4u/resources/imgs/assign_users.png" alt=""> Assign selected users
		</a>
		<a id="cancelButton" href="conferenceDetails.jsp?conferenceName=<%=conf.getName()%>">
		 <img class="img_png" width="16" height="16" alt="" src="/conf4u/resources/imgs/arrow_rotate_clockwise.png"> Back
		</a>
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
		sorter.init("table2", 1);
	</script>
</div>

<script>
$(document).ready(function(){
		
    $('input#search').quicksearch('table#table2 tbody tr');
    
    $('.assignUsers').click(function () {
		 var allVals = "";
		 var $checked = $('input:checkbox[name=userNames]:checked');
		 if ($checked.length == 0)
		 {
			jNotify("No user selected");
			return;
		 }
		$checked.each(function() {
	    	allVals += $(this).val() + ",";
	     });
		
		var confName = $(".confName").text();
		
		$.ajax({
	        url: "ConferenceServlet",
	        dataType: 'json',
	        async: false,
	        type: 'POST',
	            data: {
	            	"action": $(".operation").text(),
                	<%=ProjConst.CONF_NAME%>: confName,
	            	"userNames": allVals,
	            	<%=ProjConst.USER_ROLE%>: $("#userRole").val() 
	            },
	        success: function(data) {
	            if (data != null){
					if (data.resultSuccess == "true")
					{
						 window.location.href = "assignConferenceUser.jsp?confName=" + confName + "&messageNotification=" + data.message + "&messageNotificationType=success";
					}
					else
					{
						jError(data.message);
					}
	            }
	        }
	    });
	});
    sorter.size(10);
});
</script>

</body>
</html>