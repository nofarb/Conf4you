<%@page import="daos.ConferencesParticipantsDao"%>
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@page import="helpers.*"%>

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
               		jError("No conference found in this status" );
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
		var filterArrived = "<%=request.getParameter("filterArrived")%>";
		
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
			getConferenceList();
			$("#confNameFilter option[value='" + filterConfName + "']").attr('selected', 'selected');
		}
		if (filterArrived != "null")
		{
			$("#filterSelect option[value='" + filterArrived + "']").attr('selected', 'selected');
		}
	};
		
	updateUsersListAndFilters();
	
	$('input#search').quicksearch('table#table1 tbody tr');
	
	 if ($(".evenrow")[0]){
		 sorter.size(10);
		}
});
</script>
<body>
	<div id="body_wrap">
		<% User viewingUser = SessionUtils.getUser(request); %>
		<% 
		getServletContext().setAttribute("retUrl", request.getRequestURL().toString());
		%>

		<%= UiHelpers.GetHeader(SessionUtils.getUser(request)).toString()%>
		<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_RECEPTION).toString() %>

		<div id="content">
			<div class="pageTitle">
				<div class="titleMain ">Reception</div>
				<br />
				<div style="clear: both;"></div>
				<div class="titleSeparator"></div>
				<div class="titleSub">Conference Reception
				<span class="printing" style="display: none; padding-left: 470px;">
					<img src="/conf4u/resources/imgs/loadinfo.gif" /> In printing progress...
				</span>
				</div>

			<div class="filterStatusHidden" style="display: none;"><%=request.getParameter("filterStatus")%></div>
			<div class="filterConfNameHidden" style="display: none;"><%=request.getParameter("filterConfName")%></div>
			<div id="vn_mainbody">

				<table>
					<tr>
						<td>
							<!-- Filter : --------------------------------------->
					<tr>
						<td>
							<table class="filtersAndApllyTable">
								<tr>
									<td>
										<table class="filtersTable">
											<tr id="filterTableRow1">
												<td>Conference Status: <select id="confStatusFilter">
														<option
															value="<%=ConferenceFilters.ConferenceTimeFilter.CURRENT%>">Current</option>
														<option
															value="<%=ConferenceFilters.ConferenceTimeFilter.PAST%>">Past</option>
														<option
															value="<%=ConferenceFilters.ConferenceTimeFilter.ALL%>">All</option>
												</select> Conference Name: <select id="confNameFilter"></select>
												</td>
												<td>
													<div class="buttons">
														<a class="apply" href="javascript:;"> <img
															src="/conf4u/resources/imgs/apply.png"> Apply
														</a>
													</div>
												</td>
											</tr>
											<tr id="filterTableRow2">
												<td>
													Search: <input type="text" id="search" style="width: 130px">
													Show:
													<select id="filterSelect">
														<option value="NotArrived">Not Arrived</option>
														<option value="Arrived">Arrived</option>
														<option value="ALL" selected="selected">All</option>
													</select>
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>

				<!-- Filter end --------------------------------------->
				<%
			String confName = request.getParameter("filterConfName");
			String arrivedFilter = request.getParameter("filterArrived"); 
			if (confName != null && confName != "null") {
				Conference conference = ConferenceDao.getInstance().getConferenceByName(confName);								
				List<ConferenceUsersArivalHelper> conferenceParticipantsList = ConferencesParticipantsDao.getInstance().getAllParticipantsByConferenceAndIfArrivedToDay(conference, arrivedFilter);
					if (conferenceParticipantsList != null && conferenceParticipantsList.size() > 0) 
					{
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
								<th class="nosort"></th>
							</tr>
						</thead>
						<tbody id="tabelData">
							<% 
							String newsDate;
							
							for (ConferenceUsersArivalHelper cua : conferenceParticipantsList)
							{
								User user = cua.getConferenceUser().getUser(); 
								Date date = user.getLastLogin();
								if(date != null)
								{
									newsDate = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss aaa").format(date);
								}
								else
								{
									newsDate = "";
								}
							%>
							<tr class="gridRow">

								<td><%=user.getPasportID()%></td>
								<td><span id="userId" class="<%=user.getUserId()%>"><%=user.getName()%></span></td>
								<td><%=user.getCompany().getName()%></td>
								<td width="10%"><%=user.getCompany().getCompanyType().toString()%></td>
								<td><%=user.getPhone1()%></td>
								<td><%=user.getPhone2()%></td>
								<td width="4%" align="center">
									<%
								if (cua.isArived())
								{
								%> <img src="/conf4u/resources/imgs/apply.png"> <%}
								else
								{ %> <img src=/conf4u/resources/imgs/cancel.png> <%} %>
								</td>
								<td style="width: 150px;">
									<% if (cua.isArived()) {
									%> <a class="vn_boldtext removePartArival" href="javascript:;">
										<img src="/conf4u/resources/imgs/details.png"> Update
								</a> <% } else { %> <a class="vn_boldtext updateArival"
									href="javascript:;"> <img
										src=/conf4u/resources/imgs/details.png> Update
								</a> <% } %> <a href="javascript:;" class="vn_boldtext print"
									style="padding-left: 5px;"> <img alt=""
										src="/conf4u/resources/imgs/print.gif"> Print
								</a>
								</td>
							</tr>
							<% } %>

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
				</div>
			</div>
			<div id="dialogConfirmRemoveParticipant" title="Cancel participant Arrival from conference?" style="display: none;">
				<p>
					<span class="ui-icon ui-icon-alert"
						style="float: left; margin: 0 7px 20px 0;"></span>Cancel
					participant Arrival. Are you sure?
				</p>
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
			<% } else { %>
			<div>No participants in conference</div>
			<% } }%>
		</div>
	</div>
