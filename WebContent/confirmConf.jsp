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

<div id="content">
	<div class="pageTitle">
	
		<% 
			String userId = request.getParameter("userId");
		   	String confName = request.getParameter("confName");
		   	Conference conf = ConferenceDao.getInstance().getConferenceByName(confName);
		%>

	</div>
	<div id="vn_mainbody">
		<div class="formtable_wrapper">
			<form id="conferenceAddEditForm">
				<table class="formtable" cellspacing="0" cellpadding="0" border="0">
					<thead>
						<tr>
							<th class="header" colspan="2"><strong>Confirm Participation</strong> <br></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>
								<label>Conference name: </label> 
							</td>
							<td>
								<label> <%=conf.getName()%> </label> 
							</td>
						</tr>
						
						<tr>
							<td>
								<label>Conference description: </label> 
							</td>
							<td>
								<label> <%=conf.getDescription()%> </label> 
							</td>
						</tr>
			
						<tr>
							<td>
								<label> Location: </label> 
							</td>
							<td>
								<label> <%=conf.getLocation().getName() %> </label> 
							</td>
						</tr>
						
						
						<%
						Date start = conf.getStartDate();
						Date end = conf.getEndDate();
						String formattedStart = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss aaa").format(start);
						String formattedEnd = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss aaa").format(end);
						%>

						<tr>
							<td>
								<label> Start Date: </label> 
							</td>
							<td>
								<label> <%= formattedStart %> </label> 
							</td>
						</tr>
						
						<tr>
							<td>
								<label> End Date: </label> 
							</td>
							<td>
								<label> <%= formattedEnd %> </label> 
							</td>
						</tr>
						
						<tr>
							<td></td>
							<td class="inputcell">
								<div class="buttons">
									<button id="createButton" type="submit">
										<img class="img_png" width="16" height="16" alt=""
											src="/conf4u/resources/imgs/table_save.png"> Save
									</button>
									<a id="cancelButton" href="">
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
	
	$(document).ready(function(){
		
		var sendResponse = function() {
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
	<%-- 						
							<%if (isEdit) {%>
								params = "?conferenceName=" +$("#confName").val() + "&messageNotification=" + data.message + "&messageNotificationType=success";
							<% } else {%>
								params = "?messageNotification=" + data.message + "&messageNotificationType=success";						
							<% } %>
							 --%>
							returnUrl = "";
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
		
	});
	</script>

</body>
</html>