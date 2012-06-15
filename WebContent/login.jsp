<%@page import="utils.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%= UiHelpers.GetAllJsAndCss().toString() %>
<link type="text/css" href="css/login.css" rel="stylesheet" />
<title>Conf4U</title>
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
});
</script>
</head>
<body>
<% 
getServletContext().setAttribute("retUrl", request.getRequestURL().toString());
%>
<div id="pagewrap">
	<div id="pageheader">
		<div id="logo">
			<img width="97" height="56" border="0" alt="Conf4U" src="/conf4u/resources/imgs/conf4u_logo.png">
		</div>
	</div>
	<div id="page_whitewrap">
	<div id="pagecontent">
	<div class="main_text_wrap">
		<div class="main_text">
		<div class="breadcrumbs"></div>
		<h4> Access to conference management.</h4>
		<div class="column_2wide">
		<div class="loginform">
		<div class="loginform_title">Login:</div>
		<form name="loginform" method="post" action="LoginServlet?action=login" accept-charset="utf-8" >
			<table cellspacing="0" cellpadding="6" style="border-collapse:collapse;">
				<tbody>
					<tr>
						<td>
							<table cellpadding="0">
							<tbody>
							<tr>
								<td align="right">
								<label class="caption" for="un">User Name:</label>
								</td>
								<td>
								<input id="un" class="required" type="text" name="un">
								</td>
							</tr>
							<tr>
								<td align="right">
								<label class="caption" for="pw">Password:</label>
								</td>
								<td>
								<input id="pw" class="required" type="password" name="pw">
								</td>
							</tr>
							<tr>
								<td class="loginfailure" align="center" style="color:Red;" colspan="2"> </td>
							</tr>
							<tr>
								<td align="left" colspan="2">
								<input  class="submitbtn" type="submit" value="Login">
								</td>
							</tr>
							</tbody>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>	
	</div>
	</div>
	<div style="clear:both;"></div>
	</div>
	<div class="main_text_footerimg"></div>
	</div>	
	<div id="pagefooter">
		<div style="float:right">
		&copy; 2011 Conf4U all rights reserved to Alon Pisnoy, Elad Ephrat and Nofar Bluestein
		</div>
		</div>
	</div>
	
</div>
</body>
</html>