<%@page import="model.Conference"%>
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