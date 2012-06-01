<%@page import="model.*"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@page import="utils.*"%>

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
		
	 	$('#sendInvitationToSelected').click(function () {
	 		var checkedUserNames = $('input:checkbox[name=userNames]:checked').val();
	 		var success= [];
	 		var failed= [];
	 		for (user in checkedUserNames)
	 		{
	 			$.ajax({
			        url: "ConferenceServlet",
			        dataType: 'json',
			        async: false,
			        type: 'POST',
			            data: {
			            	"action": "sendInvitation",
			            	"confName": $(".confName").text(),
			            	"userName": checkedUserNames
			            },
			        success: function(data) {
			            if (data != null){
							if (data.resultSuccess == "true")
							{
								success.push(user);
							}
							else
							{
								failed.push(user);
							}
			            }
			        }
			    });
	 		}
	 	});
	 	
		$('#deleteSelectedParticipants').click(function () {
		 	//todo
	 	});
	 	
		 $('.deleteConf').click(function () { 
			 $('#dialog-confirm').dialog({
				resizable: false,
				height: 150,
				width: 400,
				modal: true,
				hide: "fade", 
	            show: "fade",
				buttons: {
					"Delete": function() {
						$.ajax({
					        url: "ConferenceServlet",
					        dataType: 'json',
					        async: false,
					        type: 'POST',
					            data: {
					            	"action": "delete",
					            	"confName": $(".confName").text()
					            },
					        success: function(data) {
					            if (data != null){
									if (data.resultSuccess == "true")
									{
								 	   	window.location = "conference.jsp?messageNotification=" + data.message + "&messageNotificationType=success";
									}
									else
									{
										jError(data.message);
									}
					            }
					        }
					    });
					},
					Cancel: function() {
						$( this ).dialog( "close" );
					}
				}
				});
			});
	
		 $('.addParticipant').click(function () {
			   var confName = $(".confName").text();
			   window.location.href = "userAddEdit.jsp?action=addParticipant&confName=" + confName;
		 });
		 
		 $('.assignUser').click(function () {
			   var confName = $(".confName").text();
			   window.location.href = "assignConferenceUser.jsp?confName=" + confName;
		 });
	});	
</script>


</head>

<body>
<%= UiHelpers.GetHeader().toString() %>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_CONFERENCES).toString() %>

