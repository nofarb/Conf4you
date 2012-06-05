<%@page import="model.ConferencesUsers"%>
<%@page import="model.UserRole"%>
<%@page import="daos.ConferencesUsersDao"%>
<%@page import="model.Company"%>
<%@page import="model.Conference"%>
<%@page import="model.Location"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.LocationDao"%>
<%@page import="daos.UserDao"%>
<%@page import="daos.CompanyDao"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="model.User"%>
<%@page import="utils.ProjConst"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="utils.*"%>

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

</head>

<body>
<%User user = UserDao.getInstance().getUserById(Long.parseLong(request.getParameter("userId")));%>

<%= UiHelpers.GetHeader().toString() %>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_CONFERENCES).toString() %>
<div id="content">
	<div class="pageTitle">
	<div class="titleMain ">Remove from conference</div>
	<div style="clear: both;"></div>
	<div class="<%=ProjConst.OPERATION%>" style="display:none;">removeFromConference</div>
	<div class="titleSeparator"></div>
	<div class="titleSub">Remove user from conference</div>
	</div>
	<div id="vn_mainbody">
		<div class="formtable_wrapper">
			<table class="formtable" cellspacing="0" cellpadding="0" border="0">
			
				<thead>
					<tr>
						<th class="header" colspan="2"><strong>Remove user</strong> <br></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="labelcell required">
							<label for="<%=ProjConst.CONF_NAME%>"> Conference name: </label>
						</td>
						<td class="inputcell">
							<select id="<%=ProjConst.CONF_NAME%>" class="type rdOnlyOnEdit" name="<%=ProjConst.CONF_NAME%>">
								<% 
								List<ConferencesUsers> confUsers = ConferencesUsersDao.getInstance().getAllConferenceUsersByUser(user);
								for (ConferencesUsers cu : confUsers) {
									String confName = cu.getConference().getName();
									String userRole = UserRole.resolveUserRoleToFriendlyName(cu.getUserRole());
								%>
								<option value="<%=confName%>" selected="selected"><%=confName + " with role " + userRole%></option>
								<%} %>
							</select>
						</td>
					</tr>
					<tr>
						<td></td>
						<td class="inputcell">
							<div class="buttons">
								<button id="removeUser">
									<img class="img_png" width="16" height="16" alt=""
										src="/conf4u/resources/imgs/table_save.png"> Remove
								</button>
								<a id="cancelButton" href="userDetails.jsp?usedId=<%=user.getUserId()%>">
								 <img class="img_png" width="16" height="16" alt="" src="/conf4u/resources/imgs/cancel.png"> Cancel
								</a>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<div class="clearboth"></div>
		<div id="dialogConfirmRemoveUser" title="Remove user from conference?" style="display:none;">
			<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>User will be removed. Are you sure?</p>
		</div>
	</div>
	</div>

<script>
$(document).ready(function(){
	
	 $('#removeUser').click(function () { 
		 $('#dialogConfirmRemoveUser').dialog({
			resizable: false,
			height: 150,
			width: 400,
			modal: true,
			hide: "fade", 
            show: "fade",
			buttons: {
				"Delete": function() {
					$.ajax({
				        url: "ConferenceServlet",
				        dataType: 'json',
				        async: false,
				        type: 'POST',
				            data: {
				            	"action": "removeUser",
				            	"confName": $("#confName").val(),
				            	"userName": "<%=user.getUserName()%>"
				            },
				        success: function(data) {
				            if (data != null){
								if (data.resultSuccess == "true")
								{
							 	   	window.location = "userDetails.jsp?userId=" + <%=user.getUserId()%> + "&messageNotification=" + data.message + "&messageNotificationType=success";
								}
								else
								{
									$( this ).dialog( "close" );
									jError(data.message);
								}
				            }
				        }
				    });
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			}
		});
	});
});
</script>

</body>
</html>