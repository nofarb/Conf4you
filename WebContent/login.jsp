<%@page import="utils.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%= UiHelpers.GetAllJsAndCss().toString() %>
<title>Conf4U</title>
<link type="text/css" href="css/login.css" rel="stylesheet" />
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
		<span class="sendingResetPasswordEmail" style="display: none; padding-left: 100px;">
			<img src="/conf4u/resources/imgs/loadinfo.gif" /> Sending reset password email...
		</span>
		<div class="breadcrumbs"></div>
		<h4> Access to conference management.</h4>
		<div class="column_2wide">
		<div class="loginform" style="margin-bottom: 5px;">
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
	<a class="cantRememberPassword" style="padding-left: 35px;">Can't remember your password?</a>
		<div class="resetPasswordArea" style="display: none;">
			<form id="resetPassword">
				<table>
					<tbody>
					<tr>
					<td style="height: 41px"> Enter your user name: </td>
					<td class="inputcell" style="height: 41px">
						<input id="userName" type="text" name="userName">
					</td>
					</tr>
					<tr>
					<td style="text-align:right; padding-right: 8px;">
						<a class="cancelReset">Cancel</a>
					</td>
					<td colspan="2">
						<input id="emailSubmit" type="submit" value="Email new password" name="emailSubmit">
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
	
	$(".cantRememberPassword").click(function () {
		if($(this).is(":visible"))
		{
			$(this).hide();
			$(".loginform").slideUp();
			$(".resetPasswordArea").fadeIn();
		}
	});
	
	$(".cancelReset").click(function () {
		$(".resetPasswordArea").slideUp("slow");
		$(".loginform").slideDown("slow");
		$(".cantRememberPassword").show();
	});
	
	var resetPassword = function(){
				
		$.ajax({
	        url: "LoginServlet",
	        dataType: 'json',
	        async: false,
	        type: 'POST',
	            data: {
	            	"action": "resetPassword",
	            	"userName": $("#userName").val()
	            },
	        success: function(data) {
	            if (data != null){
					if (data.resultSuccess == "true")
					{
						$('.sendingResetPasswordEmail').fadeOut("fast");
				 	   	window.location = "login.jsp?messageNotification=" + data.message + "&messageNotificationType=success";
					}
					else
					{
						$('.sendingResetPasswordEmail').fadeOut("fast");
						jError(data.message);
					}
	            }
	        }
	    });
	};
	
	$("#resetPassword").validate({
		  onkeyup: false,
		  onfocusout: false,
		  submitHandler: function(form) {  
            if ($(form).valid())
            {
            	$('.sendingResetPasswordEmail').show();
            	resetPassword();
            }
            return false;
   		},
		  rules: {
			  userName: {
			    required: true,
			    minlength: 4
			  }
		  },
		  errorElement: "div",
          wrapper: "div",  // a wrapper around the error message
	      errorPlacement: function(error, element) {
	            offset = element.offset();
	            error.insertBefore(element);
	            error.addClass('message');  // add a class to the wrapper
	            error.css('position', 'absolute');
	            error.css('left', 330);
	        }
	});
})
</script>
</body>
</html>