<div id="content">
<div class="pageTitle">
<div class="titleMain ">Conference details</div>
<div style="clear:both;"></div>
<div class="titleSeparator"></div>
<div class="titleSub">View, modify, add/remove participants for this conference</div>
</div>
<div id="detailsAndActions">
	<% String confName = request.getParameter("conferenceName");
	   Conference conf = ConferenceDao.getInstance().getConferenceByName(confName);
	%>
	<div class="vn_detailsgeneraltitle">Actions </div>
	<div class="vn_actionlistdiv yui-reset yui-base">
		<div class="vn_actionlistcolumn">
			<div class="vn_actionbuttondiv">
				<div class="title">
				<a title="Edit Conference" href="conferenceAddEdit.jsp?action=edit&confName=<%=confName%>">
					<img src="/conf4u/resources/imgs/vn_action_edit.png" alt=""> 
					Edit
				</a>
				</div>
			</div>
				<div class="vn_actionbuttondiv">
				<div class="title">
				<a class="deleteConf" title="Delete Conference">
					<img src="/conf4u/resources/imgs/vn_action_delete.png" alt=""> 
					Delete
				</a>
				</div>
			</div>
		</div>
	</div>
	<div class="vn_detailsgeneraltitle">Details </div>
	
	<div class="groupedList" style="width: 800px;">
	<table class="vn_envdetails" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
		<% 
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
			String startDateFormatted = sdf.format(conf.getStartDate());
			String endDateFormatted = sdf.format(conf.getEndDate());
		%>
		<tbody>
			<tr>
				<td>Name</td>
				<td class="confName"><%=conf.getName()%></td>
			</tr>
			<tr>
				<td>Location</td>
				<td><%=conf.getLocation().getName()%></td>
			</tr>
			<tr>
				<td>Start Date</td>
				<td><%=startDateFormatted%></td>
			</tr>
			<tr>
				<td>End Date</td>
				<td><%=endDateFormatted%></td>
			</tr>
		</tbody>
	</table>
	</div>
	
	<div style="clear:both"></div>
	<h3> Invited participants</h3>
	
	<table class="groupedList" cellspacing="0" border="0" style="border-collapse:collapse;">
		<thead>
		<tr>
			<th style="width: 22px;">
				<input class="select_all" type="checkbox">
			</th>
			<th>User name</th>
			<th>Name</th>
			<th>Email</th>
			<th>Passport ID</th>
			<th>Invitation sent</th>
			<th>Invitation status</th>
			<th style="min-width: 50px;"></th>
			<th style="min-width: 50px;"></th>
		</tr>
		</thead>
		<tbody>
			<% 
			List<ConferencesUsers> confParticipants =  ConferencesUsersDao.getInstance().getConderenceUsersByType(conf, UserRole.PARTICIPANT); 
			for (ConferencesUsers confPartcipant : confParticipants) { %>
			<tr class="gridRow">
			<td>
			<input class="select_one" type="checkbox" value="<%=confPartcipant.getUser().getUserName()%>" name="userNames">
			</td>
			<td><%=confPartcipant.getUser().getUserName()%></td>
			<td><%=confPartcipant.getUser().getName()%></td>
			<td><%=confPartcipant.getUser().getEmail()%></td>
			<td><%=confPartcipant.getUser().getPasportID()%></td>
			<%
			String invitationSentClassName = "false_status_icon";
			if (confPartcipant.isNotifiedByMail())
			{
				invitationSentClassName = "true_status_icon";
			}
			
			%>
			<td align="center">
				<span class="<%=invitationSentClassName%>"></span>
			</td>
			<%
			UserAttendanceStatus status = confPartcipant.getAttendanceStatus();
			String statusString = "No response";
			if (status != null)
			{
				if (status == UserAttendanceStatus.APPROVED)
					statusString = "Approved";
				if (status ==  UserAttendanceStatus.DECLINED)
					statusString = "Declined";
				if (status == UserAttendanceStatus.MAYBE)
					statusString = "Maybe";
			}
			%>
			<td align="center">
				<span class="status"><%=statusString%></span>
			</td>
			<td>
			<a class="editParticipant" href="javascript:;">
			<img src="/conf4u/resources/imgs/vn_action_edit.png" alt="">
			Edit
			</a>
			</td>
			<td>
			<a class="deleteParticipant"  href="javascript:;">
			<img src="/conf4u/resources/imgs/vn_action_delete.png" alt="">
			Delete
			</a>
			</td>
			</tr>
			<%} %>
		</tbody>
	</table>
	
	<% if (confParticipants.size() != 0) {%>
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
	<%} else { %>
		<div>No participants in the conference</div>
	<% }%>
	
	<div style="padding: 6px 0;">
		<button class="addParticipant" type="button">Add participant</button>
		<button class="assignUser" type="button">Assign user</button>
		<button id="sendInvitationToSelected">
		<img src="/conf4u/resources/imgs/vn_action_email.png" alt="" style="margin-bottom: -2px;">
		&nbsp; Send invitation to selected
		</button>
		<button id="deleteSelectedParticipants" type="button">
		<img src="/conf4u/resources/imgs/vn_action_delete.png" alt="" style="margin-bottom: -2px;">
		&nbsp; Delete selected
		</button>
	</div>
		
	<div id="dialog-confirm" title="Delete conference?" style="display:none;">
		<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Conference will be deleted. Are you sure?</p>
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
		sorter.init("table", 1);
	</script>
	</div>
</div>
</body>
</html>