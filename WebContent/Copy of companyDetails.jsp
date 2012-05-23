<%@page import="model.Company"%>
<%@page import="daos.CompanyDao"%>
<%@page import="daos.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="model.User"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link type="text/css" href="css/main.css" rel="stylesheet" />
<link type="text/css" href="css/tables/tableList.css" rel="stylesheet" />
<link type="text/css" href="css/cupertino/jquery-ui-1.8.18.custom.css"
	rel="stylesheet" />
<script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.18.custom.min.js"></script>

<script type="text/javascript">	
$(document).ready(function(){
	 $('.deleteComp').click(function () { 
		$.ajax({
	        url: "CompanyServlet",
	        dataType: 'json',
	        async: false,
	        type: 'POST',
	            data: {
	            	"action": "delete",
	            	"compName": $(".compName").text()
	            },
	        success: function(data) {
	            if (data != null){
					if (data.resultSuccess == "true")
					{
					
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
	});
});
</script>


</head>

<body>
<div id="content">
<div class="pageTitle">
<div class="titleMain ">Company details</div>
<div style="clear:both;"></div>
<div class="titleSeparator"></div>
<div class="titleSub">View, modify this Company</div>
</div>
<div id="detailsAndActions">
<% String companyName = request.getParameter("companyName");
	   Company comp = CompanyDao.getInstance().getCompanyByName(companyName);
	%>
	<div class="vn_detailsgeneraltitle">Actions </div>
	<div class="vn_actionlistdiv yui-reset yui-base">
		<div class="vn_actionlistcolumn">
			<div class="vn_actionbuttondiv">
				<div class="title">
				<a title="Edit Company" href="companyAddEdit.jsp?action=edit&compName=<%=companyName%>">
					<img src="/conf4u/resources/imgs/vn_action_edit.png" alt=""> 
					Edit
				</a>
				</div>
			</div>
				<div class="vn_actionbuttondiv">
				<div class="title">
				<a class="deleteComp" title="Delete Company">
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
				<td><%=comp.getName()%></td>
			</tr>
			<tr>
				<td>Type</td>
				<td><%=comp.getCompanyType()%></td>
			</tr>
		</tbody>
	</table>
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