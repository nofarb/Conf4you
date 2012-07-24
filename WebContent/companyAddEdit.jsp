<%@page import="model.CompanyType"%>
<%@page import="daos.CompanyDao"%>
<%@page import="model.Company"%>
<%@page import="model.Conference"%>
<%@page import="model.Location"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.LocationDao"%>
<%@page import="daos.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="model.User"%>
<%@page import="helpers.ProjConst"%>
<%@ page import="helpers.*"%>

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
String retUrlPrevPage = (String)getServletContext().getAttribute("retUrl");
if (!viewingUser.isAdmin())
	response.sendRedirect(retUrlPrevPage);

getServletContext().setAttribute("retUrl", request.getRequestURL().toString());
%>


<%= UiHelpers.GetHeader(viewingUser).toString() %>
<%= UiHelpers.GetTabs(viewingUser, ProjConst.TAB_COMPANIES).toString() %>

<div id="content">

	<div class="pageTitle">
		<% String action = request.getParameter("action");
		   String compName = request.getParameter("compName");
		   Boolean isEdit = action.equals("edit");
		   Company comp = new Company();
		   if (isEdit)//== ProjConst.EDIT)
		   {
			   comp = CompanyDao.getInstance().getCompanyByName(compName);			   
		   }
		%>
		<div class="operation" style="display: none;"><%=request.getParameter("action")%></div>
		<div class="compBeforeHidden" style="display: none;"><%=request.getParameter("compName")%></div>

		<% if (action.equals(ProjConst.ADD)) {%>
		<div class="titleMain ">Add company</div>
		<div style="clear: both;"></div>
		<div class="titleSeparator"></div>
		<div class="titleSub">Add a new company</div>
		<% } else {%>
		<div class="titleMain ">Edit company</div>
		<div style="clear: both;"></div>
		<div class="titleSeparator"></div>
		<div class="titleSub">Edit existing company</div>
		<%} %>
	</div>
	<div id="vn_mainbody">
		<div class="formtable_wrapper">
			<form id="companyAddEditForm">
				<table class="formtable" cellspacing="0" cellpadding="0" border="0">
					<thead>
						<tr>
							<% if (action.equals(ProjConst.EDIT)) {%>
							<th class="header" colspan="2"><strong>Edit company</strong>
								<br></th>
							<% } else {%>
							<th class="header" colspan="2"><strong>Create a new
									company</strong> <br></th>
							<%} %>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="labelcell required"><label
								for="<%=ProjConst.COMP_NAME%>"> Company name: <em>*</em>
							</label></td>
							<% if (action.equals(ProjConst.EDIT)) {%>
							<td class="inputcell"><input id="<%=ProjConst.COMP_NAME%>" type="text" name="<%=comp.getName()%>" value="<%=comp.getName()%>" />
								<div></div></td>
							<% } else {%>
							<td class="inputcell"><input id="<%=ProjConst.COMP_NAME%>"
								type="text" name="<%=ProjConst.COMP_NAME%>" />
								<div></div></td>
							<%} %>
						</tr>
						<tr>
							<td class="labelcell required"><label
								for="<%=ProjConst.COMP_TYPE%>"> Type: <em>*</em>
							</label></td>
							<td class="inputcell"><select id="<%=ProjConst.COMP_TYPE%>"
								class="type rdOnlyOnEdit" name="<%=ProjConst.COMP_TYPE%>">
									<%
								//List<Location> locations = LocationDao.getInstance().getLocations();
								
								//for (Location location : locations) {
								for (CompanyType companyType : CompanyType.values()) {%>

									<option value="<%=companyType.toString()%>"										
										<% if (action.equals(ProjConst.EDIT) && comp.getCompanyType() == companyType){ %>
										selected="selected" <%} %>>
										<%=companyType.toString()%>
									</option>
									<%} %>

							</select>
								<div></div></td>
						</tr>
						<%
						String retUrl;
						if (isEdit)
						{
							retUrl = "companyDetails.jsp";
						}
						else
						{
							retUrl = "company.jsp";
						}					
						%>
						<tr>
							<td></td>
							<td class="inputcell">
								<div class="buttons">
									<button id="createButton" type="submit">
										<img class="img_png" width="16" height="16" alt=""
											src="/conf4u/resources/imgs/save.png"> Save
									</button>
									<a id="cancelButton" href="<%=retUrl + "?companyName=" + comp.getName()%>"> 
									<img class="img_png" width="16" height="16" alt=""
										src="/conf4u/resources/imgs/cancel.png"> Cancel
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
<script type="text/javascript">	
$(function() {
	$( ".datepicker" ).datepicker();
});

$(document).ready(function(){
	var addCompSubmit = function() {
		$.ajax({
            url: "CompanyServlet",
            dataType: 'json',
            async: false,
            type: 'POST',
                data: {
                	"action": "<%=request.getParameter("action")%>",
                	"<%=ProjConst.COMP_NAME%>" : "<%=request.getParameter("action")%>" == "<%=ProjConst.ADD%>" ? $("#" + "<%=ProjConst.COMP_NAME%>").val() : $("#" + "<%=ProjConst.COMP_NAME%>").val(),
                	"<%=ProjConst.COMP_NAME_BEFORE_EDIT%>" : $(".compBeforeHidden").text(),
              	 	"<%=ProjConst.COMP_TYPE%>" : $("#" + "<%=ProjConst.COMP_TYPE%>").val()
                },
            success: function(data) {
                if (data != null){
					if (data.resultSuccess == "true")
					{
					
						var params;
						var returnUrl;
						
						<%if (isEdit) {%>
							params = "?companyName=" + $("#compName").val() + "&messageNotification=" + data.message + "&messageNotificationType=success";
						<% } else {%>
							params = "?messageNotification=" + data.message + "&messageNotificationType=success";						
						<% } %>
						
						returnUrl = "<%=retUrl%>";
						returnUrl += params;
				 	    window.location.href = returnUrl;
					}
					else
					{
						jError(data.message);
					}
                }
            }
        });
    };
	
	$.validator.addMethod("uniqueCompanyName", function(value, element) {
		  var is_valid = false;
		  	  
		  $.ajax({
              url: "CompanyServlet",
              dataType: 'json',
              async: false,
              type: 'POST',
                  data: {
                	  "action": "validation",
                      "data": value
                  },
              success: function(data) {
                  if (data != null){
                      if (data == "true")
                      {
                    	 $.validator.messages.uniqueCompanyName = value + " is already taken";
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
	 }, "Company name already exists");

	$("#companyAddEditForm").validate({
		  onkeyup: false,
		  onfocusout: false,
		  submitHandler: function(form)
		  {  
			  try
			  {
	              if ($(form).valid())
	              {
	            	  addCompSubmit();
	              }
			  }
			  catch(e)
			  {
				  alert(e);
			  }
              return false;
     		},
		  rules: {
			compName: {
			    required: true,
			    minlength: 4,
			    maxlength: 30,
			    uniqueCompanyName: $(".operation").text() == "<%=ProjConst.ADD%>",
			  },
			  compType: {
			  	required: true,
			  },
		  },
		  messages: {
			  	compName: {
					 required: "Required",
					 minlength: "You need to use at least 4 characters for your company name.",
					 maxlength: "You need to use at most 30 characters for your company name.",
					 uniqueCompanyName : "This company name already exists",
				},
				compType: {
					required: "you must choose company type.",
				},
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