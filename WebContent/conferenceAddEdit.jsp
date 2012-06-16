<%@page import="model.*"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.*"%>
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

.ui-timepicker-div .ui-widget-header { margin-bottom: 8px; }
.ui-timepicker-div dl { text-align: left; }
.ui-timepicker-div dl dt { height: 25px; margin-bottom: -25px; }
.ui-timepicker-div dl dd { margin: 0 10px 10px 65px; }
.ui-timepicker-div td { font-size: 90%; }
.ui-tpicker-grid-label { background: none; border: none; margin: 0; padding: 0; }

</style>

</head>

<body>
<% User viewingUser = SessionUtils.getUser(request); %>
<% 
//If user got to not allowed page
String retUrlPrevPage = (String)getServletContext().getAttribute("retUrl");
if (!viewingUser.isAdmin())
{
	if (ConferencesUsersDao.getInstance().getUserHighestRole(viewingUser) == null || ConferencesUsersDao.getInstance().getUserHighestRole(viewingUser).getValue() < UserRole.CONF_MNGR.getValue())
		response.sendRedirect(retUrlPrevPage);
}
getServletContext().setAttribute("retUrl", request.getRequestURL().toString());
%>
<%= UiHelpers.GetHeader(viewingUser).toString() %>
<%= UiHelpers.GetTabs(viewingUser, ProjConst.TAB_CONFERENCES).toString() %>
<div id="content">
	<div class="pageTitle">
		<% String action = request.getParameter("action");
		   String confName = request.getParameter("confName");
		   Boolean isEdit = action.equals("edit");
		   Conference conf = new Conference(); 
		   if (isEdit)//== ProjConst.EDIT)
		   {
			   conf = ConferenceDao.getInstance().getConferenceByName(confName);
		   }
		%>
		<div class="operation" style="display:none;"><%=request.getParameter("action")%></div>
		<div class="confBeforeHidden" style="display:none;"><%=request.getParameter("confName")%></div>
		<% if (action == ProjConst.ADD) {%>
			<div class="titleMain ">Add conference</div>
			<div style="clear: both;"></div>
			<div class="titleSeparator"></div>
			<div class="titleSub">Add a new conference</div>
		<% } else {%>
			<div class="titleMain ">Edit conference</div>
			<div style="clear: both;"></div>
			<div class="titleSeparator"></div>
			<div class="titleSub">Edit existing conference</div>
		<%} %>
	</div>
	<div id="vn_mainbody">
		<div class="formtable_wrapper">
			<form id="conferenceAddEditForm">
				<table class="formtable" cellspacing="0" cellpadding="0" border="0">
					<thead>
						<tr>
							<% if (action.equals("edit")) {%>
							<th class="header" colspan="2"><strong>Edit conference</strong> <br></th>
							<% } else {%>
							<th class="header" colspan="2"><strong>Create a new conference</strong> <br></th>
							<%} %>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="labelcell required"><label
								for=<%=ProjConst.CONF_NAME%>"> Conference name: <em>*</em>
							</label></td>
							<% if (action.equals("edit")) {%>
								<td class="inputcell"><input id="<%=ProjConst.CONF_NAME%>"
								type="text" name="<%=ProjConst.CONF_NAME%>" value="<%= conf.getName() %>">
								<div></div></td>
							<% } else {%>
								<td class="inputcell"><input id="<%=ProjConst.CONF_NAME%>"
								type="text" name="<%=ProjConst.CONF_NAME%>">
								<div></div></td>
							<%} %>
						</tr>
						<tr>
							<td class="labelcell required"><label
								for="<%=ProjConst.CONF_DESC%>"> Conference description:
									<em>*</em>
							</label></td>
							<% if (action.equals("edit")) {%>
								<td class="inputcell"><textarea
								id="<%=ProjConst.CONF_DESC%>" name="<%=ProjConst.CONF_DESC%>"><%=conf.getDescription()%></textarea>
								<div></div></td>
							<% } else {%>
								<td class="inputcell"><textarea
								id="<%=ProjConst.CONF_DESC%>" name="<%=ProjConst.CONF_DESC%>"></textarea>
								<div></div></td>
							<%} %>
						</tr>
						<tr>
							<td class="labelcell required"><label
								for="<%=ProjConst.CONF_LOCATION%>"> Locations: <em>*</em>
							</label></td>
							<td class="inputcell">
							<select id="<%=ProjConst.CONF_LOCATION%>" name="<%=ProjConst.CONF_LOCATION%>">
								<% List<Location> locations = LocationDao.getInstance().getLocations();
								for (Location location : locations) { %>
									<option value="<%=location.getLocationId()%>" 
									<% if (isEdit && conf.getLocation() == location) {%>
									 	selected="selected"
							 		<%} %>
							 		><%=location.getName()%></option>
				 				<%} %>
							</select>
							<div></div></td>
						</tr>
						<%
						SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy hh:mm");
						String startDateFormatted = "";
						String endDateFormatted = "";
						if (isEdit)
						{
							startDateFormatted = sdf.format(conf.getStartDate());
							endDateFormatted = sdf.format(conf.getEndDate());
						}
						%>
						<tr>
							<td class="labelcell required"><label
								for="<%=ProjConst.CONF_START_DATE%>"> Start date: <em>*</em>
							</label></td>
							<td class="inputcell"><input
								id="<%=ProjConst.CONF_START_DATE%>" class="datepicker"
								type="text"
								<% if (action.equals("edit")) {%>
									value="<%=startDateFormatted%>"
								<% } else {%>
									value=""
								<%} %>
								 name="<%=ProjConst.CONF_START_DATE%>">
								<div></div></td>
						</tr>
						<tr>
							<td class="labelcell required"><label
								for="<%=ProjConst.CONF_END_DATE%>"> End date: <em>*</em>
							</label></td>
							<% if (action.equals("edit")) { %>
								<td class="inputcell"><input id="<%=ProjConst.CONF_END_DATE%>" class="datepicker" type="text" value="<%=endDateFormatted%>" name="<%=ProjConst.CONF_END_DATE%>">
								<div></div></td>
							<% } else { %>
								<td class="inputcell"><input id="<%=ProjConst.CONF_END_DATE%>" class="datepicker" type="text" name="<%=ProjConst.CONF_END_DATE%>">
								<div></div></td>
							<% } %>
						</tr>
						
						<%
						String retUrl;
						if (isEdit)
						{
							retUrl = "conferenceDetails.jsp";
						}
						else
						{
							retUrl = "conference.jsp";
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
									<a id="cancelButton" href="<%=retUrl + "?conferenceName=" + conf.getName()%>">
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
		$( ".datepicker" ).datetimepicker();
		$('#example1').datetimepicker();
	});
	
	$(document).ready(function(){
		
		var addConfSubmit = function() {
			$.ajax({
	            url: "ConferenceServlet",
	            dataType: 'json',
	            async: false,
	            type: 'POST',
	                data: {
	                	"action": $(".operation").text(),
	                	<%=ProjConst.CONF_NAME%> : $("#confName").val(),
	                	<%=ProjConst.CONF_NAME_BEFORE_EDIT%> : $(".confBeforeHidden").text(),
	              	 	<%=ProjConst.CONF_DESC%> : $("#confDesc").val(),
	              	 	<%=ProjConst.CONF_LOCATION%> : $("#locations").val(),
	              	 	<%=ProjConst.CONF_START_DATE%> : $("#startDate").val(),
	              	 	<%=ProjConst.CONF_END_DATE%> : $("#endDate").val()	
	                },
	            success: function(data) {
	                if (data != null){
						if (data.resultSuccess == "true")
						{	    
							var params;
							var returnUrl;
							
							<%if (isEdit) {%>
								params = "?conferenceName=" +$("#confName").val() + "&messageNotification=" + data.message + "&messageNotificationType=success";
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
		
		$.validator.addMethod("uniqueConferenceName", function(value, element) {
			  var is_valid = false;	  
			  $.ajax({
	              url: "ConferenceServlet",
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
	                    	 $.validator.messages.uniqueConferenceName = value + " is already taken";
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
		 }, "Conference name is already exists");
		
		 $.validator.addMethod("endDateValidate", function(value, element) {
			 var startDate = new Date($("#startDate").val());
			 if (startDate == null)
				 return false;
			 startDate.setHours(0,0,0,0);
	         
			 var myDate = new Date(value);
	         myDate.setHours(0,0,0,0);
	         
	         if (myDate >= startDate)
	        	 return true;
	       	 else
	       		return false;		 
	     }, "Start date should be greater than end date");
		 
		 $.validator.addMethod("startDateGreaterThanNow", function(value, element) {
	         var now = new Date();
	         now.setHours(0,0,0,0);

	         var myDate = new Date(value);
	         myDate.setHours(0,0,0,0);
	         
	         if (myDate >= now)
	        	 return true;
	         else
	        	 return false;
	     }, "Start date must be in the future");
		
		$("#conferenceAddEditForm").validate({
			  onkeyup: false,
			  onfocusout: false,
			  submitHandler: function(form) {  
	              if ($(form).valid())
	              {
	            	  addConfSubmit();
	              }
	              return false;
	     		},
			  rules: {
				confName: {
				    required: true,
				    minlength: 4,
				    maxlength: 30,
				    uniqueConferenceName: $(".operation").text() == "add"
				  },
				  confDesc: {
				  	required: true,
				    minlength: 4,
				    maxlength: 254
				  },
				  locations: {
				  	required: true,
				  },
				  startDate: {
				  	required: true,
					date: true,
					startDateGreaterThanNow: true
				  },
				  endDate: {
				  	required: true,
				 	date: true,
				 	endDateValidate:true
				  },
			  },
			  messages: {
					confName: {
						 required: "Required",
						 minlength: "You need to use at least 4 characters for your conference name.",
						 maxlength: "You need to use at most 30 characters for your conference name.",
						 uniqueConferenceName : "This conference name is already exists"
					},
					confDesc: {
						 required: "Required",
						 minlength: "You need to use at least 4 characters for your conference description.",
						 maxlength: "You need to use at most 254 characters for your conference description."
					},
					locations: {
						required: "Stand up for your comments or go home."
					},
					startDate: {
						required: "Required",
						date: "Date format required",
						startDateGreaterThanNow: "Start date must be in the future"
					 },
					endDate: {
						required: "Required",
						date: "Date format required",
						endDateValidate: "Start date should be greater than end date"
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
	})(jQuery);
	</script>

</body>
</html>