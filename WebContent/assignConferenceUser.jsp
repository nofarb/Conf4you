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
<%User user = UserDao.getInstance().getUserById((Long)session.getAttribute(ProjConst.SESSION_USER_ID));%>
<%Conference conf = ConferenceDao.getInstance().getConferenceByName(request.getParameter("confName"));%>

<%= UiHelpers.GetHeader().toString() %>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_CONFERENCES).toString() %>
<div id="content">
	<div class="pageTitle">
	<div class="titleMain ">Assign user</div>
	<div style="clear: both;"></div>
	<div class="<%=ProjConst.CONF_NAME%>" style="display:none;"><%=conf.getName()%></div>
	<div class="<%=ProjConst.OPERATION%>" style="display:none;">assignUser</div>
	<div class="titleSeparator"></div>
	<div class="titleSub">Assign user to conference with specific user role</div>
	</div>
	<div id="vn_mainbody">
		<div class="formtable_wrapper">
			<form id="userAssignUser">
				<table class="formtable" cellspacing="0" cellpadding="0" border="0">
				
					<thead>
						<tr>
							<th class="header" colspan="2"><strong>Assign user</strong> <br></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="labelcell required">
								<label for="<%=ProjConst.USER_NAME%>"> User : <em>*</em> </label>
							</td>
							<td class="inputcell">
								<select id="<%=ProjConst.USER_NAME%>" class="type rdOnlyOnEdit" name="<%=ProjConst.USER_NAME%>">
									<% 
									
									List<User> users = ConferencesUsersDao.getInstance().getUsersThatNotBelongsToConference(conf);
									for (User confUser : users) { %>
							
									<option value="<%=confUser.getUserName()%>" selected="selected"><%=confUser.getUserName()%></option>
									<%} %>
								</select>
							</td>
						</tr>
						<tr>
							<td class="labelcell required">
								<label for="<%=ProjConst.USER_ROLE%>"> User role: <em>*</em> </label>
							</td>
							<td class="inputcell">
								<select id="<%=ProjConst.USER_ROLE%>" class="type rdOnlyOnEdit" name="<%=ProjConst.USER_ROLE%>">
									<% 

									Map<Integer, String> roles= UserRole.getAllRoles();
									
									Iterator it = roles.entrySet().iterator();
								    while (it.hasNext()) {
								        Map.Entry pairs = (Map.Entry)it.next(); %>
									<option value="<%=pairs.getKey()%>" selected="selected"><%=pairs.getValue()%></option>
									<%} %>
								</select>
							</td>
						</tr>
						
						<tr>
							<td></td>
							<td class="inputcell">
								<div class="buttons">
									<button id="createButton" type="submit">
										<img class="img_png" width="16" height="16" alt=""
											src="/conf4u/resources/imgs/table_save.png"> Assign
									</button>
									<a id="cancelButton" href="conferenceDetails.jsp?conferenceName=<%=request.getAttribute("confName")%>">
									 <img class="img_png" width="16" height="16" alt="" src="/conf4u/resources/imgs/cancel.png"> Cancel
									</a>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
		<div class="clearboth"></div>
	</div>
	</div>

<script>
$(document).ready(function(){
	
	var assignUserSubmit = function() {
		$.ajax({
            url: "ConferenceServlet",
            dataType: 'json',
            async: false,
            type: 'POST',
                data: {
                	"action": $(".operation").text(),
                	<%=ProjConst.CONF_NAME%>: $(".confName").text(),
                	<%=ProjConst.USER_NAME%>: $("#userName").val(),
                	<%=ProjConst.USER_ROLE%>: $("#userRole").val() 
                },
            success: function(data) {
                if (data != null){
					if (data.resultSuccess == "true")
					{
						var params = "&messageNotification=" + data.message + "&messageNotificationType=success";
				 	    window.location.href = "conferenceDetails.jsp?conferenceName=" + $(".confName").text() + params;
					}
					else
					{
						$.floatingMessage(data.message);
						$(".ui-widget-content").addClass("errorFeedback");
					}
                }
            }
        });
    };
	
	
	$("#userAssignUser").validate({
		  onkeyup: false,
		  onfocusout: false,
		  submitHandler: function(form) {  
              if ($(form).valid())
              {
            	  assignUserSubmit();
              }
              return false;
     		},
		  rules: {
			  <%=ProjConst.USER_NAME%>: {
			    required: true
			  },
			  <%=ProjConst.USER_ROLE%>: {
			  	required: true
			  }
		  },
		  errorElement: "div",
	        wrapper: "div",  // a wrapper around the error message
	        errorPlacement: function(error, element) {
	            offset = element.offset();
	            error.insertBefore(element);
	            error.addClass('message');  // add a class to the wrapper
	            error.css('position', 'absolute');
	            error.css('left', offset.left + element.outerWidth());
	        }

		});
});
</script>

</body>
</html>