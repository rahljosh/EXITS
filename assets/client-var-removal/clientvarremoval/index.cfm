<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>ColdFusion Registry Client Variable Store Purger</title>
<style type="text/css">
body {
	background-color: #FFFFCC;
	margin: 0;
	font-family: Verdana, Georgia, Arial Narrow, sans serif;
	font-size: 12px;
	padding-left: 3px;
}

h2 {
	text-align: center;
	color: #00A3DD;
}

.green {
	color:#006600; 
	font-weight:bold;
}

.red { 
	color:#CC0000;
	font-weight:bold;
}

table {
	background-color: #884488;
	font-size: xx-small;
	font-family: verdana, arial, helvetica, sans-serif;
	cell-spacing: 2px;
}

table th {
	background-color: #AA66AA;
	color: white;
	padding: 5px;
	text-align: left;
}

table td {
	background-color: #FFFFFF;
	padding: 3px;
	vertical-align: top;
}

table td.label {
	background-color: #FFDDFF;
}
#Container{
	margin: 10px auto;
	width: 800px;
	height: 600px;
}

#Nav{
	margin: 0;
	width: 20%;
	float: left;
}

#Display {
	float: left;
	margin: 0;
	width: 80%;
	height: 563px;
	overflow:auto;
}
</style>
</head>
<body>
	<div id="Container">
		<h2>ColdFusion Registry Client Variable Store Purger</h2>
		<div id="Nav">
			<p><a href="?do=getKeys">Get Registry Keys</a></p>
			<p><a href="?do=makeKeys">Make Registry Keys</a></p>
			<p><a href="?do=killKeys">Purge Registry Keys</a></p>
			<p><a href="index.cfm">Home</a></p>
		</div>
		<div id="Display"><cfparam name="URL.do" default="">
		<cfsetting enablecfoutputonly="yes">
		<cftry>
		<cfswitch expression="#URL.do#">
			<cfcase value="getKeys">
				<cfinclude template="get_keys.cfm">
				<cfif keys_to_delete.RecordCount>
					<cfoutput>
					<table>
						<tr><th colspan="4">Number of Keys: #keys_to_delete.RecordCount#</th></tr>
						<tr><td class="label">&nbsp;</td><td class="label">Entry</td><td class="label">Type</td><td class="label">Value</td></tr></cfoutput>
						<cfoutput query="keys_to_delete">
						<tr><td class="label">#currentrow#</td><td valign="top">#entry#</td><td valign="top">#type#</td><td valign="top">#value#</td></tr><cfif Request.flushCtrl><cfflush></cfif></cfoutput>
					<cfoutput></table></cfoutput>
				<cfelse>
					<cfsetting enablecfoutputonly="no"><span class="green">No Keys found in Registry!</span>	
				</cfif>
			</cfcase>
			<cfcase value="makeKeys"><cfinclude template="make_keys.cfm"></cfcase>
			<cfcase value="killKeys"><cfinclude template="kill_keys.cfm"></cfcase>
			<cfdefaultcase><cfsetting enablecfoutputonly="no"><p>This template will purge all of the client variables stored in the Registry store. It works for ColdFusion versions 4.5.x, 5.0, 6.x+ (CFMX).</p> 
			<p>To see all of the client variable keys currently stored in the Registry, click <a href="?do=getKeys">Get Registry Keys</a>.</p>
			<p>To create client variable keys in the Registry for testing, click <a href="?do=makeKeys">Make Registry Keys</a>.</p>
			<p>To purge all of the client variables keys stored in the Registry, click <a href="?do=killKeys">Purge Registry Keys</a>.</p>
			</cfdefaultcase>
		</cfswitch>
			<cfcatch type="any">
				<cfoutput><p><strong>Message:</strong> #cfcatch.Message#</p>
				<p><strong>Details:</strong> #cfcatch.Detail#</p></cfoutput>
			</cfcatch>
		</cftry>
		<cfsetting enablecfoutputonly="no">
		</div>
	</div>
</body>
</html>