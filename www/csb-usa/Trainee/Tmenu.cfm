
<style type="text/css">
<!--
#minitabs {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #0E6A38;
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
	font-size: 14px;
	line-height: 18px;
	font-weight: bold;
	margin: 0 10px 4px 10px;
	padding-bottom: 2px;
	text-decoration: none;
	color: #666;
	font-family: Arial, Helvetica, sans-serif;
	}

#minitabs a.active:link, #minitabs a.active:visited, #minitabs a:hover {
	padding-bottom: 2px;
	color: #0E6A38;
	border-bottom-width: 4px;
	border-bottom-style: solid;
	border-bottom-color: #0E6A38;
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
	color: #999;
	}

#miniflex a.active:link, #miniflex a.active:visited, #miniflex a:hover {
	border-bottom: 4px solid #333;
	padding-bottom: 2px;
	color: #333;
	}

-->
</style>

<ul id="minitabs">
	<li><a href="http://www.csb-usa.com/Trainee/index.cfm" <Cfif #cgi.path_info# is '/Trainee/index.cfm' or #cgi.path_info# is 'index/'>class="active"</cfif>>&nbsp;&nbsp;Home&nbsp;&nbsp;&nbsp;</a></li>
	<li><a href="http://www.csb-usa.com/Trainee/participants.cfm" <Cfif cgi.path_info is 'Trainee/participants.cfm'> class="active"</cfif>>&nbsp;&nbsp;&nbsp;Participants&nbsp;&nbsp;&nbsp;</a></li>
	<li><a href="http://www.csb-usa.com/Trainee/intlPartners.cfm" <Cfif cgi.path_info is 'Trainee/intlPartners.cfm'> class="active"</cfif>>&nbsp;&nbsp;&nbsp;International Partners&nbsp;&nbsp;&nbsp;</a></li>
	<li><a href="http://www.csb-usa.com/Trainee/hostComp.cfm"<Cfif cgi.path_info is 'Trainee/hostComp.cfm'> class="active"</cfif>>&nbsp;&nbsp;Host Company&nbsp;&nbsp;&nbsp;</a></li>
	<li><a href="http://www.csb-usa.com/Trainee/insurance.cfm"<Cfif cgi.path_info is 'Trainee/insurance.cfm'> class="active"</cfif>>&nbsp;&nbsp;Insurance&nbsp;&nbsp;&nbsp;</a></li>
	<li><a href="http://www.csb-usa.com/Trainee/contact.cfm"<Cfif cgi.path_info is 'Trainee/contact.cfm'> class="active"</cfif>>&nbsp;&nbsp;Contact Us&nbsp;&nbsp;&nbsp;</a></li>
</ul>