</div>
	<script type="text/javascript">
		 $('#filterSelect').change(function () {
			 var status = $("#confStatusFilter").val();
			 var confName = $("#confNameFilter").val();
			 var selectedFilter = $("#filterSelect").val();
			 window.location.href = "reception.jsp?filterStatus="+status +"&filterConfName=" + confName + "&filterArrived=" + selectedFilter;
		 });
		 
		 var selectedFilter = $('.selectedFilter').text();
		 if (selectedFilter != null && selectedFilter.length != 0)
		 {
			 $("#filterSelect option[value='" + selectedFilter + "']").attr('selected', 'selected');
		 }
	 
		$('.print').click(function () {
			$print = $(this);
			var status = $("#confStatusFilter").val();
			var confName = $("#confNameFilter").val();
			
			$('.printing').show();
			
			$.ajax({
	            url: "ReceptionServlet",
	            dataType: 'json',
	            async: false,
	            type: 'POST',
	                data: {
	                	"action": "print",
	                	"userId" : $print.closest('tr').find('span#userId').attr('class'),
	                	"<%=ProjConst.CONF_NAME%>" : "<%=request.getParameter("filterConfName")%>"
	                },
	            success: function(data) {
	            	if (data != null){
		            	if (data.resultSuccess == "true")
						{
		            		$('.printing').hide();
					 	   	window.location = "reception.jsp?filterStatus=" +status + "&filterConfName=" + confName + "&messageNotification=" + data.message + "&messageNotificationType=success";
						}
						else
						{
							$('.printing').hide();
							jError(data.message);
						}
		            }
	            }
	        });
		 });

		$('.updateArival').click(function () {
			$updateArrival = $(this);
			var status = $("#confStatusFilter").val();
			var confName = $("#confNameFilter").val();
			
			$.ajax({
	            url: "ReceptionServlet",
	            dataType: 'json',
	            async: false,
	            type: 'POST',
	                data: {
	                	"action": "updateUserArrival",
	                	"userId" : $updateArrival.closest('tr').find('span#userId').attr('class'),
	                	"<%=ProjConst.CONF_NAME%>" : "<%=request.getParameter("filterConfName")%>"
	                },
	            success: function(data) {
	            	if (data != null){
		            	if (data.resultSuccess == "true")
						{
					 	   	window.location = "reception.jsp?filterStatus=" +status + "&filterConfName=" + confName + "&messageNotification=" + data.message + "&messageNotificationType=success";
						}
						else
						{
							jError(data.message);
						}
		            }
	            }
	        });
		 });
		
		 $('.removePartArival').click(function () { 
			 var $RemoveParticipant = $(this);
			 var status = $("#confStatusFilter").val();
			 var confName = $("#confNameFilter").val();
			 
			 $('#dialogConfirmRemoveParticipant').dialog({
				resizable: false,
				height: 150,
				width: 400,
				modal: true,
				hide: "fade", 
	            show: "fade",
				buttons: {
					"Remove": function() {
						$.ajax({
					        url: "ReceptionServlet",
					        dataType: 'json',
					        async: false,
					        type: 'POST',
					            data: {
					            	"action": "removeUserArrival",
					            	"userId" : $RemoveParticipant.closest('tr').find('span#userId').attr('class'),
					            	"<%=ProjConst.CONF_NAME%>" : "<%=request.getParameter("filterConfName")%>"
									},
									success : function(
											data)
									{
										if (data != null)
										{
											if (data.resultSuccess == "true")
											{
												window.location = "reception.jsp?filterStatus=" + status + "&filterConfName=" + confName + "&messageNotification=" + data.message + "&messageNotificationType=success";
											}
											else
											{
												$(this).dialog("close");
												jError(data.message);
											}
										}
									}
								});
								},
								Cancel : function()
								{
									$(this).dialog("close");
								}
							}
						});
					});
	</script>
</body>
</html>