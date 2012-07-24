<%@page import="helpers.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%= UiHelpers.GetAllJsAndCss().toString() %>
<title>Conf4U</title>
<link type="text/css" href="css/login.css" rel="stylesheet" />
<link href="css/login-box.css" rel="stylesheet" type="text/css" />
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
		<div class="fakeBoarder"></div>
		<div id="login-box">
		<H2>Login</H2>
		Access to conference management.
		<br />
		<br />
		<div class="newLoginform" style="margin-bottom: 5px;">
			<form name="loginform" method="post" action="LoginServlet?action=login" accept-charset="utf-8" >
			<div id="login-box-name" style="margin-top:20px;">User Name:</div><div id="login-box-field" style="margin-top:20px;"><input name="un" id="un" class="form-login" title="Username" value="" size="30" maxlength="2048" /></div>
			<div id="login-box-name">Password:</div><div id="login-box-field"><input name="pw" id="pw" type="password" class="form-login" title="Password" value="" size="30" maxlength="2048" /></div>
			<br />
			<br />
			<input class="submitbtn" type="submit" value="Login">
			</form>
			<br />
			<span class="login-box-options"><a style="cursor: pointer;" class="cantRememberPassword">Forgot password?</a></span>
		</div>
		<div class="resetPasswordArea" style="display: none;">
			<form id="resetPassword">
				<div id="login-box-name" style="margin-top:20px;">User name:</div><div id="login-box-field" style="margin-top:20px;"><input id="userName" class="form-login" type="text" name="userName" /></div>
					<a class="cancelReset" style="cursor: pointer; margin-left: 92px; color: #666666;">Cancel</a>
					<input style="margin-left: 10px;" class="submitbtn" id="emailSubmit" type="submit" value="Email new password" name="emailSubmit">
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
			$(".newLoginform").slideUp();
			$(".resetPasswordArea").fadeIn();
		}
	});
	
	$(".cancelReset").click(function () {
		$(".resetPasswordArea").slideUp("slow");
		$(".newLoginform").slideDown("slow");
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