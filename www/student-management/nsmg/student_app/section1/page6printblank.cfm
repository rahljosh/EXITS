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
	<title>Page [06] - Parents Letter of Introduction</title>
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

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0> 
<tr><td>&nbsp;</td></tr>
<tr><td>
</cfif>

<cfoutput>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [06] - Parents Letter of Introduction</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page6printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td  class="tablecenter"><cfinclude template="../datestamp.cfm"></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">	
	<tr><td width="5">&nbsp;</td>
		<td><em>Please <b>type a letter in English</b> in the space below to the host parents who will share their home with your son or daughter.
			Describe your child's personality and interests, expectations and relationships.  We ask that you be very frank and honest in your letter,
			and that you comment on your child's strength and weaknesses. This will be very helpful to us in finding the best host family for your child.</em><br>
		</td>
		<td width="5">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td width="5">&nbsp;</td>
		<td width="660" height="400" valign="bottom"><br><img src="#path#pics/line.gif" width="660" height="1" border="0" align="absmiddle"></td>
		<td width="5">&nbsp;</td>
	</tr>
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
</body></html></cftry>


