<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">



<html>

<head>

	<title>ISE - International Student Exchange</title>

	<LINK REL="stylesheet" type="text/css" href="external.css">

	



<body>

<script type='text/javascript'>



//HV Menu v5- by Ger Versluis (http://www.burmees.nl/)

//Submitted to Dynamic Drive (http://www.dynamicdrive.com)

//Visit http://www.dynamicdrive.com for this script and more



function Go(){return}



</script>

<script type='text/javascript' src='pokytrails.menu.js'></script>

<script type='text/javascript' src='menu_com.js'></script>

<noscript>Your browser does not support script</noscript>


<cfif left(remote_addr,6) is '10.1.1'>
<cfset rel_abs="internal/">
<cfset local_abs="http://web/">
<cfelse>
<cfset rel_abs="http://www.iseusa.com/internal/">
<cfset local_abs="http://www.student-management.com/">
</cfif>
<cfif left(remote_host,6) is '10.1.1'>
<cfset  rel_abs= "internal/">
<cfset local_abs="http://web/">
<cfelse>
<cfset rel_abs= "http://www.iseusa.com/internal/">
<cfset local_abs="http://www.student-management.com/">

</cfif>

<cfif  isDefined("session.iserep_id") and session.iserep_id is NOT ''><form action="logout2.cfm" method="post"><cfelse><Cfoutput><form action="#rel_abs#loginapply_ise.cfm" method="post"><!----<form action="#rel_abs#down.cfm" method="post">----></cfoutput></cfif>

<table cellpadding = 0 cellspacing=0  bgcolor="#0C1163" width=100% align="center">

	<tr>

		<td ><img src="pics/white_logo.gif" width="88" height="75" alt="" border="0"><font size=-1><A href="http://www.student-management.com"><img src="../dmdusa/images/smg_group.gif" border=0></td>

		<td><div class="site-header" align="center">International Student Exchange<br>Changing Lives</div><div class="sub-title" align="center">A non-profit organization for tomorrow's leaders<br><a href="http://www.student-management.com/"><font color="white">Part of the Student Management Group family of companies.</a></font></td>

		<td valign="top"><div  align="right"><font color="white"><u>ISE Associate<cfif isDefined("session.iserep_id") and session.iserep_id is NOT ''> Info<cfelse> Login</cfif></u><br><br>
				<a href="http://www.student-management.com/nsmg/loginform.cfm"><font color="white">Login Here</a>
			</div></form>

		</td>

	</tr>

	<tr>

		<td bgcolor="#5564B5" height=23 colspan=4></td>

	</tr>

	<tr>

		<td bgcolor="#93A0B2" height=2 colspan=4></td>

	</tr>

</table>

<!----Body of Page---->

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="White">

	<TR>

		<td valign="top">

		<!----Inside Table---->

		

		

