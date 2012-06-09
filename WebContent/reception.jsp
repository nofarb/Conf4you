<%@page import="model.ConferencesUsers"%>
<%@page import="model.ConferenceFilters"%>
<%@page import="java.util.LinkedList"%>
<%@page import="daos.ConferencesUsersDao"%>
<%@page
	import="org.eclipse.jdt.internal.compiler.ast.CompilationUnitDeclaration"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="model.Conference"%>
<%@page import="model.User"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.UserDao"%>
<%@page import="utils.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>
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
	
	$('.apply').click(function () {
		var status = $("#confStatusFilter").val();
		var confName = $("#confNameFilter").val();
		if (status == null || confName == null)
		{
			jError("Some filter input is not correct");
			return;
		}
		window.location = "reception.jsp?filterStatus="+status +"&filterConfName=" + confName;
	 });
	
	$('#search').click(function ()
	{
		//   http://heathesh.com/post/2010/05/06/Filtering-or-searching-an-HTML-table-using-JavaScript.aspx
		//alert("Search");
		//tableSearch.runSearch();
			 
	 });
	
	var getConferenceList = function() {
		var statusFilter = $("#confStatusFilter");
		var nameFilter = $("#confNameFilter");
		$(nameFilter).empty();
		$.ajax({
            url: "ReceptionServlet",
            dataType: 'json',
            async: false,
            type: 'POST',
                data: {
                	"action": "filterChange",
                	"filter": $(statusFilter).val(),
                	"<%=ProjConst.USER_ID%>" : "<%= SessionUtils.getUser(request).getUserId()%>"
                },
            success: function(data) {
                if (data != null)
                {
                	 $.each(data, function(i, item){
                         $(nameFilter).append($("<option></option>").attr("value",item).text(item)); 
                     });
                	
                }
                else
               	{
               		jError("Failed to get conferences name");
               	}
            }
        });
    };
    
    $('#confStatusFilter').change(function()
	{
		getConferenceList();
	}).change();
    
	var updateUsersListAndFilters = function(){
		var filterStatus = "<%=request.getParameter("filterStatus")%>";
		var filterConfName = "<%=request.getParameter("filterConfName")%>";
		
		if (filterStatus == "null")
		{
			window.location = "reception.jsp?filterStatus=CURRENT";
		}
		if (filterStatus != "null" && filterConfName == "null")
		{
			getConferenceList();
			var confName = $("#confNameFilter").val();
			if (confName != null)
			{
				window.location = "reception.jsp?filterStatus=CURRENT&filterConfName=" + confName;
			}
		}
		if (filterStatus != "null" && filterConfName != "null")
		{
			$("#confStatusFilter option[value='" + filterStatus + "']").attr('selected', 'selected');
			$("#confNameFilter option[value='" + filterConfName + "']").attr('selected', 'selected');
		}  	
	};
		
	updateUsersListAndFilters();
	
	tableSearch.init();
});
</script>

