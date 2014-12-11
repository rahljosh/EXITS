<cftry>

<cfif LEN(URL.curdoc) OR IsDefined('url.path')>
	<cfset path = "">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [02] - Siblings</title>
	<style type="text/css">
	<!--
	body {
		margin-left: 0.3in;
		margin-top: 0.3in;
		margin-right: 0.3in;
		margin-bottom: 0.3in;
	}
	-->
	</style>	
</head>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfoutput>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0> 
<tr><td>&nbsp;</td></tr>
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [02] - Siblings</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page2printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td  class="tablecenter"><cfinclude template="../datestamp.cfm"></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">	
	<tr><td colspan="5"><b>BROTHERS and/or SISTERS</b></td></tr>
	<tr>
		<td><em>Name</em></td>
		<td><em>Date of Birth</em></td>
		<td><em>Sex</em></td>
		<td><em>Living at home?</em></td>
	</tr>
	<!--- new siblings --->
	<cfloop from="1" to="5" index="i">
	<tr>
		<td valign="top"><br><img src="#path#pics/line.gif" width="200" height="1" border="0" align="absmiddle"><br><br></td>
		<td valign="top"><br><img src="#path#pics/line.gif" width="145" height="1" border="0" align="absmiddle"><br><br></td>
		<td valign="top">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Male &nbsp; &nbsp;
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Female
			<br><img src="#path#pics/line.gif" width="150" height="1" border="0" align="absmiddle"><br><br></td>
		<td valign="top">
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> Yes &nbsp; &nbsp;
			<img src="#path#pics/RadioN.gif" width="13" height="13" border="0"> No
			<br><img src="#path#pics/line.gif" width="150" height="1" border="0" align="absmiddle"><br><br></td>	
	</tr>
	</cfloop>		
</table><br><br>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
		<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

</cfoutput>

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
</cfif>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</body>
</html>

</cftry>