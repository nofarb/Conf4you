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

<script type="text/javascript">	
$(function() {
	$( ".datepicker" ).datepicker();
});

$(document).ready(function(){
	
	var addLocSubmit = function() {
		alert("add loc");
		$.ajax({
            url: "LocationServlet",
            dataType: 'json',
            async: false,
            type: 'POST',
                data: {
                	"action": $(".operation").text(),
                	"<%=ProjConst.LOC_NAME%>" : "<%=request.getParameter("action")%>" == "<%=ProjConst.ADD%>" ? $("#" + "<%=ProjConst.LOC_NAME%>").val() : $("#" + "<%=ProjConst.LOC_NAME%>").text(),
                	"<%=ProjConst.COMP_NAME_BEFORE_EDIT%>" : $(".locBeforeHidden").text(),
                	"<%=ProjConst.LOC_Phone%>" : $("#" + "<%=ProjConst.LOC_Phone%>").val(),
                	"<%=ProjConst.LOC_Phone2%>" : $("#" + "<%=ProjConst.LOC_Phone2%>").val(),
                	"<%=ProjConst.LOC_MaxCapacity%>" : $("#" + "<%=ProjConst.LOC_MaxCapacity%>").val(),
                	"<%=ProjConst.LOC_ContactName%>" : $("#" + "<%=ProjConst.LOC_ContactName%>").val(),
                	"<%=ProjConst.LOC_Address%>" : $("#" + "<%=ProjConst.LOC_Address%>").val()
                },
            success: function(data) {
                if (data != null){
					if (data.resultSuccess == "true")
					{
					
					 	//window.location.reload();
					 	    $.floatingMessage(data.message ,{  
					 	    	height : 30
						    }); 
					 	    $(".ui-widget-content").addClass("successFeedback");
					 	
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
	
	$.validator.addMethod("uniqueLocationName", function(value, element) {
		  var is_valid = false;
		  alert("unique");
		  $.ajax({
              url: "LocationServlet",
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
                    	 $.validator.messages.uniqueLocationName = value + " is already taken";
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
	 }, "Location name is already exists");
	
	 $.validator.addMethod("endDateValidate", function(value, element) {
		 var startDateVal = $("#startDate").val();
         var startDate = $.date(startDateVal, "MM/dd/yyyy");
         var myDate = $.date(value, "MM/dd/yyyy");
         if (myDate >= startDate)
        	 return true;
       	 else
       		return false;		 
     }, "Start date should be greater than end date");
	 
	 $.validator.addMethod("startDateGreaterThanNow", function(value, element) {
         var now = $.date();
         var myDate = $.date(value, "MM/dd/yyyy");
         if (myDate >= now)
        	 return true;
         else
        	 return false;
     }, "Start date must be in the future");
	 
	 $.validator.addMethod("numberValidate", function(value, element) {
		 return !isNaN(parseFloat(value)) && isFinite(value);
	 }, "Must be a number" );
	
	$("#locationAddEditForm").validate({
		  onkeyup: false,
		  onfocusout: false,
		  submitHandler: function(form) {  
              if ($(form).valid())
              {
            	  alert("valid");
            	  addLocSubmit();
              }
              return false;
     		},
		  rules: {
			  <%=ProjConst.LOC_NAME%>: {
			    required: true,
			    minlength: 4,
			    maxlength: 30,
			    uniqueLocationName: $(".operation").text() == "add",
			  },
			  <%=ProjConst.LOC_Address%>: {
			  	required: true,
			    minlength: 4,
			    maxlength: 254,
			  },
			  <%=ProjConst.LOC_MaxCapacity%>: {
			  	required: true,
			  	maxlength: 254,
			  },
			  <%=ProjConst.LOC_ContactName%>: {
				  	required: true,
			  },
			  phone1: {
				  requied: true,
				  minlength: 9,
				  maxlength: 15,
			  },
			  phone2: {
				  requied: true,
				  minlength: 9,
				  maxlength: 15,
			  },
		  },
		  messages: {
			  <%=ProjConst.LOC_NAME%>: {
					 required: "Required",
					 minlength: "You need to use at least 4 characters for your location name.",
					 maxlength: "You need to use at most 30 characters for your location name.",
					 uniqueLocationeName : "This location name is already exists",
				},
				<%=ProjConst.LOC_Address%>: {
					 required: "Required",
					 minlength: "You need to use at least 4 characters for your location address.",
					 maxlength: "You need to use at most 254 characters for your location address.",
				},
				<%=ProjConst.LOC_MaxCapacity%>: {
					required: "you mast enter location capacity.",
					numberValidate: "You need to enter a number.",
				},
				<%=ProjConst.LOC_ContactName%>: {
					required: "Required",
				},
				phone1: {
					required: "Required",
					minlength: "You need to use at least 9 characters for your location phone.",
					maxlength: "You need to use at most 15 characters for your location phone.",
				},
				phone2: {
					required: "Required",
					minlength: "You need to use at least 9 characters for your location phone.",
					maxlength: "You need to use at most 15 characters for your location phone.",
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
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_LOCATIONS).toString() %>
<div id="content">
	<div class="pageTitle">
		<%  String locName = request.getParameter("locName");
			String action = request.getParameter("action");
		   Boolean isTrue = action.equals(ProjConst.EDIT);
		   Location location = new Location();
		
		   if (isTrue)
		   {
			   location = LocationDao.getInstance().getLocationByName(locName);
		   }
		%>
		<div class="operation" style="display:none;"><%=request.getParameter("action")%></div>
		<div class="locBeforeHidden" style="display:none;"><%=request.getParameter("locName")%></div>
		<% if (action.equals(ProjConst.ADD)) {%>
		<div class="titleMain ">Add location</div>
		<div style="clear: both;"></div>
		<div class="titleSeparator"></div>
		<div class="titleSub">Add a new location</div>
		<% } else {%>
		<div class="titleMain ">Edit location</div>
		<div style="clear: both;"></div>
		<div class="titleSeparator"></div>
		<div class="titleSub">Edit existing location</div>
		<%} %>
	</div>
	<div id="vn_mainbody">
		<div class="formtable_wrapper">
			<form id="locationAddEditForm">
				<table class="formtable" cellspacing="0" cellpadding="0" border="0">
					<thead>
						<tr>
							<% if (action.equals(ProjConst.EDIT)) {%>
							<th class="header" colspan="2"><strong>Edit location</strong>
								<br></th>
							<% } else {%>
							<th class="header" colspan="2"><strong>Create a new
									location</strong> <br></th>
							<%} %>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="labelcell required"><label
								for="<%=ProjConst.LOC_NAME%>"> Location name: <em>*</em>
							</label></td>
							<% if (action.equals(ProjConst.EDIT)) {%>
								<td class="inputcell">
								<span id="<%=ProjConst.LOC_NAME%>"><%=location.getName()%></span>
								<div></div></td>
							<% } else {%>
								<td class="inputcell"><input id="<%=ProjConst.LOC_NAME%>"
								type="text" name="<%=ProjConst.LOC_NAME%>">
								<div></div></td>
							<%} %>
						</tr>
						<tr>
							<td class="labelcell required"><label
								for="<%=ProjConst.LOC_MaxCapacity%>"> Location max capacity: <em>*</em>
							</label></td>
							<% if (action.equals(ProjConst.EDIT)) {%>
								<td class="inputcell"><textarea
								id="<%=ProjConst.LOC_MaxCapacity%>" name="<%=ProjConst.LOC_MaxCapacity%>"><%=location.getMaxCapacity()%></textarea>
								<div></div></td>
							<% } else {%>
								<td class="inputcell"><textarea id="<%=ProjConst.LOC_MaxCapacity%>" name="<%=ProjConst.LOC_MaxCapacity%>"></textarea>
								<div></div></td>
							<%} %>
						</tr>
						<tr>
							<td class="labelcell required"><label
								for="<%=ProjConst.LOC_Address%>"> Location address: <em>*</em>
							</label></td>
							<% if (action.equals(ProjConst.EDIT)) {%>
								<td class="inputcell"><textarea
								id="<%=ProjConst.LOC_Address%>" name="<%=ProjConst.LOC_Address%>"><%=location.getAddress()%></textarea>
								<div></div></td>
							<% } else {%>
								<td class="inputcell"><textarea
								id="<%=ProjConst.LOC_Address%>" name="<%=ProjConst.LOC_Address%>"></textarea>
								<div></div></td>
							<%} %>
						</tr>
						<tr>
							<td class="labelcell required"><label
								for="<%=ProjConst.LOC_ContactName%>"> Location Contact name: <em>*</em>
							</label></td>
							<% if (action.equals(ProjConst.EDIT)) {%>
								<td class="inputcell">
								<textarea id="<%=ProjConst.LOC_ContactName%>" name="<%=ProjConst.LOC_ContactName%>"><%=location.getContactName()%></textarea>
								<div></div></td>
							<% } else {%>
								<td class="inputcell"><textarea id="<%=ProjConst.LOC_ContactName%>" name="<%=ProjConst.LOC_ContactName%>"></textarea>
								<div></div></td>
							<%} %>
						</tr>
						<tr>
							<td class="labelcell required"><label
								for="<%=ProjConst.LOC_Phone%>"> Location Phone: <em>*</em>
							</label></td>
							<% if (action.equals(ProjConst.EDIT)) {%>
								<td class="inputcell"><textarea
								id="<%=ProjConst.LOC_Phone%>" name="<%=ProjConst.LOC_Phone%>"><%=location.getPhone1()%></textarea>
								<div></div></td>
							<% } else {%>
								<td class="inputcell"><textarea id="<%=ProjConst.LOC_Phone%>" name="<%=ProjConst.LOC_Phone%>"></textarea>
								<div></div></td>
							<%} %>
						</tr>		
						<tr>
						<td class="labelcell required"><label
								for="<%=ProjConst.LOC_Phone2%>"> Location Phone 2: <!-- <em>*</em> -->
							</label></td>
							<% if (action.equals(ProjConst.EDIT)) {%>
								<td class="inputcell"><textarea
								id="<%=ProjConst.LOC_Phone2%>" name="<%=ProjConst.LOC_Phone2%>"><%=location.getPhone2()%></textarea>
								<div></div></td>
							<% } else {%>
								<td class="inputcell"><textarea id="<%=ProjConst.LOC_Phone2%>" name="<%=ProjConst.LOC_Phone2%>"></textarea>
								<div></div></td>
							<%} %>
						</tr>		

						<tr>
							<td></td>
							<td class="inputcell">
								<div class="buttons">
									<button id="createButton" type="submit">
										<img class="img_png" width="16" height="16" alt=""
											src="/conf4u/resources/imgs/table_save.png"> Save
									</button>
									<a id="cancelButton" href="#"
										onClick="window.location.reload( true )"> <img
										class="img_png" width="16" height="16" alt=""
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

</body>
</html>