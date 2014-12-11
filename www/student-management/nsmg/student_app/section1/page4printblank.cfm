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
	<title>Page [04] - Family Photo Album</title>
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
		<td class="tablecenter"><h2>Page [04] - Family Photo Album</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page4printblank.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="#path#pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
        <td  class="tablecenter"><cfinclude template="../datestamp.cfm"></td>
		<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">	
	<tr><td><div align="justify"></div><em>On this section please upload recent photos (within 2 years) of you, your
			family and friends. Describe each photo on the space provided. Please feel free to upload any additional 
			pictures.</b></em></td>
	</tr>
</table><br><br>

<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">	
	<tr><td height="200" valign="middle" align="center"><img src="#path#pics/familyphoto.jpg" border="0" align="absmiddle" width="200"></td></tr>
	<tr><td><em>Describe this Picture</em></td></tr>
	<tr><td height="30" valign="bottom"><br><img src="#path#pics/line.gif" width="665" height="1" border="0" align="absmiddle"></div></td></tr>
</table><br>

<table width="670" border="0" cellpadding="3" cellspacing="0" align="center">	
	<tr><td height="200" valign="middle" align="center"><img src="#path#pics/familyphoto.jpg" border="0" align="absmiddle" width="200"></td></tr>
	<tr><td><em>Describe this Picture</em></td></tr>
	<tr><td height="50" valign="bottom"><br><img src="#path#pics/line.gif" width="665" height="1" border="0" align="absmiddle"></div></td></tr>
</table><br>
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


