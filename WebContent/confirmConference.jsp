<%@page import="model.ConferencesUsers"%>
<%@page import="daos.ConferencesUsersDao"%>
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
	<div id="vn_header_div">
		<div id="vn_header_logo">
		<img width="97" height="56" border="0" src="/conf4u/resources/imgs/conf4u_logo.png" alt="">
		</div>
	</div>
	<div class="pageTitle">
		<% 
			String uuid = request.getParameter("id");
			ConferencesUsers cu = ConferencesUsersDao.getInstance().getConferenceUsersByUUID(uuid);
			Conference conf = cu.getConference();
			Long userId = cu.getUser().getUserId();
		   	String confName = cu.getConference().getName();
		%>

		<div id="<%=ProjConst.OPERATION%>" style="display:none;">confirmArrival</div>
		<div id="<%=ProjConst.USER_ID%>" style="display:none;"><%=userId%></div>
		<div id="<%=ProjConst.CONF_NAME%>" style="display:none;"><%=confName%></div>
		
	</div>
	<div id="vn_mainbody" style="width: 1000px;">
	
	
	
		<table class="confirmTable" cellspacing="0" cellpadding="0" border="0">
					<thead>
						<tr>
							<th class="header" colspan="2">
								<div class="headerPadd">Please confirm your participation :</div>
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="labelDescColumn">
								<label class="descLabel">Name: </label> 
							</td>
							<td class="valueColumn">
								<label class="labelValue"> <%=conf.getName()%> </label> 
							</td>
						</tr>

						<tr>
							<td class="labelDescColumn">
								<label class="descLabel">Description: </label> 
							</td>
							<td class="valueColumn">
								<label class="labelValue"> <%=conf.getDescription()%> </label> 
							</td>
						</tr>

						<tr>
							<td class="labelDescColumn">
								<label class="descLabel"> Location: </label> 
							</td>
							<td class="valueColumn">
								<label class="labelValue"> <%=conf.getLocation().getName()%>, <%=conf.getLocation().getAddress()%> </label> 
							</td>
						</tr>

						<%
							Date start = conf.getStartDate();
							Date end = conf.getEndDate();
							String formattedStart = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss aaa").format(start);
							String formattedEnd = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss aaa").format(end);
						%>

						<tr>
							<td class="labelDescColumn">
								<label class="descLabel"> Start Date: </label> 
							</td>
							<td class="valueColumn">
								<label class="labelValue"> <%= formattedStart %> </label> 
							</td>
						</tr>

						<tr>
							<td class="labelDescColumn">
								<label class="descLabel"> End Date: </label> 
							</td>
							<td class="valueColumn">
								<label class="labelValue"> <%= formattedEnd %> </label> 
							</td>
						</tr>

						<tr valign="middle">
							<td valign="middle">
								<label class="descLabel goingLabel"> Going? </label> 
							</td>
							<td align="center">
								<div>
									<span class="confirmPartButtons">
										<button  class="confirmConfButton vn_iconbutton" id="APPROVED">
										<img class="img_png" width="16" height="16" alt=""
											src="/conf4u/resources/imgs/success.png"> Approve
										</button>
										<button  class="confirmConfButton vn_iconbutton" id="MAYBE" >
										<img class="img_png" width="16" height="16" alt=""
											src="/conf4u/resources/imgs/qm.png"> Maybe
										</button>
										<button  class="confirmConfButton vn_iconbutton" id="DECLINED" >
										<img class="img_png" width="16" height="16" alt=""
											src="/conf4u/resources/imgs/cancel.png"> Decline
										</button>
									</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
	
	</div>
	</div>

	<script type="text/javascript">		
	$(document).ready(function(){
	 	$('.confirmConfButton').click(function () {
	 		var id = this.id;
	 		
			$.ajax({
	            url: "UsersServlet",
	            dataType: 'json',
	            async: false,
	            type: 'POST',
	                data: {
	                	"action": $("#operation").text(),
	                	<%=ProjConst.CONF_NAME%> : $("#confName").text(),
	                	<%=ProjConst.USER_ID%> : $("#userId").text(),
	                	"answer": id
		            },
		        success: function(data) {
		            if (data != null){
						if (data.resultSuccess == "true")
						{
							jSuccess(data.message);
						}
						else
						{
							jError(data.message);
						}
		            }
		        }
		    });
	 	});
	});
	</script>

</body>
</html>