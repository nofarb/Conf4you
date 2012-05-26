<%@page import="model.*"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
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
<script type="text/javascript" src="js/jquery.floatingmessage.js"></script>

<script type="text/javascript">	
$(document).ready(function(){
	
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
								 	   	window.location = "conference.jsp";
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
					},
					Cancel: function() {
						$( this ).dialog( "close" );
					}
				}
				});
			});
	
		 $('.addParticipant').click(function () {
			   $("#addParticipantDialog").dialog("open");
			   $("#userAddFormIframe").attr("src","userAdd.jsp");
		 });
		 
	   $("#addParticipantDialog").dialog({
           autoOpen: false,
           modal: true,
           height: 800,
           width: 800
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
				<td><%=conf.getStartDate()%></td>
			</tr>
			<tr>
				<td>End Date</td>
				<td><%=conf.getEndDate()%></td>
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
			<th>Participated</th>
			<th>Logged in</th>
			<th style="min-width: 50px;"></th>
			<th style="min-width: 50px;"></th>
		</tr>
		</thead>
		<tbody>
			<% 
			List<User> users =  ConferenceDao.getInstance().getAllConferenceParticipants(conf); 
			for (User user : users) { %>
			<tr class="gridRow">
			<td>
			<input class="select_one" type="checkbox" value="<%=user.getUserName()%>" name="userNames">
			</td>
			<td><%=user.getUserName()%></td>
			<td><%=user.getName()%></td>
			<td><%=user.getEmail()%></td>
			<td><%=user.getPasportID()%></td>
			<td align="center">
				<span class="false_status_icon"></span>
			</td>
			<td align="center">
				<span class="false_status_icon"></span>
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
	
	<% if (users.size() != 0) {%>
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
	
	<div id="addParticipantDialog" title="Add participant" style="display:none;">
	    <iframe id="userAddFormIframe" width="100%" height="100%"
	    marginWidth="0" marginHeight="0" frameBorder="0" scrolling="auto"
	    title="Dialog Title">Your browser does not supprt</iframe>
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