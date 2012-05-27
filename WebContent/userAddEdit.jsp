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
<%@page import="utils.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" href="css/main.css" rel="stylesheet" />
<link type="text/css" href="css/tables/tableList.css" rel="stylesheet" />
<link type="text/css" href="css/cupertino/jquery-ui-1.8.18.custom.css"
	rel="stylesheet" />
<script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.18.custom.min.js"></script>
<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type="text/javascript" src="js/jquery.floatingmessage.js"></script>
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

<script>

$(document).ready(function(){
	
	$('.userAddEditForm').click(function() {
		$.ajax({
            url: "users",
            dataType: 'json',
            async: false,
            type: 'POST',
                data: {
                	"action": $(".operation").text(),
                	<%=ProjConst.USER_NAME%> : $("#userName").val(),
              	 	<%=ProjConst.NAME%> : $("#name").val(),
              	 	<%=ProjConst.PASSPORT_ID%> : $("#passportId").val(),
              	 	<%=ProjConst.PASSWORD%> : $("#password").val(),
              	 	<%=ProjConst.PHONE1%> : $("#phone1").val(), 	
              	 	<%=ProjConst.PHONE2%> : $("#phone2").val(), 	
              	 	<%=ProjConst.EMAIL%> : $("#email").val(), 	
              	 	<%=ProjConst.COMPANY%> : $("#company").val(), 	
              	 	<%=ProjConst.IS_ADMIN%> : $("#isAdmin").val(), 	

                },
            success: function(data) {
                if (data != null){
					if (data.resultSuccess == "true")
					{
						$(".errorMessage").val(data.message);
					}
					else
					{
						//TODO: redirect success
					}
                }
            }
        });
    });
	
	$.validator.addMethod("uniqueUserName", function(value, element) {
		  var is_valid = false;
		  	  
		  $.ajax({
              url: "users",
              dataType: 'json',
              async: false,
              type: 'POST',
                  data: {
                	  "action": "validation",
                	  <%=ProjConst.USER_NAME%> : $("#userName").val(),
                  },
              success: function(data) {
                  if (data != null){
                      if (data == "true")
                      {
                    	 $.validator.messages.uniqueUserName = value + " is already taken";
                       	is_valid = false;
                      }
                      else
                   	  {
                    	  is_valid = true;
                   	  }
                  }
              }
          });
	      return is_valid;
	 }, "The user name already exists");
	
	 $.validator.addMethod("phoneNumberValidator", function(value, element) {
		 
		 var phoneNumber = value;

/*          if (myDate >= startDate)
        	 return true;
       	 else */
       		return true;		 
     }, "Start date should be greater than end date");

	
	$("#userAddEditForm").validate({
		  onkeyup: false,
		  onfocusout: false,
		  submitHandler: function(form) {  
              if ($(form).valid())
              {
                  form.submit(); 
              }
              return false;
     		},
		  rules: {
			  <%=ProjConst.USER_NAME%>: {
			    required: true,
			    minlength: 4,
			    maxlength: 10,
			    uniqueUserName: $(".operation").text() == "add",

			  },
			  <%=ProjConst.NAME%>: {
			  	required: true,
			    minlength: 4,
			    maxlength: 254,
			  },
			  <%=ProjConst.PASSPORT_ID%>: {
				  	required: true,
				    minlength: 9,
				    maxlength: 9,
					digits: true,
			  },
			  <%=ProjConst.PASSWORD%>: {
				  	required: true,
				    minlength: 4,
				    maxlength: 16,
			  },
			  <%=ProjConst.PHONE1%>: {
			  	required: true,
			  	phoneNumberValidator: true,
			  },
			  <%=ProjConst.PHONE2%>: {
			  	required: false,
			  	phoneNumberValidator: true,
			  },
			  <%=ProjConst.EMAIL%>: {
			  	required: true,
			 	email: true,
			  },
		  },
		   
		  messages: {
			  	<%=ProjConst.USER_NAME%>: {
					 required: "Required",
					 minlength: "You need to use at least 4 characters for your user name.",
					 maxlength: "You need to use at most 10 characters for your user name.",
					 uniqueUserName : "This user name already exists",
				},
				<%=ProjConst.NAME%>: {
					 required: "Required",
					 minlength: "You need to use at least 4 characters for your name.",
					 maxlength: "You need to use at most 254 characters for your name.",
				},
				<%=ProjConst.PASSPORT_ID%>: {
					 required: "Required",
					 digits: "passport should be consisted of from digits only",
					 minlength: "IL passport id should exactly 9 characters.",
					 maxlength: "IL passport id should exactly 9 characters.",
				},
				<%=ProjConst.PASSWORD%>: {
					required: "Required",
					 minlength: "You need to use 4-16 characters for your password.",
					 maxlength: "You need to use 4-16 characters for your password.",
				 },
				 <%=ProjConst.PHONE1%>: {
					required: "Required",
				 	phoneNumberValidator:"Phone number invalid",
				},
			 	<%=ProjConst.PHONE2%>: {
				 	phoneNumberValidator:"Phone number invalid",
				},
			 	<%=ProjConst.EMAIL%>: {
			 		required: "Required",
			 		email: "Invalid email address",
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


</head>

<body>
<%= UiHelpers.GetHeader().toString() %>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_USERS).toString() %>
<div id="content">
	<div class="pageTitle">
		<% String action = request.getParameter("action");
		   boolean isEdit = action.equals("edit");
		   User user = new User();

		   String userIdStr = request.getParameter("userId");
		   
		   if (isEdit)
		   {
			   if(userIdStr != null){
				   Long userId = new Long(userIdStr);
				   user = UserDao.getInstance().getUserById(userId);
			   }
		   }

		%>
		<div class="operation" style="display:none;"><%=action%></div>
		
		<% if (isEdit) {%>
			<div class="titleMain ">Edit user</div>
			<div style="clear: both;"></div>
			<div class="titleSeparator"></div>
			<div class="titleSub">Edit existing user</div>
		<% } else {%>
			<div class="titleMain ">Add user</div>
			<div style="clear: both;"></div>
			<div class="titleSeparator"></div>
			<div class="titleSub">Add a new user</div>
		<%} %>
	</div>
	<div id="vn_mainbody">
		<div class="formtable_wrapper">
			<form id="userAddEditForm">
				<table class="formtable" cellspacing="0" cellpadding="0" border="0">
					<thead>
						<tr>
							<% if (isEdit) {%>
							<th class="header" colspan="2"><strong>Edit user</strong> <br></th>
							<% } else {%>
							<th class="header" colspan="2"><strong>Create a new user</strong> <br></th>
							<%} %>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="labelcell required"><label
								for=<%=ProjConst.USER_NAME%>> Unique User Name: <em>*</em>
							</label></td>
							<% if (isEdit) {%>
								<td class="inputcell">
									<input id="<%=ProjConst.USER_NAME%>" type="text" value="<%=user.getUserName()%>" name="<%=ProjConst.USER_NAME%>">
								</td>
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.USER_NAME%>" type="text" name="<%=ProjConst.USER_NAME%>">
								</td>
							<%} %>
						</tr>
					
						<tr>
							<td class="labelcell required"><label
								for=<%=ProjConst.NAME%>> Full Name: <em>*</em>
							</label></td>
							<% if (isEdit) {%>		
								<td class="inputcell">
									<input id="<%=ProjConst.NAME%>" type="text" value="<%=user.getName()%>" name="<%=ProjConst.NAME%>">
								</td>
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.NAME%>" type="text" name="<%=ProjConst.NAME%>">
								</td>
							<%} %>
						</tr>
			
						<tr>
							<td class="labelcell required"><label
								for=<%=ProjConst.PASSPORT_ID%>> Passport #: <em>*</em>
							</label></td>
							<% if (isEdit) {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PASSPORT_ID%>" type="text" value="<%=user.getPasportID()%>" name="<%=ProjConst.PASSPORT_ID%>">
								</td>
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PASSPORT_ID%>" type="text" name="<%=ProjConst.PASSPORT_ID%>">
								</td>
							<%} %>
						</tr>
	 
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.EMAIL%>> Email:  <em>*</em> </label>
							</td>
							<% if (isEdit) {%>
								<td class="inputcell">
									<input id="<%=ProjConst.EMAIL%>" type="text" value="<%=user.getEmail()%>" name="<%=ProjConst.EMAIL%>">
								</td>								
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.EMAIL%>" type="text" name="<%=ProjConst.EMAIL%>">
								</td>
							<%} %>
						</tr>
						
					
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.PHONE1%>> Phone #1:  <em>*</em> </label>
							</td>
							<% if (isEdit) {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PHONE1%>" type="text" value="<%=user.getPhone1()%>" name="<%=ProjConst.PHONE1%>">
								</td>
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PHONE1%>" type="text" name="<%=ProjConst.PHONE1%>">
								</td>
							<%} %>
						</tr>
						
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.PHONE2%>> Phone #2:  </label>
							</td>
							<% if (isEdit) {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PHONE2%>" type="text" value="<%=user.getPhone2()%>" name="<%=ProjConst.PHONE2%>">
								</td>
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PHONE2%>" type="text" name="<%=ProjConst.PHONE2%>">
								</td>
							<%} %>
						</tr>
						
						<tr>
							<td class="labelcell required">
								<label for="<%=ProjConst.COMPANY%>"> Company: <em>*</em> </label>
							</td>
							<td class="inputcell">
								<select id="<%=ProjConst.COMPANY%>" class="type rdOnlyOnEdit" name="<%=ProjConst.COMPANY%>">
									<% 
									List<Company> companies = CompanyDao.getInstance().getAllCompanies();
									for (Company company : companies) { %>
							
									<option value="<%=company.getCompanyID()%> " 
										<% if (isEdit && user.getCompany().getCompanyID() == company.getCompanyID()) {%>
										 	selected="selected"
								 		<%} %>
								 		><%=company.getName()%>
								 	</option>
					 				<%} %>
										 	
								</select>
							</td>
						</tr>
							
						<tr>
							<td class="labelcell required"><label for=<%=ProjConst.PASSWORD%>> Password: </label></td>
							<% if (isEdit) {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PASSWORD%>" type="password" value="*****" name="<%=ProjConst.PASSWORD%>">
								</td>
								
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PASSWORD%>" type="password"  value="" name="<%=ProjConst.PASSWORD%>">
								</td>
							<%} %>
						</tr>


						   <%
								User sessionUser = SessionUtils.getUser(request);
								if (sessionUser != null && sessionUser.isAdmin()) {
							%>
									<tr>
										<td class="labelcell required">
											<label for=<%=ProjConst.IS_ADMIN%>> Admnin User: <em>*</em> </label>				
										</td>
										<% if (isEdit && user.isAdmin()) {%>
										<td class="inputcell">
											<input id=<%=ProjConst.IS_ADMIN%> type="checkbox" value="true"  checked="checked" name=<%=ProjConst.IS_ADMIN%>><div></div>
										</td>
										
										<% } else {%>
										<td class="inputcell">
											<input id=<%=ProjConst.IS_ADMIN%> type="checkbox" value="true" name=<%=ProjConst.IS_ADMIN%>><div></div>
										</td>
										<%} %>
									</tr>
							<%
								}
							%>
							
							<%
								String redirectTo;
								if(isEdit){
									redirectTo = "userDetails.jsp?userId="+user.getUserId();
								}else{
								 	redirectTo = "users.jsp";
								}
							%>
						
						<tr>
							<td></td>
							<td class="inputcell">
								<div class="buttons">
									<button id="createButton" type="submit">
										<img class="img_png" width="16" height="16" alt=""
											src="/conf4u/resources/imgs/table_save.png"> Save
									</button>
									<a id="cancelButton" href="<%=redirectTo %>">
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

</body>
</html>