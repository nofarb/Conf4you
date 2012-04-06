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

    $('#tabs').tabs();
    $('#tabs').on('click', 'a', function(event) {
        event.preventDefault();
        $.get($(this).attr('href'), function (response){
           $(this).parent().html(response);
        });
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
	<h2 class="demoHeaders">Tabs</h2>
	<div id="tabs">
		<ul>
			<li><a href="#tabs-1">First</a></li>
			<li><a href="#tabs-2">Users</a></li>
			<li><a href="#tabs-3">Third</a></li>
		</ul>
		<div id="tabs-1">Lorem ipsum dolor sit amet, consectetur
			adipisicing elit, sed do eiusmod tempor incididunt ut labore et
			dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
			exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</div>
		<div id="tabs-2">
			<jsp:include page="users.jsp" />
		</div>
		<div id="tabs-3">
			<iframe  style="width: 100%; height: 768px;"  src="users.jsp" /></iframe>
			</div>
	</div>


</body>
</html>
