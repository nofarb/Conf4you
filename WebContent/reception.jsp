<%@page import="java.util.LinkedList"%>
<%@page import="daos.ConferencesUsersDao"%>
<%@page import="org.eclipse.jdt.internal.compiler.ast.CompilationUnitDeclaration"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="model.Conference"%>
<%@page import="model.User"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.UserDao"%>
<%@page import="utils.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%= UiHelpers.GetAllJsAndCss().toString() %>
<script type="text/javascript">

$(document).ready(function(){
	var message = "<%=request.getParameter("messageNotification")%>";
	//$('#confStatusFilter :nth-child(2)').attr('selected', 'selected'); // To select via index
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
	
	$('#apply').click(function () {
		
		var filterRadio = $('input[name=usersFilter]');
		var checkedValue = filterRadio.filter(':checked').val();
		
		if(checkedValue == "fiter1")
		{
			 var selectedFilterVal = $("#userGeneralFilter").val();
			 window.location.href = "users.jsp?filterNum=1&filterBy=" + selectedFilterVal; 
		}
		else //filter 2
		{ 
			 
			 var selectedRole = $("#role").val();
			 var selectedConf = $("#conf").val();
			 window.location.href = "users.jsp?filterNum=2&role=" + selectedRole+"&conf="+selectedConf; 
		 
		}
		
/* 		var checkedValue = myRadio.filter(':checked').val(); */	
 	
	 });
	
	$('#search').click(function ()
	{
			
		alert("Search");
			 
	 });
	
	$('#confStatusFilter').change(function()
	{
		var selectedConfStatusFilter = $("#confStatusFilter").val();
		value = selectedConfStatusFilter;
		key = selectedConfStatusFilter;
		
		$('#confNameFilter').empty().append($("<option></option>").attr("value",key).text(value)); 
		

		
		
	}) .change();
	 
/* 	 var selectedFilter = $('.selectedFilter').text();
	 if (selectedFilter != null && selectedFilter.length != 0)
	 {
		 $("#filterSelect option[value='" + selectedFilter + "']").attr('selected', 'selected');
	 } */
	 
});

</script>
<body>
<div id="body_wrap">

<%= UiHelpers.GetHeader(SessionUtils.getUser(request)).toString() %>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_RECEPTION).toString() %>

