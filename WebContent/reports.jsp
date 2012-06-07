<%@ page language="java" contentType="text/html; charset=windows-1255"
    pageEncoding="windows-1255"%>
    <%@page import="utils.*"%>
    <%@page import="model.*"%>
    <%@ page import="java.util.List"%>
   <%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
   
    <%@page import="daos.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1255">
<title>Insert title here</title>
</head>
<body>
<div id="body_wrap">
<%= UiHelpers.GetAllJsAndCss().toString() %>
<%= UiHelpers.GetHeader(SessionUtils.getUser(request)).toString() %>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_REPORTS).toString() %>

		<div id="content">
			<div class="pageTitle">
				<div class="titleMain ">Reports</div>
				<br />
				<div style="clear: both;"></div>
				<div class="titleSeparator"></div>
				<div class="titleSub">View custom reports</div>
			</div>

			<div id="vn_mainbody">
			
			
				<!-- Filter : 
	--------------------------------------->	
		<tr>
			<td>
				<table class="filtersAndApllyTable">
					<tr>
						<td>
							<table class="filtersTable" >
								<tr id="filterTableRow1">
									<td>
										<input type="radio" id="filter1" name="usersFilter" value="fiter1" checked/> 
									</td>
									<td>
										<select id="userGeneralFilter">
												<option selected="selected" value="active">Active Users</option>
												<option value="nonActive">Non Active Users</option>
												<option value="admin">Admin Users</option>
												<option value="all">All Users</option>
										</select>
									</td>
								</tr>
								<tr id="filterTableRow2">
									<td><input type="radio"  id="filter2" name="usersFilter" value="filter2" /> 
									</td>
									<td> User Role:
										<select id="roleFilter">
												<option value="PARTICIPANT">Participant</option>
												<option value="SPEAKER">Speaker</option>
												<option value="RECEPTIONIST">Receptionist</option>
												<option value="CONF_MNGR">Conference Manager</option>
										</select> 
										in Conference:
										<select id="confFilter">
										<%
											List<Conference> confrences = ConferenceDao.getInstance().getConferences(ConferencePreDefinedFilter.ALL);
											for(Conference conf : confrences){
										%>
											 	<option value="<%=conf.getConferenceId()%>" > <%=conf.getName()%> </option>
										<%
											}
										%>
										</select>
									</td>
								</tr>
							</table>
						</td>
						<td>
							<div class="buttons">
								<a id="apply"> 
									<img src="/conf4u/resources/imgs/yes_green.png"> Apply
								</a>
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
		
	<!-- Filter end 
	--------------------------------------->	
			
			</div>
		</div>
	</div>

</body>
</html>