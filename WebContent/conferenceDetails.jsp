<%@page import="model.*"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
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
		
		$('input#search').quicksearch('table#table2 tbody tr');
});
</script>
</head>

<body>
<% User viewingUser = SessionUtils.getUser(request); %>
<% 
//If user got to not allowed page
String retUrl = (String)getServletContext().getAttribute("retUrl");
if (!viewingUser.isAdmin())
{
	if (ConferencesUsersDao.getInstance().getUserHighestRole(viewingUser) == null || ConferencesUsersDao.getInstance().getUserHighestRole(viewingUser).getValue() < UserRole.CONF_MNGR.getValue())
		response.sendRedirect(retUrl);
}

getServletContext().setAttribute("retUrl", request.getRequestURL().toString());
%>
<%= UiHelpers.GetHeader(viewingUser).toString() %>
<%= UiHelpers.GetTabs(viewingUser, ProjConst.TAB_CONFERENCES).toString() %>

<div id="content">
<div class="pageTitle">
<div class="titleMain ">Conference details</div>
<div style="clear:both;"></div>
<div class="titleSeparator"></div>
<div class="titleSub">View, modify, add/remove participants for this conference
	<span class="sendingInvitations" style="display: none; padding-left: 300px;">
		<img src="/conf4u/resources/imgs/loadinfo.gif" /> Sending invitations...
	</span>