<div id="content">
	<div class="pageTitle">
	<div class="titleMain ">Reception</div>
	<br/>
	<div style="clear:both;"></div>
	<div class="titleSeparator"></div>
	<div class="titleSub">Conference Reception</div>
	</div>

	<div id="vn_mainbody">
	
	<table >
		<tr>
			<td>
			<!-- 
				<div class="buttons">
					<a id="createNewUser" href="userAddEdit.jsp?action=add">
					<span></span>
					<img src="/conf4u/resources/imgs/vn_action_add.png">
					Add User
					</a>
				</div>
				 -->
			</td>
		</tr>
	
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
									<!-- <input type="radio"  id="filter2" name="usersFilter" value="filter2" /> --> 
									</td>
									<td> Conference Status:
										<select id="confStatusFilter">
												<option value="ACTIVE">Active</option>
												<option value="FUTURE">Future</option>
												<option value="PAST">Past</option>
												<option value="ALL">All</option>
										</select> 
										Conference Name:
										<select id="confNameFilter">
										<%
											List<Conference> confrences = ConferenceDao.getInstance().getConferences(ConferencePreDefinedFilter.ACTIVE);
											for(Conference conf : confrences){
										%>
											 	<option value="<%=conf.getConferenceId()%>" > <%=conf.getName()%> </option>
										<%
											}
										%>
										</select>
									</td>
									<td>
										<div class="buttons">
											<a id="apply"> 
											<img src="/conf4u/resources/imgs/yes_green.png"> Apply
											</a>
										</div>
									</td>
								</tr>
								<tr id="filterTableRow2">
									<td>
										<!-- <input type="radio" id="filter1" name="usersFilter" value="fiter1" checked/> --> 
									</td>
									<td>
									<!-- 
										<select id="userGeneralFilter">
												<option selected="selected" value="all">All Users</option>
												<option value="active">Active Users</option>
												<option value="nonActive">Non Active Users</option>
												<option value="admin">Admin Users</option>
										</select>
									-->
										Search:
										<input type="text" size="39" maxlength="1000" value="" id="textBoxSearch" onkeyup="tableSearch.search(event);" />
                    					<!-- <input type="button" value="Search" onclick="tableSearch.runSearch();" />  -->
									</td>
									<td>
										<div class="buttons">
											<a id="search"> 
											<img src="/conf4u/resources/imgs/search.png"> Search
											</a>
										</div>
									</td>
								</tr>
							</table>
						</td>
						
					</tr>
				</table>
			</td>
		</tr>
	</table>
		
	<!-- Filter end 
	--------------------------------------->	
	
	
	<div>
	<div class="groupedList">
	<table cellpadding="0" cellspacing="0" border="0" id="table1"
		class="sortable">
		<thead>
			<tr>
				<th  class="nosort"><h3>ID</h3></th>
				<th><h3>Name</h3></th>
				<th><h3>Company</h3></th>
				<th><h3>Company Type</h3></th>
				<th><h3>Phone 1</h3></th>
				<th><h3>Phone 2</h3></th>
				<th class="nosort"><h3>Arrived</h3></th>
			</tr>
		</thead>
		<tbody id="data">
			<% 
			// !!! javascript table search http://heathesh.com/post/2010/05/06/Filtering-or-searching-an-HTML-table-using-JavaScript.aspx !!! //
			List <User> usersList = new LinkedList <User>();
			usersList = UserDao.getInstance().getUsers();
			//List<ConferenceParticipantStatus> confParticipants = ConferenceDao.getInstance().getAllConferenceParticipants(conference);
			
			/*String filterNumber = request.getParameter("filterNum");
			if(filterNumber != null){
				if(filterNumber.trim().equals("1")){
					String filterBy = request.getParameter("filterBy");
					
					if(filterBy != null){
						if(filterBy.equals("all")){
							usersList = UserDao.getInstance().getUsers();
						}
						else if(filterBy.equals("active")){
							usersList = UserDao.getInstance().getActiveUsers();
						}
						else if(filterBy.equals("nonActive")){
							usersList = UserDao.getInstance().getNonActiveUsers();
						}else{ //admin
							usersList = UserDao.getInstance().getAdmineUsers();
						}
						
					}else{
						usersList = UserDao.getInstance().getUsers();
					}

				}else{ //it's 2
					
				}
				
			}else{
				usersList = UserDao.getInstance().getUsers();
			}
			*/
			String newsDate;
			
			for (User user : usersList )
			{
				Date date = user.getLastLogin();
				if(date != null){
					newsDate = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss aaa").format(date);
				}else{
					newsDate = "";
				}
			%>
			<tr class="gridRow">
				<!-- <td><%=user.getName()%></td>  -->
				<td><%=user.getPasportID()%></td>
				<td><a class="vn_boldtext"href="userDetails.jsp?userId=<%=user.getUserId()%>"> <%=user.getName()%> </a> </td>
				<td><%=user.getCompany().getName()%></td>
				<td><%=user.getCompany().getCompanyType().toString()%></td>
				<td><%=user.getPhone1()%></td>
				<td><%=user.getPhone2()%></td>
				<td><a class="vn_boldtext"href="userDetails.jsp?userId=<%=user.getUserId()%>"> <img src="/conf4u/resources/imgs/vn_world.png" alt=""> Details </a> </td>
			</tr>
			<%	} %>
		</tbody>
	</table>
	<div id="controls">
		<div id="perpage">
			<select onchange="sorter.size(this.value)">
				<option value="5">5</option>
				<option value="10" selected="selected">10</option>
				<option value="20">20</option>
				<option value="50">50</option>
				<option value="100">100</option>
			</select> <span>Entries Per Page</span>
		</div>
		<div id="navigation">
			<img src="css/tables/images/first.gif" width="16" height="16"
				alt="First Page" onclick="sorter.move(-1,true)" /> <img
				src="css/tables/images/previous.gif" width="16" height="16"
				alt="First Page" onclick="sorter.move(-1)" /> <img
				src="css/tables/images/next.gif" width="16" height="16"
				alt="First Page" onclick="sorter.move(1)" /> <img
				src="css/tables/images/last.gif" width="16" height="16"
				alt="Last Page" onclick="sorter.move(1,true)" />
		</div>
		<div id="text">
			Displaying Page <span id="currentpage"></span> of <span
				id="pagelimit"></span>
		</div>
	</div>

	<script type="text/javascript" src="js/tables/script.js"></script>
	<script type="text/javascript">
		var sorter = new TINY.table.sorter("sorter");
		sorter.head = "head";
		sorter.asc = "asc";
		sorter.desc = "desc";
		sorter.even = "evenrow";
		sorter.odd = "oddrow";
		sorter.evensel = "evenselected";
		sorter.oddsel = "oddselected";
		sorter.paginate = true;
		sorter.currentid = "currentpage";
		sorter.limitid = "pagelimit";
		sorter.init("table1", 1);
	</script>
</div>
</div>
</div>
</div>
</div>
</body>
</html>