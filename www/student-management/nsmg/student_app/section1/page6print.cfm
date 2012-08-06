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
<body <cfif NOT LEN(URL.curdoc)>onLoad="print()"</cfif> >
<cfif isDefined('url.uniqueid')>
	<cfquery name="get_stu_id3" datasource="mysql">
    select studentid 
    from smg_students
    where uniqueid = '#url.uniqueid#'
    </cfquery>
    <cfset client.studentid = #get_stu_id3.studentid#>
</cfif>
<cfif IsDefined('url.studentid')>
	<cfset client.studentid = '#url.studentid#'>
</cfif>

<cfinclude template="../querys/get_student_info.cfm">

<cfoutput query="get_student_info">

<cfset doc = 'parents'>

<cfif NOT LEN(URL.curdoc)>
<table align="center" width=90% cellpadding=0 cellspacing=0  border=0> 
<tr><td>
</cfif>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="#relative#pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="#relative#pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [06] - Parents Letter of Introduction</h2></td>
		<cfif LEN(URL.curdoc)>
		<td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section1/page6print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
		<td width="42" class="tableside"><img src="#relative#pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<!--- show print page instead of regular page --->
<cfif LEN(URL.curdoc)>
	<cfinclude template="../check_upl_print_letter.cfm">
</cfif>

<table width="660" border="0" cellpadding="1" cellspacing="0" align="center">	
	<tr><td width="5">&nbsp;</td>
	<tr><td colspan="3">
			<em>Please <b>type a letter in English</b> in the space below to the host parents who will share their home with your son or daughter.
			Describe your child's personality and interests, expectations and relationships.  We ask that you be very frank and honest in your letter,
			and that you comment on your child's strength and weaknesses. This will be very helpful to us in finding the best host family for your child.</em><br>
		</td></tr>
		<td width="5">&nbsp;</td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td width="5">&nbsp;</td>
		<td width="660"><div align="justify">#get_student_info.familyletter#<br><img src="#relative#pics/line.gif" width="650" height="1" border="0" align="absmiddle"></div></td>
		<td width="5">&nbsp;</td>
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

</cfoutput>

<cfif NOT LEN(URL.curdoc)>
</td></tr>
</table>
<cfinclude template="../print_include_letter.cfm">
</cfif>

</body>
</html>