</div>
</div>
<div id="detailsAndActions">
	<% String confName = request.getParameter("conferenceName");
	   Conference conf = ConferenceDao.getInstance().getConferenceByName(confName);
	%>
	<% if (viewingUser.isAdmin()) {%>
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
	<%} %>
	<div class="vn_detailsgeneraltitle">Details </div>
	
	<div class="groupedList" style="width: 800px;">
	<table class="vn_envdetails" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
		<% 
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy kk:mm");
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
				<td><a class="vn_boldtext" href="LocationDetails.jsp?locName=<%=conf.getLocation().getName()%>"><%=conf.getLocation().getName()%></a></td>
			</tr>
			<tr>
				<td>Start Date</td>
				<td><%=startDateFormatted%></td>
			</tr>
			<tr>
				<td>End Date</td>
				<td><%=endDateFormatted%></td>
			</tr>
			<% List<ConferencesUsers> confUsers = ConferencesUsersDao.getInstance().getAllConferenceUsersByConference(conf); %>
			<tr>
				<td>Speakers</td>
				<td>
				<%  
					for (ConferencesUsers cu : confUsers) {
						String url = UiHelpers.GetUserDetailsUrl(cu.getUser().getUserId());
						String role = UserRole.resolveUserRoleToFriendlyName(cu.getUserRole());
						if (cu.getUserRole() != UserRole.PARTICIPANT.getValue() && cu.getUserRole() == UserRole.SPEAKER.getValue()) {
						%>
							<div><a href="<%=url%>"><%=cu.getUser().getUserName()%></a></div>
						<% } %>
					<% } %>
				</td>
			</tr>
			<tr>
				<td>Receptionists</td>
				<td> 
					<% for (ConferencesUsers cu : confUsers) {
						String url = UiHelpers.GetUserDetailsUrl(cu.getUser().getUserId());
						String role = UserRole.resolveUserRoleToFriendlyName(cu.getUserRole());
						if (cu.getUserRole() != UserRole.PARTICIPANT.getValue() && cu.getUserRole() == UserRole.RECEPTIONIST.getValue()) {
						%>
							<div><a href="<%=url%>"><%=cu.getUser().getUserName()%></a></div>
						<% } %>
					<% } %>
				</td>
			</tr>
			<tr>
				<td>Conference Managers</td>
				<td>
				<% 
					for (ConferencesUsers cu : confUsers) {
						String url = UiHelpers.GetUserDetailsUrl(cu.getUser().getUserId());
						String role = UserRole.resolveUserRoleToFriendlyName(cu.getUserRole());
						if (cu.getUserRole() != UserRole.PARTICIPANT.getValue() && cu.getUserRole() == UserRole.CONF_MNGR.getValue()) {
						%>
							<div><a href="<%=url%>"><%=cu.getUser().getUserName()%></a></div>
						<% } %>
					<% } %>
				</td>
			</tr>
		</tbody>
	</table>
	</div>
	<div style="clear:both"></div>
	
	<div class="vn_tblheadzone buttons" style="width: 1000px; margin-top: 15px;" >
		
		<span style="font-size: 14px; font-weight: bold;">Invited participants</span>
		
		<span id="vn_mainbody_filter">
			Search:
   			<input type="text" id="search">
		</span>
	</div>
	
	<div>
	<div class="groupedList" style="width: 1000px;">
	<table class="sortable" id="table2" cellspacing="0" border="0">
		<thead>
		<tr>
			<th class="nosort">
				<input class="select_all" type="checkbox" title="Select all">
			</th>
			<th>User name</th>
			<th>Name</th>
			<th>Email</th>
			<th>Passport ID</th>
			<th class="nosort" style="width: 11%">Invitation sent</th>
			<th>Attendance status</th>
			<th class="nosort"></th>
		</tr>
		</thead>
		<tbody>
			<% 
			List<ConferencesUsers> confParticipants =  ConferencesUsersDao.getInstance().getConferenceUsersByType(conf, UserRole.PARTICIPANT); 
			for (ConferencesUsers confPartcipant : confParticipants) { %>
			<tr class="gridRow">
			<td>
				<input class="checkboxUserName" id="select_one" type="checkbox" value="<%=confPartcipant.getUser().getUserName()%>" name="userNames">
			</td>
			<td id="userNameTd"><%=confPartcipant.getUser().getUserName()%></td>
			<td><a class="vn_boldtext" href="userDetails.jsp?userId=<%=confPartcipant.getUser().getUserId()%>"><%=confPartcipant.getUser().getName()%></a></td>
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
			<td id="attendanceTd" style="width: 200px;">
				<span id="participiationStatus" class="<%=status%>"><%=statusString%></span>
				
				<span class="editPartStatus" style="display: none;">
				 	<select class="attendanceStatusSelectList">
				 		<option value="NOTSELECTED" selected="selected">--Not Selected--</option>
					 	<option value="APPROVED">Approved</option>
					 	<option value="MAYBE">Maybe</option>
					 	<option value="DECLINED">Declined</option>
				 	</select>
			 	</span>
				
				<span class="savePartStatus" title="Save participant status" style="cursor: pointer; display: none; float: right; margin-right: 5px;">
					<img src="/conf4u/resources/imgs/save.ico" alt="">
				</span>
				<span class="cancelPartStatusSave" title="Cancel participant status edit" style="cursor: pointer; display: none; float: right; margin-right: 10px;">
					<img src="/conf4u/resources/imgs/cancel.ico" alt="">
				</span>
				<span class="editStatus" title="Edit participant status" style="cursor: pointer; float: right;margin-right: 5px;">
					<img src="/conf4u/resources/imgs/edit.ico" alt="">
				</span>
			</td>
			<td>
			<a class="removePart" href="javascript:;">
			<img src="/conf4u/resources/imgs/vn_action_delete.png" alt="">
			Remove
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
		sorter.init("table2", 2);
	</script>
	<%} else { %>
		<div>No participants in the conference</div>
	<% }%>
	</div>
	<div style="padding: 10px 0 30px;">
		<div class="buttons">
		<a class="addParticipant" type="button">
		<img src="/conf4u/resources/imgs/vn_action_add.png" alt="" style="margin-bottom: -2px;">
		Add participant
		</a>
		</div>
		<div class="buttons">
		<a class="assignUser" type="button">
		<img src="/conf4u/resources/imgs/assign.png" alt="" style="margin-bottom: -2px;">
		Assign user</a>
		</div>
		<div class="buttons">
		<a id="sendInvitationToSelected">
		<img src="/conf4u/resources/imgs/vn_action_email.png" alt="" style="margin-bottom: -2px;">
		&nbsp; Send invitation to selected
		</a>
		</div>
		<div class="buttons">
		<a id="deleteSelectedParticipants" type="button">
		<img src="/conf4u/resources/imgs/vn_action_delete.png" alt="" style="margin-bottom: -2px;">
		&nbsp; Remove selected
		</a>
		</div>
	</div>
		
	<div id="dialogConfirmDeleteConf" title="Delete conference?" style="display:none;">
		<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Conference will be deleted, all users will be removed from this conference. Are you sure?</p>
	</div>
	
	<div id="dialogConfirmRemoveParticipant" title="Remove participant from conference?" style="display:none;">
		<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Participant will be removed. Are you sure?</p>
	</div>

	<div id="dialogConfirmRemoveSelectedParticipant" title="Remove selected participant from conference?" style="display:none;">
		<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Selected participant will be removed. Are you sure?</p>
	</div>
	</div>
