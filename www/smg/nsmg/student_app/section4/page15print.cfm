<cftry>

<cfif IsDefined('url.curdoc') OR IsDefined('url.path')>
	<cfset path = "">
<cfelseif IsDefined('url.exits_app')>
	<cfset path = "nsmg/student_app/">
<cfelse>
	<cfset path = "../">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#path#app.css"</cfoutput>>
	<title>Page [15] - Program Agreement</title>
</head>
<body <cfif not IsDefined('url.curdoc')>onLoad="print()"</cfif>>

<cfset doc = 'program_agreement'>

<cfquery name="get_student_info" datasource="mysql">
	SELECT studentid, city, country, countryname, firstname, familylastname, sex
	FROM smg_students 
	LEFT JOIN smg_countrylist on smg_students.country = smg_countrylist.countryid
	WHERE studentid = '#client.studentid#' 
</cfquery>

<cfset doc = 'page15'>

<cfif get_student_info.sex is 'male'>
	<cfset sd='son'>
	<cfset hs='he'>
	<cfset hh='his'>
<cfelse>
	<cfset sd='daughter'>
	<cfset hs='she'>
	<cfset hh='her'>
</cfif>

<cfoutput>

<!--- PRINT ATTACHED FILE INSTEAD OF PAGE --->
<cfif NOT IsDefined('url.curdoc')>
	<cfinclude template="../print_include_file.cfm">
<cfelse>
	<cfset printpage = 'yes'>
</cfif>

<!--- PRINT PAGE IF THERE IS NO ATTACHED FILE OR FILE IS PDF OR DOC --->
<cfif printpage EQ 'yes'>

	<cfif not IsDefined('url.curdoc')>
	<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
	<tr><td>
	</cfif>
	
	<!--- HEADER OF TABLE --->
	<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
		<tr height="33">
			<td width="8" class="tableside"><img src="#path#pics/p_topleft.gif" width="8"></td>
			<td width="26" class="tablecenter"><img src="#path#pics/students.gif"></td>
			<td class="tablecenter"><h2>Page [15] - Program Agreement</h2></td>
			<cfif IsDefined('url.curdoc')>
			<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page15print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
			</cfif>
			<td width="42" class="tableside"><img src="#path#pics/p_topright.gif" width="42"></td>
		</tr>
	</table>
	
	<div class="section"><br>
	<!--- CHECK IF FILE HAS BEEN UPLOADED --->
	<cfif IsDefined('url.curdoc')>
		<cfinclude template="../check_upl_print_file.cfm">
	</cfif>
	
	<table width="660" border=0 cellpadding=0 cellspacing=0 align="center">
		<tr><td align="center">Please read carefully and sign and date where indicated.</td></tr>
		<tr><td><div align="justify"><cfinclude template="page15text.cfm"></div></td></tr>
	</table>
	
	<table width="660" border=0 cellpadding=0 cellspacing=0 align="center">
		<tr>
			<td width="210"><br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
			<td width="5"></td>
			<td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="#path#pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>		
			<td width="40"></td>
			<td width="210"><br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
			<td width="5"></td>
			<td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="#path#pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>
		</tr>
		<tr>
			<td>Signature of Parent</td>
			<td></td>
			<td>Date</td>
			<td></td>
			<td>Signature of Student</td>
			<td></td>
			<td>Date</td>	
		</tr>
	</table>
	</div>
	
	<!--- FOOTER OF TABLE --->
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr height="8">
			<td width="8"><img src="#path#pics/p_bottonleft.gif" width="8"></td>
			<td width="100%" class="tablebotton"><img src="#path#pics/p_spacer.gif"></td>
			<td width="42"><img src="#path#pics/p_bottonright.gif" width="42"></td>
		</tr>
	</table>
	
	<cfif not IsDefined('url.curdoc')>
	</td></tr>
	</table>
	</cfif>

</cfif>

</cfoutput>
</body>
</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>