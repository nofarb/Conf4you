<%@page import="model.*"%>
<%@page import="daos.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="model.User"%>
<%@page import="helpers.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%= UiHelpers.GetAllJsAndCss().toString() %>

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
<%= UiHelpers.GetTabs(viewingUser, ProjConst.TAB_LOCATIONS).toString() %>

<div id="content">
	<div class="pageTitle">
	<div class="titleMain ">Location details</div>
	<div style="clear:both;"></div>
	<div class="titleSeparator"></div>
	<div class="titleSub">View, modify this Location</div>
</div>
<div id="detailsAndActions">
	<% String locName = request.getParameter(ProjConst.LOC_NAME);
	   Location location = LocationDao.getInstance().getLocationByName(locName);
	%>
	<% if (viewingUser.isAdmin()) {%>
	<div class="vn_detailsgeneraltitle">Actions </div>
	<div class="vn_actionlistdiv yui-reset yui-base">
		<div class="vn_actionlistcolumn">
			<div class="actionButton">
				<div class="title">
				<a title="Edit Conference" href="locationAddEdit.jsp?action=edit&locName=<%=location.getName()%>">
					<img src="/conf4u/resources/imgs/edit.png" alt=""> 
					Edit
				</a>
				</div>
			</div>
				<div class="actionButton">
				<div class="title">
				<a class="deleteLoc" title="Delete Location" style="cursor:pointer;">
					<img src="/conf4u/resources/imgs/delete.png" alt=""> 
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
		<tbody>
			<tr>
				<td>Name</td>
				<td class="locName"><%=location.getName()%></td>
			</tr>
			<tr>
				<td>Address</td>
				<td><%=location.getAddress()%></td>
			</tr>
			<tr>
				<td>Max Capacity</td>
				<td><%=location.getMaxCapacity()%></td>
			</tr>
			<tr>
				<td>Contact Name</td>
				<td><%=location.getContactName()%></td>
			</tr>
			<tr>
				<td>Phone 1</td>
				<td><%=location.getPhone1()%></td>
			</tr>
			<tr>
				<td>Phone 2</td>
				<td><%=location.getPhone2()%></td>
			</tr>
		</tbody>
	</table>
	</div>
	
	<div id="dialog-confirm" title="Delete Location?" style="display:none;">
		<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Location will be deleted. Are you sure?</p>
	</div>
	
	<!-- 
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
	 -->
	</div>
</div>
<script type="text/javascript">	
$(document).ready(function(){
	
		 $('.deleteLoc').click(function () { 
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
					        url: "LocationServlet",
					        dataType: 'json',
					        async: false,
					        type: 'POST',
					            data: {
					            	"action": "delete",
					            	"locName": $(".locName").text()
					            },
					        success: function(data) {
					            if (data != null){
									if (data.resultSuccess == "true")
									{
								 	   	//window.location = "locations.jsp";
								 	    //$.floatingMessage(data.message ,{  
								 	    //	height : 30
									    //}); 
								 	    //$(".ui-widget-content").addClass("successFeedback");
										var params;
										var returnUrl;
										params = "?messageNotification=" + data.message + "&messageNotificationType=success";						
										returnUrl = "<%=retUrl%>";
										returnUrl += params;
								 	    window.location.href = returnUrl;
									}
									else
									{
										//$.floatingMessage(data.message);
										//$(".ui-widget-content").addClass("errorFeedback");
										jError(data.message);
										$( this ).dialog( "close" );
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
	});
	
	
</script>
</body>
</html>