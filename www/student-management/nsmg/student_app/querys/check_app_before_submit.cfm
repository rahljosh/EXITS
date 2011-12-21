<style type="text/css">
	body {font:Arial, Helvetica, sans-serif;}
	.thin-border{ border: 1px solid #000000; font:Arial, Helvetica, sans-serif;}
	.dashed-border {border: 1px solid #FF9933;}
</style>

<cfquery name="users_bypass" datasource="mysql">
    select userid, bypass_checklist
    from smg_users
    where userid = #client.userid#
</cfquery>

<cfif users_bypass.bypass_checklist eq 1>
	<cfset client.missingitems = 0>
    It looks like your applcations do not need to be verified through the checklist.  
    This happens on some occasions under certain circumstances.<br>
    The next time you submit an application, the check list my be required.<br><Br>
    <div align="center"><img src="../pics/processing.gif">
    	<META http-equiv="refresh" content="5;URL=check_app_results.cfm">
    <cfabort>
</cfif>

<br><br>

<body bgcolor="#dcdcdc">
<table class=dashed-border align="center" width = 550 bgcolor="white">
	<tr>
		<td><img src="../pics/top-email.gif" width="550" height="75"></td>
	</tr>
	<tr>
		<Td>
		Please wait while your application information is being checked. Do not close this window or click your back button.<br><br>
		While this initial check does not guarantee that your application will not be denied,
		it will catch many common mistakes.<br><br>
		Your local representative may deny your application and request more information, once that information
		completed, simply submit your app. again.<br>
		<div align="center"><img src="../pics/processing.gif"><br><br>If this page apears for more then 2 minutes, click <A href="check_app_results.cfm">here</A></div>
		</Td>
	</tr>
</table>

<!--- *******************************************************************
	Start of Insert check_list.cfm
******************************************************************* --->

<cfinclude template="../check_list.cfm">

<!--- *******************************************************************
	End of Insert check_list.cfm 
******************************************************************* --->

<cfset client.missingitems = countRed>

<cflocation url="check_app_results.cfm">

</body>