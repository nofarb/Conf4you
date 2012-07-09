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
<%@page import="helpers.ProjConst"%>
<%@page import="javax.servlet.jsp.PageContext"%>
<%@page import="javax.servlet.jsp.JspContext"%>
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
%>

<%= UiHelpers.GetHeader().toString() %>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_USERS).toString() %>
<div id="content">
	<div class="pageTitle">
		<% 
		   String userIdStr = request.getParameter("userId");
		%>
		<div class="<%=ProjConst.OPERATION%>" style="display:none;">changePassword</div>

		<div class="<%=ProjConst.USER_ID%>" style="display:none;"> <%=userIdStr%> </div>
	
		<div class="titleMain ">Change Password</div>
		<div style="clear: both;"></div>
		<div class="titleSeparator"></div>
		<div class="titleSub">Enter a new password</div>

	</div>
	<div id="vn_mainbody">
		<div class="formtable_wrapper">
			<form id="userAddEditForm">
				<table class="formtable" cellspacing="0" cellpadding="0" border="0">
					<thead>
						<tr>
							<th class="header" colspan="2"><strong>Change Password</strong> <br></th>
						</tr>
					</thead>
					<tbody>

					<tr>
						<td class="labelcell required"><label for=<%=ProjConst.PASSWORD%>> New Password: </label></td>
						<td class="inputcell">
							<input id="<%=ProjConst.PASSWORD%>" type="password" autocomplete="off" value="" name="<%=ProjConst.PASSWORD%>">
						</td>
					</tr>

							<%
								String redirectToCancel = "userDetails.jsp?userId="+userIdStr;
							%>
						<tr>
							<td class="inputcell">
								<div class="buttons">
									<button id="createButton" type="submit">
										<img class="img_png" width="16" height="16" alt=""
											src="/conf4u/resources/imgs/table_save.png"> Save
									</button>
									<a id="cancelButton" href="<%=redirectToCancel%>">
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
	
	var changePass = function() {
		$.ajax({
            url: "UsersServlet",
            dataType: 'json',
            async: false,
            type: 'POST',
                data: {
                	"action": $(".operation").text(),
                	<%=ProjConst.USER_ID%>: $(".userId").text(),
              	 	<%=ProjConst.PASSWORD%> : $("#password").val(),
                },
            success: function(data) {
                if (data != null){
					if (data.resultSuccess == "true")
					{
						var params;
						var returnUrl;
						
						params = "&messageNotification=" + data.message + "&messageNotificationType=success";

						returnUrl = "<%=redirectToCancel%>";
						returnUrl += params;
				 	    window.location.href = returnUrl;
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

	
	$("#userAddEditForm").validate({
		  onkeyup: false,
		  onfocusout: false,
		  submitHandler: function(form) {  
              if ($(form).valid())
              {
            	  changePass();
              }
              return false;
     		},
		  rules: {
			  <%=ProjConst.PASSWORD%>: {
				  	required: true,
				    minlength: 4,
				    maxlength: 16
			  }
		  },
		   
		  messages: {
				<%=ProjConst.PASSWORD%>: {
					required: "Required",
					 minlength: "You need to use 4-16 characters for your password.",
					 maxlength: "You need to use 4-16 characters for your password.",
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