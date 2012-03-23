<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Servlet Error Page</title>
	<link href = "ErrorStyle.css" rel="stylesheet">
</head>

<body>

	<h1> Servlet Error Page </h1>
	
	<h3> <%=(String)request.getAttribute("ServletError") %> </h3>
	
</body>
</html>