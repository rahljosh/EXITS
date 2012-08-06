<!--- This is used to set the relative directory, print_application.cfm sets this to an empty string --->
<cfparam name="relative" default="../">
<cfif LEN(URL.curdoc)>
	<cfset relative = "">
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" <cfoutput>href="#relative#app.css"</cfoutput>>	
</head>
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif>>

<cfinclude template="../querys/get_student_info.cfm">

<cfset doc = 'page16'>

<cfswitch expression="#get_student_info.sex#">

	<cfcase value="male">
		<cfset sd='son'>
        <cfset hs='he'>
        <cfset hh='his'>
    </cfcase>
    
    <cfcase value="female">
		<cfset sd='daughter'>
        <cfset hs='she'>
        <cfset hh='her'>
    </cfcase>
    
    <cfdefaultcase>
		<cfset sd='son/daughter'>
        <cfset hs='he/she'>
        <cfset hh='his/her'>
    </cfdefaultcase>

</cfswitch>

<cfoutput>

<!--- PRINT ATTACHED FILE INSTEAD OF PAGE --->
<cfif NOT LEN(URL.curdoc)>
	<cfinclude template="../print_include_file.cfm">
<cfelse>
	<cfset printpage = 'yes'>	
</cfif>

<!--- PRINT PAGE IF THERE IS NO ATTACHED FILE OR FILE IS PDF OR DOC --->
<cfif printpage EQ 'yes'>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0 > 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#relative#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#relative#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [16] - Liability Release</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page16print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#relative#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<!--- CHECK IF FILE HAS BEEN UPLOADED --->
<cfif LEN(URL.curdoc)>
	<cfinclude template="../check_upl_print_file.cfm">
</cfif>

<table width="660" border=0 cellpadding=1 cellspacing=0 align="center">
	<tr>
		<td width="110"><em>Student's Name</em></td>
		<td width="560">#get_student_info.firstname# #get_student_info.familylastname#<br><img src="#relative#pics/line.gif" width="520" height="1" border="0" align="absmiddle"></td>
	</tr>
</table><br>

<table width="660" border=0 cellpadding=2 cellspacing=0 align="center">
	<tr><td>&nbsp;</td></tr>
	<tr><td><div align="justify"><cfinclude template="page16text.cfm"></div></td></tr>
</table><br>

<table width="660" border=0 cellpadding=0 cellspacing=0 align="center">
	<tr>
		<td width="210"><br><img src="#relative#pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
		<td width="5"></td>
		<td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="#relative#pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>		
		<td width="40"></td>
		<td width="210"><br><img src="#relative#pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
		<td width="5"></td>
		<td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="#relative#pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>
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
</table><br><br>
</div>

<!--- FOOTER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="8">
		<td width="8"><img src="#relative#pics/p_bottonleft.gif" width="8"></td>
		<td width="100%" class="tablebotton"><img src="#relative#pics/p_spacer.gif"></td>
		<td width="42"><img src="#relative#pics/p_bottonright.gif" width="42"></td>
	</tr>
</table>

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
</cfif>

</cfif>

</cfoutput>
</body>
</html>