<%@page import="utils.ProjConst"%>
<%@page import="daos.CompanyDao"%>
<%@page import="model.Company"%>
<%@page import="model.Conference"%>
<%@page import="model.Location"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.ConferenceDao"%>
<%@page import="daos.LocationDao"%>
<%@page import="daos.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>
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
<script type="text/javascript" src="js/jquery.validate.js"></script>
<style type="text/css">
div.message {
	background: transparent url(/conf4u/resources/imgs/msg_arrow.gif)
		no-repeat scroll left center;
	padding-left: 7px;
}

div.error {
	background-color: #F3E6E6;
	border-color: #924949;
	border-style: solid solid solid none;
	border-width: 2px;
	padding: 4px;
}
</style>
<script>
	$(function() {
		$(".datepicker").datepicker();
	});

	$(document)
			.ready(
					function() {
						$.validator.addMethod("uniqueConferenceName", function(
								value, element) {
							$.ajax({
								type : "POST",
								url : "ConferenceServices",
								data : "confName=" + value,
								dataType : "html",
								success : function(msg) {
									//If conference exists, set response to true
									var response = (msg == 'true') ? true
											: false;
									return response;
								}
							});
						}, "conference name is Already Taken");

						$.validator.addMethod("endDateValidate", function(
								value, element) {
							var startDate = $('.startDate').val();
							return Date.parse(value) <= Date.parse(startDate)
									|| value == "";
						}, "Start date should be greater than End date");

						$.validator.addMethod("startDateGreaterThanNow",
								function(value, element) {
									var now = Date.now();
									return Date.parse(value) <= Date.parse(now)
											|| value == "";
								}, "Start date must be in the future");

						$("#conferenceAddForm")
								.validate(
										{
											onkeyup : false,
											onfocusout : false,
											rules : {
												confName : {
													required : true,
													minlength : 4,
													maxlength : 30,
													uniqueConferenceName : true,
												},
												confDesc : {
													required : true,
													minlength : 4,
													maxlength : 254,
												},
												locations : {
													required : true,
												},
												startDate : {
													required : true,
													date : true,
													startDateGreaterThanNow : true,
												},
												endDate : {
													required : true,
													date : true,
													endDateValidate : true,
												},
											},
											messages : {
												confName : {
													required : "Required",
													minlength : "You need to use at least 4 characters for your conference name.",
													maxlength : "You need to use at most 30 characters for your conference name.",
													uniqueConferenceName : "This conference name is already exists",
												},
												confDesc : {
													required : "Required",
													minlength : "You need to use at least 4 characters for your conference description.",
													maxlength : "You need to use at most 254 characters for your conference description.",
												},
												locations : {
													required : "Stand up for your comments or go home.",
												},
												startDate : {
													required : "Required",
													date : "Date format required",
													startDateGreaterThanNow : "Start date must be in the future",
												},
												endDate : {
													required : "Required",
													date : "Date format required",
													endDateValidate : "Start date should be greater than End date"
												}
											},
											errorElement : "div",
											wrapper : "div", // a wrapper around the error message
											errorPlacement : function(error,
													element) {
												offset = element.offset();
												error.insertBefore(element);
												error.addClass('message'); // add a class to the wrapper
												error.css('position',
														'absolute');
												error.css('left', offset.left
														+ element.outerWidth());
											}

										});
					});
</script>

</head>

<body>
	<div class="pageTitle">
		<div class="titleMain ">Add User</div>
		<div style="clear: both;"></div>
		<div class="titleSeparator"></div>
		<div class="titleSub">Add a new user</div>
	</div>
	<div id="vn_mainbody">
		<div class="formtable_wrapper">
			<form id="UserAddForm" method="post" action="users">
				<input type="hidden" name="action" value="add" /> <!-- hidden input to pass action type -->
				<table class="formtable" cellspacing="0" cellpadding="0" border="0">
					<thead>
						<tr>
							<th class="header" colspan="2"><strong>Create a new	user</strong> <br></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.USER_NAME%>> User Name: <em>*</em> </label>
							</td>
							<td class="inputcell">
								<input id=<%=ProjConst.USER_NAME%> type="text" value="" name=<%=ProjConst.USER_NAME%>>
								<div></div></td>
						</tr>
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.NAME%>> Name: <em>*</em> </label>
							</td>
							<td class="inputcell">
								<input id=<%=ProjConst.NAME%> type="text" value="" name=<%=ProjConst.NAME%>>
								<div></div></td>
						</tr>
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.PASSPORT_ID%>> Passport #: <em>*</em> </label>
							</td>
							<td class="inputcell">
								<input id=<%=ProjConst.PASSPORT_ID%> type="text" value="" name=<%=ProjConst.PASSPORT_ID%>>
								<div></div></td>
						</tr>
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.EMAIL%>> Email: <em>*</em> </label>
							</td>
							<td class="inputcell">
								<input id=<%=ProjConst.EMAIL%> type="text" value="" name=<%=ProjConst.EMAIL%>>
								<div></div></td>
						</tr>
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.PHONE1%>> Phone #1: <em>*</em> </label>
							</td>
							<td class="inputcell">
								<input id=<%=ProjConst.PHONE1%> type="text" value="" name=<%=ProjConst.PHONE1%>>
								<div></div></td>
						</tr>
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.PHONE2%>> Phone #2: <em>*</em> </label>
							</td>
							<td class="inputcell">
								<input id=<%=ProjConst.PHONE2%> type="text" value="" name=<%=ProjConst.PHONE2%>>
								<div></div></td>
						</tr>
						<tr>
							<td class="labelcell required"><label for=<%=ProjConst.COMPANY%>>
									Company: <em>*</em>
							</label></td>
							<td class="inputcell"><select id=<%=ProjConst.COMPANY%>
								class="type rdOnlyOnEdit" name=<%=ProjConst.COMPANY%>>

									<%
										List<Company> companies = CompanyDao.getInstance()
												.getAllCompanies();

										for (Company company : companies) {
									%>
									<option value="<%=company.getCompanyID()%>"
										selected="selected"><%=company.getName()%></option>
									<%
										}
									%>
							</select>
								<div></div></td>
						</tr>
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.PASSWORD%>> Password: <em>*</em> </label>
							</td>
							<td class="inputcell">
								<input id=<%=ProjConst.PASSWORD%> type="text" value="" name=<%=ProjConst.PASSWORD%>>
								<div></div></td>
						</tr>
						<%
							String userName = request.getParameter("userName");
							if(userName != null){
								User user = UserDao.getInstance().getUserByUserName(userName);
								if (user != null && user.isAdmin()) {
							%>
									<tr>
										<td class="labelcell required">
											<label for=<%=ProjConst.IS_ADMIN%>> Admnin User: <em>*</em> </label>				
										</td>
										<td class="inputcell">
											<input id=<%=ProjConst.IS_ADMIN%> type="checkbox" value="true" name=<%=ProjConst.IS_ADMIN%>><div></div>
										</td>
									</tr>
							<%
								}
						}
						%>
						<tr>
							<td></td>
							<td class="inputcell">
								<div class="buttons">
									<button id="createButton" type="submit">
										<img class="img_png" width="16" height="16" alt=""
											src="/conf4u/resources/imgs/table_save.png"> Create
									</button>
									<a id="cancelButton" href="#"
										onClick="window.location.reload( true )"> <img
										class="img_png" width="16" height="16" alt=""
										src="/conf4u/resources/imgs/cancel.png"> Cancel
									</a>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
		<div class="clearboth"></div>
	</div>

</body>
</html>