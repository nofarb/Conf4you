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

</head>

<body>
<% User viewingUser = SessionUtils.getUser(request); %>
<% 
//If user got to not allowed page
String retUrl = (String)getServletContext().getAttribute("retUrl");
if (!viewingUser.isAdmin())
	response.sendRedirect(retUrl);

getServletContext().setAttribute("retUrl", request.getRequestURL().toString());
 
String userId = request.getParameter("userId");
Long id = new Long(userId);
User user = UserDao.getInstance().getUserById(id);
%>


<%= UiHelpers.GetHeader(viewingUser).toString() %>
<%= UiHelpers.GetTabs(viewingUser, ProjConst.TAB_CONFERENCES).toString() %>
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
										src="/conf4u/resources/imgs/save.png"> Remove
								</button>
								<a id="cancelButton" href="userDetails.jsp?userId=<%=user.getUserId()%>">
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
				"Remove": function() {
					$.ajax({
				        url: "ConferenceServlet",
				        dataType: 'json',
				        async: false,
				        type: 'POST',
				            data: {
				            	"action": "removeUser",
				            	"confName": $("#confName").val(),
				            	"userNames": "<%=user.getUserName()%>"
				            },
				        success: function(data) {
				            if (data != null){
								if (data.resultSuccess == "true")
								{
									$( this ).dialog( "close" );
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