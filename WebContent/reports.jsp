<%@ page language="java" contentType="text/html; charset=windows-1255"
    pageEncoding="windows-1255"%>
    <%@page import="utils.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1255">
<title>Insert title here</title>
</head>
<body>
<div id="body_wrap">
<%= UiHelpers.GetAllJsAndCss().toString() %>
<%= UiHelpers.GetHeader(SessionUtils.getUser(request)).toString() %>
<%= UiHelpers.GetTabs(SessionUtils.getUser(request), ProjConst.TAB_REPORTS).toString() %>
</div>
</body>
</html>