<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Conf4You</title>
<link type="text/css" href="css/cupertino/jquery-ui-1.8.18.custom.css"
	rel="stylesheet" />
<script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>
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
	margin: 50px;
}

.demoHeaders {
	margin-top: 2em;
}

</style>
</head>
<body>

	<!-- Tabs -->
	<h1 class="demoHeaders">Conf4u</h1>
	<div style="clear:both;"></div>
	<div class="titleSeparator"></div>
	<div id="tabs">
		<ul>
			<li><a href="#tabs-1"><span>Users</span></a></li>
			<li><a href="conference.jsp"><span>Conferences</span></a></li>
			<li><a href="#tabs-3"><span>Companies</span></a></li>
		</ul>
		<div id="tabs-1">
			<iframe  style="width: 100%; height: 768px; border: none"  src="users.jsp" /></iframe>
		</div>

		<div id="tabs-3">
			<iframe  style="width: 100%; height: 768px; border: none"  src="companies.jsp" /></iframe>
		</div>
	</div>


</body>
</html>
