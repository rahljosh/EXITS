<style type="text/css">
<!--
#minitabs {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #C2B59C;
	margin-top: 0;
	margin-right: auto;
	margin-bottom: 0;
	margin-left: auto;
	padding-top: 0;
	padding-right: 0;
	padding-bottom: 20px;
	padding-left: 10px;
	}

#minitabs li {
	margin: 0;
	padding: 0;
	display: inline;
	list-style-type: none;
	}
	
#minitabs a:link, #minitabs a:visited {
	float: left;
	font-size: 10px;
	line-height: 18px;
	font-weight: bold;
	margin: 0 10px 4px 10px;
	padding-bottom: 2px;
	text-decoration: none;
	color: #FFF;
	font-family: Arial, Helvetica, sans-serif;
	}

#minitabs a.active:link, #minitabs a.active:visited, #minitabs a:hover {
	padding-bottom: 2px;
	color: #C2B59C;
	border-bottom-width: 4px;
	border-bottom-style: solid;
	border-bottom-color: #C2B59C;
	}

/* relative font-size version */

#miniflex {
	width: 100%;
	float: left;
	font-size: small; /* could be specified at a higher level */
	margin: 0;
	padding: 0 10px 0 10px;
	border-bottom: 1px solid #333;
	}

#miniflex li {
	float: left;
	margin: 0; 
	padding: 0;
	display: inline;
	list-style: none;
	}
	
#miniflex a:link, #miniflex a:visited {
	float: left;
	font-size: 85%;
	line-height: 20px;
	font-weight: bold;
	margin: 0 10px 0 10px;
	text-decoration: none;
	color: #C2B59C;
	}

#miniflex a.active:link, #miniflex a.active:visited, #miniflex a:hover {
	border-bottom: 4px solid #000;
	padding-bottom: 2px;
	color: #C2B59C;
	}

-->
</style>

<ul id="minitabs">
	<li><a href="http://www.smg-canada.org/index.cfm"<Cfif #cgi.path_info# is '/index.cfm'>class="active"</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;HOME&nbsp;&nbsp;</a></li>
	<li><a href="http://www.smg-canada.org/about.cfm"<Cfif cgi.path_info is '/about.cfm'>class="active"</cfif>>&nbsp;&nbsp;ABOUT US&nbsp;&nbsp;</a></li>
	<li><a href="http://www.smg-canada.org/programs.cfm"<Cfif cgi.path_info is '/programs.cfm'>class="active"</cfif>>&nbsp;&nbsp;OUR PROGRAMS&nbsp;&nbsp;</a></li>
	<li><a href="http://www.smg-canada.org/schools.cfm"<Cfif cgi.path_info is '/schools.cfm'>class="active"</cfif>>&nbsp;&nbsp;OUR SCHOOLS&nbsp;&nbsp;</a></li>
	<li><a href="http://canada.exitsapplication.com/" target="_blank"<Cfif cgi.path_info is '/admissions.cfm'>class="active"</cfif>>&nbsp;&nbsp;ADMISSIONS&nbsp;&nbsp;</a></li>
	<li><a href="http://www.smg-canada.org/contact.cfm"<Cfif cgi.path_info is '/contact.cfm'>class="active"</cfif>>&nbsp;&nbsp;CONTACT US&nbsp;&nbsp;</a></li>
</ul>