</div>
</div>
<script type="text/javascript">	
$(document).ready(function(){
	 	$('#sendInvitationToSelected').click(function () {
	 		 var allVals = "";
	 		 var $checked = $('input:checkbox[name=userNames]:checked');
	 		 if ($checked.length == 0)
 			 {
	 			jNotify("No user is selected");
	 			return;
 			 }
	 		$checked.each(function() {
	 	    	allVals += $(this).val() + ",";
	 	     });
	 		
	 		var confName = "<%=request.getParameter("conferenceName")%>";
	 		
	 		$("html,body").animate({ scrollTop: 0 }, "slow");
	 		
	 		$('.sendingInvitations').show();
	 		
 			$.ajax({
		        url: "ConferenceServlet",
		        dataType: 'json',
		        async: false,
		        type: 'POST',
		            data: {
		            	"action": "sendInvitation",
		            	"confName": $(".confName").text(),
		            	"userNames": allVals
		            },
		        success: function(data) {
		            if (data != null){
						if (data.resultSuccess == "true")
						{
							$('.sendingInvitations').hide();
							window.location = "conferenceDetails.jsp?conferenceName=" +confName + "&messageNotification=" + data.message + "&messageNotificationType=success";
						}
						else
						{
							$('.sendingInvitations').hide();
							jError(data.message);
						}
		            }
		        }
		    });
	 	});
	 	
	 	$('#deleteSelectedParticipants').click(function () {
	 		 var allVals = "";
	 		 var $checked = $('input:checkbox[name=userNames]:checked');
	 		 if ($checked.length == 0)
			 {
	 			jNotify("No user is selected");
	 			return;
			 }
	 		$checked.each(function() {
	 	    	allVals += $(this).val() + ",";
	 	     });
	 		
	 		var confName = "<%=request.getParameter("conferenceName")%>";
	 		$('#dialogConfirmRemoveSelectedParticipant').dialog({
				resizable: false,
				height: 150,
				width: 400,
				modal: true,
				hide: "fade", 
	            show: "fade",
				buttons: {
					"Remove selected users": function() {
							$.ajax({
						        url: "ConferenceServlet",
						        dataType: 'json',
						        async: false,
						        type: 'POST',
						            data: {
						            	"action": "removeUser",
						            	"confName": confName,
						            	"userNames": allVals
						            },
						        success: function(data) {
						            if (data != null){
						            	if (data.resultSuccess == "true")
										{
									 	   	window.location = "conferenceDetails.jsp?conferenceName=" +confName + "&messageNotification=" + data.message + "&messageNotificationType=success";
										}
										else
										{
											$('#dialogConfirmRemoveSelectedParticipant').dialog('close');
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
	 	
		 $('.removePart').click(function () { 
			 var $removeParticipant = $(this);
			 var confName = "<%=request.getParameter("conferenceName")%>";
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
					        url: "ConferenceServlet",
					        dataType: 'json',
					        async: false,
					        type: 'POST',
					            data: {
					            	"action": "removeUser",
					            	"confName": confName,
					            	"userNames": $removeParticipant.closest('tr').find('td#userNameTd').text()
					            },
					        success: function(data) {
					            if (data != null){
									if (data.resultSuccess == "true")
									{
								 	   	window.location = "conferenceDetails.jsp?conferenceName=" + confName + "&messageNotification=" + data.message + "&messageNotificationType=success";
									}
									else
									{
										$('#dialogConfirmRemoveParticipant').dialog('close');
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
	 	
		 $('.deleteConf').click(function () { 
			 $('#dialogConfirmDeleteConf').dialog({
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
										$('#dialogConfirmDeleteConf').dialog('close');
										jError(data.message);
									}
					            }
					        }
					    });
					},
					Cancel: function() {
						$(this).dialog("close");
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
		 
		 $('.select_all').click(function(){
			 if (this.checked)
			 {
				 $('input:checkbox[name=userNames]:not(:checked)').each(function() {
			 	    	$(this).prop("checked", true);
			 	     });
			 }
			 else
			 {
				 $('input:checkbox[name=userNames]:checked').each(function() {
			 	    	$(this).prop("checked", false);
			 	     });
			 }
		 });
		 
		 $('.editStatus').click(function () {
			 	$editLink = $(this);
			 	$partStatusTd = $editLink.closest('tr').find('td#attendanceTd');
			 	$partStatus = $partStatusTd.find('span#participiationStatus');
			 	$partStatusSelectList = $partStatusTd.find('.attendanceStatusSelectList');
			 	
			 	$editStatusSelectList = $partStatusTd.find('span.editPartStatus');
			 	$saveStatus = $partStatusTd.find('span.savePartStatus');
			 	$cancelSaveStatus = $partStatusTd.find('span.cancelPartStatusSave');
			 	
			 	$partStatus.hide();
			 	$editLink.hide();
			 	

			 	
			 	$editStatusSelectList.show();
			 	
			 	var partStatusText = $partStatus.attr('class');
			 	if (partStatusText != null)
		 		{
			 		$partStatusSelectList.val(partStatusText).attr('selected',true);
		 		}
			 	
			 	$cancelSaveStatus.show();
			 	$saveStatus.show();
		 });
		 
		 $('.savePartStatus').click(function () {
			 $saveStatus = $(this);
			 $partStatusTd = $saveStatus.closest('tr').find('td#attendanceTd');
			 $partStatusSelectList = $partStatusTd.find('.attendanceStatusSelectList');
			 
			 if ($partStatusSelectList.find(":selected").val() == "NOTSELECTED")
			 {
			 	jError("No status was selected");
			 	return;
			 }
			 
			 $editStatus = $partStatusTd.find('span.editPartStatus');
			 
			 $partStatus = $partStatusTd.find('span#participiationStatus');
			 $editLink = $partStatusTd.find('span.editStatus');
			
			 
			 var value = $partStatusSelectList.val();
		   	
			 var confName = $(".confName").text();
			 	
			 $.ajax({
			        url: "ConferenceServlet",
			        dataType: 'json',
			        async: false,
			        type: 'POST',
			            data: {
			            	"action": "updateUserAttendance",
			            	"confName": confName,
			            	"userName": $saveStatus.closest('tr').find('td#userNameTd').text(),
			            	"value": value
			            },
			        success: function(data) {
			            if (data != null){
							if (data.resultSuccess == "true")
							{
								$editStatusSelectList = $partStatusTd.find('span.editPartStatus');
							 	$cancelSaveStatus = $partStatusTd.find('span.cancelPartStatusSave');
							 	
							 	$editStatus.hide();
							 	$saveStatus.hide();
							 	$cancelSaveStatus.hide();
							 	
							 	$partStatus.text($editStatusSelectList.find(":selected").text());
							 	$partStatus.attr('class', $editStatusSelectList.find(":selected").val());
							 	
							 	$partStatus.show();
							 	$editLink.show();
							 	
							 	jSuccess(data.message);
							}
							else
							{
								$( this ).dialog( "close" );
								jError(data.message);
							}
			            }
			        }
			    });
			 
		 });
		 
		 $('.cancelPartStatusSave').click(function () {
			 $cancel = $(this);
			 $partStatusTd = $cancel.closest('tr').find('td#attendanceTd');
			 
			 $editStatusSelectList = $partStatusTd.find('span.editPartStatus');
			 $saveStatus = $partStatusTd.find('span.savePartStatus');
			 
			 $partStatus = $partStatusTd.find('span#participiationStatus');
			 $editLink = $partStatusTd.find('span.editStatus');
			 
			 $editStatusSelectList.hide();
			 $saveStatus.hide();
			 $cancel.hide();
			 	
		 	$partStatus.show();
		 	$editLink.show();	 
		 });
		 
		 //perform only if the class "evenrow" exists
		 if ($(".evenrow")[0]){
			 sorter.size(10);
			}

	});	
</script>


</body>
</html>