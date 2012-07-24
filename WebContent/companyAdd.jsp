<%@page import="java.util.EnumSet"%>
<%@page import="model.CompanyType"%>
<%@page import="model.Conference"%>
<%@page import="model.Location"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.LocationDao"%>
<%@page import="daos.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="model.User"%>
<%@page import="helpers.ProjConst"%>
<%@ page import="helpers.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" href="css/main.css" rel="stylesheet" />
<link type="text/css" href="css/tables/tableList.css" rel="stylesheet" />
<link type="text/css" href="css/cupertino/jquery-ui-1.8.18.custom.css" rel="stylesheet" />
<script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.18.custom.min.js"></script>
<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type="text/javascript" src="js/jquery.floatingmessage.js"></script>
<style type="text/css">
div.message{
    background: transparent url(/conf4u/resources/imgs/msg_arrow.gif) no-repeat scroll left center;
    padding-left: 7px;
}

div.error{
    background-color:#F3E6E6;
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
	var addCompSubmit = function() {
		$.ajax({
            url: "CompanyServlet",
            dataType: 'json',
            async: false,
            type: 'POST',
                data: {
                	"action": "add",
                	<%=ProjConst.COMP_NAME%> : $("#compName").val(),
              	 	<%=ProjConst.COMP_TYPE%> : $("#compType").val()
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
                    	 $.validator.messages.uniqueCompanyeName = value + " is already taken";
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
	 }, "Company name is already exists");
	
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
	
	$("#CompanyAddForm").validate({
		  onkeyup: false,
		  onfocusout: false,
		  submitHandler: function(form) {  
              if ($(form).valid())
              {
            	  addCompSubmit();
              }
              return false;
     		},
		  rules: {
			confName: {
			    required: true,
			    minlength: 4,
			    maxlength: 30,
			    uniqueConferenceName: true,
			  },
			  confDesc: {
			  	required: true,
			    minlength: 4,
			    maxlength: 254,
			  },
			  locations: {
			  	required: true,
			  },
			  startDate: {
			  	required: true,
				date: true,
				//startDateGreaterThanNow: true,
			  },
			  endDate: {
			  	required: true,
			 	date: true,
			 	//endDateValidate:true,
			  },
		  },
		  messages: {
				confName: {
					 required: "Required",
					 minlength: "You need to use at least 4 characters for your Company name.",
					 maxlength: "You need to use at most 30 characters for your Company name.",
					 uniqueConferenceName : "This Company name is already exists",
				},
				confDesc: {
					 required: "Required",
					 minlength: "You need to use at least 4 characters for your Company description.",
					 maxlength: "You need to use at most 254 characters for your Company description.",
				},
				locations: {
					required: "Stand up for your comments or go home.",
				},
				startDate: {
					required: "Required",
					date: "Date format required",
					startDateGreaterThanNow: "Start date must be in the future",
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
});
</script>

</head>

<body>

<%= UiHelpers.GetHeader().toString() %>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_COMPANIES).toString() %>

<div id="content">
<div class="pageTitle">
<div class="titleMain ">Add Company</div>
<div style="clear:both;"></div>
<div class="titleSeparator"></div>
<div class="titleSub">Add a new Company</div>
</div>
<div id="vn_mainbody">
<div class="formtable_wrapper">
<form id="conferenceAddForm">
<table class="formtable" cellspacing="0" cellpadding="0" border="0">
	<thead>
		<tr>
		<th class="header" colspan="2">
		<strong>Create a new Company</strong>
		<br>
		</th>
		</tr>
	</thead>
	<tbody>
	<tr>
		<td class="labelcell required">
			<label for="<%=ProjConst.COMP_NAME%>">
			Company name:
			<em>*</em>
			</label>
		</td>
			<td class="inputcell">
			<input id="<%=ProjConst.COMP_NAME%>" type="text" value="" name="<%=ProjConst.COMP_NAME%>">
			<div></div>
		</td>
	</tr>
		<tr>
		<td class="labelcell required">
			<label for="<%=ProjConst.COMP_TYPE%>">
			Type:
			<em>*</em>
			</label>
		</td>
			<td class="inputcell">
			<select id="<%=ProjConst.COMP_TYPE%>" class="type rdOnlyOnEdit" name="<%=ProjConst.COMP_TYPE%>">
			
			<%
			
			/*
			    enum Day { SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY }

				you can iterate over the weekdays. The EnumSet class provides a static factory that makes it easy:

    			for (Day d : EnumSet.range(Day.MONDAY, Day.FRIDAY))
        		System.out.println(d);

			
			*/
			//List<Location> locations = LocationDao.getInstance().getLocations();
			//for(Location location : locations )
			for (CompanyType companyType : CompanyType.values())
			{
			%>
				<option value="<%=companyType.toString()%>" selected="selected"><%=companyType.toString()%></option>
			<%	} %>
			</select>
			<div></div>
			</td>
	</tr>
	<tr>
	<td></td>
		<td class="inputcell">
			<div class="buttons">
				<button id="createButton" type="submit">
				<img class="img_png" width="16" height="16" alt="" src="/conf4u/resources/imgs/save.png">
				Create
				</button>
				<a id="cancelButton" href="#" onClick="window.location.reload( true )">
				<img class="img_png" width="16" height="16" alt="" src="/conf4u/resources/imgs/cancel.png">
				Cancel
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