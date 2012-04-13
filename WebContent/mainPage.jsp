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

jQuery(function($) {

    $("<p>").html("Loaded at " + new Date()).appendTo(
        document.body
    );
    showTab(location.hash || "1");

    $("#nav a").click(function() {
        var hash = this.getAttribute("href");
        if (hash.substring(0, 1) === "#") {
            hash = hash.substring(1);
        }
        location.hash = hash;
        showTab(hash);
        return false;
    });

    function showTab(hash) {
        $("div.tab").hide();
        $("#tab-" + hash).show();
    }

});
</style>
</head>
<body>

	<!-- Tabs -->
	<h2 class="demoHeaders">Tabs</h2>
	<div id="tabs">
		<ul>
			<li><a href="#tabs-1">Users</a></li>
			<li><a href="#tabs-2">Conferences</a></li>
			<li><a href="#tabs-3">Companies</a></li>
		</ul>
		<div id="tabs-1">
			<iframe  style="width: 100%; height: 768px; border: none"  src="users.jsp" /></iframe>
		</div>
		<div id="tabs-2">
			<iframe  style="width: 100%; height: 768px; border: none"  src="conference.jsp" /></iframe>
		</div>
		<div id="tabs-3">
			<iframe  style="width: 100%; height: 768px; border: none"  src="companies.jsp" /></iframe>
		</div>
	</div>


</body>
</html>