<body>
	<div id="body_wrap">
		<% User sessionUser = UserDao.getInstance().getUserById((Long)session.getAttribute(ProjConst.SESSION_USER_ID));%>
		<%= UiHelpers.GetHeader(SessionUtils.getUser(request)).toString()%>
		<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_RECEPTION).toString() %>

		<div id="content">
			<div class="pageTitle">
				<div class="titleMain ">Reception</div>
				<br />
				<div style="clear: both;"></div>
				<div class="titleSeparator"></div>
				<div class="titleSub">Conference Reception</div>
			</div>
			<div class="filterStatusHidden" style="display: none;"><%=request.getParameter("filterStatus")%></div>
			<div class="filterConfNameHidden" style="display: none;"><%=request.getParameter("filterConfName")%></div>
			<div id="vn_mainbody">

				<table>
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
										<table class="filtersTable">
											<tr id="filterTableRow1">
												<td>
													<!-- <input type="radio"  id="filter2" name="usersFilter" value="filter2" /> -->
												</td>
												<td>Conference Status: <select id="confStatusFilter">
														<option value="<%=ConferenceFilters.ConferenceTimeFilter.CURRENT%>">Current</option>
														<option value="<%=ConferenceFilters.ConferenceTimeFilter.FUTURE%>">Future</option>
														<option value="<%=ConferenceFilters.ConferenceTimeFilter.PAST%>">Past</option>
														<option value="<%=ConferenceFilters.ConferenceTimeFilter.ALL%>">All</option>
												</select> 
												Conference Name: <select id="confNameFilter"></select>
												</td>
												<td>
													<div class="buttons">
														<a class="apply" href="javascript:;"> 
															<img src="/conf4u/resources/imgs/yes_green.png"> 
															Apply
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
									--> Search: <input type="text" size="39" maxlength="1000"
													value="" id="textBoxSearch"
													onkeyup="tableSearch.search(event);" /> <!-- <input type="button" value="Search" onclick="tableSearch.runSearch();" />  -->
												</td>
												<td>
													<div class="buttons">
														<a id="search"> <img
															src="/conf4u/resources/imgs/search.png"> Search
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
								<%
									String confName = request.getParameter("filterConfName");								
									if (confName != null && confName != "null") {
									Conference conference = ConferenceDao.getInstance().getConferenceByName(confName);								
									List<ConferencesUsers> conferenceUsersList = ConferencesUsersDao.getInstance().getAllConferenceUsersByConference(conference);
									if (conferenceUsersList.size() > 0) {
								%>

		<div>
			<div class="groupedList">
				<table cellpadding="0" cellspacing="0" border="0" id="table1"
					class="sortable">
					<thead>
						<tr>
							<th class="nosort"><h3>ID</h3></th>
							<th><h3>Name</h3></th>
							<th><h3>Company</h3></th>
							<th><h3>Company Type</h3></th>
							<th><h3>Phone 1</h3></th>
							<th><h3>Phone 2</h3></th>
							<th class="nosort"><h3>Arrived</h3></th>
						</tr>
					</thead>
					<tbody id="tabelData">
						<% 
			String newsDate;
			
			for (ConferencesUsers cu : conferenceUsersList)
			{
				User user = cu.getUser(); 
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
									<td><a class="vn_boldtext"
										href="userDetails.jsp?userId=<%=user.getUserId()%>"> <%=user.getName()%>
									</a></td>
									<td><%=user.getCompany().getName()%></td>
									<td><%=user.getCompany().getCompanyType().toString()%></td>
									<td><%=user.getPhone1()%></td>
									<td><%=user.getPhone2()%></td>
									<td><a class="vn_boldtext"
										href="userDetails.jsp?userId=<%=user.getUserId()%>"> <img
											src="/conf4u/resources/imgs/vn_world.png" alt="">
											Details
									</a></td>
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
				<% } else { %>
					<div>No participants in conference</div>
				<% } %>
			<% } %>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		//define the table search object, which can implement both functions and properties
    	window.tableSearch = {};

    	//initialize the search, setup the current object
	    tableSearch.init = function()
		{
	        //define the properties I want on the tableSearch object
	        this.Rows = document.getElementById('tabelData').getElementsByTagName('TR');
	        this.RowsLength = tableSearch.Rows.length;
	        this.RowsText = [];
	       
	        //loop through the table and add the data to the table search object
	        for (var i = 0; i < tableSearch.RowsLength; i++) {
	            this.RowsText[i] = (tableSearch.Rows[i].innerText) ? tableSearch.Rows[i].innerText.toUpperCase() : tableSearch.Rows[i].textContent.toUpperCase();
	        }
	    };
	    //onlys shows the relevant rows as determined by the search string
        tableSearch.runSearch = function() {
			//get the search term
            this.Term = document.getElementById('textBoxSearch').value.toUpperCase();
           
            //loop through the rows and hide rows that do not match the search query
            for (var i = 0, row; row = this.Rows[i], rowText = this.RowsText[i]; i++)
            {
                row.style.display = ((rowText.indexOf(this.Term) != -1) || this.Term === '') ? '' : 'none';
            }
        };
		
        //handles the enter key being pressed
        tableSearch.search = function(e) 
        {
			//checks if the user pressed the enter key, and if they did then run the search
            var keycode;
            if (window.event)
            {
            	keycode = window.event.keyCode; 
            }
            else if (e)
            {
            	keycode = e.which;
            }
            else { return false; }
            if (keycode == 13) 
            {
                tableSearch.runSearch();
            }
            else { return false; }
        };
	</script>
</body>
</html>