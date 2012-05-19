<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Conf4You</title>
<link type="text/css" href="css/cupertino/jquery-ui-1.8.18.custom.css"
	rel="stylesheet" />
	<link type="text/css" href="css/main.css" rel="stylesheet" />
<script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="js/jquery.floatingmessage.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.18.custom.min.js"></script>
<script type="text/javascript">

$(document).ready(function() {
	$('#tabs').tabs({
	    load: function(event, ui) {
	        $(ui.panel).delegate('a', 'click', function(event) {
	            $(ui.panel).load(this.href);
	            event.preventDefault();
	        });
	    }
	});
	
    $("#tabs").bind('tabsselect', function(event, ui) {
        window.location.href=ui.tab;
    });

});

</script>

<style type="text/css">
/*demo page css*/
body {
	font: 62.5% "Trebuchet MS", sans-serif;
}

.demoHeaders {
	margin-top: 20px;
}

</style>
</head>
<body>



<!-- Tabs -->
<div><h1 class="demoHeaders">Conf4u</h1>
	<a style="float:right;position:relative;padding-bottom:10px;" href="LoginServlet?action=logout">Logout</a>
</div>
<div style="clear:both;"></div>
<div class="titleSeparator"></div>
<div id="tabs">
	<ul>
		<li><a href="users.jsp"><span>Users</span></a></li>
		<li><a href="conference.jsp"><span>Conferences</span></a></li>
		<li><a href="companyList.jsp"><span>Companies</span></a></li>
		<li><a href="Location.jsp"><span>Locations</span></a></li>
	</ul>
</div>

</body>
</html>
